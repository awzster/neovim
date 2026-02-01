<!-- $Id: $ -->
<jsp:useBean id="logininfo" scope="session" class="com.asbis.loginInfo">
  <% logininfo.setGuest(true); %>
</jsp:useBean>
<%
    response.setContentType("application/json; charset=UTF-8");
    if (logininfo.getUSER_ID() == null)
    {
      ((HttpServletResponse)response).sendError(403, "Session has been lost");
      return ;
    }
%>
<app:init auth="true" checkRights="false"/>
<%@ page import="com.google.gson.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.asbis.*" %>
<%
  out.clear();
  com.asbis.DsResult ds = new com.asbis.DsResult();
  java.sql.Connection con = null;
  try
  {
    con = logininfo.getConnection();

    ds.setLOGON(con);
    StringBuffer sb = new StringBuffer("");
    String userId = logininfo.getUSER_ID();
    String compCode = request.getParameter("compCode");
    String dtType = request.getParameter("dtType");
    String ip = request.getRemoteAddr();
    if (dtType == null)
      dtType = "";

    if (dtType.equals("loadFilter"))
    {
      sb.append("{");
      sb.append("}");
    }
    else if (dtType.equals("load"))
    {
      sb.append(ds.getList("call cf2.tree_lst(:userId, :compCode)", userId, compCode, request));
    }
    else if (dtType.equals("loadTree"))
    {
      sb.append(ds.getList("call cf2.tree_lst(:userId, :compCode, :trre_id)", userId, compCode, request));
    }
    getO


    else
      ((HttpServletResponse)response).sendError(456, "No such dtType: " + dtType);

    if (sb.length() == 0)
      out.println("{}");
    else
      out.println(sb.toString());
  }
  catch (Exception e)
  {
    String msg = e.getMessage();
    if (msg == null || msg.equals(""))
      msg = "Can't detect error!";
    ((HttpServletResponse)response).sendError(456, msg);
  }
  finally
  {
    ds = null;
    logininfo.releaseConnection(con);
    con = null;
  }
%>
<%!
private final static String className = "className";
public String getName() { return className; }
%>

