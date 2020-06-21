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
public class User {
    private String name;
    private String login;
    private String role;
    
    public static ArrayList<User> getUsers() throws Exception{
        ArrayList<User> list = new ArrayList<>();
        Class.forName("org.sqlite.JDBC");
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users");
        while(rs.next()){
            list.add(
                    new User(
                            rs.getString("name"), 
                            rs.getString("login"),
                            rs.getString("role")
                    )
            );
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static User login(String login, String password) throws Exception {
        User output = null;
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "SELECT * FROM users WHERE login=? AND password_hash=?";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setString(1, login);
        stmt.setLong(2, password.hashCode());
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            output = new User(
                    rs.getString("name"), 
                    rs.getString("login"), 
                    rs.getString("role")
            );
        }else{
            output = null;
        }
        rs.close();
        stmt.close();
        con.close();
        return output;
    }
    
    public static void addUser(String name, String login, String role, String password) throws Exception{
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "INSERT INTO users(name, login, role, password_hash) VALUES(?,?,?,?)";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setString(1, name);
        stmt.setString(2, login);
        stmt.setString(3, role);
        stmt.setLong(4, password.hashCode());
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void removeUser(String login) throws Exception{
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "DELETE FROM users WHERE login=?";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setString(1, login);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void changePassword(String login, String new_password) throws Exception{
        Connection con = DriverManager.getConnection(DbListener.jdbcUrl);
        String SQL = "UPDATE users SET password_hash=? WHERE login=?";
        PreparedStatement stmt = con.prepareStatement(SQL);
        stmt.setLong(1, new_password.hashCode());
        stmt.setString(2, login);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public User(String name, String login, String role) {
        this.name = name;
        this.login = login;
        this.role = role;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
    
}