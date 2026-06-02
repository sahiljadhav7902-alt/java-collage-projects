/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.lab;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Common Data Access Class
 * Handles MySQL connection for the Pathology Lab System
 * Database: pathology_lab
 * Author: Pathology Lab System
 */
public class DataAccess {

    // ==============================
    // Database Configuration
    // ==============================
    public static final String URL = "jdbc:mysql://localhost:3306/lab_information_system?useSSL=false&allowPublicKeyRetrieval=true";
    public static final String USER = "root";
    public static final String PASS = "root";

    /**
     * Returns a Connection object to the MySQL database.
     * @return Connection
     * @throws SQLException 
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Register the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            Connection con = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Database Connected Successfully to pathology_lab!");
            return con;
        } 
        catch (SQLException ex) {
            System.out.println("❌ SQL Connection Error: " + ex.getMessage());
            throw ex;
        } 
        catch (Exception ex) {
            System.out.println("⚠️ General Error: " + ex.getMessage());
            throw new SQLException("Database connection error", ex);
        }
    }

    /**
     * Close database connection safely
     * @param con 
     */
    public static void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("🔒 Connection closed successfully.");
            }
        } catch (SQLException ex) {
            System.out.println("⚠️ Error closing connection: " + ex.getMessage());
        }
    }
}