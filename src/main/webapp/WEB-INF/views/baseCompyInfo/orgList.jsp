<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <div data-options="region:'west',title:'West',split:true" style="width:200px;">
   		<ul id="tt" class="easyui-tree">
		</ul>
    </div>  
    <div data-options="region:'center',title:'center title'">
    	<table id="dg" class="easyui-datagrid" 
        toolbar="#toolbar"  idField="uuid">    
</table>  
<div id="toolbar">  
    <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newOrg()">新增</a>  
    <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editOrg()">修改</a>  
    <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyOrg()">删除</a>  
</div>  
<div id="dd" class="easyui-dialog"  style="width:400px;height:300px;padding:10px 20px"  
        data-options="resizable:true,modal:true,buttons:'#bb',closed:true">  
        <div class="ftitle">组织信息</div>  
        <form id="ff"> 
         <div class="fitem">  
            <label>组织名称:</label>  
            <input name="orgName">  
        </div>  
          <div class="fitem">  
            <label>组织编码:</label>  
            <input name="orgCode">  
        </div>  
          <div class="fitem">  
            <label>地址:</label>  
            <input name="address">  
        </div>  
       		       			<input type="hidden" name="uuid"/>
       		       			<input type="hidden" name="orgLevel"/>
       		       			<input type="hidden" name="parentid"/>
     </form>
</div>  
<div id="bb">
	<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onClick="saveOrgDia()">保存</a>
	<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onClick="closeOrgDia()">撤销</a>
</div>
    </div>  
    <script>
$(document).ready(function(){
	$('#dg').datagrid({  
	    columns:[[  
			{field:'ck',checkbox:true},
	        {field:'uuid',title:'uuid',width:100,hidden:true},
	        {field:'orgName',title:'组织名称',width:100},  
	        {field:'orgCode',title:'组织编码',width:100},  
	        {field:'orgLevel',title:'orgLevel',width:100,hidden:true},
	        {field:'address',title:'地址',width:100},
	        {field:'parentid',title:'parentid',width:100,hidden:true}
	    ]]  
	});  
	queryOrgRootTree();
});
var url;
var nodeId;
function queryOrgRootTree(){
	$.getJSON('${ctx}/org/orgRootTree',function(data){
		console.log(data);
		$('#tt').tree({
			data:data,
			  onBeforeExpand:function(node,param){                         
				  $('#tt').tree('options').url = '${ctx}/org/orgChildTree/'+node.id; 
				      },
			onClick:function(node){
				nodeId=node.id;
				$('#tt').tree('expand',node.target);
                $.getJSON('${ctx}/org/childOrg/'+node.id,function(data){
                	$('#dg').datagrid('loadData',{'rows':data});
               });
			}
		});
	});
}
function queryRootOrg(){
	$.ajax({
		type : "GET",
		url : "${ctx}/org/rootOrg",
		dataType : "json",
		contentType : "application/json; charset=utf-8",
		processData : false,
		success : function(rsData) {
				$('#dg').datagrid('loadData',{'rows':rsData});
		}
	});
}

function append(){ 
                var node = $('#tt2').tree('getSelected'); 
                $('#tt2').tree('append', { 
                    parent: (node ? node.target : null), 
                    data: [{ 
                        text: 'new1', 
                       checked: true 
                    }, { 
                        text: 'new2', 
                        state: 'closed', 
                        children: [{ 
                            text: 'subnew1' 
                        }, { 
                            text: 'subnew2' 

                        }] 
                    }] 
                }); 
            } 

function newOrg(){
	  $('#ff').form('clear'); 
	  $('#ff').form('load',{
		  parentid:nodeId
		});
	$('#dd').dialog('open');
	url="${ctx}/org/rootOrg/insert";
}
function closeOrgDia(){	
	$('#dd').dialog('close');
}
function saveOrgDia(){
	var orgFormData=$('#ff').serializeArray();
	var orgJson=changeFormData(orgFormData);
	$.ajax({
		type : "POST",
		url : url,
		data:orgJson,
		dataType : "json",
		contentType : "application/json; charset=utf-8",
		processData : false,
		success : function(rsData) {
			var data=rsData.data;
			console.log(data);
			$('#dd').dialog('close');
			$('#dg').datagrid('appendRow',data);
			var selected=$('#tt').tree('getSelected');
			$('#tt').tree('append',{
				parent:selected.target,
				data:[{
					id:data.uuid,
					text:data.orgName
				}]
			});
			$.messager.show({	// show error message
				title: '消息',
				msg: rsData.message
			});
		},
		error : function(jqXHR, errFlag) {
			console.log(jqXHR.responseText);
			console.log(errFlag);
		}
	});
}
function destroyOrg(){
	var rows = $('#dg').datagrid('getSelections');
	console.log(rows);
	if (rows){
		$.messager.confirm('Confirm','是否进行删除?',function(r){
			if (r){
					var data=$.toJSON(rows);
				$.ajax({
					type : "POST",
					url : "${ctx}/org/rootOrg/delete",
					data:data,
					dataType : "json",
					contentType : "application/json; charset=utf-8",
					processData : false,
					success : function(rsData) {
					
						for(var  i=0;i<rows.length;i++){
							var row =rows[i];
							var index=$('#dg').datagrid('getRowIndex',row);
							$('#dg').datagrid('deleteRow',index);
						}
						$.messager.show({	// show error message
							title: '消息',
							msg: rsData.message
						});
					},
					error : function(jqXHR, errFlag) {
						console.log(jqXHR.responseText);
						console.log(errFlag);
					}
				});
			}
		});
	}

}
function editOrg(){
	var row = $('#dg').datagrid('getSelected');  
	if (row){  
	    $('#dd').dialog('open').dialog('setTitle','修改');  
	    $('#ff').form('load',row);   
	    url="${ctx}/org/rootOrg/update";
	} 
}
</script>
<style type="text/css">
		#fm{
			margin:0;
			padding:10px 30px;
		}
		.ftitle{
			font-size:14px;
			font-weight:bold;
			padding:5px 0;
			margin-bottom:10px;
			border-bottom:1px solid #ccc;
		}
		.fitem{
			margin-bottom:5px;
		}
		.fitem label{
			display:inline-block;
			width:80px;
		}
	</style>
    