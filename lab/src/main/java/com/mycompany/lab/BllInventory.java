package com.mycompany.lab;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BllInventory {

    // Inner class for Inventory Items
    public static class InventoryItem {
        public int itemId;
        public String itemName;
        public String labName; // Joined from laboratories table
        public int labId;      // For editing
        public String lotNumber;
        public String expiryDate; // Formatted as yyyy-MM-dd for input type="date"
        public int quantity;
    }

    // Inner class for Lab Dropdown (Simple ID/Name pair)
    public static class LabOption {
        public int labId;
        public String labName;
        public LabOption(int id, String name) {
            this.labId = id;
            this.labName = name;
        }
    }

    // ✅ GET ALL INVENTORY (With Join to Lab Name)
    public List<InventoryItem> getAllInventory() {
        List<InventoryItem> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return list;

            String sql = "SELECT i.item_id, i.item_name, i.lab_id, l.lab_name, " +
                         "i.lot_number, i.expiry_date, i.quantity " +
                         "FROM inventory i " +
                         "JOIN laboratories l ON i.lab_id = l.lab_id " +
                         "ORDER BY i.expiry_date ASC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                InventoryItem item = new InventoryItem();
                item.itemId = rs.getInt("item_id");
                item.itemName = rs.getString("item_name");
                item.labId = rs.getInt("lab_id");
                item.labName = rs.getString("lab_name");
                item.lotNumber = rs.getString("lot_number");
                
                // Format date for HTML input
                java.sql.Date sqlDate = rs.getDate("expiry_date");
                item.expiryDate = (sqlDate != null) ? sqlDate.toString() : "";
                
                item.quantity = rs.getInt("quantity");
                list.add(item);
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

    // ✅ GET LABS (For Dropdown)
    public List<LabOption> getAllLabs() {
        List<LabOption> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            String sql = "SELECT lab_id, lab_name FROM laboratories";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new LabOption(rs.getInt("lab_id"), rs.getString("lab_name")));
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

    // ✅ GET ITEM BY ID
    public InventoryItem getItemById(int id) {
        InventoryItem item = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DataAccess.getConnection();
            String sql = "SELECT * FROM inventory WHERE item_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                item = new InventoryItem();
                item.itemId = rs.getInt("item_id");
                item.itemName = rs.getString("item_name");
                item.labId = rs.getInt("lab_id");
                item.lotNumber = rs.getString("lot_number");
                java.sql.Date sqlDate = rs.getDate("expiry_date");
                item.expiryDate = (sqlDate != null) ? sqlDate.toString() : "";
                item.quantity = rs.getInt("quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return item;
    }

    // ✅ ADD INVENTORY
    public String addInventory(String itemName, int labId, String lotNumber, String expiryDate, int quantity) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "INSERT INTO inventory (item_name, lab_id, lot_number, expiry_date, quantity) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, itemName);
            ps.setInt(2, labId);
            ps.setString(3, lotNumber);
            ps.setString(4, expiryDate);
            ps.setInt(5, quantity);

            int rows = ps.executeUpdate();
            if (rows > 0) return "Inventory item added successfully.";
            return "Failed to add item.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ UPDATE INVENTORY
    public String updateInventory(int itemId, String itemName, int labId, String lotNumber, String expiryDate, int quantity) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "UPDATE inventory SET item_name=?, lab_id=?, lot_number=?, expiry_date=?, quantity=? WHERE item_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, itemName);
            ps.setInt(2, labId);
            ps.setString(3, lotNumber);
            ps.setString(4, expiryDate);
            ps.setInt(5, quantity);
            ps.setInt(6, itemId);

            int rows = ps.executeUpdate();
            if (rows > 0) return "Inventory item updated successfully.";
            return "Item not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // ✅ DELETE INVENTORY
    public String deleteInventory(int itemId) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DataAccess.getConnection();
            if (con == null) return "Database connection failed.";

            String sql = "DELETE FROM inventory WHERE item_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, itemId);

            int rows = ps.executeUpdate();
            if (rows > 0) return "Item deleted successfully.";
            return "Item not found.";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}