package com.study.model1.board;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;

public class BoardDAO {
	private Connection conn;
	private ResultSet rs;

	public BoardDAO() {
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

	public int getNext() {
		String SQL = "SELECT seq from board order by seq DESC";//마지막 게시물 반환
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int write(String title, String writer, String content, String category,String password) {
		String SQL = "INSERT INTO board (title, content, writer,category, postdate, password) VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setString(3, writer);
			pstmt.setString(4, category);
			pstmt.setDate(5, Date.valueOf(LocalDate.now()));//날짜
			pstmt.setString(6, BCrypt.hashpw(password, BCrypt.gensalt()));

			int affectedRows = pstmt.executeUpdate();

			if (affectedRows > 0) {
				try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
					if (generatedKeys.next()) {
						return generatedKeys.getInt(1);
					}

				} catch (Exception e) {
					System.out.println("게시물이 생성되지 않았습니다.");
					e.printStackTrace();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}

	public ArrayList<Board> getList(int pageNumber) {
		String SQL = "SELECT seq,category,title,writer,viewcount,postdate,updatedate from board where seq < ? order by seq desc limit 10";
		ArrayList<Board> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Board board = new Board();
				board.setSeq(rs.getInt(1));
				board.setCategory(rs.getString(2));
				board.setTitle(rs.getString(3));
				board.setWriter(rs.getString(4));
				board.setViewcount(rs.getInt(5));
				board.setPostdate(rs.getDate(6));
				board.setContent(rs.getString(7));
				list.add(board);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int getCount() {
		String SQL = "select count(*) from board";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public ArrayList<String> getCategory() {
		ArrayList<String> list = new ArrayList<>();

		String SQL = "select title from category";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public Board getBoard(int seq) {//하나의 글 내용을 불러오는 함수
		String SQL = "SELECT * from board where seq = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, seq);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Board Board = new Board();
				Board.setSeq(rs.getInt(1));
				Board.setTitle(rs.getString(2));
				Board.setContent(rs.getString(3));
				Board.setWriter(rs.getString(4));
				Board.setCategory(rs.getString(5));
				int boardCount = Board.setViewcount(rs.getInt(6));
				Board.setPostdate(rs.getDate(7));
				Board.setUpdatedate(rs.getDate(8));
				countUpdate(seq);

				return Board;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public int countUpdate(int seq) {
		String SQL = "update board set viewcount = viewcount + 1 where seq = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, seq);//물음표의 순서
			return pstmt.executeUpdate();//insert,delete,update
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}


	public int update(int seq, String title, String content) {
		String SQL = "update Board set title = ?, content = ? where seq = ?";//특정한 아이디에 해당하는 제목과 내용을 바꿔준다.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, title);//물음표의 순서
			pstmt.setString(2, content);
			pstmt.setInt(3, seq);
			return pstmt.executeUpdate();//insert,delete,update
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}

	public int delete(int seq) {
		String SQL = "update board set BoardAvailable = 0 where seq = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, seq);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}

	public ArrayList<Board> getSearch(String startdate, String enddate, String category, String searchText) {
		ArrayList<Board> list = new ArrayList<>();
		String SQL = "select category,title,writer,viewcount,postdate,updatedate from board WHERE 1 = 1";
		try {
			if (!startdate.equals("")) SQL += " AND postdate >='" + startdate + "'";
			if (!enddate.equals("")) SQL += " AND postdate <='" + enddate + "'";
			if (!searchText.equals("")) {
				SQL += " AND( writer LIKE '%" + searchText + "%' ";
				SQL += " OR content LIKE '%" + searchText + "%' ";
				SQL += " OR title LIKE '%" + searchText + "%') ";
			}
			if (!category.equals("")) SQL += " AND category LIKE '%" + category + "%' ";
			SQL += "order by seq";

			System.out.println("SQL :" + SQL);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();//select
			while (rs.next()) {
				Board Board = new Board();
				Board.setCategory(rs.getString(1));
				Board.setTitle(rs.getString(2));
				Board.setWriter(rs.getString(3));
				Board.setViewcount(rs.getInt(4));
				Board.setPostdate(rs.getDate(5));
				Board.setUpdatedate(rs.getDate(6));
				list.add(Board);//list에 해당 인스턴스를 담는다.
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}


}
