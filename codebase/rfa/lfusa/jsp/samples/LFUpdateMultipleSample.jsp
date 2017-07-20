<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="com.lcs.wc.client.Activities,
                com.lcs.wc.client.web.*,
                com.lcs.wc.season.*,
                com.lcs.wc.sourcing.*,
                com.lcs.wc.foundation.*,
                com.lcs.wc.product.*,
                wt.part.*,
                com.lcs.wc.specification.*,
                com.lcs.wc.util.*,
                com.lcs.wc.db.*,
                com.lcs.wc.flextype.*,
                com.lcs.wc.measurements.*,
                com.lcs.wc.moa.*,
                wt.util.*,
                com.lcs.wc.sample.*,
                java.util.*"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="sampleModel" scope="request" class="com.lcs.wc.sample.LCSSampleClientModel" />
<jsp:useBean id="sampleRequestModel" scope="request" class="com.lcs.wc.sample.LCSSampleRequestClientModel" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="flexg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="columnList" scope="request" class="java.util.ArrayList" />
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<% flexg.setUpdate(true); 
    flexg.setMultiClassForm(true);
%>
<%!
	public static final String DOCUMENT_REFERENCES = PageManager.getPageURL("DOCUMENT_REFERENCES", null);
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final String VIEW_MEASUREMENTS_COLUMN_ORDER = PageManager.getPageURL("VIEW_MEASUREMENTS_COLUMN_ORDER", null);
    public static final String FIT_SAMPLE_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.Fit.Root");

   // public static final boolean DISPLAY_COMMENTS = LCSProperties.getBoolean("jsp.testing.displayLineItemComments");
   // public static final boolean DISPLAY_QUOTED   = LCSProperties.getBoolean("jsp.testing.displayQuotedValues");
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final String IMAGE_PAGE_PLUGIN = PageManager.getPageURL("VIEW_IMAGEPAGE_DOCUMENT_PLUGIN", null);
	public static final boolean ENTER_MEASUREMENTS_IN_FIT_WITH_ONE_HAND = LCSProperties.getBoolean("jsp.testing.FitApproval.enterMeasurementsInFitWithOneHand");
       //Added by Rohini
    public static final boolean DISPLAY_COLORCRITERIA   = LCSProperties.getBoolean("jsp.testing.FitApproval.ColorCriteria");
    public static final String CLIENT_SIDE_PLUGIN = PageManager.getPageURL("CLIENT_SIDE_PLUGINS", null);
    public static final boolean MEASUREMENT_SIZE_REQUIRED   = LCSProperties.getBoolean("jsp.testing.FitApproval.MeasurementSizeRequired");
    public static final boolean UPDATE_NON_BASE_SIZE_VALUES = LCSProperties.getBoolean("jsp.testing.FitApproval.UpdateNonBasedSizeValues");
    public static final String SAMPLE_IMAGES_PAGE_ROOT = LCSProperties.get("com.lcs.wc.document.LCSDocument.SampleImagesPage.Root", "Document\\Images Page");
    //End -- Rohini
    public static final String defaultUnitOfMeasure = LCSProperties.get("com.lcs.measurements.defaultUnitOfMeasure", "si.Length.in");
    public static String baseUOM = "";
    public static String instance = "";

	private boolean flag = true;
    static {
        try {
            instance = wt.util.WTProperties.getLocalProperties().getProperty ("wt.federation.ie.VMName");
            UomConversionCache UCC = new UomConversionCache();
            Map allUOMS = UCC.getAllUomKeys();
            HashMap inputUnit = (HashMap)allUOMS.get(defaultUnitOfMeasure);
            baseUOM = (String)inputUnit.get("prompt");
        } catch(Exception e){
            e.printStackTrace();
        }
    }    
    
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
//Added by Rohini
String insertButton = WTMessage.getLocalizedMessage ( RB.MAIN, "insert_Btn",RB.objA ) ;
String clearAll = WTMessage.getLocalizedMessage ( RB.MAIN, "clearAll_ALTS",RB.objA ) ;
String selectAll = WTMessage.getLocalizedMessage ( RB.MAIN, "selectAll_ALTS",RB.objA ) ;
String deleteSelectedRows = WTMessage.getLocalizedMessage ( RB.MAIN, "deleteSelectedRows_ALTS",RB.objA ) ;
String insertBeforeSelectRows = WTMessage.getLocalizedMessage ( RB.MAIN, "insertBeforeSelectRows_ALTS",RB.objA ) ;
String insertAfterSelectRows = WTMessage.getLocalizedMessage ( RB.MAIN, "insertAfterSelectRows_ALTS",RB.objA ) ;
String insertBeforeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "insertBefore_LBL",RB.objA ) ;
String insertAfterLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "insertAfter_LBL",RB.objA ) ;
//String deleteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "delete_LBL",RB.objA ) ;
//String cutLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "cut_LBL",RB.objA ) ;
//String copyLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "copy_LBL",RB.objA ) ;
//String pasteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "paste_LBL",RB.objA ) ;
String quantityLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "quantity_LBL", RB.objA ) ;
String sizeColumnLabel = WTMessage.getLocalizedMessage ( RB.UTIL, "sizeColumn_LBL", RB.objA ) ;
String colorLabel = WTMessage.getLocalizedMessage ( RB.COLOR, "color_LBL", RB.objA ) ;
String youMustSpecifyAValueForAlrt = WTMessage.getLocalizedMessage ( RB.MAIN, "youMustSpecifyAValueFor_ALRT" , RB.objA );
String closeLabel = WTMessage.getLocalizedMessage (RB.MAIN, "closeWithParenths", RB.objA ) ;
String saveButton = WTMessage.getLocalizedMessage ( RB.MAIN, "save_Btn", RB.objA ) ;
String cancelButton = WTMessage.getLocalizedMessage ( RB.MAIN, "cancel_Btn", RB.objA ) ;


// START*****************CR #512 - Change Button Label**********************/
//String addImageButton = WTMessage.getLocalizedMessage ( RB.UPDATESAMPLE, "createSampleImage_Btn", RB.objA);
String addImageButton ="Add Sample Image";

// ***************END

String reApplyPomsButton = WTMessage.getLocalizedMessage ( RB.UPDATESAMPLE, "reApplyPoms_Btn", RB.objA ) ;
String detailsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "details_LBL", RB.objA ) ;
String imageButton = WTMessage.getLocalizedMessage ( RB.MAIN, "image_LBL", RB.objA ) ;
//String fitButton = WTMessage.getLocalizedMessage ( RB.SAMPLES, "fitInfo_Btn", RB.objA ) ;
String updateSamplePgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "updateSample_PG_HEAD", RB.objA ) ;
String sampleAttributesGrpTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleAttributes_GRP_TLE", RB.objA ) ;
String typeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "type_LBL", RB.objA ) ;
String newSampleLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "requestSample_Btn", RB.objA ) ;
String fitInformationPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "fitInformation_PG_HEAD", RB.objA ) ;
String imagePgHead = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "image_OPT", RB.objA ) ;
String productLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "product_LBL", RB.objA ) ;
//String seasonLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "season_LBL", RB.objA ) ;
String sourceLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "source_LBL", RB.objA);
String fitButton = WTMessage.getLocalizedMessage ( RB.SAMPLES, "fitInfo_Btn",RB.objA ) ;
String secondaryConfirmationSureDeleteImage = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "secondaryConfirmationSureDeleteImage_CNFRM",RB.objA ) ;
String warningPermanentlyDeleteImage = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "warningPermanentlyDeleteImage_CNFRM",RB.objA ) ;
String sureDeleteThisImage = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "sureDeleteThisImage_CNFRM",RB.objA ) ;
String imageLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "image_LBL",RB.objA ) ;
String saveAndUpdate = WTMessage.getLocalizedMessage ( RB.MAIN, "update_LBL",RB.objA ) ;
String deleteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "delete_LBL",RB.objA ) ;
String imageNameLabel = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "imageName_LBL",RB.objA ) ;
String specLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "specification_LBL",RB.objA ) ;
String measurementSetLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "measurementSet_LBL", RB.objA) ;
String sampleRequestDetailsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequestDetails_LBL", RB.objA ) ;
String sampleDetailsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleDetails_PG_HEAD", RB.objA ) ;
String updateMeasurementsSetLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "updateMeasurementsSet_LBL", RB.objA ) ;
String currentMeasurementLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "currentMeasurement_LBL", RB.objA ) ;
String sampleSizeLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sampleSize_LBL",RB.objA ) ;
String sampleSizeOrderedLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sampleSizeOrdered_LBL",RB.objA ) ;
String baseSizeLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "baseSize_LBL",RB.objA ) ;
String uomLabel = WTMessage.getLocalizedMessage (  RB.MEASUREMENTS, "uom_LBL",RB.objA ) ;
String decimalLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "decimal_LBL",RB.objA ) ;
String fractionLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "fraction_LBL",RB.objA ) ;
String updateSampleRequestPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "updateSampleRequest_PG_HEAD", RB.objA );
String sampleRequestLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequest_PG_HEAD", RB.objA );
String sampleLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sample_LBL", RB.objA );
String sampleRequestAttributesGrpTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequestAttributes_GRP_TLE", RB.objA ) ;
String sampleNameLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleName_LBL", RB.objA ) ;
String sampleCommentsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleComments_LBL", RB.objA ) ;
String samplesLabel = WTMessage.getLocalizedMessage ( RB.MATERIALCOLOR, "samples_GRP_TLE", RB.objA ) ; //"Samples";
String retrievingSampleCommentsPleaseBePatientMsg = WTMessage.getLocalizedMessage ( RB.SAMPLES, "retrievingSampleCommentsPleaseBePatient_MSG", RB.objA ) ;
String updateButton = WTMessage.getLocalizedMessage ( RB.MAIN, "update_Btn", RB.objA ) ;
String updateFitSampleMouseOverToolTip = WTMessage.getLocalizedMessage ( RB.SAMPLES, "updateFitSampleMouseOver_TOOLTIP", RB.objA) ;
String updatePOMsButton = WTMessage.getLocalizedMessage ( RB.SAMPLES, "update_POMS_Btn", RB.objA ) ;
String filterLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "filter_Lbl",RB.objA ) ;
String baseUOMUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, defaultUnitOfMeasure,RB.objA ) ;
String cmUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.cm",RB.objA ) ;
String mUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.m",RB.objA ) ;
String ftUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.ft",RB.objA ) ;
String inUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.in",RB.objA ) ;
// End -- Rohini
String noAccesstoUpdateMeasurementsMouseOverTooltip = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "noAccesstoUpdateMeasurementsMouseOver_TOOLTIP", RB.objA);
String samplesRequestedLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "samplesRequested_LBL", RB.objA);
String docsButton = WTMessage.getLocalizedMessage ( RB.MAIN, "documents_LBL", RB.objA ) ;

String confirmReApplyPoms = WTMessage.getLocalizedMessage (RB.UPDATESAMPLE, "confirmReApplyPoms", RB.objA ) ;

// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
// Description : <Sample Quantity label for the Grid>
String sampleQuantityColumnLabel = "Sample Quantity";

