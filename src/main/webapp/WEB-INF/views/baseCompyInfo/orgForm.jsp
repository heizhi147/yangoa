<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<form id="orgForm" action="${ctx}/orgs/org/insert"
		method="post">
	<fieldset>
		<legend>
			<small>组织信息</small>
		</legend>
		<div class="control-group">
			<label for="form_code" class="control-label">组织名称:</label>
			<div class="controls">
				<input type="text" id="form_code" name="orgName"
					value="${org.orgName}" />
			</div>
		</div>

		<div class="control-group">
			<label for="form_code" class="control-label">组织编码:</label>
			<div class="controls">
				<input type="text" id="form_code" name="orgCode"
					value="${org.orgCode}" />
			</div>
		</div>
		<div class="control-group">
			<label for="form_code" class="control-label">组织地址:</label>
			<div class="controls">
				<input type="text" id="form_code" name="address"
					value="${org.address}" />
			</div>
		</div>
		<input type="hidden" name="parentid" value="${org.address}" />
		<div class="form-actions">
			<input id="submit_btn" class="btn btn-primary" type="submit"
				value="提交" />&nbsp; <input id="cancel_btn" class="btn"
				type="button" value="返回" onclick="history.back()" />
		</div>
	</fieldset>
</form>