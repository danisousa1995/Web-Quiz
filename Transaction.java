/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import web.DbListener;

/**
 *
 * @author rlarg
 */
public class Transaction {
    private long rowId;
    private String datetime;
    private String description;
    private String category;
    private double value;
    private String origin;
    
    public static ArrayList<Transaction> getTransactions() throws Exception{
        ArrayList<Transaction> list = new ArrayList<>();
        Class.forName("org.sqlite.JDBC");
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT rowid, * FROM transactions");
        while(rs.next()){
            list.add(
                    new Transaction(
                            rs.getLong("rowid"),
                            rs.getString("datetime"),
                            rs.getString("description"),
                            rs.getString("category"),
                            rs.getDouble("value"),
                            rs.getString("origin")
                    )
            );
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static Transaction getTransaction(long rowId) throws Exception {
        Transaction output = null;
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "SELECT rowid, * FROM transactions WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setLong(1, rowId);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            output = new Transaction(
                            rs.getLong("rowid"),
                            rs.getString("datetime"),
                            rs.getString("description"),
                            rs.getString("category"),
                            rs.getDouble("value"),
                            rs.getString("origin")
                    );
        }else{
            output = null;
        }
        rs.close();
        stmt.close();
        con.close();
        return output;
    }
    
    public static void addTransaction(String datetime, String description, String category, double value, String origin) throws Exception{
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "INSERT INTO transactions(datetime,description,category,value,origin) VALUES(?,?,?,?,?)";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setString(1, datetime);
        stmt.setString(2, description);
        stmt.setString(3, category);
        stmt.setDouble(4, value);
        stmt.setString(5, origin);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void updateTransaction(long rowId, String datetime, String description, String category, double value, String origin) throws Exception{
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "UPDATE transactions SET "
                + "datetime=?,description=?,category=?,value=?,origin=? "
                + "WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setString(1, datetime);
        stmt.setString(2, description);
        stmt.setString(3, category);
        stmt.setDouble(4, value);
        stmt.setString(5, origin);
        stmt.setLong(6, rowId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void removeTransaction(long rowId) throws Exception{
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "DELETE FROM transactions WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setLong(1, rowId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Transaction(long rowId, String datetime, String description, String category, double value, String origin) {
        this.rowId = rowId;
        this.datetime = datetime;
        this.description = description;
        this.category = category;
        this.value = value;
        this.origin = origin;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public long getRowId() {
        return rowId;
    }

    public void setRowId(long rowId) {
        this.rowId = rowId;
    }

    public String getDatetime() {
        return datetime;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }
    
}