<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page
	import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ page import="org.apache.shiro.authc.ExcessiveAttemptsException"%>
<%@ page import="org.apache.shiro.authc.IncorrectCredentialsException"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
<link rel="stylesheet"
	href="${ctx}/resources/static/bootstrap/css/bootstrap.css"
	type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/css/oa.css"
	type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/css/flat-ui.css"
	type="text/css">
	<style>
      body {
        
        background:#777777;
      }
    </style>
<script src="${ctx}/resources/static/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="${ctx}/resources/static/bootstrap/js/bootstrap.js"
	type="text/javascript"></script>


</head>
<body>
	<br><br><br>

	<div class="login">
		<div class="login-screen">
			<div class="login-icon">
			<img src="${ctx}/resources/static/images/045.jpg" alt="Welcome to Mail App" />
				<h4>
					欢迎访问 <small>办公系统</small>
				</h4>
			</div>

			<div class="login-form">
				<form id="loginForm" action="${ctx}/login" method="post">

					<%
						String error = (String) request
								.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
						if (error != null) {
					%>
					<div class="alert alert-error input-medium controls">
						<button class="close" data-dismiss="alert">×</button>
						登录失败，请重试.
					</div>
					<%
						}
					%>
					<div class="control-group">

						<div class="controls">
							<input placeholder="输入名称" type="text" id="username"
								name="username" value="${username}"
								class="input-block-level required " />
						</div>
					</div>
					<div class="control-group">

						<div class="controls">
							<input placeholder="输入密码" type="password" id="password"
								name="password" class="input-block-level required" />
						</div>
					</div>

					<div class="control-group">
						<div class="controls">
							<input id="submit_btn" class="btn  btn-block  btn-primary"
								type="submit" value="登录" />
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>


</body>
</html>