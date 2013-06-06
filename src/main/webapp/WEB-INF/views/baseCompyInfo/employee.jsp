<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<script type="text/javascript"
	src="${ctx}/resources/static/zTree/js/jquery.ztree.core-3.5.js" /></script>
<link rel="stylesheet"
	href="${ctx}/resources/static/zTree/css/zTreeStyle/zTreeStyle.css"
	type="text/css">
<script src="${ctx}/resources/static/js/editTable.js"
	type="text/javascript"></script>

	<div class="container-fluid">
	<div  class="row-fluid">		
 				<legend>人员信息维护</legend>
	</div>

		<div class="row-fluid">
			<div class="span2 divCloth">
				<ul class="ztree" id="orgsTree">
				</ul>
			</div>
			<div class="span10">
				<div class="row-fluid">
					<div class="span12">
						<a role="button" class="btn" data-toggle="modal"
							onClick="newEmp()">新增</a>
						<a role="button" class="btn" data-toggle="modal"
							onClick="delEmp()">删除</a>
						<legend></legend>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<table class="table table-bordered table-hover table-striped"
							id="employeeTable"></table>
					</div>
				</div>
				<div id="empModal" class="modal hide fade">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h3 id="myModalLabel">岗位信息</h3>

					</div>
					<div class="modal-body">
						<form id="empform" class="form-horizontal">
							<div class="control-group">
								<label for="empName" class="control-label">姓名:</label>
								<div class="controls">
									<input type="text" id="empName" name="empName" />
								</div>
							</div>

							<div class="control-group">
								<label for="empCode" class="control-label">工号:</label>
								<div class="controls">
									<input type="text" id="empCode" name="empCode" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="postName">岗位:</label>
								<div class="controls">
									<div class="input-append">
										<input name="postName" id="postName" type="text" disabled>
										<button id="postNamebtn" class="btn" type="button" onClick="show()">Go!</button>
									</div>
								</div>

								<div id="menuContent" class="menuContent"
									style="display: none; position: absolute;">
									<ul id="postTree" class="ztree"></ul>
								</div>


							</div>

							<div class="control-group">
								<label for="address" class="control-label">地址:</label>
								<div class="controls">
									<input type="text" id="address" name="address" />
								</div>
							</div>
							<div class="control-group">
								<label for="telNum" class="control-label">电话:</label>
								<div class="controls">
									<input type="text" id="telNum" name="telNum" />
								</div>
							</div>
							<div class="control-group">
								<label for="email" class="control-label">邮箱:</label>
								<div class="controls">
									<input type="text" id="email" name="email" />
								</div>
							</div>
							<input type="hidden" id="orgId" name="orgId" /> <input
								type="hidden" id="uuid" name="uuid" /> <input type="hidden"
								id="postId" name="postId" />
						</form>

					</div>
					<div class="modal-footer">
						<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
						<a class="btn btn-primary" onClick="saveEmp()">保存</a>
					</div>
				</div>
				<div class="modal fade confirm_modal" id="confirm_modal">
					<div class="modal-body inner"></div>
					<div class="modal-footer">
						<a class="btn cancel" href="#" data-dismiss="modal">cancel</a> <a
							href="#" class="btn btn-danger" id="deleteOk">yes</a>
					</div>
				</div>

			</div>
		</div>
	</div>

<script type="text/javascript">
var validateSetting={rules:{empName:['not_empty'],empCode:['not_empty']}};
function show(){
	var position = $("#postName").position();
	var cityObj = $("#postName");
	var sssss=$('.input-append');
		var cityOffset = $("#postName").offset();
		var divWidth = sssss.width() + "px";
		console.log(cityOffset.left);
		$("#menuContent").css({
			width : divWidth,
			left : position.left + "px",
			top : position.top + cityObj.outerHeight() + "px"
		});
		$("#menuContent").addClass("divSorll").slideDown("fast");
		$("body").bind("mousedown", onBodyDown);
	}
	
