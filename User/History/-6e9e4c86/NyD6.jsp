<%@ taglib uri="http://www.value4it.com/app.tld" prefix="app" %>
<app:init auth="true" checkRights="true"/>
<% out.clear(); %>
<jsp:include page="/include/smartHeader.jsp" flush="true">
<jsp:param name="jquery-version" value="/lib/js/angular/lib/jquery-2.2.2.js" />
</jsp:include>

<%
String foo = Long.toString(new java.util.Date().getTime());
String userId = logininfo.getUSER_ID();
String compCode = accessrights.getCOMP_CODE();
com.it4profi.ums.helpers.UserInfo userInfo = new com.it4profi.ums.helpers.UserInfo(logininfo.getUSER_ID());
String lang = request.getParameter("lang");
if (lang == null)
  lang = (String)session.getValue("LANG");
%>
<link rel="stylesheet" href="/lib/js/angular/css/ag-grid/ag-grid.25.1.0.min.css"></link>
<link rel="stylesheet" href="/lib/css/jquery.datetimepicker.css"></link>

<link rel="stylesheet" href="/lib/js/angular/directives/ngModal/ngModalRs.css"/>
<link rel="stylesheet" href="/lib/js/qtip/jquery.qtip.min.css"></link>
<link rel="stylesheet" href="/css/fontawesome-free-5.15.4.all.min.css"></link>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link rel="stylesheet" href="/lib/js/angular/css/select.min.css"></link>
<link rel="stylesheet" href="/lib/js/angular/css/select2.ext.css"></link>

<link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&family=Roboto+Condensed:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;1,100;1,300;1,400;1,500;1,700&family=Saira+Extra+Condensed:wght@100;200;300;400;500;600;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/toaster.min.css"></link>
<link rel="stylesheet" href="../css/common.css?foo=<%=foo%>"></link>
<link rel="stylesheet" href="./css/app.css?foo=<%=foo%>"></link>

<script src="/lib/js/angular/lib/angular1.8.min.js"></script>
<script src="/lib/js/angular/lib/angular-ui-router.min.js"></script>
<script src="/lib/js/angular/lib/angular-animate1.8.min.js"></script>
<script src="/lib/js/angular/directives/ngModal/ngModalRs.js"></script>
<script src="/lib/js/angular/lib/ag-grid-enterprise.27.0.1.min.js"></script>
<script src="/lib/js/angular/lib/sweetalert2-11.14.5.all.min.js"></script>
<script src="/lib/js/angular/lib/uib-dropdown-multiselect.js"></script>
<script src="/lib/js/angular/directives/asbCommon/asbCommonExt.js"></script>
<script src="/lib/js/angular/lib/ui-bootstrap-tpls.js"></script>
<script src="/lib/js/angular/lib/select.ext.min.js"></script>
<script src="/contentFc/js/toaster.min.js"></script>

<script src="/lib/js/spin.min.js"></script>
<script src="/lib/js/moment.js"></script>
<script src="/lib/js/jquery.datetimepicker.js"></script>
<script src="/lib/js/qtip/jquery.qtip.min.js"></script>
<script src="/lib/js/lodash.min.js"></script>
<script src="/lib/js/angular/directives/toExcel/toExcel.js"></script>
<script src="/lib/js/angular/directives/filterState/filterState.js"></script>

<script src="/lib/js/angular/js/agGridState.js"></script>
<script src="./js/app.js?foo=<%=foo%>"></script>
<script src="/lib/js/angular/js/app.common1.8.js"></script>
<script src="./js/list.controller.js?foo=<%=foo%>"></script>
<script src="./js/tree.controller.js?foo=<%=foo%>"></script>
<script src="./js/calcService.js?foo=<%=foo%>"></script>
<script src="./js/gridOptionsApi.js?foo=<%=foo%>"></script>
<script src="./js/gridOptionsEditApi.js?foo=<%=foo%>"></script>
<script src="../js/NotifierService.js?foo=<%=foo%>"></script>
<script src="../js/directives.js?foo=<%=foo%>"></script>
<script src="../js/rendererService.js?foo=<%=foo%>"></script>
<script src="../js/commonService.js?foo=<%=foo%>"></script>

<div id="main-div" ng-app="app" style="height: calc(100% - 6em); padding: 0 2px;">
  <toaster-container></toaster-container>
  <div style="position: fixed; left: calc(50vw - 30px); top: 40%; background: transparent; padding: 10px; display: none; z-index: 999999" id="loading"></div>
  <input type="hidden" id="compCode" value="<%=compCode%>"></input>
  <input type="hidden" id="email" value="<%=userInfo.email%>"></input>
  <input type="hidden" id="userName" value="<%=userInfo.firstName%> <%=userInfo.lastName%>"></input>
  <input type="hidden" id="userId" value="<%=userId%>"></input>
  <input type="hidden" id="lang" value="<%=lang%>"></input>
  <input type="hidden" id="pageId" value="<%=session.getAttribute("pageId")%>"></input>

  <div style="height: 100% !important;" ui-view>

</div>

</body>
</html>

