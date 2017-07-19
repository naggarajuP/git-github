<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ///////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ErrorReport.jsp"
    import=" com.lcs.wc.util.*,
            com.lcs.wc.util.OSHelper,
            com.lcs.wc.client.Activities,
            com.lcs.wc.client.web.*,
            com.lcs.wc.flextype.*,
            com.lcs.wc.db.*,
            com.lcs.wc.flexbom.*,
            com.lcs.wc.material.*,
            com.lcs.wc.measurements.*,
            com.lcs.wc.document.*,
            com.lcs.wc.specification.*,
            com.lcs.wc.construction.*,
            com.lcs.wc.resource.ContextBarsRB,
            com.lcs.wc.season.*,
            com.lcs.wc.sourcing.*,
            com.lcs.wc.foundation.*,
            com.lcs.wc.product.*,
			com.lcs.wc.sizing.*,
			com.lcs.wc.changeAudit.*,
            java.io.*,
            java.util.*,
            wt.util.*,
            wt.fc.*,            
            wt.part.*"
%><%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS //////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="flexg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>
<% wt.util.WTContext.getContext().setLocale(request.getLocale());%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE /////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%!
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    private static final boolean DEBUG = LCSProperties.getBoolean("jsp.main.ProductNavigator.verbose");
    private static final String JSPNAME = "SideBarProductNavigator";
    public static final boolean USE_PLACEHOLDERS = LCSProperties.getBoolean("com.lcs.wc.placeholder.usePlaceholders");

    public static final boolean USE_BOM = LCSProperties.getBoolean("com.lcs.wc.bom.useBOM");
    public static final boolean USE_BOL = LCSProperties.getBoolean("com.lcs.wc.bom.useBOL");
    public static final boolean USE_COST_SHEET = LCSProperties.getBoolean("com.lcs.wc.sourcing.useLCSCostSheet");
    public static final boolean USE_CHANGEACTIVITIES = LCSProperties.getBoolean("com.lcs.wc.change.useChangeActivities");
    public static final boolean USE_MEASUREMENTS = LCSProperties.getBoolean("com.lcs.wc.measurements.useMeasurements");
    public static final boolean USE_CONSTRUCTION = LCSProperties.getBoolean("com.lcs.wc.construction.useConstruction");
    public static final boolean USE_CAD_DATA = LCSProperties.getBoolean("com.lcs.wc.specification.cadData.Enabled");
    public static final boolean USE_PARTS = LCSProperties.getBoolean("com.lcs.wc.specification.parts.Enabled");
    public static final boolean USE_SAMPLES = LCSProperties.getBoolean("com.lcs.wc.sample.useSamples");
    public static final boolean USE_TESTING = LCSProperties.getBoolean("com.lcs.wc.testing.useTesting");
    public static final boolean USE_SILHOUETTES = LCSProperties.getBoolean("com.lcs.wc.season.useSilhouettes");
    public static final boolean USE_INSPIRATIONS = LCSProperties.getBoolean("com.lcs.wc.season.useInspirations");
    public static final boolean USE_MAT_TESTING = LCSProperties.getBoolean("com.lcs.wc.material.useTesting");
    public static final boolean USE_MAT_PRICING = LCSProperties.getBoolean("com.lcs.wc.material.usePricing");
    public static final boolean USE_PRODUCTDESTINATIONS = LCSProperties.getBoolean("com.lcs.wc.product.useProductDestinations");
    public static final boolean USE_PRODUCTTESTING = LCSProperties.getBoolean("com.lcs.wc.product.useProductTesting");
    public static final boolean USE_FIT_APPROVAL = LCSProperties.getBoolean("com.lcs.wc.product.useFitApproval");
    public static final boolean USE_MATERIAL_APPROVAL = LCSProperties.getBoolean("com.lcs.wc.product.useMaterialApproval");
    public static final boolean USE_COLOR_APPROVAL = LCSProperties.getBoolean("com.lcs.wc.product.useColorApproval");
    public static final boolean USE_SIZING = LCSProperties.getBoolean("com.lcs.wc.product.useSizing");
    public static final boolean USE_SPECIFICATION = true;
    public static final boolean USE_MULTI_COSTING = LCSProperties.getBoolean("com.lcs.wc.sourcing.useLCSMultiCosting");
    public static final boolean EXPAND_TRACKED_CHANGES = LCSProperties.getBoolean("jsp.main.SideMenu.expandTrackedChanges");
    public static final String PRODUCT_PLANNING_ROOT_TYPE = LCSProperties.get("com.lcs.wc.planning.FlexPlan.Product.Root", "Plan\\Product Plan");	
    public static final String CHANGEAUDITEVENTS_NAVBAR_MAXHEIGHT = LCSProperties.get("changeauditevents.navbar.maxheight", "200");
    public static final boolean DOCUMENT_VERSION_CONTROL=LCSProperties.getBoolean("com.lcs.wc.document.LCSDocument.revise");

    public static String getUrl = "";
    public static String WindchillContext = "/Windchill";
	public static final String PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sourcing.OrderConfirmation.Product.Root", "Order Confirmation\\Product");

    static
    {
        try
        {
            WTProperties wtproperties = WTProperties.getLocalProperties();
            getUrl = wtproperties.getProperty("wt.server.codebase","");
            WindchillContext = "/" + wtproperties.getProperty("wt.webapp.name");

        } catch(Exception e){
            e.printStackTrace();
        }
   }
    
    
%>
<%
	// LOCALIZED LABELS
	String parentLinkLabel = WTMessage.getLocalizedMessage ( RB.PRODUCT, "parentLink_LBL", RB.objA ) ;
	String childLinkLabel = WTMessage.getLocalizedMessage ( RB.PRODUCT, "childLink_LBL", RB.objA ) ;
	String siblingLinkLabel = WTMessage.getLocalizedMessage ( RB.PRODUCT, "sibling_LBL", RB.objA ) ;
	String roleNoneLabel = WTMessage.getLocalizedMessage ( RB.PRODUCT, "roleNone_LBL", RB.objA ) ;
