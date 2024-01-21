<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.study.model1.board.BoardDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 등록</title>
</head>
<body>

<div class="container">
    <div class="row">
        <form method="post" action="writeAction.jsp" enctype="multipart/form-data">
            <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                <thead>
                <tr>
                    <select name="category">
                        <%
                            BoardDAO boardDAO = new BoardDAO();
                            for (String title : boardDAO.getCategory()) {
                                out.println("<option value=\"" + title + "\">" + title + "</option>");
                            }
                        %>
                    </select>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><input type="text" class="form-control" placeholder="작성자" name="writer" maxlength="50"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="비밀번호" name="password" maxlength="50"></td>
                    <td><input type="text" class="form-control" placeholder="비밀번호 확인" name="passwordCheck" maxlength="50"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="제목" name="title" maxlength="50"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="내용" name="content" maxlength="50"></td>
                </tr>
                <tr>
                    <td><input type="file" class="form-control" placeholder="파일첨부" name="firstFile" maxlength="50"></td>
                    <td><input type="file" class="form-control" placeholder="파일첨부" name="secondFile" maxlength="50"></td>
                    <td><input type="file" class="form-control" placeholder="파일첨부" name="thirdFile" maxlength="50"></td>
                </tr>
                </tbody>
            </table>
            <input type="submit" class="btn btn-success pull-right" value="글쓰기">
        </form>
    </div>
</div>
<div>
    <button><a href="list.jsp">취소</a></button>
    <button><a href="writeAction.jsp">저장</a></button>
</div>
</body>
</html>