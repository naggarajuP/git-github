<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>

<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ///////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ErrorReport.jsp"
    import=" com.lcs.wc.util.*,
            com.lcs.wc.util.OSHelper,
            com.lcs.wc.util.aclvalidator.*,
            com.lcs.wc.client.Activities,
            com.lcs.wc.client.web.*,
            com.lcs.wc.flextype.*,
            com.lcs.wc.material.*,
            com.lcs.wc.season.*,
            com.lcs.wc.product.*,
            com.lcs.wc.calendar.*,
            com.lcs.wc.foundation.*,
            com.lcs.wc.document.*,
            com.lcs.wc.db.*,
            com.lcs.wc.sizing.*,
            com.ptc.netmarkets.util.beans.NmURLFactoryBean,
            com.ptc.netmarkets.util.misc.NmAction,
            com.ptc.netmarkets.model.NmOid,
            java.io.*,
            java.util.*,
            wt.util.*,
            wt.httpgw.URLFactory,
	    com.ptc.netmarkets.util.misc.NetmarketURL,
            wt.enterprise.*,
            wt.fc.*,
			org.apache.commons.lang.StringUtils"
%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS //////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>


<%
response.setDateHeader("Expires", -1);
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
lcsContext.initContext();
lcsContext.setLocale(request.getLocale());

response.setDateHeader("Expires",
   System.currentTimeMillis(  ) + 24*60*60*1000);
%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE /////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%!

    public static String getUrl = "";
    public static boolean hasValueListMaintenanceAccess = true;
    public static String WindchillContext = "/Windchill";

    static
    {
        try
        {
            WTProperties wtproperties = WTProperties.getLocalProperties();
            getUrl = wtproperties.getProperty("wt.server.codebase","");
            WindchillContext = "/" + wtproperties.getProperty("wt.webapp.name");
            


        }
        catch(Throwable throwable)
        {
            throw new ExceptionInInitializerError(throwable);
        }
    }
    public static final boolean BASELINE_INSTALLED = LCSProperties.getBoolean("com.lcs.baseline.Enabled");
    public static final boolean ERROR_TESTING = LCSProperties.getBoolean("jsp.exception.ErrorTesting.enabled");
    public static final boolean REMOTE_TC_MS_MANAGEMENT = LCSProperties.getBoolean("jsp.tcrestart-msrestart.enabled");

    public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final String STANDARD_TEMPLATE_HEADER = PageManager.getPageURL("STANDARD_TEMPLATE_HEADER", null);
    public static final String STANDARD_TEMPLATE_FOOTER = PageManager.getPageURL("STANDARD_TEMPLATE_FOOTER", null);

    public static final String JSPNAME = "SideMenu";
    public static final boolean DEBUG = LCSProperties.getBoolean("jsp.main.SideMenu.verbose");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final boolean LOAD_SIDEBAR_ONLY_ON_PRODUCTLINK = LCSProperties.getBoolean("jsp.main.SideMenu.loadSidebarOnlyOnProductLink");    

    public static final String PRODUCT_SKU_PAGE = "PRODUCT";
    public static final String CHANGE_ACTIVITIES_PAGE = "CHANGES";
    public static final String PROCESSES_PAGE = "PROCESSES";
    public static final String SOURCING_PAGE = "SOURCING";
    public static final String MEASUREMENTS_PAGE = "MEASUREMENTS";
    public static final String SYSTEM_PAGE = "SYSTEM";
    public static final String HISTORY_PAGE = "HISTORY";
    public static final String DOCUMENTS_PAGE = "DOCUMENTS";
    public static final String CONSTRUCTION_PAGE = "CONSTRUCTION";
    public static final String SAMPLES_PAGE = "SAMPLES";
    public static final String TESTING_PAGE = "TESTING";
    public static final String IMAGES_PAGE = "IMAGES";
    public static final String LABOR_PAGE = "LABOR";
    public static final String BOM_PAGE = "BOM";
    public static final String SPEC_SUMMARY_PAGE = "SPEC_SUMMARY";

    public static final String OVERVIEW_TAB = "1";
    public static final String COLOR_TAB = "3";
    public static final String IMAGES_TAB = "IAMGES";
    public static final String SOURCING_TAB = "7";
    public static final String MATERIALS_TAB = "BOM";
    public static final String LABOR_TAB = "LABOR";
    public static final String WHEREUSED_TAB = "WHEREUSED";
    public static final String PROCESSES_TAB = "6";
    public static final String DOCUMENTS_TAB = "5";
    public static final String SYSTEM_TAB = "4";
    public static final String PRICING = "PRICING";

    public static final String adminGroup = LCSProperties.get("jsp.main.administratorsGroup", "Administrators");
    public static final String typeAdminGroup = LCSProperties.get("jsp.flextype.adminGroup", "Type Administrators");
    public static final String userAdminGroup = LCSProperties.get("jsp.users.adminGroup","User Administrators");
    public static final String calendarAdminGroup = LCSProperties.get("jsp.calendar.adminGroup","Calendar Administrators");
    public static final String processAdminGroup = LCSProperties.get("jsp.process.adminGroup","Process Administrators");
	public static final String sizingDefinitionAdminGroup = LCSProperties.get("jsp.sizingDefinition.adminGroup","SizingDefinition Administrators");

    public static final boolean USE_BOM = LCSProperties.getBoolean("com.lcs.wc.bom.useBOM");
    public static final boolean USE_BOL = LCSProperties.getBoolean("com.lcs.wc.bom.useBOL");
    public static final boolean USE_CHANGEACTIVITIES = LCSProperties.getBoolean("com.lcs.wc.change.useChangeActivities");
    public static final boolean USE_MEASUREMENTS = LCSProperties.getBoolean("com.lcs.wc.measurements.useMeasurements");
    public static final boolean USE_CONSTRUCTION = LCSProperties.getBoolean("com.lcs.wc.construction.useConstruction");
    public static final boolean USE_SAMPLES = LCSProperties.getBoolean("com.lcs.wc.sample.useSamples");
    public static final boolean USE_TESTING = LCSProperties.getBoolean("com.lcs.wc.testing.useTesting");
    public static final boolean USE_SILHOUETTES = LCSProperties.getBoolean("com.lcs.wc.season.useSilhouettes");
    public static final boolean USE_INSPIRATIONS = LCSProperties.getBoolean("com.lcs.wc.season.useInspirations");

    public static final boolean USE_PRODUCT = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useProduct");
    public static final boolean USE_SAMPLE = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useSample");
    public static final boolean USE_MATERIAL = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useMaterial");
    public static final boolean USE_ORDERCONF = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.orderConfirmation");
    public static final boolean USE_RFQ = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useRFQ");
    public static final boolean FORUMS_ENABLED= LCSProperties.getBoolean("jsp.discussionforum.discussionforum.enabled");

    public static final String SIDE_WORKLIST_MENU = PageManager.getPageURL("SIDE_WORKLIST_MENU", null);
    
    public static final String WORK_ITEMS_DUE_WITHIN_A_WEEK_LABEL = "Due within a Week Workitems";
    public static final String UPCOMING_WORK_ITEMS_LABEL = "Upcoming Workitems";
    public static final String CALENDAR_WORK_ITEMS = "Calendar Work Item";
    
    public static final String USER_ASSESSMENT_TASK_REPORT = "User Task Assessment Report";
    public static final String SEASONAL_TASK_REPORT = "Seasonal Task Report";
    public static final String gbgUserAssessmentGroup = LCSProperties.get("jsp.lfusa.calendar.gbgUserAssessmentGroup","GBG_UserAssessment_Group");
    public static final String gbgSeasonTaskGroup = LCSProperties.get("jsp.lfusa.calendar.gbgSeasonTaskGroup","GBG_SeasonTask_Group");



    public static final String getClass(boolean active, String test, String value){

        if(active && FormatHelper.hasContent(value) && value.equals(test)){
            return "class='navigatorOptionSelected'";

        }
        return "";
    }
	
	///////////////////////////////////////////////////////////////////
	//			ITC START
	///////////////////////////////////////////////////////////////////
		public static final String reportGenerateGroup = LCSProperties.get("com.lcs.wc.reports.reportGenerateGroup");
		public static final String sampleReportGenerateGroup = LCSProperties.get("com.lcs.wc.reports.sampleReportGenerateGroup");
		public static final String changeTrackingReportGroup = LCSProperties.get("com.lcs.wc.reports.changeTrackingReportGroup");

		public static final  String reportAliases = LCSProperties.get("com.lfusa.wc.reports");
		public static final String reportList[]= StringUtils.split(reportAliases,",");

	//	Build 6.9 START
	//	BOM LISTING REPORT
		public static final String bomListingReportGroup = LCSProperties.get("com.lfusa.wc.bomListingReport.Group");
		public static final String bomListingReportActivity = LCSProperties.get("com.lfusa.wc.bomListingReport.activity");
	//	Build 6.9 END	
