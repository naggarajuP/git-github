<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="com.lcs.wc.db.*,
            com.lcs.wc.calendar.*,
            com.lcs.wc.client.*,
            com.lcs.wc.client.web.*,
            com.lcs.wc.season.*,
            com.lcs.wc.color.*,
            com.lcs.wc.util.*,
            com.lcs.wc.foundation.*,
            com.lcs.wc.product.*,
            com.lcs.wc.flextype.*,
            com.lcs.wc.sourcing.*,
            com.lcs.wc.db.*,
            java.io.*,
            wt.fc.*,
            wt.util.*,
            wt.org.*,
            wt.part.WTPartMaster,
            com.lcs.wc.infoengine.client.web.*,
            org.jfree.chart.*,
            org.jfree.data.*,
            org.jfree.data.time.*,
            org.jfree.chart.plot.PiePlot,
            org.jfree.chart.plot.CategoryPlot,
            org.jfree.chart.axis.*,
            org.jfree.chart.renderer.*,
            org.jfree.chart.entity.*,
            org.jfree.chart.servlet.*,
            org.jfree.chart.*,
            org.jfree.data.*,
            org.jfree.chart.renderer.*,
            org.jfree.chart.plot.*,
            org.jfree.chart.axis.*,
            org.jfree.chart.urls.*,
            java.util.*,
            com.lcs.wc.calendar.LCSCalendarQuery,
            com.lfusa.wc.reports.query.*,
            com.lfusa.wc.calendar.LFDashboardReportConstants,
            com.lfusa.wc.calendar.LFCalendarConstants,
            java.text.SimpleDateFormat,
            java.util.concurrent.TimeUnit
            "
			
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="ftg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="seasonModel" scope="request" class="com.lcs.wc.season.LCSSeasonClientModel" />
<jsp:useBean id="linePlanConfig" scope="session" class="com.lcs.wc.season.LinePlanConfig" />
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVA CODE ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
//setting up which RBs to use
Object[] objA = new Object[0];
String Season_MAIN = "com.lcs.wc.resource.SeasonRB";
String RB_MAIN = "com.lcs.wc.resource.MainRB";
 
String runLabel = WTMessage.getLocalizedMessage ( RB_MAIN, "run_LBL",objA ) ;
String imageLabel = WTMessage.getLocalizedMessage ( RB_MAIN, "image_LBL",objA ) ;
String healthStatus = WTMessage.getLocalizedMessage ( RB_MAIN, "healthStatus_LBL",objA ) ;
String numOnSchedule = WTMessage.getLocalizedMessage ( RB_MAIN, "numOnSchedule_LBL",objA ) ;
String numOfAlerts = WTMessage.getLocalizedMessage ( RB_MAIN, "numOfAlerts_LBL",objA ) ;
String totalLabel = WTMessage.getLocalizedMessage ( RB_MAIN, "total_LBL",objA ) ;
String levelLabel = WTMessage.getLocalizedMessage ( RB_MAIN, "level_LBL",objA ) ;
String productLabel = WTMessage.getLocalizedMessage ( Season_MAIN, "product_LBL", objA ) ;
String productsLabel = WTMessage.getLocalizedMessage ( Season_MAIN, "products_LBL", objA ) ;
String skuLabel = WTMessage.getLocalizedMessage ( Season_MAIN, "sku_LBL", objA ) ;
String skusLabel = WTMessage.getLocalizedMessage ( Season_MAIN, "skus_LBL", objA ) ;
String showThumbnailsLabel = WTMessage.getLocalizedMessage ( Season_MAIN, "showThumbnails_LBL", RB.objA ) ;

String numOfDroppedProducts = "# of dropped products" ;
Collection finalData = new ArrayList();
boolean DEBUG=LCSProperties.getBoolean("jsp.part.SeasonController.verbose");

String strDivFilterVal="";
String strProdCatFilterVal="";
String strBrandFilterVal="";
String strLicensorFilterVal="";
String strCustomerFilterVal="";
String strPropertyFilterVal="";
String strProdSubCatFilterVal="";
String strProductStatusFilterVal="";
String strSizeGroupFilterVal="";
String strYearFilterVal="";
String strSeasonFilterVal="";

// ....change
String strOtherProductClassificationFilterVal = "";

