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
                wt.util.*,
				com.lcs.wc.db.FlexObject,
				java.text.DateFormat,
				java.util.TimeZone,
				java.text.SimpleDateFormat"
%>
<%!
    public static final String width = LCSProperties.get("jsp.image.ObjectThumbnailPlugin.imageWidth", "100");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final boolean USE_FTP_JOB = LCSProperties.getBoolean("com.lcs.wc.ftpjob.useFtpJob");
    public static final boolean REVISE = LCSProperties.getBoolean("com.lcs.wc.document.LCSDocument.revise");
    public static String  iconPrefix = "";

    static {
        try {
            WTProperties wtproperties = WTProperties.getLocalProperties();
            iconPrefix = "/" + wtproperties.getProperty("wt.webapp.name");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>

<%
    String targetOid = request.getParameter("targetOid");
    String returnOid = request.getParameter("returnOid");
    String returnActivity = request.getParameter("returnActivity");
    String returnAddlParams = request.getParameter("returnAddlParams");
    String copyModeParam = request.getParameter("copyMode");
    boolean copyMode = false;
    if ("COPY".equals(copyModeParam)) {
        copyMode = true;
    }

    String contentFileNameLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "contentFileName_LBL", RB.objA) ;
    String fileSizeBytesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "fileSizeBytes_LBL", RB.objA) ;
    String documentNameLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "documentName_LBL", RB.objA) ;
    String workingStateLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "workingState_LBL", RB.objA) ;
    String typeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "type_LBL", RB.objA) ;
    String userLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "user_LBL", RB.objA) ;
    String historyLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "history_LBL",RB.objA) ;
    String referenceDocumentsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "referenceDocuments_LBL",RB.objA) ;
    String describedByDocumentsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "describedByDocuments_LBL",RB.objA) ;
    String versionLabel = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "version_LBL", RB.objA ) ;
    String thumbnailLabel = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "thumbnail_LBL", RB.objA) ;
	String createDateLabel = "Date Created";


    String docId = null;
    String name = null;
    String filesize = null;
    String urlString = null;
    Collection docs = null;
    Collection descDocs = new ArrayList();
    SearchResults results = null;

    String targetSuffix = FormatHelper.getNumericFromOid(targetOid);
    LCSDocumentQuery query = new LCSDocumentQuery();
    WTObject obj = (WTObject) request.getAttribute("DOCUMENT_REF_TARGET");
    boolean hasMenus = true;
    if (obj instanceof Iterated && !VersionHelper.isLatestIteration((Iterated)obj)) {
        hasMenus = false;
    }

    if (obj instanceof LCSPart) {
        docs = query.findPartDocReferences(obj);
        if (REVISE) {
            descDocs = query.findPartDocDescribe(obj);
        }
    } else if (obj instanceof LCSDocument) {
        docs = query.findDocDocReferences(obj);

    } else {
        docs = query.findDocObjectReferences(obj);
        if (REVISE) {
            descDocs = query.findPartDocDescribe(obj);
        }
    }

    try {
        docs = processDocumentResults(docs, lcsContext.inGroup("FTP USERS GROUP"), true);
        if (REVISE) {
              descDocs = processDocumentResults(descDocs, lcsContext.inGroup("FTP USERS GROUP"), false);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
%>
<%!
LCSDocument document2=null;
public Collection processDocumentResults(Collection docs, 
     boolean inFTPUserGroup, boolean references) throws Exception {

    String checkedOutByLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "checkOutBy_LBL", RB.objA ) ;
    String lockedByLabel = WTMessage.getLocalizedMessage (RB.MAIN, "lockedBy_LBL", RB.objA ) ;
    String checkedInLabel = WTMessage.getLocalizedMessage (RB.MAIN, "checkedIn_LBL", RB.objA ) ;

    String docId = null;
    String name = null;
    String filesize = null;
    String urlString = null;
	FlexObject fob = null;

    for (Iterator it = docs.iterator(); it.hasNext(); ) {

        Map<String,String> h = (Map<String,String>)it.next();

        // Now set the URL for the Primary Content
        docId = "OR:com.lcs.wc.document.LCSDocument:" + (String)h.get("LCSDOCUMENT.IDA2A2");

        // Handle runtime NotAuthorizedException thrown by Persistence.Manager.refresh() for
        // a document that the user does not have access too.
        LCSDocument document=null;
        try {
            document = (LCSDocument) LCSDocumentQuery.findObjectById(docId);
            document2=document;
        } catch (WTRuntimeException nae) {
            Exception nested = (Exception) ((wt.util.WTRuntimeException)nae).getNestedThrowable();
            if (nested instanceof wt.access.NotAuthorizedException) {
                it.remove();
                continue;
            } else {
                throw new WTRuntimeException("Error retrieving document");
            }
        }

        // If the user has View permission for a document that is referenced by this object show it
        if (ACLHelper.hasViewAccess((FlexTyped)document)) {
            // Get current status
            boolean isCheckedOut = VersionHelper.isCheckedOut(document);
            boolean isWorkingCopy = VersionHelper.isWorkingCopy(document);
            boolean isCheckedOutByUser = VersionHelper.isCheckedOutByUser(document);
            boolean isLocked = LockHelper.isLocked(document);
            boolean editable = ((!isCheckedOut && !isLocked)|| isCheckedOutByUser);
            if (isCheckedOut && isCheckedOutByUser && !isWorkingCopy){
                //document = (LCSDocument) VersionHelper.getWorkingCopy(document);
            }
            String checkedOutBy = "";
            String checkedOutByEmail = "";
            if(isCheckedOut){
                WTUser user = (WTUser) LockHelper.getLocker(document);
                checkedOutBy = user.getFullName();
                h.put("DOCCHKOUTSTATE", checkedOutByLabel + checkedOutBy);
                if(isCheckedOutByUser){
                    h.put("DOCWORKINGSTATE", "c/o");
                } else {
                    h.put("DOCWORKINGSTATE", "n/a");
                }
            // added to detect Visualization locks
            } else if (isLocked) {
                WTUser user = (WTUser) LockHelper.getLocker(document);
                checkedOutBy = user.getFullName();
                h.put("DOCCHKOUTSTATE", lockedByLabel + checkedOutBy);
                h.put("DOCWORKINGSTATE", "n/a");
            } else {
                h.put("DOCCHKOUTSTATE", checkedInLabel);
                h.put("DOCWORKINGSTATE", "c/i");
            }

            // Added for FTP Document Content Support
            h.put("ALLOWFTP", "false");
            if (USE_FTP_JOB) {
                if ( (FtpDocumentHelper.hasAnyValidFtpContent(document)) &&
                     (inFTPUserGroup)
                   ) {
                    h.put("ALLOWFTP", "true");
                }
            }

            String thumbnail = (String)h.get("LCSDOCUMENT.THUMBNAILLOCATION");

            if(FormatHelper.hasContent(thumbnail)){
                String encodedThumbLocation = FormatHelper.formatImageUrl(thumbnail);
                thumbnail = "<A href=\"javascript:launchImageViewer('" + encodedThumbLocation +
                        "') \"><img border=1 src=\"" + encodedThumbLocation + "\" width=\"" + width + "\"></A>";
            }
            // Init content data
            document = (LCSDocument) ContentHelper.service.getContents(document);

            // Handle lack of content
            ApplicationData primary = (ApplicationData) ContentHelper.getPrimary(document);
            if (primary != null) {
                name = java.net.URLDecoder.decode(primary.getFileName(), defaultCharsetEncoding);
                primary.setFileName(name);
                filesize = (String)(new Float(primary.getFileSizeKB())).toString();
                URL url = com.lcs.wc.util.DownloadURLHelper.getMostPreferedURL(primary, document, false);
                urlString = "<A HREF=\"javascript:openWindow('" + url.toString() + "');\"><img border=0 align=center src=\"" + iconPrefix + "/" + h.get("DATAFORMAT.STANDARDICONSTR") + "\">&nbsp;&nbsp;" + name;

                h.put("FILEREFERENCE", urlString);
                h.put("FILESIZE", FormatHelper.applyFormat(filesize, FormatHelper.DOUBLE_FORMAT)+"Kb");
                h.put("DATAFORMAT.STANDARDICONSTR", iconPrefix + "/" + h.get("DATAFORMAT.STANDARDICONSTR"));
            } else {
                h.put("FILEREFERENCE", "");
                h.put("FILESIZE", "");
            }
        } else {
            // If the user does not have permission to a document that is referenced by this object
            // then don't show it to the user.
            it.remove();
        }
   }

/**
	* Target Point Build: 004.25
	* Request ID : <5>
	* Description : Code to show Created Date for Document Object(Tech Pack) under Documents Table.
	* @author Archana Saha
	* Modified On: 25-07-2013
	*/
//ITC - START
	Iterator itr=docs.iterator();
	String timeValue = null;
	while(itr.hasNext()){
		fob = (FlexObject) itr.next();
        docId = "OR:com.lcs.wc.document.LCSDocument:" + (String)fob.get("LCSDOCUMENT.IDA2A2");

       
       LCSDocument document=null;
        try {
            document = (LCSDocument) LCSDocumentQuery.findObjectById(docId);
        } catch (WTRuntimeException nae) {
            Exception nested = (Exception) ((wt.util.WTRuntimeException)nae).getNestedThrowable();
            if (nested instanceof wt.access.NotAuthorizedException) {
                itr.remove();
                continue;
            } else {
                throw new WTRuntimeException("Error retrieving document");
            }
        }
		if(document!=null){
			final DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a z");
			String timeZoneId = "America/New_York";
			TimeZone timeZone = TimeZone.getTimeZone(timeZoneId);
			dateFormat.setTimeZone(timeZone);

			final WrappedTimestamp time = (WrappedTimestamp) document.getCreateTimestamp();
			timeValue = dateFormat.format(time);
			fob.put("LCSDOCUMENT.CREATESTAMPA2",timeValue);
		}
	}
if(docs!=null&&!docs.isEmpty()){
		docs=SortHelper.sortFlexObjectsByDate(docs,"LCSDOCUMENT.CREATESTAMPA2","MM/dd/yyyy hh:mm a z");
		Collections.reverse((List) docs);
	}
	
	//ITC - END
	
    return docs;
}

%>


<script>
if(document.DOCUMENT_REFERENCES == null){
    document.DOCUMENT_REFERENCES = new Object();
    document.DOCUMENT_REFERENCES.removeReferenceToDoc = '<%=LCSMessage.getJavascriptMessage( RB.MAIN, "removeReferenceToDoc_CNFRM",RB.objA, false )%>';
    document.DOCUMENT_REFERENCES.removeReferencesToAllReferenceDocs = '<%=LCSMessage.getJavascriptMessage( RB.MAIN, "removeReferencesToAllReferenceDocs_CNFRM",RB.objA, false ) %>';
    document.DOCUMENT_REFERENCES.removeReferencesToAllDescribedByDocs = '<%=LCSMessage.getJavascriptMessage( RB.MAIN, "removeReferencesToAllDescribedByDocs_CNFRM",RB.objA, false ) %>';
    document.DOCUMENT_REFERENCES.removeReferencesToAllDocs = '<%=LCSMessage.getJavascriptMessage( RB.MAIN, "removeReferencesToAllDocs_CNFRM",RB.objA, false ) %>';

    //Create array objects
    document.DOCUMENT_REFERENCES.returnActivity = new Array();
    document.DOCUMENT_REFERENCES.returnOid = new Array();
    document.DOCUMENT_REFERENCES.returnAddlParams = new Array();
    document.DOCUMENT_REFERENCES.objectId = new Array();
    document.DOCUMENT_REFERENCES.targetOid = new Array();
}

document.DOCUMENT_REFERENCES.returnActivity[<%= targetSuffix %>] = '<%= returnActivity %>';
document.DOCUMENT_REFERENCES.returnOid[<%= targetSuffix %>] = '<%= returnOid %>';
document.DOCUMENT_REFERENCES.returnAddlParams[<%= targetSuffix %>] = '<%= returnAddlParams%>';
document.DOCUMENT_REFERENCES.objectId[<%= targetSuffix %>] = '<%= FormatHelper.getObjectId(obj) %>';
document.DOCUMENT_REFERENCES.targetOid[<%= targetSuffix %>] = '<%= targetOid %>';
</script>



<tr>
    <td>

<%

FlexType flexType = FlexTypeCache.getFlexTypeRootByClass("com.lcs.wc.document.LCSDocument");
String nameColumnIndex = flexType.getAttribute("name").getSearchResultIndex();

Collection<TableColumn> columns = new Vector<TableColumn>();
Collection<TableColumn> describeByColumns = new Vector<TableColumn>();
TableColumn column = null;

if (copyMode) {

	column = new TableColumn();
    column.setDisplayed(true);
    column.setHeaderLabel("<input type=\"checkbox\" id=\"selectAllCheckBox\" value=\"false\" onClick=\"javascript:toggleAllItems()\">");
    column.setHeaderAlign("left");
    column.setHeaderLink("javascript:toggleAllItems()");
    TableFormElement fe = new CheckBoxTableFormElement();
    fe.setValueIndex("LCSDOCUMENT.IDA3MASTERREFERENCE");
    fe.setValuePrefix("OR:wt.doc.WTDocumentMaster:");
    fe.setName("selectedIds");
    column.setFormElement(fe);
    columns.add(column);

    column = new TableColumn();
    column.setDisplayed(true);
    column.setHeaderLabel("<input type=\"checkbox\" id=\"selectAllDBCheckBox\" value=\"false\" onClick=\"javascript:toggleAllItems('selectAllDBCheckBox','selectedDBIds')\">");
    column.setHeaderAlign("left");
    column.setHeaderLink("javascript:toggleAllItems('selectAllDBCheckBox','selectedDBIds')");
    fe = new CheckBoxTableFormElement();
    fe.setValueIndex("LCSDOCUMENT.BRANCHIDITERATIONINFO");
    fe.setValuePrefix("VR:com.lcs.wc.document.LCSDocument:");
    fe.setName("selectedDBIds");
    column.setFormElement(fe);
    describeByColumns.add(column);

} else {

	String actionsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "actions_LBL", RB.objA) ;
	String removeDocumentLabel = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "removeDocument_LBL",RB.objA) ;
	String checkinLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "checkin_LBL", RB.objA) ;
	String updateLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "update_LBL", RB.objA) ;
	String fTPContentsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "fTPContents_LBL", RB.objA) ;

	boolean documentAccessFlag= ACLHelper.hasModifyAccess(document2);
	boolean objAccessFlag= ACLHelper.hasModifyAccess((FlexTyped)obj);
   //if (ACLHelper.hasModifyAccess((FlexTyped)obj)) {
        // Set Actions Pull Down for each row returned in the resultset
        Vector<LinkAction> actions = new Vector<LinkAction>();
        Vector<LinkAction> describeByActions = new Vector<LinkAction>();
        LinkAction action = new LinkAction();
		if(!lcsContext.isVendor){
        if (hasMenus) {
            action.setActionTarget("LCSDOCUMENT.IDA3MASTERREFERENCE");
            action.setActionMethod("removeDocument");
            action.setTargetPrefix("OR:wt.doc.WTDocumentMaster:");
            action.setActionAdditionalParameters(", '" + targetSuffix + "'");
            action.setActionLabel(removeDocumentLabel);
          	if(objAccessFlag){
            	actions.add(action);
         	}
            
            action = new LinkAction();
            action.setActionTarget("LCSDOCUMENT.BRANCHIDITERATIONINFO");
            action.setActionMethod("removeDocument");
            action.setTargetPrefix("VR:com.lcs.wc.document.LCSDocument:");
            action.setActionAdditionalParameters(", '" + targetSuffix + "'");
            action.setActionLabel(removeDocumentLabel);
            if(objAccessFlag){
            	describeByActions.add(action);
         	} 
        }
   }

        // Set action conditionally based on value of DOCWORKINGSTATE
        action = new LinkAction();
        action.setActionTarget("LCSDOCUMENT.IDA2A2");
        action.setActionMethod("checkinDocument");
        action.setTargetPrefix("OR:com.lcs.wc.document.LCSDocument:");
        action.setActionAdditionalParameters(", '" + targetSuffix + "'");
        action.setActionLabel(checkinLabel);
        action.setActionCriteria("c/o");
        action.setCheckModifyACL(true);
        action.setActionCriteriaTarget("DOCWORKINGSTATE");
        actions.add(action);
        describeByActions.add(action);

        action = new LinkAction();
        action.setActionTarget("LCSDOCUMENT.IDA2A2");
        action.setActionMethod("updateDocumentReference");
        action.setTargetPrefix("OR:com.lcs.wc.document.LCSDocument:");
        action.setActionAdditionalParameters(", '" + targetSuffix + "'");
        action.setActionLabel(updateLabel);
        action.setActionCriteria("n/a");
        action.setActionCriteriaNot(true);
        action.setActionCriteriaTarget("DOCWORKINGSTATE");
        action.setCheckModifyACL(true);
        actions.add(action);

        describeByActions.add(action);

        action = new LinkAction();
        action.setActionTarget("LCSDOCUMENT.IDA2A2");
        action.setActionMethod("ftpDocument");
        action.setTargetPrefix("OR:com.lcs.wc.document.LCSDocument:");
        action.setActionLabel(fTPContentsLabel);
        action.setActionCriteria("true");
        action.setCheckModifyACL(true);
        action.setActionCriteriaTarget("ALLOWFTP");
        actions.add(action);
        describeByActions.add(action);

        action = new LinkAction();
        action.setActionTarget("LCSDOCUMENT.IDA2A2");
        action.setActionMethod("iterationHistory");
        action.setTargetPrefix("OR:com.lcs.wc.document.LCSDocument:");
        action.setActionLabel(historyLabel);
        actions.add(action);
        describeByActions.add(action);

        column = new TableColumn();
        column.setActions(actions);
        column.setDisplayed(true);
        column.setHeaderLabel(actionsLabel);
        column.setHeaderAlign("left");
        column.setColumnWidth("1%");
        column.setHeaderWrapping(false);
        columns.add(column);
        
        column = new TableColumn();
        column.setActions(describeByActions);
        column.setDisplayed(true);
        column.setHeaderLabel(actionsLabel);
        column.setHeaderAlign("left");
        column.setColumnWidth("1%");
        column.setHeaderWrapping(false);
        describeByColumns.add(column);
     }
