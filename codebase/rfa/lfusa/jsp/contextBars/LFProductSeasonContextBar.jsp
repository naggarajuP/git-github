<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>

<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// PAGE DOCUMENTATION/////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%--
      JSP Type: Presentation

--%>

<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ///////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ErrorReport.jsp"
   import=" com.lcs.wc.util.*,
            com.lcs.wc.util.OSHelper,
            com.lcs.wc.client.Activities,
            com.lcs.wc.client.web.*,
            com.lcs.wc.flextype.FlexTypeCache,
            com.lcs.wc.flextype.FlexType,
            com.lcs.wc.resource.ContextBarsRB,
            com.lcs.wc.season.*,
            com.lcs.wc.product.*,
            java.io.*,
            java.util.*,
            wt.util.*,
            wt.util.WTProperties,
            wt.util.WTContext"
%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS //////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<jsp:useBean id="seasonModel" scope="request" class="com.lcs.wc.season.LCSSeasonClientModel" />
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%

String specificationLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "specification_LBL", RB.objA ) ;
String specSummaryLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "specificationConfig_LBL", RB.objA ) ;
String imagesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "images_LBL", RB.objA ) ;
String detailsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "details_LBL", RB.objA ) ;
String summaryLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "summary_LBL", RB.objA ) ;
String documentsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "documents_LBL", RB.objA ) ;
String changesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "changes_LBL", RB.objA ) ;
String processesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "processes_LBL", RB.objA ) ;
String productTestingLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "productTesting_LBL", RB.objA ) ;
String sourcingLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "sourcing_LBL", RB.objA ) ;
String materialsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "materials_LBL", RB.objA ) ;
String laborLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "labor_LBL", RB.objA ) ;
String measurementsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "measurements_LBL", RB.objA ) ;
String constructionLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "construction_LBL", RB.objA ) ;
String samplesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "samples_LBL", RB.objA ) ;
String approvalsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "approvals_LBL", RB.objA ) ;
String productDestinationLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "productDestination_LBL", RB.objA ) ;
String systemLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "system_LBL", RB.objA ) ;
String relationshipsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "relationships_LBL", RB.objA ) ;
/*ITC Added for Build 8 : Product Calendar funcionality : Start */
String calendarLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "calendar_LBL", RB.objA ) ;
/*ITC Added for Build 8 : Product Calendar funcionality : end */
String historyLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "history_LBL", RB.objA ) ;
String productPlanningLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "productPlanning_LBL", RB.objA ) ;
String componentReportLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "componentReport_LBL", RB.objA ) ;
String fitApprovalLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "fitApprovalLabel_LBL", RB.objA ) ;
String materialApprovalLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "materialApprovalLabel_LBL", RB.objA ) ;
String colorApprovalLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "colorApprovalLabel_LBL", RB.objA ) ;
String cadDataLabel = WTMessage.getLocalizedMessage(RB.CONTEXTBARS, "cadData_LBL", RB.objA);
String partsLabel = WTMessage.getLocalizedMessage(RB.CONTEXTBARS, ContextBarsRB.PARTS_LBL, RB.objA);
String costsheetreportLable = WTMessage.getLocalizedMessage ( RB.MAIN, "costsheetReport_LBL", RB.objA ) ;
String sizingLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "sizing_LBL", RB.objA ) ;
String costingLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "costing_LBL", RB.objA ) ;
String rfqLabel = WTMessage.getLocalizedMessage ( RB.RFQ, "rfq_LBL", RB.objA ) ;
String ocLabel = WTMessage.getLocalizedMessage ( RB.ORDERCONFIRMATION, "orderConfirmation_LBL", RB.objA ) ;

