<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.study.model1.reply.Reply" %>
<%@ page import="com.study.model1.reply.ReplyDAO" %>
<%@ page import="com.study.model1.board.BoardDAO" %>
<%@ page import="com.study.model1.board.Board" %>
<%@ page import="com.study.model1.files.FilesDAO" %>
<%@ page import="com.study.model1.files.Files" %>
<% request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
    <link rel="stylesheet" href="../../css/view.css">
    <title>게시판 - 보기</title>
</head>
<body>
<%
    int seq = Integer.valueOf(request.getParameter("seq"));
    BoardDAO boardDAO = new BoardDAO();
    Board board = boardDAO.getBoard(seq);
    String writer = board.getWriter();
    java.sql.Date postdate = board.getPostdate();
    String updatedate = String.valueOf(board.getUpdatedate());
    String category = board.getCategory();
    String title = board.getTitle();
    String content = board.getContent();

    if (updatedate == null) {
        updatedate = "";
    }
%>

<%

%>
<div>작성자: <%=writer%></div>
<div>작성일: <%=postdate%></div>
<div>수정일: <%=updatedate%></div>
<div>카테고리: <%=category%></div>
<div>제목: <%=title%></div>
<div>내용: <%=content%></div>
<% // 여러 파일 출력
    FilesDAO fileDAO = new FilesDAO();

    for (Files file : fileDAO.getFilesList(seq)) {
%>
<div><a href="filesAction.jsp?fileName=<%= file.getUploadedFileName()%>"><%=file.getFileName()%>
</a></div>
<%}%>
<div id="replyArea">
    <% // 댓글목록 출력
        ReplyDAO replyDAO = new ReplyDAO();

        for (Reply reply : replyDAO.getReplyList(seq)
        ) {
            out.println("<div>" + reply.getRegdate() + "</div>");
            out.println("<div>" + reply.getComment() + "</div>");
        }
    %>
    <form method="post" action="replyAction.jsp">
        <textarea name="comment" required></textarea>
        <input type="hidden" name="board_seq" value="<%= seq%>">
        <button type="submit">등록</button>
    </form>
</div>
<button>목록</button>
<button>수정</button>
<button>삭제</button>
</body>
</html>
