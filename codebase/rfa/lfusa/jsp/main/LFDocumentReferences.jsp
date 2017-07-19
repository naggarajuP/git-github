<%-- Copyright (c) 2011 PTC Inc.  All Rights Reserved --%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
        import="java.util.*,
                java.net.URL,
                com.lcs.wc.db.SearchResults,
                com.lcs.wc.client.*,
                com.lcs.wc.client.web.*,
                com.lcs.wc.document.*,
                com.lcs.wc.ftpjob.FtpDocumentHelper,
                com.lcs.wc.flextype.*,
                com.lcs.wc.foundation.*,
                com.lcs.wc.part.LCSPartQuery,
                com.lcs.wc.part.LCSPart,
                com.lcs.wc.util.*,
                wt.locks.LockHelper,
                wt.ownership.*,
                wt.org.*,
                wt.doc.WTDocumentMaster,
                wt.content.*,
                wt.enterprise.RevisionControlled,
                wt.fc.WTObject,
                wt.vc.Iterated,
                wt.util.*"
%>
<%!
    public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final boolean COMMENT_GENERATOR = LCSProperties.getBoolean("com.lcs.wc.client.web.COMMENT_GENERATOR");
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final boolean REVISE = LCSProperties.getBoolean("com.lcs.wc.document.LCSDocument.revise");
    public static final String DOCUMENT_REFERENCE_TABLE = PageManager.getPageURL("DOCUMENT_REFERENCE_TABLE", null);

%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INCLUDED FILES  //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>

<%

    String returnActivity = request.getParameter("returnActivity");
    String returnOid = request.getParameter("returnOid");
    String targetOid = request.getParameter("targetOid");
    String returnAddlParams = request.getParameter("returnAddlParams");
    String copyModeParam = "VIEW";

    WTObject obj = (WTObject) LCSQuery.findObjectById(targetOid);
    request.setAttribute("DOCUMENT_REF_TARGET", obj); 

    boolean hasMenus = true;
    if (obj instanceof Iterated && !VersionHelper.isLatestIteration((Iterated)obj)) {
        hasMenus = false;
    }
    String targetSuffix = FormatHelper.getNumericFromOid(targetOid);

%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////////// JSP METHODS /////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////////// JAVASCRIPT /////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script type="text/javascript" src="<%=URL_CONTEXT%>/javascript/main/documentReferences.js"></script>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////// BEGIN HTML ///////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input type="hidden" name="isDocRefActivity" value="true">
<%
   if (COMMENT_GENERATOR) {
       %><!-- DocumentReferences.jsp--><%
   }
%>
<%
Locale locale = lcsContext.getLocale();
String associatedDocumentsGrpTle = WTMessage.getLocalizedMessage ( RB.MAIN, "associatedDocuments_GRP_TLE", RB.objA, locale ) ;
String actionsMenuLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "actions_LBL", RB.objA, locale ) ;
String createNewReferenceDocumentOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "createNewReferenceDocument_OPT", RB.objA, locale ) ;
String createNewDescribedByDocumentOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "createNewDescribedByDocument_OPT", RB.objA, locale ) ;
String addExistingReferenceDocumentOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "addExistingReferenceDocument_OPT", RB.objA, locale ) ;
String addExistingDescribedByDocumentOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "addExistingDescribedByDocument_OPT", RB.objA, locale ) ;
String removeAllReferenceDocumentsOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "removeAllReferenceDocuments_OPT", RB.objA, locale ) ;
String removeAllDescribedByDocumentsOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "removeAllDescribedByDocuments_OPT", RB.objA, locale ) ;
String removeAllDocumentsOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "removeAllDocuments_OPT", RB.objA, locale ) ;
String groupId = "associatedDocuments" + "_" + System.currentTimeMillis();
%>