//	String existingLinkLabel = WTMessage.getLocalizedMessage ( RB.PRODUCT, "createLinkExistingProduct_BTN", RB.objA ) ;
//	String createLinkLabel = WTMessage.getLocalizedMessage ( RB.PRODUCT, "createNewLinkedProduct_BTN", RB.objA ) ;
    String placeholderLabel = WTMessage.getLocalizedMessage ( RB.PLACEHOLDER, "placeholder_LBL", RB.objA ) ;
	String sizeRangeLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sizeRange_LBL", RB.objA ) ;
	String seasonLabel      = WTMessage.getLocalizedMessage ( RB.SEASON, "season_LBL", RB.objA ) ;
    String documents_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "documents_LBL", RB.objA ) ;	
    String specs_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "specs_LBL", RB.objA ) ;
    String colorways_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "colorways_LBL", RB.objA ) ;
    String sizecategories_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "sizecategories_LBL", RB.objA ) ;
    String destinations_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "destinations_LBL", RB.objA ) ;
    String sources_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "sources_LBL", RB.objA ) ;
    String boms_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "boms_LBL", RB.objA ) ;
    String construction_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "construction_LBL", RB.objA ) ;    
    String linkedProduct_LBL = WTMessage.getLocalizedMessage ( RB.PRODUCT, "linkedProduct_LBL", RB.objA ) ;    
    String actions_lbl = WTMessage.getLocalizedMessage( RB.MAIN, "actions2_LBL", RB.objA ) ;
    String objects_lbl =  WTMessage.getLocalizedMessage( RB.PRODUCT, "objects_LBL", RB.objA ) ;    
    String quickLinks_lbl =  WTMessage.getLocalizedMessage( RB.PRODUCT, "quickLinks_LBL", RB.objA ) ;    
    String keyInformation_lbl = WTMessage.getLocalizedMessage( RB.PRODUCT, "keyInformation_LBL", RB.objA ) ;    
    String specificationLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "specification_LBL", RB.objA ) ;
    String specSummaryLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "specificationConfig_LBL", RB.objA ) ;
    String imagesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "images_LBL", RB.objA ) ;
    String detailsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "details_LBL", RB.objA ) ;
    String summaryLabel =WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "summary_LBL", RB.objA ) ;
    String documentsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "documents_LBL", RB.objA ) ;
    String describedByDocumentsLabel=WTMessage.getLocalizedMessage ( RB.MAIN, "describedByDocuments_LBL", RB.objA );
    String referenceDocumentsLabel=WTMessage.getLocalizedMessage ( RB.MAIN, "referenceDocuments_LBL", RB.objA );
    String changesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "changes_LBL", RB.objA ) ;
    String processesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "processes_LBL", RB.objA ) ;
    String productTestingLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "productTesting_LBL", RB.objA ) ;
    String sourcingLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "sourcing_LBL", RB.objA ) ;
    String materialsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "materials_LBL", RB.objA ) ;
    String laborLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "labor_LBL", RB.objA ) ;
    String measurementsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "measurements_LBL", RB.objA ) ;
    String constructionLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "construction_LBL", RB.objA ) ;
    String cadDataLabel = WTMessage.getLocalizedMessage(RB.CONTEXTBARS, "cadData_LBL", RB.objA);
    String partsLabel = WTMessage.getLocalizedMessage(RB.CONTEXTBARS, ContextBarsRB.PARTS_LBL, RB.objA);
    String samplesLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "samples_LBL", RB.objA ) ;
    String approvalsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "approvals_LBL", RB.objA ) ;
    String productDestinationLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "productDestination_LBL", RB.objA ) ;
    String systemLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "system_LBL", RB.objA ) ;
    String relationshipsLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "relationships_LBL", RB.objA ) ;
    String historyLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "history_LBL", RB.objA ) ;

    String componentReportLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "componentReport_LBL", RB.objA ) ;
    String fitApprovalLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "fitApprovalLabel_LBL", RB.objA ) ;
    String materialApprovalLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "materialApprovalLabel_LBL", RB.objA ) ;
    String colorApprovalLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "colorApprovalLabel_LBL", RB.objA ) ;
    String costsheetreportLable = WTMessage.getLocalizedMessage ( RB.MAIN, "costsheetReport_LBL", RB.objA ) ;
    String sizingLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "sizing_LBL", RB.objA ) ;
    String costingLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "costing_LBL", RB.objA ) ;
    
    String dateCreatedLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "dateCreated_LBL", RB.objA ) ;
    String createdByLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "createdBy_LBL", RB.objA ) ;
    String lastUpdatedLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "lastUpdated_LBL", RB.objA ) ;
    String lastUpdatedByLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "lastUpdatedBy_LBL", RB.objA ) ;
    String locationLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "location_LBL", RB.objA ) ;
    String lifeCycleStateLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "lifeCycleState_LBL", RB.objA ) ;
    String typeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "type_LBL", RB.objA ) ;    
	String productPlanningLabel = WTMessage.getLocalizedMessage ( RB.CONTEXTBARS, "productPlanning_LBL", RB.objA ) ;
	String rfqLabel = WTMessage.getLocalizedMessage ( RB.RFQ, "rfq_LBL", RB.objA ) ;
	String ocLabel = WTMessage.getLocalizedMessage ( RB.ORDERCONFIRMATION, "orderConfirmation_LBL", RB.objA ) ;
	String trackedChangesLabel = WTMessage.getLocalizedMessage ( RB.EVENTS, "latestTrackedChanges_LBL", RB.objA ) ;
  String calendarLabel = "Calendar";

    String oid = java.net.URLDecoder.decode(request.getParameter("oid"), defaultCharsetEncoding);
    if(DEBUG)System.out.println(JSPNAME +": oid= " + oid);
    String quickNavTab = FormatHelper.format(request.getParameter("quickNavTab"));
    if(DEBUG)System.out.println(JSPNAME +": quickNavTab= " + quickNavTab);


    // REPLACE WITH FLEXTYPEDINFO
    
    // LOCATE THE SEASON OBJECT. NEEDED FOR
    // GETTING ACCURATE SKU, SOURCE, AND SPEC LISTS.
    // WILL BE NULL OF PRODUCT IS A REV.

    appContext.setProductContext(oid);    
    LCSProduct product = appContext.getProductSeasonRev();
    LCSProduct productARev = appContext.getProductARev();
    if(product == null){
    	product = productARev;
    }
    LCSProduct productSeasonRev = appContext.getProductSeasonRev();
    LCSSeasonProductLink productSeasonLink = appContext.getProductLink();
    LCSSeason season = appContext.getSeason();


    
    
    // FIND LIST OF SEASONS AND PRODUCT REV IDS
    PreparedQueryStatement statement = (new ProductHeaderQuery()).findSeasonsForProductQuery(productARev, false);
    
	SearchResults seasonResults = LCSQuery.runDirectQuery(statement);
    String seasonName = FlexTypeCache.getFlexTypeRoot("Season").getAttribute("seasonName").getVariableName(); 
    String seasonNameColumn = IntrospectionHelper.getTable(LCSSeason.class )+"." + seasonName;
    String prodSeasonRevId = IntrospectionHelper.getTableAndColumn(LCSSeasonProductLink.class, "productSeasonRevId");
    
    Map seasonMap = LCSQuery.createTableList(seasonResults, prodSeasonRevId, seasonNameColumn, "VR:com.lcs.wc.product.LCSProduct:", FormatHelper.STRING_FORMAT);
    seasonMap.put(FormatHelper.getVersionId(productARev), WTMessage.getLocalizedMessage ( RB.SEASON, "noneSelected_LBL", RB.objA ) );
    

    boolean skusTab = true;
    boolean specificationTab = true;
    boolean useSpecification = true;
    boolean specSummaryTab = true;
    boolean imagesTab = false;
    boolean bomTab = false;
    boolean laborTab = false;
    boolean measurementsTab = false;
    boolean constructionTab = false;
    boolean cadDataTab = false;
    boolean partsTab = false;
    boolean documentsTab = false;
    boolean processTab = true;
    boolean sourcingTab = true;
    boolean sampleTab = false;
    boolean testingTab = false;
    boolean changeTab = false;
    boolean historyTab = true;
    boolean systemTab = true;
    boolean relationsTab = true;
    boolean destinationsTab = true;
    boolean productTesting = true;
    boolean fitApproval = true;
    boolean colorApproval = true;
    boolean materialApproval = true;
    boolean componentReportTab = true;
    // for CostSheet Compare Report
    boolean costsheetreportTab = true;
    boolean sizingTab = true;
    boolean costingTab = true;
	boolean rfqTab = true;
	boolean ocTab = true;


    useSpecification = USE_SPECIFICATION && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Specification"));
    specSummaryTab = useSpecification;
    imagesTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("Document\\Images Page"));
    bomTab = USE_BOM && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("BOM"));
    laborTab = USE_BOL && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("BOM\\Labor"));
    measurementsTab = USE_MEASUREMENTS && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Measurements"));
    constructionTab = USE_CONSTRUCTION && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Construction"));
    cadDataTab = USE_CAD_DATA;
    partsTab = USE_PARTS;
    documentsTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Document"));

    // SHOULD BE LOOKING AT PRODUCT TYPES ASSOCIATED SOURCE TYPE
    sourcingTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sourcing Configuration"));
    changeTab = USE_CHANGEACTIVITIES && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Change Activity"));
    sampleTab = USE_SAMPLES && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample"));
    testingTab = USE_TESTING;
    destinationsTab = USE_PRODUCTDESTINATIONS && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product Destination"));
    productTesting = USE_PRODUCTTESTING && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Test Specification"));
    fitApproval = USE_FIT_APPROVAL;
    colorApproval = USE_COLOR_APPROVAL;
    materialApproval = USE_MATERIAL_APPROVAL;
    LCSProduct productRevA = appContext.getProductARev();
    FlexType psdType = productRevA.getFlexType().getReferencedFlexType(ReferencedTypeKeys.SIZING_TYPE);
    sizingTab = USE_SIZING && ACLHelper.hasViewAccess(psdType);
    costingTab = USE_COST_SHEET &&USE_MULTI_COSTING && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Cost Sheet"));
    costsheetreportTab = USE_COST_SHEET && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Cost Sheet"));
    
    boolean productPlanningTab = true;
    productPlanningTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_PLANNING_ROOT_TYPE));

    rfqTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("RFQ"));
    ocTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE));


	boolean showQuickLinks = true;
    if(lcsContext.isVendor){
		Collection sourcingConfigList = appContext.getSources();
		if(sourcingConfigList.size()==0){
			showQuickLinks = false;
		}
	}
   
	
