package com.mycompany.pathology;

import com.mycompany.lab.DataAccess;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Business Logic Layer for Inventory operations.
 * This class handles inventory management including CRUD operations.
 */
public class BllInventory {

    // --- Data Fields (acting as a model) ---
    private int inventoryId;
    private String itemName;
    private String lotNumber;
    private String expiryDate;
    private int quantity;
    private int labId;
    private String labName;
    private boolean isActive;

    // --- Getters and Setters for the data fields ---
    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getLotNumber() {
        return lotNumber;
    }

    public void setLotNumber(String lotNumber) {
        this.lotNumber = lotNumber;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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
     * Get all inventory items from the database
     * @return List of BllInventory objects
     */
    public List<BllInventory> getAllInventory() {
        List<BllInventory> inventoryItems = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return inventoryItems;
            }

            String sql = "SELECT i.inventory_id, i.item_name, i.lot_number, i.expiry_date, i.quantity, i.lab_id, l.lab_name, i.is_active " +
                        "FROM inventory i " +
                        "LEFT JOIN laboratories l ON i.lab_id = l.lab_id " +
                        "ORDER BY i.item_name";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllInventory item = new BllInventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setItemName(rs.getString("item_name"));
                item.setLotNumber(rs.getString("lot_number"));
                item.setExpiryDate(rs.getString("expiry_date"));
                item.setQuantity(rs.getInt("quantity"));
                item.setLabId(rs.getInt("lab_id"));
                item.setLabName(rs.getString("lab_name"));
                item.setActive(rs.getBoolean("is_active"));
                
                inventoryItems.add(item);
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

        return inventoryItems;
    }

    /**
     * Get inventory items that are expiring soon (within 30 days)
     * @return List of expiring inventory items
     */
    public List<BllInventory> getExpiringInventory() {
        List<BllInventory> expiringItems = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return expiringItems;
            }

            String sql = "SELECT i.inventory_id, i.item_name, i.lot_number, i.expiry_date, i.quantity, i.lab_id, l.lab_name, i.is_active " +
                        "FROM inventory i " +
                        "LEFT JOIN laboratories l ON i.lab_id = l.lab_id " +
                        "WHERE i.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) " +
                        "AND i.is_active = true " +
                        "ORDER BY i.expiry_date";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                BllInventory item = new BllInventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setItemName(rs.getString("item_name"));
                item.setLotNumber(rs.getString("lot_number"));
                item.setExpiryDate(rs.getString("expiry_date"));
                item.setQuantity(rs.getInt("quantity"));
                item.setLabId(rs.getInt("lab_id"));
                item.setLabName(rs.getString("lab_name"));
                item.setActive(rs.getBoolean("is_active"));
                
                expiringItems.add(item);
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

        return expiringItems;
    }

    /**
     * Add a new inventory item
     * @param itemName Item name
     * @param lotNumber Lot number
     * @param expiryDate Expiry date
     * @param quantity Quantity
     * @param labId Laboratory ID
     * @return Success or error message
     */
    public String addInventory(String itemName, String lotNumber, String expiryDate, int quantity, int labId) {
        if (itemName == null || itemName.trim().isEmpty()) {
            return "Item name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "INSERT INTO inventory (item_name, lot_number, expiry_date, quantity, lab_id, is_active) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, itemName);
            ps.setString(2, lotNumber);
            ps.setString(3, expiryDate);
            ps.setInt(4, quantity);
            ps.setInt(5, labId);
            ps.setBoolean(6, true);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Inventory item added successfully!";
            } else {
                return "Failed to add inventory item.";
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
     * Update an existing inventory item
     * @param inventoryId Inventory ID
     * @param itemName Item name
     * @param lotNumber Lot number
     * @param expiryDate Expiry date
     * @param quantity Quantity
     * @param labId Laboratory ID
     * @return Success or error message
     */
    public String updateInventory(int inventoryId, String itemName, String lotNumber, String expiryDate, int quantity, int labId) {
        if (itemName == null || itemName.trim().isEmpty()) {
            return "Item name is required.";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE inventory SET item_name = ?, lot_number = ?, expiry_date = ?, quantity = ?, lab_id = ? WHERE inventory_id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, itemName);
            ps.setString(2, lotNumber);
            ps.setString(3, expiryDate);
            ps.setInt(4, quantity);
            ps.setInt(5, labId);
            ps.setInt(6, inventoryId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Inventory item updated successfully!";
            } else {
                return "No changes made or item not found.";
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
     * Delete an inventory item (soft delete)
     * @param inventoryId Inventory ID
     * @return Success or error message
     */
    public String deleteInventory(int inventoryId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return "Database connection failed.";
            }

            String sql = "UPDATE inventory SET is_active = false WHERE inventory_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, inventoryId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                return "Inventory item deactivated successfully!";
            } else {
                return "Inventory item not found.";
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
     * Get a single inventory item by ID
     * @param inventoryId Inventory ID
     * @return BllInventory object or null if not found
     */
    public BllInventory getInventoryById(int inventoryId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) {
                return null;
            }

            String sql = "SELECT i.inventory_id, i.item_name, i.lot_number, i.expiry_date, i.quantity, i.lab_id, l.lab_name, i.is_active " +
                        "FROM inventory i " +
                        "LEFT JOIN laboratories l ON i.lab_id = l.lab_id " +
                        "WHERE i.inventory_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, inventoryId);
            rs = ps.executeQuery();

            if (rs.next()) {
                BllInventory item = new BllInventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setItemName(rs.getString("item_name"));
                item.setLotNumber(rs.getString("lot_number"));
                item.setExpiryDate(rs.getString("expiry_date"));
                item.setQuantity(rs.getInt("quantity"));
                item.setLabId(rs.getInt("lab_id"));
                item.setLabName(rs.getString("lab_name"));
                item.setActive(rs.getBoolean("is_active"));
                
                return item;
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