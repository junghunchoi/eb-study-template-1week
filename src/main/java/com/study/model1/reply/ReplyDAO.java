package com.study.model1.reply;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;

public class ReplyDAO {

	private Connection conn;
	private ResultSet rs;

	public ReplyDAO() {
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

	public int insertReply(int board_seq, String comment) {
		String SQL = "INSERT INTO reply (board_seq, comment, regdate) values(?, ?, ?) ";

		try {
			PreparedStatement preparedStatement = conn.prepareStatement(SQL);

			preparedStatement.setInt(1, board_seq);
			preparedStatement.setString(2, comment);
			preparedStatement.setDate(3, Date.valueOf(LocalDate.now()));

			preparedStatement.executeUpdate();
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return -1;
	}

	public ArrayList<Reply> getReplyList(int board_seq) {
		String SQL = "SELECT * FROM reply where board_seq = ?";
		ArrayList<Reply> replyList = new ArrayList<>();

		try {
			PreparedStatement preparedStatement = conn.prepareStatement(SQL);

			preparedStatement.setInt(1, board_seq);
			rs = preparedStatement.executeQuery();

			while (rs.next()) {
				Reply reply = new Reply();
				reply.setComment(rs.getString("comment"));
				reply.setRegdate(rs.getDate("regdate"));
				replyList.add(reply);
			}
			return replyList;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
