<%-- Copyright (c) 2002 Aptavis Technologies Corporation   All Rights Reserved --%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="
	   		com.lcs.wc.db.*,
			com.lcs.wc.foundation.*,
			com.lcs.wc.util.*,
			com.lcs.wc.client.web.*,
			com.lcs.wc.season.*,
			com.lcs.wc.product.*,
			com.lcs.wc.color.*,
			com.lcs.wc.material.*,
			com.lcs.wc.part.*,
			com.lcs.wc.document.*,
			com.lcs.wc.sourcing.*,
			com.lcs.wc.flexbom.*,
			com.lcs.wc.supplier.*,
			wt.part.WTPartMaster,
			wt.fc.*,
			wt.util.*,
            wt.org.*,
            wt.workflow.definer.*,
            wt.workflow.engine.*,
            wt.workflow.work.*,
            java.util.*,
			java.text.*,
			com.lcs.wc.flextype.FlexTypeCache,
			com.lcs.wc.flextype.FlexType,
			com.lfusa.wc.reports.*,
			com.lfusa.wc.reports.query.*,
			com.lcs.wc.client.web.TableGenerator,
			org.apache.commons.lang.StringUtils,
			com.lcs.wc.foundation.LCSQuery,
			com.lcs.wc.foundation.LCSLifecycleManaged,
			org.apache.commons.lang.StringUtils,
			com.lcs.wc.flextype.AttributeAccessRule,
			com.lcs.wc.flextype.FlexTypeQuery,
			wt.org.WTUser,
			com.lcs.wc.util.LCSLog,
			com.lfusa.wc.reports.query.LFReportConstants,
			com.lfusa.wc.reports.LFProductAdoptionReport,
			com.lfusa.wc.calendar.LFDashboardReportConstants,
			com.lfusa.wc.reports.query.bomreport.LFBOMReportQuery,
			com.lfusa.wc.calendar.LFCalendarQuery"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="ftg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="exl" scope="request" class="com.lcs.wc.client.web.ExcelGenerator" />
<jsp:useBean id="seasonModel" scope="request" class="com.lcs.wc.season.LCSSeasonClientModel" />

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////// JAVASCRIPT //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
String activity1 = request.getParameter("activity");

%>
<%!
	public static final boolean DEBUG;
	String runReportLabel = "Run Report";
	
	static 
	{
		DEBUG = LCSProperties
				.getBoolean("rfa.lfusa.jsp.reports.LFCalendarReportSearchCritiriaPage.verbose");
	}
	// List of Hierarchies
	public static final String SEASON_APP_PATH = LCSProperties.get("com.lcs.wc.reports.seasonapppath");
	public static final String SEASON_ACC_PATH = LCSProperties.get("com.lcs.wc.reports.seasonaccpath");
	public static final String SEASON_HOME_PATH = LCSProperties.get("com.lcs.wc.reports.seasonhomepath");
  public static final String BO_LICENSOR_PATH = LCSProperties.get("com.lcs.wc.reports.BOLicensorPath");
	public static final String BO_PROPERTY_PATH = LCSProperties.get("com.lcs.wc.reports.BOPropertyPath");
	public static final String BO_CUSTOMER_PATH = LCSProperties.get("com.lcs.wc.reports.BOCustomerPath");
	public static final String BO_BRAND_PATH = LCSProperties.get("com.lcs.wc.reports.BOBrandPath");
	public static final String BO_PRODUCT_CATEGORY_PATH = LCSProperties.get("com.lcs.wc.reports.BOProductCategoryPath");
	public static final String PRODUCT_PATH = LCSProperties.get("com.lcs.wc.reports.productTypePath");
	public static final String PRODUCT_APP_PATH = LCSProperties.get("com.lcs.wc.reports.productappPath");
	public static final String PRODUCT_ACC_PATH = LCSProperties.get("com.lcs.wc.reports.productaccPath");
	public static final String PRODUCT_HOME_PATH = LCSProperties.get("com.lcs.wc.reports.producthomePath");
  public static final String BO_SIZE_GROUP_PATH = LCSProperties.get("com.lcs.wc.reports.BOSizeGroupPath");
	// List of keys
	public static final String SEASON_TYPE_KEY = LCSProperties.get("com.lcs.wc.reports.seasonTypeKey");
	public static final String YEAR_KEY = LCSProperties.get("com.lcs.wc.reports.yearKey");
	public static final String BO_NAME_KEY = LCSProperties.get("com.lcs.wc.reports.BONameKey");
	public static final String PRODUCT_STATUS_KEY =LCSProperties.get("com.lcs.wc.reports.productStatusKey");
	public static final String divisionKey = "division";
	public static final String seasonTypeKey = "seasonType";
	public static final String yearKey = "year";
	public static final String productStatusKey = "productStatus";
	public static final String productCategoryKey = "productCategory";
	public static final String propertyKey = "property";
	public static final String licensorKey = "licensor";
	public static final String brandKey = "brand";
	public static final String customerKey = "customer";
	public static final String seasonDataKey = "seasonData";
  public static final String sizeGrpKey ="productGenSizeGrp";
  public static final String season_Type_Key = LFDashboardReportConstants.STR_PROD_SEASON;
  public static final String year_Type_Key = LFDashboardReportConstants.STR_PROD_SEASON_YEAR;
	public static final String productSubCategoryKey = "productSubCategory";
	public static final String dueByDateFrom = "dueByDateFrom";
	public static final String dueByDateTo="dueByDateTo";
	public static final String descriptionKey ="fRootProductLongDesc";
  public static final String taskLibraryKey = "taskLibrary";
  public static final String otherProductClassificationKey = "otherProductClassification";
  
	

	//List of Report Constants
	public static final String generateExcelToolTip = LCSProperties.get("rfa.lfusa.jsp.reports.LFUserTaskAssessmentReport.generateExcelToolTip");
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
	public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String URL_CONTEXT1 = "/Windchill";

   public  String fields = LCSProperties.get("rfa.lfusa.jsp.reports.UserTaskAssessmentReport");
	 
	StringTokenizer keys=new StringTokenizer(fields, ",");
	
	String displayNames[] = new String[keys.countTokens()];
	public   static  String divisionDisplayLabel = " ";
	public   static String seasonNameDisplayLabel = " ";
	public   static String brandDisplayLabel = " ";
	public   static  String customerDisplayLabel = " ";
	public   static String productCategoryDisplayLabel = " ";
	public   static String propertyDisplayLabel = " ";
	public   static String licensorDisplayLabel = " ";
	public   static String productStatusDisplayLabel = " ";
	public   static String sizeGroupLabel = " ";
	public   static String prodcutSubCategoryDisplayLabel = " ";
	
	public  String reportType = "My Work";
	public static final String seasonTypeDisplayLabel = "Season";
	public static final String seasonYearDisplayLabel = "Season Year";
	public static final String seasonTypeDisplayLabelDashboard = "Season (Product Level) ";
	public static final String seasonYearDisplayLabelDashboard = "Year (Product Level)";
	
	public  static String  nameDisplay = "Name";
	public static String productReference ="Product Reference#";
	public static String plmProduct  = "PLM Product#";
	public static String description ="Description";
	public static String duebyDateFromLabel = "Due By Date (From)";
	public static String duebyDateToLabel ="Due By Date(To)";
	public static String strDivision="";
 