%>
<%
    String tid = "";

    String errorMessage = request.getParameter("errorMessage");
    String oid = request.getParameter("oid");
    HashMap<String,String> samplesMap = new HashMap<String,String>();
    Collection samplesData = new Vector();
    LCSSampleQuery sampleQuery = new LCSSampleQuery();

    boolean toggleSampleRequest = false;
    Vector<String> sortOrder = new Vector<String>();

    LCSSampleRequest sampleRequest = null;
    LCSSample sample = null;
    HashMap sampleCombinations = new HashMap();
    
    if(sampleModel.getBusinessObject()!=null){
      sample = sampleModel.getBusinessObject();
      sampleRequest = sample.getSampleRequest();
      samplesData = sampleQuery.findSamplesIdForSampleRequest(sampleRequest, true);
      Iterator<?> it = samplesData.iterator();
      FlexObject fo = null;
      String sampleDetail = null;
	  String sizeInfo = "";
      while(it.hasNext()){
           fo = (FlexObject)it.next();
           sortOrder.add("OR:com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"));           
		   if(FormatHelper.hasContentAllowZero(fo.getString("LCSFITTEST.SAMPLESIZE"))){
				sizeInfo = "  ( " + fo.getString("LCSFITTEST.SAMPLESIZE") + " )";
		   }else{
				sizeInfo = "";
		   }
           samplesMap.put("OR:com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"), fo.getString("LCSSAMPLE.SAMPLENAME") + sizeInfo);
           sampleDetail = fo.getString("LCSMEASUREMENTSMASTER.MEASUREMENTSNAME") + MOAHelper.DELIM + fo.getString("LCSFITTEST.SAMPLESIZE") + MOAHelper.DELIM + fo.getString("WTPARTMASTER.NAME");
           if(sampleCombinations.get(sampleDetail)==null){
              fo.put("quantity", "1");
              sampleCombinations.put(sampleDetail, fo);
           }else{
              fo = (FlexObject)sampleCombinations.get(sampleDetail);
              fo.put("quantity", Integer.toString((fo.getInt("quantity") +1)));
              sampleCombinations.put(sampleDetail, fo);
           } 
      }
      
      
      sampleRequestModel.load(sampleRequest.toString());
     
    }else{
      toggleSampleRequest = true;
      sampleRequest = sampleRequestModel.getBusinessObject();
      samplesData = sampleQuery.findSamplesIdForSampleRequest(sampleRequest, true);
      Iterator it = samplesData.iterator();
      FlexObject fo = null;
      String sampleDetail = null;
	  String sizeInfo = "";
      String firstSample = null;
      while(it.hasNext()){
           fo = (FlexObject)it.next();
           sortOrder.add("OR:com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"));
		   if(FormatHelper.hasContentAllowZero(fo.getString("LCSFITTEST.SAMPLESIZE"))){
				sizeInfo = "  ( " + fo.getString("LCSFITTEST.SAMPLESIZE") + " )";
		   }else{
				sizeInfo = "";
		   }
           if (firstSample == null) {
               firstSample = "OR:com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2");
           }
           samplesMap.put("OR:com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"), fo.getString("LCSSAMPLE.SAMPLENAME") + sizeInfo);
           sampleDetail = fo.getString("LCSMEASUREMENTSMASTER.MEASUREMENTSNAME") + MOAHelper.DELIM + fo.getString("LCSFITTEST.SAMPLESIZE") + MOAHelper.DELIM + fo.getString("WTPARTMASTER.NAME");
           if(sampleCombinations.get(sampleDetail)==null){
              fo.put("quantity", "1");
              sampleCombinations.put(sampleDetail, fo);
           }else{
              fo = (FlexObject)sampleCombinations.get(sampleDetail);
              fo.put("quantity", Integer.toString((fo.getInt("quantity") +1)));
              sampleCombinations.put(sampleDetail, fo);
           } 
      }

      if (firstSample != null) {
         sampleModel.load(firstSample);
         sample = sampleModel.getBusinessObject();
         oid = FormatHelper.getObjectId(sample);
      }
    }
        
        
      FlexType sampleType = FlexTypeCache.getFlexTypeFromPath(FIT_SAMPLE_ROOT_TYPE);
  
    request.setAttribute("contextSample", "sample");    
    FlexType type = sample.getFlexType();
    LCSSourcingConfigMaster scMaster = (LCSSourcingConfigMaster) sampleModel.getSourcingMaster();
    LCSProduct product = null;
    //LCSSeason season = null;
    String measurementsId = "";
    String measurementsName = "";
    String sampleSize = "";
    String quantityDefaultValue = "1";
   // Target Point Build : <004.23> Request ID : <7> Modified On: 24-May-2013 Author : <Bineeta>
   // Description : <Default Value for the Custom Sample Quantity>
   String lfSampleQuantityDefaultValue = "1.00";

    LCSMeasurements measurements = null;
    LCSSourcingConfig sconfig = null;
    WTPartMaster specMaster = sampleModel.getSpecMaster();
    FlexSpecification spec = (FlexSpecification) VersionHelper.latestIterationOf(specMaster);
    if(scMaster != null){
        product = SeasonProductLocator.getProductARev(scMaster);
        //season = SeasonProductLocator.getSeasonRev(product);
        sconfig = (LCSSourcingConfig) VersionHelper.latestIterationOf(scMaster);
		appContext.setProductContext(product);

        // Target Point Build : <004.23> Request ID : <7> Modified On: 24-May-2013 Author : <Bineeta>
        // Description : <Sets the boolean flag Basing on the Product Flex Type>
        FlexType productFlexType = product.getFlexType();
		String flexTypeName = productFlexType.getFullName();
		if (flexTypeName.contains("Apparel")||flexTypeName.contains("Footwear")){
			// Flag as False(No Changes in the Grid)
			flag = true;
		}else{
			// Flag as True(Changes in the Grid)
			flag = false;
		}

    }

    LCSFitTest fitTest = LCSMeasurementsQuery.findFitTest(sample);

    //Added by rohini
    Collection measurementsList = FlexSpecQuery.getSpecComponents(spec, "MEASUREMENTS");

    Iterator measurementsIter = measurementsList.iterator();
    Hashtable measurementsTable = new Hashtable();
    //End : Added by rohini
    
    String doubleFormat = request.getParameter("measurementsFormat");
    FlexType measurementType = null;
	String placeholderRowSearchCriteriaKey = "";
	String highlightSearchCriteriaKey = "";

    if(fitTest!=null){
        measurements = (LCSMeasurements) VersionHelper.latestIterationOf(fitTest.getMeasurementsMaster());
        if(VersionHelper.isWorkingCopy(measurements)){
           measurements = (LCSMeasurements)VersionHelper.getOriginalCopy(measurements);
        }
        measurementType = measurements.getFlexType(); 
        measurementsId = FormatHelper.getVersionId(measurements);
        measurementsName = measurements.getValue("name").toString();
		placeholderRowSearchCriteriaKey = measurementType.getAttribute("placeholderRow").getSearchResultIndex();


         if(!FormatHelper.hasContent(doubleFormat) || doubleFormat.indexOf("FRACTION")>-1){
            // jc - removed "!= null" check
            if(FormatHelper.hasContent((String)measurements.getValue("uom"))){
               doubleFormat = ("si.Length." + (String)measurements.getValue("uom"));
            }else{
               doubleFormat = defaultUnitOfMeasure;
            }
         }
    }
    FlexTypeAttribute quantityAtt = null;
    try{
        quantityAtt = type.getAttribute("quantity");
	    if(FormatHelper.hasContent(quantityAtt.getAttDefaultValue())){
			quantityDefaultValue = quantityAtt.getAttDefaultValue();
		}
	}catch(WTException wte){
	}
/////////////////////List existing sample combination///////////////////////////    
 
    Collection combinationColumns = new ArrayList();
    TableColumn combinationColumn = new TableColumn();
    combinationColumn.setDisplayed(true);
    combinationColumn.setHeaderLabel(quantityLabel);
    combinationColumn.setHeaderAlign("left");
    combinationColumn.setTableIndex("quantity");
    combinationColumn.setFormatHTML(false);
    combinationColumns.add(combinationColumn);

    combinationColumn = new TableColumn();
    combinationColumn.setDisplayed(true);
    combinationColumn.setHeaderLabel(measurementSetLabel);
    combinationColumn.setHeaderAlign("left");
    combinationColumn.setTableIndex("LCSMEASUREMENTSMASTER.MEASUREMENTSNAME");
    combinationColumn.setFormatHTML(false);
    combinationColumns.add(combinationColumn);

    combinationColumn = new TableColumn();
    combinationColumn.setDisplayed(true);
    combinationColumn.setHeaderLabel(sampleSizeLabel);
    combinationColumn.setHeaderAlign("left");
    combinationColumn.setTableIndex("LCSFITTEST.SAMPLESIZE");
    combinationColumn.setFormatHTML(false);
    combinationColumns.add(combinationColumn);
    
    if(DISPLAY_COLORCRITERIA){
    combinationColumn = new TableColumn();
    combinationColumn.setDisplayed(true);
    combinationColumn.setHeaderLabel(colorLabel);
    combinationColumn.setHeaderAlign("left");
    combinationColumn.setTableIndex("WTPARTMASTER.NAME");
    combinationColumn.setFormatHTML(false);
    combinationColumns.add(combinationColumn);    
    
    }
    
    TableGenerator combinationtg = new TableGenerator();
    combinationtg.setMaxWidth(400);
    String sampleCombinationsString = combinationtg.drawTable(sampleCombinations.values(), combinationColumns, "", false, false);

	boolean newMeasurementUpdateable = false;

    FlexType imagePageType = FlexTypeCache.getFlexTypeFromPath(SAMPLE_IMAGES_PAGE_ROOT);
    String imagePageTypeId = FormatHelper.getObjectId(imagePageType);
  
  ///////////////////////////////////////////////////////////////    
  

    boolean imagesTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("Document\\Images Page"));



%>
<jsp:include page="<%=subURLFolder+ VIEW_MEASUREMENTS_COLUMN_ORDER %>" flush="true">
    <jsp:param name="none" value="" />
</jsp:include>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<link href="<%=URL_CONTEXT%>/css/domtableeditor.css" rel="stylesheet">
<script language="JavaScript" src="<%=URL_CONTEXT%>/javascript/ajax.js"></script>

<script>
    var URL_CONTEXT = '<%= URL_CONTEXT %>';
    var WT_IMAGE_LOCATION = ('<%=WT_IMAGE_LOCATION%>');
</script>

<script type="text/javascript" src="<%=URL_CONTEXT%>/javascript/domtableeditor.js"></script>
<script type="text/javascript" src="<%=URL_CONTEXT%>/javascript/datamodel.js"></script>

<script>
   var moaModel = new TableDataModel();
   var dataModel = moaModel;
   var log = new quickDoc();

    DOM_TE_ALLOW_ROW_DELETE_MESSAGE = "You do not have access to delete rows.";
    DOM_TE_ALLOW_ROW_INSERT_MESSAGE = "You do not have access to insert rows.";

 

    var sizeRuns = new Array();
    var sampleSizes = new Array();

   <%
   LCSMeasurements measurementsItem = null;
   while(measurementsIter.hasNext()){
      measurementsItem = (LCSMeasurements)measurementsIter.next();
      if(VersionHelper.isWorkingCopy(measurementsItem)){
         measurementsItem = (LCSMeasurements)VersionHelper.getOriginalCopy(measurementsItem);
      }
      if(FormatHelper.getVersionId(measurementsItem).equals(measurementsId)){
        sampleSize = measurementsItem.getSampleSize();
      }
      measurementsTable.put(FormatHelper.getVersionId(measurementsItem), measurementsItem.getValue("name").toString());

   %>
   sizeRuns['<%=FormatHelper.getVersionId(measurementsItem)%>'] = moaToArray('<%=measurementsItem.getSizeRun()%>');
   sampleSizes['<%=FormatHelper.getVersionId(measurementsItem)%>'] = '<%=measurementsItem.getSampleSize()%>';

   <% } %>