//}

// ----------------------------------------------------------------------------------------
// USE a Text Hyperlink where the Displayed output is the name of the primary content file
// ----------------------------------------------------------------------------------------
column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(thumbnailLabel);
column.setHeaderAlign("left");
column.setTableIndex("LCSDOCUMENT.THUMBNAILLOCATION");
column.setWrapping(false);
column.setFormatHTML(false);
column.setShowFullImage(false);
column.setImage(true);
columns.add(column);
describeByColumns.add(column);

column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(contentFileNameLabel);
column.setHeaderAlign("left");
column.setTableIndex("FILEREFERENCE");
column.setWrapping(false);
column.setFormatHTML(false);
columns.add(column);
describeByColumns.add(column);

column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(fileSizeBytesLabel);
column.setHeaderAlign("left");
column.setTableIndex("FILESIZE");
columns.add(column);
describeByColumns.add(column);

column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(documentNameLabel);
column.setHeaderAlign("left");
column.setLinkMethod("viewObject");
column.setUseQuickInfo(true);
column.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
column.setTableIndex(nameColumnIndex);
column.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
columns.add(column);
describeByColumns.add(column);

column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(versionLabel);
column.setHeaderAlign("left");
column.setTableIndex("LCSDOCUMENT.VERSIONIDA2VERSIONINFO");
column.setHeaderLink("javascript:resort('LCSDocument.versionIdA2versionInfo')");
//  Per Story ID B-63258, version should not appear for Reference Documents when revise is false
if (REVISE) {
    columns.add(column);
}
describeByColumns.add(column);