%>
<%!
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final StringBuffer createSubTab(String name, String link, boolean active){
        StringBuffer buffer = new StringBuffer();

        buffer.append("<TD class=tabsel noWrap>&nbsp;</TD>");
        if(active) {
            buffer.append("<td nowrap class=\"tabsel\">");            
            buffer.append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" background=\"" + URL_CONTEXT + "/images/sp.gif\" class=\"tab\">");
            buffer.append("<TBODY><TR><TD class=subtabCnr><IMG height=1 src=\"" + URL_CONTEXT + "/images/sp.gif\"></TD><TD class=subtabBdr height=1></TD><TD class=subtabCnr height=1></TD></TR>");
            buffer.append("<TR><TD class=subtabBdr></TD><TD class=subtabBgd noWrap>");
            buffer.append("<A class=subtabTxtsel href=\""+link+"\">"+name+"</A>");
            buffer.append("</TD><TD class=subtabBdr><IMG src=\"" + URL_CONTEXT + "/images/sp.gif\"></TD></TR>");
            buffer.append("<TR><TD class=subtabCnr></TD><TD class=subtabBdr height=1></TD><TD class=subtabCnr height=1></TD></TR>");
            buffer.append("</TBODY></TABLE></td>");
        } else {
             buffer.append("<TD class=tabsel noWrap>&nbsp;</TD><TD class=tabsel noWrap>&nbsp;</TD><TD class=subtabTxtNsel noWrap>");
             buffer.append("<A class=subtabTxtNsel href=\""+link+"\">"+name+"</A></TD>");
        }
        buffer.append("<TD class=tabsel noWrap>&nbsp;</TD>");
        return buffer;
    }

    public static final String SUMMARY_PAGE = "SUMMARY";    
    public static final String PRODUCT_SKU_PAGE = "PRODUCT";
    public static final String CHANGE_ACTIVITIES_PAGE = "CHANGES";
    public static final String PROCESSES_PAGE = "PROCESSES";
    public static final String PRODUCTTESTING_PAGE = "PRODUCTTESTING";
    public static final String SIZING_PAGE = "SIZING";
    public static final String SOURCING_PAGE = "SOURCING";
    public static final String MEASUREMENTS_PAGE = "MEASUREMENTS";
    public static final String PRODUCTDESTINATION_PAGE = "PRODUCTDESTINATION";
    public static final String SYSTEM_PAGE = "SYSTEM";
    public static final String RELATIONS_PAGE = "RELATIONS";
/*ITC Added for Build 8 : Product Calendar funcionality : Start */
	public static final String CALENDAR_PAGE = "CALENDARS";
/*ITC Added for Build 8 : Product Calendar funcionality : End */
    public static final String HISTORY_PAGE = "HISTORY";
    public static final String DOCUMENTS_PAGE = "DOCUMENTS";
    public static final String CONSTRUCTION_PAGE = "CONSTRUCTION";
    public static final String SAMPLES_PAGE = "SAMPLES";
    public static final String TESTING_PAGE = "TESTING";
    public static final String IMAGES_PAGE = "IMAGES";
    public static final String LABOR_PAGE = "LABOR";
    public static final String BOM_PAGE = "BOM";
    public static final String SPEC_SUMMARY_PAGE = "SPEC_SUMMARY";
    public static final String SPEC_COMPONENT_REPORT_PAGE = "SPEC_COMPONENT_REPORT";
    public static final String CAD_DATA_PAGE="CAD_DATA";
    public static final String PARTS_PAGE="PARTS";
    public static final String FIT_APPROVAL_PAGE = "FIT_APPROVAL_PAGE";
    public static final String MATERIAL_APPROVAL_PAGE = "MATERIAL_APPROVAL_PAGE";
    public static final String COLOR_APPROVAL_PAGE = "COLOR_APPROVAL_PAGE";
    //For costsheet report
    public static final String COSTSHEET_REPORT_PAGE = "COSTSHEET";
    public static final String COSTING_PAGE = "COSTING";
    public static final String PRODUCTPLANNING_PAGE = "PRODUCTPLANNING";
    public static final String RFQ_PAGE = "RFQ";
    public static final String OC_PAGE = "ORDERCONFIRMATION";

    public static final boolean USE_BOM = LCSProperties.getBoolean("com.lcs.wc.bom.useBOM");
    public static final boolean USE_BOL = LCSProperties.getBoolean("com.lcs.wc.bom.useBOL");
    public static final boolean USE_CHANGEACTIVITIES = LCSProperties.getBoolean("com.lcs.wc.change.useChangeActivities");
    public static final boolean USE_MEASUREMENTS = LCSProperties.getBoolean("com.lcs.wc.measurements.useMeasurements");
    public static final boolean USE_CONSTRUCTION = LCSProperties.getBoolean("com.lcs.wc.construction.useConstruction");
    public static final boolean USE_SAMPLES = LCSProperties.getBoolean("com.lcs.wc.sample.useSamples");
    public static final boolean USE_TESTING = LCSProperties.getBoolean("com.lcs.wc.testing.useTesting");
    public static final boolean USE_PRODUCTDESTINATIONS = LCSProperties.getBoolean("com.lcs.wc.product.useProductDestinations");
    public static final boolean USE_PRODUCTTESTING = LCSProperties.getBoolean("com.lcs.wc.product.useProductTesting");
    public static final boolean USE_FIT_APPROVAL = LCSProperties.getBoolean("com.lcs.wc.product.useFitApproval");
    public static final boolean USE_MATERIAL_APPROVAL = LCSProperties.getBoolean("com.lcs.wc.product.useMaterialApproval");
    public static final boolean USE_COLOR_APPROVAL = LCSProperties.getBoolean("com.lcs.wc.product.useColorApproval");
    public static final boolean USE_CAD_DATA = LCSProperties.getBoolean("com.lcs.wc.specification.cadData.Enabled");
    public static final boolean USE_PARTS = LCSProperties.getBoolean("com.lcs.wc.specification.parts.Enabled");
  // Added for costsheet report
    public static final boolean USE_COSTSHEET_REPORT = LCSProperties.getBoolean("com.lcs.wc.sourcing.useLCSCostSheet");
    public static final boolean USE_SIZING = LCSProperties.getBoolean("com.lcs.wc.product.useSizing");
    public static final boolean USE_MULTI_COSTING = LCSProperties.getBoolean("com.lcs.wc.sourcing.useLCSMultiCosting");
    public static final boolean USE_SPECIFICATION = true;
	public static final String PRODUCT_PLANNING_ROOT_TYPE = LCSProperties.get("com.lcs.wc.planning.FlexPlan.Product.Root", "Plan\\Product Plan");
	public static final String PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sourcing.OrderConfirmation.Product.Root", "Order Confirmation\\Product");

