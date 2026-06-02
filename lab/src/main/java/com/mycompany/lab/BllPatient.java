package com.mycompany.lab;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public class BllPatient {

    public int userId;
    public String firstName;
    public String lastName;
    public String email;
    public String phone;
    public String address;
    public String dateOfBirth;
    public String gender;
    public String mrn; // Medical Record Number

    // ✅ REGISTER PATIENT
    public String registerPatient(String firstName, String lastName, String email, 
                                  String password, String phone, String address, 
                                  String mrn, String dob, String gender) {

        if (firstName == null || lastName == null || email == null || password == null || mrn == null) {
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

            // Check duplicate MRN
            String checkMrnSql = "SELECT mrn FROM users WHERE mrn=?";
            checkPs = con.prepareStatement(checkMrnSql);
            checkPs.setString(1, mrn);
            rs = checkPs.executeQuery();
            if (rs.next()) {
                return "This Medical Record Number (MRN) already exists.";
            }

            // Hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Insert patient
            String insertSql = "INSERT INTO users " +
                    "(user_type, first_name, last_name, email, password_hash, phone, address, mrn, date_of_birth, gender) " +
                    "VALUES ('patient', ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            insertPs = con.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);

            insertPs.setString(1, firstName);
            insertPs.setString(2, lastName);
            insertPs.setString(3, email);
            insertPs.setString(4, hashedPassword);
            insertPs.setString(5, phone);
            insertPs.setString(6, address);
            insertPs.setString(7, mrn);
            insertPs.setString(8, dob);
            insertPs.setString(9, gender);

            int rows = insertPs.executeUpdate();

            if (rows > 0) {
                rs = insertPs.getGeneratedKeys();
                if (rs.next()) {
                    this.userId = rs.getInt(1);
                }
                return "Patient registered successfully.";
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

    // ✅ GET PATIENT BY ID (For Edit)
    public BllPatient getPatientById(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        BllPatient patient = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM users WHERE user_id=? AND user_type='patient'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                patient = new BllPatient();
                patient.userId = rs.getInt("user_id");
                patient.firstName = rs.getString("first_name");
                patient.lastName = rs.getString("last_name");
                patient.email = rs.getString("email");
                patient.phone = rs.getString("phone");
                patient.address = rs.getString("address");
                patient.mrn = rs.getString("mrn");
                patient.dateOfBirth = rs.getString("date_of_birth");
                patient.gender = rs.getString("gender");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return patient;
    }

    // ✅ UPDATE PATIENT
    public String updatePatient(int userId, String firstName, String lastName, 
                                String email, String phone, String address, 
                                String mrn, String dob, String gender) {

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "UPDATE users SET first_name=?, last_name=?, email=?, phone=?, address=?, mrn=?, date_of_birth=?, gender=? WHERE user_id=? AND user_type='patient'";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, mrn);
            ps.setString(7, dob);
            ps.setString(8, gender);
            ps.setInt(9, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Patient updated successfully.";
            return "Patient not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // ✅ DELETE PATIENT
    public String deletePatient(int userId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            // Note: In a real system, check if patient has active orders before deleting
            String sql = "DELETE FROM users WHERE user_id=? AND user_type='patient'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) return "Patient deleted successfully.";
            return "Patient not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            // Might fail if there are foreign key constraints (e.g. existing orders)
            return "Error: " + e.getMessage(); 
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
    
        // ✅ SEARCH PATIENTS (For Doctor use)
    public List<BllPatient> searchPatients(String query) {
        List<BllPatient> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        if (query == null || query.trim().isEmpty()) {
            return list;
        }

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            String sql = "SELECT user_id, first_name, last_name, email, phone, mrn, date_of_birth, gender " +
                         "FROM users " +
                         "WHERE user_type='patient' " +
                         "AND (first_name LIKE ? OR last_name LIKE ? OR mrn LIKE ?)";
            
            ps = con.prepareStatement(sql);
            String searchPattern = "%" + query + "%";
            
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            rs = ps.executeQuery();

            while (rs.next()) {
                BllPatient p = new BllPatient();
                p.userId = rs.getInt("user_id");
                p.firstName = rs.getString("first_name");
                p.lastName = rs.getString("last_name");
                p.email = rs.getString("email");
                p.phone = rs.getString("phone");
                p.mrn = rs.getString("mrn");
                p.dateOfBirth = rs.getString("date_of_birth");
                p.gender = rs.getString("gender");
                list.add(p);
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
}