package com.mycompany.lab;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class BllUserMaster {
    private int userId;
    private String userType;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String address;
    private String dateOfBirth;
    private String gender;
    private String licenseNumber;

    private String mrn;
    private boolean isActive;

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }
    
    public String getMrn() { return mrn; }
    public void setMrn(String mrn) { this.mrn = mrn; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getFullName() { return firstName + " " + lastName; }

    /**
     * Register a new patient
     */
    public String registerPatient(String firstName, String lastName, String email, 
                                String password, String phone, String dob, String gender) {
        
        if (firstName == null || lastName == null || email == null || password == null) {
            return "All required fields must be filled.";
        }

        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            // Check if email already exists
            String checkSql = "SELECT email FROM users WHERE email = ?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            rs = checkPs.executeQuery();

            if (rs.next()) {
                return "This email is already registered.";
            }

            // Generate MRN for patient
            String mrn = "MRN" + System.currentTimeMillis();

            // Hash the password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Insert patient
            String insertSql = "INSERT INTO users (user_type, first_name, last_name, email, password_hash, phone, date_of_birth, gender, mrn) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            insertPs = con.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            insertPs.setString(1, "PATIENT");
            insertPs.setString(2, firstName);
            insertPs.setString(3, lastName);
            insertPs.setString(4, email);
            insertPs.setString(5, hashedPassword);
            insertPs.setString(6, phone);
            insertPs.setString(7, dob);
            insertPs.setString(8, gender);
            insertPs.setString(9, mrn);

            int rowsAffected = insertPs.executeUpdate();
            if (rowsAffected > 0) {
                rs = insertPs.getGeneratedKeys();
                if (rs.next()) {
                    this.userId = rs.getInt(1);
                    this.userType = "PATIENT";
                    this.firstName = firstName;
                    this.lastName = lastName;
                    this.email = email;
                    this.phone = phone;
                    this.dateOfBirth = dob;
                    this.gender = gender;
                    this.mrn = mrn;
                    return "Patient registration successful! Your MRN is: " + mrn;
                }
            }
            
            return "Registration failed. Please try again.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "An error occurred: " + e.getMessage();
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
     * Register a new doctor or admin
     */
    public String registerDoctorOrAdmin(String userType, String firstName, String lastName, 
                                       String email, String password, String phone, 
                                       String address, String licenseNumber, 
                                       String certification) {
        
        if (firstName == null || lastName == null || email == null || password == null || userType == null) {
            return "All required fields must be filled.";
        }
         
        if (!userType.equals("physician") && !userType.equals("admin")) {
            System.out.println("hi"+userType);
            return "Invalid user type. Must be DOCTOR or ADMIN.";
        }

        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            // Check if email already exists
            String checkSql = "SELECT email FROM users WHERE email = ?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            rs = checkPs.executeQuery();

            if (rs.next()) {
                return "This email is already registered.";
            }

            // Hash the password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Insert user
            String insertSql = "INSERT INTO users (user_type, first_name, last_name, email, password_hash, phone, address, license_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            insertPs = con.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            insertPs.setString(1, userType);
            insertPs.setString(2, firstName);
            insertPs.setString(3, lastName);
            insertPs.setString(4, email);
            insertPs.setString(5, hashedPassword);
            insertPs.setString(6, phone);
            insertPs.setString(7, address);
            insertPs.setString(8, licenseNumber);
          

            int rowsAffected = insertPs.executeUpdate();
            if (rowsAffected > 0) {
                rs = insertPs.getGeneratedKeys();
                if (rs.next()) {
                    this.userId = rs.getInt(1);
                    this.userType = userType;
                    this.firstName = firstName;
                    this.lastName = lastName;
                    this.email = email;
                    this.phone = phone;
                    this.address = address;
                    this.licenseNumber = licenseNumber;
                    return userType + " registration successful! You can now log in.";
                }
            }
            
            return "Registration failed. Please try again.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "An error occurred: " + e.getMessage();
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
     * User login logic with redirection
     */
 /**
 * Logs in a user by verifying their email and password against the database.
 *
 * @param email The user's email address.
 * @param password The plain-text password entered by the user.
 * @return A BllUserMaster object populated with the user's data on success,
 *         or null if the login fails (user not found, incorrect password, or database error).
 */
public BllUserMaster loginUser(String email, String password) {
    // Use java.util.logging for standard, no-dependency logging
    java.util.logging.Logger logger = java.util.logging.Logger.getLogger(BllUserMaster.class.getName());

    // Log the attempt (do NOT log the password)
    logger.info("Attempting login for email: " + email);

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DataAccess.getConnection();
        if (con == null) {
            logger.severe("Database connection failed. DataAccess.getConnection() returned null.");
            return null;
        }

        // IMPORTANT FIX: Added 'last_name' to the SELECT statement
        String sql = "SELECT user_id, user_type, first_name, last_name, password_hash " +
                     "FROM users WHERE email = ?";
        
        ps = con.prepareStatement(sql);
        ps.setString(1, email);

        rs = ps.executeQuery();

        if (rs.next()) {
            // User with the email was found
            String storedHash = rs.getString("password_hash");

            if (storedHash == null || storedHash.isEmpty()) {
                logger.severe("Login failed for email '" + email + "'. Password hash is null or empty in the database.");
                return null;
            }

            // Verify the password
            if (BCrypt.checkpw(password, storedHash)) {
                // Password is correct! Create and populate the user object.
                logger.info("Password verified successfully for email: " + email);
                
                BllUserMaster user = new BllUserMaster();
                user.setUserId(rs.getInt("user_id"));
                user.setUserType(rs.getString("user_type"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name")); // This line is now crucial
                
                return user;
            } else {
                // Password does not match
                logger.warning("Login failed for email '" + email + "'. Password mismatch.");
                return null;
            }
        } else {
            // No user found with that email
            logger.warning("Login failed. No user found with email: " + email);
            return null;
        }

    } catch (SQLException e) {
        // Log the specific SQL exception for debugging
        logger.severe("SQLException occurred during login for email '" + email + "': " + e.getMessage());
        e.printStackTrace();
        return null;
    } finally {
        // Ensure all resources are closed properly
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            logger.severe("Error closing database resources: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
    /**
     * Get user by ID
     */
    public BllUserMaster getUserById(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT * FROM users WHERE user_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                this.userId = rs.getInt("user_id");
                this.userType = rs.getString("user_type");
                this.firstName = rs.getString("first_name");
                this.lastName = rs.getString("last_name");
                this.email = rs.getString("email");
                this.phone = rs.getString("phone");
                this.address = rs.getString("address");
                this.dateOfBirth = rs.getString("date_of_birth");
                this.gender = rs.getString("gender");
                this.licenseNumber = rs.getString("license_number");
               
                this.mrn = rs.getString("mrn");
                this.isActive = rs.getBoolean("is_active");
                return this;
            }
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
    
    
        // ... [Keep all your existing code: registerPatient, registerDoctorOrAdmin, loginUser, getUserById] ...

    /**
     * Update Patient Profile Info
     */
    public String updatePatientProfile(int userId, String email, String phone, String address, String newPassword) {
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            // 1. Check if new email already exists for a DIFFERENT user
            String checkSql = "SELECT email FROM users WHERE email = ? AND user_id != ?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            checkPs.setInt(2, userId);
            rs = checkPs.executeQuery();

            if (rs.next()) {
                return "This email is already in use by another account.";
            }

            // 2. Update Query
            // We update phone, address, and email.
            // Password is handled separately if provided.
            String sql = "UPDATE users SET email = ?, phone = ?, address = ?";
            
            if (newPassword != null && !newPassword.isEmpty()) {
                // Append password update if provided
                sql += ", password_hash = ?";
            }
            
            sql += " WHERE user_id = ?";

            updatePs = con.prepareStatement(sql);
            int paramIndex = 1;
            updatePs.setString(paramIndex++, email);
            updatePs.setString(paramIndex++, phone);
            updatePs.setString(paramIndex++, address);

            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                updatePs.setString(paramIndex++, hashedPassword);
            }

            updatePs.setInt(paramIndex, userId);

            int rows = updatePs.executeUpdate();
            if (rows > 0) {
                // Update session attributes for display
                // Note: In a real MVC app, you'd update the session object properly
                return "Profile updated successfully!";
            } else {
                return "Update failed. User not found.";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPs != null) checkPs.close();
                if (updatePs != null) updatePs.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
