package com.mycompany.lab;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BllBilling {

    // Inner class to hold Billing details
    public static class BillInfo {
        public int billId;
        public int orderId;
        public String patientName;
        public String cptCode;
        public double amount;
        public String paymentStatus;
    }

    // ✅ GET ALL BILLS (With Join to Order/Patient)
    public List<BillInfo> getAllBills() {
        List<BillInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            // Join Billing -> Order -> Patient
            String sql = "SELECT b.bill_id, b.order_id, b.cpt_code, b.amount, b.payment_status, " +
                         "CONCAT(u.first_name, ' ', u.last_name) AS patient_name " +
                         "FROM billing b " +
                         "JOIN orders o ON b.order_id = o.order_id " +
                         "JOIN users u ON o.patient_id = u.user_id " +
                         "ORDER BY b.bill_id DESC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BillInfo info = new BillInfo();
                info.billId = rs.getInt("bill_id");
                info.orderId = rs.getInt("order_id");
                info.patientName = rs.getString("patient_name");
                info.cptCode = rs.getString("cpt_code");
                info.amount = rs.getDouble("amount");
                info.paymentStatus = rs.getString("payment_status");
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

    // ✅ GET BILL BY ID (For Edit)
    public BillInfo getBillById(int id) {
        BillInfo info = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            String sql = "SELECT * FROM billing WHERE bill_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                info = new BillInfo();
                info.billId = rs.getInt("bill_id");
                info.orderId = rs.getInt("order_id");
                info.cptCode = rs.getString("cpt_code");
                info.amount = rs.getDouble("amount");
                info.paymentStatus = rs.getString("payment_status");
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

    // ✅ ADD BILL
    public String addBill(int orderId, String cptCode, double amount, String paymentStatus) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "INSERT INTO billing (order_id, cpt_code, amount, payment_status) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ps.setString(2, cptCode);
            ps.setDouble(3, amount);
            ps.setString(4, paymentStatus);

            int rows = ps.executeUpdate();
            if (rows > 0) return "Bill added successfully.";
            return "Failed to add bill.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ UPDATE BILL (Track Payment)
    public String updateBill(int billId, int orderId, String cptCode, double amount, String paymentStatus) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "UPDATE billing SET order_id=?, cpt_code=?, amount=?, payment_status=? WHERE bill_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ps.setString(2, cptCode);
            ps.setDouble(3, amount);
            ps.setString(4, paymentStatus);
            ps.setInt(5, billId);

            int rows = ps.executeUpdate();
            if (rows > 0) return "Bill updated successfully.";
            return "Bill not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ DELETE BILL
    public String deleteBill(int billId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "DELETE FROM billing WHERE bill_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, billId);

            int rows = ps.executeUpdate();
            if (rows > 0) return "Bill deleted successfully.";
            return "Bill not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
    
        // ... [Keep your existing code: BillInfo, getAllBills, getBillById, addBill, updateBill, deleteBill] ...

    // =====================================================
    // PATIENT BILLING METHODS
    // =====================================================

    // Inner class for Patient Bill Details
    public static class PatientBillInfo {
        public int billId;
        public int orderId;
        public String orderDate;
        public String cptCode;
        public double amount;
        public String paymentStatus;
    }

    // ✅ GET BILLS BY PATIENT
    public List<PatientBillInfo> getBillsByPatient(int patientId) {
        List<PatientBillInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            // Join Billing with Orders
            String sql = "SELECT b.bill_id, b.order_id, b.cpt_code, b.amount, b.payment_status, o.order_date " +
                         "FROM billing b " +
                         "JOIN orders o ON b.order_id = o.order_id " +
                         "WHERE o.patient_id = ? " +
                         "ORDER BY o.order_date DESC";

            ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();

            while (rs.next()) {
                PatientBillInfo info = new PatientBillInfo();
                info.billId = rs.getInt("bill_id");
                info.orderId = rs.getInt("order_id");
                info.orderDate = rs.getString("order_date");
                info.cptCode = rs.getString("cpt_code");
                info.amount = rs.getDouble("amount");
                info.paymentStatus = rs.getString("payment_status");
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
// MARK BILL AS PAID (DUMMY ONLINE PAYMENT)
// =====================================================
public String markBillAsPaid(int billId) {

    try (Connection con = DataAccess.getConnection()) {

        String sql = 
            "UPDATE billing SET payment_status='Paid' WHERE bill_id=?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, billId);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            return "SUCCESS: Payment completed.";
        } else {
            return "Bill not found.";
        }

    } catch (Exception e) {
        e.printStackTrace();
        return "Error: " + e.getMessage();
    }
}

// =====================================================
// GET TOTAL OUTSTANDING AMOUNT (FIXED VERSION)
// =====================================================
public double getTotalOutstanding(int patientId) {

    double total = 0;

    try (Connection con = DataAccess.getConnection()) {

        String sql =
            "SELECT SUM(b.amount) AS total " +
            "FROM billing b " +
            "JOIN orders o ON b.order_id = o.order_id " +
            "WHERE o.patient_id=? " +
            "AND b.payment_status IN ('Pending','Denied')";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, patientId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            total = rs.getDouble("total");
            if (rs.wasNull()) total = 0;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return total;
}
}