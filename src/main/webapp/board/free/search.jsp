<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.study.model1.board.Board" %>
<%@ page import="com.study.model1.board.BoardDAO" %>
<%@ page import="java.lang.reflect.Array" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
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
    <select name="categoryselect" name="category">
        <%
            BoardDAO boardDAO = new BoardDAO();
            for (String title : boardDAO.getCategory()) {
                out.println("<option value=\"" + title + "\">" + title + "</option>");
            }
        %>
    </select>
    <input type="text" id="searchinput" placeholder="검색어를 입력해주세요. (제목+작성자+내용)" name="searchText">
    <button type="submit">검색</button>
</form>

<%
    String startDate = request.getParameter("startdate");
    String endDate = request.getParameter("enddate");
    String category = request.getParameter("category");
    String searchText = request.getParameter("searchText");

    ArrayList<Board> boardList = boardDAO.getSearch(startDate, endDate, category, searchText);
%>
<h2><%= startDate + " " + endDate + " " + category + " " + searchText%>
</h2>
<h2>게시물 총 수: <%= boardList.size() %>
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
        int count = 0;
        for (Board board : boardList) {
            if (count >= 10) break;
    %>
    <tr>
        <td><%= board.getCategory()%>
        </td>
        <td><%= board.getTitle()%>
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
    <%
            count++;
        }%>

    </tbody>
</table>

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
