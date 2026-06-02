package com.mycompany.lab;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BllResult {

    // =====================================================
    // INNER CLASS
    // =====================================================
    public static class ResultInfo {
        public int resultId;
        public int orderId;
        public int orderTestId;
        public String testName;
        public String patientName;
        public String resultValue;
        public String unit;
        public String referenceRange;
        public String abnormalFlag;
        public String resultStatus;
        public String validatedAt;
        public String orderDate; 
    }

    // =====================================================
    // GET ALL RESULTS (ADMIN PANEL)
    // =====================================================
    public List<ResultInfo> getAllResults() {

        List<ResultInfo> list = new ArrayList<>();

        try (Connection con = DataAccess.getConnection()) {

            String sql =
                    "SELECT r.result_id, r.order_test_id, r.result_value, r.unit, " +
                    "r.reference_range, r.abnormal_flag, r.result_status, r.validated_at, " +
                    "t.test_name, o.order_id, " +
                    "CONCAT(p.first_name,' ',p.last_name) AS patient_name " +
                    "FROM results r " +
                    "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
                    "JOIN tests t ON ot.test_id = t.test_id " +
                    "JOIN orders o ON ot.order_id = o.order_id " +
                    "JOIN users p ON o.patient_id = p.user_id " +
                    "ORDER BY r.result_id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ResultInfo info = new ResultInfo();
                info.resultId = rs.getInt("result_id");
                info.orderTestId = rs.getInt("order_test_id");
                info.orderId = rs.getInt("order_id");
                info.testName = rs.getString("test_name");
                info.patientName = rs.getString("patient_name");
                info.resultValue = rs.getString("result_value");
                info.unit = rs.getString("unit");
                info.referenceRange = rs.getString("reference_range");
                info.abnormalFlag = rs.getString("abnormal_flag");
                info.resultStatus = rs.getString("result_status");
                info.validatedAt = rs.getString("validated_at");
                list.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

  // =====================================================
// INSERT RESULT (FINAL VERSION)
// =====================================================
public String insertResult(int orderId, int orderTestId,
                           String resultValue, String unit,
                           String refRange, String abnormalFlag,
                           String resultStatus) {

    // 🔎 Basic validation
    if (orderTestId <= 0) {
        return "ERROR: Invalid Order Test ID.";
    }

    if (resultValue == null || resultValue.trim().isEmpty()) {
        return "ERROR: Result value cannot be empty.";
    }

    try (Connection con = DataAccess.getConnection()) {

        if (con == null) {
            return "ERROR: Database connection failed.";
        }

        // ✅ Check if result already exists for this test
        String checkSql = "SELECT result_id FROM results WHERE order_test_id=?";
        PreparedStatement checkPs = con.prepareStatement(checkSql);
        checkPs.setInt(1, orderTestId);
        ResultSet rs = checkPs.executeQuery();

        if (rs.next()) {
            return "ERROR: Result already exists for this test.";
        }

        // ✅ Insert result
        String sql =
                "INSERT INTO results " +
                "(order_test_id, result_value, unit, reference_range, abnormal_flag, result_status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, orderTestId);
        ps.setString(2, resultValue);
        ps.setString(3, unit);
        ps.setString(4, refRange);
        ps.setString(5, abnormalFlag);
        ps.setString(6, resultStatus);

        int rows = ps.executeUpdate();

        if (rows > 0) {

            // 🔥 Optional workflow update
            try {
                BllSpecimen specimen = new BllSpecimen();
                specimen.updateSpecimenStatusByOrder(orderId, "Preliminary");
            } catch (Exception e) {
                System.out.println("Specimen status update failed: " + e.getMessage());
            }

            return "SUCCESS: Result inserted successfully.";
        }

        return "ERROR: Insert failed.";

    } catch (Exception e) {
        e.printStackTrace();
        return "ERROR: " + e.getMessage();
    }
}
    // =====================================================
    // VERIFY / UPDATE RESULT (STEP 6)
    // =====================================================
  
public String verifyResult(int resultId,
                           String resultValue,
                           String unit,
                           String referenceRange,
                           String abnormalFlag,
                           String resultStatus) {

    if (resultId <= 0) {
        return "ERROR: Invalid Result ID.";
    }

    try (Connection con = DataAccess.getConnection()) {

        String sql =
                "UPDATE results SET " +
                "result_value=?, " +
                "unit=?, " +
                "reference_range=?, " +
                "abnormal_flag=?, " +
                "result_status=?, " +
                "validated_at = NOW() " +
                "WHERE result_id=?";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, resultValue);
        ps.setString(2, unit);
        ps.setString(3, referenceRange);
        ps.setString(4, abnormalFlag);
        ps.setString(5, resultStatus);
        ps.setInt(6, resultId);

        int rows = ps.executeUpdate();
        
        if (rows > 0) {
            checkAndCompleteOrder(con, resultId);
            return "SUCCESS: Result updated successfully.";
        }

        return "ERROR: Update failed.";

    } catch (Exception e) {
        e.printStackTrace();
        return "ERROR: " + e.getMessage();
    }
}

    // =====================================================
    // GET RESULTS BY ORDER (STEP 5 ENTRY PAGE)
    // =====================================================
   public List<ResultInfo> getResultsByOrder(int orderId) {

    List<ResultInfo> list = new ArrayList<>();

    try (Connection con = DataAccess.getConnection()) {

        String sql =
            "SELECT ot.order_test_id, t.test_name, " +
            "r.result_id, r.result_value, r.unit, " +
            "r.reference_range, r.abnormal_flag, r.result_status " +
            "FROM order_tests ot " +
            "JOIN tests t ON ot.test_id = t.test_id " +
            "LEFT JOIN results r ON ot.order_test_id = r.order_test_id " +
            "WHERE ot.order_id = ?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, orderId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            ResultInfo ri = new ResultInfo();

            ri.orderTestId = rs.getInt("order_test_id");
            ri.testName = rs.getString("test_name");
            ri.resultId = rs.getInt("result_id");
            ri.resultValue = rs.getString("result_value");
            ri.unit = rs.getString("unit");
            ri.referenceRange = rs.getString("reference_range");
            ri.abnormalFlag = rs.getString("abnormal_flag");
            ri.resultStatus = rs.getString("result_status");

            list.add(ri);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    
    // =====================================================
// GET RESULT BY RESULT_ID
// =====================================================
public ResultInfo getResultById(int resultId) {

    ResultInfo ri = null;

    try (Connection con = DataAccess.getConnection()) {

        String sql =
            "SELECT r.result_id, r.result_value, r.unit, " +
            "r.reference_range, r.abnormal_flag, r.result_status, " +
            "t.test_name, ot.order_id " +
            "FROM results r " +
            "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
            "JOIN tests t ON ot.test_id = t.test_id " +
            "WHERE r.result_id = ?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, resultId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            ri = new ResultInfo();
            ri.resultId = rs.getInt("result_id");
            ri.resultValue = rs.getString("result_value");
            ri.unit = rs.getString("unit");
            ri.referenceRange = rs.getString("reference_range");
            ri.abnormalFlag = rs.getString("abnormal_flag");
            ri.resultStatus = rs.getString("result_status");
            ri.testName = rs.getString("test_name");
            ri.orderId = rs.getInt("order_id");

        } else {
            System.out.println("No result found for result_id = " + resultId);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return ri;
}

public List<ResultInfo> getResultsByPhysician(int physicianId) {

    List<ResultInfo> list = new ArrayList<>();

    try (Connection con = DataAccess.getConnection()) {

        String sql =
            "SELECT r.result_id, r.result_value, r.unit, " +
            "r.reference_range, r.abnormal_flag, r.result_status, " +
            "t.test_name, ot.order_id " +
            "FROM results r " +
            "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
            "JOIN orders o ON ot.order_id = o.order_id " +
            "JOIN tests t ON ot.test_id = t.test_id " +
            "WHERE o.physician_id = ?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, physicianId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            ResultInfo ri = new ResultInfo();
            ri.resultId = rs.getInt("result_id");
            ri.resultValue = rs.getString("result_value");
            ri.unit = rs.getString("unit");
            ri.referenceRange = rs.getString("reference_range");
            ri.abnormalFlag = rs.getString("abnormal_flag");
            ri.resultStatus = rs.getString("result_status");
            ri.testName = rs.getString("test_name");
            ri.orderId = rs.getInt("order_id");
            list.add(ri);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public List<ResultInfo> getFinalizedResultsForPatient(int patientId) {

    List<ResultInfo> list = new ArrayList<>();

    try (Connection con = DataAccess.getConnection()) {

        String sql =
            "SELECT o.order_date, t.test_name, r.result_value, r.unit, " +
            "r.abnormal_flag, r.result_id " +
            "FROM orders o " +
            "JOIN order_tests ot ON o.order_id = ot.order_id " +
            "JOIN results r ON ot.order_test_id = r.order_test_id " +
            "JOIN tests t ON ot.test_id = t.test_id " +
            "WHERE o.patient_id = ? AND r.result_status = 'Final' " +
            "ORDER BY o.order_date DESC";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, patientId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            ResultInfo info = new ResultInfo();

            info.orderDate = rs.getString("order_date");
            info.testName = rs.getString("test_name");
            info.resultValue = rs.getString("result_value");
            info.unit = rs.getString("unit");
            info.abnormalFlag = rs.getString("abnormal_flag");
            info.resultId = rs.getInt("result_id");

            list.add(info);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
// =====================================================
// CHECK IF ALL RESULTS FINAL → COMPLETE ORDER
// =====================================================
private void checkAndCompleteOrder(Connection con, int resultId) throws Exception {

    // 1️⃣ Get order_id from result
    String sql =
        "SELECT o.order_id " +
        "FROM results r " +
        "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
        "JOIN orders o ON ot.order_id = o.order_id " +
        "WHERE r.result_id=?";

    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, resultId);
    ResultSet rs = ps.executeQuery();

    int orderId = 0;
    if (rs.next()) {
        orderId = rs.getInt("order_id");
    }

    // 2️⃣ Check if any result is NOT Final
    String checkSql =
        "SELECT COUNT(*) FROM results r " +
        "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
        "WHERE ot.order_id=? AND r.result_status!='Final'";

    PreparedStatement checkPs = con.prepareStatement(checkSql);
    checkPs.setInt(1, orderId);
    ResultSet checkRs = checkPs.executeQuery();

    if (checkRs.next() && checkRs.getInt(1) == 0) {

        // 3️⃣ All results Final → Complete order
        String updateOrder =
            "UPDATE orders SET status='Completed' WHERE order_id=?";

        PreparedStatement updatePs = con.prepareStatement(updateOrder);
        updatePs.setInt(1, orderId);
        updatePs.executeUpdate();
    }
}
}