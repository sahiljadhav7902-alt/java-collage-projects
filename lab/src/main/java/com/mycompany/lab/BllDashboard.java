package com.mycompany.lab;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BllDashboard {

    private int totalPatients;
    private int pendingOrders;
    private int completedTests;
    private double totalRevenue;
    private int activeUsers;
    private int todayAppointments;
    private int lowStockItems;
    private int recentReports;
    private List<BllUserMaster> recentPatients;

       // --- 2. DOCTOR DASHBOARD METHODS (New) ---

    // Inner class for Doctor Statistics
    public static class DoctorStats {
        public int totalPatients; // Total patients assigned to this doctor (or total in system)
        public int activeOrders;
        public int completedOrders;
        public int pendingResults; // Orders where status is 'Completed' but maybe not viewed (simplified to Completed here)
    }

    // Inner class for Doctor's Recent Orders
    public static class DoctorOrderInfo {
        public int orderId;
        public String patientName;
        public String orderDate;
        public String status;
        public String tests; // Comma separated test names
    }
    
    
    public BllDashboard() {
        this.recentPatients = new ArrayList<>();
    }

    public boolean getCompleteDashboardData() {
        Connection con = null;

        try {
            System.out.println(">>> DASHBOARD: Getting DB connection...");
            con = DataAccess.getConnection();

            if (con == null) {
                System.err.println("!!! DASHBOARD FAILED: DB Connection is NULL");
                return false;
            }

            // 1️⃣ Total Patients
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE user_type = 'patient'")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) totalPatients = rs.getInt(1);
            }

            // 2️⃣ Pending Orders
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM orders WHERE status = 'Ordered'")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) pendingOrders = rs.getInt(1);
            }

            // 3️⃣ Completed Tests
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM results WHERE result_status = 'Final'")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) completedTests = rs.getInt(1);
            }

            // 4️⃣ Total Revenue
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COALESCE(SUM(amount),0) FROM billing WHERE payment_status = 'Paid'")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) totalRevenue = rs.getDouble(1);
            }

            // 5️⃣ Active Users (Fixed)
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE is_active = 1")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) activeUsers = rs.getInt(1);
            }

            // 6️⃣ Today's Appointments
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURDATE()")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) todayAppointments = rs.getInt(1);
            }

            // 7️⃣ Low Stock Items
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM inventory WHERE quantity < 10")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) lowStockItems = rs.getInt(1);
            }

            // 8️⃣ Recent Reports (Fixed to validated_at)
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM results WHERE validated_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) recentReports = rs.getInt(1);
            }

            // 9️⃣ Recent Patients
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM users WHERE user_type = 'patient' ORDER BY created_at DESC LIMIT 5")) {

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    BllUserMaster patient = new BllUserMaster();
                    patient.setUserId(rs.getInt("user_id"));
                    patient.setFirstName(rs.getString("first_name"));
                    patient.setLastName(rs.getString("last_name"));
                    patient.setEmail(rs.getString("email"));
                    patient.setPhone(rs.getString("phone"));

                    recentPatients.add(patient);
                }
            }

            System.out.println(">>> DASHBOARD: Loaded Successfully");
            return true;

        } catch (Exception e) {
            System.err.println("!!! DASHBOARD ERROR:");
            e.printStackTrace();
            return false;

        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

     public DoctorStats getDoctorStats(int physicianId) {
        DoctorStats stats = new DoctorStats();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            
            // 1. Active/Pending Orders (Ordered, Collected, Processing)
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

            // 3. Total Patients (Simple count of unique patients this doctor has ordered for)
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

    // ✅ GET DOCTOR RECENT ORDERS
    public List<DoctorOrderInfo> getDoctorRecentOrders(int physicianId) {
        List<DoctorOrderInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            // Join Orders with Patient and Tests
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
                         "LIMIT 10"; // Limit to last 10 for dashboard

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
    
        // ... [Keep your existing Admin and Doctor methods] ...

    // =====================================================
    // PATIENT DASHBOARD METHODS
    // =====================================================

    // Inner class for Patient Statistics
    public static class PatientStats {
        public int totalOrders;
        public int activeOrders;
        public int completedOrders;
    }

    // Inner class for Patient Recent Orders
    public static class PatientOrderInfo {
        public int orderId;
        public String orderDate;
        public String status;
        public String tests;
    }

    // ✅ GET PATIENT STATS
    public PatientStats getPatientStats(int patientId) {
        PatientStats stats = new PatientStats();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            
            // 1. Total Orders
            String sqlTotal = "SELECT COUNT(*) FROM orders WHERE patient_id=?";
            ps = con.prepareStatement(sqlTotal);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            if (rs.next()) stats.totalOrders = rs.getInt(1);

            // 2. Active Orders (Ordered, Collected, Processing)
            String sqlActive = "SELECT COUNT(*) FROM orders WHERE patient_id=? AND status IN ('Ordered', 'Collected', 'Processing')";
            ps = con.prepareStatement(sqlActive);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            if (rs.next()) stats.activeOrders = rs.getInt(1);

            // 3. Completed Orders
            String sqlCompleted = "SELECT COUNT(*) FROM orders WHERE patient_id=? AND status='Completed'";
            ps = con.prepareStatement(sqlCompleted);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            if (rs.next()) stats.completedOrders = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return stats;
    }

    // ✅ GET PATIENT RECENT ORDERS
    public List<PatientOrderInfo> getPatientRecentOrders(int patientId) {
        List<PatientOrderInfo> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            // Join Orders with Tests to show what was ordered
            String sql = "SELECT o.order_id, o.order_date, o.status, " +
                         "GROUP_CONCAT(t.test_name SEPARATOR ', ') AS tests " +
                         "FROM orders o " +
                         "JOIN order_tests ot ON o.order_id = ot.order_id " +
                         "JOIN tests t ON ot.test_id = t.test_id " +
                         "WHERE o.patient_id = ? " +
                         "GROUP BY o.order_id " +
                         "ORDER BY o.order_date DESC " +
                         "LIMIT 5";

            ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();

            while (rs.next()) {
                PatientOrderInfo info = new PatientOrderInfo();
                info.orderId = rs.getInt("order_id");
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
    // ===== GETTERS =====

    public int getTotalPatients() { return totalPatients; }
    public int getPendingOrders() { return pendingOrders; }
    public int getCompletedTests() { return completedTests; }
    public double getTotalRevenue() { return totalRevenue; }
    public int getActiveUsers() { return activeUsers; }
    public int getTodayAppointments() { return todayAppointments; }
    public int getLowStockItems() { return lowStockItems; }
    public int getRecentReports() { return recentReports; }
    public List<BllUserMaster> getRecentPatients() { return recentPatients; }
}
