<%@ page import="java.sql.*" %>
<%@ page import="com.study.connection.ConnectionMaria" %>
<%@ page import="com.study.model1.board.BoardDAO" %>
<%@ page import="com.study.model1.board.Board" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="../../css/list.css">
    <title>게시판 목록</title>
</head>

<body>
<%
    int pageNumber = 1;//기본적으로 1페이지
    if (request.getParameter("pageNumber") != null)
        pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
%>
<form method="post" name="search" action="search.jsp">
    <input type="text" id="startdate" name="startdate">
    <input type="text" id="enddate" name="enddate">
    <select name="category">
        <%
            BoardDAO boardDAO = new BoardDAO();
            for (String title : boardDAO.getCategory()) {
                out.println("<option value=\"" + title + "\">" + title + "</option>");
            }
        %>
    </select>
    <input type="text" id="searchinput" placeholder="검색어를 입력해주세요. (제목+작성자+내용)" name ="searchText">
    <button type="submit">검색</button>
</form>
<%

    int totalCount = boardDAO.getCount();


%>


<h2>게시물 총 수: <%= totalCount %>
</h2>
<table>
    <thead>

    </thead>
    <th>카테고리</th>
    <th>제목</th>
    <th>작성자</th>
    <th>조회수</th>
    <th>등록일시</th>
    <th>수정일시</th>
    <tbody>
    <%
        for (Board board : boardDAO.getList(pageNumber)){
    %>
    <tr>
        <td><%= board.getCategory()%>
        </td>
        <td><a href="/board/free/view.jsp?seq=<%= board.getSeq() %>"><%= board.getTitle()%></>
        </td>
        <td><%= board.getWriter()%>
        </td>
        <td><%= board.getViewcount()%>
        </td>
        <td><%= board.getPostdate()%>
        </td>
        <td><%= board.getUpdatedate()%>
        </td>
    </tr>
    <%}%>

    </tbody>
</table>
<button><a href="write.jsp">글쓰기</a></button>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.12.4.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0');
    var yyyy = today.getFullYear();

    today = yyyy + '-' + mm + '-' + dd;

    $(function () {
        $("#startdate").datepicker({dateFormat: "yy-mm-dd"});
        $("#startdate").datepicker("setDate", today);
        $("#enddate").datepicker({dateFormat: "yy-mm-dd"});
        $("#enddate").datepicker("setDate", today);
    });
</script>
</body>
</html>
