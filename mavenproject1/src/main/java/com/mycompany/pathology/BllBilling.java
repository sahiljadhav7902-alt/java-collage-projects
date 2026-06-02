package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Business Logic Layer for Billing operations.
 * This class handles billing management including viewing and processing bills.
 */
public class BllBilling {

    // --- Data Fields (acting as a model) ---
    private int billId;
    private int orderId;
    private String cptCode;
    private double amount;
    private String paymentStatus;
    private String billDate;
    private boolean isActive;

    // --- Getters and Setters for the data fields ---
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getCptCode() {
        return cptCode;
    }

    public void setCptCode(String cptCode) {
        this.cptCode = cptCode;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getBillDate() {
        return billDate;
    }

    public void setBillDate(String billDate) {
        this.billDate = billDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    /**
     * Get all bills from the database
     * @return List of BllBilling objects
     */
    public List<BllBilling> getAllBills() {
        List<BllBilling> bills = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return bills;
            }

            String sql = "SELECT bill_id, order_id, cpt_code, amount, payment_status, bill_date, is_active " +
                        "FROM bills ORDER BY bill_date DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllBilling bill = new BllBilling();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setOrderId(rs.getInt("order_id"));
                bill.setCptCode(rs.getString("cpt_code"));
                bill.setAmount(rs.getDouble("amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setBillDate(rs.getString("bill_date"));
                bill.setActive(rs.getBoolean("is_active"));
                
                bills.add(bill);
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

        return bills;
    }

    /**
     * Get bills by payment status
     * @param status Payment status to filter by
     * @return List of BllBilling objects
     */
    public List<BllBilling> getBillsByStatus(String status) {
        List<BllBilling> bills = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return bills;
            }

            String sql = "SELECT bill_id, order_id, cpt_code, amount, payment_status, bill_date, is_active " +
                        "FROM bills WHERE payment_status = ? ORDER BY bill_date DESC";
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllBilling bill = new BllBilling();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setOrderId(rs.getInt("order_id"));
                bill.setCptCode(rs.getString("cpt_code"));
                bill.setAmount(rs.getDouble("amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setBillDate(rs.getString("bill_date"));
                bill.setActive(rs.getBoolean("is_active"));
                
                bills.add(bill);
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

        return bills;
    }

    /**
     * Get bill details by ID
     * @param billId Bill ID
     * @return BllBilling object or null if not found
     */
    public BllBilling getBillById(int billId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return null;
            }

            String sql = "SELECT bill_id, order_id, cpt_code, amount, payment_status, bill_date, is_active " +
                        "FROM bills WHERE bill_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, billId);
            rs = ps.executeQuery();

            if (rs.next()) {
                BllBilling bill = new BllBilling();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setOrderId(rs.getInt("order_id"));
                bill.setCptCode(rs.getString("cpt_code"));
                bill.setAmount(rs.getDouble("amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setBillDate(rs.getString("bill_date"));
                bill.setActive(rs.getBoolean("is_active"));
                
                return bill;
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
     * Update bill payment status
     * @param billId Bill ID
     * @param newStatus New payment status
     * @return Success or error message
     */
    public String updateBillStatus(int billId, String newStatus) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE bills SET payment_status = ? WHERE bill_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, billId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Bill status updated successfully!";
            } else {
                return "Bill not found.";
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
}