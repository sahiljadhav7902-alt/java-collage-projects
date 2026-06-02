package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Business Logic Layer for Technician operations.
 * This class handles technician management including CRUD operations.
 */
public class BllTechnician {

    // --- Data Fields (acting as a model) ---
    private int technicianId;
    private String firstName;
    private String lastName;
    private String certification;
    private int labId;
    private String labName;
    private boolean isActive;

    // --- Getters and Setters for the data fields ---
    public int getTechnicianId() {
        return technicianId;
    }

    public void setTechnicianId(int technicianId) {
        this.technicianId = technicianId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCertification() {
        return certification;
    }

    public void setCertification(String certification) {
        this.certification = certification;
    }

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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    /**
     * Get all technicians from the database
     * @return List of BllTechnician objects
     */
    public List<BllTechnician> getAllTechnicians() {
        List<BllTechnician> technicians = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return technicians;
            }

            String sql = "SELECT t.technician_id, t.first_name, t.last_name, t.certification, t.lab_id, l.lab_name, t.is_active " +
                        "FROM technicians t " +
                        "LEFT JOIN laboratories l ON t.lab_id = l.lab_id " +
                        "ORDER BY t.last_name, t.first_name";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllTechnician technician = new BllTechnician();
                technician.setTechnicianId(rs.getInt("technician_id"));
                technician.setFirstName(rs.getString("first_name"));
                technician.setLastName(rs.getString("last_name"));
                technician.setCertification(rs.getString("certification"));
                technician.setLabId(rs.getInt("lab_id"));
                technician.setLabName(rs.getString("lab_name"));
                technician.setActive(rs.getBoolean("is_active"));
                
                technicians.add(technician);
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

        return technicians;
    }

    /**
     * Add a new technician
     * @param firstName Technician's first name
     * @param lastName Technician's last name
     * @param certification Certification
     * @param labId Laboratory ID
     * @return Success or error message
     */
    public String addTechnician(String firstName, String lastName, String certification, int labId) {
        if (firstName == null || firstName.trim().isEmpty() || 
            lastName == null || lastName.trim().isEmpty()) {
            return "First name and last name are required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "INSERT INTO technicians (first_name, last_name, certification, lab_id, is_active) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, certification);
            ps.setInt(4, labId);
            ps.setBoolean(5, true);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Technician added successfully!";
            } else {
                return "Failed to add technician.";
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
     * Update an existing technician
     * @param technicianId Technician ID
     * @param firstName Technician's first name
     * @param lastName Technician's last name
     * @param certification Certification
     * @param labId Laboratory ID
     * @return Success or error message
     */
    public String updateTechnician(int technicianId, String firstName, String lastName, String certification, int labId) {
        if (firstName == null || firstName.trim().isEmpty() || 
            lastName == null || lastName.trim().isEmpty()) {
            return "First name and last name are required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE technicians SET first_name = ?, last_name = ?, certification = ?, lab_id = ? WHERE technician_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, certification);
            ps.setInt(4, labId);
            ps.setInt(5, technicianId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Technician updated successfully!";
            } else {
                return "No changes made or technician not found.";
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
     * Delete a technician (soft delete)
     * @param technicianId Technician ID
     * @return Success or error message
     */
    public String deleteTechnician(int technicianId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE technicians SET is_active = false WHERE technician_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, technicianId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Technician deactivated successfully!";
            } else {
                return "Technician not found.";
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
     * Get a single technician by ID
     * @param technicianId Technician ID
     * @return BllTechnician object or null if not found
     */
    public BllTechnician getTechnicianById(int technicianId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return null;
            }

            String sql = "SELECT t.technician_id, t.first_name, t.last_name, t.certification, t.lab_id, l.lab_name, t.is_active " +
                        "FROM technicians t " +
                        "LEFT JOIN laboratories l ON t.lab_id = l.lab_id " +
                        "WHERE t.technician_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, technicianId);
            rs = ps.executeQuery();

            if (rs.next()) {
                BllTechnician technician = new BllTechnician();
                technician.setTechnicianId(rs.getInt("technician_id"));
                technician.setFirstName(rs.getString("first_name"));
                technician.setLastName(rs.getString("last_name"));
                technician.setCertification(rs.getString("certification"));
                technician.setLabId(rs.getInt("lab_id"));
                technician.setLabName(rs.getString("lab_name"));
                technician.setActive(rs.getBoolean("is_active"));
                
                return technician;
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

    /**
     * Get all laboratories for dropdown
     * @return List of laboratory names and IDs
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

            String sql = "SELECT lab_id, lab_name FROM laboratories WHERE is_active = true ORDER BY lab_name";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllLaboratory lab = new BllLaboratory();
                lab.setLabId(rs.getInt("lab_id"));
                lab.setLabName(rs.getString("lab_name"));
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
}