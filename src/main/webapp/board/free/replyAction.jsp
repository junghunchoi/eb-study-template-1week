<%@ page import="com.study.model1.reply.ReplyDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    int board_seq = Integer.parseInt(request.getParameter("board_seq"));
	String comment = request.getParameter("comment");

    ReplyDAO replyDAO = new ReplyDAO();

    int result = replyDAO.insertReply(board_seq, comment);

    if (result > 0) {
        out.println("<script>alert('댓글이 등록되었습니다'); location.href='view.jsp?seq=" + board_seq + "'</script>");
    } else {
        out.println("<script>alert('댓글 등록에 실패하였습니다.'); history.go(-1);</script>");
    }
%>
</body>
</html>
