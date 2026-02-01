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
      sb.append("\"typeOfList\": " + ds.getList("call cf2.tree_of_cb(:userId, :compCode)", userId, compCode, request) + "");
      sb.append("}");
    }
    else if (dtType.equals("load"))
    {
      sb.append(ds.getList("call cf2.tree_filter_lst(:userId, :compCode)", userId, compCode, request));
    }
    else if (dtType.equals("loadFilter"))
    {
      sb.append(ds.getList("call cf2.tree_node_lst(:userId, :compCode, :tree_id)", userId, compCode, request));
    }
    else if (dtType.equals("getFilter"))
    {
      sb.append(ds.getObject("call cf2.tree_get(:userId, :compCode, :tree_id)", userId, compCode, request));
    }
    else if (dtType.equals("filterGet"))
    {
      sb.append(ds.getObject("call cf2.tree_filter_get(:userId, :compCode, :id)", userId, compCode, request));
    }
    else if (dtType.equals("submit"))
    {
      ds.Update("call cf2.tree_node_upd(:userId, :compCode, '" + ip + "', :tree_id, :id, :parent_id, :name, :has_products)", userId, compCode, request);
    }
    else if (dtType.equals("doSort"))
    {
      ds.Update("call cf2.tree_node_ord(:userId, :compCode, '" + ip + "', :id, :type)", userId, compCode, request);
    }
    else if (dtType.equals("nodeList"))
    {
      sb.append(ds.getList("call cf2.tree_node2move(:userId, :compCode, :tree_id, :node_id)", userId, compCode, request));
    }
    else if (dtType.equals("filterSubmit"))
    {
      ds.Update("call cf2.tree_filter_upd(:userId, :compCode, '" + ip + "', :id, :name)", userId, compCode, request);
    }

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

