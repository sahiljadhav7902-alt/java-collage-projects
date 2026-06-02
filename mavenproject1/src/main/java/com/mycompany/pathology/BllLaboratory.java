package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Business Logic Layer for Laboratory operations.
 * This class handles laboratory management including CRUD operations.
 */
public class BllLaboratory {

    // --- Data Fields (acting as a model) ---
    private int labId;
    private String labName;
    private String labAddress;
    private String labPhone;
    private String labEmail;
    private String labManager;
    private boolean isActive;

    // --- Getters and Setters for the data fields ---
    public int getLabId() {
        return labId;
    }

    public void setLabId(int labId) {
        this.labId = labId;
    }

    public String getLabName() {
        return labName;
    }

    public void setLabName(String labName) {
        this.labName = labName;
    }

    public String getLabAddress() {
        return labAddress;
    }

    public void setLabAddress(String labAddress) {
        this.labAddress = labAddress;
    }

    public String getLabPhone() {
        return labPhone;
    }

    public void setLabPhone(String labPhone) {
        this.labPhone = labPhone;
    }

    public String getLabEmail() {
        return labEmail;
    }

    public void setLabEmail(String labEmail) {
        this.labEmail = labEmail;
    }

    public String getLabManager() {
        return labManager;
    }

    public void setLabManager(String labManager) {
        this.labManager = labManager;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    /**
     * Get all laboratories from the database
     * @return List of BllLaboratory objects
     */
    public List<BllLaboratory> getAllLaboratories() {
        List<BllLaboratory> laboratories = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return laboratories;
            }

            String sql = "SELECT lab_id, lab_name, lab_address, lab_phone, lab_email, lab_manager, is_active FROM laboratories ORDER BY lab_name";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllLaboratory lab = new BllLaboratory();
                lab.setLabId(rs.getInt("lab_id"));
                lab.setLabName(rs.getString("lab_name"));
                lab.setLabAddress(rs.getString("lab_address"));
                lab.setLabPhone(rs.getString("lab_phone"));
                lab.setLabEmail(rs.getString("lab_email"));
                lab.setLabManager(rs.getString("lab_manager"));
                lab.setActive(rs.getBoolean("is_active"));
                
                laboratories.add(lab);
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

        return laboratories;
    }

    /**
     * Add a new laboratory
     * @param labName Laboratory name
     * @param labAddress Laboratory address
     * @param labPhone Laboratory phone
     * @param labEmail Laboratory email
     * @param labManager Laboratory manager
     * @return Success or error message
     */
    public String addLaboratory(String labName, String labAddress, String labPhone, String labEmail, String labManager) {
        if (labName == null || labName.trim().isEmpty()) {
            return "Laboratory name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "INSERT INTO laboratories (lab_name, lab_address, lab_phone, lab_email, lab_manager, is_active) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, labName);
            ps.setString(2, labAddress);
            ps.setString(3, labPhone);
            ps.setString(4, labEmail);
            ps.setString(5, labManager);
            ps.setBoolean(6, true);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Laboratory added successfully!";
            } else {
                return "Failed to add laboratory.";
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
     * Update an existing laboratory
     * @param labId Laboratory ID
     * @param labName Laboratory name
     * @param labAddress Laboratory address
     * @param labPhone Laboratory phone
     * @param labEmail Laboratory email
     * @param labManager Laboratory manager
     * @return Success or error message
     */
    public String updateLaboratory(int labId, String labName, String labAddress, String labPhone, String labEmail, String labManager) {
        if (labName == null || labName.trim().isEmpty()) {
            return "Laboratory name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE laboratories SET lab_name = ?, lab_address = ?, lab_phone = ?, lab_email = ?, lab_manager = ? WHERE lab_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, labName);
            ps.setString(2, labAddress);
            ps.setString(3, labPhone);
            ps.setString(4, labEmail);
            ps.setString(5, labManager);
            ps.setInt(6, labId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Laboratory updated successfully!";
            } else {
                return "No changes made or laboratory not found.";
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
     * Delete a laboratory (soft delete)
     * @param labId Laboratory ID
     * @return Success or error message
     */
    public String deleteLaboratory(int labId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE laboratories SET is_active = false WHERE lab_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, labId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Laboratory deactivated successfully!";
            } else {
                return "Laboratory not found.";
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
     * Get a single laboratory by ID
     * @param labId Laboratory ID
     * @return BllLaboratory object or null if not found
     */
    public BllLaboratory getLaboratoryById(int labId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return null;
            }

            String sql = "SELECT lab_id, lab_name, lab_address, lab_phone, lab_email, lab_manager, is_active FROM laboratories WHERE lab_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, labId);
            rs = ps.executeQuery();

            if (rs.next()) {
                BllLaboratory lab = new BllLaboratory();
                lab.setLabId(rs.getInt("lab_id"));
                lab.setLabName(rs.getString("lab_name"));
                lab.setLabAddress(rs.getString("lab_address"));
                lab.setLabPhone(rs.getString("lab_phone"));
                lab.setLabEmail(rs.getString("lab_email"));
                lab.setLabManager(rs.getString("lab_manager"));
                lab.setActive(rs.getBoolean("is_active"));
                
                return lab;
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