%>

<%
     //Start -- Added code for defaulting division.
     LCSSeason season = seasonModel.getBusinessObject();
	 if(FormatHelper.hasContent(activity1))
		{
		if(season!=null && activity1.equalsIgnoreCase("VIEW_SEASON_DASHBOARDS"))
			{
			 strDivision=(String)season.getValue(LFDashboardReportConstants.STR_DIVISION);
			}
		}
    //End-- Code for defaulting division.
      int k=0;	 
	  while(keys.hasMoreElements())
	 {
	      String key=(String)keys.nextElement();		  
		   displayNames[k] = key;		  
		   k++;
	  }
		divisionDisplayLabel =displayNames[0];
		seasonNameDisplayLabel =displayNames[1];
		brandDisplayLabel  =displayNames[2];
		customerDisplayLabel =displayNames[3];
		productCategoryDisplayLabel =displayNames[4];
		propertyDisplayLabel =displayNames[5];
		licensorDisplayLabel =displayNames[6];
		productStatusDisplayLabel =displayNames[7];
		sizeGroupLabel  =displayNames[8];
		prodcutSubCategoryDisplayLabel =displayNames[9]; 
%>

<%
		LFProductAdoptionReport reportObj = new LFProductAdoptionReport();
		LFProductAdoptionReport.initializeAllSeasonMap();	
	/************************ FOR DIVISION ********************************/
	Map DivisionSingleListMap = reportObj.getDivisionMap();
	/************************ FOR SEASON NAME********************************/
	Map seasondata = new HashMap();
	Vector seasonDataOrder = new Vector();
	
	String strVendor = "";
	StringBuilder strVendorBuilder = new StringBuilder("");
	/*********** FOR SEASON **********************/
	Collection seasonTypeValues = new ArrayList();
	Vector seasonTypeorder = new Vector();
	Map seasontype = new HashMap();
	
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_APP_PATH))){
		seasontype =reportObj.getSingleListMap(SEASON_APP_PATH,SEASON_TYPE_KEY);
		seasonTypeorder = reportObj.getOrderSet(SEASON_APP_PATH,SEASON_TYPE_KEY);
		seasonTypeValues = seasontype.values();
	}
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_ACC_PATH))){
		seasontype = reportObj.getSingleListMap(SEASON_ACC_PATH,SEASON_TYPE_KEY);
		seasonTypeorder = reportObj.getOrderSet(SEASON_ACC_PATH,SEASON_TYPE_KEY);
		seasonTypeValues = seasontype.values();
	}
	if (ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_HOME_PATH))){
		seasontype = reportObj.getSingleListMap(SEASON_HOME_PATH,SEASON_TYPE_KEY);
		seasonTypeorder = reportObj.getOrderSet(SEASON_HOME_PATH,SEASON_TYPE_KEY);
		seasonTypeValues = seasontype.values();
	}
	if (ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_HOME_PATH)) 
    && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_ACC_PATH)) 
    && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_APP_PATH))){
		Map seasontypeapp =  reportObj.getSingleListMap(SEASON_APP_PATH,SEASON_TYPE_KEY);
		Map seasontypeacc =  reportObj.getSingleListMap(SEASON_ACC_PATH,SEASON_TYPE_KEY);
		Map seasontypehome = reportObj.getSingleListMap(SEASON_HOME_PATH,SEASON_TYPE_KEY);
		seasontype.putAll(seasontypeapp);
		seasontype.putAll(seasontypeacc);
		seasontype.putAll(seasontypehome);
		seasonTypeValues = seasontype.values();
	}

	/************************ FOR SEASON YEAR ********************************/
	Collection yearValues = new ArrayList();
	Vector yearorder = new Vector();
	Map year = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_APP_PATH))){
		year =reportObj.getSingleListMap(SEASON_APP_PATH,YEAR_KEY);
		yearorder = reportObj.getOrderSet(SEASON_APP_PATH,YEAR_KEY);
		yearValues = year.values();
	}
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_ACC_PATH))){
		year = reportObj.getSingleListMap(SEASON_ACC_PATH,YEAR_KEY);
		yearorder = reportObj.getOrderSet(SEASON_ACC_PATH,YEAR_KEY);
		yearValues = year.values();
	}
	if (ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_HOME_PATH))){
		year = reportObj.getSingleListMap(SEASON_HOME_PATH,YEAR_KEY);
		yearorder = reportObj.getOrderSet(SEASON_HOME_PATH,YEAR_KEY);
		yearValues = year.values();
	}
	if (ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_ACC_PATH)) 
    && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_APP_PATH))
    && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_HOME_PATH))){
		Map yearapp =  reportObj.getSingleListMap(SEASON_APP_PATH,YEAR_KEY);
		Map yearacc =  reportObj.getSingleListMap(SEASON_ACC_PATH,YEAR_KEY);
		Map yearhome = reportObj.getSingleListMap(SEASON_HOME_PATH,YEAR_KEY);
		year.putAll(yearapp);
		year.putAll(yearacc);
		year.putAll(yearhome);
		yearValues = year.values();
	}

	/*************  FOR PRODUCT STATUS*************/
	Collection prodstatusValues = new ArrayList();
	Vector productStatusOrder = new Vector();
	Map productstatus = new HashMap();

	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_APP_PATH))){
		productstatus =reportObj.getSingleListMap(PRODUCT_APP_PATH,PRODUCT_STATUS_KEY);
		productStatusOrder = reportObj.getOrderSet(PRODUCT_APP_PATH,PRODUCT_STATUS_KEY);
		prodstatusValues = productstatus.values();
	}
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_ACC_PATH))){
		productstatus = reportObj.getSingleListMap(PRODUCT_ACC_PATH,PRODUCT_STATUS_KEY);
		productStatusOrder = reportObj.getOrderSet(PRODUCT_ACC_PATH,PRODUCT_STATUS_KEY);
		prodstatusValues = productstatus.values();
	}
	if (ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_HOME_PATH))){
		productstatus = reportObj.getSingleListMap(PRODUCT_HOME_PATH,PRODUCT_STATUS_KEY);
		productStatusOrder = reportObj.getOrderSet(PRODUCT_HOME_PATH,PRODUCT_STATUS_KEY);
		prodstatusValues = productstatus.values();
	}
	if (ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_ACC_PATH)) 
    && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_APP_PATH)) 
    && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(SEASON_HOME_PATH))){
		Map statusapp =  reportObj.getSingleListMap(PRODUCT_APP_PATH,PRODUCT_STATUS_KEY);
		Map statusacc =  reportObj.getSingleListMap(PRODUCT_ACC_PATH,PRODUCT_STATUS_KEY);
		Map statushome = reportObj.getSingleListMap(PRODUCT_HOME_PATH,PRODUCT_STATUS_KEY);
		productstatus.putAll(statusapp);
		productstatus.putAll(statusacc);
		productstatus.putAll(statushome);
		prodstatusValues = productstatus.values();
	}

	/************************ FOR PRODUCT_CATEGORY ********************************/
	Vector productCategoryOrder = new Vector();
	Map productcategory = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(BO_PRODUCT_CATEGORY_PATH))){
		productcategory =reportObj.getSingleListMap(BO_PRODUCT_CATEGORY_PATH,LFReportConstants.PRODUCT_CATEGORY_KEY);
		productCategoryOrder = reportObj.getOrderSet(BO_PRODUCT_CATEGORY_PATH,LFReportConstants.PRODUCT_CATEGORY_KEY);
	}

	/************************ FOR LICENSOR ********************************/
	Collection licensorTypeValues = new ArrayList();
	Vector licensorTypeorder = new Vector();
	Map licensortype = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(BO_LICENSOR_PATH))){
		licensortype= reportObj.getTextAttValue(BO_LICENSOR_PATH,BO_NAME_KEY);
		Set s = licensortype.entrySet();
		Iterator itr1=s.iterator();   
	   while(itr1.hasNext())   
	   { 
		   Map.Entry m=(Map.Entry)itr1.next();  
	       licensorTypeorder.add(m.getValue());
	       licensorTypeValues.add(m.getValue());
	   }  
	}
	/************************ FOR PROPERTY ********************************/
	Collection propertyTypeValues = new ArrayList();
	Vector propertyTypeorder = new Vector();
	Map propertytype = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(BO_PROPERTY_PATH))){
		propertytype= reportObj.getTextAttValue(BO_PROPERTY_PATH,BO_NAME_KEY);
		Set s2 = propertytype.entrySet();
		Iterator itr2=s2.iterator();   
		while(itr2.hasNext())   
		{   
			Map.Entry m2=(Map.Entry)itr2.next();  
			propertyTypeorder.add(m2.getValue());
			propertyTypeValues.add(m2.getValue());
		} 
	}
	/************************ FOR BRAND ********************************/
	Collection brandTypeValues = new ArrayList();
	Vector brandTypeorder = new Vector();
	Map brandtype = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(BO_BRAND_PATH))){
		brandtype= reportObj.getTextAttValue(BO_BRAND_PATH,BO_NAME_KEY);
		Set s3 = brandtype.entrySet();
		Iterator itr3=s3.iterator();   
		while(itr3.hasNext())   
		{   
			Map.Entry m3=(Map.Entry)itr3.next();
			brandTypeorder.add(m3.getValue());
			brandTypeValues.add(m3.getValue());
		} 
	} 
  /************************ FOR TASK ********************************/
	Collection taskLibraryValues = new ArrayList();
	Vector taskLibraryorder = new Vector();
	Map taskLibraryType = new HashMap();
  Map updatedtaskLibraryType = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("Business Object\\Calendar\\Calendar Task Names Library"))){
		taskLibraryType= reportObj.getTextAttValue("Business Object\\Calendar\\Calendar Task Names Library",BO_NAME_KEY);
		Set taskset = taskLibraryType.entrySet();
    Set taskKeys = taskLibraryType.keySet();
    
    Iterator keysItr = taskKeys.iterator();
    while(keysItr.hasNext()){
      String key = (String) keysItr.next();
      LCSLifecycleManaged bo = (LCSLifecycleManaged) LCSQuery.findObjectById("OR:com.lcs.wc.foundation.LCSLifecycleManaged:" + key);
      if(bo != null) {
        String taskLibraryStatus = (String) bo.getValue("lfStatus");
        if(taskLibraryStatus != null && FormatHelper.hasContent(taskLibraryStatus) && taskLibraryStatus.equalsIgnoreCase("active")) {
            taskLibraryorder.add((String) taskLibraryType.get(key));
            taskLibraryValues.add((String) taskLibraryType.get(key));
            updatedtaskLibraryType.put(key,taskLibraryType.get(key));
        }
      }
    }
  } 
  
	/************************ FOR CUSTOMER ********************************/
	Collection customerTypeValues = new ArrayList();
	Vector customerTypeorder = new Vector();
	Map customertype = new HashMap();
	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(BO_CUSTOMER_PATH))){
		customertype= reportObj.getTextAttValue(BO_CUSTOMER_PATH,BO_NAME_KEY);
		Set cus = customertype.entrySet();
		Iterator itr4=cus.iterator();   
		while(itr4.hasNext())   
		{   
			Map.Entry m1=(Map.Entry)itr4.next();
			customerTypeorder.add(m1.getValue());
			customerTypeValues.add(m1.getValue());
		}  
	}

	/*************  FOR SIZE GROUP*************/
	Vector sizeGroupOrder = new Vector();
	Map sizegroup = new HashMap();

	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(BO_SIZE_GROUP_PATH)))
	{
		sizegroup =reportObj.getSingleListMap(BO_SIZE_GROUP_PATH,LFReportConstants.SIZE_GROUP_KEY);
		sizeGroupOrder = reportObj.getOrderSet(BO_SIZE_GROUP_PATH,LFReportConstants.SIZE_GROUP_KEY);
	}
	
	/*************For ProductSubCategory********************/
	
	Vector productSubCategoryOrder = new Vector();
	Map productSubCategoryMap = new HashMap();

	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_PATH)))
	{
		productSubCategoryMap =reportObj.getSingleListMap(PRODUCT_PATH,LFReportConstants.PRODUCT_SUB_CATEGORY_KEY);
		productSubCategoryOrder = reportObj.getOrderSet(PRODUCT_PATH,LFReportConstants.PRODUCT_SUB_CATEGORY_KEY);
	}
  
  
  	/*************  FOR OTHER PRODUCT CLASSIFICATION *************/
	Vector otherProductClassificationOrder = new Vector();
	Map otherProductClassification = new HashMap();

	if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath(PRODUCT_PATH)))
	{
		otherProductClassification =reportObj.getSingleListMap(PRODUCT_PATH,"lfRootProductOtherProdClass");
		otherProductClassificationOrder = reportObj.getOrderSet(PRODUCT_PATH,"lfRootProductOtherProdClass");
	}

	%>