%>

<script>
//**************** custom js function for report generation***********
 function viewLFProductAdoptionReport(reportAliasName,activityName){
     	document.MAINFORM.activity.value = activityName;
		document.MAINFORM.action.value = "INIT";
		submitForm();
    }
</script>

<%
	///////////////////////////////////////////////////////////////////
	//			ITC END
	///////////////////////////////////////////////////////////////////
%>

<%    response.setContentType("text/html; charset=" +defaultCharsetEncoding);%>
<jsp:include page="<%= subURLFolder + STANDARD_TEMPLATE_HEADER %>" flush="true">
    <jsp:param name="bodyClass" value="xnavigatorBody" />
</jsp:include>

<%

String siteTab_lbl = WTMessage.getLocalizedMessage ( RB.MAIN, "siteTab_LBL", RB.objA ) ;
String productTab_lbl = WTMessage.getLocalizedMessage ( RB.MAIN, "productTab_LBL", RB.objA ) ;
String yourWorkListPgTle = WTMessage.getLocalizedMessage ( RB.WF, "yourWorkList_PG_TLE", RB.objA ) ;
String actions_lbl = WTMessage.getLocalizedMessage( RB.MAIN, "actions2_LBL", RB.objA ) ;
String clearUserGroupCacheLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "clearUserGroupCache_LBL_OPT", RB.objA ) ;
String skuLabel = WTMessage.getLocalizedMessage ( RB.SKU, "SKU_LBL", RB.objA ) ;
String materialSupplierLabel = WTMessage.getLocalizedMessage ( RB.MATERIALSUPPLIER, "materialSupplier_LBL", RB.objA ) ;
String pLMNavigatorLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "pLMNavigator_LBL", RB.objA ) ;
String myHomeButton  = WTMessage.getLocalizedMessage ( RB.MAIN, "myHome_Btn", RB.objA ) ;
String myWorkButton = WTMessage.getLocalizedMessage ( RB.MAIN, "myWork_Btn", RB.objA ) ;
String clipboardLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "clipboard_LBL", RB.objA ) ;
String mySeasonsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "mySeasons_LBL", RB.objA ) ;
String detailsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "details_LBL", RB.objA ) ;
String inspirationsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "inspirations_LBL", RB.objA ) ;
String paletteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "palette_LBL", RB.objA ) ;
String conceptsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "concepts_LBL", RB.objA ) ;
String silhouettesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "silhouettes_LBL", RB.objA ) ;
String developmentLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "development_LBL", RB.objA ) ;
String lineLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "line_LBL", RB.objA ) ;
String calendarLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "calendar_LBL", RB.objA ) ;
String dashboardsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "dashboards_LBL", RB.objA ) ;
String specificationLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "specification_LBL", RB.objA ) ;
String specificationConfig = WTMessage.getLocalizedMessage ( RB.MAIN, "specificationConfig_LBL", RB.objA ) ;
String imagesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "images_LBL", RB.objA ) ;
String measurementsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "measurements_LBL", RB.objA ) ;
String materialsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "materials_LBL", RB.objA ) ;
String constructionLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "construction_LBL", RB.objA ) ;
String discussionLibrary_LBL = WTMessage.getLocalizedMessage ( RB.MAIN, "discussionLibrary_LBL", RB.objA ) ;
String documentsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "documents_LBL", RB.objA ) ;
String laborLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "labor_LBL", RB.objA ) ;
String specSummaryLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "specificationConfig_LBL", RB.objA ) ;
String processesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "processes_LBL", RB.objA ) ;
String historyLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "history_LBL", RB.objA ) ;
String recentLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "recent_LBL", RB.objA ) ;
String overviewLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "overview_LBL", RB.objA ) ;
String librariesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "libraries_LBL", RB.objA ) ;
String administrativeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "administrative_LBL", RB.objA ) ;
String manageTypesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "manageTypes_LBL", RB.objA ) ;
String manageCalendarsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "manageCalendars_LBL", RB.objA ) ;
String loadFileLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "loadFile_LBL", RB.objA ) ;
String loadTranslationFileLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "loadTypeManagerTranslations_MENU", RB.objA ) ;
String sourcingLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "sourcing_LBL", RB.objA ) ;
String samplesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "samples_LBL", RB.objA ) ;
String approvalsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "approvals_LBL", RB.objA ) ;
String changesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "changes_LBL", RB.objA ) ;
String systemLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "system_LBL", RB.objA ) ;
String reportsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "reports_LBL", RB.objA ) ;
String listAttributesOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "listAttributes_OPT", RB.objA ) ;
String manageProcessesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "manageProcesses_OPT", RB.objA ) ;
String userAccessLogStatsOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "userAccessLogStats_OPT", RB.objA ) ;
String manageUsersLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "manageUsers_OPT", RB.objA ) ;
String manageLocksLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "manageLocks_OPT", RB.objA ) ;
String manageAttributeValueListsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "manageAttributeValueLists_OPT", RB.objA ) ;
String workitemsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "workitems_LBL", RB.objA ) ;
String myCheckedOutItemsPgHead = WTMessage.getLocalizedMessage ( RB.MAIN, "myCheckedOutItems_PG_HEAD", RB.objA ) ;
String presentationBoardLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "presentationBoard_LBL", RB.objA ) ;
String loadWorkListPageTitle = WTMessage.getLocalizedMessage ( RB.WF, "loadWorkList_PG_TLE", RB.objA ) ;
String clearFlexTypeCacheLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "clearFlexTypeCache_LBL_OPT", RB.objA ) ;
String favoritesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "favorites_LBL", RB.objA ) ;
String removeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "remove_Btn", RB.objA ) ;
String navigatorLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "navigator_LBL", RB.objA ) ;
String worklistExceptionsOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "worklistExceptions_OPT", RB.objA ) ;
String allCcalendarsOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "allCalendars_OPT", RB.objA ) ;
String planningLabel = WTMessage.getLocalizedMessage ( RB.PLAN, "planning_LBL", RB.objA ) ;
//String productLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "productOption_LBL",RB.objA ) ;
//String materialLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "materialOption_LBL",RB.objA ) ;
//String documentLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "documentOption_LBL",RB.objA ) ;
String myInfoLabel = WTMessage.getLocalizedMessage ( RB.VENDORPORTAL, "myInfo_LBL", RB.objA ) ;
String myInfoMultiLabel = WTMessage.getLocalizedMessage ( RB.VENDORPORTAL, "myInfoMulti_LBL", RB.objA ) ;
String rfqLabel = WTMessage.getLocalizedMessage ( RB.VENDORPORTAL, "rfq_LBL", RB.objA ) ;
String sampleLabel = WTMessage.getLocalizedMessage ( RB.VENDORPORTAL, "sample_LBL", RB.objA ) ;

String reports = WTMessage.getLocalizedMessage ( RB.MAIN, "reports_LBL", RB.objA ) ;
String productCount = WTMessage.getLocalizedMessage ( RB.MAIN, "productCount_LBL", RB.objA ) ;
String userAssignments = WTMessage.getLocalizedMessage ( RB.MAIN, "userAssignments_LBL", RB.objA ) ;
String materialUsage = WTMessage.getLocalizedMessage ( RB.MAIN, "materialUsage_LBL", RB.objA ) ;
String committments = WTMessage.getLocalizedMessage ( RB.MAIN, "committments_LBL", RB.objA ) ;
String seasonCosts = WTMessage.getLocalizedMessage ( RB.MAIN, "seasonCosts_LBL", RB.objA ) ;
String sampleTracking = WTMessage.getLocalizedMessage ( RB.MAIN, "sampleTracking_LBL", RB.objA ) ;
String labDipTracking = WTMessage.getLocalizedMessage ( RB.MAIN, "labDipTracking_LBL", RB.objA ) ;

String siteLevelLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "siteLevel_LBL", RB.objA ) ;
String orgLevelLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "orgLevel_LBL", RB.objA ) ;
String wcHomePage = WTMessage.getLocalizedMessage ( RB.MAIN, "wcHomePage_LBL", RB.objA ) ;
String managerUserGroupProfiles = WTMessage.getLocalizedMessage ( RB.MAIN, "manageUserGroupProfiles_LBL", RB.objA ) ;

String errorReport_forceSystemErrorLink = WTMessage.getLocalizedMessage ( RB.ERRORREPORT, "errorReport_forceSystemErrorLink", RB.objA ) ;

String hostUrl = getUrl + "/..";


// START: VENDOR PORTAL PROFILE SETUP SECTION
String myProfileString = "";

  if(lcsContext.isVendor){
        myProfileString = (String)session.getAttribute("MY_PROFILE");
        if(!FormatHelper.hasContent(myProfileString)){
            myProfileString = "";
        }
        if(!FormatHelper.hasContent(myProfileString)){
            Collection vObjects = lcsContext.getVendorObjects();
            Iterator i = vObjects.iterator();
            FlexTyped tObj = null;
            while(i.hasNext()){
                tObj = (FlexTyped)i.next();
                String name = tObj.getFlexType().getRootType().getFullName();
                name = name + ":" + tObj.getValue("name");
                String id = "";
                if(tObj instanceof wt.enterprise.RevisionControlled){
                    id = FormatHelper.getVersionId((wt.enterprise.RevisionControlled)tObj);
                }
                else{
                    id = FormatHelper.getObjectId((WTObject)tObj);
                }
                myProfileString += "<a href=\"javascript:viewVendorObject('" + id + "')\">&nbsp;" +  name + "</a>";
                if(i.hasNext())myProfileString += "</br>";
            }
            session.setAttribute("MY_PROFILE", myProfileString);
        }
    }
// END: VENDOR PORTAL PROFILE SETUP SECTION


    appContext.loadSeasonList(false);

    String activity = request.getParameter("activity");
    String action = request.getParameter("action");
    String oid = request.getParameter("oid");
    String type = request.getParameter("type");
    String tabPage = request.getParameter("tabPage");


//Tests if Manage Attribute Value Lists link is to be placed in side menu. If Admin then will always be there. If not then query
// and test each to see if in the groups.

    if (!hasValueListMaintenanceAccess) {
        Map requestMap = RequestHelper.hashRequest(request);
        requestMap.put("attVariableType","choice|~*~|colorSelect|~*~|composite|~*~|driven|~*~|moaList");
        SearchResults results = new FlexTypeQuery().findAttributesByCriteria(requestMap);

        String userName = lcsContext.getUser().getName();
        if(!userName.equalsIgnoreCase("Administrator")){
            Hashtable typeMap = new Hashtable();
            Collection data = results.getResults();
            Iterator rows = data.iterator();

            try {

                while(rows.hasNext()) {

                    FlexObject flex = (FlexObject) rows.next();
                    String ftId = (String)flex.get("FLEXTYPE.IDA2A2");

                    //FlexType flextype = FlexTypeCache.getFlexType("OR:com.lcs.wc.flextype.FlexType:"+ftId);

                    String ftaId = (String)flex.get("FLEXTYPEATTRIBUTE.IDA2A2");
                    if(FormatHelper.hasContent(ftaId)){

                        // find the attribute
                        FlexTypeAttribute flexTypeAttribute = (FlexTypeAttribute) LCSQuery.findObjectById("OR:com.lcs.wc.flextype.FlexTypeAttribute:"+ftaId);

                        Collection maintenanceGroupsMap = new Vector();

                        // get the attributes Maintenance Groups
                        String maintenanceGroupsString = flexTypeAttribute.getMaintenanceGroups();
                        if(FormatHelper.hasContent(maintenanceGroupsString)){
                            StringTokenizer maintenanceGroupsTokenizer = new MultiCharDelimStringTokenizer(maintenanceGroupsString, MOAHelper.DELIM);
                            // create a map of groups allowed to maintain the attribute
                            while(maintenanceGroupsTokenizer.hasMoreTokens()) {
                                String currentGroup = maintenanceGroupsTokenizer.nextToken();
                                if(FormatHelper.hasContent(currentGroup))maintenanceGroupsMap.add(UserCache.getGroupName(currentGroup).toUpperCase());
                            }
                        } else {
                            // no maintenance groups for this attribute no point in continuing
                            continue;
                        }

                        // get the current users group membership
                        Collection userGroups = lcsContext.getGroups();

                        Iterator groupIter = userGroups.iterator();
                        boolean foundMatch = false;
                        // loop over the groups the user belongs to and see if any of the
                        // groups give the user Maintenance rights on this attributes value list
                        while(groupIter.hasNext()){
                            String userGroup = (String)groupIter.next();
                            if(maintenanceGroupsMap.contains(userGroup)){
                                foundMatch = true;

                                // this boolean controls whether the user will be allowed to see the option in the menu
                                hasValueListMaintenanceAccess = true;
                                break;
                            }
                        }

                        // found a match no need to look further
                        // the user has the rights to edit at least one attributes list of values
                        if(foundMatch)break;
                    }
                }
            } catch(Throwable th) {
                th.printStackTrace();
            }
        }
    }
%>

<script type="text/javascript" src="<%= URL_CONTEXT %>/lfusa/javascript/calendar/LFCalendarCustom.js"></script>
<script type="text/javascript" src="<%= URL_CONTEXT %>/javascript/seasonProductPage.js"></script>
<input type="hidden" name="rootTypeId" value="">
<input type="hidden" name="linePlanLevel" value="">
<input type="hidden" name="contextSKUId" value="">
<input type="hidden" name="globalChangeTrackingSinceDate" value="">
<ul id="tabnav" style='padding-left:10px'>
<li id='siteNavLink' class='tab'><a  href="javascript:changeNavigatorTab('site')"><%= siteTab_lbl %></a></li>
<li id='productNavLink' class='tab' style='display:none'><a  href="javascript:changeNavigatorTab('product')"><%= productTab_lbl %></a></li>
</ul>

<div id='siteNavigator'>
<!-- Start Border -->
<div class='BlueBox'>
<div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
    <div class='BoxContent'>
    <!-- Start Title -->
            <div style='overflow:hidden'>
                <table width='90%' cellspacing='0' cellpadding='0'>
                    <td class='BlueHeader' style='padding-left:10px;'>
                        <a href="javascript:toggleExpandableDiv('myWorkContent', 'myWorkContentIcon');checkInitialLoadWorkList();"><span style='padding-right:4px'><img id='myWorkContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%=myWorkButton%></a>
                  </td>
                </table>
            </div>
    <!-- End Title -->
    <!-- Start Content -->
          <div class='BlueBody' id='myWorkContent' style='display:none;'>
                  <div class='BlueBox' style='overflow:hidden'>
                    <div class='BlueBoxHeader'>
                    </div>
                    <div class='BoxContent' style='overflow:hidden'>
                        <div class="LABEL">
                            <a href="javascript:showCheckedOutItems();"><span style='padding-right:4px'><img id='myCheckedOutItemsContentIcon' valign="bottom" src='<%= WT_IMAGE_LOCATION %>/checkout.png' border='0'></span><%=myCheckedOutItemsPgHead%></a><br>
                        </div>
                        <br>
                        <div class="LABEL">                      
                            <a href="javascript:loadCalendarWorkitems();"><span style='padding-right:4px'><img id='myUpcomingWorkItemsIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/calendar2.png' border='0'></span><%= CALENDAR_WORK_ITEMS %></a><br>                            
                       </div>
                        
                        <br/>
                        <div id="workListDiv"></div>

                    </div>
                    <div class='BlueBoxFooter'>
                    </div>

                </div>

            </div>

    <!-- End Content -->
    </div>