%>
<%!
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    static String systemName = "";
    static String tempChartDirectory = "";
    static String tempChartDirectoryURL = "";
    static final String CALENDAR_DASHBOARD_TAB = "CALENDAR_DASHBOARD_TAB";

    static String greenGif = "<img id=\"priority3\" align=\"middle\" src=\"" + WT_IMAGE_LOCATION + "/greenAlert.png\">";
    static String redGif = "<img id=\"priority1\" align=\"middle\" src=\"" + WT_IMAGE_LOCATION + "/failure_fixable_16x16.gif\">";
    static String yellowGif = "<img id=\"priority2\" align=\"middle\" src=\"" + WT_IMAGE_LOCATION + "/warning_16x16.gif\">";
	static String blackGif = "<img id=\"priority4\" align=\"middle\" src=\"" + WT_IMAGE_LOCATION + "/black.gif\">";
  	public static String EXCEL_GENERATOR_SUPPORT_PLUGIN = PageManager.getPageURL("EXCEL_GENERATOR_SUPPORT_PLUGIN", null);
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    static {
        try {
            systemName = wt.util.WTProperties.getLocalProperties().getProperty ("java.rmi.server.hostname");
            tempChartDirectory = wt.util.WTProperties.getLocalProperties().getProperty("wt.home") + FormatHelper.formatOSFolderLocation(LCSProperties.get("jsp.tempChartDirectory", "none"));
            tempChartDirectoryURL = LCSProperties.get("jsp.tempChartDirectoryURL","none");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
    //Start This code will be used for hide and show column.
     public static final String getActionButtons() throws WTException
     {
      String hideShowButton = WTMessage.getLocalizedMessage ( RB.FLEXBOM, "hideShow_LBL", RB.objA ) ;
      StringBuilder sb = new StringBuilder();
      sb.append("<td class=\"button\"><a class=\"button\" id='hideColButton' href=\"javascript:showHidableTableColumns('customEditorHideShow', 'columnHideFixedBox')\">"+hideShowButton +"</a>");
      return sb.toString();
    }
	// Start Holder map for generating excel report.
    Map map=new HashMap();
    public Map retainVal(String strDivSelected,String strProdCatSelected,String strBrandSelelcted,String strLicensorSelected,
                String strCustomerSelected,String strPropertySelected,String strProdSubCatSelected,String strProdStatusSelected,
                String strSizeGroupSelected,String strYearSelected, String strSeasonSelected , String strOtherProductClassificationSelected)
      {                    
      String seasonVal =  strSeasonSelected;
      String yearVal   =  strYearSelected;
    
      Collection SeasonValList = MOAHelper.getMOACollection(seasonVal);
      List seasonValues = new ArrayList(SeasonValList);
  
      Collection yearValList = MOAHelper.getMOACollection(yearVal);
      List yearValues = new ArrayList(yearValList);
       
      String SEASON_KEY_PRODUCT = "SEASON_KEY_PRODUCT";
      String YEAR_KEY_PRODUCT = "YEAR_KEY_PRODUCT";
    
      String divisionValue = strDivSelected;
      String DIVISION_KEY = LFReportConstants.SEARCH_DIVISION;
      
      
      // ....change
      
      /***************** FOR OTHER PRODUCT CLASSIFICATION ******************/
      String otherProductClassificationValue = strOtherProductClassificationSelected;
      String OTHER_PRODUCT_CLASSIFICATION_KEY = "OTHER_PRODUCT_CLASSIFICATION_KEY";
      Collection otherProductClassificationList = MOAHelper.getMOACollection(otherProductClassificationValue);
      List otherProductClassificationValues = new ArrayList(otherProductClassificationList);
      
      System.out.println("\n\n\n\n\n OTHER Product  ..... " + otherProductClassificationValues+"\n\n\n\n\n");
      
      /************************ FOR CUSTOMER ********************************/
      String customerValue = strCustomerSelected;
      String CUSTOMER_RETAILER_KEY = LFReportConstants.SEARCH_CUSTOMER;
      Collection customerList = MOAHelper.getMOACollection(customerValue);
      List customerValues = new ArrayList(customerList);
     
      /************************ FOR BRAND ********************************/
      String brandValue = strBrandSelelcted;
      String BRAND_KEY = LFReportConstants.SEARCH_BRAND;
      Collection brandList = MOAHelper.getMOACollection(brandValue);
      List brandValues = new ArrayList(brandList);
     
     /************************ FOR LICENSOR ********************************/
      String licensorValue = strLicensorSelected;
      String LICENSOR_KEY = LFReportConstants.SEARCH_LICENSOR;
      Collection licensorList = MOAHelper.getMOACollection(licensorValue);
      List licensorValues = new ArrayList(licensorList);
      
      /************************ FOR PROPERTY ********************************/
      String propertyValue = strPropertySelected;
      String PROPERTY_KEY = LFReportConstants.SEARCH_PROPERTY;
      Collection propertyList = MOAHelper.getMOACollection(propertyValue);
      List propertyValues = new ArrayList(propertyList);
  
      String productCategoryValue = strProdCatSelected;
      String PRODUCT_CATEGORY_KEY = LFReportConstants.SEARCH_PRODUCT_CATEGORY;	
      Collection productCategoryList = MOAHelper.getMOACollection(productCategoryValue);
      List productCategoryValues = new ArrayList(productCategoryList);
      
        /*********************** FOR PRODUCT STATUS ***********************************/
      String productstatusValue = strProdStatusSelected;
      String STATUS_KEY = LFReportConstants.SEARCH_PRODUCT_STATUS;
      Collection productStatusList = MOAHelper.getMOACollection(productstatusValue);
      List productStatusValues = new ArrayList(productStatusList);
 
      /*********************** FOR SIZE GROUP ***********************************/
      String sizeGroupValue = strSizeGroupSelected;
      String SIZE_GROUP_KEY = LFReportConstants.SEARCH_SIZE_GROUP;
      Collection sizeGroupList = MOAHelper.getMOACollection(sizeGroupValue);
      List sizeGroupValues = new ArrayList(sizeGroupList);
             
       /*********************** FOR PRODUCT SUB CATEGORY ***********************************/
      String productSubGroupValue = strProdSubCatSelected;
      String PRODUCT_SUBCATEGORY_KEY = LFReportConstants.SEARCH_PRODUCT_SUB_CATEGORY;
      Collection productSubGroupGroupList = MOAHelper.getMOACollection(productSubGroupValue);
      List productSubGroupValues = new ArrayList(productSubGroupGroupList);
      
      /********************** Request Map ********************************/
                           
       if(FormatHelper.hasContent(otherProductClassificationValue)) {
          map.put("OTHER_PRODUCT_CLASSIFICATION_KEY",otherProductClassificationValues);
       } else {
          map.put("OTHER_PRODUCT_CLASSIFICATION_KEY","");
       }
        if(FormatHelper.hasContent(seasonVal))
        map.put(SEASON_KEY_PRODUCT,seasonValues);
       else
        map.put(SEASON_KEY_PRODUCT,"");
        
       if(FormatHelper.hasContent(yearVal))
        map.put(YEAR_KEY_PRODUCT,yearValues);
       else
        map.put(YEAR_KEY_PRODUCT,"");
        
      if(FormatHelper.hasContent(divisionValue))
        map.put(DIVISION_KEY,divisionValue);
       else
        map.put(DIVISION_KEY,"");
        
      if(FormatHelper.hasContent(brandValue))
        map.put(BRAND_KEY,brandValues);
      else
        map.put(BRAND_KEY,new ArrayList());
        
      if(FormatHelper.hasContent(customerValue))
        map.put(CUSTOMER_RETAILER_KEY,customerValues);
      else
        map.put(CUSTOMER_RETAILER_KEY,new ArrayList());
        
      if(FormatHelper.hasContent(licensorValue))
        map.put(LICENSOR_KEY,licensorValues);
      else
        map.put(LICENSOR_KEY,new ArrayList());
      
      if(FormatHelper.hasContent(propertyValue))
        map.put(PROPERTY_KEY,propertyValues);
      else
        map.put(PROPERTY_KEY,new ArrayList());
        
      if(FormatHelper.hasContent(productCategoryValue))
        map.put(PRODUCT_CATEGORY_KEY,productCategoryValues);
      else
        map.put(PRODUCT_CATEGORY_KEY,new ArrayList());  
        
      if(FormatHelper.hasContent(productstatusValue))
        map.put(STATUS_KEY,productStatusValues);
      else
        map.put(STATUS_KEY,new ArrayList());  
        
       if(FormatHelper.hasContent(productSubGroupValue))
        map.put(PRODUCT_SUBCATEGORY_KEY,productSubGroupValues);
      else
        map.put(PRODUCT_SUBCATEGORY_KEY,new ArrayList());

      if(FormatHelper.hasContent(sizeGroupValue))
        map.put(SIZE_GROUP_KEY,sizeGroupValues);
      else
        map.put(SIZE_GROUP_KEY,new ArrayList());
        
     return map;
    }
    
	// End Holder map for generating excel report.

	// Start of hide and show column code development
    public static final String drawCustomHideableColumns(String showThumbsBox, Collection taskNameColl, TableGenerator tg1){
	   TableGenerator tgc = new TableGenerator();
	   String tid = "customEditorHideShow";
     String hideAllBtn = WTMessage.getLocalizedMessage ( RB.TABLEGENERATOR, "hideAll_BTN", RB.objA ) ;
     String showAllBtn = WTMessage.getLocalizedMessage ( RB.TABLEGENERATOR, "showAll_BTN", RB.objA ) ;  
     String taskNameStr="";
      
     boolean darkRow2 = true;
	   StringBuilder sbC = new StringBuilder();
	   
	   int displayedColumnCount = 3;
	   int startingPoint = 4;
	   if(FormatHelper.hasContent(showThumbsBox)) {
				displayedColumnCount = 4;
				startingPoint = 5;	
		}
     for( Iterator it = taskNameColl.iterator();it.hasNext();){
    	   taskNameStr = (String)it.next();
           displayedColumnCount++;		   
       }
       sbC.append("<input type='hidden' id='columnHideFixedBox'>"); 
       sbC.append("\n			<div id='columnHide" + tid + "' style='display:none;'>");
       sbC.append(tgc.startGroupBorder());
       sbC.append(tgc.startGroupTitle(null, false, null));
      
       sbC.append("<table width='100%'><td align='right'><img onClick='hideDiv(\"columnHide" + tid + "\")' src='" + WT_IMAGE_LOCATION + "/closebutton.png'></td></table>");        
       sbC.append(tgc.endTitle());
       sbC.append(tgc.startGroupContentTable(null, false, null));        
       sbC.append("\n			<td><div class='LABEL'>");
       sbC.append("\n                          <a href=\"javascript:hideAllColumns('"+tid+"','"+displayedColumnCount+"')\">" + hideAllBtn + "</a><br>");
       sbC.append("\n                          <a href=\"javascript:showAllColumns('"+tid+"','"+displayedColumnCount+"')\">" + showAllBtn + "</a><br><br>");
             
       if(taskNameColl != null){
           Iterator i = taskNameColl.iterator();

		   int columnIndexCustom = 4;
		   
		   if(FormatHelper.hasContent(showThumbsBox)) {
				columnIndexCustom++;
		   }
		    while(i.hasNext()){
		    taskNameStr = (String) i.next();
               sbC.append("\n <input type=checkbox name=\"HC"+columnIndexCustom +"\" value=\"true\" onclick=\"toggleColumn(this, '" + tid + "')\" checked>&nbsp;&nbsp;" + taskNameStr+"<br>");
               columnIndexCustom = columnIndexCustom + 1;
               darkRow2 = !darkRow2;
           }
           sbC.append("\n<input type=\"hidden\" name=\"HC_Col_Count\" value=\""+columnIndexCustom+"\">");
                  }
       sbC.append("\n              </div></td>");
    
       sbC.append(tgc.endContentTable());        
       sbC.append(tgc.endTable());
       sbC.append(tgc.endBorder());        
       sbC.append("\n              </div>"); // END COLUMN HIDE DIV        
	   return sbC.toString();
   }
   //End This code will be used for hide and show column.
	
    public static String formatCalc(double val){
        if((new Double(val)).isNaN()){
            return "0";
        }
        val = val * 100;
        String sVal = "" + val;
        sVal = FormatHelper.applyFormat(sVal, FormatHelper.DOUBLE_FORMAT, 2);
        return sVal;
    }
%>
<%
    String csv = request.getParameter("csv");
    String dateToUse = "LCSCALENDARTASK.ESTENDDATE";
    String productBarChartFileName = "";
    String seasonName = null;
    String seasonId = request.getParameter("reportSeasonId");
    String reportSeasonId = seasonId;
    LCSSeason season = seasonModel.getBusinessObject();
    FlexType productType = season.getProductType();
    FlexType costSheetType = season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE);
    FlexType sourcingType = season.getProductType().getReferencedFlexType(ReferencedTypeKeys.SOURCING_CONFIG_TYPE);
    FlexTypeAttribute productNameAtt = productType.getAttribute("productName");
	
    boolean runReport = (season != null && FormatHelper.parseBoolean(request.getParameter("runReport")));

	String linePlanLevel =  (String) request.getParameter("linePlanLevel");
	if(!FormatHelper.hasContent(linePlanLevel)) {
		linePlanLevel = FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL;
	}
    boolean showThumbs = FormatHelper.parseBoolean(request.getParameter("showThumbs"));

    String rowsPerPage = "";
    int rowsToBreak = 0;
    if(FormatHelper.hasContent(request.getParameter("printMode")) && "true".equals(request.getParameter("printMode"))){
        if(FormatHelper.hasContent(request.getParameter("rowsPerPage"))){
            rowsPerPage = request.getParameter("rowsPerPage");
            rowsToBreak = (new Integer(rowsPerPage)).intValue();
        }

        if(rowsToBreak > 0){
            tg.setUsePageBreaks(true);
            tg.setPageBreakRows(rowsToBreak);
        }
    }
    else{
        tg.setUsePageBreaks(false);
    }
    boolean includeSKUs = false;
    if(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SKU_LEVEL.equals(linePlanLevel)){
        includeSKUs = true;
    }
    Hashtable columnMap = new Hashtable();
    Collection columns = new Vector();
    Collection attList = new Vector();
    Collection data = null;
    Collection productData = null;

    Collection filterList = new Vector();
    Hashtable attributeMap = new Hashtable();
    Counter counter = new Counter();
  
    Map chartURLs = new Hashtable();

    int totalCount = 0;
    int alerts = 0;
    int safe = 0;
    int warnings = 0;
    int dropCount = 0;

    ////////////////////////////////////////////////////////////////////////////
    // CREATE THE TABLE COLUMN DEFINITIONS
    ////////////////////////////////////////////////////////////////////////////
	Collection taskNamesList = new ArrayList(); 
    if(season != null){

        ftg.setScope(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SCOPE);
        ftg.setLevel(FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL);
        ftg.createTableColumns(productType, columnMap, productType.getAllAttributes(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SCOPE, FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL, false), false, "PRODUCT.");

        ftg.setScope(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SCOPE);
        ftg.setLevel(FootwearApparelFlexTypeScopeDefinition.SKU_LEVEL);
        ftg.createTableColumns(productType, columnMap, productType.getAllAttributes(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SCOPE, FootwearApparelFlexTypeScopeDefinition.SKU_LEVEL, false), false, "PRODUCT.");

        ftg.setScope(FootwearApparelFlexTypeScopeDefinition.PRODUCTSEASON_SCOPE);
        ftg.setLevel(FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL);
        ftg.createTableColumns(productType, columnMap, productType.getAllAttributes(FootwearApparelFlexTypeScopeDefinition.PRODUCTSEASON_SCOPE, FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL, true), false, "PRODUCT.");

        ftg.setScope(FootwearApparelFlexTypeScopeDefinition.PRODUCTSEASON_SCOPE);
        ftg.setLevel(FootwearApparelFlexTypeScopeDefinition.SKU_LEVEL);
        ftg.createTableColumns(productType, columnMap, productType.getAllAttributes(FootwearApparelFlexTypeScopeDefinition.PRODUCTSEASON_SCOPE, FootwearApparelFlexTypeScopeDefinition.SKU_LEVEL, false), false, "PRODUCT.");

        ftg.setScope(null);
        ftg.setLevel(null);
        if (season.getProductType().getReferencedFlexType(ReferencedTypeKeys.SOURCING_CONFIG_TYPE) != null) 
        ftg.createTableColumns(season.getProductType().getReferencedFlexType(ReferencedTypeKeys.SOURCING_CONFIG_TYPE), columnMap, season.getProductType().getReferencedFlexType(ReferencedTypeKeys.SOURCING_CONFIG_TYPE).getAllAttributes(), false, "SOURCING.");

        ftg.setScope(CostSheetFlexTypeScopeDefinition.COST_SHEET_SCOPE);
        ftg.setLevel(CostSheetFlexTypeScopeDefinition.PRODUCT_LEVEL);
        if (season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE) != null) 
         ftg.createTableColumns(season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE), columnMap, season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE).getAllAttributes(CostSheetFlexTypeScopeDefinition.COST_SHEET_SCOPE, CostSheetFlexTypeScopeDefinition.PRODUCT_LEVEL, false), false, "COSTSHEET.");

        ftg.setScope(CostSheetFlexTypeScopeDefinition.COST_SHEET_SCOPE);
        ftg.setLevel(CostSheetFlexTypeScopeDefinition.SKU_LEVEL);
        if (season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE) != null) 
        ftg.createTableColumns(season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE), columnMap, season.getProductType().getReferencedFlexType(ReferencedTypeKeys.COST_SHEET_TYPE).getAllAttributes(CostSheetFlexTypeScopeDefinition.COST_SHEET_SCOPE, CostSheetFlexTypeScopeDefinition.SKU_LEVEL, false), false, "COSTSHEET.");

		// added this block to have Product Column in the UI 
        com.lcs.wc.client.web.TableColumn column = new com.lcs.wc.client.web.TableColumn();
        column.setDisplayed(true);
        column.setHeaderLabel(productType.getAttribute("productName").getAttDisplay());
        column.setHeaderAlign("center");
        column.setUseQuickInfo(true);
        column.setLinkMethod("viewProduct");
        column.setLinkTableIndex("LCSSEASONPRODUCTLINK.PRODUCTSEASONREVID");
        column.setTableIndex(productNameAtt.getSearchResultIndex());
        column.setLinkMethodPrefix("VR:com.lcs.wc.product.LCSProduct:");
        column.setWrapping(false);
        column.setShowGroupSubTotal(false);
        columnMap.put("PRODUCT.productName", column);

        // Modified this block for THE CALENDAR NAME COLUMN WHICH IS NOT MADE BY THE ABOVE CODE
        column = new com.lcs.wc.client.web.TableColumn();
        column.setDisplayed(true);
        column.setHeaderLabel(LFDashboardReportConstants.STR_CALENDAR_NAME);
        column.setHeaderAlign("center");
        column.setUseQuickInfo(true);
        column.setLinkMethod("viewCalendar");
        column.setLinkTableIndex("LCSSEASONPRODUCTLINK.PRODUCTSEASONREVID");
		column.setLinkTableIndex2("LCSLifecycleManaged.IDA2A2");
        column.setTableIndex("CALENDAR_NAME");
        column.setLinkMethodPrefix("VR:com.lcs.wc.product.LCSProduct:");
        column.setHeaderLink("javascript:resort('" + productNameAtt.getSearchResultIndex() + "')");
        column.setWrapping(false);
        column.setShowGroupSubTotal(false);
        columnMap.put("Calendar Name", column);
        //  CREATES THE SKU NAME COLUMN WHICH IS NOT MADE BY THE ABOVE CODE
        column = new com.lcs.wc.client.web.TableColumn();
        column.setDisplayed(true);
        column.setHeaderLabel(productType.getAttribute("skuName").getAttDisplay());
        column.setHeaderAlign("center");
        column.setUseQuickInfo(true);
        column.setLinkMethod("viewCalendar");
        column.setLinkTableIndex("LCSSEASONPRODUCTLINK.SKUSEASONREVID");
        column.setTableIndex(productType.getAttribute("skuName").getSearchResultIndex());
        column.setLinkMethodPrefix("VR:com.lcs.wc.product.LCSSKU:");
        column.setHeaderLink("javascript:resort('" + productType.getAttribute("skuName").getSearchResultIndex() + "')");
        column.setWrapping(false);
        column.setShowGroupSubTotal(false);
        column.setShowCriteria("0");
        column.setShowCriteriaTarget("LCSSKU.PLACEHOLDER");
        column.setShowCriteriaNumericCompare(true);
        columnMap.put("PRODUCT.skuName", column);

		if(showThumbs) {
        	column = new TableColumn();
        	column.setDisplayed(true);
        	column.setHeaderLabel(imageLabel);
        	column.setHeaderAlign("center");
        	column.setLinkMethod("launchImageViewer");
        	column.setLinkTableIndex("LCSPRODUCT.PARTPRIMARYIMAGEURL");
        	column.setTableIndex("LCSPRODUCT.PARTPRIMARYIMAGEURL");
        	column.setColumnWidth("1%");
        	column.setLinkMethodPrefix("");
        	column.setImage(true);
        	column.setImageWidth(75);
          column.setShowFullImage(true);
        	column.setHeaderLink("javascript:resort('PRODUCTMASTER.name')");
        	columnMap.put("PRODUCT.thumbnail", column);
      }
      
      // PLM-24 UAT Change Request. Disabling the below line  to not show health status COLUMN .
              
      /*
        column = new TableColumn();
        column.setDisplayed(true);
        column.setHeaderLabel(healthStatus);
        column.setHeaderAlign("center");
        column.setAlign("center");        
        column.setTableIndex("PRODUCT.HEALTHSTATUS");
        column.setColumnWidth("1%");
        column.setFormatHTML(false);
        // issue where Groupby header is drawn and formats HTML. Added check for Format Type so will not format HTML if specified
        column.setFormat("UNFORMATTED_HTML");
        columnMap.put("PRODUCT.HEALTHSTATUS", column);

        */
        
        // PLM-24 UAT Change Request ENDS.
        
        
        ////////////////////////////////////////////////////////////////////////
        // CREATES THE LIST OF COLUMNS WHICH WILL ACTUALLY
        // BE USED BUT THE REPORT
        ////////////////////////////////////////////////////////////////////////
        Collection columnList = new Vector();
       
        columnList.add("PRODUCT.thumbnail");
        columnList.add("PRODUCT.HEALTHSTATUS");
        columnList.add("PRODUCT.productName");
        columnList.add("Calendar Name");
		
        if(includeSKUs){
            columnList.add("PRODUCT.skuName");
        }
        columnList.add("PRODUCT.department");
        //columnList.add("PRODUCT.InterModelRetailIntro");

        ////////////////////////////////////////////////////////////////////////
        // RUNS THE QUERY
        ////////////////////////////////////////////////////////////////////////
        //if(runReport){
        //get the appropriate LineplanConfig:
            
            Hashtable lpconfig = new Hashtable();
                 
            Hashtable criteria = new Hashtable();
            criteria.putAll(lpconfig);
            Hashtable criteria2 = new Hashtable();
            criteria2.putAll(lpconfig);
            LCSSeasonQuery query = new LCSSeasonQuery();
            Vector sorts = new Vector();
            sorts.add("productName");
            sorts.add("skuName");
            query.setSortOverride(sorts);
                      
            Map reqMap = (Map) request.getAttribute("requestMapVal");    
            String strDivisionValSelect=(String)request.getParameter("selectedDivision");
           
            if(FormatHelper.hasContent(strDivisionValSelect))
              {
               
                  boolean hasValue = false;
                  FlexType flexType=FlexTypeCache.getFlexTypeFromPath("Product");
                     
                for(Map.Entry entry : (Set<Map.Entry>)reqMap.entrySet()) {
                  Object key = entry.getKey();
                  Object value = entry.getValue();              
                  hasValue = false;
                 
                  if(value instanceof List) { // This is for multi list type filters              
                    hasValue = ((List)value).size() > 0 ? true : false;              
                  } else { // for other type              
                    hasValue = FormatHelper.hasContent((String)value);                                
                  }
                  if(hasValue) {
                  
                      if("OTHER_PRODUCT_CLASSIFICATION_KEY".equals(key)) {
                          
                          String otherProductClassificationFilter=flexType.getAttribute("lfRootProductOtherProdClass").getVariableName();
                          lpconfig.put("LCSPRODUCT_"+otherProductClassificationFilter, MOAHelper.toMOAString((Collection)value));
                          strOtherProductClassificationFilterVal=MOAHelper.toMOAString((Collection)value);                      
                      } else if("DIVISION_KEY".equals(key)) {     
                          String divisionFilter=flexType.getAttribute(LFDashboardReportConstants.STR_DIVISION).getVariableName();
                          lpconfig.put("LCSPRODUCT_"+divisionFilter, value.toString());
                          strDivFilterVal=value.toString();

                      } else if("PRODUCT_CATEGORY".equals(key)) {
                          String productCategoryFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_CATEGORY).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+productCategoryFilter, MOAHelper.toMOAString((Collection)value));
                        strProdCatFilterVal=MOAHelper.toMOAString((Collection)value);

                      }
                      else if("BRAND_KEY".equals(key)) {  
                      String brandFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_BRAND).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+brandFilter, MOAHelper.toMOAString((Collection)value));
                        strBrandFilterVal=MOAHelper.toMOAString((Collection)value);
                        
                      }
                      else if("LICENSOR_KEY".equals(key)) {   
                          String licensorFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_LICENSOR).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+licensorFilter, MOAHelper.toMOAString((Collection)value));
                        strLicensorFilterVal=MOAHelper.toMOAString((Collection)value);
                       
                      }
                      else if("CUSTOMER_RETAILER_KEY".equals(key)) {  
                        String customerFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_CUSTOMER).getVariableName();                  
                        lpconfig.put("LCSPRODUCT_"+customerFilter, MOAHelper.toMOAString((Collection)value));
                        strCustomerFilterVal=MOAHelper.toMOAString((Collection)value);
                       
                      }
                      else if("PROPERTY_KEY".equals(key)) {  
                        String propertyFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_PROPERTY).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+propertyFilter, MOAHelper.toMOAString((Collection)value));
                        strPropertyFilterVal= MOAHelper.toMOAString((Collection)value);
                     
                      }
                      else if("PRODUCT_SUB_CATEGORY".equals(key)) { 
                       String productSubCategoryFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_SUBCATEGORY).getVariableName(); 
                        lpconfig.put("LCSPRODUCT_"+productSubCategoryFilter, MOAHelper.toMOAString((Collection)value));
                        strProdSubCatFilterVal= MOAHelper.toMOAString((Collection)value);
                       
                      }
                      else if("SEARCH_PRODUCT_STATUS_KEY".equals(key)) { 
                        String statusFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_STATUS).getVariableName();
                        lpconfig.put("LCSSEASONPRODUCTLINK_"+statusFilter, MOAHelper.toMOAString((Collection)value));
                        strProductStatusFilterVal= MOAHelper.toMOAString((Collection)value);
                        
                      }
                      else if("SEARCH_SIZE_GROUP_KEY".equals(key)) {  
                        String sizeFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_SIZE_GRP).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+sizeFilter, MOAHelper.toMOAString((Collection)value));
                        strSizeGroupFilterVal=MOAHelper.toMOAString((Collection)value);
                       
                      }
                      else if("YEAR_KEY_PRODUCT".equals(key)) { 
                        FlexType flexTypeYear=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_PROD_APP_HIERARCHY);                    
                        String yearFilter=flexTypeYear.getAttribute(LFDashboardReportConstants.STR_PROD_SEASON_YEAR).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+yearFilter, MOAHelper.toMOAString((Collection)value));
                        strYearFilterVal=MOAHelper.toMOAString((Collection)value);
                       
                      }
                      else if("SEASON_KEY_PRODUCT".equals(key)) { 
                        FlexType flexTypeSeason=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_PROD_APP_HIERARCHY);
                        String seasonFilter=flexTypeSeason.getAttribute(LFDashboardReportConstants.STR_PROD_SEASON).getVariableName();                  
                        lpconfig.put("LCSPRODUCT_"+seasonFilter, MOAHelper.toMOAString((Collection)value));
                        strSeasonFilterVal=MOAHelper.toMOAString((Collection)value);
                       
                        }
                      }    
                  }
                 
                   data = new LCSSeasonQuery().runSeasonProductReport(season, includeSKUs, lpconfig);
                }
              
             else {
                
                  boolean hasValue1 = false;
                  FlexType flexType=FlexTypeCache.getFlexTypeFromPath("Product");
                 
                  String strDivSelected=(String)request.getParameter("SelectedDivisionCriteriadashboard");
                  String strProdCatSelected=(String)request.getParameter("SelectedProductCatCriteriadashboard");
                  String strBrandSelelcted=(String)request.getParameter("SelectedBrandCriteriadashboard");
                  String strLicensorSelected=(String)request.getParameter("SelectedLicensorCriteriadashboard");
                  String strCustomerSelected=(String)request.getParameter("SelectedCustomerCriteriadashboard");
                  String strPropertySelected=(String)request.getParameter("SelectedPropertyCriteriadashboard"); 
                  String strProdSubCatSelected=(String)request.getParameter("SelectedProdSubCatCriteriadashboard");
                  String strProdStatusSelected=(String)request.getParameter("SelectedProdStatusCriteriadashboard");
                  String strSizeGroupSelected=(String)request.getParameter("SelectedSizeGroupCriteriadashboard");
                  String strYearSelected=(String)request.getParameter("SelectedYearCriteriadashboard");
                  String strSeasonSelected=(String)request.getParameter("SelectedSeasonCriteriadashboard");
                  String strOtherProductClassificationSelected = (String)request.getParameter("SelectedOtherProductClassficationCriteriadashboard");
                  
                  
                  System.out.println(".... retain val ..... " + strSeasonSelected);
                  System.out.println(".... retain val ..... " + strOtherProductClassificationSelected);

                Map map1 = retainVal(strDivSelected,strProdCatSelected,strBrandSelelcted,strLicensorSelected,
                strCustomerSelected,strPropertySelected,strProdSubCatSelected,strProdStatusSelected,strSizeGroupSelected,
                strYearSelected,strSeasonSelected , strOtherProductClassificationSelected);
                   
                for(Map.Entry entry : (Set<Map.Entry>)map1.entrySet()) {
                  Object key = entry.getKey();
                  Object value = entry.getValue();              
                  hasValue1 = false;
               
                  if(value instanceof List) { // This is for multi list type filters              
                    hasValue1 = ((List)value).size() > 0 ? true : false;              
                  } else { // for other type              
                    hasValue1 = FormatHelper.hasContent((String)value);                                
                  }
                  if(hasValue1) {
                    
                       if("OTHER_PRODUCT_CLASSIFICATION_KEY".equals(key)) {
                          String otherProductClassificationFilter=flexType.getAttribute("lfRootProductOtherProdClass").getVariableName();
                          lpconfig.put("LCSPRODUCT_"+otherProductClassificationFilter, MOAHelper.toMOAString((Collection)value));
                          strOtherProductClassificationFilterVal=MOAHelper.toMOAString((Collection)value);
                          
                          System.out.println("\n\n\n\n strOtherProductClassificationFilterVal + " + "LCSPRODUCT_"+otherProductClassificationFilter + "...." +MOAHelper.toMOAString((Collection)value) + "\n\n\n\n");
                      
                      } else if("DIVISION_KEY".equals(key)) {     
                       String divisionFilter=flexType.getAttribute(LFDashboardReportConstants.STR_DIVISION).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+divisionFilter, value.toString());
                        strDivFilterVal=value.toString();
                     
                      } else if("PRODUCT_CATEGORY".equals(key)) {
                          String productCategoryFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_CATEGORY).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+productCategoryFilter, MOAHelper.toMOAString((Collection)value));
                        strProdCatFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                      else if("BRAND_KEY".equals(key)) {  
                      String brandFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_BRAND).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+brandFilter, MOAHelper.toMOAString((Collection)value));
                        strBrandFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                      else if("LICENSOR_KEY".equals(key)) {   
                          String licensorFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_LICENSOR).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+licensorFilter, MOAHelper.toMOAString((Collection)value));
                        strLicensorFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                      else if("CUSTOMER_RETAILER_KEY".equals(key)) {  
                        String customerFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_CUSTOMER).getVariableName();                  
                        lpconfig.put("LCSPRODUCT_"+customerFilter, MOAHelper.toMOAString((Collection)value));
                        strCustomerFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                      else if("PROPERTY_KEY".equals(key)) {  
                        String propertyFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_PROPERTY).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+propertyFilter, MOAHelper.toMOAString((Collection)value));
                        strPropertyFilterVal= MOAHelper.toMOAString((Collection)value);
                      }
                      else if("PRODUCT_SUB_CATEGORY".equals(key)) { 
                       String productSubCategoryFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_SUBCATEGORY).getVariableName(); 
                        lpconfig.put("LCSPRODUCT_"+productSubCategoryFilter, MOAHelper.toMOAString((Collection)value));
                        strProdSubCatFilterVal= MOAHelper.toMOAString((Collection)value);
                      }
                      else if("SEARCH_PRODUCT_STATUS_KEY".equals(key)) { 
                      
                        String statusFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_STATUS).getVariableName();
                        lpconfig.put("LCSSEASONPRODUCTLINK_"+statusFilter, MOAHelper.toMOAString((Collection)value));
                        strProductStatusFilterVal= MOAHelper.toMOAString((Collection)value);
                      }
                      else if("SEARCH_SIZE_GROUP_KEY".equals(key)) {  
                        String sizeFilter=flexType.getAttribute(LFDashboardReportConstants.STR_PRODUCT_SIZE_GRP).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+sizeFilter, MOAHelper.toMOAString((Collection)value));
                        strSizeGroupFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                      else if("YEAR_KEY_PRODUCT".equals(key)) { 
                        FlexType flexTypeYear=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_PROD_APP_HIERARCHY);                    
                        String yearFilter=flexTypeYear.getAttribute(LFDashboardReportConstants.STR_PROD_SEASON_YEAR).getVariableName();
                        lpconfig.put("LCSPRODUCT_"+yearFilter, MOAHelper.toMOAString((Collection)value));
                        strYearFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                      else if("SEASON_KEY_PRODUCT".equals(key)) { 
                        FlexType flexTypeSeason=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_PROD_APP_HIERARCHY);
                        String seasonFilter=flexTypeSeason.getAttribute(LFDashboardReportConstants.STR_PROD_SEASON).getVariableName();                  
                        lpconfig.put("LCSPRODUCT_"+seasonFilter, MOAHelper.toMOAString((Collection)value));
                        strSeasonFilterVal=MOAHelper.toMOAString((Collection)value);
                      }
                    }     
                  } 
               
                  data = new LCSSeasonQuery().runSeasonProductReport(season, includeSKUs, lpconfig);    
               }            
                          
            ////////////////////////////////////
            // GET THE CALENDAR INFORMATION: SKU
            ////////////////////////////////////
            PreparedQueryStatement statement = new PreparedQueryStatement();
            statement.appendFromTable(LCSCalendarTask.class);
            statement.appendFromTable(LCSCalendar.class);
            statement.appendFromTable(LCSSeasonProductLink.class);
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "estEndDate"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "endDate"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "name"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendar.class, "ownerReference.key.id"));
            statement.appendAndIfNeeded();
            statement.appendJoin(new QueryColumn(LCSCalendarTask.class, "calendarReference.key.id"), new QueryColumn(LCSCalendar.class, "thePersistInfo.theObjectIdentifier.id"));
            statement.appendJoin(new QueryColumn(LCSCalendar.class, "ownerVersion"), new QueryColumn(LCSSeasonProductLink.class, "seasonProductRevision"));
            statement.appendJoin(new QueryColumn(LCSCalendar.class, "ownerReference.key.id"), new QueryColumn(LCSSeasonProductLink.class, "skuMasterId"));
            statement.appendAndIfNeeded();
            statement.appendCriteria(new Criteria(new QueryColumn(LCSSeasonProductLink.class, "effectOutDate"), "", Criteria.IS_NULL));
            statement.appendAndIfNeeded();
            statement.appendCriteria(new Criteria(new QueryColumn(LCSSeasonProductLink.class, "seasonRevId"), "?", Criteria.EQUALS), new Long(FormatHelper.getNumericVersionIdFromObject(season)) );

            SearchResults skuResults = LCSQuery.runDirectQuery(statement);

            /////////////////////////////////////////
            // GET THE CALENDAR INFORMATION: PRODUCT
            /////////////////////////////////////////
            statement = new PreparedQueryStatement();
            
            //Custom code to read Keys from constant file.
            FlexType flexTypeBO=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_BO_CA_CI_HIERARCHY);
            String seasonProdRev=flexTypeBO.getAttribute(LFDashboardReportConstants.STR_BO_LF_SEASONPRODREV).getVariableName();
            String calInstanceID=flexTypeBO.getAttribute(LFDashboardReportConstants.STR_BO_CALENDAR_INSTANCE).getVariableName();
            String seasonID=flexTypeBO.getAttribute(LFDashboardReportConstants.STR_BO_SEASON).getVariableName();
            
            //Custom code to read the database columns dynamically irrespective of environment.
            FlexType type_CalendarTask=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_CALENDARTASK);
            String completed_date=type_CalendarTask.getAttribute(LFDashboardReportConstants.STR_COMPLETED_DATE).getVariableName();
            String target_date=type_CalendarTask.getAttribute(LFDashboardReportConstants.STR_TARGET_DATE).getVariableName();
			
			 String order_No=type_CalendarTask.getAttribute(LFDashboardReportConstants.STR_ORDER_NO).getVariableName();
			
            
            FlexType type_Calendar=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_CALENDAR);
            String calendar_status=type_Calendar.getAttribute(LFDashboardReportConstants.STR_CALENDAR_STATUS).getVariableName();
            String calendar_name_key=type_Calendar.getAttribute(LFDashboardReportConstants.STR_CALENDAR_NAME_KEY).getVariableName();
            
            FlexType bo_type=FlexTypeCache.getFlexTypeFromPath(LFDashboardReportConstants.STR_BO_TYPE);
            String cal_bo_status=bo_type.getAttribute(LFDashboardReportConstants.STR_BO_CA_CI_STATUS).getVariableName();
            
            statement.appendFromTable(LCSCalendarTask.class);
            statement.appendFromTable(LCSCalendar.class);
            statement.appendFromTable(LCSLifecycleManaged.class);
            statement.appendFromTable(LCSSeasonProductLink.class);
            
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "estEndDate"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "endDate"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "name"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, completed_date));
            statement.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, target_date));
            statement.appendSelectColumn(new QueryColumn(LCSCalendar.class, calendar_status));
            statement.appendSelectColumn(new QueryColumn(LCSLifecycleManaged.class, cal_bo_status));
            statement.appendSelectColumn(new QueryColumn(LCSCalendar.class, "ownerReference.key.id"));
            statement.appendSelectColumn(new QueryColumn(LCSCalendar.class, calendar_name_key));
            statement.appendSelectColumn(new QueryColumn(LCSSeasonProductLink.class, "skuMasterId"));
            statement.appendSelectColumn(new QueryColumn(LCSSeasonProductLink.class, "roleAObjectRef.key.id"));
            statement.appendSelectColumn(new QueryColumn(LCSSeasonProductLink.class, "productSeasonRevId"));
            statement.appendSelectColumn(new QueryColumn(LCSLifecycleManaged.class, "thePersistInfo.theObjectIdentifier.id"));
            
            statement.appendAndIfNeeded();
            statement.appendJoin(new QueryColumn(LCSCalendarTask.class, "calendarReference.key.id"), new QueryColumn(LCSCalendar.class, "thePersistInfo.theObjectIdentifier.id"));
            statement.appendAndIfNeeded();
            statement.appendJoin(new QueryColumn(LCSCalendar.class, "ownerReference.key.id"), new QueryColumn(LCSLifecycleManaged.class, "thePersistInfo.theObjectIdentifier.id"));
            statement.appendAndIfNeeded();
            statement.appendJoin(new QueryColumn(LCSSeasonProductLink.class, "productSeasonRevId"), new QueryColumn(LCSLifecycleManaged.class, seasonProdRev));
            statement.appendAndIfNeeded();            
            statement.appendCriteria(new Criteria(new QueryColumn(LCSSeasonProductLink.class, "effectOutDate"), ((String)null), Criteria.IS_NULL)); 
            statement.appendAndIfNeeded();
            statement.appendCriteria(new Criteria(new QueryColumn(LCSSeasonProductLink.class, "seasonRevId"), "?", Criteria.EQUALS), new Long(season.getBranchIdentifier()));
            statement.appendAndIfNeeded();
            statement.appendCriteria(new Criteria(new QueryColumn(LCSSeasonProductLink.class, "seasonLinkType"), "?", Criteria.EQUALS), "PRODUCT");
            statement.appendAndIfNeeded();
            statement.appendCriteria(new Criteria(new QueryColumn(LCSCalendar.class, calendar_status), "?", Criteria.EQUALS), "active");
            statement.appendAndIfNeeded();
            statement.appendCriteria(new Criteria(new QueryColumn(LCSLifecycleManaged.class, cal_bo_status), "?", Criteria.EQUALS), "active");
            
            statement.appendSortBy(new QueryColumn(LCSSeasonProductLink.class, "productSeasonRevId"));
            statement.appendSortBy(new QueryColumn(LCSLifecycleManaged.class, "thePersistInfo.theObjectIdentifier.id"));
            statement.appendSortBy(new QueryColumn(LCSCalendarTask.class, "estEndDate"));            
            
            SearchResults productResults = LCSQuery.runDirectQuery(statement);
            
            /////////////////////////////////////////
            // Code to get THE CALENDAR INFORMATION for SEASON
            /////////////////////////////////////////
          
            Long seasonID_Long =(Long)season.getBranchIdentifier();   
            String strSeason_OID =Long.toString(seasonID_Long);
            
            FlexType boFlexType = FlexTypeCache.getFlexTypeFromPath(LFCalendarConstants.CALENDARINSTANCESTYPESTR);
            FlexType calendarFlexType = FlexTypeCache.getFlexTypeFromPath("Calendar");
            String flexTypeId = FormatHelper.getNumericObjectIdFromObject(boFlexType);
            String nameAtt = boFlexType.getAttribute("name").getVariableName();
            
            PreparedQueryStatement pqs = new PreparedQueryStatement();
            
            pqs.appendFromTable(LCSLifecycleManaged.class);
            pqs.appendFromTable(LCSCalendar.class);
            pqs.appendFromTable(LCSCalendarTask.class);
            
            pqs.appendSelectColumn(new QueryColumn(LCSLifecycleManaged.class, calInstanceID));
            pqs.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "name"));
	
			 pqs.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, order_No));
		
            pqs.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "targetDate"));
            pqs.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, target_date));   
            pqs.appendSelectColumn(new QueryColumn(LCSLifecycleManaged.class, "thePersistInfo.theObjectIdentifier.id"));
            pqs.appendSelectColumn(new QueryColumn(LCSLifecycleManaged.class, boFlexType.getAttribute("name").getVariableName()));
            pqs.appendSelectColumn(new QueryColumn(LCSLifecycleManaged.class, calInstanceID));
            pqs.appendAndIfNeeded();
            pqs.appendCriteria(new Criteria(new QueryColumn("LCSLifecycleManaged", "FLEXTYPEIDPATH"), "%" + flexTypeId + "%", Criteria.LIKE));
            
            pqs.appendAndIfNeeded();
            pqs.appendCriteria(new Criteria(new QueryColumn(LCSLifecycleManaged.class, boFlexType.getAttribute(LFCalendarConstants.LFCALENDARBOSEASONKEY).getVariableName()), strSeason_OID, Criteria.EQUALS));	
            pqs.appendAndIfNeeded();
            pqs.appendCriteria(new Criteria(new QueryColumn(LCSLifecycleManaged.class, boFlexType.getAttribute(LFCalendarConstants.LFCALENDARBOTYPEKEY).getVariableName()), LFCalendarConstants.LFCALENDARBOSEASONCALTYPE, Criteria.EQUALS));	

            pqs.appendAndIfNeeded();
            pqs.appendCriteria(new Criteria(new QueryColumn(LCSLifecycleManaged.class, boFlexType.getAttribute(LFCalendarConstants.LFCALENDARBOSTATUSKEY).getVariableName()), LFCalendarConstants.LFCALENDARBOSTATUSACTIVEVAL, Criteria.EQUALS));	
            
            pqs.appendJoin(new QueryColumn("LCSCalendar", "idA3A5"), new QueryColumn(LCSLifecycleManaged.class, "thePersistInfo.theObjectIdentifier.id"));
            pqs.appendAndIfNeeded();
            pqs.appendJoin(new QueryColumn(LCSCalendarTask.class, "calendarReference.key.id"), new QueryColumn(LCSCalendar.class, "thePersistInfo.theObjectIdentifier.id"));
            pqs.appendAndIfNeeded();
            pqs.appendSelectColumn(new QueryColumn(LCSCalendar.class, calendarFlexType.getAttribute("name").getVariableName()));
            pqs.appendAndIfNeeded();
            pqs.appendSelectColumn(new QueryColumn(LCSCalendarTask.class, "targetDate"));
            pqs.appendAndIfNeeded();                       
            pqs.appendCriteria(new Criteria(new QueryColumn(LCSCalendarTask.class, "firstTask"), "1", Criteria.NOT_EQUAL_TO));
            pqs.appendSortBy(new QueryColumn(LCSLifecycleManaged.class, calInstanceID), "ASC"); // 
            //pqs.appendSortBy(new QueryColumn(LCSCalendarTask.class, "name")); 	
			pqs.appendSortBy(new QueryColumn(LCSCalendarTask.class, order_No)); 

			      
            SearchResults seasonResults = LCSQuery.runDirectQuery(pqs);
            
            Collection seasonTasks = seasonResults.getResults();

            Vector taskList = new Vector();
			
            Map seasonTaskMap = new HashMap();
            Iterator seasonIter = seasonTasks.iterator();
            FlexObject calRow;
            String dateString;
            Date calDate;
            Date seasonDate;
            String taskName;
            String calendarName;
            String calID = "";
            String num1 = "", oldNum1 = "";
            
            while(seasonIter.hasNext()){
                calRow = (FlexObject) seasonIter.next();
                num1 = calRow.getString("LCSLifecycleManaged."+calInstanceID.toUpperCase());
                
                if(!oldNum1.equals(num1) && !"".equals(oldNum1)) {
                  break;
                }

                dateString = calRow.getString("LCSCALENDARTASK."+target_date.toUpperCase());
                dateString = FormatHelper.applyFormat(dateString, FormatHelper.DATE_ONLY_OLD_CALENDAR_STRING_FORMAT);
                seasonDate = FormatHelper.parseDate(dateString + " GMT","yyyy-MM-dd HH:mm:ss.S z");
                taskName = calRow.getString("LCSCALENDARTASK.NAME");

           if(FormatHelper.hasContent(taskName))
            {
              seasonTaskMap.put(taskName, seasonDate);
              taskList.add(taskName);
              taskNamesList.add(taskName);
              column = new com.lcs.wc.client.web.TableColumn();
              column.setDisplayed(true);
              column.setHeaderLabel(taskName);
              column.setHeaderAlign("center");
              column.setTableIndex(taskName);
              column.setWrapping(false);
              column.setFormatHTML(false);
              column.setColumnWidth(""+FormatHelper.formatWithPrecision((90.0d/seasonTasks.size()),0)+"%");
              columnMap.put(taskName, column);
              columnList.add(taskName);
         
          if(column != null)
            {
              StringBuffer buffer = new StringBuffer();
              buffer.append("<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"1\" align=\"center\">");
              buffer.append("   <tr width=\"100%\">");
  
              buffer.append("     <td valign=\"bottom\" class=\"RPT_DATE_LABEL\">" + FormatHelper.encodeForHTMLContent(column.getHeaderLabel()) + "</td>");
              buffer.append("   </tr>");
              buffer.append("   <tr valign=\"bottom\">");
              buffer.append("     <td weight=\"100%\" align=\"center\" valign=\"bottom\" class=\"RPT_DATE\">" + dateString + "</td>");
              buffer.append("   </tr>");
              buffer.append("</table>");
              column.setHeaderLabel(buffer.toString());
              column.setFormat("UNFORMATTED_HTML");
            }
          }      
          oldNum1 = num1;
      }     
        com.lcs.wc.client.web.TableColumn potentialColumn;
        Iterator it = columnList.iterator();
        String key = "";
        while(it.hasNext()){
            key = (String)it.next();
            potentialColumn = (com.lcs.wc.client.web.TableColumn) columnMap.get(key);
            if(potentialColumn != null){
                columns.add(potentialColumn);
                if(key.indexOf(".") > 0){
                    key = key.substring(key.indexOf(".") + 1, key.length());
                }
                attList.add(key);
            }
        }
      
          // ADD THE EVENTS TO THE PROPER DATE ROWS..
          Set taskNames = new HashSet();
          String safeColor = "#7F8272";
          String alertColor = "red";
          String warningColor = "#FFEA61";
          String completedColor = "black";
		 


          Date curDate = new Date();
          String currentCalId = "", oldCalId = "", curProductId = "", oldProductId = "";
          Iterator calIter = productResults.getResults().iterator();
          Collection newdataFragment = null;
          int calCount = 1;
          Map<String, String> productCalMap = new HashMap<String, String>();
                 
          while(calIter.hasNext()) 
          {
            calRow = (FlexObject) calIter.next();
            curProductId = calRow.getString("LCSSeasonProductLink.productSeasonRevId");
            currentCalId = calRow.getString("LCSLifecycleManaged.ida2a2");
            productCalMap.put(currentCalId, curProductId);
            if(!currentCalId.equals(oldCalId) && !"".equals(oldCalId))
            {
              calCount++;              
            }
            if(!curProductId.equals(oldProductId) && !"".equals(oldProductId)) {              
              Collection dataFragment = FlexObjectUtil.filter(data, "LCSSEASONPRODUCTLINK.PRODUCTSEASONREVID", oldProductId);
              for(int loop = 1; loop < calCount - 1; loop++) {
                newdataFragment = FlexObjectUtil.cloneFlexObjects(dataFragment);
                data.addAll(newdataFragment);
                newdataFragment.clear();
              }
              calCount = 1;
            }
            oldProductId = curProductId;
            oldCalId = currentCalId;
          }
          
          Collection dataFragment = FlexObjectUtil.filter(data, "LCSSEASONPRODUCTLINK.PRODUCTSEASONREVID", curProductId);
          for(int loop = 1; loop < calCount; loop++)
          {
            newdataFragment = FlexObjectUtil.cloneFlexObjects(dataFragment);
            data.addAll(newdataFragment);
            newdataFragment.clear();
          }         
         int count = 0;
         String oldValue = "", key1 = "", value = "";
         for(Map.Entry<String, String> entry : productCalMap.entrySet())
         {  
          key1 = entry.getKey();
          value = entry.getValue();
          Collection dataFragment2 = FlexObjectUtil.filter(data, "LCSSEASONPRODUCTLINK.PRODUCTSEASONREVID", value);
            if(dataFragment2 != null && dataFragment2.size() > 0)
            {
              FlexObject productDataObj = (FlexObject) dataFragment2.toArray()[0];
              productDataObj.put("LCSLifecycleManaged.ida2a2", key1);   
              boolean changed = finalData.add(productDataObj.clone());
            }
         }     
             FlexObject row1 = null;  
             Iterator dataIter1 = finalData.iterator();  
            
             ArrayList list=new ArrayList();
             String strVal="";
             while(dataIter1.hasNext())
             {
               row1 = (FlexObject) dataIter1.next();
               FlexType flexTypeDropped=FlexTypeCache.getFlexTypeFromPath("Product");
               String droppedCount=flexTypeDropped.getAttribute(LFDashboardReportConstants.STR_PRODUCT_STATUS).getVariableName();
                if("dropped".equalsIgnoreCase(row1.getString("LCSSEASONPRODUCTLINK."+droppedCount))) 
                {
                  strVal=row1.getString("LCSSEASONPRODUCTLINK.PRODUCTSEASONREVID");
                  if(!list.contains(strVal)){
                     list.add(strVal);
                     dropCount++;
                    }   
                }
             }
          
           ///////////////////////////////////////////////
            // FLATTEN THE RESULTS INTO ROWS OF EVENTS
            ///////////////////////////////////////////////
          
            String SPL_roleA_id = IntrospectionHelper.getTableAndColumn(LCSSeasonProductLink.class, "roleAObjectRef.key.id");
            // HASH THE LINE PLAN DATA BY SKU ID
            Iterator dataIter = finalData.iterator();
            Hashtable dataSKUHash = new Hashtable();
            FlexObject row;
            while(dataIter.hasNext()){
                row = (FlexObject) dataIter.next();
                 dataSKUHash.put(row.getString("LCSLifecycleManaged.ida2a2"), row);
            }
          
          // Validate Product calendars against seasonal calendar
          // red - task is late
          // yellow - task is due in five days
          // grey - task is not late or not due in five days
          // black bold - task is complete
          calIter = productResults.getResults().iterator();
                 
          oldProductId = "";
          curProductId = "";
          oldCalId = "";
          currentCalId = "";

          while(calIter.hasNext())  {
              calRow = (FlexObject) calIter.next();
                      
              row = (FlexObject) dataSKUHash.get(calRow.getString("LCSLifecycleManaged.ida2a2"));
              if(row == null) continue;
              
              currentCalId = calRow.getString("LCSLifecycleManaged.ida2a2");
                
              taskName = calRow.getString("LCSCALENDARTASK.NAME");
              
              if("- Start of Calendar -".equals(taskName)) {
                continue;
              }   
             
              Date cCompletedDate=null; 
              dateString = calRow.getString("LCSCALENDARTASK."+completed_date.toUpperCase());
              seasonDate = (Date) seasonTaskMap.get(taskName);
				
              //When COMPLETED DATE for the task is present - Display it on black bold
		
              if(FormatHelper.hasContent(dateString)) {
               
                dateString = FormatHelper.applyFormat(dateString, FormatHelper.DATE_STRING_FORMAT);
                //calDate = FormatHelper.parseDate(dateString + " GMT","yyyy-MM-dd HH:mm:ss.S z");
             
                if(seasonDate != null){
                  //int comp = seasonDate.compareTo(calDate);
             
                  if(FormatHelper.hasContent(dateString)){
                    dateString = "<font color='"+completedColor+"'><b>" + dateString + "</b>&nbsp;<img align=\"middle\" src=\""+WT_IMAGE_LOCATION+"/checked.gif\"></font>";
                  } 
                }
              } else {
                   
                  Date cTargetDate=null;
                  
                   //Target Date  
                  dateString = calRow.getString("LCSCALENDARTASK."+target_date.toUpperCase());
                  Calendar targetCal = Calendar.getInstance();
                  
                  if(FormatHelper.hasContent(dateString)){
                      cTargetDate=(Date)FormatHelper.parseDate(dateString + " GMT","yyyy-MM-dd HH:mm:ss.S z");
                    
                    
                      targetCal.setTime(cTargetDate);
                      targetCal.set(Calendar.HOUR, 0);
                      targetCal.set(Calendar.HOUR_OF_DAY, 0);
                      targetCal.set(Calendar.MINUTE, 0);
                      targetCal.set(Calendar.SECOND, 0);
                      targetCal.set(Calendar.MILLISECOND, 0); 
                      
                   
                      dateString = FormatHelper.applyFormat(dateString, FormatHelper.DATE_ONLY_OLD_CALENDAR_STRING_FORMAT);
                      calDate = FormatHelper.parseDate(dateString + " GMT","yyyy-MM-dd HH:mm:ss.S z");
                      
                      
                       Calendar curCal = Calendar.getInstance();
                      
                      curCal.setTime(curDate);
                      curCal.set(Calendar.HOUR, 0);
                      curCal.set(Calendar.HOUR_OF_DAY, 0);
                      curCal.set(Calendar.MINUTE, 0);
                      curCal.set(Calendar.SECOND, 0);
                      curCal.set(Calendar.MILLISECOND, 0); 
                      curDate = curCal.getTime();
                      
                      
                      TimeUnit timeunit = TimeUnit.DAYS;
                      long diffInMillies = curDate.getTime() - targetCal.getTime().getTime();
                      long days = timeunit.convert(diffInMillies, TimeUnit.MILLISECONDS);
                      
                      if (days > 0) {
                        //System.out.println("diffInDays >5==>"+diffInDays);
                        dateString = "<font color='"+alertColor+"'>" + dateString + "</font>";
                      }
                      if (days > -5 && days <= 0) { 
                        dateString = "<font color='"+warningColor+"'>" + dateString + "</font>";
                      }

                      if (days <= -5) {
                        dateString = "<font color='"+safeColor+"'>" + dateString + "</font>";
                      }  
                  }

              }                  
              curProductId = calRow.getString("LCSSeasonProductLink.productSeasonRevId");
              currentCalId = calRow.getString("LCSLifecycleManaged.ida2a2");
                           
              row.put(taskName, dateString);
              calendarName = calRow.getString("LCSCALENDAR.ATT1");
              calID=calRow.getString("LCSLifecycleManaged.IDA2A2");
              row.put("CALENDAR_NAME", calendarName);
              row.put("LCSLifecycleManaged.IDA2A2", calID);        
               oldCalId = currentCalId;
          }	
            Iterator dit = dataSKUHash.keySet().iterator();
		
            String task;
            String taskVal;

            boolean alertsOnly = false;
            if("true".equals(request.getParameter("alertsOnly"))){
                alertsOnly = true;
            }
            boolean foundDate = false;
            while(dit.hasNext()){
                row = (FlexObject)dataSKUHash.get(dit.next());
                foundDate = false;
                for(int i = taskList.size() - 1; i >= 0 ; i--){
                    task = (String)taskList.elementAt(i);
                    taskVal = (String)row.getString(task);
                    if(FormatHelper.hasContent(taskVal)){
                        if(taskVal.indexOf(alertColor) > -1){
                            //row.put("PRODUCT.HEALTHSTATUS", redGif);
                            totalCount++;
                            alerts++;
                        } else if(taskVal.indexOf(warningColor) > -1) {
							//row.put("PRODUCT.HEALTHSTATUS", yellowGif);
							totalCount++;
							warnings++;
						} else {
                            if(alertsOnly){
                                data.remove(row);
                                //finalData.remove(row);
                            } else {
                                //row.put("PRODUCT.HEALTHSTATUS", greenGif);
                                totalCount++;
                                safe++;
                            }
                        }
                        foundDate = true;
                        break;
                    }
                }
                if(!foundDate){
                    if(alertsOnly){
                        data.remove(row);
                        //finalData.remove(row);
                    }
                    else{
                        //row.put("PRODUCT.HEALTHSTATUS", greenGif);
                        totalCount++;
                        safe++;
                   }
                }
            }
    }
    /////////////////////////////
    //Filters init
    /////////////////////////////
    attributeMap = productType.getAttributeMap(productType.getAllAttributes(), "PRODUCT.");
    attributeMap.putAll(sourcingType.getAttributeMap(sourcingType.getAllAttributes(), "SOURCING."));
    attributeMap.putAll(costSheetType.getAttributeMap(costSheetType.getAllAttributes(), "COSTSHEET."));

    
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVASCRIPT //////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script type="text/javascript" src="<%=URL_CONTEXT%>/lfusa/javascript/calendar/LFCalendarCustom.js"></script>
<script>


  function viewCalendar(oid,oid_BO){
  

	if ("VIEW_SEASON_DASHBOARDS" == document.MAINFORM.activity.value){
		document.MAINFORM.returnActivity.value = document.MAINFORM.activity.value;
	} else {
		document.MAINFORM.returnActivity.value = '';
	}
   var y=oid_BO;
    document.MAINFORM.returnAction.value = document.MAINFORM.action.value;
    document.MAINFORM.returnOid.value = document.MAINFORM.oid.value;
    document.MAINFORM.oid.value = oid;
    document.MAINFORM.action.value = 'INIT';
    document.MAINFORM.activity.value = 'VIEW_SEASON_PRODUCT_LINK';
    document.MAINFORM.tabPage.value = 'CALENDARS';
    addHiddenElement("businessObjectId", y);
     submitForm();
}