<%!
	public static final Map getRequestMap(HttpServletRequest request){
	Map requestMap = new HashMap();

	/************************ FOR DIVISION ********************************/
	String divisionValue = (String)request.getParameter("division");
	String DIVISION_KEY = LFReportConstants.SEARCH_DIVISION;

	/************************ FOR LICENSOR ********************************/
	String licensorValue = (String) request.getParameter("licensor");
	String LICENSOR_KEY = LFReportConstants.SEARCH_LICENSOR;
	Collection licensorList = MOAHelper.getMOACollection(licensorValue);
	List licensorValues = new ArrayList(licensorList);
	if(DEBUG)
		LCSLog.debug("licensorValues: "+licensorValues);

	/************************ FOR PROPERTY ********************************/
	String propertyValue = (String) request.getParameter("property");
	String PROPERTY_KEY = LFReportConstants.SEARCH_PROPERTY;
	Collection propertyList = MOAHelper.getMOACollection(propertyValue);
	List propertyValues = new ArrayList(propertyList);
	if(DEBUG)
		LCSLog.debug("propertyValues: "+propertyValues);
	
	/************************ FOR CUSTOMER ********************************/
	String customerValue = (String) request.getParameter("customer");
	String CUSTOMER_RETAILER_KEY = LFReportConstants.SEARCH_CUSTOMER;
	Collection customerList = MOAHelper.getMOACollection(customerValue);
	List customerValues = new ArrayList(customerList);
	if(DEBUG)
		LCSLog.debug("customerValues: "+customerValues);
	
	/************************ FOR BRAND ********************************/
	String brandValue = (String) request.getParameter("brand");
  
	String BRAND_KEY = LFReportConstants.SEARCH_BRAND;
	Collection brandList = MOAHelper.getMOACollection(brandValue);
	List brandValues = new ArrayList(brandList);
	if(DEBUG)
		LCSLog.debug("brandValues: "+brandValues);    

	/************************ FOR SEASON DATA ********************************/
	String seasonDataValue = (String) request.getParameter("seasonData");
	String SEASON_DATA_KEY = LFReportConstants.SEARCH_SEASON_DATA;
	Collection seasonDataList = MOAHelper.getMOACollection(seasonDataValue);
	List seasonDataValues = new ArrayList(seasonDataList);
	if(DEBUG)
		LCSLog.debug("seasonDataValues: "+seasonDataValues);

	/*********************** FOR PRODUCT CATEGORY ***********************************/
	String productCategoryValue = (String) request.getParameter("productCategory");
	String PRODUCT_CATEGORY_KEY = LFReportConstants.SEARCH_PRODUCT_CATEGORY;	
	Collection productCategoryList = MOAHelper.getMOACollection(productCategoryValue);
	List productCategoryValues = new ArrayList(productCategoryList);
	if(DEBUG)
		LCSLog.debug("productCategoryValues : "+productCategoryValues);

	/*********************** FOR PRODUCT STATUS ***********************************/
	String productstatusValue = (String) request.getParameter("productStatus");
	String STATUS_KEY = LFReportConstants.SEARCH_PRODUCT_STATUS;
	Collection productStatusList = MOAHelper.getMOACollection(productstatusValue);
	List productStatusValues = new ArrayList(productStatusList);
	if(DEBUG)
		LCSLog.debug("productStatusValues : "+productStatusValues);
	
	/*********************** FOR SIZE GROUP ***********************************/
	String sizeGroupValue = (String) request.getParameter("productGenSizeGrp");
	String SIZE_GROUP_KEY = LFReportConstants.SEARCH_SIZE_GROUP;
	Collection sizeGroupList = MOAHelper.getMOACollection(sizeGroupValue);
	List sizeGroupValues = new ArrayList(sizeGroupList);
	if(DEBUG)
		LCSLog.debug("sizeGroupValues : "+sizeGroupValues);
		
			/*********************** FOR PRODUCT SUB CATEGORY ***********************************/
	String productSubGroupValue = (String) request.getParameter("productSubCategory");
	String PRODUCT_SUBCATEGORY_KEY = LFReportConstants.SEARCH_PRODUCT_SUB_CATEGORY;
	Collection productSubGroupGroupList = MOAHelper.getMOACollection(productSubGroupValue);
	List productSubGroupValues = new ArrayList(productSubGroupGroupList);
	if(DEBUG)
		LCSLog.debug("sizeGroupValues : "+sizeGroupValues);

	/********************** Request Map ********************************/
	requestMap.put(DIVISION_KEY,divisionValue);
	requestMap.put(STATUS_KEY,productStatusValues);
	requestMap.put(PRODUCT_CATEGORY_KEY,productCategoryValues);
	requestMap.put(LICENSOR_KEY,licensorValues);
	requestMap.put(CUSTOMER_RETAILER_KEY,customerValues);
	requestMap.put(PROPERTY_KEY,propertyValues);
	requestMap.put(BRAND_KEY,brandValues);
	requestMap.put(SEASON_DATA_KEY,seasonDataValues);
	requestMap.put(PRODUCT_SUBCATEGORY_KEY,productSubGroupValues);
	requestMap.put(SIZE_GROUP_KEY,sizeGroupValues);

	if(DEBUG)
			LCSLog.debug("BOM Listing Report request::"+requestMap);
	return requestMap;
}

