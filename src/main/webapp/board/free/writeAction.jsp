<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.study.model1.board.BoardDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.study.model1.files.Files" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.UUID" %>
<%@ page import="com.study.model1.files.FilesDAO" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<% request.setCharacterEncoding("UTF-8"); %>


<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String category = "";
    String writer = "";
    String password = "";
    String passwordCheck = "";
    String title = "";
    String content = "";
    int board_seq = 0;


    String realPath = "C:\\ebsoft\\src\\main\\webapp\\uploads";
    ArrayList<Files> filesList = new ArrayList<>();
    FilesDAO filesDAO = new FilesDAO();
    PrintWriter script = response.getWriter();

    if (ServletFileUpload.isMultipartContent(request)) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setRepository(new File(realPath));
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            List<FileItem> formItems = upload.parseRequest(request);

            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {

                    if (!item.isFormField()) { // 파일 처리
                        String fileName = item.getName();
                        if (fileName.equals("")) continue;
                        Files file = new Files();
                        long fileSize = item.getSize();
                        String fileType = FilenameUtils.getExtension(fileName);
                        String uuid = UUID.randomUUID().toString();
                        String separator = File.separator;

                        file.setFileName(fileName);
                        file.setFileType(fileType);
                        file.setFileSize((int) fileSize);
                        file.setFilePath(realPath + "." + fileType);
                        file.setUploadedFileName(uuid+"."+fileType);
						file.setUploadedDate(Date.valueOf(LocalDate.now()));

                        File uploadFile = new File(realPath + separator + uuid + "." + fileType);
                        item.write(uploadFile);

                        filesList.add(file);
                    } else { // 일반 text 항목
                        String fieldName = item.getFieldName();
                        String fieldValue = item.getString("UTF-8"); // 문자 인코딩 지정

                        if ("category".equals(fieldName)) {
                            category = fieldValue;
                        } else if ("writer".equals(fieldName)) {
                            writer = fieldValue;
                        } else if ("password".equals(fieldName)) {
                            password = fieldValue;
                        } else if ("passwordCheck".equals(fieldName)) {
                            passwordCheck = fieldValue;
                        } else if ("title".equals(fieldName)) {
                            title = fieldValue;
                        } else if ("content".equals(fieldName)) {
                            content = fieldValue;
                        }
                    }
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    if (category == null || password == null || passwordCheck == null || title == null || content == null) {
        script.println("<script>");
        script.println("alert('입력이 안 된 사항이 있습니다.')");
        script.println("history.back()");
        script.println("</script>");
    } else if (!password.equals(passwordCheck)) {
        script.println("<script>");
        script.println("alert('비밀번호를 다시 한번 확인해주세요')");
        script.println("history.back()");
        script.println("</script>");
    } else {
        BoardDAO boardDAO = new BoardDAO();//하나의 인스턴스
        board_seq = boardDAO.write(title, writer, content, category, password);

        script.println("<script>");
        script.println("location.href='/board/free/list.jsp'");
        script.println("</script>");

    }

    filesDAO.insertFiles(filesList, board_seq);


%>

</body>
</html>
