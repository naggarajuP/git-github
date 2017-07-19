
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ControlException.jsp"
        import="com.lcs.wc.db.SearchResults,
            com.lcs.wc.client.web.PageManager,
                com.lcs.wc.client.web.WebControllers,
                com.lcs.wc.client.Activities,
                com.lcs.wc.flextype.*,
                com.lcs.wc.foundation.*,
                com.lcs.wc.db.*,
                wt.util.*,
                com.lcs.wc.last.*,
            com.lcs.wc.util.*"
%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INCLUDED FILES  //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lastModel" scope="request" class="com.lfusa.wc.last.GBGLCSLastClientModel" />
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>
<% wt.util.WTContext.getContext().setLocale(request.getLocale());%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// STATIS JSP CODE //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");

    public static final String JSPNAME = "LastController";
    public static final boolean DEBUG = LCSProperties.getBoolean("jsp.last.LastController.verbose");
    public static final String MAINTEMPLATE = PageManager.getPageURL("MAINTEMPLATE", null);
	public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
//setting up which RBs to use
Object[] objA = new Object[0];
String RB_MAIN = "com.lcs.wc.resource.MainRB";
String Last_MAIN = "com.lcs.wc.resource.LastRB";

String viewLastPgTle = WTMessage.getLocalizedMessage ( Last_MAIN, "viewLast_PG_TLE", objA ) ;
String createLastPgTle = WTMessage.getLocalizedMessage ( Last_MAIN, "createLast_PG_TLE", objA ) ;
String updateLastPgTle = WTMessage.getLocalizedMessage ( Last_MAIN, "updateLast_PG_TLE", objA ) ;
String lastDetailsPgTle = WTMessage.getLocalizedMessage ( Last_MAIN, "lastDetails_PG_TLE", objA ) ;
String lastSearchCriteriaPgTle = WTMessage.getLocalizedMessage ( Last_MAIN, "lastSearchCriteria_PG_TLE", objA ) ;
String lastSearchResultsPgTle = WTMessage.getLocalizedMessage ( Last_MAIN, "lastSearchResults_PG_TLE", objA ) ;
String lastLabel = WTMessage.getLocalizedMessage ( Last_MAIN, "last_LBL", objA ) ;
%>
<%
    String activity = request.getParameter("activity");
    String action = request.getParameter("action");
    String oid = request.getParameter("oid");
    String returnActivity = request.getParameter("returnActivity");
    String returnAction = request.getParameter("returnAction");
    String returnOid = request.getParameter("returnOid");
    boolean checkReturn = false;

    String title = "";
    String errorMessage = request.getParameter("errorMessage");
	if (FormatHelper.hasContent(errorMessage)) {
		errorMessage = java.net.URLDecoder.decode(errorMessage, defaultCharsetEncoding);
	} else {
	  errorMessage = "";
	}
    String infoMessage = request.getParameter("infoMessage");
    String view = null;
    String formType = "standard";
    String type = "";

    FlexType flexType = null;
    String contextHeaderPage = "";

   ///////////////////////////////////////////////////////////////////
    if(Activities.VIEW_LAST.equals(activity)){
        lastModel.load(oid);
        view = PageManager.VIEW_LAST_PAGE;
        title = viewLastPgTle;


      flexType = lastModel.getFlexType();
   ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////
    } else if(Activities.CREATE_LAST.equals(activity)){

        if(action == null || "INIT".equals(action) || "".equals(action)){

            title = createLastPgTle;
            view = PageManager.CLASSIFY_PAGE;

        } else if("CLASSIFY".equals(action)){

            AttributeValueSetter.setAllAttributes(lastModel, RequestHelper.hashRequest(request));
            if(FormatHelper.hasContent(request.getParameter("directClassifyId"))){
                lastModel.setTypeId(request.getParameter("directClassifyId"));
            }
            title = createLastPgTle;
            view = PageManager.CREATE_LAST_PAGE;

        } else if("SAVE".equals(action)){

         try {
            AttributeValueSetter.setAllAttributes(lastModel, RequestHelper.hashRequest(request));
            lastModel.save();
            oid = FormatHelper.getObjectId(lastModel.getBusinessObject());
            view = PageManager.SAFE_PAGE;
            title = viewLastPgTle;
            action = "INIT";
            activity = Activities.VIEW_LAST;

           } catch(LCSException e){
                view = PageManager.CREATE_LAST_PAGE;
                title = createLastPgTle;
                errorMessage=e.getLocalizedMessage();
           }
      }

      flexType = lastModel.getFlexType();
    ///////////////////////////////////////////////////////////////////
    } else if(Activities.UPDATE_LAST.equals(activity)){

        if(action == null || "INIT".equals(action) || "".equals(action)){

            lastModel.load(oid);
            view = PageManager.UPDATE_LAST_PAGE;
            title = updateLastPgTle;
         //formType = "document";

        } else if("SAVE".equals(action)){
            try{
                lastModel.load(oid);
                AttributeValueSetter.setAllAttributes(lastModel, RequestHelper.hashRequest(request));
                lastModel.save();
                oid = FormatHelper.getVersionId(lastModel.getBusinessObject());

                view = PageManager.SAFE_PAGE;
                title = lastDetailsPgTle;
                action = "INIT";
                activity = Activities.VIEW_LAST;
                checkReturn = true;

            } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.UPDATE_LAST_PAGE;
                title = updateLastPgTle;
            }
        }

      flexType = lastModel.getFlexType();
   ///////////////////////////////////////////////////////////////////
    // ACTIVITY = FIND
    ///////////////////////////////////////////////////////////////////
    } else if(Activities.FIND_LAST.equals(activity)){
	contextHeaderPage = "STANDARD_LIBRARY_CONTEXT_BAR";
        if(action == null || "".equals(action) || "INIT".equals(action)){
            contextHeaderPage = "STANDARD_LIBRARY_CONTEXT_BAR";
            view = PageManager.FIND_LAST_CRITERIA;
            title = lastSearchCriteriaPgTle;
            type = "";

        } else if("CHANGE_TYPE".equals(action)){
            view = PageManager.FIND_LAST_CRITERIA;
            title = lastSearchCriteriaPgTle;
            type = request.getParameter("type");
         flexType = FlexTypeCache.getFlexType(type);

        } else if("SEARCH".equals(action)){
			if("true".equals(request.getParameter("updateMode"))){
				formType = "image";
			}
            type = request.getParameter("type");
            view = PageManager.FIND_LAST_RESULTS;
            title = lastSearchResultsPgTle;

        } else if("RETURN".equals(action)){
         checkReturn = true;
      }
    }
	////////////////////////////////////////////////////////////////////
	// ACTIVITY = COPY : Task PLM-128 Implement Copy last Functionality
	////////////////////////////////////////////////////////////////////
	else if("COPY_LAST".equals(activity)){

		if("COPY".equals(action)){

            lastModel.load(oid);
			PropertyBasedAttributeValueLogic.setAttributes(lastModel, "com.lcs.wc.last.LCSLast", "", "COPY");
			view ="COPY_LAST_PAGE";
			title="Copy Last";

        } else if("SAVE".equals(action)){
				
				lastModel.setTypeId(request.getParameter("typeId"));  	
				
            try {

				LCSLast lastObj = (LCSLast)LCSQuery.findObjectById(oid);
				AttributeValueSetter.setAllAttributes(lastModel, RequestHelper.hashRequest(request));
				lastModel.setCopiedFrom(lastObj);
				LCSLast copiedLastObj=(LCSLast)lastModel.copyLast();
				oid = FormatHelper.getObjectId(copiedLastObj);
				lastModel.load(oid);
                view = PageManager.SAFE_PAGE;
                title = lastDetailsPgTle;
                action = "INIT";
                activity = Activities.VIEW_LAST;
           } catch(LCSException e){
				view ="COPY_LAST_PAGE";
				title="Copy Last";
                errorMessage=e.getLocalizedMessage();
           }

        }

      flexType = lastModel.getFlexType();
	}


    String contentPage = null;
    if(view != null){
        contentPage = PageManager.getPageURL(view, null);
    } else {
        contentPage = "";
    }

    ////////////////////////////////////////////////////////////////////////////
    // GET THE CLIENT MODELS FLEX TYPE FULL NAME
    ////////////////////////////////////////////////////////////////////////////
   String flexTypeName = null;
   if (flexType != null) {
      flexTypeName = flexType.getFullNameDisplay(true);
      type = "OR:com.lcs.wc.flextype.FlexType:" + flexType.getIdNumber();
   }

    ////////////////////////////////////////////////////////////////////////////
    // CHECK RETURN ACTIVITY..
    ////////////////////////////////////////////////////////////////////////////
    if(FormatHelper.hasContent(returnActivity) && checkReturn){
        activity = returnActivity;
        action = returnAction;
        oid = returnOid;
        returnActivity = "";
        returnAction = "";
        returnOid = "";
        %>
        <jsp:forward page="<%=subURLFolder+ WebControllers.MASTER_CONTROLLER %>">
            <jsp:param name="action" value="<%= action %>" />
            <jsp:param name="activity" value="<%= activity %>" />
            <jsp:param name="oid" value="<%= oid %>" />
            <jsp:param name="returnOid" value="" />
            <jsp:param name="returnAction" value="" />
            <jsp:param name="returnActivity" value="" />
         <jsp:param name="flexTypeName" value="<%= flexTypeName %>" />
        </jsp:forward>
        <%
    }

%>
<jsp:forward page="<%=subURLFolder+ MAINTEMPLATE %>">
   <jsp:param name="title" value="<%= java.net.URLEncoder.encode(title, defaultCharsetEncoding)%>" />
   <jsp:param name="infoMessage" value="<%= infoMessage %>" />
   <jsp:param name="errorMessage" value="<%= java.net.URLEncoder.encode(errorMessage, defaultCharsetEncoding) %>" />
   <jsp:param name="requestedPage" value="<%= contentPage %>" />
   <jsp:param name="contentPage" value="<%= contentPage %>" />
    <jsp:param name="oid" value="<%= oid %>" />
    <jsp:param name="action" value="<%= action %>" />
    <jsp:param name="formType" value="<%= formType %>" />
    <jsp:param name="activity" value="<%= activity %>" />
   <jsp:param name="objectType" value="Last" />
   <jsp:param name="typeClass" value="com.lcs.wc.last.LCSLast" />
   <jsp:param name="type" value="<%= type %>" />
   <jsp:param name="flexTypeName" value="<%= flexTypeName %>" />
   <jsp:param name="contextHeaderPage" value="<%= contextHeaderPage %>" />
</jsp:forward>