<div class='BlueBoxFooter'></div>
</div>
<!-- End Border -->

<%if(lcsContext.isVendor){
    if(FormatHelper.hasContent(myProfileString)){%>
        <!-- Start Border -->
        <div class='BlueBox' >
        <div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
            <div class='BoxContent'>
            <!-- Start Title -->
                    <div style='overflow:hidden'>
                        <table width='90%' cellspacing='0' cellpadding='0'>
                            <td class='BlueHeader' style='padding-left:10px;'>
                                <a href="javascript:toggleExpandableDiv('myProfileContent', 'myProfileContentIcon');"><span style='padding-right:4px'><img id='myProfileContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= myInfoLabel%></a>
                          </td>
                        </table>
                    </div>
            <!-- End Title -->
            <!-- Start Content -->
                  <div class='BlueBody' id='myProfileContent' style='display:none;'>
                          <div class='BlueBox'>
                            <div class='BlueBoxHeader'>
                            </div>
                            <div class='BoxContent'>
                                <div class="LABEL">
                                <%= myProfileString%>
                                </div>

                            </div>
                            <div class='BlueBoxFooter'>
                            </div>

                        </div>

                    </div>

            <!-- End Content -->
            </div>
        <div class='BlueBoxFooter'></div>
        </div>
        <!-- End Border -->
        <%}
}%>

<!-- Start Border -->
<div class='BlueBox'>
<div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
    <div class='BoxContent'>
    <!-- Start Title -->
            <div style='overflow:hidden'>
                <table width='90%' cellspacing='0' cellpadding='0'>
                    <td class='BlueHeader' style='padding-left:10px;'>
                        <a href="javascript:toggleExpandableDiv('favoritesContent', 'favoritesContentIcon');"><span style='padding-right:4px'><img id='favoritesContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= favoritesLabel %></a>
                  </td>
                </table>
            </div>
    <!-- End Title -->
    <!-- Start Content -->
          <div class='BlueBody' id='favoritesContent' style='display:none;'>
                  <div class='BlueBox'>
                    <div class='BlueBoxHeader'>
                    </div>
                    <div class='BoxContent'>
                        <div id="favoritesListDiv" style='overflow:hidden'>
                        </div>
                    </div>
                    <div class='BlueBoxFooter'>
                    </div>
                </div>
            </div>
    <!-- End Content -->
    </div>
<div class='BlueBoxFooter'></div>
</div>
<!-- End Border -->


<%
    String id = "";
    String name;
    String seasonVersionId;
    boolean activeSeason;


if(!lcsContext.isVendor){%>
<!-- Start Border -->
<div class='BlueBox'>
<div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
<div class='BoxContent'>
<!-- Start Title -->
        <div style='overflow:hidden'>
            <table width='90%' cellspacing='0' cellpadding='0'>
                <td class='BlueHeader' style='padding-left:10px;'>
                    <a href="javascript:toggleExpandableDiv('seasonsContent', 'seasonsContentIcon');"><span style='padding-right:4px'><img id='seasonsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= mySeasonsLabel %></a>
              </td>
            </table>
        </div>
<!-- End Title -->
<!-- Start Content -->
      <div class='BlueBody' id='seasonsContent' style='display:none;'>
        <div class='BlueBox'>
            <div class='BlueBoxHeader'>
            </div>
            <div class='BoxContent' style='overflow:hidden'>
                <%
                    Map seasonMap = appContext.getSeasonMap();
                    Iterator seasonIter = seasonMap.keySet().iterator();

                    Collection seasons = new Vector();
                    while(seasonIter.hasNext()) {
                        FlexObject season = new FlexObject();
                        season.put("oid",seasonIter.next());
                        season.put("name",seasonMap.get(season.get("oid")));
                        seasons.add(season);
                    }
                    seasonIter = SortHelper.sortFlexObjects(seasons,"name").iterator();

                    %>
                    <select name="seasonSelectList" id="seasonSelectList">
                    <%
                    while(seasonIter.hasNext()){
                        FlexObject season = (FlexObject) seasonIter.next();
                        id = "" + season.get("oid");
                        name = "" + season.get("name");
                        name = FormatHelper.encodeAndFormatForHTMLContent(name);
                        %><option value="<%= id %>"><a href="javascript:void(0)"><%= name %></a><%
                    }
                    %>
                    </select>
                    <br><div style="padding-bottom:10px;"></div>
                    <a id="ac_seasonActions" href="javascript:getActiveSeasonActions()" class="actions_link"><%= actions_lbl %></a>                    
                    <div style='padding-bottom:2px;padding-top:5px'><a class="LABEL" href="javascript:toggleExpandableDiv('seasonConceptContent', 'seasonConceptContentIcon');"><span style='padding-right:4px'><img id='seasonConceptContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/expand_tree.png' border='0'></span><%= conceptsLabel %></a></div>
                    <div id='seasonConceptContent'>
                        <a href="javascript:viewSelectedSeasonDetails()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/flexdetails.png" alt="" border="0" align="bottom"></span><%= detailsLabel %></a><br>
						<%if(USE_INSPIRATIONS){%>
                        <a href="javascript:viewSelectedInspirations()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/inspiration_s.png" alt="" border="0" align="bottom"></span><%= inspirationsLabel %></a><br>  
						<%}%>
                        <a href="javascript:viewSelectedPalette()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/palette_s_3.png" alt="" border="0" align="bottom"></span><%= paletteLabel %></a><br>
						<%
						if(USE_SILHOUETTES){%>
						<!--GBG Build 10 : commented below code to hide Silhouettes option from side menu : start-->
                        <!-- <a href="javascript:viewSelectedSilhouettes()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/silhouette_s.png" alt="" border="0" align="bottom"></span><%= silhouettesLabel %></a><br>-->
						<!--GBG Build 10 : commented below code to hide Silhouettes option from side menu : end-->
						<%}%>
                   </div>
                   <div style='padding-bottom:2px;padding-top:5px'><a class="LABEL" href="javascript:toggleExpandableDiv('seasonDevelopmentContent', 'seasonDevelopmentContentIcon');"><span style='padding-right:4px'><img id='seasonDevelopmentContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/expand_tree.png' border='0'></span><%= developmentLabel %></a></div>                    
                   <div id='seasonDevelopmentContent'>
                        <a href="javascript:viewSelectedPlanning()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/projectPlan.gif" alt="" border="0" align="bottom"></span><%= planningLabel %></a><br>
                        <a href="javascript:viewSelectedLineSheet()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/lineplan_s.png" alt="" border="0" align="bottom"></span><%= lineLabel %></a><br>
                        <a href="javascript:viewSelectedLineBoard()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/lineboard_s.png" alt="" border="0" align="bottom"></span><%= presentationBoardLabel %></a><br>
                        <a href="javascript:viewSelectedCalendar()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/calendar2.png" width="28" alt="" border="0" align="bottom"></span><%= calendarLabel %></a><br>
                        <a href="javascript:viewSelectedDashboard()"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src="<%=WT_IMAGE_LOCATION%>/chart_pie.png" alt="" border="0" align="bottom"></span><%= dashboardsLabel %></a><br>
                   </div>
                   <div style='padding-bottom:2px;padding-top:5px' ><a class="LABEL" href="javascript:toggleExpandableDiv('seasonReportsContent', 'seasonReportsContentIcon');"><span style='padding-right:4px'><img id='seasonReportsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= reportsLabel %></a></div>                    
                   <div id='seasonReportsContent' class="LABEL" style='display:none'>
                       <%if(BASELINE_INSTALLED){%>
                       <a <%= getClass(true, "VIEW_PRODUCT_COUNT_REPORT", activity) %> href="javascript:viewReport('VIEW_PRODUCT_COUNT_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= productCount%></a><br>
                       <a <%= getClass(true, "VIEW_USER_ASSIGNMENT_REPORT", activity) %> href="javascript:viewReport('VIEW_USER_ASSIGNMENT_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= userAssignments%></a><br>
                       <a <%= getClass(true, "VIEW_MATERIAL_USAGE_REPORT", activity) %> href="javascript:viewReport('VIEW_MATERIAL_USAGE_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= materialUsage%></a><br>
                       <a <%= getClass(true, "VIEW_MATERIAL_COMMITMENT_REPORT", activity) %> href="javascript:viewReport('VIEW_MATERIAL_COMMITMENT_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= committments%></a><br>
                       <a <%= getClass(true, "VIEW_SEASON_COST_REPORT", activity) %> href="javascript:viewReport('VIEW_SEASON_COST_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= seasonCosts%></a><br>
                       <a <%= getClass(true, "VIEW_SAMPLE_TRACKING_REPORT", activity) %> href="javascript:viewReport('VIEW_SAMPLE_TRACKING_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= sampleTracking%></a><br>
                       <a <%= getClass(true, "VIEW_MATCOL_TRACKING_REPORT", activity) %> href="javascript:viewReport('VIEW_MATCOL_TRACKING_REPORT')"><span style='padding-right:4px;padding-left:15px;'></span><%= labDipTracking%></a><br>
                         <!--- end of Baseline Report Additions -->
                       <%}%>
                   </div>
                   
            </div>
            <div class='BlueBoxFooter'>
            </div>
        </div>
    </div>
<!-- End Content -->
</div>


<div class='BlueBoxFooter'></div>
</div>
<!-- End Border -->
<%}%>