%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////////// HTML /////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>

	<input type="hidden" name="generateExcel" value="false">
	<input type="hidden" name="flag" value="false">
  <input type="hidden" name="selectedDivision" value="<%=strDivision%>">
	<%if(FormatHelper.hasContent(request.getParameter("seasonListAjax"))){%>
		<input type="hidden" name="seasonListAjax" value='<%= request.getParameter("seasonListAjax")%>'>
	<%}else{%>
		<input type="hidden" name="seasonListAjax" value="">
	<%}%>	
	
	<table width="100%" cellspacing="10" cellpadding="2">
		<tr style="height:50px" cellspacing="10">
			<td>
				<%= tg.startGroupBorder() %>
				<%= tg.startTable() %>
				<%= tg.startGroupTitle() %>
				<%= tg.endTitle() %>
				<%= tg.startGroupContentTable() %>
      
      <% if(activity1.equals("VIEW_SEASON_DASHBOARDS") ) {%> 
			<tr>
					<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("division")!=null)
            { String divisionVal = request.getParameter("division"); %>
							
							<%= fg.createDropDownListWidget(divisionDisplayLabel,DivisionSingleListMap, divisionKey,divisionVal, "", true) %>
						<%}else{%>
							<%= fg.createDropDownListWidget(divisionDisplayLabel,DivisionSingleListMap, divisionKey,strDivision, "", true) %>
						<%}%>
					</td>
     <%}%>	 
	 
	    <% if(activity1.equals("SEASON_TASK_ASSESSMENT_REPORT") || activity1.equals("USER_TASK_ASSESSMENT_REPORT")) {%> 
			<tr>
					<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("division")!=null){ 
							String divisionVal = request.getParameter("division"); %>
							<%= fg.createDropDownListWidget(divisionDisplayLabel,DivisionSingleListMap, divisionKey,divisionVal, "javascript:addWidgetDivision()", true) %>
						<%}else{%>
							<%= fg.createDropDownListWidget(divisionDisplayLabel,DivisionSingleListMap, divisionKey,"", "javascript:addWidgetDivision()", true) %>
						<%}%>
					</td>
	    
        <% if(activity1.equals("SEASON_TASK_ASSESSMENT_REPORT") ) { %>
					<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("seasonType")!=null){ 
							String seasonTypeVal = request.getParameter("seasonType"); %>
							<%= fg.createMultiChoice(seasonTypeKey,seasonTypeDisplayLabelDashboard,seasontype,seasonTypeVal,false,null,true)%>
						<%}else{%>
							<%= fg.createMultiChoice(seasonTypeKey,seasonTypeDisplayLabelDashboard,seasontype,"",false,seasonTypeorder,true)%>
						<%}%>
					</td>

					<td>
						<%if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("year")!=null){ 
							String yearval = request.getParameter("year"); %>
							<%= fg.createMultiChoice(yearKey,seasonYearDisplayLabelDashboard,year,yearval,false,null,true)%>
						<%}else{%>
							<%= fg.createMultiChoice(yearKey,seasonYearDisplayLabelDashboard,year,"",false,yearorder,true)%>
						<%}%>
					</td>				
						<%} else if(activity1.equals("USER_TASK_ASSESSMENT_REPORT") ) { %>
            <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("seasonType")!=null){ 
							String seasonTypeVal = request.getParameter("seasonType"); %>
							<%= fg.createMultiChoice(seasonTypeKey,seasonTypeDisplayLabel,seasontype,seasonTypeVal,false,null,true)%>
						<%}else{%>
							<%= fg.createMultiChoice(seasonTypeKey,seasonTypeDisplayLabel,seasontype,"",false,seasonTypeorder,true)%>
						<%}%>
					</td>

					<td>
						<%if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("year")!=null){ 
							String yearval = request.getParameter("year"); %>
							<%= fg.createMultiChoice(yearKey,seasonYearDisplayLabel,year,yearval,false,null,true)%>
						<%}else{%>
							<%= fg.createMultiChoice(yearKey,seasonYearDisplayLabel,year,"",false,yearorder,true)%>
						<%}%>
					</td>		
            <%}%>

				</tr>
										
					
     <%}%>
		
		<% if(activity1.equals("SEASON_TASK_ASSESSMENT_REPORT") || activity1.equals("USER_TASK_ASSESSMENT_REPORT")){%>
				<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("seasonListAjax")!=null) {
							String seasonDataOptionVal = request.getParameter("seasonListAjax");
							String seasonDataVal = request.getParameter("seasonData");
							System.out.println("seasonDataVal"+seasonDataVal);
							String[] seasonDataArray = null;
							seasonDataArray = StringUtils.splitByWholeSeparator(seasonDataOptionVal, "|~*~|");
							int i = 0;
							seasondata = new HashMap();
							for (i = 0; i < seasonDataArray.length; i++) {
								String key = (String)seasonDataArray[i];
								LCSSeason season1 = (LCSSeason) LCSQuery
										.findObjectById("OR:com.lcs.wc.season.LCSSeason:"
												+ key.toString());
								String display = (String) season1.getValue(LFReportConstants.SEASON_NAME_KEY);
								seasondata.put(key, display);
							}
							if(seasonDataVal == null || seasonDataVal == ""){%>
								<%= fg.createMultiChoice(seasonDataKey,seasonNameDisplayLabel,seasondata,"",false,null,true)%>
							<%}else{%>
								<%= fg.createMultiChoice(seasonDataKey,seasonNameDisplayLabel,seasondata,seasonDataVal,true,null,true)%>
							<%}%>
						<%}else{%>
								<%= fg.createMultiChoice(seasonDataKey,"Season Name",seasondata,"",true,seasonDataOrder,true)%>
						<%}%>
				</td>
		  <%}%>	  
          <% if(activity1.equals("CALENDAR_WORKITEMS_CRITERIA")) { %>
             
                <td>   
         
                    <% if (request.getMethod().equalsIgnoreCase("POST")&& request.getParameter("flag")!=null && request.getParameter("seasonType")!=null){ 
                        String seasonTypeVal = request.getParameter("seasonType");%>
                        <%= fg.createMultiChoice(seasonDataKey,seasonTypeDisplayLabel,seasonTypeValues,seasonTypeVal,true,null,true)%>
                    <%}else{%>
                              <%= fg.createMultiChoice(seasonDataKey,seasonTypeDisplayLabel,seasonTypeValues,"",true,null,true)%>
                    <%}%>	    
                </td>
                
                 <td>
                    <% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter(year_Type_Key)!=null){ 
                    String yearTypeValues_ = request.getParameter(year_Type_Key);%>
                    <%= fg.createMultiChoice(year_Type_Key,seasonYearDisplayLabel,yearValues, yearTypeValues_,false,null,true) %>
                  <%}else{%>
                    <%= fg.createMultiChoice(year_Type_Key,seasonYearDisplayLabel,yearValues,"", false,null,true) %>
                  <%}%>	
                 </td>

			  <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("productGenSizeGrp")!=null){ 
							String sizeGrpVal = request.getParameter("productGenSizeGrp");%>
							<%= fg.createMultiChoice(sizeGrpKey,sizeGroupLabel,sizegroup, sizeGrpVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(sizeGrpKey,sizeGroupLabel,sizegroup,"", false,null,true) %>
						<%}%>	
              </td>   
                
          <%}%>	  
          
           <% if(activity1.equals("SEASON_TASK_ASSESSMENT_REPORT") || activity1.equals("USER_TASK_ASSESSMENT_REPORT")) {%>
               
            
               <td>
                  <% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("productGenSizeGrp")!=null){ 
                    String sizeGrpVal = request.getParameter("productGenSizeGrp");%>
                    <%= fg.createMultiChoice(sizeGrpKey,sizeGroupLabel,sizegroup, sizeGrpVal,false,null,true) %>
                  <%}else{%>
                    <%= fg.createMultiChoice(sizeGrpKey,sizeGroupLabel,sizegroup,"", false,null,true) %>
                  <%}%>	
                </td>   
                
          <%}%>	
          
                  
         
           <td>
            <% if(activity1.equals("VIEW_SEASON_DASHBOARDS"))
						   {%> 
              <% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter(season_Type_Key)!=null){ 
                String seasonTypeValues_ = request.getParameter(season_Type_Key);%>
                <%= fg.createMultiChoice(season_Type_Key,seasonTypeDisplayLabelDashboard,seasonTypeValues, seasonTypeValues_,false,null,false) %>
              <%}else{%>
                <%= fg.createMultiChoice(season_Type_Key,seasonTypeDisplayLabelDashboard,seasonTypeValues,"", false,null,false) %>
              <%}%>	
              <%}%>	
					</td>
          
          <td>
           <% if(activity1.equals("VIEW_SEASON_DASHBOARDS"))
						   {%> 
              <% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter(year_Type_Key)!=null){ 
                String yearTypeValues_ = request.getParameter(year_Type_Key);%>
                <%= fg.createMultiChoice(year_Type_Key,seasonYearDisplayLabelDashboard,yearValues, yearTypeValues_,false,null,false) %>
              <%}else{%>
                <%= fg.createMultiChoice(year_Type_Key,seasonYearDisplayLabelDashboard,yearValues,"", false,null,false) %>
              <%}%>	
            
					</td>
            <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("productGenSizeGrp")!=null){ 
							String sizeGrpVal = request.getParameter("productGenSizeGrp");%>
							<%= fg.createMultiChoice(sizeGrpKey,sizeGroupLabel,sizegroup, sizeGrpVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(sizeGrpKey,sizeGroupLabel,sizegroup,"", false,null,true) %>
						<%}%>	
					</td>   
              <%}%>	          
		
         
         <tr>
           <td bgcolor="#FFFFFF" style="line-height:10px;" colspan=3>&nbsp;</td>
           </tr>
        
        <% if(activity1.equals("CALENDAR_WORKITEMS_CRITERIA"))
					{%> 
         	<tr>
                <td>  
                  <% if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("lfRootProductSmartCode")!=null)
                    { 
                     String  productRefSelected = request.getParameter("lfRootProductSmartCode"); %>
                      <%=fg.createTextInput("lfRootProductSmartCode",productReference, productRefSelected, 20, 40, false, false)%> 
                     
                      <% }else{ %>
                        <%=fg.createTextInput("lfRootProductSmartCode",productReference, "", 20, 40, false, false)%> 
                      <%}%>	
                </td>
           
                <td>  
                    <% if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("lfRootProductNum")!=null)
                    { 
                      String  plmProductSelected = request.getParameter("lfRootProductNum"); %>
                      <%=fg.createTextInput("lfRootProductNum",plmProduct, plmProductSelected, 20, 40, false, false)%> 
                   
                    <% }else{ %>
                      <%=fg.createTextInput("lfRootProductNum",plmProduct, "", 20, 40, false, false)%> 
                    <%}%>	
                </td>     
						
                <td>
                  <% if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter(descriptionKey)!=null)
                    {
                    String descriptionSelected=(String)request.getParameter(descriptionKey);%>
                    <%= fg.createTextInput(descriptionKey,description, descriptionSelected,20,40,false,false) %>
                    <%} else{%>
                    <%= fg.createTextInput(descriptionKey,description, "",20,40,false,false) %>
                    
                    <%}%>
                </td>
          </tr>
        <%}%>	
          
        <tr>
        
                          
          <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("productCategory")!=null){ 
							String productCategoryVal = request.getParameter("productCategory");%>
							<%= fg.createMultiChoice(productCategoryKey,productCategoryDisplayLabel,productcategory, productCategoryVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(productCategoryKey, productCategoryDisplayLabel,productcategory,"", false,productCategoryOrder,true) %>
						<%}%>	
		</td>
          
          <% if( ! activity1.equals("SEASON_TASK_ASSESSMENT_REPORT")) { %>

          <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("productSubCategory")!=null){ 
							String productSubCategoryVal = request.getParameter("productSubCategory");%>
							<%= fg.createMultiChoice(productSubCategoryKey,prodcutSubCategoryDisplayLabel,productSubCategoryMap, productSubCategoryVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(productSubCategoryKey, prodcutSubCategoryDisplayLabel,productSubCategoryMap,"", false,null,true) %>
						<%}%>	
					</td>
          <%}%>
          
					<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("customer")!=null){ 
							String customerVal = request.getParameter("customer");%>
							<%= fg.createMultiChoice(customerKey,customerDisplayLabel,customertype, customerVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(customerKey, customerDisplayLabel,customertype,"", false,customerTypeorder,true) %>
						<%}%>
					</td>
 			
				</tr>

				<tr>       
				
				<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("licensor")!=null){ 
							String licensorVal = request.getParameter("licensor");%>
							<%= fg.createMultiChoice(licensorKey,licensorDisplayLabel,licensortype, licensorVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(licensorKey, licensorDisplayLabel,licensortype,"", false,licensorTypeorder,true) %>
						<%}%>	
					</td>
          
          <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("property")!=null){ 
							String propertyVal = request.getParameter("property");%>
							<%= fg.createMultiChoice(propertyKey,propertyDisplayLabel,propertytype, propertyVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(propertyKey, propertyDisplayLabel,propertytype,"", false,propertyTypeorder,true) %>
						<%}%>	
					</td>
          
          <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("brand")!=null){ 
							String brandVal = request.getParameter("brand");%>
							<%= fg.createMultiChoice(brandKey,brandDisplayLabel,brandtype, brandVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(brandKey, brandDisplayLabel,brandtype,"", false,brandTypeorder,true) %>
						<%}%>	
					</td>
     
				</tr>
				<tr>	
       
          <% if(activity1.equals("VIEW_SEASON_DASHBOARDS")) { %>
            <td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("otherProductClassification")!=null){ 
							String otherProductClassificationVal = request.getParameter("otherProductClassification");%>
							<%= fg.createMultiChoice(otherProductClassificationKey,"Other Product Classification",otherProductClassification, otherProductClassificationVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(otherProductClassificationKey,"Other Product Classification",otherProductClassification,"", false,null,true) %>
						<%}%>	
					</td> 
          <%}%>	

      
      <% if( ! activity1.equals("SEASON_TASK_ASSESSMENT_REPORT")) { %>
      
					<td>
						<% if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("flag")!=null&&request.getParameter("productStatus")!=null){ 
							String productStatusVal = request.getParameter("productStatus");%>
							<%= fg.createMultiChoice(productStatusKey,productStatusDisplayLabel,productstatus, productStatusVal,false,null,true) %>
						<%}else{%>
							<%= fg.createMultiChoice(productStatusKey, productStatusDisplayLabel,productstatus,"", false,null,true) %>
						<%}%>	
					</td>
      <%}%>  
            <% if(activity1.equals("CALENDAR_WORKITEMS_CRITERIA"))
						   {%>            
                  <td>
                    <% if(activity1.equals("UPCOMING_WORKITEMS")&& request.getMethod().equalsIgnoreCase("POST") && request.getParameter("dueByDateFromDateString")!=null)
                     { %>
                    <%String dueByFromDate =(String) request.getParameter("dueByDateFromDateString");%>
                      <%= fg.createDateInput(dueByDateFrom,duebyDateFromLabel,dueByFromDate,0,10,false) %>
                     <%} 
                     else{%>
                      <%= fg.createDateInput(dueByDateFrom,duebyDateFromLabel,"",0,10,false) %>
                    <%}%>
                  </td>
                
                  <td>
                     <% if(activity1.equals("UPCOMING_WORKITEMS")&& request.getMethod().equalsIgnoreCase("POST") && request.getParameter("dueByDateToDateString")!=null)
                   { String dueByToDate =(String) request.getParameter("dueByDateToDateString");%>
                    <%= fg.createDateInput(dueByDateTo,duebyDateToLabel,dueByToDate,0,10,false) %>
                   <%} else{ %>
                        <%= fg.createDateInput(dueByDateTo,duebyDateToLabel,"",0,10,false) %>
                   <%}%>	
                  </td>
						  <%}%>
						
					</tr>
            <% if(activity1.equals("CALENDAR_WORKITEMS_CRITERIA"))
						  {%>            
						<tr>
              <td>
                   <% if(activity1.equals("UPCOMING_WORKITEMS")&& request.getMethod().equalsIgnoreCase("POST"))
                   { String taskLibrary =(String) request.getParameter("taskLibrary");%>
                   <%= fg.createMultiChoice(taskLibraryKey, "Task",updatedtaskLibraryType,taskLibrary, false,null,true) %>
                   <%} else{ %>
                  <%= fg.createMultiChoice(taskLibraryKey, "Task",updatedtaskLibraryType,"",false,null,true) %>	
                  <%}%>           
              </td>
						</tr>
              <%}%>	          
				</tr>			
	</table>

