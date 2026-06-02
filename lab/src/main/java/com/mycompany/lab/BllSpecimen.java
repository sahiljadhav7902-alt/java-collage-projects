package com.mycompany.lab;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BllSpecimen {

    // =====================================================
    // INNER CLASS (ADMIN VIEW)
    // =====================================================
    public static class SpecimenInfo {
        public int specimenId;
        public int orderId;
        public String specimenBarcode;
        public String specimenType;
        public String collectionTime;
        public String receivedTime;
        public String status;
        public String technicianId;
        public String patientName;
    }

    // =====================================================
    // GET ALL SPECIMENS (ADMIN PANEL)
    // =====================================================
    public List<SpecimenInfo> getAllSpecimens() {

        List<SpecimenInfo> list = new ArrayList<>();

        try (Connection con = DataAccess.getConnection()) {

            String sql =
                "SELECT s.specimen_id, s.order_id, s.specimen_barcode, s.specimen_type, " +
                "s.collection_time, s.received_time, s.status, s.technician_id, " +
                "CONCAT(p.first_name,' ',p.last_name) AS patient_name " +
                "FROM specimens s " +
                "JOIN orders o ON s.order_id = o.order_id " +
                "JOIN users p ON o.patient_id = p.user_id " +
                "ORDER BY s.collection_time DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SpecimenInfo info = new SpecimenInfo();
                info.specimenId = rs.getInt("specimen_id");
                info.orderId = rs.getInt("order_id");
                info.specimenBarcode = rs.getString("specimen_barcode");
                info.specimenType = rs.getString("specimen_type");
                info.collectionTime = rs.getString("collection_time");
                info.receivedTime = rs.getString("received_time");
                info.status = rs.getString("status");
                info.technicianId = rs.getString("technician_id");
                info.patientName = rs.getString("patient_name");
                list.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =====================================================
    // GET SPECIMEN BY ID
    // =====================================================
    public SpecimenInfo getSpecimenById(int id) {

        SpecimenInfo info = null;

        try (Connection con = DataAccess.getConnection()) {

            String sql = "SELECT * FROM specimens WHERE specimen_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                info = new SpecimenInfo();
                info.specimenId = rs.getInt("specimen_id");
                info.orderId = rs.getInt("order_id");
                info.specimenBarcode = rs.getString("specimen_barcode");
                info.specimenType = rs.getString("specimen_type");
                info.collectionTime = rs.getString("collection_time");
                info.receivedTime = rs.getString("received_time");
                info.status = rs.getString("status");
                info.technicianId = rs.getString("technician_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return info;
    }

    // =====================================================
    // ADD SPECIMEN
    // =====================================================
    public String addSpecimen(int orderId, String barcode,
                              String type, String collectionTime) {

        try (Connection con = DataAccess.getConnection()) {

            String sql =
                "INSERT INTO specimens " +
                "(order_id, specimen_barcode, specimen_type, collection_time, status) " +
                "VALUES (?, ?, ?, ?, 'Collected')";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);
            ps.setString(2, barcode);
            ps.setString(3, type);
            ps.setString(4, collectionTime);

            int rows = ps.executeUpdate();

            if (rows > 0)
                return "Specimen registered successfully.";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }

        return "Failed to add specimen.";
    }

    // =====================================================
    // UPDATE SPECIMEN (TRACKING PAGE)
    // =====================================================
// =====================================================
// UPDATE SPECIMEN (WITH ORDER WORKFLOW SYNC)
// =====================================================
public String updateSpecimen(int specimenId, String status,
                             String receivedTime, String technicianId) {

    try (Connection con = DataAccess.getConnection()) {

        con.setAutoCommit(false);   // 🔥 Transaction Start

        // 1️⃣ Update specimen
        String sql =
            "UPDATE specimens SET status=?, received_time=?, technician_id=? " +
            "WHERE specimen_id=?";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, status);
        ps.setString(2, receivedTime);

        if (technicianId != null && !technicianId.isEmpty())
            ps.setInt(3, Integer.parseInt(technicianId));
        else
            ps.setNull(3, Types.INTEGER);

        ps.setInt(4, specimenId);

        int rows = ps.executeUpdate();

        if (rows == 0) {
            con.rollback();
            return "Specimen not found.";
        }

        // 2️⃣ Get order_id for this specimen
        String getOrderSql = "SELECT order_id FROM specimens WHERE specimen_id=?";
        PreparedStatement orderPs = con.prepareStatement(getOrderSql);
        orderPs.setInt(1, specimenId);
        ResultSet rs = orderPs.executeQuery();

        int orderId = 0;
        if (rs.next()) {
            orderId = rs.getInt("order_id");
        }

        // 3️⃣ Derive ORDER STATUS from specimen status
        String orderStatus = null;

        if (status.equals("Collected")) {
            orderStatus = "Collected";
        } 
        else if (status.equals("Processing")) {
            orderStatus = "Processing";
        }

        if (orderStatus != null) {
            String updateOrderSql =
                "UPDATE orders SET status=? WHERE order_id=?";
            PreparedStatement updateOrderPs =
                con.prepareStatement(updateOrderSql);

            updateOrderPs.setString(1, orderStatus);
            updateOrderPs.setInt(2, orderId);
            updateOrderPs.executeUpdate();
        }

        con.commit();   // 🔥 Transaction Commit
        return "SUCCESS: Specimen tracking updated.";

    } catch (Exception e) {
        e.printStackTrace();
        return "ERROR: " + e.getMessage();
    }
}

    // =====================================================
    // 🔥 WORKFLOW SYNC METHOD (VERY IMPORTANT)
    // =====================================================
    public String updateSpecimenStatusByOrder(int orderId, String status) {

        try (Connection con = DataAccess.getConnection()) {

            String sql =
                "UPDATE specimens SET status=? WHERE order_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);

            int rows = ps.executeUpdate();

            if (rows > 0)
                return "Specimen status updated to " + status;

        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }

        return "Specimen not found.";
    }

    // =====================================================
    // INNER CLASS (PATIENT VIEW)
    // =====================================================
    public static class PatientSpecimenInfo {
        public int specimenId;
        public int orderId;
        public String specimenBarcode;
        public String specimenType;
        public String collectionTime;
        public String receivedTime;
        public String status;
    }

    // =====================================================
    // GET SPECIMENS BY PATIENT
    // =====================================================
    public List<PatientSpecimenInfo> getSpecimensByPatient(int patientId) {

        List<PatientSpecimenInfo> list = new ArrayList<>();

        try (Connection con = DataAccess.getConnection()) {

            String sql =
                "SELECT s.specimen_id, s.order_id, s.specimen_barcode, " +
                "s.specimen_type, s.collection_time, s.received_time, s.status " +
                "FROM specimens s " +
                "JOIN orders o ON s.order_id = o.order_id " +
                "WHERE o.patient_id=? " +
                "ORDER BY s.collection_time DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PatientSpecimenInfo info = new PatientSpecimenInfo();
                info.specimenId = rs.getInt("specimen_id");
                info.orderId = rs.getInt("order_id");
                info.specimenBarcode = rs.getString("specimen_barcode");
                info.specimenType = rs.getString("specimen_type");
                info.collectionTime = rs.getString("collection_time");
                info.receivedTime = rs.getString("received_time");
                info.status = rs.getString("status");
                list.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // =====================================================
// GET AVAILABLE ORDERS FOR DROPDOWN
// =====================================================
public List<SpecimenInfo> getAvailableOrders() {

    List<SpecimenInfo> list = new ArrayList<>();

    try (Connection con = DataAccess.getConnection()) {

        String sql =
            "SELECT o.order_id, CONCAT(u.first_name,' ',u.last_name) AS patient_name " +
            "FROM orders o " +
            "JOIN users u ON o.patient_id = u.user_id " +
            "WHERE o.status='Ordered' OR o.status='Collected' " +
            "ORDER BY o.order_id DESC";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            SpecimenInfo info = new SpecimenInfo();
            info.orderId = rs.getInt("order_id");
            info.patientName = rs.getString("patient_name");
            list.add(info);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
}