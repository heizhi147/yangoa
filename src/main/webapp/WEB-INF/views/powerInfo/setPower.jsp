<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<link rel="stylesheet"
	href="${ctx}/resources/static/zTree/css/zTreeStyle/zTreeStyle.css"
	type="text/css">
<script type="text/javascript"
	src="${ctx}/resources/static/zTree/js/jquery.ztree.core-3.5.js" /></script>
<script type="text/javascript"
	src="${ctx}/resources/static/zTree/js/jquery.ztree.excheck-3.5.js" /></script>
<script src="${ctx}/resources/static/js/editTable.js"></script>
<script type="text/javascript">
	var parentid = "";
	var roleid = "";
	var selectEmpInfo = {};
	var empTableSetting = {
		readOnly : true,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "empName",
			name : "姓名",
			hide : false,
			width : "50%"
		}, {
			id : "empCode",
			name : "编码",
			hide : false,
			width : "50%"
		} ]
	};
	var roleEmpTableSetting = {
		readOnly : false,
		ifUpdate : false,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "empName",
			name : "姓名",
			hide : false,
			width : "50%"
		}, {
			id : "empCode",
			name : "编码",
			hide : false,
			width : "50%"
		} ]
	};
	var roleTableSetting = {
		readOnly : true,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "roleName",
			name : "角色名",
			hide : false,
			width : "100%"
		}, {
			id : "roleCode",
			name : "角色编码",
			hide : true,
			width : "0%"
		} ]
	};
	var treeSetting = {
		async : {
			enable : true,
			url : "${ctx}/powers/resTree",
			autoParam : [ "id=parentid" ],
			otherParam : {}
		},
		simpleData : {
			enable : true
		},

		check : {
			enable : true,
			chkStyle : "checkbox",
			chkboxType : {
				"Y" : "s",
				"N" : "s"
			}
		}
	};
	function initRoleEmpTable(roleid) {
		$.getJSON('${ctx}/powers/roleEmps?roleId=' + roleid, function(data) {
			$("#roleEmpTable").editTable(roleEmpTableSetting, data);
		});
	}
	function removeRoleEmp(checkdata) {
		$.ajax({
			type : "POST",
			url : '${ctx}/powers/roleEmps/delete',
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			data:checkdata,
			processData : false,
			success : function(rsData) {
				initRoleEmpTable(roleid);
				$.globalMessenger().post({
					  message: rsData.message,
					  showCloseButton: true
					});
				$('#confirm_modal').modal('hide');
			},
			error : function(jqXHR, errFlag) {
				var errobj=$.evalJSON(jqXHR.responseText);
				$.globalMessenger().post({
					  message: errobj.message,
					  type: 'error',
					  showCloseButton: true
					});
				$('#confirm_modal').modal('hide');
			}
		});

	}
	var params = {
		onePageRows : 3,
		currentPage : 1
	}

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
	var empName = "";
	var empCode = "";
	function disPlayEmpTableData(data) {
		$("#empTable").editTable(empTableSetting, data.queryReult);
		initPaging(data.pageInfo, '${ctx}/employees/nameCode?empName='
				+ empName + '&empCode=' + empCode);
		$("#empTable tr").click(function() {

			var currentEmpId = $(this).find("td[title=uuid]").text();
			var currentempName = $(this).find("td[title=empName]").text();
			var currentEmpCode = $(this).find("td[title=empCode]").text();
			selectEmpInfo.uuid = currentEmpId;
			selectEmpInfo.empName = currentempName;
			selectEmpInfo.empCode = currentEmpCode;
			$("#roleTable .selected").removeClass("selected");
			$(this).addClass("selected");
			var roleEmp = {};
			roleEmp.groupid = currentEmpId;
			roleEmp.roleid = roleid;
			var roleEmpJson = $.toJSON(roleEmp);
			$.ajax({
				type : "POST",
				url : '${ctx}/powers/roleEmps/roleEmp/insert',
				data : roleEmpJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					initRoleEmpTable(roleid);
				},
				error : function(jqXHR, errFlag) {
					console.log(jqXHR.responseText);
					console.log(errFlag);
				}
			});
			$('#empModal').modal('hide');
		});

	}
	function queryEmp(){
		var empName=$("#queryKeyName").val();
		var empCode=$("#queryKeyName").val();
		initEmpTable(empName, empCode);
	}
	function delRoleEmp(){
		var checkdata=$("#roleEmpTable").getCheckData();
		var checkObj=$.evalJSON(checkdata);
		var objArray=[];
		for(var i=0;i<checkObj.length;i++){
			objArray[i]=checkObj[i].uuid;
		}
		var postData=$.toJSON(objArray);
		$('#confirm_modal .modal-body').html("是否进行删除?");
		$('#confirm_modal #deleteOk').bind('click', function() {
			removeRoleEmp(postData);
		});
		$('#confirm_modal').modal('show');
	}
	function initEmpTable(empName, empCode) {
	

		$.getJSON('${ctx}/employees/nameCode?empName=' + empName + '&empCode='
				+ empCode, params, function(data) {

			disPlayEmpTableData(data);
		});

	}
	function initResTree() {
		$.post('${ctx}/reses/resTree?parentid=' + parentid + '&roleId='
				+ roleid, function(data) {
			$.fn.zTree.init($("#resTree"), treeSetting, data);
		});
	}
	function initTable() {
		$.getJSON('${ctx}/roles', function(data) {
			$("#roleTable").editTable(roleTableSetting, data);
			$("#roleTable tr").bind("click", function(event) {
				var currentroleid = $(this).find("td[title=uuid]").text();
				var roleName = $(this).find("td[title=roleName]").text();
				roleid = currentroleid;
				console.log(roleName);
				$(".text-info").html(roleName);
				var postParam = {
					"roleId" : currentroleid
				};
				treeSetting.async.otherParam = postParam;
				$("#roleTable .selected").removeClass("selected");
				$(this).addClass("selected");
				initRoleEmpTable(roleid);
				initResTree();
			});
		});
	}
	function saveRole() {
		var zTree = $.fn.zTree.getZTreeObj("resTree");
		var nodes = zTree.getChangeCheckedNodes();
		var nodesArray = [];
		for ( var i = 0; i < nodes.length; i++) {
			var node = nodes[i];
			var nodeObject = {
				id : node.id,
				pId : node.pId,
				checked : node.checked,
				name : node.name
			};
			nodesArray[i] = nodeObject;
		}
		var postJson = $.toJSON(nodesArray);
		$.ajax({
			type : "POST",
			url : '${ctx}/powers/roleRes/' + roleid,
			data : postJson,
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			processData : false,
			success : function(rsData) {
				$.globalMessenger().post({
					  message: rsData.message,
					  showCloseButton: true
					});
			},
			error : function(jqXHR, errFlag) {
				console.log(jqXHR.responseText);
				console.log(errFlag);
			}
		});

	}
	
	function newRoleEmp() {
		$('#empModal').modal('show');


	}
	$(document).ready(function() {
		initResTree();
		initTable();
		initRoleEmpTable();
	});
