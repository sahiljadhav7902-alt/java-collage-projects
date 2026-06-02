package com.mycompany.lab;

import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class BllPhysician {

    public int userId;
    public String firstName;
    public String lastName;
    public String email;
    public String phone;
    public String address;
    public String licenseNumber;
    public String dateOfBirth;
    public String gender;

    // ✅ GET PHYSICIAN BY ID (For Edit)
    public BllPhysician getPhysicianById(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BllPhysician physician = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM users WHERE user_id=? AND user_type='physician'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                physician = new BllPhysician();
                physician.userId = rs.getInt("user_id");
                physician.firstName = rs.getString("first_name");
                physician.lastName = rs.getString("last_name");
                physician.email = rs.getString("email");
                physician.phone = rs.getString("phone");
                physician.address = rs.getString("address");
                physician.licenseNumber = rs.getString("license_number");
                physician.dateOfBirth = rs.getString("date_of_birth");
                physician.gender = rs.getString("gender");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return physician;
    }

    // ✅ UPDATE PHYSICIAN
    public String updatePhysician(int userId, String firstName, String lastName, 
                                  String email, String phone, String address, 
                                  String licenseNumber, String dob, String gender) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            // Note: We do not update password_hash here
            String sql = "UPDATE users SET first_name=?, last_name=?, email=?, phone=?, address=?, license_number=?, date_of_birth=?, gender=? WHERE user_id=? AND user_type='physician'";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, licenseNumber);
            ps.setString(7, dob);
            ps.setString(8, gender);
            ps.setInt(9, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Physician updated successfully.";
            return "Physician not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // ✅ REGISTER PHYSICIAN (Your existing code)
    public String registerPhysician(String firstName, String lastName,
                                    String email, String password,
                                    String phone, String address,
                                    String licenseNumber,
                                    String dob, String gender) {
        if (firstName == null || lastName == null || email == null || password == null) {
            return "All required fields must be filled.";
        }
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;
        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";
            
            // Check duplicate email
            String checkSql = "SELECT email FROM users WHERE email=?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            rs = checkPs.executeQuery();
            if (rs.next()) {
                return "This email is already registered.";
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            String insertSql = "INSERT INTO users " +
                    "(user_type, first_name, last_name, email, password_hash, phone, address, license_number, date_of_birth, gender) " +
                    "VALUES ('physician', ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            insertPs = con.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            insertPs.setString(1, firstName);
            insertPs.setString(2, lastName);
            insertPs.setString(3, email);
            insertPs.setString(4, hashedPassword);
            insertPs.setString(5, phone);
            insertPs.setString(6, address);
            insertPs.setString(7, licenseNumber);
            insertPs.setString(8, dob);
            insertPs.setString(9, gender);

            int rows = insertPs.executeUpdate();
            if (rows > 0) {
                rs = insertPs.getGeneratedKeys();
                if (rs.next()) {
                    this.userId = rs.getInt(1);
                }
                return "Physician registered successfully.";
            }
            return "Registration failed.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkPs != null) checkPs.close(); } catch (Exception e) {}
            try { if (insertPs != null) insertPs.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ DELETE PHYSICIAN (Your existing code)
    public String deletePhysician(int userId) {
        // ... keep your existing delete code ...
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";
            String sql = "DELETE FROM users WHERE user_id=? AND user_type='physician'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            if (rows > 0) return "Physician deleted successfully.";
            return "Physician not found.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}