function viewCalendar1(activiy,id,calendarsListElement){
  var x=calendarsListElement;
  	addHiddenElement("businessObjectId", x);
	document.MAINFORM.activity.value = activiy;
	document.MAINFORM.oid.value = id;
	submitForm();
}
	function hideAllColumns(TableId, columnCount, prefix) {		
		
		
		var showThumbs = document.MAINFORM.showThumbs;
		var startFrom = 4;
		if(showThumbs.value != 'null') {
			startFrom = 5;
		}
		for (var i=startFrom; i<=columnCount; i++) {
			
		
			var checkBoxName = '';
			if(hasContent(prefix)){
				checkBoxName = 'HC' + prefix + i;
			}
			else{
				checkBoxName = 'HC'+i;
			}
			var checkbox = document.getElementsByName(checkBoxName);
			if (checkbox[0].value == 'true') {
				checkbox[0].checked = false;
				toggleColumn(checkbox[0], TableId);
			}
		}
	}
	function showAllColumns(TableId, columnCount, prefix) {
		var showThumbs = document.MAINFORM.showThumbs;
		var startFrom = 4;
		if(showThumbs.value != 'null') {
			startFrom = 5;
		}
	
		for (i=startFrom; i<=columnCount; i++) {
			var checkBoxName = '';
			if(hasContent(prefix)){
				checkBoxName = 'HC' + prefix + i;
			}
			else{
				checkBoxName = 'HC'+i;
			}

			var checkbox = document.getElementsByName(checkBoxName);

			if (checkbox[0].value != 'true') {
				checkbox[0].checked = true;
				toggleColumn(checkbox[0], TableId);
			}
		
	}
}

    function runReport(){
        if(!validate()){
            return;
        }
        document.MAINFORM.tabPage.value = '<%=CALENDAR_DASHBOARD_TAB%>';
        submitForm();
    }
    function validate(){

        return true;
    }
