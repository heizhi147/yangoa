package com.yang.oa.commons;

public class PagingBean {
	private int rowsNums;
	private int currentRows;
	private int onePageRows;
	private int currentPage;
	private int pageNums;
	private boolean hasPreviousPage;
	private boolean hasNextPage;
	public boolean isHasPreviousPage() {
		return hasPreviousPage;
	}
	public void setHasPreviousPage(boolean hasPreviousPage) {
		this.hasPreviousPage = hasPreviousPage;
	}
	public boolean isHasNextPage() {
		return hasNextPage;
	}
	public void setHasNextPage(boolean hasNextPage) {
		this.hasNextPage = hasNextPage;
	}
	public int getRowsNums() {
		return rowsNums;
	}
	public void setRowsNums(int rowsNums) {
		this.rowsNums = rowsNums;
	}
	public int getCurrentRows() {
		return currentRows;
	}
	public void setCurrentRows(int currentRows) {
		this.currentRows = currentRows;
	}
	public int getOnePageRows() {
		return onePageRows;
	}
	public void setOnePageRows(int onePageRows) {
		this.onePageRows = onePageRows;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getPageNums() {
		return pageNums;
	}
	public void setPageNums(int pageNums) {
		this.pageNums = pageNums;
	}
	
}