<!-- Start Border -->
<div class='BlueBox'>
<div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
<div class='BoxContent'>
<!-- Start Title -->
        <div style='overflow:hidden'>
            <table width='90%' cellspacing='0' cellpadding='0'>
                <tr>
                    <td class='BlueHeader' style='padding-left:10px;'>
                    <a href="javascript:toggleExpandableDiv('librariesContent', 'librariesContentIcon');"><span style='padding-right:4px'><img id='librariesContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= librariesLabel %></a>
                    </td>
                </tr>

            </table>

        </div>
<!-- End Title -->
<!-- Start Content -->
      <div class='BlueBody' id='librariesContent' style='display:none;'>
              <div class='BlueBox'>
                <div class='BlueBoxHeader'>
                </div>
                <div class='BoxContent' style='overflow:hidden'>
                    <div class="LABEL">
                    <%


                        Hashtable scripts = new Hashtable();

                        // KEY is expected to be the ROOT type of the flex type tree
                        if(!lcsContext.isVendor){
						   //scripts.put("Agent","findAgent()");
						   //scripts.put("Factory","findFactory()");
							if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("BOM\\Materials"))){
								scripts.put("BOM","bomSearch()");
							}
                            scripts.put("Color","findColor()");
                            scripts.put("Business Object","findCBO()");
                            scripts.put("Change Activity","findChangeActivity()");
                            scripts.put("Country","findCountry()");
                            scripts.put("Construction","manageConstruction()");
                            scripts.put("Document","findDocument()");
                            scripts.put("Document Collection","findDocumentCollection()");
                            scripts.put("Effectivity Context","findEffectivityContext()");
                            scripts.put("Image","findImage()");
                            scripts.put("Last","findLast()");
                            scripts.put("Log Entry","findLogEntry()");
                            scripts.put("Material","findMaterial()");
                            scripts.put("Measurements","manageMeasurements()");
                            // - Removed no longer supported due to multi-scope/object material search page
                            //scripts.put("Material Color","findMaterialColor()");
                            //scripts.put("Material Supplier","findMaterialSupplier()");
                            scripts.put("Media","findMedia()");
                            scripts.put("Multi-Object","findMultiObject()");
                            scripts.put("Order Confirmation","findOrderConfirmation()");
                            scripts.put("Palette","findPalette()");
                            
                            scripts.put("Plan","findPlan()");
                            scripts.put("Placeholder","findPlaceholder()");
                            scripts.put("Product","findProduct()");
                    //        scripts.put("Product Destination","findProductDestination()");
                    		//Story B-38659
							////////////////////////////////////////////////
							//if(ACLValidatorFactory.getACLValidator(new ProductSizeCategory()).isInAdminGroup()){
                    			scripts.put("Size Definition","manageSizingDefinition()");
                    		//}
                    		////////////////////////////////////////////////
                            scripts.put("RFQ","findRFQ()");
                            scripts.put("Sample","findSample()");
                            scripts.put("Season","findSeason()");
                            scripts.put("SKU","findSKU()");
                            scripts.put("Supplier","findSupplier()");
                            scripts.put("Test Specification","manageTesting()");
						//GBG : Calendar functionality change : allow only Calendar Business Administrators to create templates: start
                            if(ACLValidatorFactory.getACLValidator(LCSCalendar.newLCSCalendar()).isInAdminGroup()
                            		||adminGroup.equals("ALL") 
                            		|| lcsContext.inGroup(adminGroup.toUpperCase())){
                            	scripts.put("Calendar","manageCalendars()");
                              }
						//GBG : Calendar functionality change : allow only Calendar Business Administrators to create templates: end                            

                        }else{
							scripts.put("Color","findColor()");
							//PLM -172 : Commented to remove access to Vendor portal users 
                            //scripts.put("Document","findDocument()");

                            boolean hasSupplierLinks = false;

                            for(Iterator vendorObjsItr = lcsContext.getVendorObjects().iterator();vendorObjsItr.hasNext(); ){
                                    if(hasSupplierLinks){
                                            break;
                                    }else if(vendorObjsItr.next().toString().indexOf("LCSSupplier:") > -1){
                                            hasSupplierLinks = true;
                                    }
                            }
                            if(USE_MATERIAL &&  ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Material")) && hasSupplierLinks) { 
                                scripts.put("Material","findMaterial()");
                            }


                            if(USE_ORDERCONF &&  ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Order Confirmation")) && hasSupplierLinks) { 
                                scripts.put("Order Confirmation","findOrderConfirmation()");
                            }

                            if(USE_PRODUCT &&  ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product")) && hasSupplierLinks) { 
                                scripts.put("Product","findProduct()");
                            }

                            if(USE_RFQ && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("RFQ")) && hasSupplierLinks) { 
                                scripts.put("RFQ","findRFQ()");
                            }

                            if(USE_SAMPLE && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Season")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product"))){
                                scripts.put("Sample","findSample()");
                            }
                        }

                        Object[] it = scripts.keySet().toArray();
                        Arrays.sort(it);

                        FlexType t;
                        for(int i = 0; i < it.length; i++){
                            name = (String)it[i];
                            if(name.equals("SKU") || name.equals("Placeholder")){
                                t = FlexTypeCache.getFlexTypeRoot("Product");
                            } else if(name.equals("Material Supplier")){
                                t = FlexTypeCache.getFlexTypeRoot("Material");
                            } else{
                                t = FlexTypeCache.getFlexTypeRoot(name);
                            }
                            if(t != null && ACLHelper.hasViewAccess(t)){

                                // LOCALIZE THE NAME OF THE OPTIONS... BREAKS ON SKU :(
                                //String localizedName = t.getTypeDisplayName();
                                //String script = "" + scripts.get(name);
                                //scripts.remove(name);
                                //scripts.put(localizedName, script);

                                // LOCALIZE THE NAME OF THE OPTIONS...
                                // Go to Resource Bundle for SKU
                                // Use TypeManager localization for all other types
                                String localizedName = "";
                                if(name.equals("SKU")){
                                    localizedName = skuLabel;
                                } else if(name.equals("Material Supplier")){
                                    localizedName = materialSupplierLabel;
                                } else if(name.equals("Placeholder")){
                                    localizedName = WTMessage.getLocalizedMessage ( RB.PLACEHOLDER, "placeholder_LBL", RB.objA ) ;
                                } else {
                                    localizedName = t.getTypeDisplayName();
                                }
                                String script = "" + scripts.get(name);
                                scripts.remove(name);
                                scripts.put(localizedName, script);
                            } else {
                                scripts.remove(name);
                            }
                        }

                        Iterator revisableEntityChildren = FlexTypeCache.getFlexTypeFromPath("Revisable Entity").getChildren().iterator();
                        while(revisableEntityChildren.hasNext()){
                            t = (FlexType)revisableEntityChildren.next();
                            if(ACLHelper.hasViewAccess(t) && !lcsContext.isVendor){
                                scripts.put(t.getTypeDisplayName(), "findRBO('" + FormatHelper.getObjectId(t) + "')");
                            }
                        }


						if(FORUMS_ENABLED){
							String libOid =	new wt.fc.ReferenceFactory().getReferenceString(com.lcs.wc.util.FlexContainerHelper.getFlexContainer());
							String parameters = "components$loadWizardStep$" + libOid + "$|forum$discuss$" + libOid + "&oid=" + libOid;
							HashMap urlParam = new HashMap();
							urlParam.put("oid", libOid);
							String discussionLink = FormatHelper.convertToShellURL(NetmarketURL.buildURL(new NmURLFactoryBean(), "project", "view_forum_flex", null, urlParam, true, new NmAction()));
						    scripts.put(discussionLibrary_LBL,"createDialogWindow('"+ discussionLink +"', 'Discussions', '900', '600', '1')");
						}

                        Iterator keys = SortHelper.sortStrings(scripts.keySet()).iterator();
                        while(keys.hasNext()){
                            name = (String) keys.next();
                            %>
                            <a href="javascript:<%= scripts.get(name) %>"><%= name %></a><br>
                            <%
                        }

                    %>
                    </div>
                </div>
                <div class='BlueBoxFooter'>
                </div>
            </div>
        </div>