</script>

<%
    String fontSize = FormatHelper.format(request.getParameter("reportFontSize"));
    if(!FormatHelper.hasContent(fontSize)){
        fontSize = "8pt";
    }

	ArrayList tableColumns = new ArrayList();
	tableColumns.add(totalLabel);
	tableColumns.add(numOfAlerts +" "+"Late");
	tableColumns.add("% "+"Late");
	tableColumns.add(numOfAlerts +" "+"Ready");
	tableColumns.add("% "+"Ready");
	tableColumns.add(numOnSchedule +" "+"Safe");
	tableColumns.add("% "+"Safe");
	tableColumns.add(numOfDroppedProducts +" ");
	
	ArrayList tableData = new ArrayList();
	
%>

<%--@@@ changed font weight, font family and removed background image from date box in header @@@--%>
<style type="text/css">

    .RPT_TBL {
        font-family: "Segoe UI", Tahoma, Arial, Helvetica, sans-serif;
        text-decoration: normal;
        font-size: <%= fontSize %>;
        font-weight: normal;
        font-style: normal;
        color: #464646;
        background-color: #FFFFFF;
        padding-left : 6;
        padding-right : 6;
        padding-top: 4;
        vertical-align: text-top;
    }

    .RPT_TBD {
        font-family: "Segoe UI", Tahoma, Arial, Helvetica, sans-serif;
        text-decoration: normal;
        font-size: <%= fontSize %>;
        font-weight: normal;
        font-style: normal;
        color: #464646;
        background-color: #EEEEEE;
        padding-left : 6;
        padding-right : 6;
        padding-top: 4;
        vertical-align: text-top;

    }

    .RPT_BACKGROUND{
        vertical-align: top;
    }

    .RPT_HEADER {
        font-family: "Segoe UI", Tahoma, Arial, Helvetica, sans-serif;
        text-decoration: underline;
        font-size: <%= fontSize %>;
        font-weight: bold;
        font-style: normal;
        color: #464646;
        background-color: #FFFFFF;
        padding-left : 4;
        padding-right : 4;
        vertical-align: text-bottom;
    }

    .RPT_DATE_LABEL {
        font-family: "Segoe UI", Tahoma, Arial, Helvetica, sans-serif;
        text-decoration: normal;
        font-size: <%= fontSize %>;
        font-weight: bold;
        font-style: normal;
        color: #464646;
        obackground-color: #FFFFFF;
        padding-left : 4;
        padding-right : 4;
		padding:2px;
        vertical-align: text-bottom;
    }

    .RPT_DATE {
        font-family: "Segoe UI", Tahoma, Arial, Helvetica, sans-serif;
        text-decoration: normal;
        font-size: <%= fontSize %>;
        font-weight: bold;
        font-style: normal;
        color: #464646;
        padding-left : 2;
        padding-right : 2;
        vertical-align: text-bottom;
        border-color: #d0d0d0;
        border-width: 1px;
        border-style: solid;
        padding: 2px;
        background-color: #FFFFD6;
        <%-- background-image: url(<%= URL_CONTEXT%>/images/header_yellow.jpg); --%>
    }
    .RPT_GROUPSEPARATOR {
        font-size: <%= fontSize %>;
    }
    .RPT_TOTALS {
        font-family: "Segoe UI", Tahoma, Arial, Helvetica, sans-serif;
        font-weight: normal;
        font-size: <%= fontSize %>;
        padding-left : 6;
        padding-right : 6;
        padding-top: 4;
    }