column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(workingStateLabel);
column.setHeaderAlign("left");
column.setTableIndex("DOCCHKOUTSTATE");
columns.add(column);
describeByColumns.add(column);

// FOR FULL TYPE NAME
column = new FlexTypeDescriptorTableColumn();
column.setDisplayed(true);
column.setHeaderLabel(typeLabel);
column.setHeaderAlign("left");
column.setTableIndex("LCSDOCUMENT.IDA3A11");
columns.add(column);
describeByColumns.add(column);

column = new UserTableColumn();
column.setDisplayed(true);
column.setHeaderLabel(userLabel);
column.setHeaderAlign("left");
column.setTableIndex("LCSDOCUMENT.IDA3D2ITERATIONINFO");
columns.add(column);
describeByColumns.add(column);

/**
	* Target Point Build: 004.25
	* Request ID : <5>
	* Description : Code to show Created Date for Document Object(Tech Pack) under Documents Table.
	* @author Archana Saha
	* Modified On: 25-07-2013
	*/
//ITC - START
column = new TableColumn();
column.setDisplayed(true);
column.setHeaderLabel(createDateLabel);
column.setHeaderAlign("left");
column.setTableIndex("LCSDOCUMENT.CREATESTAMPA2");
columns.add(column);
describeByColumns.add(column);
//ITC - END


tg.setClientSort(true);

out.print(tg.drawTable(docs, columns, referenceDocumentsLabel, true, false));

%>
    </td>
</tr>

<tr>
    <td>
        &nbsp;
    </td>
</tr>


<% if (REVISE) { %>
    <tr>
        <td>
<%
        out.print(tg.drawTable(descDocs, describeByColumns, describedByDocumentsLabel, true, false));
%>
        </td>
    </tr>
<% } %>

<%
   tg.setClientSort(false);
%>
<%= tg.endContentTable() %>
<%= tg.endTable() %>
<%= tg.endBorder() %>