<!-- End Content -->
</div>
<div class='BlueBoxFooter'></div>
</div>
<!-- End Border -->




<!-- Start Border -->
<div class='BlueBox'>
<div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
<div class='BoxContent'>
<!-- Start Title -->
        <div style='overflow:hidden'>
            <table width='90%' cellspacing='0' cellpadding='0'>
                <tr>
                    <td class='BlueHeader' style='padding-left:10px;'>
                    <a href="javascript:toggleExpandableDiv('reportsContent', 'reportsContentIcon');"><span style='padding-right:4px'><img id='reportsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= reportsLabel %> </a>
                    </td>
                </tr>

            </table>

        </div>
<!-- End Title -->
<!-- Start Content -->
      <div class='BlueBody' id='reportsContent' style='display:none;'>
              <div class='BlueBox'>
                <div class='BlueBoxHeader'>
                </div>
                <div class='BoxContent' style='overflow:hidden'>
                    <div class="LABEL">

                        <%if(!lcsContext.isVendor){%>

                            <a href="javascript:viewExceptionReport()" <%= getClass(true, "WORKLIST_EXCEPTION_REPORT", activity)%>><%= worklistExceptionsOpt %></a><br>
                            <% if(adminGroup.equals("ALL") || lcsContext.inGroup(adminGroup.toUpperCase())){ %>
                                <a href="javascript:viewAllAttributes()"><%= listAttributesOpt %></a><br>
                                <a href="javascript:viewLCSAccessLogStats()"><%= userAccessLogStatsOpt %></a><br>
                            <% } %>
                        <%}else{%>
                            <%if(false && USE_SAMPLE && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Season")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product"))) {%>
                                    <a href="javascript:launchSampleList()">&nbsp;<%= sampleLabel %></a><br>
                            <%}%>
                            <% //Neew RFQ functionality has depricated this report
                            if(false && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Season")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product")))  { %>
                                    <a href="javascript:launchRFQ()">&nbsp;<%= rfqLabel %></a><br>
                            <%}%>
                        <%}%>                               
                                <!--GBG CALENDAR FUNCTIONALITY PHASE 2 STARTS -->
                                <% if(lcsContext.inGroup(adminGroup.toUpperCase()) || lcsContext.inGroup(gbgUserAssessmentGroup.toUpperCase())){ %>
                                  <a href="javascript:userAssessmentTaskReport()"><%= USER_ASSESSMENT_TASK_REPORT %></a><br>
                                  
                                <% } %>
                                
                                <% if(lcsContext.inGroup(adminGroup.toUpperCase()) || lcsContext.inGroup(gbgSeasonTaskGroup.toUpperCase())){ %>                                
                                  <a href="javascript:seasonalTaskReport()"><%= SEASONAL_TASK_REPORT %></a><br>
                                  
                                <% } %>
                                <!--GBG CALENDAR FUNCTIONALITY PHASE 2 ENDS -->
                                
						<%for(int i=0; i<reportList.length; i++){
							String reportAliasName= reportList[i];
							String reportName=LCSProperties.get("com.lfusa.wc."+reportAliasName+".ReportName");
							String activityName=LCSProperties.get("com.lfusa.wc."+reportAliasName+".activity");
							System.out.println("group id is......"+reportGenerateGroup+"..."+sampleReportGenerateGroup+"..."+changeTrackingReportGroup+"..."+lcsContext.getGroups());
							if(lcsContext.inGroup(reportGenerateGroup) && activityName.equals("PRODUCT_ADOPTION_REPORT")){%>
								<a href="javascript:viewLFProductAdoptionReport('<%=reportAliasName%>','<%=activityName%>')"><%=reportName%></a><br>
							<%}if(lcsContext.inGroup(sampleReportGenerateGroup) && activityName.equals("SAMPLE_TRACKING_REPORT")){%>
								<a href="javascript:viewLFProductAdoptionReport('<%=reportAliasName%>','<%=activityName%>')"><%=reportName%></a><br>
							<%}if(lcsContext.inGroup(changeTrackingReportGroup) && activityName.equals("CHANGE_TRACKING_REPORT")){%>
								<a href="javascript:viewLFProductAdoptionReport('<%=reportAliasName%>','<%=activityName%>')"><%=reportName%></a><br>
							<%}if(lcsContext.inGroup(bomListingReportGroup) && activityName.equals(bomListingReportActivity)){%>
								<a href="javascript:viewLFProductAdoptionReport('<%=reportAliasName%>','<%=activityName%>')"><%=reportName%></a><br>
							<%}}%>
                    </div>
                </div>
                <div class='BlueBoxFooter'>
                </div>
            </div>
        </div>
<!-- End Content -->
</div>
<div class='BlueBoxFooter'></div>
</div>
<!-- End Border -->