<%= tg.startGroupBorder() %>
<%= tg.startGroupTitle(groupId) %>
<%= associatedDocumentsGrpTle %>
<%= tg.endTitle() %>
<%= tg.startGroupContentTable(groupId) %>

    <% if (ACLHelper.hasModifyAccess((FlexTyped)obj)) { %>
   <tr>
      <td class="GROUPTABLEBACKGROUND">
         <table>
            <tr>
               <td class="LABEL">
                   <%= actionsMenuLabel %>
               </td>

                    <td class="PAGEHEADINGTEXT" align="right">
                    <% if (hasMenus) { %>
                    <select class="FORMELEMENT" onChange="evalList(this)">
                         <option>
                         <option value="addNewDocument('<%= targetSuffix %>', '<%= LCSDocumentLogic.REFERENCE_DOC%>')"><%= createNewReferenceDocumentOpt %>
                         <% if (REVISE) { %>
                                <option value="addNewDocument('<%= targetSuffix %>', '<%= LCSDocumentLogic.DESCRIBEDBY_DOC%>')"><%= createNewDescribedByDocumentOpt %>
                         <% } %>
                                         
                         <% if(obj instanceof LCSPart){ %>
                         <option value="launchModuleChooser('DOCUMENT','' ,'' ,'', true, 'addDocuments', false, 'master', '', '&selectParameter=<%= targetSuffix %>');this.selectedIndex=0"><%= addExistingReferenceDocumentOpt %>
                            <% if (REVISE) { %>
                                <option value="launchModuleChooser('DOCUMENT','' ,'' ,'', true, 'addDocuments', false, 'version', '', '&selectParameter=<%= targetSuffix %>');this.selectedIndex=0"><%= addExistingDescribedByDocumentOpt %>
                            <% } %>
                         <% } else if(obj instanceof LCSDocument){ %>
                         <option value="launchModuleChooser('DOCUMENT','' ,'' ,'', true, 'addDocuments', false, 'version', '', '&selectParameter=<%= targetSuffix %>');this.selectedIndex=0"><%= addExistingReferenceDocumentOpt %>
                            <% if (REVISE) { %>
                                <option value="launchModuleChooser('DOCUMENT','' ,'' ,'', true, 'addDocuments', false, 'version', '', '&selectParameter=<%= targetSuffix %>');this.selectedIndex=0"><%= addExistingDescribedByDocumentOpt %>
                            <% } %>
                         <% } else {  %>
                         <option value="launchModuleChooser('DOCUMENT','' ,'' ,'', true, 'addDocuments', false, 'master', '', '&selectParameter=<%= targetSuffix %>');this.selectedIndex=0"><%= addExistingReferenceDocumentOpt %>
                            <% if (REVISE) { %>
                                <option value="launchModuleChooser('DOCUMENT','' ,'' ,'', true, 'addDocuments', false, 'version', '', '&selectParameter=<%= targetSuffix %>');this.selectedIndex=0"><%= addExistingDescribedByDocumentOpt %>
                            <% } %>
                         <% } %>

                         <% if (REVISE) { %>
                                <option value="javascript:removeDocuments('<%= targetSuffix %>', '<%= LCSDocumentLogic.REFERENCE_DOC%>') "><%= removeAllReferenceDocumentsOpt %>
                                <option value="javascript:removeDocuments('<%= targetSuffix %>', '<%= LCSDocumentLogic.DESCRIBEDBY_DOC%>') "><%= removeAllDescribedByDocumentsOpt %>
                         <% } %>
						 <%if(!lcsContext.isVendor){%>
                         <option value="javascript:removeDocuments('<%= targetSuffix %>', '<%= LCSDocumentLogic.ALL_DOCS%>') "><%= removeAllDocumentsOpt %>
						 <%}%>
                    </select>
                    <% } %>
                    </td>
            </tr>
         </table>
      </td>
   </tr>
   <% } %>


    <jsp:include page="<%=subURLFolder+ DOCUMENT_REFERENCE_TABLE %>" flush="true">
        <jsp:param name="targetOid" value="<%= targetOid %>" />
        <jsp:param name="returnOid" value="<%= returnOid %>" />
        <jsp:param name="returnActivity" value="<%= returnActivity %>" />
        <jsp:param name="returnAddlParams" value="<%= returnAddlParams %>" />
        <jsp:param name="copyMode" value="<%= copyModeParam %>" />
    </jsp:include>


