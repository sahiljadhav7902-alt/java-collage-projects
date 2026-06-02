package com.mycompany.lab;

import java.sql.*;

public class BllDiagnosis {

    public int diagnosisId;
    public String icd10Code;
    public String description;

    // ✅ ADD DIAGNOSIS
    public String addDiagnosis(String icd10Code, String description) {
        if (icd10Code == null || icd10Code.isEmpty()) {
            return "ICD-10 Code is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            // Check for duplicate code
            String checkSql = "SELECT icd10_code FROM diagnoses WHERE icd10_code=?";
            ps = con.prepareStatement(checkSql);
            ps.setString(1, icd10Code);
            rs = ps.executeQuery();
            if (rs.next()) {
                return "This ICD-10 Code already exists.";
            }

            // Insert
            String sql = "INSERT INTO diagnoses (icd10_code, description) VALUES (?, ?)";
            ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, icd10Code);
            ps.setString(2, description);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                return "Diagnosis added successfully.";
            }

            return "Failed to add diagnosis.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ GET DIAGNOSIS BY ID (For Edit)
    public BllDiagnosis getDiagnosisById(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BllDiagnosis diagnosis = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM diagnoses WHERE diagnosis_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                diagnosis = new BllDiagnosis();
                diagnosis.diagnosisId = rs.getInt("diagnosis_id");
                diagnosis.icd10Code = rs.getString("icd10_code");
                diagnosis.description = rs.getString("description");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return diagnosis;
    }

    // ✅ UPDATE DIAGNOSIS
    public String updateDiagnosis(int diagnosisId, String icd10Code, String description) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "UPDATE diagnoses SET icd10_code=?, description=? WHERE diagnosis_id=?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, icd10Code);
            ps.setString(2, description);
            ps.setInt(3, diagnosisId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Diagnosis updated successfully.";
            return "Diagnosis not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // ✅ DELETE DIAGNOSIS
    public String deleteDiagnosis(int diagnosisId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "DELETE FROM diagnoses WHERE diagnosis_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, diagnosisId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Diagnosis deleted successfully.";
            return "Diagnosis not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            // Note: This will fail if the diagnosis is referenced by existing orders (Foreign Key constraint)
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}