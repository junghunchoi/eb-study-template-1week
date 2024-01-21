package com.study.model1.files;

import java.sql.*;
import java.util.ArrayList;

public class FilesDAO {
	private Connection conn;
	private ResultSet rs;

	public FilesDAO() {
		try {
			final String DB_URL = "jdbc:mysql://localhost:3306/ebrainsoft_study";
			final String USER = "ebsoft";
			final String PASS = "ebsoft";

			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(DB_URL, USER, PASS);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	public int insertFiles(ArrayList<Files> files, int board_seq){
		String INSERT_FILES_SQL = "INSERT INTO files (uploadedFileName, fileType, fileSize, filePath, uploadedDate, board_seq, fileName) VALUES (?, ?, ?, ?, ?, ?, ?);";

		try (
		     PreparedStatement preparedStatement = conn.prepareStatement(INSERT_FILES_SQL)) {

			for (Files file : files) {
				preparedStatement.setString(1, file.getUploadedFileName());
				preparedStatement.setString(2, file.getFileType());
				preparedStatement.setInt(3, file.getFileSize());
				preparedStatement.setString(4, file.getFilePath());
				preparedStatement.setDate(5, file.getUploadedDate());
				preparedStatement.setInt(6, board_seq);
				preparedStatement.setString(7, file.getFileName());
				preparedStatement.addBatch(); // 쿼리를 배치에 추가
			}

			preparedStatement.executeBatch(); // 배치 실행
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return -1;

	}

	public ArrayList<Files> getFilesList(int board_seq) {
		String SQL = "SELECT * FROM files WHERE board_seq =?";
		ArrayList<Files> filesList = new ArrayList<>();

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, board_seq);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				Files file = new Files();
				file.setFileName(rs.getString("filename"));
				file.setUploadedFileName(rs.getString("uploadedFileName"));
				filesList.add(file);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return filesList;
	}
}
