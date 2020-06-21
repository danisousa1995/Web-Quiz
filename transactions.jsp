<%-- 
    Document   : transactions
    Created on : 19/06/2020, 13:39:51
    Author     : danisousa
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="db.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page import="db.Transaction"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
    Exception requestException = null;
    if(request.getParameter("cancel")!=null){
        response.sendRedirect(request.getRequestURI());
    }
    if(request.getParameter("insert")!=null){
        try{
            String datetime = request.getParameter("datetime");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            double value = Double.parseDouble(request.getParameter("value"));
            String origin = request.getParameter("origin");
            Transaction.addTransaction(datetime, description, category, value, origin);
            response.sendRedirect(request.getRequestURI());
        }catch(Exception ex){
            requestException = ex;
        }
    }
    if(request.getParameter("update")!=null){
        try{
            long rowId = Long.parseLong(request.getParameter("rowid"));
            String datetime = request.getParameter("datetime");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            double value = Double.parseDouble(request.getParameter("value"));
            String origin = request.getParameter("origin");
            Transaction.updateTransaction(rowId, datetime, description, category, value, origin);
            response.sendRedirect(request.getRequestURI());
        }catch(Exception ex){
            requestException = ex;
        }
    }
    if(request.getParameter("delete")!=null){
        try{
            long rowId = Long.parseLong(request.getParameter("rowid"));
            Transaction.removeTransaction(rowId);
            response.sendRedirect(request.getRequestURI());
        }catch(Exception ex){
            requestException = ex;
        }
    }
    
    ArrayList<Category> categoriesList = new ArrayList<>();
    ArrayList<Transaction> list = new ArrayList<>();
    try{
        categoriesList = Category.getCategories();
        list = Transaction.getTransactions();
    }catch(Exception ex){
        requestException = ex;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Transações - FINANCY$</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/menu.jspf" %>
        <h2>Transações</h2>
        <%if(session.getAttribute("user.login") == null){%>
            <p>Você precisa estar logado para acessar o conteúdo desta página</p>
        <%}else{%>
            <%if(requestException!=null){%>
            <div style="color:red"><%= requestException.getMessage() %></div>
            <%}%>
            <%if(request.getParameter("prepareInsert")!=null){%>
                <form method="post">
                    <fieldset>
                        <legend>Nova transação</legend>
                        Data/hora: <input type="datetime-local" name="datetime"
                            value="<%= new SimpleDateFormat("yyyy-MM-dd'T'hh:mm").format(new Date()) %>"/>
                        Descrição: <input type="text" name="description"/>
                        Categoria: <select name="category">
                            <option value=""></option>
                            <%for(Category c: categoriesList){%>
                                <option value="<%= c.getName() %>"><%= c.getName() %></option>
                            <%}%>
                        </select>
                        Valor: <input type="number" step="0.01" name="value"/>
                        Estabelecimento: <input type="text" name="origin"/>
                        <input type="submit" name="insert" value="Incluir"/>
                        <input type="submit" name="cancel" value="Cancelar"/>
                    </fieldset>
                </form>
            <%}else if(request.getParameter("prepareUpdate")!=null){%>
                <form method="post">
                    <fieldset>
                        <% long rowId = Long.parseLong(request.getParameter("rowid")); %>
                        <% Transaction t = Transaction.getTransaction(rowId); %>
                        <legend>Alterar transação <%= request.getParameter("rowid") %></legend>
                        <input type="hidden" name="rowid" value="<%= request.getParameter("rowid") %>"/>
                        Data/hora: <input type="datetime-local" name="datetime" value="<%= t.getDatetime() %>"/>
                        Descrição: <input type="text" name="description" value="<%= t.getDescription() %>"/>
                        Categoria: <select name="category">
                            <option value=""></option>
                            <%for(Category c: categoriesList){%>
                            <option value="<%= c.getName() %>" <%= c.getName().equals(t.getCategory())?"selected":"" %>>
                                <%= c.getName() %>
                            </option>
                            <%}%>
                        </select>
                        Valor: <input type="number" step="0.01" name="value" value="<%= t.getValue() %>"/>
                        Estabelecimento: <input type="text" name="origin" value="<%= t.getOrigin() %>"/>
                        <input type="submit" name="update" value="Alterar"/>
                        <input type="submit" name="cancel" value="Cancelar"/>
                    </fieldset>
                </form>
            <%}else if(request.getParameter("prepareDelete")!=null){%>
                <form method="post">
                    <fieldset>
                        <% long rowId = Long.parseLong(request.getParameter("rowid")); %>
                        <% Transaction t = Transaction.getTransaction(rowId); %>
                        <legend>Excluir transação <%= request.getParameter("rowid") %></legend>
                        <input type="hidden" name="rowid" value="<%= request.getParameter("rowid") %>"/>
                        Data/hora: <b><%= t.getDatetime() %></b><br/>
                        Descrição: <b><%= t.getDescription() %></b><br/>
                        Categoria: <b><%= t.getCategory()%></b><br/>
                        Valor: <b><%= t.getValue() %></b><br/>
                        Estabelecimento: <b><%= t.getOrigin() %></b><br/>
                        Deseja realmente excluir a transação acima?
                        <input type="submit" name="delete" value="Remover"/>
                        <input type="submit" name="cancel" value="Cancelar"/>
                    </fieldset>
                </form>
            <%}else{%>
                <form method="post">
                    <input type="submit" name="prepareInsert" value="Incluir"/>
                </form>
            <%}%>
            <hr/>
            <table border="1">
                <tr>
                    <th>ID</th>
                    <th>Data/hora</th>
                    <th>Descrição</th>
                    <th>Categoria</th>
                    <th>Valor</th>
                    <th>Estabelecimento</th>
                    <th>Comandos</th>
                </tr>
                <%for(Transaction t: list){%>
                <tr>
                    <td><%= t.getRowId()%></td>
                    <td><%= t.getDatetime()%></td>
                    <td><%= t.getDescription()%></td>
                    <td><%= t.getCategory()%></td>
                    <td><%= t.getValue() %></td>
                    <td><%= t.getOrigin() %></td>
                    <td>
                        <form method="post">
                            <input type="hidden" name="rowid" value="<%= t.getRowId() %>"/>
                            <input type="submit" name="prepareUpdate" value="Alterar"/>
                            <input type="submit" name="prepareDelete" value="Remover"/>
                        </form>
                    </td>
                </tr>
                <%}%>
            </table>
        <%}%>
    </body>
</html>