<br>
</br>
<table  width="100%" cellspacing="0" cellpadding="0">
</tr>
</table>

<tr><td style="page-break-before: always"></td></tr>

      <table>
        <tr>
          <% if(activity1.equals("CALENDAR_WORKITEMS_CRITERIA") ||activity1.equals("VIEW_SEASON_DASHBOARDS") || activity1.equals("USER_TASK_ASSESSMENT_REPORT") || activity1.equals("SEASON_TASK_ASSESSMENT_REPORT") )
            { %>         
                <td class="button" align="right">
		
                    <td class="button">
                      <a class="button" href="javascript:runReport('<%=activity1%>')"><%= runReportLabel %></a>
                  </td>
                </td>
          <%}%>
        </tr>
      </table>

<script>

function addWidgetDivision(Myworkitem){
		
		
		addWidget('division');
		
		
	}

	function removeWidget(widgetName){
		var chsn =  document.getElementById(widgetName + 'Chosen');
		var wdgt =  document.getElementById(widgetName);
		var divisionSelected = "";
		var seasonTypeSelected = "";
		var yearSelected = "";


		if(widgetName == 'seasonType' || widgetName == 'year'){
			document.getElementById('seasonDataOptions').options.length = 0;
			document.getElementById('seasonDataChosen').options.length = 0;
		
			
			var seasonTypeOptElement = document.getElementById('seasonTypeOptions');
			var yearOptElement = document.getElementById('yearOptions');
			var seasonTypeChoElement = document.getElementById('seasonTypeChosen');
			var yearChoElement = document.getElementById('yearChosen');

			if(seasonTypeChoElement.options.length > 0){
				for(i = 0; i < seasonTypeChoElement.options.length; i++){
					var seasonTypeChosenValue = seasonTypeChoElement.options[i].value;
					seasonTypeSelected = addValueUtil(seasonTypeSelected, seasonTypeChosenValue);
				}
			}
			if(yearChoElement.options.length > 0){
				for(i = 0; i < yearChoElement.options.length; i++){
					var yearChosenValue = yearChoElement.options[i].value;
					yearSelected = addValueUtil(yearSelected, yearChosenValue);
				}
			}

			var divisionElement = document.getElementById('division');
			divisionSelected = divisionElement.value;
			

			if (widgetName == 'seasonType'){
				seasonTypeSelected = removeValueUtil('seasonType');
			}
			if (widgetName == 'year'){
				yearSelected = removeValueUtil('year');
			}

			var chosen = document.getElementById('seasonDataChosen');
			for(i = 0; i < chosen.length; i++){
				chosen.options[i].selected = true;
			}
			removeWidget('seasonData');
			showWaitingMessageDiv();
			runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/lfusa/jsp/reports/LFChangeReportAjaxSAT.jsp?&division='+divisionSelected+'&season='+seasonTypeSelected+'&year='+yearSelected,'ajaxAddOption');
			remove(chsn, wdgt);
		}else{
			remove(chsn, wdgt);
		}
	}

	function removeValueUtil(widgetName){

		var selectedRemovalVal = "";
		var allSelected = "";
		var i = 0;
		var element = document.getElementById(widgetName+'Chosen');
		for(i = 0; i < element.options.length; i++){
			if(element.options[i].selected){
				var selectedValue = element.options[i].value;
				selectedRemovalVal = selectedRemovalVal+'|~*~|'+selectedValue;
			}
			allSelected = allSelected + '|~*~|'+element.options[i].value;
		}
		var chosenValues = new Array();
		chosenValues = moaToArray(selectedRemovalVal);
		var allChosenValues = new Array();
		allChosenValues = moaToArray(allSelected);
		for(i = 0; i < chosenValues.length; i++){
			var index = allChosenValues.indexOf(chosenValues[i]);
			allChosenValues.splice( index, 1 );
		}
		selectedRemovalVal = allChosenValues.toString();
		return(selectedRemovalVal);
	}

	function addWidget(widgetName, sortList, allowDuplicates){
		if(widgetName == 'division' || widgetName == 'seasonType' || widgetName == 'year'){
			
			var divisionSelected = "";
			var seasonTypeSelected = "";
			var yearSelected = "";

			var divisionElement = document.getElementById('division');
			var seasonTypeOptElement = document.getElementById('seasonTypeOptions');
			var yearOptElement = document.getElementById('yearOptions');
			var seasonTypeChoElement = document.getElementById('seasonTypeChosen');
			var yearChoElement = document.getElementById('yearChosen');
			
			var i = 0;
			divisionSelected = divisionElement.value;
			
			if(seasonTypeChoElement.options.length > 0){
				for(i = 0; i < seasonTypeChoElement.options.length; i++){
					var seasonTypeChosenValue = seasonTypeChoElement.options[i].value;
					seasonTypeSelected = addValueUtil(seasonTypeSelected, seasonTypeChosenValue);
				}
			}
			if(yearChoElement.options.length > 0){
				for(i = 0; i < yearChoElement.options.length; i++){
					var yearChosenValue = yearChoElement.options[i].value;
					yearSelected = addValueUtil(yearSelected, yearChosenValue);
				}
			}

			if(widgetName == 'division'){
				document.getElementById('seasonDataOptions').options.length = 0;
				document.getElementById('seasonDataChosen').options.length = 0;
				divisionSelected = divisionElement.value;
				
			}
			if (widgetName == 'seasonType' || widgetName == 'year'){
				document.getElementById('seasonDataOptions').options.length = 0;
				document.getElementById('seasonDataChosen').options.length = 0;
				
				if (divisionSelected != ""){
					for(i = 0; i < seasonTypeOptElement.options.length; i++){
						if(seasonTypeOptElement.options[i].selected){
							var seasonSelectedValue = seasonTypeOptElement.options[i].value;
							seasonTypeSelected  = addValueUtil(seasonTypeSelected, seasonSelectedValue);
						}
					}
					for(i = 0; i < yearOptElement.options.length; i++){
						if(yearOptElement.options[i].selected){
							var yearSelectedValue = yearOptElement.options[i].value;
							// alert("yearSelectedValue"+yearSelectedValue);
							yearSelected  = addValueUtil(yearSelected, yearSelectedValue);
							// alert("yearSelected"+yearSelected);
						}
					}
				}
			}

			showWaitingMessageDiv();
			runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/lfusa/jsp/reports/LFChangeReportAjaxSAT.jsp?&division='+divisionSelected+'&season='+seasonTypeSelected+'&year='+yearSelected,'ajaxAddOption');

			var optns = document.getElementById(widgetName + 'Options');
			var chsn =  document.getElementById(widgetName + 'Chosen');
			var wdgt =  document.getElementById(widgetName);
			add(optns, chsn, wdgt, sortList, allowDuplicates);
			//Added for Build 6.13- BOM Listing Report Changes
			//ITC START
		}else if(widgetName == 'vendorBtnSearch'){
			var vendorSearchElement = document.getElementById('vendorSearch');
			var vendorSearchValue = vendorSearchElement.value;
			showWaitingMessageDiv();
			runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>'+ '/lfusa/jsp/reports/LFVendorSearchAjax.jsp?&criteria=' +vendorSearchValue,'ajaxVendorAddOption');

			var optns = document.getElementById(widgetName + 'Options');
			var chsn =  document.getElementById(widgetName + 'Chosen');
			var wdgt =  document.getElementById(widgetName);
			add(optns, chsn, wdgt, sortList, allowDuplicates);

			//ITC END
		}else{
			var optns = document.getElementById(widgetName + 'Options');
			var chsn =  document.getElementById(widgetName + 'Chosen');
			var wdgt =  document.getElementById(widgetName);
			add(optns, chsn, wdgt, sortList, allowDuplicates);
		}
	}

	function addValueUtil(selectedValue, chosenValue){
		if(selectedValue != ""){
			selectedValue = selectedValue+'|~*~|'+chosenValue;
		}else{
			selectedValue = '|~*~|'+chosenValue;
		}
		// alert("selectedValue"+selectedValue);
		return selectedValue;
	}


		function ajaxAddOption(xml, text){
		var seasonIdNameList, keyValuePair, seasonId, seasonName;
		var optns = document.getElementById('seasonDataOptions');
		var text1 = (new String(text)).replace(/^\s+|\s+$/g,'');
		var sesonIDList = "";
		seasonIdNameList = text1.split('|~*~|');
		document.getElementById('seasonDataOptions').options.length = 0;
		document.getElementById('seasonDataChosen').options.length = 0;
		document.MAINFORM.seasonData.value = "";

		for(i = 0; i<seasonIdNameList.size(); i++){
			var keyValuePair = seasonIdNameList[i];
			if (!(keyValuePair == null || keyValuePair == undefined || keyValuePair == "")){
				var name= keyValuePair.split('|&^&|');
				seasonId = name[0];
				seasonName = name[1];
				addOptionValue(optns, seasonName, seasonId, null, false);
				sesonIDList = buildMOA(sesonIDList,seasonId);

			}
		}
		document.MAINFORM.seasonListAjax.value = sesonIDList;
		closeDivWindow(true);
	}

	function showWaitingMessageDiv(){
		var jswWidth = 300;
		var jswHeight = 200;
		var cenPos = getCenteredPosition(300, 200);
		var cenx = cenPos["x"];
		var ceny = cenPos["y"];
		divWindow = new jsWindow(jswWidth, jswHeight, ceny, cenx, 30, "", 20, false, false, false, true, true);
		divWindow.showProcessingMessage();
	}