%>
<%

    String summaryPage = SUMMARY_PAGE;
    if(lcsContext.isVendor){
        summaryPage = PRODUCT_SKU_PAGE;
    }
    boolean showTabs = true;
    LCSSeason season = appContext.getSeason();
    String activity = request.getParameter("activity");
    String tabPage = request.getParameter("tabPage");
    if(!FormatHelper.hasContent(tabPage)){
        if(lcsContext.isVendor){
            tabPage =  PRODUCT_SKU_PAGE;
        }else{
            tabPage =  SUMMARY_PAGE;
        }
    }
	if(lcsContext.isVendor){
		Collection sourcingConfigList = appContext.getSources();
		if(sourcingConfigList.size()==0){
			showTabs = false;
			if(FormatHelper.hasContent(tabPage) && !"RFQ".equals(tabPage)){
				tabPage =  PRODUCT_SKU_PAGE;
			}
		}
	}
    String seasonId = appContext.getSeasonId();
    String seasonName = appContext.getSeasonName();
    LCSProduct prodActiveVersion = appContext.getProductARev();
    FlexType specType = prodActiveVersion.getFlexType().getReferencedFlexType(ReferencedTypeKeys.SPEC_TYPE);
    if(appContext.getProductSeasonRev() != null){
        prodActiveVersion = appContext.getProductSeasonRev();
    }
    String prodActiveId = FormatHelper.getVersionId(prodActiveVersion);
%>
<%
    //Tab Permissions
    boolean summaryTab = true;
    boolean detailsTab = true;
    boolean specificationTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Specification"));
    boolean documentsTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Document"));
    boolean changeTab = USE_CHANGEACTIVITIES && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Change Activity"));
    boolean processTab = true;
    boolean productDestinationTab = USE_PRODUCTDESTINATIONS && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product Destination"));
    boolean sourcingTab = true;
    if(prodActiveVersion != null){
        sourcingTab = prodActiveVersion.getFlexType().getReferencedFlexType(ReferencedTypeKeys.SOURCING_CONFIG_TYPE) != null && ACLHelper.hasViewAccess(prodActiveVersion.getFlexType().getReferencedFlexType(ReferencedTypeKeys.SOURCING_CONFIG_TYPE));
    }
    else{
        sourcingTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sourcing Configuration"));
    }
    boolean bomTab = USE_BOM && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("BOM"));
    boolean laborTab = USE_BOL && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("BOM\\Labor"));
    boolean measurementsTab = USE_MEASUREMENTS && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Measurements"));
    boolean constructionTab = USE_CONSTRUCTION && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Construction"));
    boolean sampleTab = USE_SAMPLES && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample"));
    boolean testingTab = USE_TESTING;
    boolean systemTab = true;
    boolean relationsTab = true;
    boolean historyTab = true;
