//package com.mycompany.pathology;
//
//import java.sql.*;
//import java.util.*;
//
//public class BllAdmin {
//    private Connection con;
//    
//    public BllAdmin() {
//        try {
//            con = DataAccess.getConnection();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//    
//    // Dashboard Statistics
//    public Map<String, Integer> getDashboardStats() {
//        Map<String, Integer> stats = new HashMap<>();
//        String query = "SELECT " +
//                      "(SELECT COUNT(*) FROM patients) as total_patients, " +
//                      "(SELECT COUNT(*) FROM orders WHERE status = 'PENDING') as pending_orders, " +
//                      "(SELECT COUNT(*) FROM orders WHERE status = 'COMPLETED') as completed_orders, " +
//                      "(SELECT COUNT(*) FROM billing WHERE status = 'PAID') as paid_bills";
//        
//        try (PreparedStatement ps = con.prepareStatement(query);
//             ResultSet rs = ps.executeQuery()) {
//            if (rs.next()) {
//                stats.put("total_patients", rs.getInt("total_patients"));
//                stats.put("pending_orders", rs.getInt("pending_orders"));
//                stats.put("completed_orders", rs.getInt("completed_orders"));
//                stats.put("paid_bills", rs.getInt("paid_bills"));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return stats;
//    }
//    
//    // Laboratory Management
//    public boolean addLaboratory(Laboratory lab) {
//        String query = "INSERT INTO laboratories (lab_name, lab_code, address, phone, email, contact_person) " +
//                      "VALUES (?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = con.prepareStatement(query)) {
//            ps.setString(1, lab.getLabName());
//            ps.setString(2, lab.getLabCode());
//            ps.setString(3, lab.getAddress());
//            ps.setString(4, lab.getPhone());
//            ps.setString(5, lab.getEmail());
//            ps.setString(6, lab.getContactPerson());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    public List<Laboratory> getAllLaboratories() {
//        List<Laboratory> labs = new ArrayList<>();
//        String query = "SELECT * FROM laboratories ORDER BY lab_name";
//        
//        try (PreparedStatement ps = con.prepareStatement(query);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Laboratory lab = new Laboratory();
//                lab.setLabId(rs.getInt("lab_id"));
//                lab.setLabName(rs.getString("lab_name"));
//                lab.setLabCode(rs.getString("lab_code"));
//                lab.setAddress(rs.getString("address"));
//                lab.setPhone(rs.getString("phone"));
//                lab.setEmail(rs.getString("email"));
//                lab.setContactPerson(rs.getString("contact_person"));
//                lab.setStatus(rs.getString("status"));
//                labs.add(lab);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return labs;
//    }
//    
//    // Physician Management
//    public boolean addPhysician(Physician physician) {
//        String query = "INSERT INTO physicians (first_name, last_name, npi_number, specialization, " +
//                      "email, phone, address, license_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = con.prepareStatement(query)) {
//            ps.setString(1, physician.getFirstName());
//            ps.setString(2, physician.getLastName());
//            ps.setString(3, physician.getNpiNumber());
//            ps.setString(4, physician.getSpecialization());
//            ps.setString(5, physician.getEmail());
//            ps.setString(6, physician.getPhone());
//            ps.setString(7, physician.getAddress());
//            ps.setString(8, physician.getLicenseNumber());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    // Test Management
//    public boolean addTest(Test test) {
//        String query = "INSERT INTO tests (test_name, loinc_code, snomed_code, category, " +
//                      "specimen_type, method, normal_range, unit, price, turnaround_time) " +
//                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = con.prepareStatement(query)) {
//            ps.setString(1, test.getTestName());
//            ps.setString(2, test.getLoincCode());
//            ps.setString(3, test.getSnomedCode());
//            ps.setString(4, test.getCategory());
//            ps.setString(5, test.getSpecimenType());
//            ps.setString(6, test.getMethod());
//            ps.setString(7, test.getNormalRange());
//            ps.setString(8, test.getUnit());
//            ps.setDouble(9, test.getPrice());
//            ps.setInt(10, test.getTurnaroundTime());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    // Order Management
//    public List<Order> getAllOrders() {
//        List<Order> orders = new ArrayList<>();
//        String query = "SELECT o.*, p.first_name, p.last_name, ph.first_name as phys_first, " +
//                      "ph.last_name as phys_last, l.lab_name FROM orders o " +
//                      "LEFT JOIN patients p ON o.patient_id = p.patient_id " +
//                      "LEFT JOIN physicians ph ON o.physician_id = ph.physician_id " +
//                      "LEFT JOIN laboratories l ON o.lab_id = l.lab_id " +
//                      "ORDER BY o.order_date DESC";
//        
//        try (PreparedStatement ps = con.prepareStatement(query);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Order order = new Order();
//                order.setOrderId(rs.getInt("order_id"));
//                order.setOrderNumber(rs.getString("order_number"));
//                order.setPatientName(rs.getString("first_name") + " " + rs.getString("last_name"));
//                order.setPhysicianName(rs.getString("phys_first") + " " + rs.getString("phys_last"));
//                order.setLabName(rs.getString("lab_name"));
//                order.setOrderDate(rs.getString("order_date"));
//                order.setStatus(rs.getString("status"));
//                order.setPriority(rs.getString("priority"));
//                order.setTotalAmount(rs.getDouble("total_amount"));
//                orders.add(order);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return orders;
//    }
//    
//    // Inventory Management
//    public boolean addInventoryItem(Inventory item) {
//        String query = "INSERT INTO inventory (item_name, item_code, category, description, " +
//                      "unit, current_stock, minimum_stock, maximum_stock, unit_cost, " +
//                      "supplier, expiry_date, storage_location) " +
//                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = con.prepareStatement(query)) {
//            ps.setString(1, item.getItemName());
//            ps.setString(2, item.getItemCode());
//            ps.setString(3, item.getCategory());
//            ps.setString(4, item.getDescription());
//            ps.setString(5, item.getUnit());
//            ps.setInt(6, item.getCurrentStock());
//            ps.setInt(7, item.getMinimumStock());
//            ps.setInt(8, item.getMaximumStock());
//            ps.setDouble(9, item.getUnitCost());
//            ps.setString(10, item.getSupplier());
//            ps.setDate(11, new java.sql.Date(item.getExpiryDate().getTime()));
//            ps.setString(12, item.getStorageLocation());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//    
//    public List<Inventory> getLowStockItems() {
//        List<Inventory> items = new ArrayList<>();
//        String query = "SELECT * FROM inventory WHERE current_stock <= minimum_stock AND status = 'ACTIVE'";
//        
//        try (PreparedStatement ps = con.prepareStatement(query);
//             ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Inventory item = new Inventory();
//                item.setItemId(rs.getInt("inventory_id"));
//                item.setItemName(rs.getString("item_name"));
//                item.setItemCode(rs.getString("item_code"));
//                item.setCurrentStock(rs.getInt("current_stock"));
//                item.setMinimumStock(rs.getInt("minimum_stock"));
//                item.setUnit(rs.getString("unit"));
//                items.add(item);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return items;
//    }
//}