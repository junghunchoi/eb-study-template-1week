<%@ page import="com.study.connection.ConnectionMaria" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %>
</h1>
<br/>
<a href="hello-servlet">Hello Servlet</a>


<%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        con = ConnectionMaria.getConnection();
        stmt = con.createStatement();
        String sql = "SELECT * FROM board;";
        rs = stmt.executeQuery(sql);

        while (rs.next()) {
            out.println(rs.toString());
            out.println(rs.getString("title") + "<br>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }finally {
		ConnectionMaria.close(con,stmt,rs);
    }

%>

</body>
</html>
