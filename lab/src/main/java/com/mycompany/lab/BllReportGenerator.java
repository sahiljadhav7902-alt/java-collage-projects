package com.mycompany.lab;

import java.sql.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

public class BllReportGenerator {

    // --- 1. ANALYTICS / DASHBOARD DATA ---

    // Simple inner class to hold dashboard counts
    public static class DashboardStats {
        public int totalPatients;
        public int totalPhysicians;
        public int totalOrders;
        public int pendingOrders;
        public double totalRevenue; // Paid
        public double pendingRevenue; // Pending
        public int lowStockItems;
    }

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            stmt = con.createStatement();

            // 1. Counts
            rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE user_type='patient'");
            if (rs.next()) stats.totalPatients = rs.getInt(1);

            rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE user_type='physician'");
            if (rs.next()) stats.totalPhysicians = rs.getInt(1);

            rs = stmt.executeQuery("SELECT COUNT(*) FROM orders");
            if (rs.next()) stats.totalOrders = rs.getInt(1);

            rs = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status='Ordered'");
            if (rs.next()) stats.pendingOrders = rs.getInt(1);

            // 2. Financials
            rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM billing WHERE payment_status='Paid'");
            if (rs.next()) stats.totalRevenue = rs.getDouble(1);

            rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM billing WHERE payment_status='Pending'");
            if (rs.next()) stats.pendingRevenue = rs.getDouble(1);

