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
var parentid="";
var treeSetting = {
		async : {
			enable : true,
			url : "${ctx}/reses/resTree",
			autoParam : [ "id=parentid" ]
		},
		simpleData : {
			enable : true
		},
		callback : {
			onClick : onClickTree
		}
	};
	function onClickTree(event, treeId, treeNode, clickFlag){
		var zTree = $.fn.zTree.getZTreeObj("resTree");
		zTree.expandNode(treeNode, true, null, null, null);
		parentid = treeNode.id;
		initTable();
	}
	//tree操作
	function creatResTreeNode(resObject) {
		var zTree = $.fn.zTree.getZTreeObj("resTree");
		var node = zTree.getSelectedNodes();
		var addNode = {
			id : resObject.uuid,
			pId : resObject.parentid,
			name : resObject.resName
		};
		zTree.addNodes(node[0], addNode);

	}

	function updateResTreeNode(resObject) {
		var zTree = $.fn.zTree.getZTreeObj("resTree");
		var node = zTree.getSelectedNodes();
		var childNodes = node[0].children;
		//获取提交的角色数据
		var resId = resObject.uuid;
		var resName = resObject.resName;
		//获取当前选中元素的子元素
		for ( var i = 0; i < childNodes.length; i++) {
			var childnode = childNodes[i];
			var id = childnode.id;
			//判断是否需要修改
			if (id == resId) {
				childnode.name = resName;
				zTree.updateNode(childnode);
			}
		}

	}

	function removeResTreeNode(resId) {
		var treeObj = $.fn.zTree.getZTreeObj("resTree");
		var node = treeObj.getNodeByParam("id", resId, null);
		treeObj.removeNode(node);
	}
	/* Table initialisation */
	$(document)
			.ready(
					function() {
						$.post('${ctx}/reses/resTree?parentid=' + parentid,function (data){
							$.fn.zTree.init($("#resTree"), treeSetting,
									data);
						});
						initTable();
						$("select").change(function () {
							  var str = "";
							  str= $("select option:selected").val();
							  $("#resType").val(str);
							});

					});
	var resTableSetting = {
			readOnly : false,
			columns : [ {
				id : "uuid",
				name : "uuid",
				hide : true,
				width : "0%"
			}, {
				id : "resName",
				name : "资源名",
				hide : false,
				width : "20%"
			}, {
				id : "resCode",
				name : "资源编码",
				hide : false,
				width : "10%"
			}, {
				id : "resType",
				name : "资源类型",
				hide : false,
				width : "10%"
			}, {
				id : "urlCode",
				name : "访问地址",
				hide : false,
				width : "30%"
			},{
				id : "action",
				name : "动作",
				hide : false,
				width : "10%"
			}, {
				id : "parentid",
				name : "parentid",
				hide : true,
				width : "0%"
			}]
		};
	function initTable(){
		$.getJSON('${ctx}/reses/res?parentid=' + parentid, function(data) {
			$("#resTable").editTable(resTableSetting, data);
			$("#resTable").find("a[name=update]").bind(
					'click',
					function() {
						var uuidValue = $(this).parent().parent().find(
								"td[title=uuid]").html();
						editRes(uuidValue);
					});
		});
	}
	function  editRes(id){
		$.getJSON('${ctx}/reses/res/' + id, function(data) {
			console.log(data);
			for (k in data) {
				var input = $("#resForm #" + k);
				if (input.length > 0) {
					input.val(data[k]);
				}
			}
			var restype=$("#resType").val();
			$("select").val(restype);
			$('#resModal').modal('show');
		});
	}
	function removeRes(checkdata){
		$.ajax({
			type : "POST",
			url : "${ctx}/reses/res/delete",
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			data:checkdata,
			processData : false,
			success : function(rsData) {
				initTable();
				var checkobj=$.evalJSON(checkdata);
				for(var i=0;i<checkobj.length;i++){
				removeResTreeNode(checkobj[i].uuid);
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
	function newRes(){
		
		$("#resForm :input").val('');
		$("#resForm #parentid").val(parentid);
		$('#resModal').modal('show');
	}
	
	function delRes(){
		var checkdata=$("#resTable").getCheckData();
		$('#confirm_modal .modal-body').html("是否进行删除?");
		$('#confirm_modal #deleteOk').bind('click', function() {
			removeRes(checkdata);
		});
		$('#confirm_modal').modal('show');
	}
	function saveRes(){
		var resFormData = $('#resForm').serializeArray();
		var uuid = $("#resForm #uuid").val();
		var url;
		var resJson = changeFormData(resFormData);
	
		if (uuid = null || "" == uuid) {
			url = "${ctx}/reses/res/insert";
			$.ajax({
				type : "POST",
				url : url,
				data : resJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					initTable();
					creatResTreeNode(rsData);
					$('#resModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#resModal').modal('hide');
				}
			});
		} else {
			url = "${ctx}/reses/res/update";
			$.ajax({
				type : "POST",
				url : url,
				data : resJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					initTable();
					updateResTreeNode(rsData.data);
				
					$.globalMessenger().post({
						  message: rsData.message,
						  showCloseButton: true
						});
					$('#resModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#resModal').modal('hide');
				}
			});
		}
	}
</script>


	<div class="container-fluid">
	<div  class="row-fluid">		
 				<legend>资源维护</legend>
	</div>
		<div class="row-fluid">
			<div class="span2 divCloth">
				<ul class="ztree" id="resTree">
				</ul>
			</div>
			<div class="span10">
				<div class="row-fluid">
					<div class="span12">
						<a role="button" class="btn" data-toggle="modal"
							onClick="newRes()">新增</a> 
						<a role="button" class="btn" data-toggle="modal"
							onClick="delRes()">删除</a> 
						<legend></legend>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<table class="table table-striped table-bordered" id="resTable">

						</table>
					</div>
				</div>
				<div id="resModal" class="modal hide fade">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h3 id="myModalLabel">资源信息</h3>

					</div>
					<div class="modal-body">
						<form id="resForm" class="form-horizontal">
							<div class="control-group">
								<label for="resName" class="control-label">资源名称:</label>
								<div class="controls">
									<input type="text" id="resName" name="resName" />
								</div>
							</div>

							<div class="control-group">
								<label for="resCode" class="control-label">资源编码:</label>
								<div class="controls">
									<input type="text" id="resCode" name="resCode" />
								</div>
							</div>
							<div class="control-group">
								<label for="resType" class="control-label">资源类型:</label>
								<div class="controls">
									<select id="resTypeSe">
										<option value ="">请选择--</option>
										<option value ="mo">模块</option>
										<option value ="page">页面</option>
										<option value ="btn">按钮</option>
									</select> 
									<input type="hidden" id="resType" name="resType" />
								</div>
							</div>
								<div class="control-group">
								<label for="urlCode" class="control-label">请求地址:</label>
								<div class="controls">
									<input type="text" id="urlCode" name="urlCode" />
								</div>
							</div>
								<div class="control-group">
								<label for="action" class="control-label">请求动作:</label>
								<div class="controls">
									<input type="text" id="action" name="action" />
								</div>
							</div>
							<input type="hidden" id="parentid" name="parentid" /> <input
								type="hidden" id="uuid" name="uuid" /> 
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