%>
<script>
document.SEASON_PRODUCT_PAGE = new Object();
document.SEASON_PRODUCT_PAGE.prodActiveId = '<%= appContext.getActiveProductId() %>';
document.SEASON_PRODUCT_PAGE.productMasterId = '<%= appContext.getProductMasterId() %>';
document.SEASON_PRODUCT_PAGE.hasSeason = <%= (season != null)%>;
document.SEASON_PRODUCT_PAGE.productSeasonId = '<%= appContext.getActiveProductId() %>';
document.SEASON_PRODUCT_PAGE.seasonVersionId = '<%= FormatHelper.format(appContext.getSeasonId()) %>';
<% if(appContext.getSourcingConfig() != null){%>
document.SEASON_PRODUCT_PAGE.sourcingConfigVersionId = '<%= FormatHelper.getVersionId(appContext.getSourcingConfig()) %>';
document.SEASON_PRODUCT_PAGE.sourcingConfigMasterObjectId = '<%= FormatHelper.getObjectId((LCSSourcingConfigMaster)appContext.getSourcingConfig().getMaster()) %>';
<%}else{%>
document.SEASON_PRODUCT_PAGE.sourcingConfigVersionId = '';
document.SEASON_PRODUCT_PAGE.sourcingConfigMasterObjectId = '';
<%}%>

document.APP_CONTEXT = new Object();
document.APP_CONTEXT.activeProductId ='<%= appContext.getActiveProductId() %>';
document.APP_CONTEXT.productARevId='<%= appContext.getProductARevId() %>';
document.APP_CONTEXT.skuARevId='<%= appContext.getSKUARevId() %>';
document.APP_CONTEXT.seasonId='<%= appContext.getSeasonId() %>';
document.APP_CONTEXT.productLinkId='<%=appContext.getProductLinkId() %>';
document.APP_CONTEXT.placeholderId='<%=appContext.getPlaceholderId()%>';
document.SEASON_HEADER = new Object();
document.SEASON_HEADER.seasonVId =  '<%= FormatHelper.getVersionId(season) %>';
<%if(season == null){%>
document.SEASON_HEADER.seasonMasterId = '';
<%}else{%>
document.SEASON_HEADER.seasonMasterId = '<%= FormatHelper.getObjectId((WTObject)season.getMaster())%>';
<%}%>

</script>
<div class="HEADING1" style="padding-left:10px;padding-top:10px;padding-bottom:5px;line-height:95%;">
<%if(!lcsContext.isVendor){%>
<a href="javascript:window.parent.contentframe.loadProductNavigator('<%= FormatHelper.getVersionId(product) %>')"><%= productARev.getValue("productName") %></a>
<% } else { %>
<%= productARev.getValue("productName") %>
<% } %>
</div>
<%
String dateStr = request.getParameter("globalChangeTrackingSinceDate");
Date sinceDate = FormatHelper.parseDate(dateStr.trim()); 
Collection<ChangeAuditEvent> auditEvents = Collections.EMPTY_LIST;
auditEvents = ChangeAuditQuery.getLatestChangeAuditEvents((WTPartMaster)productRevA.getMaster(),null,sinceDate);

String style = null;
String image = WT_IMAGE_LOCATION +"/expand_tree.png";
if(EXPAND_TRACKED_CHANGES&&auditEvents.size()>0){
	 style = "style=\"display:block;\"";
}else{
	 style = "style=\"display:none;\"";
	 image = WT_IMAGE_LOCATION +"/collapse_tree.png";
}

String trackedChangeContentDetailStyle ="style=\"max-height:" + CHANGEAUDITEVENTS_NAVBAR_MAXHEIGHT + "px;overflow-y:auto;height:expression(this.offsetHeight > CHANGEAUDITEVENTS_NAVBAR_MAXHEIGHT? CHANGEAUDITEVENTS_NAVBAR_MAXHEIGHT + 'px': this.offsetHeight+'px' );\"";
%>