<%if(!lcsContext.isVendor){%>

<div class='BlueBox'>
    <div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
    <div class='BoxContent'>
            <div style='overflow:hidden'>
                <table width='90%' cellspacing='0' cellpadding='0'>
                    <td class='BlueHeader' style='padding-left:10px;'>
                        <a href="javascript:toggleExpandableDiv('adminContent', 'adminContentIcon');"><span style='padding-right:4px'><img id='adminContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%=administrativeLabel %></a>
                  </td>
                </table>
            </div>
          <div class='BlueBody' id='adminContent' style='display:none;'>
                <div class='BlueBox'>
                    <div class='BlueBoxHeader'>
                    </div>
                    <div class='BoxContent' style='overflow:hidden'>
                        <div class="LABEL">
                        <%
                        /*** Get the classic container reference to be used for some clients ***/

                        String orgContainerRef = com.lcs.wc.util.FlexContainerHelper.getFlexContainer().getParentRef().toString();
                        String siteContainerRef = (wt.inf.container.WTContainerHelper.getExchangeRef()).toString();
                        
                        String WCShellContext = WindchillContext + "/" + NetmarketURL.convertToShellURL(NetmarketURL.getMVCURL(""));
			
			NmURLFactoryBean urlFactoryBean = new NmURLFactoryBean();
  			HashMap urlParam = new HashMap();
			urlParam.put("oid", java.net.URLEncoder.encode("OR:" +orgContainerRef));

                        String orgUserGroupLink  = FormatHelper.convertToShellURL(NetmarketURL.buildURL(urlFactoryBean, "administration", "participantAdministration_flex", null, urlParam, true, new NmAction()));
                        
                        urlParam.clear();
                        urlParam.put("oid", java.net.URLEncoder.encode("OR:" +siteContainerRef));
                        String siteUserGroupLink  = FormatHelper.convertToShellURL(NetmarketURL.buildURL(urlFactoryBean, "administration", "participantAdministration_flex", null, urlParam, true, new NmAction()));
                        
                        String wcHomePageLink  = WCShellContext + "homepage";
                        
                        String wcProfilesLinks  = NetmarketURL.buildURL(urlFactoryBean, "org", "listProfiles_flex", NmOid.newNmOid("OR:" +orgContainerRef));
                        %> 
                        
                        <% if(adminGroup.equals("ALL") || lcsContext.inGroup(adminGroup.toUpperCase())){ %>

							<%if(ERROR_TESTING){%>
								<a href="javascript:throwErrorPage()"><%= errorReport_forceSystemErrorLink %></a><br>
							<%}%>

                            <a href="javascript:manageTypes()"><%= manageTypesLabel %></a><br>
                            <a href="javascript:manageMultiObjectLocks()"><%= manageLocksLabel%></a><br>
                            <a href="javascript:manageAttributeValueLists()"><%= manageAttributeValueListsLabel %></a><br>
                            <a href="javascript:processAdmin()"><%= manageProcessesLabel %></a><br>
                            <a href="javascript:toggleExpandableDiv('userGroupTable', 'manageUsersIcon');loadManageUsersOptions();"><span style='padding-right:4px'><img id='manageUsersIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%=manageUsersLabel%></a><br>
                                <div id='userGroupTable' style='display:none;'></div>
							<a href="javascript:createToolbarWindow('<%=wcProfilesLinks%>','Profiles')"><%= managerUserGroupProfiles %></a><br>
							<a href="javascript:loadFile()"><%= loadFileLabel %></a><br>
                            <a href="javascript:loadL10NFile()"><%= loadTranslationFileLabel%></a><br>
							<a href="javascript:clearUserGroupCache()"><%= clearUserGroupCacheLabel %></a><br>
                            <a href="javascript:clearFlexTypeCache()"><%= clearFlexTypeCacheLabel %></a><br>
							<a href="javascript:wcHomePage('<%=wcHomePageLink%>')"><%= wcHomePage %></a><br>

                         <% } else if(lcsContext.inGroup(typeAdminGroup.toUpperCase()) ||
                                      lcsContext.inGroup(userAdminGroup.toUpperCase()) ||
                                      lcsContext.inGroup(processAdminGroup.toUpperCase()) ||
                                      hasValueListMaintenanceAccess
                                     ) { %>


                            <% if(lcsContext.inGroup(typeAdminGroup.toUpperCase())){ %>
                            <a href="javascript:manageTypes()"><%= manageTypesLabel %></a><br>
                            <% } %>
                            <% if(lcsContext.inGroup(processAdminGroup.toUpperCase())){%>
                            <a href="javascript:processAdmin()"><%= manageProcessesLabel %></a><br>
                            <%}%>
                            <% if(lcsContext.inGroup(userAdminGroup.toUpperCase())){ %>
                                <a href="javascript:toggleExpandableDiv('userGroupTable', 'manageUsersIcon');loadManageUsersOptions();"><span style='padding-right:4px'><img id='manageUsersIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%=manageUsersLabel%></a><br>
                                    <div id='userGroupTable' style='display:none;'></div>
                            <% } %>
                            <% if(hasValueListMaintenanceAccess){ %>
                            <a href="javascript:manageAttributeValueLists()"><%= manageAttributeValueListsLabel %></a><br>
                            <% } %>

                        <% } %>
                        </div>
                    </div>
                    <div class='BlueBoxFooter'>
                    </div>
                </div>
            </div>
    <!-- End Content -->
    </div>
    <div class='BlueBoxFooter'></div>
</div>

<script>
      
    function loadManageUsersOptions(){
        var userGroupTable = document.getElementById('userGroupTable');
        if(!hasContent(userGroupTable.innerHTML)){
            <%//This needs to change later(possibly lcsContext.getUser because of getOrganization????) when we support multiple organizations with FlexPLM as right now we get the users organization and check if they are in the organizations administrators group etc etc.
            if(lcsContext.inGroup("ADMINISTRATORS") || (lcsContext.getUser().getOrganization() != null && lcsContext.getUser().getOrganization().getAdministrator() != null && lcsContext.inGroup(lcsContext.getUser().getOrganization().getAdministrator().getName().toUpperCase()))){%>
            userGroupTable.innerHTML = "\
                <a href=\"javascript:manageUsers('<%=orgUserGroupLink%>')\"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src='<%=WT_IMAGE_LOCATION%>/organization_context.gif' alt='' border='0' align='bottom'></span><%=FormatHelper.formatJavascriptString(orgLevelLabel)%></a><br>\
            ";
            <%}%>
            <%if(lcsContext.inGroup("ADMINISTRATORS")){%>
                userGroupTable.innerHTML += "\
                    <a href=\"javascript:manageUsers('<%=siteUserGroupLink%>')\"><span style='padding-right:4px;padding-left:15px;'><img width='16' align='middle' src='<%=WT_IMAGE_LOCATION%>/user.gif' alt='' border='0' align='bottom'></span><%=FormatHelper.formatJavascriptString(siteLevelLabel)%></a><br>\
                ";
            <%}%>
        }else{
            userGroupTable.innerHTML = '';
        }

    }   
</script>

<%}%>

</div> <!-- END SITE NAVIGATION -->

<div id='productNavigator' style='display:none;'>
    PRODUCT NAV
</div>