/*ITC Added for Build 8 : Product Calendar funcionality : Start */
	boolean calendarTab = true;
/*ITC Added for Build 8 : Product Calendar funcionality : End */
	
    boolean imagesTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("Document\\Images Page"));
    boolean fitApprovalTab = USE_FIT_APPROVAL;
    boolean colorApprovalTab = USE_COLOR_APPROVAL;
    boolean materialApprovalTab = USE_MATERIAL_APPROVAL;
    boolean productTestingTab = USE_PRODUCTTESTING && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Test Specification"));
    LCSProduct productRevA = appContext.getProductARev();
    FlexType psdType = productRevA.getFlexType().getReferencedFlexType(ReferencedTypeKeys.SIZING_TYPE);
    boolean sizingTab = USE_SIZING && ACLHelper.hasViewAccess(psdType);
    boolean rfqTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("RFQ"));
    boolean ocTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE));
    boolean productPlanningTab = true;
    productPlanningTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_PLANNING_ROOT_TYPE));
    boolean componentReportTab = true;
    boolean  costsheetreportTab = USE_COSTSHEET_REPORT && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Cost Sheet"));
    boolean cadDataTab = USE_CAD_DATA;
    boolean partsTab = USE_PARTS;
    boolean useSpecification = USE_SPECIFICATION && ACLHelper.hasViewAccess(specType);
    boolean specSummaryTab = useSpecification;
    String SPEC_DEFAULT = SPEC_SUMMARY_PAGE;
    if(!specSummaryTab){
        SPEC_DEFAULT = SPEC_COMPONENT_REPORT_PAGE;
    }
    boolean  costingTab = USE_MULTI_COSTING && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Cost Sheet"));
%>

<script>
    function viewLinePlanTab(){
        document.MAINFORM.activity.value = 'VIEW_LINE_PLAN';
        document.MAINFORM.oid.value = '<%= FormatHelper.getVersionId(season) %>';
        document.MAINFORM.action.value = 'RELOAD';
        document.MAINFORM.returnActivity.value = '';
        document.MAINFORM.tabId.value = '';
        submitForm();
    }
</script>

