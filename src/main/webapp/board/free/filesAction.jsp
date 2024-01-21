<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String fileName = request.getParameter("fileName");

    String filePath = "C:\\ebsoft\\src\\main\\webapp\\uploads\\"+fileName;
    File file = new File(filePath);
    response.setContentType("application/octet-stream");
    response.setContentLength((int) file.length());

    // 파일 다운로드를 위한 응답 헤더 설정
    String headerKey = "Content-Disposition";
    String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
    response.setHeader(headerKey, headerValue);

    // 파일 데이터를 클라이언트에 전송
    FileInputStream fileInputStream = new FileInputStream(file);
    OutputStream outStream = response.getOutputStream();
    byte[] buffer = new byte[4096];
    int bytesRead = -1;

    while ((bytesRead = fileInputStream.read(buffer)) != -1) {
        outStream.write(buffer, 0, bytesRead);
    }

    fileInputStream.close();
    outStream.close();
%>
</body>
</html>
