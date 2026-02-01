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
      //sb.append("\"ptList\":" + ds.getList("call cf2.hierarchy_cb(:userId, :compCode, 'PTYPE', :null)", userId, compCode, request) + ",");
      //sb.append("\"brandList\":" + ds.getList("call cf2.hierarchy_cb(:userId, :compCode, 'BRAND', :null)", userId, compCode, request) + "");
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
    else if (dtType.equals("loadTemplate"))
    {
      sb.append("{");
      sb.append("\"template\":" + ds.getObject("call cf2.attr_tmpl_get(:userId, :compCode, :template_id)", userId, compCode, request) + ",");
      sb.append("\"ptListSelected\":" + ds.getList("call cf2.attr_tmpl_ptype_lst(:userId, :compCode, :template_id)", userId, compCode, request) + ",");
      sb.append("\"groupListSelected\":" + ds.getList("call cf2.attr_tmpl_group_lst(:userId, :compCode, :template_id)", userId, compCode, request) + ",");
      sb.append("\"tree\":" + ds.getList("call cf2.attr_tmpl_group_tree(:userId, :compCode, :template_id)", userId, compCode, request) + "");
      sb.append("}");
    }
    else if (dtType.equals("doSaveTemplate"))
    {
      ds.Update("call cf2.attr_tmpl_upd(:userId, :compCode, '" + ip + "', :id, :name, :status, :description)", userId, compCode, request);
    }
    else if (dtType.equals("ptLinkSubmit"))
    {
      ds.Update("call cf2.attr_tmpl_ptype_mu(:userId, :compCode, '" + ip + "', :template_id, :list)", userId, compCode, request);
    }
    else if (dtType.equals("groupLinkSubmit"))
    {
      ds.Update("call cf2.attr_tmpl_group_mu(:userId, :compCode, '" + ip + "', :template_id, :list)", userId, compCode, request);
    }
    else if (dtType.equals("doRemoveGroup"))
    {
      ds.Update("call cf2.attr_tmpl_group_upd(:userId, :compCode, '" + ip + "', :template_id, :group2unlink, '1')", userId, compCode, request);
    }
    else if (dtType.equals("doRemovePt"))
    {
      ds.Update("call cf2.attr_tmpl_ptype_upd(:userId, :compCode, '" + ip + "', :template_id, :pt2unlink, :brand2unlink, '1')", userId, compCode, request);
    }
    else if (dtType.equals("groupList"))
    {
      sb.append(ds.getList("call cf2.attr_group_cb(:userId, :compCode)", userId, compCode, request));
    }
    else if (dtType.equals("ptList"))
    {
      sb.append(ds.getList("call cf2.hierarchy_cb(:userId, :compCode, 'PTYPE', :null)", userId, compCode, request));
    }
    else if (dtType.equals("templateSubmit"))
    {
        ds.Update("call cf2.attr_tmpl_upd(:userId, :compCode, '" + ip + "', :id, :name, :status, :groupList, :ptList )", userId, compCode, request);
    }
    else if (dtType.equals("doSort"))
    {
        ds.Update("call cf2.attr_tmpl_group_ord(:userId, :compCode, '" + ip + "', :id, :type)", userId, compCode, request);
    }
    else if (dtType.equals("changeStatus"))
    {
        ds.Update("call cf2.attr_tmpl_group_sts(:userId, :compCode, '" + ip + "', :id, :status)", userId, compCode, request);
    }
    else if (dtType.equals("attrInTemplateDlgOpen"))
    {
      sb.append("{");
      sb.append("\"item\":" + ds.getObject("call cf2.attr_tmpl_item_get(:userId, :compCode, :id)", userId, compCode, request) + ",");
      sb.append("\"unitList\":" + ds.getList("call cf2.measure_unit_id20(:userId, :compCode, :id)", userId, compCode, request) + "");
      sb.append("}");
    }
    else if (dtType.equals("attrInTemplateSubmit"))
    {
      ds.Update("call cf2.attr_tmpl_item_upd(:userId, :compCode, '" + ip + "', :id, :unit, :is_bundle, :is_required, :is_internal)", userId, compCode, request);
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

