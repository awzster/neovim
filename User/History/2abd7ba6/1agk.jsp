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

    else if (dtType.equals("linkHint"))
    {
      java.util.ArrayList<java.util.Hashtable> list = ds.getResult("call cf2.attr_tmpl_hint(:userId, :compCode, :id, :type)", userId, compCode, request);
      String res = "<table class=\"table\"><thead><tr><th>#</th><th>" + request.getParameter("title") + "</th></tr></thead><body>";
      for (int i = 0; i < list.size(); i++)
      {
        Hashtable<String, String> o = (Hashtable <String, String>) list.get(i);
        res += "<tr>" +
            "<td>" + o.get( "pos") +
            "<td class='text-left'>" + o.get("name") + "</td>" +
            "</tr>";
      }
      res += "</body></table>";
      response.setContentType("text/html; charset=UTF-8");
      out.clear();
      out.println("<div>" + res + "</div>");
      return;
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