<%if(showTabs){%>
<tr>
    <td class="contextBar" id="contextBar">
        <table width="100%" cellspacing="0" cellpadding="0">
            <td align="left">
<!--/*ITC Added for Build 8 : Product Calendar funcionality : Start */-->			
            <% if(  SUMMARY_PAGE.equals(tabPage) || 
            		PRODUCT_SKU_PAGE.equals(tabPage)  ||
                    DOCUMENTS_PAGE.equals(tabPage)  ||
                    CHANGE_ACTIVITIES_PAGE.equals(tabPage)  ||
                    PROCESSES_PAGE.equals(tabPage)  ||
                    SYSTEM_PAGE.equals(tabPage)  ||
                    RELATIONS_PAGE.equals(tabPage)  ||
                    HISTORY_PAGE.equals(tabPage) ||
                    PRODUCTPLANNING_PAGE.equals(tabPage)||
					CALENDAR_PAGE.equals(tabPage)
                    ){
            %>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : End */-->			
                <% if(FormatHelper.hasContent(seasonId)) { %>
                <a class="contextBarText" href="javascript:viewLinePlan('<%= seasonId %>', true)"><img src="<%=WT_IMAGE_LOCATION%>/season_m.png" alt="" border="0" align="absmiddle">&nbsp;&nbsp;<%= seasonName %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% } %>
                <!--<a class="contextBarText" href="javascript:viewObject('<%= prodActiveId %>')"><%= appContext.getProductName() %></a>-->
                <a class="contextBarText" href="javascript:changePage('', '<%=summaryPage%>')"><%= appContext.getProductName() %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;

				<% if(SUMMARY_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= summaryLabel %></a>				
                <% } else if(PRODUCT_SKU_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= detailsLabel %></a>
                <% } else if(DOCUMENTS_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= documentsLabel %></a>
                <% } else if(CHANGE_ACTIVITIES_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= changesLabel %></a>
                <% } else if(PROCESSES_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= processesLabel %></a>
                <% } else if(SYSTEM_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= systemLabel %></a>
                <% } else if(RELATIONS_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= relationshipsLabel %></a>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : Start */-->				
                <% } else if(CALENDAR_PAGE.equals(tabPage)&& (!(lcsContext.isVendor))){ %>
                <a class="contextBarText" href="#"><%= calendarLabel %></a>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : End */-->				
                <% } else if(HISTORY_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= historyLabel %></a>
                <% } else if(PRODUCTPLANNING_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= productPlanningLabel %></a>
                <% } %>

            <% } else if(
                    IMAGES_PAGE.equals(tabPage)  ||
                    BOM_PAGE.equals(tabPage)  ||
                    LABOR_PAGE.equals(tabPage)  ||
                    CAD_DATA_PAGE.equals(tabPage) ||
                    PARTS_PAGE.equals(tabPage) ||
                    MEASUREMENTS_PAGE.equals(tabPage)  ||
                    CONSTRUCTION_PAGE.equals(tabPage) ||
                    SPEC_SUMMARY_PAGE.equals(tabPage) ||
                    SIZING_PAGE.equals(tabPage) ||
                    SPEC_COMPONENT_REPORT_PAGE.equals(tabPage)
                    ){
            %>
                <% if(FormatHelper.hasContent(seasonId)) { %>
                <a class="contextBarText" href="javascript:viewLinePlan('<%= seasonId %>', true)"><img src="<%=WT_IMAGE_LOCATION%>/season_m.png" alt="" border="0" align="absmiddle">&nbsp;&nbsp;<%= seasonName %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% } %>
                <!--<a class="contextBarText" href="javascript:viewObject('<%= prodActiveId %>')"><%= appContext.getProductName() %></a>-->
                <a class="contextBarText" href="javascript:changePage('', '<%=summaryPage%>')"><%= appContext.getProductName() %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <a class="contextBarText" href="javascript:changePage('', '<%= SPEC_SUMMARY_PAGE %>')"><%= specificationLabel %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% if(IMAGES_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= imagesLabel %></a>
                <% } else if(SPEC_SUMMARY_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= specSummaryLabel %></a>
                <% } else if(SPEC_COMPONENT_REPORT_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= componentReportLabel %></a>
                <% } else if(BOM_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= materialsLabel %></a>
                <% } else if(CAD_DATA_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= cadDataLabel %></a>                
                <% } else if(PARTS_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= partsLabel %></a>                
                <% } else if(LABOR_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= laborLabel %></a>
                <% } else if(MEASUREMENTS_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= measurementsLabel %></a>
                <% } else if(CONSTRUCTION_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= constructionLabel %></a>
                <% } else if(SIZING_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= sizingLabel %></a>
                <% } %>
            <% } else if(
                    SOURCING_PAGE.equals(tabPage)  ||
                    COSTSHEET_REPORT_PAGE.equals(tabPage) ||
                    PRODUCTDESTINATION_PAGE.equals(tabPage)  ||
                    SAMPLES_PAGE.equals(tabPage) ||
					RFQ_PAGE.equals(tabPage) ||
					OC_PAGE.equals(tabPage) ||
                    COSTING_PAGE.equals(tabPage)

                    ){
            %>
                <% if(FormatHelper.hasContent(seasonId)) { %>
                <a class="contextBarText" href="javascript:viewLinePlan('<%= seasonId %>', true)"><img src="<%=WT_IMAGE_LOCATION%>/season_m.png" alt="" border="0" align="absmiddle">&nbsp;&nbsp;<%= seasonName %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% } %>
                <!--<a class="contextBarText" href="javascript:viewObject('<%= prodActiveId %>')"><%= appContext.getProductName() %></a>-->
                <a class="contextBarText" href="javascript:changePage('', '<%=summaryPage%>')"><%= appContext.getProductName() %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <a class="contextBarText" href="javascript:changePage('', '<%= SOURCING_PAGE %>')"><%= sourcingLabel %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;

                <% if(SOURCING_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= specSummaryLabel %></a>
                <% } else if(COSTING_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= costingLabel %></a>
                <% } else if(PRODUCTDESTINATION_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= productDestinationLabel %></a>
                <% } else if(SAMPLES_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= samplesLabel %></a>
                <% } else if(COSTSHEET_REPORT_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= costsheetreportLable %></a>
                <% } else if(RFQ_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= rfqLabel %></a>
                <% } else if(OC_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= ocLabel %></a>
                <% } %>


            <% } else if(
                    TESTING_PAGE.equals(tabPage)  ||
                    FIT_APPROVAL_PAGE.equals(tabPage) ||
                    MATERIAL_APPROVAL_PAGE.equals(tabPage) ||
                    COLOR_APPROVAL_PAGE.equals(tabPage) ||
                    PRODUCTTESTING_PAGE.equals(tabPage)
                    ){
            %>
                <% if(FormatHelper.hasContent(seasonId)) { %>
                <a class="contextBarText" href="javascript:viewLinePlan('<%= seasonId %>', true)"><img src="<%=WT_IMAGE_LOCATION%>/season_m.png" alt="" border="0" align="absmiddle">&nbsp;&nbsp;<%= seasonName %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% } %>
                <!--<a class="contextBarText" href="javascript:viewObject('<%= prodActiveId %>')"><%= appContext.getProductName() %></a>-->
                <a class="contextBarText" href="javascript:changePage('', '<%=summaryPage%>')"><%= appContext.getProductName() %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <a class="contextBarText" href="javascript:changePage('', '<%= TESTING_PAGE %>')"><%= approvalsLabel %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;

                <% if(TESTING_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= specSummaryLabel %></a>

                <% } else if(FIT_APPROVAL_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= fitApprovalLabel %></a>
                <% } else if(MATERIAL_APPROVAL_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= materialApprovalLabel %></a>
                <% } else if(COLOR_APPROVAL_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= colorApprovalLabel %></a>

                <% } else if(PRODUCTTESTING_PAGE.equals(tabPage)){ %>
                <a class="contextBarText" href="#"><%= productTestingLabel %></a>
                <% } %>

            <% } %>

            <td>
        </table>
    </td>
</tr>
<tr>
    <td class="CONTEXTTABS">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : Start */-->	
            <% if(  SUMMARY_PAGE.equals(tabPage)  ||
            		PRODUCT_SKU_PAGE.equals(tabPage)  ||
                    DOCUMENTS_PAGE.equals(tabPage)  ||
                    CHANGE_ACTIVITIES_PAGE.equals(tabPage)  ||
                    PROCESSES_PAGE.equals(tabPage)  ||
                    SYSTEM_PAGE.equals(tabPage)  ||
                    RELATIONS_PAGE.equals(tabPage)  ||
                    HISTORY_PAGE.equals(tabPage) ||
					PRODUCTPLANNING_PAGE.equals(tabPage) ||
					CALENDAR_PAGE.equals(tabPage)
                    ){
            %>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : End */-->				
                    <% if(summaryTab && !lcsContext.isVendor){ %>
                        <%= createSubTab(summaryLabel,"javascript:changePage('', '" + SUMMARY_PAGE + "')",SUMMARY_PAGE.equals(tabPage)) %>
                    <% } %>
            
                    <% if(detailsTab){ %>
                        <%= createSubTab(detailsLabel,"javascript:changePage('', '" + PRODUCT_SKU_PAGE + "')",PRODUCT_SKU_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(specificationTab){ %>
                        <%= createSubTab(specificationLabel,"javascript:changePage('', '" + SPEC_DEFAULT + "')",SPEC_DEFAULT.equals(tabPage)) %>
                    <% } %>
                    <% if(sourcingTab){ %>
                        <%= createSubTab(sourcingLabel,"javascript:changePage('', '" + SOURCING_PAGE + "')",SOURCING_PAGE.equals(tabPage)) %>
                    <% } %>


                    <% if(productPlanningTab){ %>
                        <%= createSubTab(productPlanningLabel,"javascript:changePage('', '" + PRODUCTPLANNING_PAGE + "')",PRODUCTPLANNING_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(testingTab){ %>
                        <%= createSubTab(approvalsLabel,"javascript:changePage('', '" + TESTING_PAGE + "')",TESTING_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(documentsTab){ %>
                        <%= createSubTab(documentsLabel,"javascript:changePage('', '" + DOCUMENTS_PAGE + "')",DOCUMENTS_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(processTab){ %>
                        <%= createSubTab(processesLabel,"javascript:changePage('', '" + PROCESSES_PAGE + "')",PROCESSES_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(changeTab){ %>
                        <%= createSubTab(changesLabel,"javascript:changePage('', '" + CHANGE_ACTIVITIES_PAGE + "')",CHANGE_ACTIVITIES_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(historyTab){ %>
                        <%= createSubTab(historyLabel,"javascript:changePage('', '" + HISTORY_PAGE + "')",HISTORY_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(relationsTab){ %>
                        <%= createSubTab(relationshipsLabel,"javascript:changePage('', '" + RELATIONS_PAGE + "')",RELATIONS_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(systemTab){ %>
                        <%= createSubTab(systemLabel,"javascript:changePage('', '" + SYSTEM_PAGE + "')",SYSTEM_PAGE.equals(tabPage)) %>
                    <% } %>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : Start */-->	
                    <% if(calendarTab&& (!(lcsContext.isVendor))){ %>
                        <%= createSubTab(calendarLabel,"javascript:changePage('', '" + CALENDAR_PAGE + "')",CALENDAR_PAGE.equals(tabPage)) %>
                    <% } %>
<!--/*ITC Added for Build 8 : Product Calendar funcionality : End */-->	
            <% } else if(
                    IMAGES_PAGE.equals(tabPage)  ||
                    BOM_PAGE.equals(tabPage)  ||
                    CAD_DATA_PAGE.equals(tabPage) ||
                    PARTS_PAGE.equals(tabPage) ||
                    SIZING_PAGE.equals(tabPage)  ||
                    
                    LABOR_PAGE.equals(tabPage)  ||
                    MEASUREMENTS_PAGE.equals(tabPage)  ||
                    CONSTRUCTION_PAGE.equals(tabPage) ||
                    SPEC_SUMMARY_PAGE.equals(tabPage) ||
                    SPEC_COMPONENT_REPORT_PAGE.equals(tabPage)
                    ){
            %>


                    <% if(specSummaryTab){ %>
                        <%= createSubTab(specSummaryLabel,"javascript:changePage('', '" + SPEC_SUMMARY_PAGE + "')", SPEC_SUMMARY_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(imagesTab){ %>
                        <%= createSubTab(imagesLabel,"javascript:changePage('', '" + IMAGES_PAGE + "')",IMAGES_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(bomTab){ %>
                        <%= createSubTab(materialsLabel,"javascript:changePage('', '" + BOM_PAGE + "')",BOM_PAGE.equals(tabPage)) %>
                    <% } %>
                    
                     <% if(cadDataTab){ %>
                        <%= createSubTab(cadDataLabel,"javascript:changePage('', '" + CAD_DATA_PAGE + "')",CAD_DATA_PAGE.equals(tabPage)) %>
                    <% } %>
                    
                     <% if(partsTab){ %>
                        <%= createSubTab(partsLabel,"javascript:changePage('', '" + PARTS_PAGE + "')",PARTS_PAGE.equals(tabPage)) %>
                    <% } %>
                    
                    <% if(laborTab){ %>
                        <%= createSubTab(laborLabel,"javascript:changePage('', '" + LABOR_PAGE + "')",LABOR_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(sizingTab){ %>
                        <%= createSubTab(sizingLabel,"javascript:changePage('', '" + SIZING_PAGE + "')",SIZING_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(measurementsTab){ %>
                        <%= createSubTab(measurementsLabel,"javascript:changePage('', '" + MEASUREMENTS_PAGE + "')",MEASUREMENTS_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(constructionTab){ %>
                        <%= createSubTab(constructionLabel,"javascript:changePage('', '" + CONSTRUCTION_PAGE + "')",CONSTRUCTION_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(componentReportTab){ %>
                        <%= createSubTab(componentReportLabel,"javascript:changePage('', '" + SPEC_COMPONENT_REPORT_PAGE + "')",SPEC_COMPONENT_REPORT_PAGE.equals(tabPage)) %>
                    <% } %>             
              
            <% } else if(
                    SOURCING_PAGE.equals(tabPage)  ||
                    /////////////// ADD HERE
                    COSTSHEET_REPORT_PAGE.equals(tabPage) ||
                    SAMPLES_PAGE.equals(tabPage)  ||
					RFQ_PAGE.equals(tabPage)  ||
					OC_PAGE.equals(tabPage)  ||
                    PRODUCTDESTINATION_PAGE.equals(tabPage) ||
                    COSTING_PAGE.equals(tabPage)
                    ){
            %>
                    <% if(sourcingTab){ %>
                        <%= createSubTab(specSummaryLabel,"javascript:changePage('', '" + SOURCING_PAGE + "')",SOURCING_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(costingTab)  { %>
                        <%= createSubTab(costingLabel,"javascript:changePage('', '" + COSTING_PAGE + "')",COSTING_PAGE.equals(tabPage)) %>
                    <% } %>
					 <% if(rfqTab){ %>
                        <%= createSubTab(rfqLabel,"javascript:changePage('', '" + RFQ_PAGE + "')",RFQ_PAGE.equals(tabPage)) %>
                    <% } %>
					 <% if(ocTab){ %>
                        <%= createSubTab(ocLabel,"javascript:changePage('', '" + OC_PAGE + "')",OC_PAGE.equals(tabPage)) %>
                    <% } %>
					<% if(productDestinationTab){ %>
                        <%= createSubTab(productDestinationLabel,"javascript:changePage('', '" + PRODUCTDESTINATION_PAGE + "')",PRODUCTDESTINATION_PAGE.equals(tabPage)) %>
                    <% } %>
        

                    <% if(sampleTab){ %>
                        <%= createSubTab(samplesLabel,"javascript:changePage('', '" + SAMPLES_PAGE + "')",SAMPLES_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(costsheetreportTab)  { %>
                        <%= createSubTab(costsheetreportLable,"javascript:changePage('', '" + COSTSHEET_REPORT_PAGE + "')",COSTSHEET_REPORT_PAGE.equals(tabPage)) %>
                    <% } %>
					
            <% } else if(
                    TESTING_PAGE.equals(tabPage)  ||
                    FIT_APPROVAL_PAGE.equals(tabPage) ||
                    MATERIAL_APPROVAL_PAGE.equals(tabPage) ||
                    COLOR_APPROVAL_PAGE.equals(tabPage) ||
                    PRODUCTTESTING_PAGE.equals(tabPage)
                    ){
            %>
                    <% if(testingTab){ %>
                        <%= createSubTab(specSummaryLabel,"javascript:changePage('', '" + TESTING_PAGE + "')",TESTING_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(fitApprovalTab){ %>
                        <%= createSubTab(fitApprovalLabel,"javascript:changePage('', '" + FIT_APPROVAL_PAGE + "')",FIT_APPROVAL_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(colorApprovalTab){ %>
                        <%= createSubTab(colorApprovalLabel,"javascript:changePage('', '" + COLOR_APPROVAL_PAGE + "')",COLOR_APPROVAL_PAGE.equals(tabPage)) %>
                    <% } %>
                    <% if(materialApprovalTab){ %>
                        <%= createSubTab(materialApprovalLabel,"javascript:changePage('', '" + MATERIAL_APPROVAL_PAGE + "')",MATERIAL_APPROVAL_PAGE.equals(tabPage)) %>
                    <% } %>

                    <% if(productTestingTab){ %>
                        <%= createSubTab(productTestingLabel,"javascript:changePage('', '" + PRODUCTTESTING_PAGE + "')",PRODUCTTESTING_PAGE.equals(tabPage)) %>
                    <% } %>
            <% } %>
            </tr>
        </table>
   </td>
</tr>

<%}else{%>
<tr>
    <td class="contextBar" id="contextBar">
        <table width="100%" cellspacing="0" cellpadding="0">
		     <tr>
			   <td>
			     &nbsp;
			   </td>
             </tr>
        </table>
    </td>
</tr>

<tr>
	<td class="CONTEXTTABS">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
                    <% if(detailsTab){ %>
                        <%= createSubTab(detailsLabel,"javascript:changePage('', '" + PRODUCT_SKU_PAGE + "')",PRODUCT_SKU_PAGE.equals(tabPage)) %>
                    <% } %>
			  <%= createSubTab(rfqLabel,"javascript:changePage('', '" + RFQ_PAGE + "')",RFQ_PAGE.equals(tabPage)) %>
			</tr>
		 </table>
	</td>
</tr>
<%}%>