</style>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////////// HTML ////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input type="hidden" name="runReport" value="<%= request.getParameter("runReport") %>">
<input type="hidden" id="SelectedDivisionCriteriadashboard" name="SelectedDivisionCriteriadashboard" value="<%=strDivFilterVal%>">
<input type="hidden" id="SelectedProductCatCriteriadashboard" name="SelectedProductCatCriteriadashboard" value="<%=strProdCatFilterVal%>">
<input type="hidden" id="SelectedBrandCriteriadashboard" name="SelectedBrandCriteriadashboard" value="<%=strBrandFilterVal%>">
<input type="hidden" id="SelectedLicensorCriteriadashboard" name="SelectedLicensorCriteriadashboard" value="<%=strLicensorFilterVal%>">
<input type="hidden" id="SelectedCustomerCriteriadashboard" name="SelectedCustomerCriteriadashboard" value="<%=strCustomerFilterVal%>">
<input type="hidden" id="SelectedPropertyCriteriadashboard" name="SelectedPropertyCriteriadashboard" value="<%=strPropertyFilterVal%>">
<input type="hidden" id="SelectedProdSubCatCriteriadashboard" name="SelectedProdSubCatCriteriadashboard" value="<%=strProdSubCatFilterVal%>">
<input type="hidden" id="SelectedProdStatusCriteriadashboard" name="SelectedProdStatusCriteriadashboard" value="<%=strProductStatusFilterVal%>">
<input type="hidden" id="SelectedSizeGroupCriteriadashboard" name="SelectedSizeGroupCriteriadashboard" value="<%=strSizeGroupFilterVal%>">
<input type="hidden" id="SelectedYearCriteriadashboard" name="SelectedYearCriteriadashboard" value="<%=strYearFilterVal%>">
<input type="hidden" id="SelectedSeasonCriteriadashboard" name="SelectedSeasonCriteriadashboard" value="<%=strSeasonFilterVal%>">
<input type="hidden" id="SelectedOtherProductClassficationCriteriadashboard" name="SelectedOtherProductClassficationCriteriadashboard" value="<%=strOtherProductClassificationFilterVal%>">




