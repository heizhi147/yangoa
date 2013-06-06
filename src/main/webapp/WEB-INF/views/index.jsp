<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
<title>办公平台</title>
<link rel="apple-touch-icon" sizes="72x72" href="${ctx}/resources/static/themes/default/images/touch-logo.png">
<link rel="apple-touch-icon" sizes="114x114" href="${ctx}/resources/static/themes/default/images/touch-logo@2x.png">
<link type="image/x-icon" href="favicon.ico" rel="shortcut icon">
<link type="text/css" rel="stylesheet" href="${ctx}/resources/static/themes/default/css/jui.core.css">
<link type="text/css" rel="stylesheet" href="${ctx}/resources/static/themes/default/css/layout.css">
<link type="text/css" rel="stylesheet" href="${ctx}/resources/static/themes/default/css/style.css">
<link type="text/css" rel="stylesheet" href="${ctx}/resources/static/sco/css/scojs.css">
<!--[if lte IE 8]><script src="scripts/html5.js"></script><script src="scripts/css3-mediaqueries.js"></script><link rel="stylesheet" href="themes/default/css/iehack.css"><![endif]-->
<!--[if lte IE 6]><script src="scripts/iepngfix_tilebg.js"></script><![endif]-->


<link rel="stylesheet" href="${ctx}/resources/static/bootstrap/css/bootstrap-responsive.css"  type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/bootstrap/css/bootstrap.css"  type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/css/oa.css"  type="text/css">

<script src="${ctx}/resources/static/jquery/jquery-1.9.1.min.js" type="text/javascript" ></script>
<script src="${ctx}/resources/static/jquery/jquery.json-2.4.min.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/jquery/jquery.form.js" type="text/javascript"></script>

<script src="${ctx}/resources/static/bootstrap/js/bootstrap.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/sco/js/sco.message.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/js/myvalid.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/js/mycommonjs.js" type="text/javascript"></script>

<sitemesh:head/>
</head>

<body>
<div id="container" class="flyout">
	<header id="header">
		<section id="global-nav" class="flyout">
			<nav class="layout clearfix">
				<ul class="projects">
					<li class="sys active"><a class="toggle" href="#">切换系统</a><!--active-->
						
					</li>
					<li class="com"><a class="toggle" href="#">公司：北京志能祥赢节能环保科技有限公司</a>
						<div class="pop-nav">
							<ul>
								<li><a href="#">北京志能祥赢节能环保科技有限公司</a></li>
								<li><a href="#">哈尔滨嘉天房地产开发股份有限公司</a></li>
								<li><a href="#">苏尼特右旗朱日和铜业有限责任公司</a></li>
							</ul>
						</div>
					</li>
				</ul>
				<ul class="links">
					<li class="contact"><a class="toggle" target="_blank" href="#">通讯录</a></li>
					<li class="email"><a class="toggle" target="_blank" href="#">电子邮箱</a></li>
					<li class="help"><a class="toggle" target="_blank" href="#">帮助中心</a></li>
					
				</ul>
			</nav>
		</section>
		<div id="site-logo" class="layout">
		
		</div>
		<nav id="site-nav" class="layout">
			<div class="nav">
				<div class="main-nav">
					<div class="nav-bd">
						<div class="nav-ct">
							<ul>
								<li><a href="#"></a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="sub-nav">
					<div class="sub-bd">
						<ul>
							<li>
								
							</li>
						</ul>
					</div>
				</div>
				<div class="" style="display:none;">
					历史 收藏 通知
				</div>
			</div>
			<div id="msg">
	
			</div>
		</nav>
	</header>
	<div id="content" class="layout">
			<sitemesh:body/>
			<br><br>
	</div>
	<footer id="footer">
		<div class="layout">
			<hr>
			<div class="clearfix">
				<ul class="footer-nav">
					<li><a href="#">服务条款</a></li>
					<li><a href="#">技术支持</a></li>
					<li><a href="#">问题反馈</a></li>
				</ul>
				<p class="copyright">&copy; 2013 JIANLONG STEEL, All Rights Reserved.</p>
			</div>
		</div>
	</footer>
</div>
</body>
</html>