<input type="hidden" id="cancelBackInfo" name="cancelBackInfo" value=""> 

    <div class='BlueBox'>
        <div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
        <div class='BoxContent'>
                <div style='overflow:hidden'>
                    <table width='90%' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td class='BlueHeader' style='padding-left:10px;'>
                                <a href="javascript:toggleExpandableDiv('trackedChangeContent', 'trackedChangeContentIcon');"><span style='padding-right:4px'><img id='trackedChangeContentIcon' valign="bottom" src='<%= image %>' border='0'></span><%=trackedChangesLabel %></a>
                                <%if(!auditEvents.isEmpty()){ %>
                                <img id='hasChanges' src='<%=WT_IMAGE_LOCATION%>/details.gif'>
                                <%} %>
                           </td>
                           <td class="LABEL">

                           </td>
                       </tr>
                    </table>

                </div>
              <div class='BlueBody' id='trackedChangeContent' <%=style%>>
               	<div class='BlueBox'>
                        <div class='BlueBoxHeader'>
                        </div>
                        <div class='BoxContent' style='overflow:hidden'>
                        	<div id='trackedChangeContentDetail' <%=trackedChangeContentDetailStyle %>>
		                        <table>
		                       <% 
								for(ChangeAuditEvent evt:auditEvents) {
										if(ChangeAuditLogic.hasViewPermission(evt)){
										%>
										<tr><td class='DISPLAYTEXT'><%=ChangeEventMessageHelper.getDisplayMessage(evt)%></td></tr>
										<tr><td></td></tr>
										<%
										}
									}
								%>
								</table>
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

