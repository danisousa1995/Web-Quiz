<%-- 
    Document   : me
    Created on : 19/06/2020, 14:53:45
    Author     : danisousa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Exception requestException = null;
    if(request.getParameter("changePassword")!=null){
        try{
            String login = request.getParameter("login");
            String password = request.getParameter("password");
            String new_password = request.getParameter("new_password");
            String new_password2 = request.getParameter("new_password2");
            if(User.login(login, password)==null){
                throw new Exception("Actual password incorrect");
            }else if(!new_password.equals(new_password2)){
                throw new Exception("Password confirmation incorrect");
            }else{
                User.changePassword(login, new_password);
            }
        }catch(Exception ex){
            requestException = ex;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Meu perfil - FINANCY$</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/menu.jspf" %>
        <h2>Meu perfil</h2>
        <%if(session.getAttribute("user.login") == null){%>
            <p>Você precisa estar logado para acessar o conteúdo desta página</p>
        <%}else{%>
            <h2>Login: <u><%= session.getAttribute("user.login") %></u></h2>
            <h2>Nome: <u><%= session.getAttribute("user.name") %></u></h2>
            <h2>Papel: <u><%= session.getAttribute("user.role") %></u></h2>
            <h2>Alteração de senha:</h2>
            <%if(requestException != null){%>
            <div style="color:red"><%=requestException.getMessage()%></div>
            <%}%>
            <form method="post">
                <input type="hidden" name="login" value="<%= session.getAttribute("user.login") %>"/>
                Senha atual: <br/>
                <input type="password" name="password"/> <br/>
                Nova senha: <br/>
                <input type="password" name="new_password"/> <br/>
                Confirmação da nova senha: <br/>
                <input type="password" name="new_password2"/> <br/>
                <br/><input type="submit" name="changePassword" value="Redefinir"/>
            </form>
        <%}%>
    </body>
</html>