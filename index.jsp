<%-- 
    Document   : index
    Created on : 19/06/2020, 13:49:36
    Author     : danisousa
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="web.DbListener"%>
<%@page import="db.User"%>
<%@page import="db.Player"%>
<%@page import="db.Db"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home - WebQuiz</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/menu.jspf" %>
        <h2>Início</h2>
        <p>
              <div class="col-md-6">
                <strong>Top 10</strong>
                <table class="table">
                    <thead>
                      <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Média</th>
                      </tr>
                    </thead>
                           <%int i =1; %>      
                    <tbody>
                        
                       <% for (Player p : Db.getPlayers()) { %>
                            <% if (i <= 10) {%>
                            <tr>    
                                <td><%= i++%>º</td>
                                <td><%= p.getName()%></td>
                                <td><%= p.getScore()%></td>
                            </tr>
                            <% } %>  
                            <%}%>
                    </tbody>
                  </table>
            </div>
            
            <div class="col-md-6">
            <strong>Historico</strong>
            <table class="table">
                <thead>
                    
                  <tr>
                    <th>Name</th>
                    <th>Score</th>
                    <th>Date</th>
                  </tr>
                </thead>
                <tbody>
                    <% DateFormat df = new SimpleDateFormat("dd/MM/yyyy");%>
                  <% for (Player p :Db.getPlayers()) {%>
                    <tr>
                        <td><%= p.getName()%></td>
                        <td><%= p.getScore()%></td>
                        <td><%= df.format(p.getData())%></td>
                    </tr>
                    <%}%>
                  </tr>
                </tbody>
              </table>
            </div>
        </div>
        </p>
    </body>
</html>
