
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="com.lcs.wc.client.Activities,
                com.lcs.wc.client.web.*,
                com.lcs.wc.util.*,
                com.lcs.wc.db.*,
                com.lcs.wc.last.*,
                com.lcs.wc.flextype.*,
                wt.doc.WTDocumentMaster,
                wt.ownership.*,
                wt.locks.LockHelper,
                wt.org.*,
				wt.util.*,
                java.text.*,
                java.util.*"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lastModel" scope="request" class="com.lcs.wc.last.LCSLastClientModel" />
<jsp:useBean id="type" scope="request" class="com.lcs.wc.flextype.FlexType" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="flexg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
//setting up which RBs to use

String lastDetailsPgHead = WTMessage.getLocalizedMessage ( RB.LAST, "lastDetails_PG_HEAD", RB.objA ) ;
String iterationHistoryOpt = WTMessage.getLocalizedMessage ( RB.LAST, "iterationHistory_OPT", RB.objA ) ;
String lastIdGrpTle = WTMessage.getLocalizedMessage ( RB.LAST, "lastId_GRP_TLE", RB.objA ) ;
String nameLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "name_LBL", RB.objA ) ;
String typeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "type_LBL", RB.objA ) ;
String actionsLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "actions_LBL",RB.objA ) ;
String oldIterationLabel = WTMessage.getLocalizedMessage (RB.MAIN, "oldIteration_LBL", RB.objA ) ;

    flexg.setModuleName("LAST");

    LCSLast last = lastModel.getBusinessObject();

    boolean isLatestIteration = VersionHelper.isLatestIteration(last);
    boolean isCheckedOut = VersionHelper.isCheckedOut(last);
    boolean isWorkingCopy = VersionHelper.isWorkingCopy(last);
    boolean isCheckedOutByUser = VersionHelper.isCheckedOutByUser(last);
    boolean editable = (!isCheckedOut || isCheckedOutByUser);
    if(isCheckedOut && isCheckedOutByUser && !isWorkingCopy){
        last = (LCSLast) VersionHelper.getWorkingCopy(last);
    }
    String checkedOutBy = "";
    String checkedOutByEmail = "";
    if(!editable){
        WTUser user = (WTUser) LockHelper.getLocker(last);
        checkedOutBy = user.getFullName();
        checkedOutByEmail = user.getEMail();
    }

    type = last.getFlexType();

    String errorMessage = request.getParameter("errorMessage");
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JSP METHODS /////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final String JSPNAME = "ViewLast";
    public static final boolean DEBUG = true;
        public static final String DOCUMENT_REFERENCES = PageManager.getPageURL("DOCUMENT_REFERENCES", null);
        public static final String ACTION_OPTIONS = PageManager.getPageURL("ACTION_OPTIONS", null);
        public static final String WC_META_DATA= PageManager.getPageURL("WC_META_DATA", null);
        public static final String DISCUSSION_FORM_POSTINGS = PageManager.getPageURL("DISCUSSION_FORM_POSTINGS", null);


%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script>
   function addSKU(){
      document.MAINFORM.activity.value = '<%= Activities.CREATE_SKU %>';
      document.MAINFORM.action.value = 'INIT';
      submitForm();
   }
   //Task PLM-128 Implement Copy last Functionality
   function copyLast(oid){

	  	document.MAINFORM.activity.value = 'COPY_LAST';
		document.MAINFORM.action.value = 'COPY';
		document.MAINFORM.oid.value = oid;
		document.MAINFORM.returnActivity.value = "VIEW_LAST";
		document.MAINFORM.returnAction.value = "COPY";
		document.MAINFORM.returnOid.value = oid;
		submitForm();
   }
</script>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input type="hidden" name="typeId" value="<%= FormatHelper.getObjectId(type) %>">
<input type="hidden" name="lastMasterId" value="<%= FormatHelper.getObjectId((LCSLastMaster)last.getMaster()) %>">
<table width="100%">
   <tr>
      <td class="PAGEHEADING">
         <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
               <td class="PAGEHEADINGTITLE">
                  <%= lastDetailsPgHead %>: <%= FormatHelper.encodeAndFormatForHTMLContent((String)last.getValue("name")) %>
               </td>
               <td class="PAGEHEADINGTEXT" width="1%" nowrap>
					<jsp:include page="<%=subURLFolder+ DISCUSSION_FORM_POSTINGS %>" flush="true">
                        <jsp:param name="oid" value="<%= FormatHelper.getObjectId(last) %>" />
                    </jsp:include>

                 <% if (isLatestIteration){ %>
                    &nbsp;<%= actionsLbl %>&nbsp;
                    <select onChange="evalList(this)">
                        <option>
                        <jsp:include page="<%=subURLFolder+ ACTION_OPTIONS %>" flush="true">
                            <jsp:param name="type" value="<%= FormatHelper.getObjectId(type) %>" />
                            <jsp:param name="targetOid" value="<%= FormatHelper.getVersionId(last) %>" />
                            <jsp:param name="returnActivity" value="VIEW_LAST" />
                            <jsp:param name="updateActivity" value="UPDATE_LAST" />
							<jsp:param name="copyActivity" value="COPY_LAST" />
                        </jsp:include>
						<option value="copyLast('<%= FormatHelper.getVersionId(last) %>')">Copy Last
                            <% if(!lcsContext.isVendor){ %>
                        <option value="iterationHistory('<%= FormatHelper.getVersionId(last) %>')"><%= iterationHistoryOpt %>
                            <% } %>
                    </select>
                <% } else { %>
                    <%= oldIterationLabel%> -
                    &nbsp;<%= actionsLbl %>&nbsp;
                    <select onChange="evalList(this)">
                        <option>
                            <% if(!lcsContext.isVendor){ %>
                        <option value="iterationHistory('<%= FormatHelper.getVersionId(last) %>')"><%= iterationHistoryOpt %>
                            <% } %>
                    </select>
                <% } %>
               </td>
            </tr>
         </table>
      </td>
   </tr>
   <tr>
      <td width="10%" valign="top">
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle() %><%= lastIdGrpTle %><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>
         <col width="15%"></col>
         <col width="35%"></col>
         <col width="15%"></col>
         <col width="35%"></col>
         <tr>
            <%= FormGenerator.createDisplay(nameLabel, (String)last.getValue("name"), FormatHelper.STRING_FORMAT) %>
            <%= FormGenerator.createDisplay(typeLabel, last.getFlexType().getFullNameDisplay(), FormatHelper.STRING_FORMAT) %>
         </tr>
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
      </td>
   </tr>
   <tr>
      <td>
         <%= flexg.generateDetails(last) %>
      </td>
   </tr>
   <tr>
      <td>
         <jsp:include page="<%=subURLFolder+ DOCUMENT_REFERENCES %>" flush="true">
            <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(last) %>" />
            <jsp:param name="returnActivity" value="VIEW_LAST" />
            <jsp:param name="returnOid" value="<%= FormatHelper.getObjectId(last) %>" />
         </jsp:include>
      </td>
   </tr>
   <tr>
      <td>
         <jsp:include page="<%=subURLFolder+ WC_META_DATA %>" flush="true">
            <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(last) %>" />
         </jsp:include>
      </td>
   </tr>
</table>
