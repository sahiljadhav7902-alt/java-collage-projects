package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Business Logic Layer for Test Catalog operations.
 * This class handles test management including CRUD operations.
 */
public class BllTestMaster {

    // --- Data Fields (acting as a model) ---
    private int testId;
    private String testName;
    private String loincCode;
    private String snomedCode;
    private String specimenType;
    private String normalRange;
    private String unit;
    private boolean isActive;

    // --- Getters and Setters for the data fields ---
    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public String getTestName() {
        return testName;
    }

    public void setTestName(String testName) {
        this.testName = testName;
    }

    public String getLoincCode() {
        return loincCode;
    }

    public void setLoincCode(String loincCode) {
        this.loincCode = loincCode;
    }

    public String getSnomedCode() {
        return snomedCode;
    }

    public void setSnomedCode(String snomedCode) {
        this.snomedCode = snomedCode;
    }

    public String getSpecimenType() {
        return specimenType;
    }

    public void setSpecimenType(String specimenType) {
        this.specimenType = specimenType;
    }

    public String getNormalRange() {
        return normalRange;
    }

    public void setNormalRange(String normalRange) {
        this.normalRange = normalRange;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    /**
     * Get all tests from the database
     * @return List of BllTestMaster objects
     */
    public List<BllTestMaster> getAllTests() {
        List<BllTestMaster> tests = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return tests;
            }

            String sql = "SELECT test_id, test_name, loinc_code, snomed_code, specimen_type, normal_range, unit, is_active " +
                        "FROM test_master ORDER BY test_name";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllTestMaster test = new BllTestMaster();
                test.setTestId(rs.getInt("test_id"));
                test.setTestName(rs.getString("test_name"));
                test.setLoincCode(rs.getString("loinc_code"));
                test.setSnomedCode(rs.getString("snomed_code"));
                test.setSpecimenType(rs.getString("specimen_type"));
                test.setNormalRange(rs.getString("normal_range"));
                test.setUnit(rs.getString("unit"));
                test.setActive(rs.getBoolean("is_active"));
                
                tests.add(test);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return tests;
    }

    /**
     * Add a new test
     * @param testName Test name
     * @param loincCode LOINC code
     * @param snomedCode SNOMED code
     * @param specimenType Specimen type
     * @param normalRange Normal range
     * @param unit Unit of measurement
     * @return Success or error message
     */
    public String addTest(String testName, String loincCode, String snomedCode, String specimenType, String normalRange, String unit) {
        if (testName == null || testName.trim().isEmpty()) {
            return "Test name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "INSERT INTO test_master (test_name, loinc_code, snomed_code, specimen_type, normal_range, unit, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, testName);
            ps.setString(2, loincCode);
            ps.setString(3, snomedCode);
            ps.setString(4, specimenType);
            ps.setString(5, normalRange);
            ps.setString(6, unit);
            ps.setBoolean(7, true);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Test added successfully!";
            } else {
                return "Failed to add test.";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Update an existing test
     * @param testId Test ID
     * @param testName Test name
     * @param loincCode LOINC code
     * @param snomedCode SNOMED code
     * @param specimenType Specimen type
     * @param normalRange Normal range
     * @param unit Unit of measurement
     * @return Success or error message
     */
    public String updateTest(int testId, String testName, String loincCode, String snomedCode, String specimenType, String normalRange, String unit) {
        if (testName == null || testName.trim().isEmpty()) {
            return "Test name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE test_master SET test_name = ?, loinc_code = ?, snomed_code = ?, specimen_type = ?, normal_range = ?, unit = ? WHERE test_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, testName);
            ps.setString(2, loincCode);
            ps.setString(3, snomedCode);
            ps.setString(4, specimenType);
            ps.setString(5, normalRange);
            ps.setString(6, unit);
            ps.setInt(7, testId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Test updated successfully!";
            } else {
                return "No changes made or test not found.";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Delete a test (soft delete)
     * @param testId Test ID
     * @return Success or error message
     */
    public String deleteTest(int testId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE test_master SET is_active = false WHERE test_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, testId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Test deactivated successfully!";
            } else {
                return "Test not found.";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Get a single test by ID
     * @param testId Test ID
     * @return BllTestMaster object or null if not found
     */
    public BllTestMaster getTestById(int testId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return null;
            }

            String sql = "SELECT test_id, test_name, loinc_code, snomed_code, specimen_type, normal_range, unit, is_active " +
                        "FROM test_master WHERE test_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, testId);
            rs = ps.executeQuery();

            if (rs.next()) {
                BllTestMaster test = new BllTestMaster();
                test.setTestId(rs.getInt("test_id"));
                test.setTestName(rs.getString("test_name"));
                test.setLoincCode(rs.getString("loinc_code"));
                test.setSnomedCode(rs.getString("snomed_code"));
                test.setSpecimenType(rs.getString("specimen_type"));
                test.setNormalRange(rs.getString("normal_range"));
                test.setUnit(rs.getString("unit"));
                test.setActive(rs.getBoolean("is_active"));
                
                return test;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return null;
    }
}