<%if(!lcsContext.isVendor){ %>
    <div class='BlueBox'>
        <div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
        <div class='BoxContent'>
                <div style='overflow:hidden'>
                    <table width='90%' cellspacing='0' cellpadding='0'>
                        <tr>
                            <td class='BlueHeader' style='padding-left:10px;'>
                                <a href="javascript:toggleExpandableDiv('prodNavContent', 'prodNavContentIcon');"><span style='padding-right:4px'><img id='prodNavContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/expand_tree.png' border='0'></span><%=objects_lbl %></a>
                           </td>
                           <td class="LABEL">

                           </td>
                       </tr>
                    </table>

                </div>
              <div class='BlueBody' id='prodNavContent'>
                    <div class='BlueBox'>
                        <div class='BlueBoxHeader'>
                        </div>
                        <div class='BoxContent'  style='overflow:hidden'>
							<div style='padding-left:10px;padding-bottom:5px;'>
								<table width="90%" border="0" cellspacing="2" cellpadding="1">
								  <tr>
									<td>
									<a id="prodsidebar_P_<%= FormatHelper.getNumericVersionIdFromObject(product) %>" href="javascript:getActionsMenu('P_<%= FormatHelper.getNumericVersionIdFromObject(product) %>', 'PRODUCT', '', 'prodsidebar_')" class="actions_link"><%= actions_lbl %></a> &nbsp;&nbsp;
									<a onClick="openNewProductWindow('<%= FormatHelper.getVersionId(product) %>');"><img src='<%= WT_IMAGE_LOCATION %>/new_window.png'></a>
									</td>								
								   </tr>
								   <tr>
									<td>
									<% if(season != null){ %>
									<a id="ac_<%= FormatHelper.getVersionId(season) %>" href="javascript:getActionsMenu('<%= FormatHelper.getVersionId(season) %>', '', '', '')" class="actions_link">
									<%= seasonLabel %>:  
									</a>
									<% } else { %>
									<%= seasonLabel %>:
									<% } %>
								   </td>
								   </tr>
								   <tr>
									<td>
									<%= new FormGenerator().createDropDownList(seasonMap, "seasonList", FormatHelper.getVersionId(productSeasonRev), "setActiveProductFromSeasonList(this.options[this.selectedIndex].value)", 1, false) %>
									</td>
								   </tr>
								</table>
							</div>

                            <table width="90%" border="0" cellspacing="1" cellpadding="1">
                                <%
                                if(skusTab){
                                    Map skuMap = appContext.getSKUsMap();
                                    
                                    String skuid = null;
                                    String skuname = null;
                                    
                                    Map skuNameMap = CollectionUtil.reverseMap(skuMap);
                                    Collection nameSet = skuNameMap.keySet();
                                    nameSet = SortHelper.sortStrings(nameSet);
                                    Iterator skuIdIter = nameSet.iterator();
                                    %>
	                                <tr>
	                                    <td>
                                        <a class='LABEL' href="javascript:toggleExpandableDiv('colorsContent', 'colorsContentIcon');"><span style='padding-right:4px'><img id='colorsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= colorways_LBL %> (<%= skuMap.size() %>)</a><br>
                                        <div id="colorsContent" style="display:none;padding-left:20;padding-top:5px;">
                                        <%

                                        while(skuIdIter.hasNext()){
                                        	skuname = (String) skuIdIter.next();
                                        	skuid = (String) skuNameMap.get(skuname);
                                            %>
                                            <a id="ac_<%= skuid %>" href="javascript:getActionsMenuWithActiveProductId('<%= skuid %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(skuname) %></a><br>
                                            <%
                                        }
                                        %>
                                        </div>
	                                    </td>
	                                </tr>
	                            <%
	                            }
                                if(imagesTab){
	                               LCSProductQuery prodQuery = new LCSProductQuery();
	                               Collection prodImagePages = prodQuery.findImagePages(product, null, null, true);
	                               prodImagePages = CollectionUtil.distinctResults(prodImagePages, "LCSDOCUMENT.BRANCHIDITERATIONINFO");
	                               FlexType imagePageRootType = FlexTypeCache.getFlexTypeFromPath("Document\\Images Page");
	                               prodImagePages = SortHelper.sortFlexObjects(prodImagePages, imagePageRootType.getAttribute("name").getSearchResultIndex());	                               
	                               %>
	                               <tr>
	                                   <td>		                               
		                               <a class='LABEL' href="javascript:toggleExpandableDiv('imagePageContent', 'imagePageContentIcon');"><span style='padding-right:4px'><img id='imagePageContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%=imagesLabel %> (<%= prodImagePages.size() %>)</a><br>
		                               <div id="imagePageContent" style="display:none;padding-left:20;padding-top:5px;">
		                               <%
		                               Iterator imagePageIter = prodImagePages.iterator();
		                                while(imagePageIter.hasNext()){
		                                    FlexObject obj = (FlexObject) imagePageIter.next();
		                                    String imagePageId = "VR:com.lcs.wc.document.LCSDocument:" + obj.getString("LCSDOCUMENT.BRANCHIDITERATIONINFO");
		                                    %>
		                                    <a id="ac_<%= imagePageId %>" href="javascript:getActionsMenuWithActiveProductId('<%= imagePageId %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(obj.getString(imagePageRootType.getAttribute("name").getSearchResultIndex())) %></a><br>
		                                <%
		                                }
		                                %>
                                        </div>
                                        </td>
                                    </tr>
                                    <%
	                            }
                                Collection bomResults = null;
                                Collection laborResults = null;
                                FlexType bomRootType = FlexTypeCache.getFlexTypeFromPath("BOM\\Materials");
                                
                                if(bomTab){
                                    bomResults = new LCSFlexBOMQuery().findBOMs(productRevA, null, null, "MAIN",true);
                                    if(bomResults == null){ bomResults = new ArrayList(); }
                                    bomResults = SortHelper.sortFlexObjects(bomResults, bomRootType.getAttribute("name").getSearchResultIndex());

	                                %>
	                                <tr>
	                                    <td>
	                                        <a class='LABEL' href="javascript:toggleExpandableDiv('materialsContent', 'materialsContentIcon');"><span style='padding-right:4px'><img id='materialsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= materialsLabel %> (<%= bomResults.size() %>)</a><br>
	                                        <div id="materialsContent"  style="display:none;padding-left:20;padding-top:5px;">
	                                        <%
                                            Iterator bomIter = bomResults.iterator();
                                            while(bomIter.hasNext()){
	                                        	FlexObject obj = (FlexObject) bomIter.next();
	                                            String bomId = "VR:com.lcs.wc.flexbom.FlexBOMPart:" + obj.getString("FLEXBOMPART.BRANCHIDITERATIONINFO");
	                                            %>
	                                            <a id="ac_<%= bomId %>" href="javascript:getActionsMenuWithActiveProductId('<%= bomId %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(obj.getString(bomRootType.getAttribute("name").getSearchResultIndex())) %></a><br>
	                                            <%
	                                        }
	                                        %>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <%
                                }
                                if(laborTab){
                                    laborResults = new LCSFlexBOMQuery().findBOMs(productRevA, null, null, "LABOR", true);
                                    if(laborResults == null){ laborResults = new ArrayList(); }
                                    laborResults = SortHelper.sortFlexObjects(laborResults, bomRootType.getAttribute("name").getSearchResultIndex());
                                    %>
                                    <tr>
                                        <td>
                                            <a class='LABEL' href="javascript:toggleExpandableDiv('laborContent', 'laborContentIcon');"><span style='padding-right:4px'><img id='laborContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= laborLabel %> (<%= laborResults.size() %>)</a><br>
                                            <div id="laborContent"  style="display:none;padding-left:20;padding-top:5px;">
                                            <%
                                            Iterator bomIter = laborResults.iterator();
                                            while(bomIter.hasNext()){
                                                FlexObject obj = (FlexObject) bomIter.next();
                                                String bomId = "VR:com.lcs.wc.flexbom.FlexBOMPart:" + obj.getString("FLEXBOMPART.BRANCHIDITERATIONINFO");
                                                %>
                                                <a id="ac_<%= bomId %>" href="javascript:getActionsMenuWithActiveProductId('<%= bomId %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(obj.getString(bomRootType.getAttribute("name").getSearchResultIndex())) %></a><br>
                                                <%
                                            }
                                            %>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                }                                
                                if(measurementsTab){
	                                Collection measurements = LCSMeasurementsQuery.findMeasurements(product, null, null, null, true);
	                                FlexType measurementsRootType = FlexTypeCache.getFlexTypeFromPath("Measurements");
	                                measurements = SortHelper.sortFlexObjects(measurements, measurementsRootType.getAttribute("name").getSearchResultIndex());
	                                %>
	                                <tr>
	                                    <td>
	                                        <a class='LABEL' href="javascript:toggleExpandableDiv('measurementsContent', 'measurementsContentIcon');"><span style='padding-right:4px'><img id='measurementsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%=measurementsLabel %> (<%= measurements.size() %>)</a><br>
	                                        <div id="measurementsContent"  style="display:none;padding-left:20;padding-top:5px;">
	                                        <%
	                                        Iterator measIter = measurements.iterator();
	                                        while(measIter.hasNext()){
	                                            FlexObject obj = (FlexObject) measIter.next();
	                                            String measId = "VR:com.lcs.wc.measurements.LCSMeasurements:" + obj.getString("LCSMEASUREMENTS.BRANCHIDITERATIONINFO");
	                                            %>
	                                            <a id="ac_<%= measId %>" href="javascript:getActionsMenuWithActiveProductId('<%= measId %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(obj.getString(measurementsRootType.getAttribute("name").getSearchResultIndex())) %></a><br>
	                                            <%
	                                        }
	                                        %>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <%
                                }
                                if(constructionTab){
	                                Collection construction = LCSConstructionQuery.findConstructionInfos(product, null, null, true);
	                                FlexType constructionRootType = FlexTypeCache.getFlexTypeFromPath("Construction");
	                                construction = SortHelper.sortFlexObjects(construction, constructionRootType.getAttribute("name").getSearchResultIndex());
	                                %>
	                                <tr>
	                                    <td>
	                                        <a class='LABEL' href="javascript:toggleExpandableDiv('constructionContent', 'constructionContentIcon');"><span style='padding-right:4px'><img id='constructionContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= constructionLabel %> (<%= construction.size() %>)</a><br>
	                                        <div id="constructionContent"  style="display:none;padding-left:20;padding-top:5px;">
	                                        <%
	                                        Iterator constIter = construction.iterator();
	                                        while(constIter.hasNext()){
	                                            FlexObject obj = (FlexObject) constIter.next();
	                                            String constId = "VR:com.lcs.wc.construction.LCSConstructionInfo:" + obj.getString("LCSCONSTRUCTIONINFO.BRANCHIDITERATIONINFO");
	                                            %>
	                                            <a id="ac_<%= constId %>" href="javascript:getActionsMenuWithActiveProductId('<%= constId %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(obj.getString(constructionRootType.getAttribute("name").getSearchResultIndex())) %></a><br>
	                                            <%
	                                        }
	                                        %>
	                                        </div>
	                                    </td>
	                                </tr>
	                           <% 
	                           } 
                               if(sourcingTab){
	                               Map sourceMap = appContext.getSourcesMap();
	                               String sourceId = null;
	                               String sourceName = null;

	                               
	                               Map sourceNameMap = CollectionUtil.reverseMap(sourceMap);
                                   Collection nameSet = sourceNameMap.keySet();
                                   nameSet = SortHelper.sortStrings(nameSet);
                                   Iterator sourceIdIter = nameSet.iterator();
	                               
                                   %>
                                   <tr>
                                       <td>
                                        <a class='LABEL' href="javascript:toggleExpandableDiv('sourcesContent', 'sourcesContentIcon');"><span style='padding-right:4px'><img id='sourcesContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= sources_LBL %> (<%= sourceMap.size() %>)</a><br>
                                        <div id="sourcesContent" style="display:none;padding-left:20;padding-top:5px;">
                                        <%

                                        while(sourceIdIter.hasNext()){

                                        	sourceName = (String) sourceIdIter.next();
                                            sourceId = (String) sourceNameMap.get(sourceName);
                                            %>
                                            <a id="ac_<%= sourceId %>" href="javascript:getActionsMenuWithActiveProductId('<%= sourceId %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(sourceName) %></a><br>
                                            <%
                                        }
                                        %>
                                        </div>
                                        </td>
                                    </tr>     
                               <%
                               }
                               if(documentsTab){
	                                Collection productReferenceDocs = new LCSDocumentQuery().findPartDocReferences(productARev);
	                                Collection productDescribeByDocs=new LCSDocumentQuery().findPartDocDescribe(productARev);

	                                if(productSeasonRev != null){
	                                    productReferenceDocs.addAll(new LCSDocumentQuery().findPartDocReferences(productSeasonRev));//add product-season reference doc
	                                    productDescribeByDocs.addAll(new LCSDocumentQuery().findPartDocDescribe(productSeasonRev));// add product-sasson describe by doc
	                                }  
	                                
	                                //Count
	                                int count = productReferenceDocs.size();
                                    if(DOCUMENT_VERSION_CONTROL==true){
       							      	count += productDescribeByDocs.size();
       							     }
	                                
	                                //Ordering By Name and Version
                                    Vector<String> sorting = new Vector<String>(2);
                                    sorting.add("LCSDOCUMENT.ATT1");
                                    sorting.add("LCSDOCUMENT.VERSIONIDA2VERSIONINFO");
                                    productReferenceDocs = SortHelper.sortFlexObjects(productReferenceDocs, sorting);                                    
                                    productDescribeByDocs=SortHelper.sortFlexObjects(productDescribeByDocs, sorting); 
	                                
	                                %>                       
	                                <tr>
	                                    <td>
	                                        <a class='LABEL' href="javascript:toggleExpandableDiv('documentsContent', 'documentsContentIcon');"><span style='padding-right:4px'><img id='documentsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= documentsLabel %>(<%= count %>)</a><br>
	            							
	                                        <div id="documentsContent"  style="display:none;padding-left:20;padding-top:5px;">
	                                        <% if(productReferenceDocs.size()>0){
	                                              if(DOCUMENT_VERSION_CONTROL==true){
	                                         %>
	                                        <div style="padding-left:0;padding-top:0px;" class='LABEL'><%= referenceDocumentsLabel %></div><%} %>
	                                        <div style="padding-left:15;padding-top:0px;">
	                                        <%
	                                        Iterator referenceDocIter = productReferenceDocs.iterator();
	                                        FlexObject referenceDoc;
	                                        String referenceDocName = null;
	                                        while(referenceDocIter.hasNext()){
	                                            referenceDoc = (FlexObject) referenceDocIter.next(); 
	                                            referenceDocName = referenceDoc.getString("LCSDOCUMENT.ATT1");
	                                            %> 
													<div style="padding-top:3px;" >
														<a style="display:inline-block;" id="ac_<%= "VR:com.lcs.wc.document.LCSDocument:" + referenceDoc.getString("LCSDOCUMENT.BRANCHIDITERATIONINFO") %>" href="javascript:getActionsMenuWithActiveProductId('<%= "VR:com.lcs.wc.document.LCSDocument:" + referenceDoc.getString("LCSDOCUMENT.BRANCHIDITERATIONINFO") %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(referenceDocName) %> </a>
													</div>
												<%
	                                        }
	                                        %>
	                                	     </div>
	                                        <%} %>
	                                        <%if(DOCUMENT_VERSION_CONTROL==true&&productDescribeByDocs.size()>0){ %>
	                                        <div style="padding-left:0;padding-top:5px;" class='LABEL'><%= describedByDocumentsLabel %></div>  
	                                        <div style="padding-left:15;padding-top:0px;">
	                                        <%
	                                        Iterator describeByDocIter = productDescribeByDocs.iterator();
	                                        FlexObject describeByDoc;
	                                        String describeByDocName = null;
	                                        while(describeByDocIter.hasNext()){
	                                        	describeByDoc = (FlexObject) describeByDocIter.next(); 
	                                        	describeByDocName = describeByDoc.getString("LCSDOCUMENT.ATT1") + " (" + describeByDoc.getString("LCSDOCUMENT.VERSIONIDA2VERSIONINFO") + ")";
	                                            %>
	                                           <div style="padding-top:3px; clear:both;" >
	                                           		<a style="display:inline-block;" id="ac_<%= "VR:com.lcs.wc.document.LCSDocument:" + describeByDoc.getString("LCSDOCUMENT.BRANCHIDITERATIONINFO") %>" href="javascript:getActionsMenuWithActiveProductId('<%= "VR:com.lcs.wc.document.LCSDocument:" + describeByDoc.getString("LCSDOCUMENT.BRANCHIDITERATIONINFO") %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(describeByDocName) %> </a>
	                                           	</div>
	                                            <%
	                                        }	

	                                        %>
	                                        </div>
	                                        <% } %>
	                                      </div>
	                                    </td>
	                                </tr>
                                <%
                               }
                               
                                Collection linkedProducts = new ArrayList();
                                Collection parentLinks = LCSProductQuery.getLinkedProducts(FormatHelper.getObjectId((WTObject) product.getMaster()), false, true);
                                String nameColumn = FlexTypeCache.getFlexTypeRoot("Product").getAttribute("productName").getVariableName().toUpperCase();

                                Iterator i = parentLinks.iterator();
                                FlexObject fobj = null;
                                FlexObject nobj = null;

                                while(i.hasNext()){
                                    fobj = (FlexObject)i.next();
                                    nobj = fobj.dup();
                                    nobj.put("PRODNAME", fobj.get("PARENTPRODUCT." + nameColumn));
                                    nobj.put("PRODID", fobj.get("PARENTPRODUCT.BRANCHIDITERATIONINFO"));
                                    nobj.put("RELATIONSHIP_TYPE",fobj.get("PRODUCTTOPRODUCTLINK.LINKTYPE"));
                                    if("sibling".equalsIgnoreCase(CopyModeUtil.getRelationshipType((String)fobj.get("PRODUCTTOPRODUCTLINK.LINKTYPE")))){
                                        nobj.put("RELATIONSHIP", roleNoneLabel);
                                    }else{
                                        nobj.put("RELATIONSHIP", parentLinkLabel);
                                    }
                                    linkedProducts.add(nobj);
                                }


                                //Child products
                                Collection childLinks = LCSProductQuery.getLinkedProducts(FormatHelper.getObjectId((WTObject) product.getMaster()), true, false);
                                i = childLinks.iterator();
                                while(i.hasNext()){
                                    fobj = (FlexObject)i.next();
                                    nobj = fobj.dup();
                                    nobj.put("PRODNAME", fobj.get("CHILDPRODUCT." + nameColumn));
                                    nobj.put("PRODID", fobj.get("CHILDPRODUCT.BRANCHIDITERATIONINFO"));
                                    nobj.put("RELATIONSHIP_TYPE",fobj.get("PRODUCTTOPRODUCTLINK.LINKTYPE"));
                                    if("sibling".equalsIgnoreCase(CopyModeUtil.getRelationshipType((String)fobj.get("PRODUCTTOPRODUCTLINK.LINKTYPE")))){
                                        nobj.put("RELATIONSHIP", roleNoneLabel);
                                    }else{
                                        nobj.put("RELATIONSHIP", childLinkLabel);
                                    }
                                    linkedProducts.add(nobj);
                                }
                                    %>
                                <tr>
                                    <td>
                                        <a class='LABEL' href="javascript:toggleExpandableDiv('relatedProductsContent', 'relatedProductsContentIcon');"><span style='padding-right:4px'><img id='relatedProductsContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/collapse_tree.png' border='0'></span><%= linkedProduct_LBL %>(<%= linkedProducts.size() %>)</a><br>
                                        <div id="relatedProductsContent" style="display:none;padding-left:20;padding-top:5px;">
                                        <%	                            	
                                                Iterator linkedProdIter = linkedProducts.iterator();
                                                while(linkedProdIter.hasNext()){
                                                    nobj = (FlexObject) linkedProdIter.next();
                                                    %>
                                            <a id="ac_<%= "VR:com.lcs.wc.product.LCSProduct:" + nobj.getString("PRODID") %>" href="javascript:getActionsMenuWithActiveProductId('<%= "VR:com.lcs.wc.product.LCSProduct:" + nobj.getString("PRODID") %>')" class="actions_link"><%= FormatHelper.encodeAndFormatForHTMLContent(nobj.getString("PRODNAME")) %> (<%= FormatHelper.encodeAndFormatForHTMLContent(nobj.getString("RELATIONSHIP")) %>)</a><br>                                    	
                                        <% } %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class='BlueBoxFooter'>
                        </div>
                    </div>
                </div>
        <!-- End Content -->
        </div>
        <div class='BlueBoxFooter'></div>
    </div>
<%}%>

