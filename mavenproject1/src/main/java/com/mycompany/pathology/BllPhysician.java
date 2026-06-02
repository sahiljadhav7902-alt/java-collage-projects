package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class BllPhysician {

    private int physicianId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String licenseNumber;

    // Getters and Setters
    public int getPhysicianId() { return physicianId; }
    public void setPhysicianId(int physicianId) { this.physicianId = physicianId; }
    public String getFullName() { return firstName + " " + lastName; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public BllPhysician loginPhysician(String email, String password) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return null;

            String sql = "SELECT physician_id, first_name, last_name, email, phone, license_number, password_hash FROM physicians WHERE email = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (BCrypt.checkpw(password, storedHash)) {
                    this.physicianId = rs.getInt("physician_id");
                    this.firstName = rs.getString("first_name");
                    this.lastName = rs.getString("last_name");
                    this.email = rs.getString("email");
                    this.phone = rs.getString("phone");
                    this.licenseNumber = rs.getString("license_number");
                    return this;
                }
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
}