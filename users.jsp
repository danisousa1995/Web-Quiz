<%-- 
    Document   : index
    Created on : 01/06/2020, 13:49:36
    Author     : rlarg
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="db.Db"%>
<%@page import="db.Player"%>
<%@page import="java.text.DateFormat"%>
<%@page import="web.DbListener"%>
<%@page import="db.User"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Exception requestException = null;
    if(request.getParameter("insert")!=null){
        try{
            String name = request.getParameter("name");
            String login = request.getParameter("login");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            User.addUser(name, login, role, password);
            response.sendRedirect(request.getRequestURI());
        }catch(Exception ex){
            requestException = ex;
        }
    }
    if(request.getParameter("delete")!=null){
        try{
            String login = request.getParameter("login");
            User.removeUser(login);
            
            response.sendRedirect(request.getRequestURI());
        }catch(Exception ex){
            requestException = ex;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Web Quiz - Usuários</title>
    </head>
    <body>
        <%@include file="../WEB-INF/jspf/menu.jspf" %>
        <h2>Usuários</h2>
        <%if(session.getAttribute("user.login") != null){%>
            <%if(session.getAttribute("user.role").equals("ADMIN")){%>
                <fieldset>
                    <legend>Novo usuário</legend>
                    <%if(requestException!=null){%>
                    <div style="color:red"><%=requestException.getMessage()%></div>
                    <%}%>
                    <form method="post">
                        Nome: <input type="text" name="name"/>
                        Login: <input type="text" name="login"/>
                        Role: <select name="role">
                            <option value="USER">USER</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                        Password: <input type="password" name="password"/>
                        <input type="submit" name="insert" value="Inserir"/>
                    </form>
                </fieldset>
                <hr/>
                <%
                ArrayList<User> list = new ArrayList<>();
                try{
                    list = User.getUsers();
                }catch(Exception ex){
                    out.println("<h3>Erro: "+ex.getMessage()+"</h3>");
                }
                %>
                <table border="1">
                    <tr>
                        <th>Nome do usuário</th>
                        <th>Login</th>
                        <th>Role</th>
                        <th>Comandos</th>
                    </tr>
                    <%for(User u: list){%>
                    <tr>
                        <td><%= u.getName() %></td>
                        <td><%= u.getLogin() %></td>
                        <td><%= u.getRole() %></td>
                        <td>
                            <form method="post">
                                <input type="hidden" name="login" value="<%=u.getLogin()%>"/>
                                <input type="submit" name="delete" value="Remover"/>
                            </form>
                        </td>
                    </tr>
                    <%}%>
                </table>
            <%}else{%>
                <p>Você precisa ser administrador para acessar o conteúdo desta página</p>
            <%}%>
        <%}else{%>
            <p>Você precisa estar logado para acessar o conteúdo desta página</p>
        <%}%>
        
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