</script>

<div class="container-fluid">
	<div  class="row-fluid">		
 				<legend>授权作业</legend>
	</div>
	<div class="row-fluid">
		<div class="span3">
			<div class="well">
				当前选中角色:
				<p class="text-info"></p>
			</div>
			<table class="table table-striped table-hover table-bordered"
				id="roleTable">

			</table>
		</div>
		<div class="span9">
			<div class="tabbable">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#1" data-toggle="tab">角色对应资源</a></li>
					<li><a href="#2" data-toggle="tab">角色对于人</a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="1">
						<div class="row-fluid">
							<a role="button" class="btn" data-toggle="modal"
								onClick="saveRole()">保存</a>
							<legend></legend>
						</div>
						<ul class="ztree" id="resTree">
						</ul>
					</div>
					<div class="tab-pane" id="2">
						<div class="row-fluid">
							<a role="button" class="btn" data-toggle="modal"
								onClick="newRoleEmp()">新增</a>
							<a role="button" class="btn" data-toggle="modal"
								onClick="delRoleEmp()">删除</a>
							<legend></legend>
						</div>
						<div class="row-fluid">
							<table class="table table-striped table-hover table-bordered"
								id="roleEmpTable"></table>
							<div id="empModal" class="modal hide fade">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-hidden="true">×</button>
									<h3 id="myModalLabel">角色对应人信息</h3>

								</div>
								<div class="modal-body">
									<div class="row-fluid">
										<form class="form-search">
											<input id="queryKeyName" type="text" class="input-small search-query" placeholder="姓名">
											<input id="queryKeyCode" type="text" class="input-small search-query" placeholder="编码">
										</form>
									</div>
									<table class="table table-striped table-bordered table-hover" id="empTable">

									</table>
									<div class="pagination">
										<ul>
										</ul>
									</div>
								</div>
								<div class="modal-footer">
									<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
									<a class="btn btn-primary" onClick="queryEmp()">查询</a>
								</div>
							</div>
							<div class="modal fade confirm_modal" id="confirm_modal">
								<div class="modal-body inner"></div>
								<div class="modal-footer">
									<a class="btn cancel" href="#" data-dismiss="modal">cancel</a>
									<a href="#" class="btn btn-danger" id="deleteOk">yes</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>