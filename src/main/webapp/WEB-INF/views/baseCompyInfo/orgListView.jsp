<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
	<legend>组织信息</legend>
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success">
			<button data-dismiss="alert" class="close">×</button>
			${message}
		</div>
	</c:if>
	<input type="hidden" name="parentid" value="${parentid}" />
<form id="form1">
	<div class="row-fluid">
		<div class="span12">
			<a class="btn" href="${ctx}/orgs/org/create">创建组织</a>
			
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12">
			<table class="table table-striped  table-bordered table-hover">
				<thead>
					<tr>
						<th>组织名称</th>
						<th>组织编码</th>
						<th>组织地址</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${orgList}" var="org">
						<tr>
							<td><a href="${ctx}/orgs/org/delete/${org.uuid}">删除</a></td>
							<td><a href="${ctx}/orgs/org/update/${org.uuid}">${org.orgName}</a></td>
							<td><a href="${ctx}/orgs/org/update/${org.uuid}">${org.orgCode}</a></td>
							<td><a href="${ctx}/orgs/org/update/${org.uuid}">${org.address}</a></td>
							
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</form>