<!-- End Border -->
<script>
    var activeProductId;
    var activeSKUId;
    var activeOid;
    function getActionsMenuWithActiveProductId(Id){
    	getActionsMenu(Id, '', '&activeProductId='+activeOid+'&contextSKUId='+activeSKUId);
    }
    ///////////////////////////////////////////////////////////////////////////
    function loadProductSideBar(productId,skuId,quickNavTab){
    	var tempQuickNavTab='';
    	if(hasContent(quickNavTab)){
    		tempQuickNavTab=quickNavTab;
    	}
        setActiveProduct(productId, productId, '', '', true);
        if(!<%= LOAD_SIDEBAR_ONLY_ON_PRODUCTLINK %>){
            window.parent.contentframe.loadProductNavigator(productId,tempQuickNavTab,'',skuId);
        }
    }
    ///////////////////////////////////////////////////////////////////////////
    function setActiveProductFromSeasonList(productId){
        setActiveProduct(productId, activeOid, '', '', true);
		if(window.parent.contentframe.changeProductSeason){
			window.parent.contentframe.changeProductSeason(productId);
		}else{
			window.parent.contentframe.loadProductNavigator(productId);
		}
    }
    ///////////////////////////////////////////////////////////////////////////
    function setActiveProduct(productId, activeId, productName, skuId, forceReload){
        
        // CHECK TO SEE IF ACTIVE PRODUCT ID IS THE SAME
        //console.log("setActiveProduct");
        if(!(forceReload == true) && activeProductId == productId && activeSKUId == skuId){
            changeNavigatorTab('product');
            if (activeId == activeProductId)
            	return;
        }
        if(activeProductId != productId || forceReload){
        	if(forceReload){
            	console.log("setActiveProduct: forceReload");
            }else{
            	console.log("setActiveProduct: loading with new product id");
            }
		
            runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/Main.jsp?activity=VIEW_SIDE_BAR_PRODUCT_NAVIGATOR&timecode=' + new Date().getTime() + '&oid=' + productId +'&globalChangeTrackingSinceDate='+window.parent.headerframe.getGlobalChangeTrackingSinceDate(), 'completeLoadProductNavigator');
        } else {
            changeNavigatorTab('product');
        }

        activeProductId = productId;
        activeSKUId = skuId;
        if(hasContent(activeId)){
            activeOid = activeId;
        } else {
            activeOid = productId;
        }
        console.log("setActiveProduct: activeProductId = " + activeProductId + " activeSKUId " + activeSKUId + " activeId = " + activeId);
		//The following 2 parameters are set in here so that the quick actions from the side menu (Update Measurement Set, Update Constuction Set)will return to the view season product link page upon completion.
		document.REQUEST.oid = productId;
		document.REQUEST.activity = "VIEW_SEASON_PRODUCT_LINK";
		//Clear the old activity/action info to prevent going to the wrong place
        document.MAINFORM.activity.value="VIEW_SEASON_PRODUCT_LINK";
        document.MAINFORM.action.value="";
        document.MAINFORM.oid.value=productId;
        document.MAINFORM.returnActivity.value="VIEW_SEASON_PRODUCT_LINK";
        document.MAINFORM.returnAction.value="";
        document.MAINFORM.returnOid.value=productId;
        document.MAINFORM.copyFromOid.value = '';
        document.MAINFORM.productId.value='';
        document.MAINFORM.seasonId.value = '';

    }
    function completeLoadProductNavigator(xml, text){
        changeNavigatorTab('product');
        //console.log(text);
        var div = document.getElementById('productNavigator');
        parseScripts(text);
        div.innerHTML = text;
    }
    ////////////////////////////////////////////////////////////////////////////
    function addToFavorites(ids){
        //displayFavorites();
        if(hasContent(ids)){
           runPostAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/Main.jsp','activity=ADD_TO_FAVORITES&oids=' + ids + '&timecode=' + new Date().getTime(), 'completeAddFavorites');
        }
    }
    ////////////////////////////////////////////////////////////////////////////
    function completeAddFavorites(){
        loadFavorites();
    }
    function loadFavorites(){
        runPostAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/Main.jsp','activity=VIEW_FAVORITES' + '&timecode=' + new Date().getTime(), 'completeViewFavorites');
    }
    ////////////////////////////////////////////////////////////////////////////
    function completeViewFavorites(xml, text){
        var div = document.getElementById('favoritesListDiv');
        div.innerHTML = text;
    }
    ////////////////////////////////////////////////////////////////////////////
    function removeFromFavorites(){
        var ids = getCheckBoxIds(document.MAINFORM.favoritesCheckBox);
        runPostAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/Main.jsp','activity=REMOVE_FROM_FAVORITES&oids=' + ids + '&timecode=' + new Date().getTime(), 'completeViewFavorites');
        //alert(ids);
    }
    ////////////////////////////////////////////////////////////////////////////
    function viewSelectedLineSheet(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewLinePlan(seasonList.options[seasonList.selectedIndex].value);
    }
    function viewSelectedLineBoard(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewLineBoard(seasonList.options[seasonList.selectedIndex].value);
    }
    function viewSelectedPalette(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewSeasonPalette(seasonList.options[seasonList.selectedIndex].value);
    }
    function viewSelectedPlanning(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewSeasonPlanning(seasonList.options[seasonList.selectedIndex].value);
    }
    function viewSelectedDashboard(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewSeasonDashboards(seasonList.options[seasonList.selectedIndex].value);    
    }
    function viewSelectedCalendar(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewSeasonCalendar(seasonList.options[seasonList.selectedIndex].value);    
    }    
    function viewSelectedSeasonDetails(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewObject(seasonList.options[seasonList.selectedIndex].value);    
    }   
    function viewSelectedSilhouettes(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewSeasonSilhouette(seasonList.options[seasonList.selectedIndex].value);    
    }
    function viewSelectedInspirations(){
        var seasonList = document.MAINFORM.seasonSelectList;
        viewSeasonInspiration(seasonList.options[seasonList.selectedIndex].value);    
    }  
    
    var activeSeasonMenu = document.getElementById('ac_seasonActions');
    function getActiveSeasonActions(){
        console.log("getActiveSeasonActions!");
        
        var seasonList = document.MAINFORM.seasonSelectList;
        activeSeasonMenu.id = ('ac_' + seasonList.options[seasonList.selectedIndex].value);
        console.log(activeSeasonMenu.id);
        getActionsMenu(seasonList.options[seasonList.selectedIndex].value);
    }         
    ////////////////////////////////////////////////////////////////////////////
    loadFavorites();

    ////////////////////////////////////////////////////////////////////////////
    function changeNavigatorTab(tab){
        var productNavLink = document.getElementById('productNavLink');
        var siteNavLink = document.getElementById('siteNavLink');
        closeActionsMenu();
        if(tab == 'site'){

            showDiv('siteNavigator');
            hideDiv('productNavigator');
            productNavLink.className = 'tab';
            siteNavLink.className = 'tabselected';


        } else if (tab == 'product'){

            showDiv('productNavigator');
            hideDiv('siteNavigator');
            productNavLink.className = 'tabselected';
            productNavLink.style.display = 'block';
            siteNavLink.className = 'tab';

        }
    }
    ////////////////////////////////////////////////////////////////////////////
    function checkInitialLoadWorkList(){
        
        var workListDiv = document.getElementById('workListDiv');
        if(!hasContent(workListDiv.innerHTML)){
            console.log("checkInitialLoadWorkList: LOADING");        
            loadWorkList();            
        }    
    }    
    ////////////////////////////////////////////////////////////////////////////    
    function loadWorkList(){
        console.log("loadWorkList: start");    
        var workListDiv = document.getElementById('workListDiv');
        workListDiv.innerHTML = "<center><br><img border='0' src='<%= URL_CONTEXT %>/images/blue-loading.gif'><br></center>";
        
        runPostAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/SideMenuAddWorkList.jsp', 'timecode=' + new Date().getTime(), 'completeLoadWorkList');    
        //runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/SideMenuAddWorkList.jsp?insertPath=' + workListInsertNodePath + '&insertBeforePath=' + workListInsertBeforePoint + '&timecode=' + new Date().getTime(), 'insertWorkList');
    }    
    ////////////////////////////////////////////////////////////////////////////
    function completeLoadWorkList(xml, text){
        //console.log(text);
        var workListDiv = document.getElementById('workListDiv');
        workListDiv.innerHTML = text;
    }
    ////////////////////////////////////////////////////////////////////////////
    function removeFromFavorites(){
        var ids = getCheckBoxIds(document.MAINFORM.favoritesCheckBox);
        runPostAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/main/Main.jsp','activity=REMOVE_FROM_FAVORITES&oids=' + ids + '&timecode=' + new Date().getTime(), 'completeViewFavorites');
    }     
    ////////////////////////////////////////////////////////////////////////////    
    // Baseline Report additions start //

    function viewReport(activity){
        document.MAINFORM.activity.value = activity;
        document.MAINFORM.oid.value = getSelectedSeasonId();
        submitForm();
    }

    function viewVendorObject(oid){
        if(oid.indexOf('LCSSupplier') > -1){
            viewSupplier(oid);
        } else if(oid.indexOf('LCSAgent') > -1){
            viewAgent(oid);
        } else if(oid.indexOf('LCSFactory') > -1){
            viewFactory(oid);
        }
    }
    function launchRFQ(){
        //alert("RFQ");
        document.MAINFORM.activity.value="VIEW_RFQ_PAGE";
        document.MAINFORM.action.value="INIT";
        submitForm();
    }

    function launchSampleList(){
        //alert("RFQ");
        document.MAINFORM.activity.value="VIEW_VENDOR_SAMPLES_PAGE";
        document.MAINFORM.action.value="INIT";
        submitForm();
    }

    function launchVendorInfo(){
        //alert("RFQ");
        document.MAINFORM.activity.value="VIEW_VENDOR_INFO";
        document.MAINFORM.action.value="INIT";
        submitForm();
    }
    ///////////////////////////////////////////////////////////////////////////
    function viewSPL(tabPage){
        if(hasContent(activeSKUId)){
            document.MAINFORM.contextSKUId.value = activeSKUId;
        }
        else{
            document.MAINFORM.contextSKUId.value = '';
        }

        viewProductSeasonLink(activeOid, tabPage);
    }    

    //Added this to keep from having to rewrrite grabbing season id stuff each time. CG
    function getSelectedSeasonId(){
        var seasonList = document.MAINFORM.seasonSelectList;
        var seasonId = (seasonList.options[seasonList.selectedIndex].value);
        return seasonId;
    }
<%if(lcsContext.isVendor){%>
    toggleExpandableDiv('librariesContent', 'librariesContentIcon');
    toggleExpandableDiv('reportsContent', 'reportsContentIcon');
<%}%>

function changeSelectedSeason(id){
	var seasonList = document.MAINFORM.seasonSelectList;
	setSelectedValueOfListFromValue(seasonList, id);
}
</script>

<jsp:include page="<%= subURLFolder + STANDARD_TEMPLATE_FOOTER %>" flush="true">
    <jsp:param name="bodyClass" value="xnavigatorBody" />
</jsp:include>