</script>


<script>
	function validate(activity1){
	 
		if (document.MAINFORM.division){
			var divisionValue = document.MAINFORM.division.value.strip();
			if((divisionValue == "" || divisionValue == "0"||divisionValue == null)) {
				alert('You must enter a value for : Division');
				return false;
			}
		}
    
	if(activity1=='CALENDAR_WORKITEMS_CRITERIA'){
	
    if (document.MAINFORM.seasonData){
			var seasonDataValue = document.MAINFORM.seasonData.value.strip();
			if((seasonDataValue == "" || seasonDataValue == "0"||seasonDataValue == null)) {
				alert('You must enter a value for Season Type');
				return false;
				}
			}
		}
	if(activity1=='SEASON_TASK_ASSESSMENT_REPORT'||activity1=='USER_TASK_ASSESSMENT_REPORT'){
	
	  if (document.MAINFORM.seasonData){
			var seasonDataValue = document.MAINFORM.seasonData.value.strip();
			if((seasonDataValue == "" || seasonDataValue == "0"||seasonDataValue == null)) {
				alert('You must enter a value for Season Name');
				return false;
				}
			}
		}			    
		//Check for In Store Date
		if (document.MAINFORM.inStoreDateFromDateString && document.MAINFORM.inStoreDateToDateString){

			var inStoreFromVal = document.MAINFORM.inStoreDateFromDateString.value.strip();
			var inStoreToVal = document.MAINFORM.inStoreDateToDateString.value.strip();
			if(!(inStoreToVal == "" || inStoreToVal == "0" || inStoreToVal == null)) {
				if((inStoreFromVal == "" || inStoreFromVal == "0" || inStoreFromVal == null)){
				alert('For Instore Date, If "TO" value is specified. then a "FROM" value must also be specified.');
				return false;
				}
			}
		}
		
		return true;
	}
	
	function validateSeasonName(){
		if(document.MAINFORM.seasonData.value.strip())
		{
			var seasonDataValue = document.MAINFORM.seasonData.value.strip();
			var tempArr = [];
			myArray = seasonDataValue.split("|~*~|");
			for (var i = 0; i < myArray.length; i++) 
			{
				if (myArray[i] !== "") {
					tempArr.push(myArray[i]);
				}
			}
			myArray = tempArr;
			if(myArray.length>5){
				alert('You must select only five Seasons');
				return false;
			}
		}
	  return true;
	}
