/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import db.Category;
import db.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Web application lifecycle listener.
 *
 * @author rlarg
 */
public class DbListener implements ServletContextListener {
    public static final String jdbcUrl = "jdbc:sqlite:C:\\Users\\danisousa\\fincansys.db";
    
    public static String exceptionMessage = null;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String step = "Database creation";
        try{
            Class.forName("org.sqlite.JDBC");
            Connection con = DriverManager.getConnection(jdbcUrl);
            Statement stmt = con.createStatement();
            
            step = "Table 'users' creation";
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users("
                    + "name VARCHAR(200) NOT NULL,"
                    + "login VARCHAR(20) PRIMARY KEY,"
                    + "password_hash LONG NOT NULL,"
                    + "role VARCHAR(20) NOT NULL"
                    + ")");
            
            if(User.getUsers().isEmpty()){
                step = "Default admin user creation";
                stmt.executeUpdate("INSERT INTO users(name, login, password_hash, role)"
                        + "VALUES ('Administrador', 'admin', "+"123456".hashCode()+", 'ADMIN')");
                step = "Default fulano user creation";
                stmt.executeUpdate("INSERT INTO users(name, login, password_hash, role)"
                        + "VALUES ('Fulano da Silva', 'fulano', "+"123456".hashCode()+", 'USER')");
            }
            
            step = "Table 'categories' creation";
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS categories("
                    + "name VARCHAR(50) PRIMARY KEY,"
                    + "description VARCHAR(200) NOT NULL"
                    + ")");
            if(Category.getCategories().isEmpty()){
                step = "Default categories creation";
                stmt.executeUpdate("INSERT INTO categories(name, description)"
                        + "VALUES ('Moradia', 'Gastos com aluguel, UPTU, luz, água, etc')");
                stmt.executeUpdate("INSERT INTO categories(name, description)"
                        + "VALUES ('Alimentação', 'Gatsos com mercado, restaurantes, etc')");
                stmt.executeUpdate("INSERT INTO categories(name, description)"
                        + "VALUES ('Educação', 'Gastos com formação profissional')");
                stmt.executeUpdate("INSERT INTO categories(name, description)"
                        + "VALUES ('Lazer', 'Gastos com viagens, baladas, hobbies, etc')");
                stmt.executeUpdate("INSERT INTO categories(name, description)"
                        + "VALUES ('Receita', 'Proventos de quaisquer tipos')");
            }
            
            step = "Table 'transactions' creation";
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS transactions("
                    + "datetime VARCHAR(25) PRIMARY KEY,"
                    + "description VARCHAR(200) NOT NULL,"
                    + "category VARCHAR(50) NOT NULL,"
                    + "value NUMERIC(10,2) NOT NULL,"
                    + "origin VARCHAR(200) NOT NULL,"
                    + "FOREIGN KEY(category) REFERENCES categories(name)"
                    + ")");
            
            stmt.close();
            con.close();
        }catch(Exception ex){
            exceptionMessage = step + ": " + ex.getMessage();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        
    }
}
