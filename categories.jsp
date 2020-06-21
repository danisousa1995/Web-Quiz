<%-- 
    Document   : me
    Created on : 08/06/2020, 14:53:45
    Author     : rlarg
--%>

<%@page import="db.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
    Exception requestException = null;
    if(request.getParameter("insert")!=null){
        try{
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            Category.addCategory(name, description);
            response.sendRedirect(request.getRequestURI());
        }catch(Exception ex){
            requestException = ex;
        }
    }
    if(request.getParameter("delete")!=null){
        try{
            String name = request.getParameter("name");
            Category.removeCategory(name);
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
        <title>Categorias - FINANCY$</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/menu.jspf" %>
        <h2>Categorias</h2>
        <%if(session.getAttribute("user.login") == null){%>
            <p>Você precisa estar logado para acessar o conteúdo desta página</p>
        <%}else{%>
            <fieldset>
                <legend>Nova categoria</legend>
                <%if(requestException!=null){%>
                <div style="color:red"><%=requestException.getMessage()%></div>
                <%}%>
                <form method="post">
                    Nome: <input type="text" name="name"/>
                    Descrição: <input type="text" name="description"/>
                    <input type="submit" name="insert" value="Inserir"/>
                </form>
            </fieldset>
            <hr/>
            <%
                ArrayList<Category> list = new ArrayList<>();
                try{
                    list = Category.getCategories();
                }catch(Exception ex){
                    out.println("<h3>Erro: "+ex.getMessage()+"</h3>");
                }
            %>
            <table border="1">
                <tr>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Comandos</th>
                </tr>
                <%for(Category c: list){%>
                <tr>
                    <td><%= c.getName() %></td>
                    <td><%= c.getDescription()%></td>
                    <td>
                        <form method="post">
                            <input type="hidden" name="name" value="<%=c.getName()%>"/>
                            <input type="submit" name="delete" value="Remover"/>
                        </form>
                    </td>
                </tr>
                <%}%>
            </table>
        <%}%>
    </body>
</html>