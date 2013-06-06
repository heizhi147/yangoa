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
 				<legend>组织信息维护</legend>
	</div>
	<div class="row-fluid">
		<div class="span2 divCloth">
			<ul id="postTree" class="ztree ulTreeleft"></ul>
		
		</div>
		<div class="span10">
			<div class="row-fluid">
				<div class="span12">
					<a role="button" class="btn" data-toggle="modal" onClick="newOrg()">新增</a>
					<a role="button" class="btn" data-toggle="modal" onClick="delOrg()">删除</a>
					<legend></legend>
				</div>
			</div>
			<div class="row-fluid">
				<div class="span12 .divSorll">
					<table class="table table-bordered table-hover table-striped"
						id="orgList">

					</table>
				</div>
				<div id="myModal" class="modal hide fade">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h3 id="myModalLabel">组织信息</h3>

					</div>
					<div class="modal-body">
						<form id="ff" class="form-horizontal">
							<div class="control-group">
								<label for="orgName" class="control-label">组织名称:</label>
								<div class="controls">
									<input type="text" id="orgName" name="orgName" check-type="required" required-message="组织名称不能为空"/>
								</div>
							</div>

							<div class="control-group">
								<label for="orgCode" class="control-label">组织编码:</label>
								<div class="controls">
									<input type="text" id="orgCode" name="orgCode" />
								</div>
							</div>
							<div class="control-group">
								<label for="address" class="control-label">组织地址:</label>
								<div class="controls">
									<input type="text" id="address" name="address" />
								</div>
							</div>
							<input type="hidden" id="parentid" name="parentid" /> <input
								type="hidden" id="uuid" name="uuid" /> <input type="hidden"
								id="orgLevel" name="orgLevel" />
						</form>
					</div>
					<div class="modal-footer">
						<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
						<a class="btn btn-primary" onClick="insertOrg()">保存</a>
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
</div>
<script type="text/javascript">
	var parentid = "";
	var validateSetting={rules:{orgName:['not_empty'],orgCode:['not_empty'],address:['not_empty']}};
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

	function newOrg() {
		$("#ff :input").val('');
		$("#ff #parentid").val(parentid);
		$("#ff").removeValidateClss(validateSetting);
		$('#myModal').modal('show');
	}
	//tree设置

	function creatOrgTreeNode(orgObject) {
		var zTree = $.fn.zTree.getZTreeObj("postTree");
		var node = zTree.getSelectedNodes();
		var addNode = {
			id : orgObject.uuid,
			pId : orgObject.parentid,
			name : orgObject.orgName
		};
		zTree.addNodes(node[0], addNode);

	}

	function updateOrgTreeNode(orgObject) {
		var zTree = $.fn.zTree.getZTreeObj("postTree");
		var node = zTree.getSelectedNodes();
		console.log(node);
		var childNodes = node[0].children;
		//获取提交的角色数据
		var orgId = orgObject.uuid;
		var orgName = orgObject.orgName;
		//获取当前选中元素的子元素
		for ( var i = 0; i < childNodes.length; i++) {
			var childnode = childNodes[i];
			var id = childnode.id;
			//判断是否需要修改
			if (id == orgId) {
				childnode.name = orgName;
				zTree.updateNode(childnode);
			}
		}

	}
	function removeOrgTreeNode(orgId) {
		var treeObj = $.fn.zTree.getZTreeObj("postTree");
		var node = treeObj.getNodeByParam("id", orgId, null);
		treeObj.removeNode(node);
	}
	function onClickTree(event, treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("postTree");
		zTree.expandNode(treeNode, true, null, null, null);
		parentid = treeNode.id;
		resetTable();
	}

	//table操作
	var tableSetting = {
		readOnly : false,
		columns : [ {
			id : "uuid",
			name : "uuid",
			hide : true,
			width : "0%"
		}, {
			id : "orgName",
			name : "组织名称",
			hide : false,
			width : "10%"
		}, {
			id : "orgCode",
			name : "组织编码",
			hide : false,
			width : "10%"
		}, {
			id : "address",
			name : "组织地址",
			hide : false,
			width : "30%"
		}, {
			id : "orgLevel",
			name : "orgLevel",
			hide : true,
			width : "0%"
		}, {
			id : "parentid",
			name : "parentid",
			hide : true,
			width : "0%"
		}

		]
	};
	function resetTable() {
		$.getJSON('${ctx}/orgs/org?parentid=' + parentid, function(data) {
			$("#orgList").editTable(tableSetting, data.tableData);
			$("#orgList").find("a[name=update]").bind(
					'click',
					function() {
						var uuidValue = $(this).parent().parent().find(
								"td[title=uuid]").html();
						editOrg(uuidValue);
					});
			$("#orgList").find("a[name=remove]").bind(
					'click',
					function() {
						var uuidValue = $(this).parent().parent().find(
								"td[title=uuid]").html();
						$('#confirm_modal .modal-body').html("是否进行删除?");
						$('#confirm_modal #deleteOk').bind('click', function() {
							removeOrg(uuidValue);
						});
						$('#confirm_modal').modal('show');

					});

		});
	}
	function insertOrg() {
		var orgFormData = $('#ff').serializeArray();
		var uuid = $("#ff #uuid").val();
		var url;
		var orgJson = changeFormData(orgFormData);
		var s=$("#ff").validate(validateSetting);
		if(!s){
			return;
		}
		if (uuid = null || "" == uuid) {
			url = "${ctx}/orgs/org/insert";
			$.ajax({
				type : "POST",
				url : url,
				data : orgJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					resetTable();
					$('#myModal').modal('hide');
					creatOrgTreeNode(rsData.data);
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#myModal').modal('hide');
				}
			});
		} else {
			url = "${ctx}/orgs/org/update";

			$.ajax({
				type : "POST",
				url : url,
				data : orgJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					resetTable();
					$('#myModal').modal('hide');
					updateOrgTreeNode(rsData.data);
					$.globalMessenger().post({
						  message: rsData.message,
						  showCloseButton: true
						});
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#myModal').modal('hide');
				}
			});
		}

	}
	function editOrg(id) {
		$.getJSON('${ctx}/orgs/org/' + id, function(data) {
			console.log(data);
			for (k in data) {
				var input = $("#ff #" + k);
				if (input.length > 0) {
					input.val(data[k]);
				}
			}
			$('#myModal').modal('show');
		});
	}
	function removeOrg(checkdata) {
		
		$.ajax({
			type : "POST",
			url : "${ctx}/orgs/org/delete",
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			data:checkdata,
			processData : false,
			success : function(rsData) {
				resetTable();
				var checkobj=$.evalJSON(checkdata);
				for(var i=0;i<checkobj.length;i++){
				removeOrgTreeNode(checkobj[i].uuid);
				}
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
	function delOrg(){
		var checkdata=$("#orgList").getCheckData();
		$('#confirm_modal .modal-body').html("是否进行删除?");
		$('#confirm_modal #deleteOk').bind('click', function() {
			removeOrg(checkdata);
		});
		$('#confirm_modal').modal('show');
	}
	$(document).ready(
			
			function() {
			
			
		
				$.getJSON('${ctx}/orgs/org?parentid=' + parentid,
						function(data) {
							$.fn.zTree.init($("#postTree"), setting,
									data.treeData);
							$("#orgList").editTable(tableSetting,
									data.tableData);
							$("#orgList").find("a[name=update]").bind(
									'click',
									function() {
										var uuidValue = $(this).parent()
												.parent()
												.find("td[title=uuid]").html();
										editOrg(uuidValue);
									});
				

						});
			});
</script>