            // 3. Inventory
            rs = stmt.executeQuery("SELECT COUNT(*) FROM inventory WHERE quantity < 10");
            if (rs.next()) stats.lowStockItems = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return stats;
    }

    // --- 2. DATA EXPORT METHODS (Returns Lists of String Arrays for CSV) ---

    // Export: Patients
    public List<String[]> getPatientData() {
        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"ID", "Name", "Email", "Phone", "MRN", "DOB"}); // Header
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DataAccess.getConnection();
            String sql = "SELECT user_id, CONCAT(first_name, ' ', last_name), email, phone, mrn, date_of_birth FROM users WHERE user_type='patient'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                data.add(new String[]{
                    rs.getString(1), rs.getString(2), rs.getString(3), 
                    rs.getString(4), rs.getString(5), rs.getString(6)
                });
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { /* close resources */ try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){} }
        return data;
    }

    // Export: Orders
    public List<String[]> getOrderData() {
        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"Order ID", "Patient Name", "Date", "Status", "Test Names"}); // Header
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DataAccess.getConnection();
            // Note: GROUP_CONCAT might not work in all DBs, using simplified join for export
            String sql = "SELECT o.order_id, CONCAT(p.first_name, ' ', p.last_name), o.order_date, o.status, " +
                         "(SELECT GROUP_CONCAT(t.test_name) FROM order_tests ot JOIN tests t ON ot.test_id=t.test_id WHERE ot.order_id=o.order_id) as tests " +
                         "FROM orders o JOIN users p ON o.patient_id = p.user_id";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                data.add(new String[]{
                    rs.getString(1), rs.getString(2), rs.getString(3), 
                    rs.getString(4), (rs.getString(5)!=null) ? rs.getString(5) : ""
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { /* close resources */ try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){} }
        return data;
    }

    // Export: Billing
    public List<String[]> getBillingData() {
        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"Bill ID", "Order ID", "Amount", "Status", "CPT Code"}); // Header
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DataAccess.getConnection();
            String sql = "SELECT bill_id, order_id, amount, payment_status, cpt_code FROM billing";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                data.add(new String[]{
                    rs.getString(1), rs.getString(2), rs.getString(3), 
                    rs.getString(4), rs.getString(5)
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { /* close resources */ try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){} }
        return data;
    }

    // Export: Inventory
    public List<String[]> getInventoryData() {
        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"Item Name", "Lab", "Lot Number", "Quantity", "Expiry"}); // Header
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DataAccess.getConnection();
            String sql = "SELECT i.item_name, l.lab_name, i.lot_number, i.quantity, i.expiry_date " +
                         "FROM inventory i JOIN laboratories l ON i.lab_id = l.lab_id";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                data.add(new String[]{
                    rs.getString(1), rs.getString(2), rs.getString(3), 
                    rs.getString(4), rs.getString(5)
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { /* close resources */ try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){} }
        return data;
    }
    
        // ... [Keep your existing methods] ...

    // Inner class for a Complete Lab Report
    public static class FullReportData {
        public String labName = "Pathology Lab Information System";
        public String reportDate;
        
        // Patient Info
        public String patientName;
        public String patientDob;
        public String patientGender;
        public String mrn;
        
        // Order Info
        public int orderId;
        public String orderDate;
        public String diagnosis;
        
        // Physician Info
        public String physicianName;
        
        // Results List (Multiple rows for one order)
        public List<ResultRow> resultRows;
        
        public static class ResultRow {
            public String testName;
            public String resultValue;
            public String unit;
            public String refRange;
            public String flag;
        }
    }

    // ✅ GENERATE FULL REPORT DATA (For PDF/Print View)
   public FullReportData generateReport(int resultId) {

    FullReportData report = new FullReportData();

    try (Connection con = DataAccess.getConnection()) {

        // ===============================
        // 1️⃣ Get Order ID from Result
        // ===============================
        String sqlOrder =
            "SELECT ot.order_id " +
            "FROM results r " +
            "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
            "WHERE r.result_id = ?";

        PreparedStatement ps = con.prepareStatement(sqlOrder);
        ps.setInt(1, resultId);
        ResultSet rs = ps.executeQuery();

        if (!rs.next()) {
            System.out.println("No order found for result_id = " + resultId);
            return null;
        }

        int orderId = rs.getInt("order_id");
        report.orderId = orderId;


        // ===============================
        // 2️⃣ Fetch Patient + Physician + Diagnosis + Order Info
        // ===============================
        String sqlDetails =
            "SELECT o.order_date, " +
            "p.first_name AS patient_fname, p.last_name AS patient_lname, " +
            "p.gender, p.date_of_birth, p.mrn, " +
            "ph.first_name AS phy_fname, ph.last_name AS phy_lname, " +
            "d.description AS diagnosis " +
            "FROM orders o " +
            "JOIN users p ON o.patient_id = p.user_id " +
            "LEFT JOIN users ph ON o.physician_id = ph.user_id " +
            "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
            "WHERE o.order_id = ?";

        ps = con.prepareStatement(sqlDetails);
        ps.setInt(1, orderId);
        rs = ps.executeQuery();

        if (rs.next()) {

            report.patientName =
                rs.getString("patient_fname") + " " +
                rs.getString("patient_lname");

            report.patientGender = rs.getString("gender");
            report.patientDob = rs.getString("date_of_birth");
            report.mrn = rs.getString("mrn");

            report.physicianName =
                rs.getString("phy_fname") + " " +
                rs.getString("phy_lname");

            report.diagnosis = rs.getString("diagnosis");
            report.orderDate = rs.getString("order_date");
            report.reportDate = java.time.LocalDateTime.now().toString();
        }


        // ===============================
        // 3️⃣ Fetch All Test Results for That Order
        // ===============================
        String sqlResults =
            "SELECT t.test_name, r.result_value, r.unit, " +
            "r.reference_range, r.abnormal_flag " +
            "FROM results r " +
            "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
            "JOIN tests t ON ot.test_id = t.test_id " +
            "WHERE ot.order_id = ?";

        ps = con.prepareStatement(sqlResults);
        ps.setInt(1, orderId);
        rs = ps.executeQuery();

        List<FullReportData.ResultRow> rows = new ArrayList<>();

        while (rs.next()) {

            FullReportData.ResultRow row =
                new FullReportData.ResultRow();

            row.testName = rs.getString("test_name");
            row.resultValue = rs.getString("result_value");
            row.unit = rs.getString("unit");
            row.refRange = rs.getString("reference_range");
            row.flag = rs.getString("abnormal_flag");

            rows.add(row);
        }

        report.resultRows = rows;

        // ===============================
        // 4️⃣ Lab Name (Static for now)
        // ===============================
        report.labName = "Pathology Lab Information System";

        return report;

    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
}
        // ... [Keep your existing code] ...

    /**
     * GENERATE SECURE REPORT FOR PATIENT
     * Verifies that the result_id belongs to the logged-in patient before returning data.
     */
    public FullReportData generatePatientReport(int resultId, int sessionPatientId) {
        FullReportData report = new FullReportData();
        report.resultRows = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DataAccess.getConnection();
            
            // 1. Find Order ID
            int orderId = -1;
            String sqlFindOrder = "SELECT order_id FROM results WHERE result_id=?";
            ps = con.prepareStatement(sqlFindOrder);
            ps.setInt(1, resultId);
            rs = ps.executeQuery();
            if(rs.next()) {
                orderId = rs.getInt("order_id");
            }
            if(orderId == -1) return null; 
            
            // 2. Fetch Details (SECURE: Added AND o.patient_id = ?)
            String sqlOrder = "SELECT o.order_id, o.order_date, d.description AS diagnosis, " +
                              "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.dob, p.gender, p.mrn, " +
                              "CONCAT(ph.first_name, ' ', ph.last_name) AS physician_name " +
                              "FROM orders o " +
                              "JOIN users p ON o.patient_id = p.user_id " +
                              "LEFT JOIN users ph ON o.physician_id = ph.user_id " +
                              "LEFT JOIN diagnoses d ON o.diagnosis_id = d.diagnosis_id " +
                              "WHERE o.order_id = ? AND o.patient_id = ?"; // SECURITY CHECK
            
            ps = con.prepareStatement(sqlOrder);
            ps.setInt(1, orderId);
            ps.setInt(2, sessionPatientId);
            rs = ps.executeQuery();
            
            if(rs.next()) {
                report.orderId = rs.getInt("order_id");
                report.orderDate = rs.getString("order_date");
                report.diagnosis = rs.getString("diagnosis");
                report.patientName = rs.getString("patient_name");
                report.patientDob = rs.getString("dob");
                report.patientGender = rs.getString("gender");
                report.mrn = rs.getString("mrn");
                report.physicianName = rs.getString("physician_name");
            } else {
                // If no rows returned, it means the order doesn't belong to this patient
                return null; 
            }
            
            // 3. Fetch Results
            String sqlResults = "SELECT t.test_name, r.result_value, r.unit, r.reference_range, r.abnormal_flag " +
                                "FROM results r " +
                                "JOIN order_tests ot ON r.order_test_id = ot.order_test_id " +
                                "JOIN tests t ON ot.test_id = t.test_id " +
                                "WHERE ot.order_id = ?";
            
            ps = con.prepareStatement(sqlResults);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            
            while(rs.next()) {
                FullReportData.ResultRow row = new FullReportData.ResultRow();
                row.testName = rs.getString("test_name");
                row.resultValue = rs.getString("result_value");
                row.unit = rs.getString("unit");
                row.refRange = rs.getString("reference_range");
                row.flag = rs.getString("abnormal_flag");
                report.resultRows.add(row);
            }
            
            report.reportDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return report;
    }
}