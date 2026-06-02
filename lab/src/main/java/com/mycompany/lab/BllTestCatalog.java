package com.mycompany.lab;

import java.sql.*;

public class BllTestCatalog {

    public int testId;
    public String testName;
    public String loincCode;
    public String snomedCode;
    public String specimenType;
    public String normalRange;
    public String unit;

    // ✅ ADD TEST
    public String addTest(String testName, String loincCode, String snomedCode, 
                          String specimenType, String normalRange, String unit) {

        if (testName == null || testName.isEmpty()) {
            return "Test Name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "INSERT INTO tests (test_name, loinc_code, snomed_code, specimen_type, normal_range, unit) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setString(1, testName);
            ps.setString(2, loincCode);
            ps.setString(3, snomedCode);
            ps.setString(4, specimenType);
            ps.setString(5, normalRange);
            ps.setString(6, unit);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                return "Test added successfully.";
            }

            return "Failed to add test.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ GET TEST BY ID (For Edit)
    public BllTestCatalog getTestById(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BllTestCatalog test = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM tests WHERE test_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                test = new BllTestCatalog();
                test.testId = rs.getInt("test_id");
                test.testName = rs.getString("test_name");
                test.loincCode = rs.getString("loinc_code");
                test.snomedCode = rs.getString("snomed_code");
                test.specimenType = rs.getString("specimen_type");
                test.normalRange = rs.getString("normal_range");
                test.unit = rs.getString("unit");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return test;
    }

    // ✅ UPDATE TEST
    public String updateTest(int testId, String testName, String loincCode, String snomedCode, 
                             String specimenType, String normalRange, String unit) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "UPDATE tests SET test_name=?, loinc_code=?, snomed_code=?, specimen_type=?, normal_range=?, unit=? WHERE test_id=?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, testName);
            ps.setString(2, loincCode);
            ps.setString(3, snomedCode);
            ps.setString(4, specimenType);
            ps.setString(5, normalRange);
            ps.setString(6, unit);
            ps.setInt(7, testId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Test updated successfully.";
            return "Test not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // ✅ DELETE TEST
    public String deleteTest(int testId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "DELETE FROM tests WHERE test_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, testId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Test deleted successfully.";
            return "Test not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            // Note: This may fail if the test is referenced in existing orders
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}