<!-- PLM-24 UAT Change Request. Disabling the option to show the below table.-->

<!--

<table>
	<tr>
    	<td class="BORDER">
    		<table width="100%" cellspacing="1" cellpadding="0">
	      		<tr>
					<td class="TABLEBACKGROUND">
						<table width="100%" border="0" cellspacing="1" cellpadding="1">
							<tr>
								<td class="TABLESUBHEADER" align="center" nowrap=true><b><%= totalLabel %></b></td>
                				<td class="TABLESUBHEADER" align="center" nowrap=true><b><%= numOfAlerts %></b>&nbsp;<%= redGif %></td>
                				<td class="TABLESUBHEADER" align="center" nowrap=true><b>%</b>&nbsp;<%= redGif %></td>
                				<td class="TABLESUBHEADER" align="center" nowrap=true><b><%= numOfAlerts %></b>&nbsp;<%= yellowGif %></td>
                				<td class="TABLESUBHEADER" align="center" nowrap=true><b>%</b>&nbsp;<%= yellowGif %></td>
                				<td class="TABLESUBHEADER" align="center" nowrap=true><b><%= numOnSchedule %></b>&nbsp;<%= greenGif %></td>
                				<td class="TABLESUBHEADER" align="center" nowrap=true><b>%</b>&nbsp;<%= greenGif %></td>
								<td class="TABLESUBHEADER" align="center" nowrap=true><b><%= numOfDroppedProducts %></b>&nbsp;<%= blackGif %></td>
            				</tr>
			
							<tr>
								<td nowrap class="TBLD" align="center"><%= totalCount %></td>
								 <% 
								 
								 tableData.add(totalCount); 
								 
								 %>
				
								<td nowrap class="TBLD" align="center"><%= alerts %></td>
								<% 
								 
								 tableData.add(alerts); 
								 
								 %>
                				<%
                    				double calc = (double)alerts/ (double)totalCount;
                				%>				
								<td nowrap class="TBLD" align="center"><%= formatCalc(calc) %>&nbsp;%</td>
								
								<% 
								 
								 tableData.add(calc); 
								 
								 %>
				
								<td nowrap class="TBLD" align="center"><%= warnings %></td>
								<% 
								 
								 tableData.add(warnings); 
								 
								 %>
								
                				<%
                    				 calc = (double)warnings/ (double)totalCount;
                				%>
								<td nowrap class="TBLD" align="center"><%= formatCalc(calc) %>&nbsp;%</td>
								<% 
								 
								 tableData.add(calc); 
								 
								 %>
				
								<td nowrap class="TBLD" align="center"><%= safe %></td>
								<% 
								 
								 tableData.add(safe); 
								 
								 %>
                				<%
                    				 calc = (double)safe/(double)totalCount;
                				%>
								<td nowrap class="TBLD" align="center"><%= formatCalc(calc) %>&nbsp;%</td>
								<% 
								 
								 tableData.add(calc); 
								 
								 %>
								
								<td nowrap class="TBLD" align="center"><%= dropCount %></td>
								<% 
								 
								 tableData.add(dropCount); 
								 
								 %>
								
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

