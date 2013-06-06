<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<script src="${ctx}/resources/static/js/editTable.js"></script>
<script type="text/javascript">
	var roleTableSetting = {
		readOnly : false,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "roleName",
			name : "资源名",
			hide : false,
			width : "50%"
		}, {
			id : "roleCode",
			name : "资源编码",
			hide : false,
			width : "50%"
		} ]
	};

	function initTable() {
		$.getJSON('${ctx}/roles', function(data) {
			$("#roleTable").editTable(roleTableSetting, data);
			$("#roleTable").find("a[name=update]").bind(
					'click',
					function() {
						var uuidValue = $(this).parent().parent().find(
								"td[title=uuid]").html();
						editRole(uuidValue);
					});
		});
	}
	function newRole(){
		$("#roleForm :input").val('');
		$('#roleModal').modal('show');
	}
	
	function saveRes(){
		var roleFormData = $('#roleForm').serializeArray();
		var uuid = $("#roleForm #uuid").val();
		var url;
		var roleJson = changeFormData(roleFormData);
	
		if (uuid = null || "" == uuid) {
			url = "${ctx}/roles/role/insert";
			$.ajax({
				type : "POST",
				url : url,
				data : roleJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					initTable();
					$('#roleModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#roleModal').modal('hide');
				}
			});
		} else {
			url = "${ctx}/roles/role/update";

			$.ajax({
				type : "POST",
				url : url,
				data : roleJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					initTable();
					$.globalMessenger().post({
						  message: rsData.message,
						  showCloseButton: true
						});
					$('#roleModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#roleModal').modal('hide');
				}
			});
		}
	}
	function editRole(id){
		$.getJSON('${ctx}/roles/role/' + id, function(data) {
			for (k in data) {
				var input = $("#roleForm #" + k);
				if (input.length > 0) {
					input.val(data[k]);
				}
			}

			$('#roleModal').modal('show');
		});
	}
	function delRole(){
		var checkdata=$("#roleTable").getCheckData();
		$('#confirm_modal .modal-body').html("删除角色将同时角色对应权限,是否进行删除?");
		$('#confirm_modal #deleteOk').bind('click', function() {
			removeRole(checkdata);
		});
		$('#confirm_modal').modal('show');
	}
	function removeRole(checkdata){
		$.ajax({
			type : "POST",
			url : "${ctx}/roles/role/delete",
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			data:checkdata,
			processData : false,
			success : function(rsData) {
				initTable();
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
	
	$(document)
	.ready(
			function() {
				initTable();
			

			});
</script>

<div class="container-fluid">
	<div  class="row-fluid">		
 				<legend>角色维护</legend>
	</div>
	<div class="row-fluid">
		<div class="span12">
			<a role="button" class="btn" data-toggle="modal"
				onClick="newRole()">新增</a>
			<a role="button" class="btn" data-toggle="modal"
				onClick="delRole()">删除</a>
			<legend></legend>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12">
			<table class="table table-striped table-bordered" id="roleTable"></table>
			<div id="roleModal" class="modal hide fade">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h3 id="myModalLabel">角色信息</h3>

					</div>
					<div class="modal-body">
						<form id="roleForm" class="form-horizontal">
							<div class="control-group">
								<label for="roleName" class="control-label">角色名称:</label>
								<div class="controls">
									<input type="text" id="roleName" name="roleName" />
								</div>
							</div>

							<div class="control-group">
								<label for="roleCode" class="control-label">角色编码:</label>
								<div class="controls">
									<input type="text" id="roleCode" name="roleCode" />
								</div>
							</div>
					
						
					<input type="hidden" id="uuid" name="uuid" /> 
						</form>
					</div>
					<div class="modal-footer">
						<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
						<a class="btn btn-primary" onClick="saveRes()">保存</a>
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