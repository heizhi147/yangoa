<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<script type="text/javascript"
	src="${ctx}/resources/static/zTree/js/jquery.ztree.core-3.5.js" /></script>
<link rel="stylesheet"
	href="${ctx}/resources/static/zTree/css/zTreeStyle/zTreeStyle.css"
	type="text/css">
<script src="${ctx}/resources/static/js/editTable.js"></script>

<div class="container-fluid">
<div  class="row-fluid">		
 				<legend>岗位维护</legend>
	</div>
  <div class="row-fluid">
    <div class="span2 divCloth">
     	<ul class="ztree" id="postTree">
      	</ul>
    </div>
    <div class="span10">
    	<div class="row-fluid">
				<div class="span12">
					<a role="button" class="btn" data-toggle="modal" onClick="newPost()">新增</a>
					<a role="button" class="btn" data-toggle="modal" onClick="delPost()">删除</a>
					<legend></legend>
				</div>
		</div>
			<div class="row-fluid">
				<div class="span12">
					 <table class="table table-bordered table-hover table-striped" id="postTable"></table>
				</div>
		</div>
     		<div id="postModal" class="modal hide fade">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h3 id="myModalLabel">岗位信息</h3>

					</div>
					<div class="modal-body">
						<form id="postff" class="form-horizontal">
							<div class="control-group">
								<label for="postName" class="control-label">岗位名称:</label>
								<div class="controls">
									<input type="text" id="postName" name="postName"/>
								</div>
							</div>

							<div class="control-group">
								<label for="postCode" class="control-label">岗位编码:</label>
								<div class="controls">
									<input type="text" id="postCode" name="postCode" />
								</div>
							</div>
							<div class="control-group">
								<label for="postDis" class="control-label">岗位职责:</label>
								<div class="controls">
									<input type="text" id="postDis" name="postDis" />
								</div>
							</div>
							<input type="hidden" id="parentid" name="parentid" /> <input
								type="hidden" id="uuid" name="uuid" /> <input type="hidden"
								id="postLevel" name="postLevel" />
						</form>
					</div>
					<div class="modal-footer">
						<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
						<a class="btn btn-primary" onClick="savePost()">保存</a>
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
var validateSetting={rules:{postName:['not_empty'],postCode:['not_empty'],postDis:['not_empty']}};
//tree操作
function creatOrgTreeNode(orgObject) {
	var zTree = $.fn.zTree.getZTreeObj("postTree");
	var node = zTree.getSelectedNodes();
	var addNode = {
		id : orgObject.uuid,
		pId : orgObject.parentid,
		name : orgObject.postName
	};
	zTree.addNodes(node[0], addNode);

}