-->

<!-- PLM-24 ENDS-->

&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td>
			<table border="0" cellspacing="2" cellpadding="2">
				<tr>
					<%
						Hashtable levels = new Hashtable();
       					levels.put(FootwearApparelFlexTypeScopeDefinition.PRODUCT_LEVEL, productLabel);
						levels.put(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SKU_LEVEL, skuLabel);
					%>
					<%--Dhiraj Commented to remove Levels from the UI--%>
      				<%-- = fg.createDropDownListWidget(levelLabel, levels, "linePlanLevel", linePlanLevel, "", false, false, null, null, null) --%>
                    
					<td nowrap class="FORMLABEL">&nbsp;&nbsp;&nbsp;<%= showThumbnailsLabel %></td>
                    <td nowrap><input name="showThumbsBox" type=checkbox onClick="handleCheckBox(this, document.MAINFORM.showThumbs)" <% if(showThumbs){ out.print("checked"); } %>></td>
    				<td class="button">
        				&nbsp;<a class="button" href="javascript:runReport()"><%= runLabel %></a>
   					</td>
					<%= getActionButtons()%>
					<td>
						<%
							String showThumbsBox = request.getParameter("showThumbsBox");
						%>
						<%=drawCustomHideableColumns(showThumbsBox, taskNamesList, tg) %>
					</td>
					<td>
					  
					<jsp:include page="<%=subURLFolder+ EXCEL_GENERATOR_SUPPORT_PLUGIN %>" flush="true">
                           	<jsp:param name="csv" value="<%= csv %>" />
                            	<jsp:param name="showThumbs" value="<%= showThumbs %>" />
                          	<jsp:param name="reportDisplayName" value="ViewBom" />
                           	<jsp:param name="reportName" value="ViewBom" />
                          	<jsp:param name="iconOnly" value="true"/>
                       	</jsp:include>
					</td>
				</tr>
			</table>
		</td>
	</tr>