function hideMenu() {
	$("#menuContent").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == "postNamebtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
		hideMenu();
	}
}

	var posttreeSetting = {
		async : {
			enable : true,
			url : "${ctx}/posts/postTree/",
			autoParam : [ "id=parentid" ]
		},
		simpleData : {
			enable : true
		},
		callback : {
			onClick : onPostClickTree
		}
	};
	function onPostClickTree(event, treeId, treeNode, clickFlag){
		var zTree = $.fn.zTree.getZTreeObj("orgsTree");
		var postId = treeNode.id;
		$("#postId").val(postId);
		$("#postName").val(treeNode.name);
		hideMenu();
	}
	//table操作
	var orgId = "";
	var parentid = "";
	var postLevel = Number("1");
	var setting = {
		async : {
			enable : true,
			url : "${ctx}/orgs/orgChildTree/",
			autoParam : [ "id=parentid" ]
		},
		simpleData : {
			enable : true
		},
		callback : {
			onClick : onClickTree
		}
	};
	function onClickTree(event, treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("orgsTree");
		zTree.expandNode(treeNode, true, null, null, null);
		orgId = treeNode.id;
		resetTable();
	}

	function newEmp() {
		$.post('${ctx}/posts/postTree?parentid=', function(data) {
			$.fn.zTree.init($("#postTree"), posttreeSetting, data);
		});
		$("#empform :input").val('');
		$("#empform #orgId").val(orgId);
		$("#empform").removeValidateClss(validateSetting);
		$('#empModal').modal('show');
	}
	function saveEmp() {
		var empFormData = $('#empform').serializeArray();
		console.log(empFormData);
		var uuid = $("#empform #uuid").val();
		var url;
		var empJson = changeFormData(empFormData);
		var s=$("#empform").validate(validateSetting);
		if(!s){
			return;
		}
		if (uuid = null || "" == uuid) {
			url = "${ctx}/employees/employee/insert";
			$.ajax({
				type : "POST",
				url : url,
				data : empJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					resetTable();
					$('#empModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#empModal').modal('hide');
				}
			});
		} else {
			url = "${ctx}/employees/employee/update";
			$.ajax({
				type : "POST",
				url : url,
				data : empJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					resetTable();
					
					$.globalMessenger().post({
						  message: rsData.message,
						  showCloseButton: true
						});
					$('#empModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#empModal').modal('hide');
				}
			});
		}
	}
	function editEmp(id) {
		$.getJSON('${ctx}/employees/employee/' + id, function(data) {
			console.log(data);
			for (k in data) {
				var input = $("#empform #" + k);
				if (input.length > 0) {
					input.val(data[k]);
				}
			}
			$('#empModal').modal('show');
		});
	}

	function removeEmp(checkdata) {
		$.ajax({
			type : "POST",
			url : "${ctx}/employees/employee/delete",
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			data:checkdata,
			processData : false,
			success : function(rsData) {
				resetTable();
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
	function delEmp(){
		var checkdata=$("#employeeTable").getCheckData();
		$('#confirm_modal .modal-body').html("是否进行删除?");
		$('#confirm_modal #deleteOk').bind('click', function() {
			removeEmp(checkdata);
		});
		$('#confirm_modal').modal('show');
	}
	function resetTable() {
		$.getJSON('${ctx}/employees?orgId=' + orgId, function(data) {
			$("#employeeTable").editTable(postTableSetting, data);
			$("#employeeTable").find("a[name=update]").bind(
					'click',
					function() {
						var uuidValue = $(this).parent().parent().find(
								"td[title=uuid]").html();
						editEmp(uuidValue);
					});

		});
	}
	var postTableSetting = {
		readOnly : false,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "empName",
			name : "姓名",
			hide : false,
			width : "10%"
		}, {
			id : "empCode",
			name : "工号",
			hide : false,
			width : "10%"
		}, {
			id : "postId",
			name : "postId",
			hide : true,
			width : "10%"
		}, {
			id : "postName",
			name : "岗位名称",
			hide : false,
			width : "10%"
		}, {
			id : "address",
			name : "地址",
			hide : false,
			width : "20%"
		}, {
			id : "telNum",
			name : "电话",
			hide : false,
			width : "10%"
		}, {
			id : "email",
			name : "email",
			hide : false,
			width : "10%"
		} ]
	};
	$(document).ready(function() {
		$.getJSON('${ctx}/orgs/org?parentid=' + parentid, function(data) {
			$.fn.zTree.init($("#orgsTree"), setting, data.treeData);
		});

		resetTable();
	});
</script>