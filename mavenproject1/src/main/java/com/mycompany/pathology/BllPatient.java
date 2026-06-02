package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Business Logic Layer for Patient operations.
 * This class handles patient registration and related business logic.
 */
public class BllPatient {

    // --- Data Fields (acting as a model) ---
    private int patientId;
    private String fullName;
    private String email;
    private String phone;
    private String dob;
    private String gender;
    private String role;

    // --- Getters and Setters for the data fields ---
    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    /**
     * Handles the complete patient registration process.
     * @param fullName Full name of the patient
     * @param email Patient's email
     * @param password Patient's plain-text password
     * @param mobile Patient's phone number
     * @param dob Date of birth
     * @param gender Gender
     * @param role User role (e.g., "patient")
     * @return Success or error message
     */
      public String registerPatient(String fullName, String email, String password, String mobile, String dob, String gender, String role) {
    // Input validation
    if (fullName == null || fullName.trim().isEmpty() ||
        email == null || !email.contains("@") ||
        password == null || password.length() < 6) {
        return "Invalid input. Please fill all fields correctly. Password must be at least 6 characters.";
    }

    Connection con = null;
    PreparedStatement checkPs = null;
    PreparedStatement insertPs = null;
    ResultSet rs = null;

    try {
        con = DataAccess.getConnection();
        if (con == null) {
            return "Database connection failed. Please try again later.";
        }

        // Check if email already exists
        String checkSql = "SELECT email FROM patients WHERE email = ?";
        checkPs = con.prepareStatement(checkSql);
        checkPs.setString(1, email);
        rs = checkPs.executeQuery();

        if (rs.next()) {
            return "This email is already registered.";
        }

        // Split full name into first and last name
        String[] nameParts = fullName.split(" ", 2);
        String firstName = nameParts[0];
        String lastName = nameParts.length > 1 ? nameParts[1] : "";

        // Generate unique MRN (Medical Record Number)
        String mrn = generateUniqueMRN();

        // Hash the password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // Insert new patient
        String insertSql = "INSERT INTO patients (mrn, first_name, last_name, email, password_hash, phone, date_of_birth, gender, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        insertPs = con.prepareStatement(insertSql);
        insertPs.setString(1, mrn);
        insertPs.setString(2, firstName);
        insertPs.setString(3, lastName);
        insertPs.setString(4, email);
        insertPs.setString(5, hashedPassword);
        insertPs.setString(6, mobile);
        insertPs.setString(7, dob);
        insertPs.setString(8, gender);
        insertPs.setString(9, role);

        int rowsAffected = insertPs.executeUpdate();

        if (rowsAffected > 0) {
            return "Registration successful! Your MRN is: " + mrn + ". You can now log in.";
        } else {
            return "Registration failed. No rows were affected.";
        }

    } catch (SQLException e) {
        e.printStackTrace();
        return "An error occurred during registration: " + e.getMessage();
    } finally {
        try {
            if (rs != null) rs.close();
            if (checkPs != null) checkPs.close();
            if (insertPs != null) insertPs.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

/**
 * Generates a unique Medical Record Number (MRN)
 * Format: MRN + timestamp + random number
 */
private String generateUniqueMRN() {
    // Generate timestamp-based MRN
    String timestamp = String.valueOf(System.currentTimeMillis());
    String random = String.valueOf((int)(Math.random() * 1000));
    
    // Create MRN in format: MRN + first 8 digits of timestamp + random 3 digits
    return "MRN" + timestamp.substring(timestamp.length() - 8) + random;
}

    /**
     * Handles patient login process.
     * @param email Patient's email
     * @param password Patient's plain-text password
     * @return BllPatient object if login successful, null otherwise
     */
    public BllPatient loginPatient(String email, String password) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return null;
            }

            String sql = "SELECT patient_id, full_name, email, password_hash, phone, dob, gender, role FROM patients WHERE email = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");

                if (BCrypt.checkpw(password, storedHash)) {
                    // Password is correct, populate this object's fields
                    this.patientId = rs.getInt("patient_id");
                    this.fullName = rs.getString("full_name");
                    this.email = rs.getString("email");
                    this.phone = rs.getString("phone");
                    this.dob = rs.getString("dob");
                    this.gender = rs.getString("gender");
                    this.role = rs.getString("role");
                    
                    // Return this instance, which now holds the patient's data
                    return this;
                }
            }
            // If email not found or password doesn't match, return null
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}