<tr><td style="page-break-before: always"></td></tr>
<tr>
    <td>
        <%      
            Vector groupBy = new Vector();
            String reportGroupBy = FormatHelper.format(request.getParameter("reportGroupBy"));
            if(FormatHelper.hasContent(reportGroupBy)){
                groupBy.add((TableColumn)columnMap.get(reportGroupBy));
            }
            String secondaryGroupBy = FormatHelper.format(request.getParameter("secondaryGroupBy"));
            if(FormatHelper.hasContent(secondaryGroupBy)){
                groupBy.add((TableColumn)columnMap.get(secondaryGroupBy));
            }
            String tertiaryGroupBy = FormatHelper.format(request.getParameter("tertiaryGroupBy"));
            if(FormatHelper.hasContent(tertiaryGroupBy)){
                groupBy.add((TableColumn)columnMap.get(tertiaryGroupBy));
            }

           // PLM-24 UAT Change Request. Disabling the below line  to not show health status.
           
              //groupBy.add((TableColumn)columnMap.get("PRODUCT.HEALTHSTATUS"));
            
           // PLM-24 UAT Change Request ENDS.
           
            if(FootwearApparelFlexTypeScopeDefinition.PRODUCT_SKU_LEVEL.equals(linePlanLevel)) {
				TableColumn column = (TableColumn)columnMap.get("PRODUCT.productName");
				column.setDisplayed(false);
				groupBy.add(column);
			}
			tg.setSpaceBetweenGroups(false);
      tg.setGroupByColumns(groupBy);
			
        %>		
        <%= tg.drawTable(finalData, columns, null, false, false) %>
    </td>
</tr>
</table>
<script>
var tablevar = document.getElementById("TBLT<%=tg.getTableId()%>");
	tablevar.id="customEditorHideShow";

</script>
<%
    
	if (columns != null) {
		Collection exportColumns = new Vector();
		Iterator columnIter = columns.iterator();
		while(columnIter.hasNext()) {
			TableColumn column = (TableColumn) columnIter.next();
			String headerLabel = column.getHeaderLabel();
			headerLabel = FormatHelper.replaceString(headerLabel,"&nbsp;"," ");
			headerLabel = headerLabel.replaceAll("\\<.*?>","");
			column.setHeaderLabel(headerLabel);
			column.setBgColorIndex(column.getTableIndex()+"_DATECOLOR");

			exportColumns.add(column);
		}
		request.setAttribute("columns", exportColumns);

		Collection exportGroupByColumns = new Vector();
		columnIter = groupBy.iterator();
		while(columnIter.hasNext()) {
			TableColumn column = (TableColumn) columnIter.next();
			String headerLabel = column.getHeaderLabel();
			headerLabel = FormatHelper.replaceString(headerLabel,"&nbsp;"," ");
			headerLabel = headerLabel.replaceAll("\\<.*?>","");
			column.setHeaderLabel(headerLabel);
			
			exportGroupByColumns.add(column);
		}
		request.setAttribute("groupByColumns", exportGroupByColumns);
	}
  
	if (finalData != null) {
		Collection exportData = new Vector();
		Iterator dataIter = finalData.iterator();
		while(dataIter.hasNext()) 
    {
			FlexObject rowObj = (FlexObject) dataIter.next();
      Iterator keyIter = rowObj.keySet().iterator();
			while(keyIter.hasNext())
      {
				String key = (String) keyIter.next();
				String value = (String) rowObj.get(key);
        if(FormatHelper.hasContent(value)) 
        {
         if(!"PRODUCT.HEALTHSTATUS".equals(key))
         {
          value = FormatHelper.replaceString(value,"&nbsp;"," ");
          value = value.replaceAll("\\<.*?>","");
         }
         else {
            if(value.contains("greenAlert"))
            {              
              value = "8CFA82";
            }
            else if (value.contains("failure_fixable_16x16")) 
            {
              value = "FF0000";
            } else if (value.contains("warning_16x16")) 
            {
              value = "E0CC11";
            }
          }
        }       
				rowObj.put(key,value);
			}
      rowObj.put("PRODUCT.BLANKKEY", "");      
			exportData.add(rowObj);
		}
       	request.setAttribute("data", exportData);
   	}
    request.setAttribute("tableColumns", tableColumns);
	request.setAttribute("tableData", tableData);
		
%>
<table>
    <tr>
        <td>
            <div id='hiddenExcelDiv'>
            	<jsp:include page="<%=subURLFolder+ EXCEL_GENERATOR_SUPPORT_PLUGIN %>" flush="true">
            		<jsp:param name="csv" value="<%= csv %>" />
            		<jsp:param name="reportDisplayName" value="Season Dashboard Report" />
            		<jsp:param name="reportName" value="Season Dashboard Report" />
            	</jsp:include>

            </div>
        </td>
    </tr>
    <script>
        hideDiv('hiddenExcelDiv');

    </script>
</table>