</script>

<script>
	function generateExcelReport(){
		if(validate()){
			document.MAINFORM.generateExcel.value = true;
			submitForm();
		}
	}

<%

	if( request.getMethod().equalsIgnoreCase("POST") ){
	
			if(DEBUG)
				LCSLog.debug("Inside EXCEL!!!!!!");
			Map requestMap = getRequestMap(request);
	}%>

</script>

<script>
 
	function runReport(activity1) {
	  
    if (validate(activity1)) {
	
      if(activity1=='VIEW_SEASON_DASHBOARDS') {
       
          document.MAINFORM.activity.value="CALENDAR_DASHBOARD_REPORT";
          document.MAINFORM.action.value="init";
          submitForm();
          
        }
		else if (activity1=='CALENDAR_WORKITEMS_CRITERIA')  {
          document.MAINFORM.activity.value="CALENDAR_WORKITEMS_RESULTS";
          document.MAINFORM.action.value="init";
          submitForm();			
          
        } 
		else if (activity1=='USER_TASK_ASSESSMENT_REPORT') {
          document.MAINFORM.activity.value="USER_TASK_ASSESSMENT_REPORT";
          document.MAINFORM.action.value="RUN_REPORT";
          submitForm();			
          
        } 
		else if (activity1=='SEASON_TASK_ASSESSMENT_REPORT') {   

	   if(validateSeasonName()){
			  document.MAINFORM.activity.value="SEASON_TASK_ASSESSMENT_REPORT";
			  document.MAINFORM.action.value="RUN_REPORT";
			  submitForm();			
		  }
          
        }     
     }
  }
</script>	
