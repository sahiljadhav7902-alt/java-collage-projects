package com.mycompany.lab;

import java.sql.*;
import java.util.*;

public class BllOrder {

    // =====================================================
    // INNER CLASSES (Data Models)
    // =====================================================

    // 1. Admin Order Info
    public static class OrderInfo {
        public int orderId;
        public String orderDate;
        public String status;
        public String patientName;
        public String physicianName;
        public String diagnosis;
        public String tests; 
    }

    // 2. Doctor Dashboard Stats
    public static class DoctorStats {
        public int totalPatients;
        public int activeOrders;
        public int completedOrders;
        public int pendingResults;
    }

    // 3. Doctor Order Info (My Orders)
    public static class DoctorOrderInfo {
        public int orderId;
        public String patientName;
        public String orderDate;
        public String status;
        public String tests; // Used for Diagnosis in "My Orders" view
    }


    // =====================================================
    // ADMIN METHODS
    // =====================================================

    // ✅ GET ALL ORDERS (Admin)
    public List<OrderInfo> getAllOrders() {
        List<OrderInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            String sql = "SELECT o.order_id, o.order_date, o.status, " +
                         "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                         "CONCAT(ph.first_name, ' ', ph.last_name) AS physician_name, " +
                         "d.description AS diagnosis, " +
                         "GROUP_CONCAT(t.test_name SEPARATOR ', ') AS tests " +
                         "FROM orders o " +
                         "JOIN users p ON o.patient_id = p.user_id " +
                         "LEFT JOIN users ph ON o.physician_id = ph.user_id " +
                         "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
                         "JOIN order_tests ot ON o.order_id = ot.order_id " +
                         "JOIN tests t ON ot.test_id = t.test_id " +
                         "GROUP BY o.order_id " +
                         "ORDER BY o.order_date DESC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderInfo info = new OrderInfo();
                info.orderId = rs.getInt("order_id");
                info.orderDate = rs.getString("order_date");
                info.status = rs.getString("status");
                info.patientName = rs.getString("patient_name");
                info.physicianName = rs.getString("physician_name");
                info.diagnosis = rs.getString("diagnosis");
                info.tests = rs.getString("tests");
                list.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // ✅ GET ORDER BY ID (Admin)
    public OrderInfo getOrderById(int id) {
        OrderInfo info = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            String sql = "SELECT o.order_id, o.order_date, o.status, " +
                         "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                         "CONCAT(ph.first_name, ' ', ph.last_name) AS physician_name, " +
                         "d.description AS diagnosis, " +
                         "GROUP_CONCAT(t.test_name SEPARATOR ', ') AS tests " +
                         "FROM orders o " +
                         "JOIN users p ON o.patient_id = p.user_id " +
                         "LEFT JOIN users ph ON o.physician_id = ph.user_id " +
                         "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
                         "JOIN order_tests ot ON o.order_id = ot.order_id " +
                         "JOIN tests t ON ot.test_id = t.test_id " +
                         "WHERE o.order_id = ? " +
                         "GROUP BY o.order_id";

            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                info = new OrderInfo();
                info.orderId = rs.getInt("order_id");
                info.orderDate = rs.getString("order_date");
                info.status = rs.getString("status");
                info.patientName = rs.getString("patient_name");
                info.physicianName = rs.getString("physician_name");
                info.diagnosis = rs.getString("diagnosis");
                info.tests = rs.getString("tests");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return info;
    }

    // ✅ UPDATE ORDER STATUS (Admin)
    public String updateOrderStatus(int orderId, String status) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "UPDATE orders SET status=? WHERE order_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Order status updated successfully.";
            return "Order not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }


    // =====================================================
    // DOCTOR DASHBOARD METHODS
    // =====================================================

    // ✅ GET DOCTOR STATS
    public DoctorStats getDoctorStats(int physicianId) {
        DoctorStats stats = new DoctorStats();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            
            // 1. Active/Pending Orders
            String sqlActive = "SELECT COUNT(*) FROM orders WHERE physician_id=? AND status IN ('Ordered', 'Collected', 'Processing')";
            ps = con.prepareStatement(sqlActive);
            ps.setInt(1, physicianId);
            rs = ps.executeQuery();
            if (rs.next()) stats.activeOrders = rs.getInt(1);
            
            // 2. Completed Orders
            String sqlCompleted = "SELECT COUNT(*) FROM orders WHERE physician_id=? AND status='Completed'";
            ps = con.prepareStatement(sqlCompleted);
            ps.setInt(1, physicianId);
            rs = ps.executeQuery();
            if (rs.next()) stats.completedOrders = rs.getInt(1);

            // 3. Total Patients
            String sqlPatients = "SELECT COUNT(DISTINCT patient_id) FROM orders WHERE physician_id=?";
            ps = con.prepareStatement(sqlPatients);
            ps.setInt(1, physicianId);
            rs = ps.executeQuery();
            if (rs.next()) stats.totalPatients = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return stats;
    }

    // ✅ GET DOCTOR RECENT ORDERS (Dashboard)
    public List<DoctorOrderInfo> getDoctorRecentOrders(int physicianId) {
        List<DoctorOrderInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            String sql = "SELECT o.order_id, o.order_date, o.status, " +
                         "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                         "GROUP_CONCAT(t.test_name SEPARATOR ', ') AS tests " +
                         "FROM orders o " +
                         "JOIN users p ON o.patient_id = p.user_id " +
                         "JOIN order_tests ot ON o.order_id = ot.order_id " +
                         "JOIN tests t ON ot.test_id = t.test_id " +
                         "WHERE o.physician_id = ? " +
                         "GROUP BY o.order_id " +
                         "ORDER BY o.order_date DESC " +
                         "LIMIT 10";

            ps = con.prepareStatement(sql);
            ps.setInt(1, physicianId);
            rs = ps.executeQuery();

            while (rs.next()) {
                DoctorOrderInfo info = new DoctorOrderInfo();
                info.orderId = rs.getInt("order_id");
                info.patientName = rs.getString("patient_name");
                info.orderDate = rs.getString("order_date");
                info.status = rs.getString("status");
                info.tests = rs.getString("tests");
                list.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // ✅ GET ORDERS BY PHYSICIAN (My Orders Page)
    public List<DoctorOrderInfo> getOrdersByPhysician(int physicianId) {
        List<DoctorOrderInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            String sql = "SELECT o.order_id, o.order_date, o.status, " +
                         "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                         "d.description AS diagnosis " +
                         "FROM orders o " +
                         "JOIN users p ON o.patient_id = p.user_id " +
                         "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
                         "WHERE o.physician_id = ? " +
                         "ORDER BY o.order_date DESC";

            ps = con.prepareStatement(sql);
            ps.setInt(1, physicianId);
            rs = ps.executeQuery();

            while (rs.next()) {
                DoctorOrderInfo info = new DoctorOrderInfo();
                info.orderId = rs.getInt("order_id");
                info.patientName = rs.getString("patient_name");
                info.orderDate = rs.getString("order_date");
                info.status = rs.getString("status");
                info.tests = rs.getString("diagnosis"); // Reusing 'tests' field for Diagnosis to save creating a new class
                list.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }


    // =====================================================
    // CREATE & MANAGE ORDER METHODS
    // =====================================================

    // ✅ CREATE ORDER (Header Only)
    public int createOrder(int patientId, int physicianId, int diagnosisId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int newOrderId = -1;

        try {
            con = DataAccess.getConnection();
            if (con == null) return -1;

            String sql = "INSERT INTO orders (patient_id, physician_id, diagnosis_id, status) VALUES (?, ?, ?, 'Ordered')";
            ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setInt(1, patientId);
            ps.setInt(2, physicianId);
            ps.setInt(3, diagnosisId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    newOrderId = rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return newOrderId;
    }
// ✅ HELPER: Get Physician Name
public String getPhysicianName(int physicianId) {

    String name = "Unknown Doctor";

    try (Connection con = DataAccess.getConnection()) {

        String sql = "SELECT CONCAT(first_name, ' ', last_name) AS name " +
                     "FROM users WHERE user_id=? AND user_type='physician'";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, physicianId);

        ResultSet rs = ps.executeQuery();

        if (rs.next() && rs.getString("name") != null) {
            name = rs.getString("name");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return name;
}

    // ✅ HELPER: Get All Diagnoses
    public Map<Integer, String> getAllDiagnoses() {
        Map<Integer, String> map = new LinkedHashMap<>(); 
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DataAccess.getConnection();
            String sql = "SELECT diagnosis_id, icd10_code, description FROM diagnoses ORDER BY icd10_code ASC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("diagnosis_id");
                String code = rs.getString("icd10_code");
                String desc = rs.getString("description");
                map.put(id, code + " - " + desc);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { try{if(rs!=null)rs.close();if(ps!=null)ps.close();if(con!=null)con.close();}catch(Exception e){} }
        return map;
    }

    // ✅ GET TEST IDs FOR ORDER
    public List<Integer> getTestIdsForOrder(int orderId) {
        List<Integer> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            String sql = "SELECT test_id FROM order_tests WHERE order_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getInt("test_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    // ✅ UPDATE ORDER TESTS (Save selections)
    public String updateOrderTests(int orderId, String[] testIds) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            con.setAutoCommit(false);

            String deleteSql = "DELETE FROM order_tests WHERE order_id=?";
            ps = con.prepareStatement(deleteSql);
            ps.setInt(1, orderId);
            ps.executeUpdate();
            ps.close(); 

            if (testIds != null && testIds.length > 0) {
                String insertSql = "INSERT INTO order_tests (order_id, test_id) VALUES (?, ?)";
                ps = con.prepareStatement(insertSql);
                
                for (String tid : testIds) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, Integer.parseInt(tid));
                    ps.addBatch(); 
                }
                ps.executeBatch(); 
            }

            con.commit();
            return "Tests updated successfully.";

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (con != null) con.setAutoCommit(true); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
    
     
    // =====================================================
    // HISTORY METHODS
    // =====================================================

    // Inner class for History View
    public static class HistoryItem {
        public int orderId;
        public String patientName;
        public String orderDate;
        public String diagnosis;
        public int sampleResultId; // Used to link to the full report
    }

    // ✅ GET COMPLETED ORDERS FOR HISTORY
    public List<HistoryItem> getCompletedOrdersForHistory(int physicianId) {
        List<HistoryItem> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            // Select orders that are Completed AND have at least one result entry
            String sql = "SELECT o.order_id, o.order_date, d.description AS diagnosis, " +
                         "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                         "MIN(r.result_id) AS sample_result_id " + // Get one result ID to generate the report link
                         "FROM orders o " +
                         "JOIN users p ON o.patient_id = p.user_id " +
                         "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
                         "JOIN order_tests ot ON o.order_id = ot.order_id " +
                         "JOIN results r ON ot.order_test_id = r.order_test_id " + // Ensure results exist
                         "WHERE o.physician_id = ? AND o.status = 'Completed' " +
                         "GROUP BY o.order_id " +
                         "ORDER BY o.order_date DESC";

            ps = con.prepareStatement(sql);
            ps.setInt(1, physicianId);
            rs = ps.executeQuery();

            while (rs.next()) {
                HistoryItem item = new HistoryItem();
                item.orderId = rs.getInt("order_id");
                item.patientName = rs.getString("patient_name");
                item.orderDate = rs.getString("order_date");
                item.diagnosis = rs.getString("diagnosis");
                item.sampleResultId = rs.getInt("sample_result_id");
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }
    
        // ... [Keep your existing code] ...

    // =====================================================
    // PATIENT ORDER HISTORY METHODS
    // =====================================================

    // Inner class for Patient Order Details
    public static class PatientOrderDetail {
        public int orderId;
        public String orderDate;
        public String status;
        public String physicianName;
        public String diagnosis;
        public String tests;
    }

    // ✅ GET ORDERS BY PATIENT (Full History)
    public List<PatientOrderDetail> getPatientOrders(int patientId) {
        List<PatientOrderDetail> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            String sql = "SELECT o.order_id, o.order_date, o.status, " +
                         "CONCAT(ph.first_name, ' ', ph.last_name) AS physician_name, " +
                         "d.description AS diagnosis, " +
                         "GROUP_CONCAT(t.test_name SEPARATOR ', ') AS tests " +
                         "FROM orders o " +
                         "JOIN users ph ON o.physician_id = ph.user_id " +
                         "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
                         "JOIN order_tests ot ON o.order_id = ot.order_id " +
                         "JOIN tests t ON ot.test_id = t.test_id " +
                         "WHERE o.patient_id = ? " +
                         "GROUP BY o.order_id " +
                         "ORDER BY o.order_date DESC";

            ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();

            while (rs.next()) {
                PatientOrderDetail detail = new PatientOrderDetail();
                detail.orderId = rs.getInt("order_id");
                detail.orderDate = rs.getString("order_date");
                detail.status = rs.getString("status");
                detail.physicianName = rs.getString("physician_name");
                detail.diagnosis = rs.getString("diagnosis");
                detail.tests = rs.getString("tests");
                list.add(detail);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }
    
    
}