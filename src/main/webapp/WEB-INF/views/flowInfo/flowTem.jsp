<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<script type="text/javascript"
	src="${ctx}/resources/static/zTree/js/jquery.ztree.core-3.5.js" /></script>
<link rel="stylesheet"
	href="${ctx}/resources/static/zTree/css/zTreeStyle/zTreeStyle.css"
	type="text/css">
<script src="${ctx}/resources/static/js/editTable.js"></script>
<script type="text/javascript">
	var resTableSetting = {
		readOnly : false,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "tempName",
			name : "资源名",
			hide : false,
			width : "20%"
		}, {
			id : "tempCode",
			name : "资源编码",
			hide : false,
			width : "10%"
		} ]
	};
	
	function initPaging(pageInfo, url) {
		$(".pagination ul").children().remove();
		var currentPage = pageInfo.currentPage;
		var pageSize = pageInfo.onePageRows;
		var pageNum = pageInfo.pageNums;
		var pageUl = $(".pagination ul");
		var start = Math.max(1, currentPage - pageSize / 2);
		var end = Math.min(currentPage + pageSize / 2, pageNum);
		var first = currentPage - 1;
		var last = currentPage + 1;
		var pagefirstli = "<li id=\""+first+"\"><a href=\"#\">&lt;</a></li>";
		if (!pageInfo.hasPreviousPage) {
			pagefirstli = "<li id=\""+first+"\" class=\"disabled\"><a href=\"#\">&lt;</a></li>";
		}
		pageUl.append(pagefirstli);

		for (start; start <= end; start++) {
			if (start == currentPage) {
				var li = "<li id=\""+start+"\" class=\"active\"><a href=\"#\">"
						+ start + "</a></li>";
				pageUl.append(li);
			} else {
				var li = "<li id=\""+start+"\"><a href=\"#\">" + start
						+ "</a></li>";
				pageUl.append(li);
			}
		}
		var pageLastli = "<li id=\""+last+"\"><a href=\"#\">&gt;</a></li>";
		if (!pageInfo.hasNextPage) {
			pageLastli = "<li id=\""+last+"\" class=\"disabled\"><a href=\"#\">&gt;</a></li>";
		}
		pageUl.append(pageLastli);
		pageUl.find("li").click(function() {
			var clickLi = $(this);
			if (!$(this).hasClass("disabled")) {

				var liId = clickLi.attr("id");
				console.log(liId);
				params.currentPage = liId;

				$.getJSON(url, params, function(data) {
					disPlayEmpTableData(data);
				});

			}
		});
	}
	var flowTemName="";
	var params = {
			onePageRows : 10,
			currentPage : 1
		}

	$(document).ready(function() {
		$.getJSON('${ctx}/flowTems?flowTemName='+flowTemName,params,function(data){
			$("#flowTemTable").editTable(resTableSetting, data.queryReult);
			initPaging(data.pageInfo, '${ctx}/flowTems?flowTemName='+flowTemName);
		});
		
		
	});
</script>
<div class="container-fluid">
	<div class="row-fluid">
		<legend>流程维护</legend>
	</div>
	<div class="row-fluid">
		
		
			<div class="space4">
				<button class="btn " type="button">新增</button>
				<button class="btn " type="button">删除</button>
			</div>	
			<div class="space5 offset8">
				<form class="form-search">
				<label>名称：</label> <input type="text" name="search_LIKE_title" class="input-medium"> 
					<button type="submit" class="btn" id="search_btn">查询</button>
				</form>
			</div>
	
	</div>
	<div class="row-fluid">
		`
		<table class="table table-striped table-bordered" id="flowTemTable">
		</table>
		<div class="pagination">
			<ul>
			</ul>
		</div>
	</div>
</div>