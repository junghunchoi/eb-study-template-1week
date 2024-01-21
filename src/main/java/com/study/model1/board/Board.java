package com.study.model1.board;

import java.sql.Date;

public class Board {
	private int seq;
	private String title;
	private String content;
	private String writer;
	private String category;
	private int viewcount;
	private java.sql.Date postdate;
	private java.sql.Date updatedate;
	private int fileseq;
	private int replyseq;

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getSeq() {
		return seq;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getViewcount() {
		return viewcount;
	}

	public int setViewcount(int viewcount) {
		this.viewcount = viewcount;

		return viewcount;
	}

	public Date getPostdate() {
		return postdate;
	}

	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}

	public Date getUpdatedate() {
		return updatedate;
	}

	public void setUpdatedate(Date updatedate) {
		this.updatedate = updatedate;
	}

	public int getFileseq() {
		return fileseq;
	}

	public void setFileseq(int fileseq) {
		this.fileseq = fileseq;
	}

	public int getReplyseq() {
		return replyseq;
	}

	public void setReplyseq(int replyseq) {
		this.replyseq = replyseq;
	}
}
