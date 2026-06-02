package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Business Logic Layer for Dashboard operations.
 * This class handles dashboard statistics and overview data.
 */
public class BllDashboard {

    /**
     * Get total number of patients
     * @return Total patients count
     */
    public int getTotalPatients() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return 0;
            }

            String sql = "SELECT COUNT(*) as total FROM patients WHERE role = 'patient' AND is_active = true";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
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

        return count;
    }

    /**
     * Get total number of orders
     * @return Total orders count
     */
    public int getTotalOrders() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return 0;
            }

            String sql = "SELECT COUNT(*) as total FROM orders";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
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

        return count;
    }

    /**
     * Get number of pending orders
     * @return Pending orders count
     */
    public int getPendingOrders() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return 0;
            }

            String sql = "SELECT COUNT(*) as total FROM orders WHERE status = 'pending'";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
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

        return count;
    }

    /**
     * Get inventory alerts (items expiring in less than 30 days)
     * @return Inventory alerts count
     */
    public int getInventoryAlerts() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return 0;
            }

            String sql = "SELECT COUNT(*) as total FROM inventory WHERE expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) AND expiry_date >= CURDATE()";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
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

        return count;
    }
}