function updateOrgTreeNode(orgObject) {
	var zTree = $.fn.zTree.getZTreeObj("postTree");
	var node = zTree.getSelectedNodes();
	var childNodes = node[0].children;
	//获取提交的角色数据
	var orgId = orgObject.uuid;
	var orgName = orgObject.postName;
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

function removePostTreeNode(orgId) {
	var treeObj = $.fn.zTree.getZTreeObj("postTree");
	var node = treeObj.getNodeByParam("id", orgId, null);
	treeObj.removeNode(node);
}
//table操作
	var parentid="";
	var postLevel=Number("1");
	var validateSetting={rules:{postName:['not_empty'],postCode:['not_empty'],postDis:['not_empty']}};
	var treeSetting = {
			async : {
				enable : true,
				url : "${ctx}/posts/postTree/",
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
		var zTree = $.fn.zTree.getZTreeObj("postTree");
		zTree.expandNode(treeNode, true, null, null, null);
		parentid = treeNode.id;
		postLevel=treeNode.treeLevel
		console.log(treeNode.treeLevel);
		resetTable();
	}
	function  newPost(){
		$("#postff :input").val('');
		$("#postff #parentid").val(parentid);
		if(""!=parentid){
			postLevel=Number(postLevel)+Number("1");
		}
		$("#postff #postLevel").val(postLevel);
		$('#postModal').modal('show');
}
	function savePost(){
		var postFormData = $('#postff').serializeArray();
		var uuid = $("#postff #uuid").val();
		var url;
		var postJson = changeFormData(postFormData);
		var s=$("#postff").validate(validateSetting);
		if(!s){
			return;
		}
		if (uuid = null || "" == uuid) {
			url = "${ctx}/posts/post/insert";
			$.ajax({
				type : "POST",
				url : url,
				data : postJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					resetTable();
					creatOrgTreeNode(rsData);
					$('#postModal').modal('hide');
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#postModal').modal('hide');
				}
			});
		} else {
			url = "${ctx}/posts/post/update";

			$.ajax({
				type : "POST",
				url : url,
				data : postJson,
				dataType : "json",
				contentType : "application/json; charset=utf-8",
				processData : false,
				success : function(rsData) {
					resetTable();
					$('#postModal').modal('hide');
					updateOrgTreeNode(rsData.data);
					$.scojs_message(rsData.message, $.scojs_message.TYPE_OK);
				},
				error : function(jqXHR, errFlag) {
					var errobj=$.evalJSON(jqXHR.responseText);
					$.globalMessenger().post({
						  message: errobj.message,
						  type: 'error',
						  showCloseButton: true
						});
					$('#postModal').modal('hide');
				}
			});
		}
	}
	function editPost(id) {
		$.getJSON('${ctx}/posts/post/' + id, function(data) {
			console.log(data);
			for (k in data) {
				var input = $("#postff #" + k);
				if (input.length > 0) {
					input.val(data[k]);
				}
			}
			$('#postModal').modal('show');
		});
	}
	
	function removePost(checkdata) {
		$.ajax({
			type : "POST",
			url : "${ctx}/posts/post/delete",
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			data:checkdata,
			processData : false,
			success : function(rsData) {
				resetTable();
				var checkobj=$.evalJSON(checkdata);
				for(var i=0;i<checkobj.length;i++){
					removePostTreeNode(checkobj[i].uuid);
				}
				$.globalMessenger().post({
					  message: rsData.message,
					  showCloseButton: true
					});

				$('#confirm_modal').modal('hide');
			},
			error : function(jqXHR, errFlag) {
				console.log(jqXHR);
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
	function delPost(){
		var checkdata=$("#postTable").getCheckData();
		$('#confirm_modal .modal-body').html("是否进行删除?");
		$('#confirm_modal #deleteOk').bind('click', function() {
			removePost(checkdata);
		});
		$('#confirm_modal').modal('show');
	}
	function resetTable() {
		$.getJSON('${ctx}/posts/childpost?parentid=' + parentid, function(data) {
			$("#postTable").editTable(postTableSetting, data);
			$("#postTable").find("a[name=update]").bind(
					'click',
					function() {
						var uuidValue = $(this).parent().parent().find(
								"td[title=uuid]").html();
						editPost(uuidValue);
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
			id : "postName",
			name : "岗位名称",
			hide : false,
			width : "10%"
		}, {
			id : "postCode",
			name : "岗位编码",
			hide : false,
			width : "10%"
		}, {
			id : "postDis",
			name : "岗位职责",
			hide : false,
			width : "30%"
		}, {
			id : "postLevel",
			name : "postLevel",
			hide : true,
			width : "0%"
		}, {
			id : "parentid",
			name : "parentid",
			hide : true,
			width : "0%"
		}, {
			id : "orgid",
			name : "orgid",
			hide : true,
			width : "0%"
		}]
	};
	$(document).ready(function(){
		$.post('${ctx}/posts/postTree?parentid=' + parentid,function (data){
			$.fn.zTree.init($("#postTree"), treeSetting,
					data);
		});
	
		resetTable();
	});
</script>