<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="description" content="overview & stats" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="Cache-Control" content="no-store" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<link rel="stylesheet" href="${ctx}/resources/static/bootstrap/css/bootstrap.css"  type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/bootstrap/css/bootstrap-responsive.css"  type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/bootstrap/font-awesome/css/font-awesome.css"  type="text/css">
<link rel="stylesheet" href="${ctx}/resources/static/css/oa.css"  type="text/css">
<link  rel="stylesheet" href="${ctx}/resources/static/sco/css/scojs.css" type="text/css">
<link  rel="stylesheet" href="${ctx}/resources/static/hubspot/build/css/messenger.css" type="text/css">
<link  rel="stylesheet" href="${ctx}/resources/static/hubspot/build/css/messenger-theme-future.css" type="text/css">
  <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
        background:#EEEEEE;
      }
    </style>
<script src="${ctx}/resources/static/jquery/jquery-1.9.1.min.js" type="text/javascript" ></script>
<script src="${ctx}/resources/static/jquery/jquery.json-2.4.min.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/jquery/jquery.form.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/bootstrap/js/bootstrap.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/sco/js/sco.message.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/sco/js/sco.confirm.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/hubspot/build/js/messenger.min.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/js/myvalid.js" type="text/javascript"></script>
<script src="${ctx}/resources/static/js/mycommonjs.js" type="text/javascript"></script>
<sitemesh:head/>
</head>
<body >

	<div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#">办公平台</a>
          <div class="nav-collapse collapse">
            <p class="navbar-text pull-right">
              	登陆人 <a href="${ctx}/login/logout" class="navbar-link" id="userName">Username</a>
            </p>
            <ul class="nav">
              <li class="active"><a href="${ctx}/orgs">组织维护</a></li>
              <li><a href="${ctx}/posts">岗位维护</a></li>
              <li><a href="${ctx}/employees/page">人员维护</a></li>
               <li><a href="${ctx}/reses/page">资源维护</a></li>
               <li><a href="${ctx}/powers/page">授权作业</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
    <div  id="container" class="container backColor">
	<sitemesh:body/>
	</div>
	<script type="text/javascript">
		$.getJSON('${ctx}/login/info',function(data){
			$("#userName").html(data.loginName);
			console.log(data);
		});
	</script>
</body>
</html>