</script>
<script language="JavaScript">



    function handleFitWidgetEvent(widgetObj){
        <% if(fitTest != null){ %>
            var quotedMeasDeltaPrecision = <%=measurementType.getAttribute("quotedMeasurementDelta").getAttDecimalFigures()%>;
            var actualMeasDeltaPrecision = <%=measurementType.getAttribute("actualMeasurementDelta").getAttDecimalFigures()%>;
                    
            var objName = widgetObj.name;
            if(objName.indexOf("M_F_")>-1){
                var index = objName.lastIndexOf("_");
                var ObjName = objName.substring(0,index+1);
                var requestedValueObj = document.getElementById(ObjName+"requestedMeasurementDisplay");
				if(requestedValueObj){
					var requestMeas = requestedValueObj.innerHTML;
					var plusTol = '<%=LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER%>';
					var minusTol = '<%=LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER%>';

					if(document.getElementById(ObjName+"plusToleranceDisplay")){
						plusTol = document.getElementById(ObjName+"plusToleranceDisplay").innerHTML;
					}
					if(document.getElementById(ObjName+"minusToleranceDisplay")){
						minusTol = document.getElementById(ObjName+"minusToleranceDisplay").innerHTML;
					}
					if((widgetObj.name).indexOf("actualMeasurement") > -1){
						var actualMeasurement = widgetObj.value;
						var actualDeltaObj = document.getElementById(ObjName+"actualMeasurementDelta");
						if(actualDeltaObj!=undefined){
							var actualDeltaObjDisplay = document.getElementById(ObjName+"actualMeasurementDeltaDisplay");
		
							if(isNaN(actualMeasurement) != true && parseFloat(actualMeasurement) > 0){
								var actualDelta = parseFloat(actualMeasurement) - parseFloat(requestMeas) ;
								actualDeltaObj.value=format_number(actualDelta,actualMeasDeltaPrecision);
								actualDeltaObjDisplay.innerHTML = format_number(actualDelta,actualMeasDeltaPrecision);
								if((actualDelta<0 && parseFloat(minusTol) < Math.abs(actualDelta)) || (actualDelta>0 && parseFloat(plusTol) < Math.abs(actualDelta))){       
									actualDeltaObjDisplay.className = "OUT_OF_TOLERANCE_" + requestedValueObj.className;
								}else{
									actualDeltaObjDisplay.className = requestedValueObj.className;                          
		
								}
							}else if(isNaN(actualMeasurement) != true && parseFloat(actualMeasurement) == 0){
							    actualDeltaObj.value= 0;
								actualDeltaObjDisplay.innerHTML = format_number(0,actualMeasDeltaPrecision);
								actualDeltaObjDisplay.className = requestedValueObj.className;                          
							}
						}
					}

					if((widgetObj.name).indexOf("quotedMeasurement") > -1){
						var quotedMeasurement = widgetObj.value;
						var quotedDeltaObj = document.getElementById(ObjName+"quotedMeasurementDelta");      
						if(quotedDeltaObj!=undefined){
							var quotedDeltaObjDisplay = document.getElementById(ObjName+"quotedMeasurementDeltaDisplay");
							if(isNaN(quotedMeasurement) != true && parseFloat(quotedMeasurement) > 0){
								var quotedDelta = parseFloat(quotedMeasurement) - parseFloat(requestMeas) ;
								quotedDeltaObj.value=format_number(quotedDelta,quotedMeasDeltaPrecision);

								quotedDeltaObjDisplay.innerHTML=format_number(quotedDelta,quotedMeasDeltaPrecision);
								if((quotedDelta<0 && parseFloat(minusTol) < Math.abs(quotedDelta)) || (quotedDelta>0 && parseFloat(plusTol) < Math.abs(quotedDelta))){
										quotedDeltaObjDisplay.className="OUT_OF_TOLERANCE_" + requestedValueObj.className;

								}else{
										quotedDeltaObjDisplay.className=requestedValueObj.className;
																   
								}
							}else if(isNaN(quotedMeasurement) != true && parseFloat(quotedMeasurement) == 0){
				                quotedDeltaObj.value= 0;
								quotedDeltaObjDisplay.innerHTML = format_number(0,quotedMeasDeltaPrecision);
								quotedDeltaObjDisplay.className = requestedValueObj.className;                          
							}
						}
					}
				}
            }
        <% } %>
    }




    function update(){
        endCellEdit();
        if(validate()&& validate2()){
            document.MAINFORM.oid.value = document.getElementById("sampleId").value;
			document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
            document.MAINFORM.action.value = 'SAVE';
			if(document.getElementById("samplesDiv").style.display=='block'){
				var dataString = getDataString();
				document.MAINFORM.LCSSAMPLE_sampleRequestString.value = dataString;
				
				// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
				// Description : <Variable to fetch the data from the Grid and set it in lfFloatSampleQuantity>
				var qtyString = getCustomValuesFromGrid();
				//alert("qtyString update*******"+qtyString);
				document.MAINFORM.lfFloatSampleQuantity.value = qtyString;

            }
            selectPOMs();            
            submitForm();
        }
    }


    function toggleSample(id){
        endCellEdit();
        if(validate() && validate2()){
            document.MAINFORM.oid.value = '<%=FormatHelper.getObjectId(sample)%>';
            document.MAINFORM.nextSampleOid.value = id;
            document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
            document.MAINFORM.action.value = 'SAVE_AND_TOGGLE';
			if(document.getElementById("samplesDiv").style.display=='block'){
				var dataString = getDataString();
				document.MAINFORM.LCSSAMPLE_sampleRequestString.value = dataString;
            }
			selectPOMs();
            submitForm();
        }else{
            
            var samplesDropdown = document.MAINFORM.sampleId;
            for (i=0; i<samplesDropdown.options.length; i++) {
                if (samplesDropdown.options[i].value=='<%=FormatHelper.getObjectId(sample)%>') {
                    samplesDropdown.options[i].selected=true;
                    break;
                }
            }
        }
    }

    function refreshFitSample(){
		if(confirm('<%= FormatHelper.formatJavascriptString(confirmReApplyPoms, false) %>')){
	        endCellEdit();
	        document.MAINFORM.oid.value = '<%= oid %>';
	        document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
	        document.MAINFORM.action.value = 'SAVE_AND_REFRESH_FIT';
			document.MAINFORM.origActivity.value = document.MAINFORM.returnActivity.value;
			document.MAINFORM.origOid.value = document.MAINFORM.returnOid.value;	
	        submitForm();
    	}
    }

    function validate(){
    
        var tabId = document.MAINFORM.tabId.value;
        changeTab('sampleDetailTab');
        <% flexg.setScope(SampleRequestFlexTypeScopeDefinition.SAMPLE_SCOPE); %>
        <%= flexg.generateFormValidation(sample) %>
         
        <% flexg.setScope(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE); %>       
        <%= flexg.drawFormValidation(type.getAttribute("requestName")) %>
        <%= flexg.generateFormValidation(sampleRequest) %>
        document.MAINFORM.tabId.value = tabId;
        changeTab(tabId);
        return true;
    }

    function createSampleImage() {
 
        if(validate() && validate2()){

            var id = document.getElementById("sampleId").value;
            var url = '<%=URL_CONTEXT%>/jsp/main/Main.jsp?activity=CREATE_DOCUMENT&sampleId='+id+'&action=INIT&templateType=EMPTY&' +
                'rootTypeId=<%= imagePageTypeId %>&specId=<%=FormatHelper.getVersionId(spec)%>&imagePageOwnerId=<%= FormatHelper.getVersionId(product) %>&popUpWindow=true';
            window.open(url,'sampleImagePage','top=20,left=20,scrollbars=1,resizable=yes,status=true');
        }
    }

    function deleteSampleImage(id) {
        var message = '<%=FormatHelper.formatJavascriptString(sureDeleteThisImage , false) %>';
        message = message + "\n\n " + '<%= FormatHelper.formatJavascriptString(warningPermanentlyDeleteImage ,false)%>';

        if(!confirm(message)){
            return;
        }

        if(!confirm('<%= FormatHelper.formatJavascriptString(secondaryConfirmationSureDeleteImage ,false)%>')){
                return;
        }

        document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
        document.MAINFORM.action.value = 'SAVE_AND_DELETE_IMAGE';
        document.MAINFORM.oid.value = '<%= oid %>';
        document.MAINFORM.imagePageId.value = id;
        document.MAINFORM.returnOid.value = '<%= oid %>';
        document.MAINFORM.returnActivity.value = document.REQUEST.activity;
        document.MAINFORM.returnAction.value = document.REQUEST.action;
        submitForm();
     }

    function displayImage(id){
        document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
        document.MAINFORM.action.value = 'SAVE_AND_RETURN';
        document.MAINFORM.imagePageId.value = id;
        document.MAINFORM.hideFileTable.value = true;
        document.MAINFORM.value = "true";
        submitForm();
    }

   function saveAndUpdateImagesPage(id){
        var url = '<%=URL_CONTEXT%>/jsp/main/Main.jsp?activity=UPDATE_DOCUMENT&action=INIT&oid='+id+'&templateType=EMPTY&imagePageOwnerId=<%= FormatHelper.getVersionId(product) %>&popUpWindow=true';
        window.open(url,'sampleImagePage','top=20,left=20,scrollbars=1,resizable=yes,status=true');
    }

    function saveAndRefresh(objId) {
        endCellEdit();

        //  document.MAINFORM.oid.value = '<%= oid %>';
        //  document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
        //  document.MAINFORM.action.value = 'SAVE_AND_REFRESH';
        //  if(objId && objId.indexOf('LCSDocument') > -1){
        //      document.MAINFORM.imagePageId.value=objId;
        //  }
        //  submitForm();
        toggleSample('<%= oid %>');
    }

    //////////////////////////////////////////////////////////////////////////////////////
    /** Locates the proper widget for a cell and loads it.
     * The proper state of the widget is then loaded from
     * the appropriate data.
     * @param    cell    The cell to load.
     */
    function loadWidget(cell){
        //alert("loadWidget");

        if(domTableEditor_widgetCustomWidgetLoader && eval(domTableEditor_widgetCustomWidgetLoader)){
            return;
        }

        try {
            selectRow(cell.parentNode);
            var id = cell.id;

            var attKey = id.substring(id.indexOf('_') + 1, id.length);
            var branchId = id.substring(1, id.indexOf('_'));

            var branch = dataModel.getBranch(branchId);


            cellType = cellTypes[attKey];
            currentCellType = cellType;

            var currentValue = getValueForWidget(branch, attKey);
            var currentDisplay = getDisplayForWidget(branch, attKey);

            while(cell.childNodes.length > 0){
                cell.removeChild(cell.childNodes[0]);
            }


            var widgetIndex = attKey;

            var widget = widgets[widgetIndex];
            
            
            if(attKey=='size'){
                 var currentMeasurementValue = getValueForWidget(branch, "measurementsSet");
                 var sizes = sizeRuns[currentMeasurementValue];
                 var selectString = "";                 
                 if(sizes!=undefined){
                    for(var j=0; j<sizes.length; j++){
                            selectString = selectString + "<option value=\"" + sizes[j] + "\" >" + sizes[j];
                    }    
                 }
             
                 widget.innerHTML = "<select name=\"size\" id=\"size\" parent=\"size\" onkeydown=\"typeAhead()\"><option value=\" \">" + selectString + "</select>";

            }
            
            
            cell.appendChild(widget);


            widget = cell.childNodes[0];
            //widget = getWidgetFromCell(cell);
            if("composite" == cellType){
                //setChosenLabelElements(widget);
            }

            loadWidgetData(widget, cellType, currentValue, currentDisplay);
            if (!programmaticWidgetUpdate) {
                window.setTimeout('handleWidgetFocus()', 50);
            }
       } catch (exception){
           alert('Exception occured in loadWidget: ' + exception.message);
           for(var n in exception){
                //debug(n + ':' + exception[n]);
           }
        }

    }




    function handleChange(oldValue, newValue, branch, sourceCell, attKey){
        
    }

    function getDisplayForWidget(branch, attKey){
        return format(branch[attKey + "Display"]);
    }

    function getValueForWidget(branch, attKey){
        return format(branch[attKey]);
    }

    function handleWidgetFocus(widget){
        if(currentWidget){
            widget = currentWidget;
        }
        if("moaList" == currentCellType){
            widget = getListOption(widget);
        }
        else if("composite" == currentCellType){
            widget = getCompositeContent(widget);
        }
        else if("object_ref" == currentCellType){
            var widLink = getObjectRefLink(widget);
        }
        else if(widget.tagName == 'TEXT' || widget.tagName == 'INPUT'){
            if(widget.select){
                widget.select();
            }
        }
        else {
  //          widget.focus();
        }
    }
    
   function getDataString(){
        var dataString = new quickDoc();
        var branch;
        var branches = moaModel.getData();

        for(var i = 0; i < branches.length; i++){

            branch = branches[i];

            if(branch.dropped){
              continue;
            }

            var tempString = new quickDoc();
            //tempString.write('sortingNumber<%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + format(branch.sortingNumber) + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');
            tempString.write('<%= MultiObjectHelper.ID %><%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + branch.branchId + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');
            tempString.write('<%= MultiObjectHelper.DROPPED %><%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + branch.dropped + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');

            if(hasContent(branch.quantity)){
                tempString.write('quantity<%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + format(branch.quantity) + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');
                    
                tempString.write('size<%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + format(branch.size) + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');

                tempString.write('measurementsSet<%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + format(branch.measurementsSet) + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');
                 
               <%  if(DISPLAY_COLORCRITERIA){ %>
                     
                     tempString.write('color<%= MultiObjectHelper.NAME_VALUE_DELIMITER %>' + format(branch.color) + '<%= MultiObjectHelper.ATTRIBUTE_DELIMITER %>');
        
           <%  } %>                  

                dataString.write(tempString.toString());
                dataString.write('<%= MultiObjectHelper.ROW_DELIMITER %>'); // ENTRY DELIMETER
            }
       
        }
        return dataString.toString();
    }

	    /**
    * 
    * Target Point Build: 004.23
    * Request ID : <7>
    * Modified On: 24-May-2013
    * Method to get the Values from the Grid 
    * from the Sample Request Create Page
    * @author  Bineeta
    * getCustomValuesFromGrid
    * @return qtyString contains the sample quantity value
    */
	// ITC -  Start
	function getCustomValuesFromGrid(){
		var qtyString = new quickDoc();
		var branch;
		var branches = moaModel.getData();

		for(var i = 0; i < branches.length; i++){

			branch = branches[i];
			// IF DROPPED BUT NOT PERSISTED THEN SKIP
			if(branch.dropped && !branch.persisted){
				continue;
			}
			if(branch.touched){
				var tempString1 = new quickDoc();
				// The Branch ID of the Grid 
				tempString1.write('' + branch.branchId + '-');
				// The Sample Quantity value
				tempString1.write('' + format(branch.lfFloatSampleQuantity) + ',');
				qtyString.write(tempString1.toString());
			}
		}
		endCellEdit();
		return qtyString.toString();
	}
	    
    
    

    function getValueForWidget(branch, attKey){
        return format(branch[attKey]);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    /** Pulls value from branch to be set into a widget on load.
     */
    function getDisplayForWidget(branch, attKey){
        return format(branch[attKey + "Display"]);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function getDisplayFromWidgetDisplay(branch, display, attKey){
        return format(display);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function getValueFromWidgetValue(branch, value, attKey){
        return format(value);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function isEditable(cell){
        return true;
    }
    function selectRowForCellImage(img){
        var row = img.parentNode.parentNode;
        selectRow(row);
    }

    function validate2(){
        var branch;
        var branches = moaModel.getData();
		if(document.getElementById("samplesDiv").style.display=='block'){
			for(var i = 0; i < branches.length; i++){

				branch = branches[i];
				// IF DROPPED BUT NOT PERSISTED THEN SKIP
				if(branch.dropped){
					continue;
				}

				if(!checkRequiredFields(branch)){
					return false;
				}
			}
		}
        return true;
    }


    function checkRequiredFields(branch){
        if((hasContentAllowZero(branch['measurementsSet']) && !hasContentNoZero(branch['quantity']))){
              alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(quantityLabel, false)%>');
              return false;
         }
         
    <%if(MEASUREMENT_SIZE_REQUIRED){
    %>
           if(!hasContentNoZero(branch['quantity']) && (hasContentAllowZero(branch['measurementsSet']) || hasContentAllowZero(branch['size']))){                   
           alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(quantityLabel, false)%>');
           return false;
           }else if(!hasContentAllowZero(branch['measurementsSet'])  && (hasContentNoZero(branch['quantity']) || hasContentAllowZero(branch['size']))){                   
           alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(measurementSetLabel, false)%>');
           return false;
           }else if(!hasContentAllowZero(branch['size'])  && (hasContentNoZero(branch['quantity']) || hasContentAllowZero(branch['measurementsSet']))){                   
           alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(sizeColumnLabel, false)%>');
           return false;
           }                             
    <%
    }
    %>         
         
         
     if(!hasContentAllowZero(branch['size']) && hasContentAllowZero(branch['measurementsSet'])){                   
          alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + FormatHelper.formatJavascriptString(sizeColumnLabel) %>');
              return false;
         }

     if(hasContentAllowZero(branch['size']) && !hasContentAllowZero(branch['measurementsSet'])){                   
          alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(measurementSetLabel, false)%>');
              return false;
         }
     if(hasContentAllowZero(branch['size']) && !hasContentNoZero(branch['quantity'])){                   
          alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(quantityLabel, false)%>');
              return false;
         }         
         

	 // Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
	 // Description : <Check for the Sample Quantity to be in between 0-40 >
	 // ITC - Start

     if(branch['lfFloatSampleQuantity'] > 40){                   
          alert(' Maximum Sample Quantity can be 40');
              return false;
         }

     if(branch['lfFloatSampleQuantity'] <= 0){                   
          alert(' Minimum Sample Quantity should be 1');
              return false;
         }
         
        return true;
    }

	    /**
    * Target Point Build: 004.23
    * Request ID : <7>
    * Description : <Changed the Row Number of the Columns according the new 
    * Arrangement and Set the default value for the Custom Sample Quantity>
    * @author Bineeta
    * Modified On: 24-May-2013
    */
    function initNewRow(newRow, newBranch){
         //Default the measurements set to the selected measurements set from the 
         //previous page and the size to the sample size of the measurements set.
         //Also set the quantity to "1" by default.
         var quantityCell = getCell(newRow, null);
         var measurementsSetCell = getCell(newRow, 2);
         var sizeCell = getCell(newRow, 3);
         var sampleQuantityCell = getCell(newRow, 4);

         measurementsSetCell.innerHTML = '<%=FormatHelper.formatJavascriptString(measurementsName)%>';
         newBranch['measurementsSet'] = '<%=FormatHelper.formatJavascriptString(measurementsId)%>'; 
         sizeCell.innerHTML ='<%=FormatHelper.formatJavascriptString(sampleSize)%>';
         newBranch['size'] = '<%=FormatHelper.formatJavascriptString(sampleSize)%>'; 
         quantityCell.innerHTML = '<%=quantityDefaultValue%>';
         newBranch['quantity'] = '<%=quantityDefaultValue%>'; 
         sampleQuantityCell.innerHTML = '<%=lfSampleQuantityDefaultValue%>';
         newBranch['lfFloatSampleQuantity'] = '<%=lfSampleQuantityDefaultValue%>'; 
    }


    function insertNewRow(){
        var table = document.getElementById("editorTable");
        insertRow(null, (getRowCount(table)-2)+1);
 
       
    }
    
    
    //End by Rohini
    
    
    
    
    function changeTab(tabId, page) {
        document.MAINFORM.tabId.value = tabId;
        var sampleDetailTab = document.getElementById('sampleDetailTab');
        var sampleDetailDiv = document.getElementById('sampleDetailDiv');
        var docsTab = document.getElementById('docsTab');
        var docsDiv = document.getElementById('docsDiv');
        var fitTab = document.getElementById('fitTab');
        var fitDiv = document.getElementById('fitDiv');
		<% if(imagesTab){ %>
        var imagesTab = document.getElementById('imagesTab');
        var imagesDiv = document.getElementById('imagesDiv');
		<%}%>        
        if (!hasContent("" + fitTab) ) {
           fitTab = format(fitTab);
        }

        if (tabId == 'sampleDetailTab' ) {
            sampleDetailTab.className='tabselected';
            sampleDetailDiv.style.display = 'block';
            fitTab.className='tab';
            fitDiv.style.display = 'none';
            docsTab.className='tab';
            docsDiv.style.display = 'none';
			<% if(imagesTab){ %>
            imagesTab.className='tab';
            imagesDiv.style.display = 'none';
			<%}%>
        } else if (tabId == 'fitTab') {
            sampleDetailTab.className='tab';
            sampleDetailDiv.style.display = 'none';
            fitTab.className='tabselected';
            fitDiv.style.display = 'block';
            docsTab.className='tab';
            docsDiv.style.display = 'none';
			<% if(imagesTab){ %>
            imagesTab.className='tab';
            imagesDiv.style.display = 'none';
			<%}%>

        }else if (tabId == 'docsTab') {
            sampleDetailTab.className='tab';
            sampleDetailDiv.style.display = 'none';
            fitTab.className='tab';
            fitDiv.style.display = 'none';
            docsTab.className='tabselected';
            docsDiv.style.display = 'block';
			<% if(imagesTab){ %>
            imagesTab.className='tab';
            imagesDiv.style.display = 'none'; 
			<%}%>
			
        }<% if(imagesTab){ %>else if (tabId == 'imageTab') {
            sampleDetailTab.className='tab';
            sampleDetailDiv.style.display = 'none';
            fitTab.className='tab';
            fitDiv.style.display = 'none';
            docsTab.className='tab';
            docsDiv.style.display = 'none';
            imagesTab.className='tabselected';
            imagesDiv.style.display = 'block';            
        }
		<%}%> 
        
    }
    
     function toggleAllItems() {
        var selectAllCheckbox = document.getElementById('selectAllCheckBox');

        var checkbox = document.getElementsByName('selectedPOMIds');
        for (i=0; i<checkbox.length; i++) {

            if (selectAllCheckbox.checked) {
                checkbox[i].checked = true;
            } else {
                checkbox[i].checked = false;
            }
        }
    }   
    
   function selectPOMs(){

        if(document.MAINFORM.selectedPOMIds!=undefined){
            var group = document.MAINFORM.selectedPOMIds;
			if(!hasContent(group.length)){
				// SINGLE CHECK BOX CASE
				if(group.checked && group.value != "on"){
					ids = group.value;
				}				
			}else{
				var checked = false;
				var ids = '';

				// GROUP THE SELECED IDS INTO A MOA STRING
				for (var k =0; k < group.length; k++)  {
					if (group[k].checked)   {
						if (ids=='noneSelected') {
							ids='';
						}
						if(group[k].value != "on"){
							ids = buildMOA(ids, group[k].value);
						}
					}
				}
			}

            document.MAINFORM.M_F_null_CHECKBOX_pomlist.value = ids;     
        }
   }    
  
   function viewSample(id){
      document.MAINFORM.activity.value = 'VIEW_MULTIPLE_SAMPLE';
      document.MAINFORM.action.value = 'INIT';
      document.MAINFORM.oid.value = id;
      document.MAINFORM.returnActivity.value = document.REQUEST.activity;
      document.MAINFORM.returnAction.value = document.REQUEST.action;
      submitForm();
   }

	var divWindow;
    function findSampleComments(){

	    divWindow = new jsWindow(1000, 600,200, 100, 20, "", 20, true, true, true);
		divWindow.showProcessingMessage();

		runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/samples/SampleCommentsAJAXSearch.jsp?typeId=<%=FormatHelper.getObjectId(sampleRequestModel.getFlexType())%>&ownerMasterId=<%=sampleRequest.getOwnerMaster().toString()%>&specMasterId=<%=FormatHelper.getObjectId((WTPartMaster)spec.getMaster())%>', 'ajaxDefaultResponse');

    }

    /////////////////////////////////////////////////////////////////////////////////
  
    function resetSampleSize(list){
        var selectedIndex = list.selectedIndex;
		// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
		// Description : <Changed the Row number >
        var sizeCell = getCell(currentRow, 3);
        var branch = getBranchFromRow(currentRow);
        //reset the size to empty if no measurements set is selected
        if(selectedIndex==0){
            sizeCell.innerHTML = "";
            branch['size'] = ""; 
        }else{
            //set the size to the sample size of the selected measurements set
            var selectedMeasurementsSet = list.options[selectedIndex].value; 
            sizeCell.innerHTML = sampleSizes[selectedMeasurementsSet];
            branch['size'] = sampleSizes[selectedMeasurementsSet]; 
        }

    }

    /** customized so that no new row is added upon removal of everything.
     */
    function removeRow(confirmRemove) {
      endCellEdit();
        if(!DOM_TE_ALLOW_ROW_DELETE){
            alert(onlyDeleteRowsWhenOnProductBOMMSG);
            return;
        }

      if(confirmRemove && hasContent(domTeConfirmRowDeleteMSG)){
         if(!confirm(domTeConfirmRowDeleteMSG + "\n")){
            return;
         }
      }

        // DELETE ROW EVENT LISTENER
        if(domTableEditor_preDeleteMethod){
            eval(domTableEditor_preDeleteMethod);
        }


        if(currentCell){
            deSelectCell(currentCell);
            unLoadWidget();
        }

        var id = currentRow.id;
        var branchId = id.substring(1, id.length);
        var branch = dataModel.getBranch(branchId);

        if(branch.persisted && !DOM_TE_ALLOW_PERSISTED_ROW_DELETE){
            alert(doNotHavePermissionDeletePersistedRowMSG);
            return
        }

        dataModel.dropBranch(branchId);
        domTableEditor_currentTable = getTableFromRow(currentRow).id;
        currentRow.parentNode.removeChild(currentRow);

        //document.getElementById(domTableEditor_currentTable).deleteRow(currentRow.rowIndex);
        currentRow = null;

        // IF WE HAVE JUST REMOVED ALL OF THE ROWS THEN ADD A NEW ONE
        // 3 IS USED HERE TO ISOLATE NON HEADER ROWS
        /*var table = document.getElementById(domTableEditor_currentTable);
        var rowCount = getRowCount(table);
        if(rowCount < 3){
            insertRow();
        }*/
    }

    handleFitKeyNow = function(keyCode, name){
        var srcElement;        
        var tableName;
        var currentRowId;
        var nextRow;        
        var nextCellId;
        var currentTableRows;        
        var currentRowIndex = -1;
        var nextRowIndex = -1;        

        domTableEditor_handleKeyNow = "";
        if (keyCode == 13){
            srcElemment = document.getElementById(name + "Input");            
            if (srcElemment.type=='text' && (srcElemment.id.indexOf('actualMeasurementInput') != -1 || srcElemment.id.indexOf('quotedMeasurementInput') != -1 || srcElemment.id.indexOf('newMeasurementInput') != -1)) {
            	var tmpRowId = srcElemment.id.substring(4);
            	currentRowId = tmpRowId.substring(0, tmpRowId.indexOf("_"));  	
            	currentRowIndex = parseInt(document.getElementById(currentRowId).rowIndex);
				tableName = document.getElementById("measurementsHtmlTableId").value;
				currentTable = document.getElementById(tableName);
				currentTableRows=currentTable.rows.length;
				if(currentRowIndex+1==currentTableRows){
					nextRowIndex=1;
				}else{
					nextRowIndex=currentRowIndex+1;
				}
				while (currentTable.rows[nextRowIndex].style.display == "none"){					
					if (++nextRowIndex == currentTableRows){
						nextRowIndex=1;
					}
				}					
				if(currentTable.rows[nextRowIndex]) {
					nextRow = currentTable.rows[nextRowIndex];
					if (srcElemment.id.indexOf('actualMeasurementInput')>-1)  {						
						nextCellId = "M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_actualMeasurementInput";    //M_F_282450_LCSPOINTSOFMEASURE$282450_actualMeasurementInput'										
					}else if(srcElemment.id.indexOf('quotedMeasurementInput')>-1){
						nextCellId = "M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_quotedMeasurementInput";    //M_F_282450_LCSPOINTSOFMEASURE$282450_quotedMeasurementInput'					
					}else if(srcElemment.id.indexOf('newMeasurementInput')>-1){
						nextCellId = "M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_newMeasurementInput";    //M_F_282450_LCSPOINTSOFMEASURE$282450_newMeasurementInput'
					}					
				}				
				if (document.getElementById(nextCellId)) {					
					domTableEditor_handleKeyNow = "document.getElementById('" + nextCellId + "').focus();document.getElementById('" + nextCellId + "').select();";
				}				           	
            }             	               	
        }    	
    }	
</script>






<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input name="typeId" type="hidden" value='<%= FormatHelper.getObjectId(sampleRequestModel.getFlexType()) %>'>
<input name="LCSSAMPLE_sampleRequestString" type="hidden" value="">
<input name="LCSSAMPLE_measurementsFormat" type="hidden" value="<%=doubleFormat%>">
<input name="M_F_null_CHECKBOX_pomlist" type="hidden" value="">
<input name="nextSampleOid" type="hidden" value="">
<input name="measurementsId" type="hidden" value='<%= FormatHelper.getVersionId(measurements) %>'>
<input name="toggle" type="hidden" value='<%= request.getParameter("toggle") %>'>
<input name="imagePageId" type="hidden" value=''>
<input name="popUpWindow" type="hidden" value=''>
<input name="updateImagesPage" type="hidden" value=''>
<input name="updateDoc" type="hidden" value=''>
<input name="hideFileTable" type="hidden" value='false'>
<input type="hidden" name="fitSample" value="true">
<input name="origActivity" type="hidden" value='<%= request.getParameter("origActivity")%>'>
<input name="origOid" type="hidden" value='<%= request.getParameter("origOid")%>'>
<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
Description : <input lfFloatSampleQuantity to store data from the Grid> -->
<input name="lfFloatSampleQuantity" type="hidden" value=''>
<%
    boolean toggle = true;
    if ("false".equals(request.getParameter("toggle"))) {
        toggle = false;
    }
%>

<table width="100%">
    <tr>
        <td class="PAGEHEADING">
            <table width="100%">
                <tr>
                    <td class="PAGEHEADINGTITLE">
                      <%=  updateSampleRequestPgHead %>
                    </td>
                    <td class="button" align="right">
                        <a class="button" href="javascript:update()"><%= saveButton %></a>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <a class="button"  href="javascript:backCancel()"><%= cancelButton %></a>
                    </td>
               </tr>
           </table>
       </td>
    </tr>

    <tr>
        <td>
            <%= tg.startGroupBorder() %>
            <%= tg.startTable() %>
            <%= tg.startGroupTitle() %>
            <%= sampleRequestAttributesGrpTle %>:
            <%= tg.endTitle() %>
            <%= tg.startGroupContentTable() %>

            <% if(FormatHelper.hasContent(errorMessage)) { %>
                <tr>
                    <td class="ERROR" colspan="4">
                        <%= java.net.URLDecoder.decode(errorMessage, defaultCharsetEncoding) %>
                    </td>
                </tr>
            <% } %>
            <col width="15%"><col width="35%">
            <col width="15%"><col width="35%">
            <tr>
              <%
                flexg.setScope(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE);

              %>
                <%= flexg.drawFormWidget(type.getAttribute("requestName"), sampleRequestModel) %>
                <%= fg.createDisplay(typeLabel, type.getFullNameDisplay(), FormatHelper.STRING_FORMAT) %>
            </tr>
            <tr>
               <%= fg.createDisplay(productLabel, product.getName(), FormatHelper.STRING_FORMAT, "javascript:viewObject('" + FormatHelper.getVersionId(product) + "')", fg.getQuickInfoURL(FormatHelper.getVersionId(product))) %>
               <%= fg.createDisplay(specLabel, spec.getName(), FormatHelper.STRING_FORMAT) %>
               <%  //fg.createDisplay(seasonLabel, season.getName(), FormatHelper.STRING_FORMAT) %>
            </tr>
            <tr>

               
               <%= fg.createDisplay(sourceLabel, sconfig.getSourcingConfigName(), FormatHelper.STRING_FORMAT) %>
               <%= fg.createDisplay(measurementSetLabel, measurementsName, FormatHelper.STRING_FORMAT) %>

            </tr>
            
            <tr>
        <td class="FORMLABEL" nowrap width="1%">
                      &nbsp;&nbsp;&nbsp;<%= sampleNameLabel %>&nbsp;</td>
                <td>
                    <%= fg.createDropDownList(samplesMap, "sampleId", FormatHelper.getObjectId(sample), "toggleSample(this.options[this.selectedIndex].value)", 1, false, "", sortOrder) %>
                		<% if(ACLHelper.hasCreateAccess(sampleType)) { %>

                         &nbsp;&nbsp;<a onmouseover="return overlib('<%=FormatHelper.formatJavascriptString(newSampleLabel)%>');" onmouseout="return nd();" href="javascript:showSampleCreationDiv()"><img border="0" src="<%=WT_IMAGE_LOCATION%>/object_new.png"></a>
						 <%}%>
                         &nbsp<a onmouseover="return overlib('<%= FormatHelper.formatJavascriptString(sampleCombinationsString) %>');" onmouseout="return nd();" href="javascript:doNothing()"><img   border="0" src="<%=WT_IMAGE_LOCATION%>/details.gif"></a>
                         &nbsp;&nbsp;<a onmouseover="return overlib('<%=FormatHelper.formatJavascriptString(sampleCommentsLabel)%>');" onmouseout="return nd();" href="javascript:findSampleComments()"><img   border="0" src="<%=URL_CONTEXT%>/images/newPostings.gif"></a>            

               </td>       
               <%
               if(fitTest!=null){
               %>
               <%= fg.createDisplay(sampleSizeLabel, fitTest.getSampleSize(), FormatHelper.STRING_FORMAT) %>
               <%
               }%>
            </tr>
             <td>
             </td>
             <td>
             </td>
            <% if(DISPLAY_COLORCRITERIA && sample.getColor()!=null) { %>   
               <%= fg.createDisplay(colorLabel, (String)((LCSSKU)VersionHelper.latestIterationOf((WTPartMaster)sample.getColor())).getValue("skuName"), FormatHelper.STRING_FORMAT) %>
            <tr>
            
            </tr>
            <%}%>
            <%= tg.endContentTable() %>
            <%= tg.endTable() %>
            <%= tg.endBorder() %>
        </td>
    </tr>
</table>




<!-- Added by Rohini -->
<table width="100%">
   <tr>
     <td>
<div id='samplesDiv'>

<table width="100%">

   <tr>
      <td width="10%" valign="top">
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle() %><%=samplesRequestedLabel%><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>
         <col width="15%">
         <col width="35%">
         <col width="15%">
         <col width="35%">



    <tr>
        <td>
            <a href="javascript:clearSelections()"><img src="<%=WT_IMAGE_LOCATION%>/clear_16x16.gif" alt="<%= clearAll %>" ></a>
            <a href="javascript:selectSelections(false)"><img src="<%=WT_IMAGE_LOCATION%>/select.selections.png" alt="<%= selectAll %>" ></a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="javascript:removeRows()"><img src="<%=WT_IMAGE_LOCATION%>/delete.png" alt="<%= deleteSelectedRows %>"></a>
            <a href="javascript:insertNewRow()"><img src="<%=WT_IMAGE_LOCATION%>/insert_row_below.gif" alt="<%= insertAfterSelectRows %>"></a>
        </td>
    </tr>
    <%
    int visCount = 6;;

    %>


    <tr>
        <td width="100%">
            <table id="editorTable" align=left width="100%" class="editor" border="0" cellspacing="1" onClick="handleTableClick()">
                <tr id="columns">
                   <td class="TABLESUBHEADER">&nbsp;</td>
                   <td class="TABLESUBHEADER">&nbsp;</td>

				   <!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						Description : < The OOTB Quantity Label id hidden and added condition to add the Measurement 
						and Size column header in the Grid if the Product Type is only Apparel>
					-->
                        <!-- <td class="TABLESUBHEADER">&nbsp;*<%=quantityLabel%></td> -->

                        <%if(flag){
							if(MEASUREMENT_SIZE_REQUIRED){
                        %>
                           <td class="TABLESUBHEADER" nowrap>&nbsp;*<%=measurementSetLabel%></td>
                           <td class="TABLESUBHEADER">&nbsp;*<%=sizeColumnLabel%></td>

                        <%}else{
                        %>
                           <td class="TABLESUBHEADER" nowrap>&nbsp;<%=measurementSetLabel%></td>
                           <td class="TABLESUBHEADER">&nbsp;<%=sizeColumnLabel%></td>
                        
                        <%}
						}
                        %>
					<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						 Description : <Added Sample Quantity column Header in the Grid>
					-->
						<td class="TABLESUBHEADER">&nbsp;<%=sampleQuantityColumnLabel%></td>

                        
            <% if(DISPLAY_COLORCRITERIA) { %>
                <td class="TABLESUBHEADER">&nbsp;<%=colorLabel%></td>
            <% } %>

                </tr>



                <tr id="columns">
                   <td class="TABLESUBHEADER">&nbsp;</td>
                   <td class="TABLESUBHEADER">&nbsp;</td>

				   <!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						Description : < The OOTB Quantity Label id hidden and added condition to add the Measurement 
						and Size column header in the Grid if the Product Type is only Apparel>
					-->
                        <!-- <td class="TABLESUBHEADER">&nbsp;*<%=quantityLabel%></td> -->

                        <%if(flag){
							if(MEASUREMENT_SIZE_REQUIRED){
                        %>
                           <td class="TABLESUBHEADER" nowrap>&nbsp;*<%=measurementSetLabel%></td>
                           <td class="TABLESUBHEADER">&nbsp;*<%=sizeColumnLabel%></td>

                        <%}else{
                        %>
                           <td class="TABLESUBHEADER" nowrap>&nbsp;<%=measurementSetLabel%></td>
                           <td class="TABLESUBHEADER">&nbsp;<%=sizeColumnLabel%></td>
                        
                        <%}
						}
                        %>
					<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						 Description : <Added Sample Quantity column Header in the Grid>
					-->
						<td class="TABLESUBHEADER">&nbsp;<%=sampleQuantityColumnLabel%></td>

            <% if(DISPLAY_COLORCRITERIA) { %>
                <td class="TABLESUBHEADER">&nbsp;<%=colorLabel%></td>
            <% } %>
                </tr>

            </table>

        </td>
    </tr>
    <tr>
        <td>
            <a href="javascript:clearSelections()"><img src="<%=WT_IMAGE_LOCATION%>/clear_16x16.gif" alt="<%= clearAll %>"></a>
            <a href="javascript:selectSelections(false)"><img src="<%=WT_IMAGE_LOCATION%>/select.selections.png" alt="<%= selectAll %>"></a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="javascript:removeRows()"><img src="<%=WT_IMAGE_LOCATION%>/delete.png" alt="<%= deleteSelectedRows %>"></a>
            <a href="javascript:insertNewRow()"><img src="<%=WT_IMAGE_LOCATION%>/insert_row_below.gif" alt="<%= insertAfterSelectRows %>"></a>
        </td>
    </tr>
    <!-- SOURCE CELLS FOR DEFINING WIDGETS -->
    <tr>
        <td>
            <table>
					<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
					// Description : <Quantity Source Cell Hidden as not Required Any more in the Grid>
					 -->
<!--                     <td id="quantitySource"><div id="quantitySourceDiv">
<input type='text' value='' name='quantity' id='quantity' parent='quantity' onBlur='if(isValidIntegerRange(this, "<%=FormatHelper.formatJavascriptString(quantityLabel, false)%>", <%=quantityAtt.getAttLowerLimit()%>, <%=quantityAtt.getAttUpperLimit()%>, <%=quantityAtt.isAttUseUpperLimit()%>, <%=quantityAtt.isAttUseLowerLimit()%>)){handleWidgetEvent(this);}'></div></td>
 -->
<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
			// Description : <Added condition to add the Measurement and Size column Cell in the Grid>
			 -->
			 <%if(flag){%>
                    <td id="measurementsSetSource"><div id="measurementsSetSourceDiv">
<%=FormGenerator.createDropDownList(measurementsTable, "measurementsSet", null, "resetSampleSize(this)", 1, true) %>


</div></td>
                
                    <td id="sizeSource"><div id="sizeSourceDiv"><select name="size" id="size" parent="size" onkeydown="typeAhead()">
<option value=" ">
	<%}%>

			<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
			// Description : <Added Sample Quantity Cell to the Grid>
			 -->
					<td id="sampleQuantity"><div id="sampleQuantityDiv">
<input type='text' value='' name='lfFloatSampleQuantity' id='lfFloatSampleQuantity' parent='lfFloatSampleQuantity' onBlur='if(isValidIntegerRange(this, "Sample Quantity", -1.0E9, 1.0E9, false, false)){handleWidgetEvent(this);}'></div></td>


</select></div></td>

<%
// Added by Rohini
Hashtable colorsTable = new Hashtable();
if(DISPLAY_COLORCRITERIA){
    Iterator skuIter = appContext.getSKUs().iterator();
    LCSSKU skuObject;
    WTPartMaster skuMaster;
    String skuName = "";
    while (skuIter.hasNext()) {
        skuObject = (LCSSKU) skuIter.next();
        skuMaster =(WTPartMaster) skuObject.getMaster();
        skuName = (String)skuObject.getValue("skuName");
        colorsTable.put(FormatHelper.getNumericFromOid(skuMaster.toString()),skuName);
    }
}
%>

<% if(DISPLAY_COLORCRITERIA){ %>
    <td id="colorSource"  ><div id="colorSourceDiv">
    <%=FormGenerator.createDropDownList(colorsTable, "colors", null, null, 1, true) %>
</div></td>
<% } %>


            </table>
        </td>
    </tr>

  
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
      </td>
   </tr>

</table>
<div id="tableMenu" class="tableMenuStyle" onMouseover="highlightMenuOption()" onMouseout="lowlightMenuOption();checkHide();" onClick="invokeMenuAction();">
    <div class="menuItem" id="insertRow(false);"><%= insertAfterLabel %></div>
    <div class="menuItem" id="insertRow(true);"><%= insertBeforeLabel %></div>
    <div class="menuItem" id="removeRow();"><%= deleteLabel %></div>
</div>

<div id='tableMenuOV'>
<table>
    <tr><td><a href="javascript:insertRow(false);"><%= insertAfterLabel %></a></td></tr>
    <tr><td><a href="javascript:insertRow(true);"><%= insertBeforeLabel %></a></td></tr>
    <tr><td><a href="javascript:removeRow();"><%= deleteLabel %></a></td></tr>
</table>
</div>


</div>


<script>
    var menuArray = new Array();
    var tm = document.getElementById('tableMenuOV');
    menuArray['tableMenu'] = tm.innerHTML;
    tm.innerHTML = '';

    menuArray['childMenu'] = '';


    var cellTypes = new Object();
    var columnList = new Array();
    var alignments = new Object();
    var defaultValues = new Object();
    var sourceCell;
    var classNames = new Object();
    var precisions = new Object();

    var widget;
    
    DOM_TE_ALLOW_ROW_INSERT = true;
    

    
    DOM_TE_ALLOW_PERSISTED_ROW_DELETE = true;
    
		// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
		// Description : <Removed Quantity widget ,Added widget for Sample Quantity and condition for Measurement and Size Widget>

	<%if(flag){%>
    sourceCell = document.getElementById('measurementsSetSource');
    widget = sourceCell.childNodes[0];
    //alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
    while(sourceCell.childNodes.length > 0){
        //alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
        var child = sourceCell.removeChild(sourceCell.childNodes[0]);
        if(!("TEXT" == child.tagName)){
            widget = child;
        }
    }
    widgets["measurementsSet"] = widget;

    cellTypes["measurementsSet"] = "choice";
    columnList[columnList.length] = "measurementsSet";
    defaultValues[columnList[columnList.length-1]] = "null";
    precisions["measurementsSet"] = 0;

    
        sourceCell = document.getElementById('sizeSource');
        widget = sourceCell.childNodes[0];
        //alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
        while(sourceCell.childNodes.length > 0){
            //alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
            var child = sourceCell.removeChild(sourceCell.childNodes[0]);
            if(!("TEXT" == child.tagName)){
                widget = child;
            }
        }
        widgets["size"] = widget;

        cellTypes["size"] = "choice";
        columnList[columnList.length] = "size";
        defaultValues[columnList[columnList.length-1]] = "null";
        precisions["size"] = 0;
		<%}%>

        sourceCell = document.getElementById('sampleQuantity');
        widget = sourceCell.childNodes[0];
        //alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
        while(sourceCell.childNodes.length > 0){
            //alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
            var child = sourceCell.removeChild(sourceCell.childNodes[0]);
            if(!("TEXT" == child.tagName)){
                widget = child;
            }
        }
        widgets["lfFloatSampleQuantity"] = widget;

        cellTypes["lfFloatSampleQuantity"] = "float";
        columnList[columnList.length] = "lfFloatSampleQuantity";
        defaultValues[columnList[columnList.length-1]] = "null";
        precisions["lfFloatSampleQuantity"] = 0;



    <%    if(DISPLAY_COLORCRITERIA){ %>
            sourceCell = document.getElementById('colorSource');
            widget = sourceCell.childNodes[0];
            //alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
            while(sourceCell.childNodes.length > 0){
                //alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
                var child = sourceCell.removeChild(sourceCell.childNodes[0]);
                if(!("TEXT" == child.tagName)){
                    widget = child;
                }
            }
            widgets["color"] = widget;

            cellTypes["color"] = "choice";
            columnList[columnList.length] = "color";
            defaultValues[columnList[columnList.length-1]] = "null";
            precisions["color"] = 0;
        <%}%>

    


    var table = document.getElementById("editorTable");
    var tableMenu = document.getElementById("tableMenu");
    if(is.nav){
        table.addEventListener('click',handleTableClick,false);
        tableMenu.addEventListener('onmouseover',highlightMenuOption,false);
        tableMenu.addEventListener('onmouseout',checkHide,false);
        tableMenu.addEventListener('click',invokeMenuAction,false);
    }

    if(moaModel.dataModel.length == 0){
        //A default row cannot be added and defaulted with quantity, measurements set and size because it will create new samples
        //every time a sample is saved or toggled.

        insertRow(null, 1);
        //insertRow(null, 2);
        //insertRow(null, 3);
        
    }

    function updateFitSample(id) {
		endCellEdit();
        document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
        document.MAINFORM.action.value = 'SAVE_AND_UPDATE_MEASUREMENTS';
		document.MAINFORM.oid.value = document.getElementById("sampleId").value;
		document.MAINFORM.origActivity.value = document.MAINFORM.returnActivity.value;
		document.MAINFORM.origOid.value = document.MAINFORM.returnOid.value;
        submitForm();
    }

	function backCancel(){
		document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
        document.MAINFORM.action.value = 'CANCEL';
	    submitForm();
	}

      toggleDiv('samplesDiv');

</script>

        </td>
     </tr>
   </table>
<table width="100%">

<%
    //Tab permissions
    boolean detailsTab = true;
    boolean docsTab = true;

    boolean fitTab = (fitTest != null);
%>

 <tr>
   <td valign=top width="100%">
     <table width="100%">


        <tr>
        <td>
            <ul id="tabnav">
                <%--////////////////////////////////////////////////////////////////////////////// --%>
                <%--                Draw Tabs that make sense in Latest Iteration view             --%>
                <%--////////////////////////////////////////////////////////////////////////////// --%>
                
                <% if(detailsTab){ %>
                    <li id="sampleDetailTab" class="tabselected"><a href="javascript:changeTab('sampleDetailTab')"><%= detailsLabel %></a></li>
                <% } %>
                <% if(fitTab){ %>
                    <li id="fitTab" class="tab"><a href="javascript:changeTab('fitTab')"><%= fitButton %></a></li>
                <% } %>
				<% if(docsTab){ %>
					<li id="docsTab" class="tab"><a href="javascript:changeTab('docsTab')"><%= docsButton %></a></li>
				<% } %>

                <% if(imagesTab){ %>
                    <li id="imagesTab" class="tab"><a href="javascript:changeTab('imageTab')"><%= imageButton %></a></li>
                <% } %>

                
                
            </ul>

        </td>         
       

    </tr>

				<%
				flexg.setScope(null);
                Collection scopeLevelList = new Vector();
                HashMap table = new HashMap();
                table.put("scope", SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE);
                table.put("label", sampleRequestLabel);
                table.put("typed", sampleRequest);
                table.put("multiObject_typed", sampleRequest);
                table.put("moduleName", "SAMPLE-REQUEST");
                table.put("image_typed", sampleRequest);
                scopeLevelList.add(table);
				
				table = new HashMap();
				table.put("scope", SampleRequestFlexTypeScopeDefinition.SAMPLE_SCOPE);
				table.put("label", sampleLabel);
				table.put("typed", sample);
				table.put("multiObject_typed", sample);
				table.put("moduleName", "SAMPLE");
				table.put("image_typed", sample);
				scopeLevelList.add(table);				
				flexg.setScopeLevelList(scopeLevelList);

                        flexg.setSingleLevel(true);
                        flexg.setModuleName("SAMPLE");
				%>


    <!-- Sample Details Div -->
    <tr>
        <td>
            <div id='sampleDetailDiv'>

            <%= flexg.generateForm(sample) %>
        <%
				flexg.setScopeLevelList(null);
		%>
            </div>
        </td>
    </tr>
     <%	String specMasterId = (sample.getSpecMaster() != null)?FormatHelper.getNumericObjectIdFromObject(sample.getSpecMaster()):"";
        Collection pages = LCSSampleQuery.findImagePages(FormatHelper.getObjectId(sample), FormatHelper.getObjectId(sample.getCopiedFrom()), specMasterId);
        // Constuct table layout
        Collection imageColumns = new Vector();
        TableColumn imageColumn = new TableColumn();

		if(ACLHelper.hasDeleteAccess(imagePageType)){
			imageColumn = new TableColumn();
			imageColumn.setHeaderLabel("");
			imageColumn.setDisplayed(true);
			imageColumn.setLinkMethod("deleteSampleImage");
			imageColumn.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
			imageColumn.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
			imageColumn.setConstantDisplay(true);
			imageColumn.setConstantValue("<img src='" + WT_IMAGE_LOCATION + "/delete.png' border='0'" + " onmouseover=\"return overlib('" + FormatHelper.formatJavascriptString(deleteLabel) + "');\" onmouseout=\"return nd();\">");
			imageColumn.setFormatHTML(false);
			imageColumns.add(imageColumn);
		}

		if(ACLHelper.hasEditAccess(imagePageType)){
			imageColumn = new TableColumn();
			imageColumn.setHeaderLabel("");
			imageColumn.setDisplayed(true);
			imageColumn.setLinkMethod("saveAndUpdateImagesPage");
			imageColumn.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
			imageColumn.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
			imageColumn.setConstantDisplay(true);
			imageColumn.setConstantValue("<img src='" + WT_IMAGE_LOCATION + "/customize_tablebutton.gif' border='0'" + " onmouseover=\"return overlib('" + FormatHelper.formatJavascriptString(saveAndUpdate) + "');\" onmouseout=\"return nd();\">");
			imageColumn.setFormatHTML(false);
			imageColumns.add(imageColumn);
		}

        imageColumn = new TableColumn();
        imageColumn.setDisplayed(true);
        imageColumn.setHeaderLabel(imageLabel);
        imageColumn.setLinkMethod("displayImage");
        imageColumn.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
        imageColumn.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
        imageColumn.setTableIndex(imagePageType.getAttribute("name").getSearchResultIndex());
        imageColumns.add(imageColumn);

        //add image colum and description
        imageColumns.add(flexg.createTableColumn(imagePageType.getAttribute("pageDescription"), imagePageType, false));
        imageColumns.add(flexg.createTableColumn(imagePageType.getAttribute("pageType"), imagePageType, false));

    %>

    <!-- Fit Div -->
    <tr>
        <td>
            <div id="fitDiv">
                <% if(fitTab){

                    //Collection iPages = LCSSampleQuery.findImagePages(FormatHelper.getObjectId(sample));
                    Collection iColumns = new Vector();
                    TableColumn iColumn = new TableColumn();
                    FlexType iPageType = FlexTypeCache.getFlexTypeFromPath("Document\\Images Page");
                    // Constuct table layout
                    iColumns = new Vector();
                    iColumn = new TableColumn();
                    iColumn.setDisplayed(true);
                    iColumn.setHeaderLabel(imageNameLabel);
                    iColumn.setLinkMethod("viewObject");
                    iColumn.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
                    iColumn.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
                    iColumn.setTableIndex(imagePageType.getAttribute("name").getSearchResultIndex());
                    iColumns.add(iColumn);

                    //add image colum and description
                    iColumns.add(flexg.createTableColumn(iPageType.getAttribute("pageDescription"), iPageType, false));
                    iColumns.add(flexg.createTableColumn(iPageType.getAttribute("pageType"), iPageType, false));


                    //measurements = (LCSMeasurements) VersionHelper.latestIterationOf(fitTest.getMeasurementsMaster());

                    Collection fitTestData = LCSMeasurementsQuery.findFitTestData(fitTest).getResults();
                    //begin fix SPR 1738296
                    FlexType measurementsType = FlexTypeCache.getFlexTypeFromPath("Measurements");
					FlexTypeAttribute requestedMeasurementAtt = measurementType.getAttribute("requestedMeasurement");

                    String newMeasurementKey = measurementsType.getAttribute("newMeasurement").getSearchResultIndex();
                    String requestedMeasurementKey = measurementsType.getAttribute("requestedMeasurement").getSearchResultIndex();
                    
                    Iterator itFitTestData = fitTestData.iterator();
                    while (itFitTestData.hasNext()){						
                    	FlexObject fo = (FlexObject)itFitTestData.next();
                    	String requestedMeasurementValue = (String)fo.get(requestedMeasurementKey);
                    	String newMeasurementValue = (String)fo.get(newMeasurementKey);
						fo.put("POM_UPDATE_MEASUREMENT_SET_SWITCH", "ON"); //FIX OF SPR: 1551810

                    	if (FormatHelper.hasContent(requestedMeasurementValue)){
							if(Double.parseDouble(requestedMeasurementValue)==Double.parseDouble(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER)){
								fo.put("POM_UPDATE_MEASUREMENT_SET_SWITCH", "OFF"); //FIX OF SPR: 1551810
								if(!FormatHelper.hasContent(newMeasurementValue)){
									fo.put(newMeasurementKey, "0");
								}
							}else if (!requestedMeasurementValue.equals(newMeasurementValue) && (!FormatHelper.hasContentAllowZero(newMeasurementValue))) {
                    			fo.put(newMeasurementKey, fo.get(requestedMeasurementKey));
                    		}

                    	}
                    }
                    //end fix SPR 1738296
                    Collection columns = new Vector();
                    TableColumn column = null;
                    TableColumn overrideColumn = null;
                    UpdateTableColumn updateColumn;

            Iterator columnIter1;
            Iterator columnIter2;
            String columnKey;
            FlexTypeAttribute att;

            Collection atts = measurementType.getAllAttributes(MeasurementsFlexTypeScopeDefinition.MEASUREMENT_SCOPE, null, false);
            Map attMap = flexg.hashAttributesByKey(atts, "LCSPOINTSOFMEASURE.");

            flexg.setScope(MeasurementsFlexTypeScopeDefinition.MEASUREMENT_SCOPE);

            columnIter1 = ((ArrayList)columnList.get(0)).iterator();
            
            Vector selectedAtts = new Vector();
            while(columnIter1.hasNext()){
              columnKey = (String) columnIter1.next();
              att = (FlexTypeAttribute) attMap.get(columnKey);
              if(att == null || att.isAttHidden()){
                      continue;
              }
              selectedAtts.add(att);
              String attKey = att.getAttKey();
              column = flexg.createTableColumn(att, measurementType, false);

              if(att.getAttVariableType().equals("float") || att.getAttVariableType().equals("integer")){


                if (doubleFormat.startsWith("si.Length.")) {
                      column.setOutputUom(doubleFormat);
                      column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                } else {
                      column.setFormat(doubleFormat);
                }
                if(att.getAttKey().equals("plusTolerance") || att.getAttKey().equals("minusTolerance")){
                      overrideColumn = new UpdateMeasurementTableColumn();
                      column = new UpdateMeasurementTableColumn();

                      // handle Null Value Display if Place holder Row is set
                      overrideColumn.setShowCriteria("0");
                      overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
					  overrideColumn.setShowCriteriaNumericCompare(true);
                      ((UpdateMeasurementTableColumn)overrideColumn).setFlexTypeAttribute(att);
                      overrideColumn.setDisplayed(true);
                      overrideColumn.setHeaderLabel(att.getAttDisplay());
                      overrideColumn.setWrapping(att.isAttTableWrapable());
                      overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                      overrideColumn.setDecimalPrecision(att.getAttDecimalFigures());
                      overrideColumn.setAttributeType(att.getAttVariableType());
                      overrideColumn.setHeaderAlign("right");
                      overrideColumn.setAlign("right");
                      overrideColumn.setColumnClassIndex("POM_HIGHLIGHT");
                      if (doubleFormat.startsWith("si.Length.")) {
                         overrideColumn.setOutputUom(doubleFormat);
                         overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                      } else {
                         overrideColumn.setFormat(doubleFormat);
                      }

                      // handle Null Value Display if placeHolderRow is NOT set
                      column.setShowCriteria(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
                      column.setShowCriteriaNot(true);
                      column.setShowCriteriaTarget(att.getSearchResultIndex());
                      column.setShowCriteriaNumericCompare(true);
                      column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn, true);
                      column.setShowCriteriaOverride(true);

                      ((UpdateMeasurementTableColumn)column).setFlexTypeAttribute(att);
                      column.setDisplayed(true);
                      column.setHeaderLabel(att.getAttDisplay());
                      column.setWrapping(att.isAttTableWrapable());
                      column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                      column.setDecimalPrecision(att.getAttDecimalFigures());
                      column.setAttributeType(att.getAttVariableType());
                      column.setHeaderAlign("right");
                      column.setAlign("right");
                      column.setColumnClassIndex("POM_HIGHLIGHT");
                      if (doubleFormat.startsWith("si.Length.")) {
                         column.setOutputUom(doubleFormat);
                         column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                      } else {
                         column.setFormat(doubleFormat);
                      }
                      columns.add(column);
                      continue;
                    }
               }
               if(column instanceof UpdateTableColumn){
                updateColumn = (UpdateTableColumn) column;                                
                updateColumn.setEditMode("FORM_ONLY");
                updateColumn.setColumnClassIndex("POM_HIGHLIGHT");
                columns.add(updateColumn);
               } else {
                column.setColumnClassIndex("POM_HIGHLIGHT");
                columns.add(column);
               }
              }

             
            columnIter2 = ((ArrayList)columnList.get(1)).iterator();
            while(columnIter2.hasNext()){
                columnKey = (String) columnIter2.next();

                att = (FlexTypeAttribute) attMap.get(columnKey);
                if(att == null){
                    continue;
                }
                String attKey = att.getAttKey();

                column = flexg.createTableColumn(att, measurementType, att.isAttUpdateable());
                overrideColumn = flexg.createTableColumn(att, measurementType, att.isAttUpdateable());

			    column.setShowCriteria("0");
				column.setShowCriteriaNumericCompare(true);
                column.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
                
				if((att.getAttVariableType()).equals("float")){
                    if (doubleFormat.startsWith("si.Length.")) {
                        column.setOutputUom(doubleFormat);
                        column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                    } else {
                        column.setFormat(doubleFormat);
                    }
                }


                if(att.getAttKey().equals("actualMeasurement") || att.getAttKey().equals("quotedMeasurement") || att.getAttKey().equals("newMeasurement")){
					if(att.getAttKey().equals("newMeasurement")){
						newMeasurementUpdateable = ACLHelper.hasEditAccess(att); 
					}

                    // handle Null Value Display if placeHolderRow is set
                    overrideColumn.setShowCriteria("0");
					overrideColumn.setShowCriteriaNumericCompare(true);
                    overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
                    overrideColumn.setDisplayed(true);

                    if (doubleFormat.startsWith("si.Length.")) {
                        overrideColumn.setOutputUom(doubleFormat);
                        overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                    } else {
                        overrideColumn.setFormat(doubleFormat);
                    }                    
                    overrideColumn.setColumnClassIndex("POM_HIGHLIGHT");

                    // handle Null Value Display if placeholderRow is NOT set
                    column.setShowCriteria("0");
                    //column.setShowCriteriaNot(true);
                    column.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
                    column.setShowCriteriaNumericCompare(true);
                    column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn, true);
                    column.setShowCriteriaOverride(true);
                    if (doubleFormat.startsWith("si.Length.")) {
                        column.setOutputUom(doubleFormat);
                        column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                    } else {
                        column.setFormat(doubleFormat);
                    }                    
                }

                if(att.getAttKey().equals("requestedMeasurement") || att.getAttKey().equals("quotedMeasurementDelta") || att.getAttKey().equals("actualMeasurementDelta")){

                    overrideColumn = new UpdateMeasurementTableColumn();
                    column = new UpdateMeasurementTableColumn();
    
                    // handle Null Value Display if Place holder is set
                    overrideColumn.setShowCriteria("0");
					overrideColumn.setShowCriteriaNumericCompare(true);
                    overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
                    overrideColumn.setDisplayed(true);

                    ((UpdateMeasurementTableColumn)overrideColumn).setFlexTypeAttribute(att);
                    overrideColumn.setHeaderLabel(att.getAttDisplay());
                    overrideColumn.setWrapping(att.isAttTableWrapable());
                    overrideColumn.setDecimalPrecision(att.getAttDecimalFigures());
                    overrideColumn.setAttributeType(att.getAttVariableType());
                    overrideColumn.setHeaderAlign("right");
                    overrideColumn.setAlign("right");
                    if (doubleFormat.startsWith("si.Length.")) {
                        overrideColumn.setOutputUom(doubleFormat);
                        overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                    } else {
                        overrideColumn.setFormat(doubleFormat);
                    }
                    overrideColumn.setColumnClassIndex("POM_HIGHLIGHT");

                    // handle Null Value Display if Place holder is set
                    column.setShowCriteria(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
                    column.setShowCriteriaNot(true);
                    column.setShowCriteriaTarget(att.getSearchResultIndex());
                    column.setShowCriteriaNumericCompare(true);
                    column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn, true);
                    column.setShowCriteriaOverride(true);
    
					if(att.getAttKey().equals("quotedMeasurementDelta") || att.getAttKey().equals("actualMeasurementDelta")){
						column.setShowCriteriaTarget(requestedMeasurementAtt.getSearchResultIndex());
					}

                    ((UpdateMeasurementTableColumn)column).setFlexTypeAttribute(att);
                    column.setDisplayed(true);
                    column.setHeaderLabel(att.getAttDisplay());
                    column.setWrapping(att.isAttTableWrapable());
                    column.setDecimalPrecision(att.getAttDecimalFigures());
                    column.setAttributeType(att.getAttVariableType());
                    column.setHeaderAlign("right");
                    column.setAlign("right");
                    if (doubleFormat.startsWith("si.Length.")) {
                        column.setOutputUom(doubleFormat);
                        column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
                    } else {
                        column.setFormat(doubleFormat);
                    }



                    if(att.getAttKey().equals("quotedMeasurementDelta") || att.getAttKey().equals("actualMeasurementDelta")){
                        ((UpdateMeasurementTableColumn)column).setUpdateable(true);
                        ((UpdateMeasurementTableColumn)column).setPlusToleranceAtt(measurementType.getAttribute("plusTolerance").getSearchResultIndex());
                        ((UpdateMeasurementTableColumn)column).setMinusToleranceAtt(measurementType.getAttribute("minusTolerance").getSearchResultIndex());                                      
                    }         
                    column.setColumnClassIndex("POM_HIGHLIGHT");
                    columns.add(column);
                    continue;
                  
                }
              
                if(column instanceof UpdateTableColumn){
                    updateColumn = (UpdateTableColumn) column;                                            
                    updateColumn.setEditMode("FORM_ONLY");
                    updateColumn.setColumnClassIndex("POM_HIGHLIGHT");
                    columns.add(updateColumn);
                } else {
                    column.setColumnClassIndex("POM_HIGHLIGHT");
                    columns.add(column);
                }
            }
             //// End : Rohini

            // COLLECT MEASUREMENT VALUES FOR THE SAMPLE SIZE


            // MAY NOT NEED THIS QUERY ANY MORE
            //Map pomValueMap = new LCSMeasurementsQuery().getPOMIdSizeValueMapForSize(measurements, fitTest.getSampleSize());
            //Iterator pomValIter = pomValueMap.keySet().iterator();
            String pomId;
            String value;
            FlexObject pomFO;
            Collection pomValueData = new ArrayList();

            Iterator poms = LCSMeasurementsQuery.findPointsOfMeasure(measurements).iterator();
            LCSPointsOfMeasure pom;
            MeasurementValues mv;
            int j=0;
            FlexTypeAttribute loopAtt = null;
            while(poms.hasNext()){
                pom = (LCSPointsOfMeasure) poms.next();
                pomId = "" + pom.getId();
                pomFO = new FlexObject();
                mv = (MeasurementValues) pom.getMeasurementValues().get(fitTest.getSampleSize());
                if(mv != null){
                    pomFO.put("POM_VALUE", "" + mv.getValue());
                }
                pomFO.put("POM_IDA2A2", FormatHelper.getNumericObjectIdFromObject(pom));
                pomFO.put("POM_ID", pomId);
                pomFO.put("POM_HIGHLIGHT", pom.getValue("highLight"));
                for(j=0; j<selectedAtts.size(); j++){
                    loopAtt = (FlexTypeAttribute)selectedAtts.get(j);
                    pomFO.put(loopAtt.getSearchResultIndex(), pom.getValue(loopAtt.getAttKey()));
                }
                pomValueData.add(pomFO);

            }


            // JOIN MEASUREMENTS DATA TO FIT TEST DATA
            fitTestData = FlexObjectUtil.join(fitTestData, pomValueData, "LCSPOINTSOFMEASURE.INSTANCESOURCEID", "POM_ID", true);
            
            // For Current Measurement
            overrideColumn = flexg.createTableColumn(measurementType.getAttribute("requestedMeasurement"), measurementType, false);
            column = flexg.createTableColumn(measurementType.getAttribute("requestedMeasurement"), measurementType, false);

            FlexTypeAttribute attDecimalPercision = measurementType.getAttribute("requestedMeasurement");

            // handle Null Value Display if Place holder is set
            overrideColumn.setShowCriteria("0");
            overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
			overrideColumn.setShowCriteriaNumericCompare(true);
            overrideColumn.setDisplayed(true);
            overrideColumn.setHeaderLabel(currentMeasurementLabel);
            overrideColumn.setTableIndex("POM_VALUE");
            if (doubleFormat.startsWith("si.Length.")) {
                 overrideColumn.setOutputUom(doubleFormat);
                 overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
            } else {
                 overrideColumn.setFormat(doubleFormat);
            }
            overrideColumn.setHeaderAlign("right");
            overrideColumn.setAlign("right");
            overrideColumn.setColumnClassIndex("POM_HIGHLIGHT");

            // handle Null Value Display if Place holder is set
            column.setShowCriteria(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
            column.setShowCriteriaNot(true);
            column.setShowCriteriaTarget("POM_VALUE");
            column.setShowCriteriaNumericCompare(true);
            column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn, true);
            column.setShowCriteriaOverride(true);

            column.setHeaderLabel(currentMeasurementLabel);
            column.setTableIndex("POM_VALUE");
            column.setDisplayed(true);
            if (doubleFormat.startsWith("si.Length.")) {
                 column.setOutputUom(doubleFormat);
                 column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT_NO_SYMBOLS);
            } else {
                 column.setFormat(doubleFormat);
            }
            column.setHeaderAlign("right");
            column.setAlign("right");
            column.setColumnClassIndex("POM_HIGHLIGHT");
            columns.add(column); 
               
           
          boolean isLatestIteration = false;
          boolean isCheckedOut = false;
          boolean isWorkingCopy = false;
          boolean isCheckedOutByUser = false;
          boolean isLocked = false;
          isLatestIteration = VersionHelper.isLatestIteration(measurements);
          isCheckedOut = VersionHelper.isCheckedOut(measurements);
          isWorkingCopy = VersionHelper.isWorkingCopy(measurements);
          isCheckedOutByUser = VersionHelper.isCheckedOutByUser(measurements);
          boolean editable = ((!isCheckedOut && !isLocked )|| isCheckedOutByUser);
          if(editable&&ACLHelper.hasModifyAccess(measurements) && newMeasurementUpdateable){
             if(fitTest.getSampleSize().equals(measurements.getSampleSize()) || UPDATE_NON_BASE_SIZE_VALUES){
                  column = new TableColumn();
             column.setDisplayed(true);
             //column.setHeaderLabel(updateMeasurementsSetLabel + "<br><input type=\"checkbox\" id=\"selectAllCheckBox\" value=\"false\" onClick=\"javascript:toggleAllItems()\" checked>");

			 // Target Point Build : <004.23> Request ID : <7> Modified On: 6-June-2013 Author : <Girish>
			 // Description : <To set the checkbox by default false for Header and Commented out OOTB line>
             column.setHeaderLabel(updateMeasurementsSetLabel + "<br><input type=\"checkbox\" id=\"selectAllCheckBox\" value=\"false\" onClick=\"javascript:toggleAllItems()\">");
             column.setHeaderAlign("left");
             column.setActions(new Vector());
             CheckBoxTableFormElement fe = new CheckBoxTableFormElement();
             fe.setValueIndex("POM_IDA2A2");
             fe.setName("selectedPOMIds");

             //FIX OF SPR: 1551810
             //fe.setCheckedCriteria("ON");

			 // Target Point Build : <004.23> Request ID : <7> Modified On: 6-June-2013 Author : <Girish>
			 // Description : <To set the checkbox by default false for POM Data and Commented out OOTB line>
             fe.setCheckedCriteria("OFF");
             fe.setCheckedCriteriaTarget("POM_UPDATE_MEASUREMENT_SET_SWITCH");
             

             column.setShowCriteria("0");
			 column.setShowCriteriaNumericCompare(true);
             column.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
             column.setFormElement(fe);     
             column.setColumnClassIndex("POM_HIGHLIGHT");
             column.setColumnWidth("10%");
             columns.add(column);
             }
          }

             // SORT BY SORTING NUMBER
             Collection tableData = SortHelper.sortFlexObjectsByNumber(fitTestData, "LCSPOINTSOFMEASURE.SORTINGNUMBER");

                  %>

                        <table width='100%'>
                          <tr>
                            <td>
                              <table width='100%'>
                               <tr>
                                <td class="HEADING2" nowrap="">
                                    <%= fitInformationPgHead %>
								 </td>
								 <td class="button" nowrap="">

								 <% if(ACLHelper.hasModifyAccess((FlexTyped)measurements) && editable) { %>
								     <a onmouseover="return overlib('<%= FormatHelper.formatJavascriptString(updateFitSampleMouseOverToolTip) %>');" onmouseout="return nd();" class="button" href="javascript:updateFitSample('<%= FormatHelper.getObjectId(measurements) %>')"><%= updatePOMsButton %></a>
                                 <%}else{%>
								     <a onmouseover="return overlib('<%= FormatHelper.formatJavascriptString(noAccesstoUpdateMeasurementsMouseOverTooltip) %>');" onmouseout="return nd();" class="button" disabled="true"><%= updatePOMsButton %></a>

								 <%}%>&nbsp;&nbsp;|&nbsp;&nbsp;<a class="button" href="javascript:refreshFitSample()"><%= reApplyPomsButton %></a>

                               </td>
                                <td width=50%>
                                 &nbsp;&nbsp;
                                </td>
                                <%
                                  FlexTypeAttribute attCriticalPom = measurements.getFlexType().getAttribute("criticalPom");
                                  String criticalPomDisplay = attCriticalPom.getAttDisplay();
                                  String stringValue = attCriticalPom.getAttDefaultValue();
                                  AttributeValueList list = attCriticalPom.getAttValueList();
                                  %>
                                 <%= fg.createDropDownListWidget(filterLabel, list.toLocalizedMapSelectable(lcsContext.getLocale()), "criticalPomFilter", stringValue, "filterTable('" + FormatHelper.formatJavascriptString(criticalPomDisplay) + "')", false) %>
         
                              <%
                                Map formats = new HashMap();
								formats.put("si.Length.in", inUnitLabel);
								formats.put("si.Length.cm", cmUnitLabel);
								formats.put("si.Length.ft", ftUnitLabel);
								formats.put("si.Length.m", mUnitLabel);
                             %>
                               <%=fg.createDropDownListWidget(uomLabel, formats, "measurementsFormat", doubleFormat, "toggleSample('" + oid + "')", false, false)%> 
                          
                                 
                               </tr>
                             </td>
                             </table> 
                            </td>  
                          </tr>  
                          <tr>
                            <td>
                                <div>
                                   <% 
                                    tg.setRowIdIndex("LCSPOINTSOFMEASURE.IDA2A2");
                                    tg.setSortable(true);
                                    tg.setClientSort(true);
                                   %>
                                    <%= tg.drawTable(tableData, columns, measurementSetLabel + " " + baseSizeLabel + ": " + measurements.getSampleSize() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + sampleSizeOrderedLabel + ": " + fitTest.getSampleSize()) %>
                                </div>
                                <% tid = "TBLT" + tg.getTableId(); %>
                                <input type="hidden" id="measurementsHtmlTableId" value="<%=tid%>">

                            </td>
                          </tr>
                        </table>

                <% } %>
              </div>
         </td>
    </tr>

	            <!-- Doc Div -->
            <tr>
                <td colspan=2>
                    <div id="docsDiv">
					 <%if(docsTab) { %>
						<jsp:include page="<%=subURLFolder+ DOCUMENT_REFERENCES %>" flush="true">
							<jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sample) %>" />
							<jsp:param name="returnActivity" value="VIEW_SAMPLE" />
							<jsp:param name="returnOid" value="<%= FormatHelper.getObjectId(sample) %>" />
						</jsp:include>
						<%}%>
                    </div>
                </td>
            </tr>



    <!-- Images Div -->
<% if (imagesTab) {
	tg.setClientSort(true);

	%> 
    <tr>
        <td>
            <div id="imagesDiv">

                <table width='100%'>
                    <tr>
                      <td>
						<table>
						  <tr>
							<td class="HEADING2" align="top">
								<%= imagePgHead %>
							</td>
							<td class="button">
							   <%if(ACLHelper.hasCreateAccess(imagePageType)){%>
								<a class="button" href="javascript:createSampleImage()"><%= addImageButton %></a>&nbsp;&nbsp;
								<%}else{%>
								<a class="button" disabled=true><%= addImageButton %></a>&nbsp;&nbsp;

								<%}%>							</td>
                           </tr>
                        </table>
					  </td>
					</tr>
                    <tr>
                        <td>
                            <%= tg.drawTable(pages, imageColumns, "", true, false) %>
                        </td>
                    </tr>
                    <tr>
                        <td align="middle" rowspan="1">
                            <% if (FormatHelper.hasContent(request.getParameter("imagePageId"))) { %>
                                <%
                                    String imagePageId = request.getParameter("imagePageId");
                                %>
                                <jsp:include page="<%=subURLFolder+ IMAGE_PAGE_PLUGIN %>" flush="true">
                                    <jsp:param name="documentId" value="<%= imagePageId %>" />
                                    <jsp:param name="hideFileTable" value="false" />
                                </jsp:include>
                            <% } %>
                        </td>
                    </tr>
                </table>
        
            </div>
        </td>
    </tr>
    <% }%>

  


     <tr>
        <td>&nbsp;</td>
     </tr>
    
    
    
</table>

</td>

</tr>
    <tr>
        <td>
            <table width="100%">
                <tr>
                    <td>
                       &nbsp;
                    </td>
                    <td class="button" align="right">
                        <a class="button" href="javascript:update()"><%= saveButton %></a>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <a class="button"  href="javascript:backCancel()"><%= cancelButton %></a>
                    </td>
               </tr>
           </table>
       </td>
    </tr>
</table>
<script>
<%if(imagesTab){%>
      toggleDiv('imagesDiv');
      toggleDiv('fitDiv');
<%}%>     
	 toggleDiv('docsDiv');



<% 
  if("fitTab".equals(request.getParameter("tabId"))){
%>
    changeTab('fitTab');
<%
   }else if(imagesTab && "imageTab".equals(request.getParameter("tabId"))){
%>
    changeTab('imageTab');

<%
   }else if("docsTab".equals(request.getParameter("tabId"))){
%>
    changeTab('docsTab');

<%
   }else if("sampleDetailTab".equals(request.getParameter("tabId"))){
%>
    changeTab('sampleDetailTab');   
<%
   } else {
%>
    <% if(fitTab){ %>
        changeTab('fitTab');
    <% } %>
        
<%
   }
%> 

function showSampleCreationDiv(){
	if(document.getElementById("samplesDiv").style.display!='block'){
		if(validate()){
			toggleDiv("samplesDiv");
			hideDiv("sampleDetailDiv");
			if(document.getElementById("fitDiv")){
				hideDiv("fitDiv");
			}
			<%if(imagesTab){%>
			hideDiv("imagesDiv");
			<%}%>
			hideDiv("docsDiv");
			hideDiv("tabnav");
		}
	}else{
		toggleDiv("samplesDiv");
		if(document.MAINFORM.tabId.value=='sampleDetailTab'){
			showDiv("sampleDetailDiv");
		}
		if(document.getElementById("fitDiv") && document.MAINFORM.tabId.value=='fitTab'){
			showDiv("fitDiv");
		}
		if(document.MAINFORM.tabId.value=='imageTab'){
			showDiv("imagesDiv");
		}
		if(document.MAINFORM.tabId.value=='docsTab'){
			showDiv("docsDiv");
		}
		showDiv("tabnav");
	}
}

function saveSampleData(actionName){
	endCellEdit();
	if(validate() && validate2()){
		document.MAINFORM.oid.value = document.getElementById("sampleId").value;
		document.MAINFORM.LCSSAMPLE_measurementsFormat.value = '<%=doubleFormat%>';            
		document.MAINFORM.activity.value = 'UPDATE_MULTIPLE_SAMPLE';
		document.MAINFORM.action.value = actionName;
		if(document.getElementById("samplesDiv").style.display=='block'){
			var dataString = getDataString();
			document.MAINFORM.LCSSAMPLE_sampleRequestString.value = dataString;
		}
		selectPOMs();
		submitForm();
	}else{
		var samplesDropdown = document.MAINFORM.sampleId;
		for (i=0; i<samplesDropdown.options.length; i++) {
			if (samplesDropdown.options[i].value=='<%=FormatHelper.getObjectId(sample)%>') {
				samplesDropdown.options[i].selected=true;
				break;
			}
		}
	}
}


function addNewDocument(targetSuffix, referenceType){
    if(referenceType=='referenceDoc'){
		saveSampleData("SAVE_AND_REF_DOC");	
	}else{
		saveSampleData("SAVE_AND_DESC_DOC");	
	}
}


function addDocuments(ids, targetSuffix) {
    closeChooser();
	document.MAINFORM.oids.value = ids;
	saveSampleData("SAVE_AND_ADD_DOC");	
}

function removeDocument(id, targetSuffix) {
    if(confirm(document.DOCUMENT_REFERENCES.removeReferenceToDoc)){
        document.MAINFORM.docRefId.value = id;
		saveSampleData("SAVE_AND_REMOVE_DOC");	
    }
}
function removeDocuments(targetSuffix, referenceType) {
    if(referenceType=='referenceDoc'){
	    if(confirm(document.DOCUMENT_REFERENCES.removeReferencesToAllReferenceDocs)){
			saveSampleData("SAVE_AND_REMOVE_ALL_REF_DOC");	
		}
	}else if(referenceType == "describedByDoc") {
		if(confirm(document.DOCUMENT_REFERENCES.removeReferencesToAllDescribedByDocs)){
			saveSampleData("SAVE_AND_REMOVE_ALL_DESCRIBED_BY_DOC");	
		}
	}else{
		if(confirm(document.DOCUMENT_REFERENCES.removeReferencesToAllDocs)){
			saveSampleData("SAVE_AND_REMOVE_ALL_DOC");	
		}
	}
}


function updateDocumentReference(id, targetSuffix){
    document.MAINFORM.docRefId.value = id;
	saveSampleData("SAVE_AND_UPDATE_DOC");	
}

function iterationHistory(oid){
    document.MAINFORM.docRefId.value = oid;
	saveSampleData("SAVE_AND_DOC_HISTORY");	
}

///The handleWidget was overriden by the local function making CSP functions invalid.  The following will fix the issue
var oldHandleWidgetEvent = handleWidgetEvent;

handleWidgetEvent=function(widgetObj) {
	handleFitWidgetEvent(widgetObj);
   return oldHandleWidgetEvent(widgetObj);

}

var oldHandleKeyNow = handleKeyNow;
	handleKeyNow=function(keyCode, shiftPressed, ctrlPressed, altPressed, name) {	
	if (<%=ENTER_MEASUREMENTS_IN_FIT_WITH_ONE_HAND%>){

		handleFitKeyNow(keyCode, name);
	}
	if(keyCode == 9 && document.getElementById("samplesDiv").style.display!='block'){ //the tab key event shouldn't be caught by the handleKeyNow function of the domtableeditor.js if the create sample div is not active.
		return;
	}
	return oldHandleKeyNow(keyCode, shiftPressed, ctrlPressed, altPressed, name);
	
}

	//Target Point Build : 004.24 
	//Request ID : 4
	//Modified On: 06-Jun-2013
	//Author : Shamel
	//Description : whenever user clicks on the TAB it has to go vertically 
	
	<%if(fitTab){%>
	addTabIndex();
	function addTabIndex(){
		var quotedMeasurementInput;
		var actualMeasurementInput;
		var newMeasurementInput;
		var sampleMeasurementComments;

		var currentRowId;
		var nextRow;
		var nextCellId;
		var nextRowIndex	 = 1;
		var tableName		 = document.getElementById("measurementsHtmlTableId").value;
		var currentTable	 = document.getElementById(tableName);
		var currentTableRows = currentTable.rows.length;
		for( nextRowIndex = 1 ; nextRowIndex<currentTableRows ; nextRowIndex=nextRowIndex+1 ){
			if(currentTable.rows[nextRowIndex]) {
				nextRow	 =	 currentTable.rows[nextRowIndex];
				quotedMeasurementInput		=	"M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_quotedMeasurementInput";//M_F_852762_LCSPOINTSOFMEASURE$852762_quotedMeasurementInput
				actualMeasurementInput		=	"M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_actualMeasurementInput";//M_F_852762_LCSPOINTSOFMEASURE$852762_actualMeasurementInput
				newMeasurementInput			=	"M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_newMeasurementInput";//M_F_852762_LCSPOINTSOFMEASURE$852762_newMeasurementInput
				sampleMeasurementComments	=	"M_F_" + nextRow.id + "_LCSPOINTSOFMEASURE$" + nextRow.id + "_sampleMeasurementComments"; //M_F_852762_LCSPOINTSOFMEASURE$852762_sampleMeasurementComments
				if(document.getElementById(quotedMeasurementInput)){	document.getElementById(quotedMeasurementInput).tabIndex = "1";}
				if(document.getElementById(actualMeasurementInput)){	document.getElementById(actualMeasurementInput).tabIndex = "2";}
				if(document.getElementById(newMeasurementInput)){		document.getElementById(newMeasurementInput).tabIndex = "3";}
				if(document.getElementById(sampleMeasurementComments)){	document.getElementById(sampleMeasurementComments).tabIndex = "4";}
			}	
		}
	}
	<%}%>
	//Target Point Build : 004.24 
	//Request ID : 4
	//Modified On: 06-Jun-2013
	//Author : Shamel
	//Description : whenever user clicks on the TAB it has to go vertically 

</script>
