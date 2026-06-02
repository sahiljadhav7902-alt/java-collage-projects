package com.mycompany.lab;

import java.sql.*;

public class BllLaboratory {

    public int labId;
    public String labName;
    public String location;
    public String accreditation;

    // ✅ GET LAB BY ID (New method for Edit)
    public BllLaboratory getLaboratoryById(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BllLaboratory lab = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM laboratories WHERE lab_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                lab = new BllLaboratory();
                lab.labId = rs.getInt("lab_id");
                lab.labName = rs.getString("lab_name");
                lab.location = rs.getString("location");
                lab.accreditation = rs.getString("accreditation");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return lab;
    }

    // ✅ ADD LAB (Your existing code)
    public String addLaboratory(String labName, String location, String accreditation) {
        if (labName == null || labName.isEmpty()) {
            return "Lab name is required.";
        }
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";
            String sql = "INSERT INTO laboratories (lab_name, location, accreditation) VALUES ( ?, ?, ?)";
            ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, labName);
            ps.setString(2, location);
            ps.setString(3, accreditation);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    this.labId = rs.getInt(1);
                }
                return "Laboratory added successfully.";
            }
            return "Failed to add laboratory.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // ✅ UPDATE LAB (Your existing code)
    public String updateLaboratory(int labId, String labName, String location, String accreditation) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";
            String sql = "UPDATE laboratories SET lab_name=?, location=?, accreditation=? WHERE lab_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, labName);
            ps.setString(2, location);
            ps.setString(3, accreditation);
            ps.setInt(4, labId);
            int rows = ps.executeUpdate();
            if (rows > 0) return "Laboratory updated successfully.";
            return "Laboratory not found.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // ✅ DELETE LAB (Your existing code)
    public String deleteLaboratory(int labId) {
        // ... (Keep your existing delete code here) ...
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";
            String sql = "DELETE FROM laboratories WHERE lab_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, labId);
            int rows = ps.executeUpdate();
            if (rows > 0) return "Laboratory deleted successfully.";
            return "Laboratory not found.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}