<%if(showQuickLinks){%>
<div class='BlueBox'>
    <div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
    <div class='BoxContent'>
            <div style='overflow:hidden'>
                <table width='90%' cellspacing='0' cellpadding='0'>
                    <td class='BlueHeader' style='padding-left:10px;'>
                    <a href="javascript:toggleExpandableDiv('quickLinkContent', 'quickLinkContentIcon');"><span style='padding-right:4px'><img id='quickLinkContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/expand_tree.png' border='0'></span><%= quickLinks_lbl %></a>
                    </td>
                </table>
            </div>
          <div class='BlueBody' id='quickLinkContent'>
                <div class='BlueBox'>
                    <div class='BlueBoxHeader'>
                        <div class="BlueHeader">
                        </div>
                    </div>
                    <div class='BoxContent' style='overflow:hidden'>
                        <div class="LABEL">
	                        <%if(!lcsContext.isVendor){%><a class="LABEL" href="javascript:viewSPL('SUMMARY')"><%= summaryLabel %></a><br><%}%>
	                        <a class="LABEL" href="javascript:viewSPL('PRODUCT')"><%= detailsLabel %></a><br>
	                        <% if(specSummaryTab){ %>
	                        <a class="LABEL" href="javascript:viewSPL('SPEC_SUMMARY')"><%= specificationLabel %></a><br>
	                        <% } %>
	                        <div class="DISPLAYTEXT" style='padding-left:14px'>
                                <% if(imagesTab){ %>
	                           <a href="javascript:viewSPL('IMAGES')"><%= imagesLabel %></a><br>
	                           <% } %>
	                           <% if(bomTab){ %>
	                           <a href="javascript:viewSPL('BOM')"><%= materialsLabel %></a><br>
	                           <% } %>
	                           <% if(cadDataTab){ %>
	                           <a href="javascript:viewSPL('CAD_DATA')"><%= cadDataLabel %></a><br>
	                           <% } %>
	                           <% if(partsTab){ %>
	                           <a href="javascript:viewSPL('PARTS')"><%= partsLabel %></a><br>
	                           <% } %>
                               <% if(laborTab){ %>
                               <a href="javascript:viewSPL('LABOR')"><%= laborLabel %></a><br>
                               <% } %>	                           
	                           <% if(sizingTab){ %>
	                           <a href="javascript:viewSPL('SIZING')"><%= sizingLabel %></a><br>
	                           <% } %>
	                           <% if(measurementsTab){ %>
	                           <a href="javascript:viewSPL('MEASUREMENTS')"><%= measurementsLabel %></a><br>
	                           <% } %>
	                           <% if(constructionTab){ %>
	                           <a href="javascript:viewSPL('CONSTRUCTION')"><%= constructionLabel %></a><br>
	                           <% } %>
	                           
	                           
	                        </div>
                            
                            <% if(sourcingTab) { %>
	                        <a class="LABEL" href="javascript:viewSPL('SOURCING')"><%= sourcingLabel %></a><br>
                            <div class="DISPLAYTEXT" style='padding-left:14px'>
                            	<%if(costingTab){%>
	                           <a href="javascript:viewSPL('COSTING')"><%= costingLabel %></a><br>
	                           <%}%>
                            	<%if(rfqTab){%>
	                           <a href="javascript:viewSPL('RFQ')"><%= rfqLabel %></a><br>
							   <%}%>
                           		<%if(ocTab){%>
	                           <a href="javascript:viewSPL('ORDERCONFIRMATION')"><%= ocLabel %></a><br>
							   <%}%>
	                           <% if(destinationsTab){ %>
	                           <a href="javascript:viewSPL('PRODUCTDESTINATION')"><%= productDestinationLabel %></a><br>
	                           <% } %>
	                           <% if(sampleTab){ %>
	                           <a href="javascript:viewSPL('SAMPLES')"><%= samplesLabel %></a><br>
	                           <% } %>
	                           <% if(costsheetreportTab){ %>
	                           <a href="javascript:viewSPL('COSTSHEET')"><%= costsheetreportLable %></a><br>
	                           <% } %>
	                        </div>
                            <% } %>
                            <a class="LABEL" href="javascript:viewSPL('PRODUCTPLANNING')"><%= productPlanningLabel %></a><br>
                            <a class="LABEL" href="javascript:viewSPL('TESTING')"><%= approvalsLabel %></a><br>
                            <div class="DISPLAYTEXT" style='padding-left:14px'>
                               <% if(fitApproval){ %>
                               <a href="javascript:viewSPL('FIT_APPROVAL_PAGE')"><%= fitApprovalLabel %></a><br>
                               <% } %>
                               <% if(materialApproval){ %>
                               <a href="javascript:viewSPL('MATERIAL_APPROVAL_PAGE')"><%= materialApprovalLabel %></a><br>
                               <% } %>
                               <% if(colorApproval){ %>
                               <a href="javascript:viewSPL('COLOR_APPROVAL_PAGE')"><%= colorApprovalLabel  %></a><br>
                               <% } %>
                               <% if(productTesting){ %>
                               <a href="javascript:viewSPL('PRODUCTTESTING')"><%= productTestingLabel  %></a><br>
                               <% } %>
                            </div>
                            <% if(documentsTab){ %>
                            <a class="LABEL" href="javascript:viewSPL('DOCUMENTS')"><%= documentsLabel %></a><br>
                            <% } %>
	                        <% if(processTab){ %>
	                        <a class="LABEL" href="javascript:viewSPL('PROCESSES')"><%= processesLabel %></a><br>
	                        <% } %>
                            <a class="LABEL" href="javascript:viewSPL('CHANGES')"><%= changesLabel %></a><br>
                            <a class="LABEL" href="javascript:viewSPL('HISTORY')"><%= historyLabel %></a><br>
                            <a class="LABEL" href="javascript:viewSPL('RELATIONS')"><%= relationshipsLabel %></a><br>                            
                            <a class="LABEL" href="javascript:viewSPL('SYSTEM')"><%= systemLabel %></a><br>
							<% if(!lcsContext.isVendor){ %>							
                            <a class="LABEL" href="javascript:viewSPL('CALENDARS')"><%= calendarLabel %></a><br>                            
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
<%}%>

<div class='BlueBox'>
    <div class='BlueBoxHeader'><img src='<%= URL_CONTEXT %>/images/blue_topleft.gif' width='4' height='4'></div>
    <div class='BoxContent'>
            <div style='overflow:hidden'>
                <table width='90%' cellspacing='0' cellpadding='0'>
                    <td class='BlueHeader' style='padding-left:10px;'>
                    <a href="javascript:toggleExpandableDiv('attributeContent', 'attributeContentIcon');"><span style='padding-right:4px'><img id='attributeContentIcon' valign="bottom" src='<%=WT_IMAGE_LOCATION%>/expand_tree.png' border='0'></span><%= keyInformation_lbl %></a>
                    </td>
                </table>
            </div>
          <div class='BlueBody' id='attributeContent'>
                <div class='BlueBox'>
                    <div class='BlueBoxHeader'>
                        <div class="BlueHeader">
                        </div>
                    </div>
                    <div class='BoxContent' style="overflow:hidden">
                        <table width="90%">
                            <col width="1%"><col width="99%">
                            <%
                            flexg.setScope(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SCOPE);
                            flexg.setLevel(FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL);
                            Iterator quickAttIter = product.getFlexType().getQuickInfoAttributes(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SCOPE, FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL).iterator();
                            FlexTypeAttribute att;
                            while(quickAttIter.hasNext()){
                                att = (FlexTypeAttribute) quickAttIter.next();
                                if(!ACLHelper.hasViewAccess(att)){ continue; }
                                %>
                                <tr>
                                <%= flexg.drawDisplay(att, productARev) %>
                                </tr>
                                <%
                            }
                            if(productSeasonRev != null){
                                flexg.setScope(FootwearApparelFlexTypeScopeDefinition.PRODUCTSEASON_SCOPE);
                                flexg.setLevel(FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL);
                                quickAttIter = product.getFlexType().getQuickInfoAttributes(FootwearApparelFlexTypeScopeDefinition.PRODUCTSEASON_SCOPE, FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL).iterator();
                         
                                while(quickAttIter.hasNext()){
                                    att = (FlexTypeAttribute) quickAttIter.next();
                                    if(!ACLHelper.hasViewAccess(att)){ continue; }
                                    %>
                                    <tr>
                                    <%= flexg.drawDisplay(att, productSeasonLink) %>
                                    </tr>
                                    <%
                                }
                            }
							Collection productSizeCats = new SizingQuery().findProductSizeCategoriesForProduct(product).getResults();
							String sizeRangeString = "";
							int sizeCatCounter = 1;
							Iterator productSizeCatsIterator = productSizeCats.iterator();
							FlexObject productSizeFo;
							if(productSizeCats.size()>1){

								while(productSizeCatsIterator.hasNext()){
									  productSizeFo = (FlexObject)productSizeCatsIterator.next();
									  if(FormatHelper.hasContentAllowZero(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZEVALUES")) && FormatHelper.hasContentAllowZero(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZE2VALUES"))){
										sizeRangeString = "(" + MOAHelper.parseOutDelims(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZEVALUES"), true) + ")\n(" + MOAHelper.parseOutDelims(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZE2VALUES"), true) + ")";
									  }else{
										sizeRangeString = MOAHelper.parseOutDelims(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZEVALUES"), true);
									  }
									  %>
										 <tr><%= fg.createDisplay(sizeRangeLabel + " " + sizeCatCounter + ":", sizeRangeString, FormatHelper.STRING_FORMAT) %></tr>

									  <%
									 sizeCatCounter++;
								}
							}else if(productSizeCats.size() == 1){
								  productSizeFo = (FlexObject)productSizeCatsIterator.next();
								  if(FormatHelper.hasContentAllowZero(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZEVALUES")) && FormatHelper.hasContentAllowZero(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZE2VALUES"))){
									sizeRangeString = "(" + MOAHelper.parseOutDelims(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZEVALUES"), true) + ")\n(" + MOAHelper.parseOutDelims(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZE2VALUES"), true) + ")";
								  }else{
									sizeRangeString = MOAHelper.parseOutDelims(productSizeFo.getString("PRODUCTSIZECATEGORY.SIZEVALUES"), true);
								  }
							%>
								<tr><%= fg.createDisplay(sizeRangeLabel, sizeRangeString, FormatHelper.STRING_FORMAT) %></tr>

							<%
								
							}else{%>
								<tr><%= fg.createDisplay(sizeRangeLabel, "", FormatHelper.STRING_FORMAT) %></tr>

							<%
							}
							%>
                            <%if(USE_PLACEHOLDERS && productSeasonLink != null && productSeasonLink.getPlaceholder() != null){%>
                            <tr>
                            <%= fg.createDisplay(placeholderLabel, (String)productSeasonLink.getPlaceholder().getValue("placeholderName"),
                                                 FormatHelper.STRING_FORMAT, "javascript:viewObject('" + FormatHelper.getObjectId(appContext.getProductLink().getPlaceholder()) + "')")%>
                            </tr>
                            <%}%>
                            <tr><%= fg.createDisplay(typeLabel, product.getFlexType().getFullName(), FormatHelper.STRING_FORMAT) %></tr>
                            <tr><%= fg.createDisplay(lifeCycleStateLabel, product.getLifeCycleState().getDisplay(request.getLocale()), FormatHelper.STRING_FORMAT) %></tr>
                            <tr><%= fg.createDisplay(dateCreatedLabel, productARev.getCreateTimestamp(), FormatHelper.DATE_TIME_STRING_FORMAT) %></tr>
                            <tr><%= fg.createDisplay(lastUpdatedLabel, productARev.getModifyTimestamp(), FormatHelper.DATE_TIME_STRING_FORMAT) %></tr>
                        </table>
                    </div>
                    <div class='BlueBoxFooter'>
                    </div>
                </div>
            </div>
    <!-- End Content -->
    </div>
    <div class='BlueBoxFooter'></div>
</div><!-- -- PAGE_LOAD_SUCESS -- -->
