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
                wt.util.*,
                com.lcs.wc.sample.*,
				java.math.BigDecimal,
                java.util.*,
				java.awt.Color,
				java.awt.Font,
				com.lcs.wc.client.*,
				java.io.*,
				java.text.*"
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

	<%--
	//Target Point Build : 004.24 
	//Request ID : 5
	//Modified On: 14-Jun-2013
	//Author : Shamel
	//Description : if measurement is differen than requested measurement, then colur sgould be green.
	--%>

<style type="text/css" media=screen>
   .OUT_OF_TOLERANCE_HIGHLIGHT_TBLD {
		font-family: Arial;
		font-weight: bold;
		color: Green;
		background-color: rgb(242, 245, 247);;
		padding-left : 8px;
		padding-right : 8px;
		vertical-align: text-top;
		font-style: italic;
	}
	.OUT_OF_TOLERANCE_HIGHLIGHT_TBLL {
		font-family: Arial;
		font-weight: bold;
		color: Green;
		background-color: white;
		padding-left : 8px;
		padding-right : 8px;
		vertical-align: text-top;
		font-style: italic;
	}
	.OUT_OF_TOLERANCE_HIGHLIGHT_HIGHLIGHT_WHITE{
		font-family: Arial;
		font-weight: bold;
		color: Green;
		background-color: white;
		padding-left : 8px;
		padding-right : 8px;
		vertical-align: text-top;
		font-style: italic;
	}
	.OUT_OF_TOLERANCE_HIGHLIGHT_HIGHLIGHT_PALEBLUE {
		font-family: Arial;
		font-weight: bold;
		color: Green;
		background-color: #99CCFF;
		padding-left : 8px;
		padding-right : 8px;
		vertical-align: text-top;
		font-style: italic;
	}
</style>

	<%--
	//Target Point Build : 004.24 
	//Request ID : 5
	//Modified On: 14-Jun-2013
	//Author : Shamel
	//Description : if measurement is differen than requested measurement, then colur sgould be green.
	--%>

<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final String VIEW_MEASUREMENTS_COLUMN_ORDER = PageManager.getPageURL("VIEW_MEASUREMENTS_COLUMN_ORDER", null);

    public static final boolean DISPLAY_COMMENTS = LCSProperties.getBoolean("jsp.testing.displayLineItemComments");
    public static final boolean DISPLAY_QUOTED   = LCSProperties.getBoolean("jsp.testing.displayQuotedValues");
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final String IMAGE_PAGE_PLUGIN = PageManager.getPageURL("VIEW_IMAGEPAGE_DOCUMENT_PLUGIN", null);
    public static final String ACTION_OPTIONS = PageManager.getPageURL("ACTION_OPTIONS", null);
    public static final String SAMPLE_META_DATA = PageManager.getPageURL("SAMPLE_META_DATA", null);
    public static final String DISCUSSION_FORM_POSTINGS = PageManager.getPageURL("DISCUSSION_FORM_POSTINGS", null);
    public static final String DISCUSSION_FORM = PageManager.getPageURL("DISCUSSION_FORM", null);
    public static final boolean FORUMS_ENABLED= LCSProperties.getBoolean("jsp.discussionforum.discussionforum.enabled");

    public static final boolean SUBSCRIPTION_ENABLED= LCSProperties.getBoolean("jsp.subscriptions.enabled");
    public static final String SUBSCRIPTION_FORM = PageManager.getPageURL("SUBSCRIPTION_FORM", null);

    public static final boolean DISPLAY_COLORCRITERIA = LCSProperties.getBoolean("jsp.testing.FitApproval.ColorCriteria");
    public static final String PDF_GENERATOR = PageManager.getPageURL("PDF_GENERATOR", null);
    public static final boolean DISPLAY_DELTA = LCSProperties.getBoolean("jsp.testing.displayDeltaValues");
	public static final String DOCUMENT_REFERENCES = PageManager.getPageURL("DOCUMENT_REFERENCES", null);
    public static final boolean CLIENT_SIDE_EMAIL = LCSProperties.getBoolean("com.lcs.wc.util.clientSideEmail.enabled");
    public static final boolean SERVER_USING_MULTIPLE_PROTOCALS = LCSProperties.getBoolean("com.lcs.wc.util.MultiProtocalAccessToServer");
    public static String getUrl = "";
    public static String WindchillContext = "/Windchill";
    public static String windchillHost = "";
	public static String proxyWebHostOverride = "";
    public static String windchillPort = "";
    public static String proxyWebPortOverride = "";
    public static final boolean proxyWebPortDisabled = LCSProperties.getBoolean("com.lcs.wc.util.webserver.proxyWebPortDisabled");


    public static final String defaultUnitOfMeasure = LCSProperties.get("com.lcs.measurements.defaultUnitOfMeasure", "si.Length.in");
    public static String baseUOM = "";
    public static String instance = "";
    static {
        try {

            WTProperties wtproperties = WTProperties.getLocalProperties();
			getUrl = wtproperties.getProperty("wt.server.codebase","");
			WindchillContext = "/" + wtproperties.getProperty("wt.webapp.name");
            windchillHost = wtproperties.getProperty("wt.rmi.server.hostname","");
			proxyWebHostOverride = LCSProperties.get("com.lcs.wc.util.webserver.proxyWebHostOverride",windchillHost);
            windchillPort = wtproperties.getProperty("wt.webserver.port");
			proxyWebPortOverride = LCSProperties.get("com.lcs.wc.util.webserver.proxyWebPortOverride",windchillPort);

			windchillHost = proxyWebHostOverride;
			if(!proxyWebPortDisabled) windchillHost += ":" + proxyWebPortOverride;

            instance = wt.util.WTProperties.getLocalProperties().getProperty ("wt.federation.ie.VMName");
            UomConversionCache UCC = new UomConversionCache();
            Map allUOMS = UCC.getAllUomKeys();
            HashMap inputUnit = (HashMap)allUOMS.get(defaultUnitOfMeasure);
            baseUOM = (String)inputUnit.get("prompt");
        } catch(Exception e){
            e.printStackTrace();
        }
    }    
    public static final String LIFE_CYCLE_MANAGED = PageManager.getPageURL("LIFE_CYCLE_MANAGED", null);
    public static final String TEAM_MANAGED = PageManager.getPageURL("TEAM_MANAGED", null);    


    public static boolean testTolerance(String requested, String tested, String plusTol, String minusTol, int precision, String doubleFormat){

		if(!FormatHelper.hasContentAllowZero(plusTol) || (FormatHelper.hasContentAllowZero(plusTol) && Double.parseDouble(plusTol) == Double.parseDouble(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER))){
			  return true;
		}
		
		if(!FormatHelper.hasContentAllowZero(minusTol) || (FormatHelper.hasContentAllowZero(minusTol) && Double.parseDouble(minusTol) == Double.parseDouble(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER))){
			  return true;
		}

		if("FRACTION_FORMAT".equals(doubleFormat)){
			doubleFormat = "si.Length.in";
		}

        requested = MetricFormatter.uomConvertor(requested, doubleFormat, precision, false, false);
        tested = MetricFormatter.uomConvertor(tested, doubleFormat, precision, false, false);
        plusTol = MetricFormatter.uomConvertor(plusTol, doubleFormat, precision, false, false);
        minusTol = MetricFormatter.uomConvertor(minusTol, doubleFormat, precision, false, false);

		BigDecimal requestedFloat = new BigDecimal(requested);
		BigDecimal testedFloat = new BigDecimal(tested);
		BigDecimal plusTolFloat = new BigDecimal(plusTol);
		BigDecimal minusTolFloat = new BigDecimal(minusTol);

		if(requestedFloat == testedFloat){
            return true;
        }

        boolean greaterThan = ((requestedFloat.subtract(testedFloat)).compareTo(new BigDecimal("0"))== -1);
        BigDecimal dif = requestedFloat.subtract(testedFloat).abs();

        if(greaterThan && (dif.compareTo(plusTolFloat)<=0 || dif.compareTo(plusTolFloat)==0)){
            return true;
        }
        if(!greaterThan && (dif.compareTo(minusTolFloat)<=0 || dif.compareTo(minusTolFloat)==0)){
            return true;
        }
        return false;
    }


%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
flexg.setModuleName("SAMPLE_IMAGE");

String quantityLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "quantity_LBL", RB.objA ) ;
String colorLabel = WTMessage.getLocalizedMessage ( RB.COLOR, "color_LBL", RB.objA ) ;
String actionsPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "actions_PG_HEAD", RB.objA ) ;
String closeLabel = WTMessage.getLocalizedMessage (RB.MAIN, "closeWithParenths", RB.objA ) ;
String saveButton = WTMessage.getLocalizedMessage ( RB.MAIN, "save_Btn", RB.objA ) ;

String cancelButton = WTMessage.getLocalizedMessage ( RB.MAIN, "cancel_Btn", RB.objA ) ;
String addImageButton = WTMessage.getLocalizedMessage ( RB.UPDATESAMPLE, "createSampleImage_Btn", RB.objA);
String refreshButton = WTMessage.getLocalizedMessage ( RB.UPDATESAMPLE, "refresh_Btn", RB.objA ) ;
String imageButton = WTMessage.getLocalizedMessage ( RB.MAIN, "image_LBL", RB.objA ) ;
String returntoFitApprovalButton = WTMessage.getLocalizedMessage ( RB.SAMPLES, "returntoFitApproval_Btn", RB.objA ) ;
String updateSamplePgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "updateSample_PG_HEAD", RB.objA ) ;
String sampleAttributesGrpTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleAttributes_GRP_TLE", RB.objA ) ;
String typeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "type_LBL", RB.objA ) ;
String newRequestLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "newRequest_LBL", RB.objA ) ;
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
String saveAndUpdate = WTMessage.getLocalizedMessage ( RB.MAIN, "saveAndUpdate_LBL",RB.objA ) ;
String deleteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "delete_LBL",RB.objA ) ;
String imageNameLabel = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "imageName_LBL",RB.objA ) ;
String specLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "specification_LBL",RB.objA ) ;
String measurementsSetLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "measurementsSet_LBL", RB.objA) ;
String sampleRequestDetailsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequestDetails_LBL", RB.objA ) ;
String sampleDetailsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleDetails_PG_HEAD", RB.objA ) ;
String detailsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "details_LBL", RB.objA ) ;
String updateMeasurementsSetLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "updateMeasurementsSet_LBL", RB.objA ) ;
String currentMeasurementLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "currentMeasurement_LBL", RB.objA ) ;
String sampleSizeLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sampleSize_LBL",RB.objA ) ;
String pomsLabel = WTMessage.getLocalizedMessage (  RB.MEASUREMENTS, "poms_plural_LBL",RB.objA ) ;
String uomLabel = WTMessage.getLocalizedMessage (  RB.MEASUREMENTS, "uom_LBL",RB.objA ) ;
String decimalLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "decimal_LBL",RB.objA ) ;
String fractionLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "fraction_LBL",RB.objA ) ;
String viewSampleRequestPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "viewSampleRequest_PG_HEAD", RB.objA );
String sampleRequestLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequest_PG_HEAD", RB.objA );
String sampleRequestAttributesGrpTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequestAttributes_GRP_TLE", RB.objA ) ;
String sampleLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sample_LBL", RB.objA ) ;
String sampleCommentsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleComments_LBL", RB.objA ) ;
String samplesLabel = WTMessage.getLocalizedMessage ( RB.MATERIALCOLOR, "samples_GRP_TLE", RB.objA ) ; //"Samples";
String updateLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "update_LBL",RB.objA ) ;
String retrievingSampleCommentsPleaseBePatientMsg = WTMessage.getLocalizedMessage ( RB.SAMPLES, "retrievingSampleCommentsPleaseBePatient_MSG", RB.objA ) ;
String pleaseSelectMeasurementSetMSG = WTMessage.getLocalizedMessage ( RB.SAMPLES, "pleaseSelectMeasurementSet_MSG", RB.objA );

String deleteSampleLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "deleteSample_LBL", RB.objA);
String deleteSampleRequestLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "deleteSampleRequest_LBL", RB.objA);
String whereUsed = WTMessage.getLocalizedMessage ( RB.MATERIAL, "whereUsed_OPT",RB.objA ) ;
String viewCalendar = WTMessage.getLocalizedMessage ( RB.MATERIAL, "viewCalendar_OPT",RB.objA ) ;
String allLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "all_LBL", RB.objA ) ;
String copyPOMsToClipboardToolTip = WTMessage.getLocalizedMessage(RB.MEASUREMENTS, "copyPOMsToClipboardMouseOver_TOOLTIP" ,RB.objA );
String filterLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "filter_Lbl",RB.objA ) ;
String baseUOMUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, defaultUnitOfMeasure,RB.objA ) ;
String cmUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.cm",RB.objA ) ;
String mUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.m",RB.objA ) ;
String ftUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.ft",RB.objA ) ;
String inUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, "si.Length.in",RB.objA ) ;
String newSampleLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "requestSample_Btn", RB.objA ) ;
String docsButton = WTMessage.getLocalizedMessage ( RB.MAIN, "documents_LBL", RB.objA ) ;
String emailPageOpt = WTMessage.getLocalizedMessage ( RB.MAIN, "emailPage_OPT", RB.objA ) ;


%>
<%

    String tid = "";

    String errorMessage = request.getParameter("errorMessage");
    String oid = request.getParameter("oid");
    String activity = request.getParameter("activity");
    String action = request.getParameter("action");
	String mailToAddress = FormatHelper.format(request.getParameter("mailToAddress"));
    String mailToCCAddress = FormatHelper.format(request.getParameter("mailToCCAddress"));
    String mailToBCCAddress = FormatHelper.format(request.getParameter("mailToBCCAddress"));
    String mailToSubject = FormatHelper.format(request.getParameter("mailToSubject"));
    HashMap samplesMap = new HashMap();
    Collection samplesData = new Vector();
    LCSSampleQuery sampleQuery = new LCSSampleQuery();

    boolean toggleSampleRequest = false;
    Vector sortOrder = new Vector();

    LCSSampleRequest sampleRequest = null;
    LCSSample sample = null;
    HashMap sampleCombinations = new HashMap();


    String windchillURL = request.getScheme().toLowerCase() + "://" + windchillHost ;
	 
	if(SERVER_USING_MULTIPLE_PROTOCALS && CLIENT_SIDE_EMAIL && !lcsContext.isVendor){
		 windchillURL = windchillHost ;
	}
	String mailToString = "";

	if(!CLIENT_SIDE_EMAIL || lcsContext.isVendor){
		mailToString = "mailTo:";
	}
    //String mailToString = "mailTo:";
    String params = "";
    if(FormatHelper.hasContent(mailToAddress)){
        mailToString += mailToAddress;
    }
	if(CLIENT_SIDE_EMAIL && !lcsContext.isVendor){
	    mailToString += "";
	}else{
		mailToString += "?";
	}

    if(FormatHelper.hasContent(mailToCCAddress)){
        params += "&cc=" + mailToCCAddress;
    }
    if(FormatHelper.hasContent(mailToBCCAddress)){
        params += "&bcc=" + mailToBCCAddress;
    }
    if(FormatHelper.hasContent(mailToSubject)){
        params += "&subject=" + mailToSubject;
    }
	String emailParams = windchillURL + URL_CONTEXT + java.net.URLEncoder.encode("/jsp/main/Main.jsp?activity=" +  activity + "&action=" +  FormatHelper.format(action) + "&oid=" +  oid);
	if(CLIENT_SIDE_EMAIL && !lcsContext.isVendor){
	   params += "&" + emailParams;
	}else{
		params += "&body=" + emailParams;
	}
    if(params.startsWith("&")){
        params = params.substring(1);
    }
    mailToString += params;

    
    if(sampleModel.getBusinessObject()!=null){
        sample = sampleModel.getBusinessObject();
        sampleRequest = sample.getSampleRequest();
        samplesData = sampleQuery.findSamplesIdForSampleRequest(sampleRequest, true);
        Iterator it = samplesData.iterator();
        FlexObject fo = null;
        String sampleDetail = null;
		String sizeInfo = "";
        while(it.hasNext()){
            fo = (FlexObject)it.next();
            sortOrder.add("com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"));           
		    if(FormatHelper.hasContentAllowZero(fo.getString("LCSFITTEST.SAMPLESIZE"))){
				sizeInfo = "  ( " + fo.getString("LCSFITTEST.SAMPLESIZE") + " )";
		    }else{
				sizeInfo = "";
		    }
            samplesMap.put("com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"), fo.getString("LCSSAMPLE.SAMPLENAME") + sizeInfo);
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
        while(it.hasNext()){
            fo = (FlexObject)it.next();
            sortOrder.add("com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"));
		    if(FormatHelper.hasContentAllowZero(fo.getString("LCSFITTEST.SAMPLESIZE"))){
				sizeInfo = "  ( " + fo.getString("LCSFITTEST.SAMPLESIZE") + " )";
		    }else{
				sizeInfo = "";
		    }            
			samplesMap.put("com.lcs.wc.sample.LCSSample:" + fo.getString("LCSSAMPLE.IDA2A2"), fo.getString("LCSSAMPLE.SAMPLENAME") + sizeInfo);
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

        if(!samplesMap.isEmpty()){
            sampleModel.load(samplesMap.keySet().iterator().next().toString());
            sample = sampleModel.getBusinessObject();
			//System.out.println("lese view page started sample****1111*******"+sample.getValue("lfSampleQuantity"));
			//System.out.println("lese view page started sample****1111*******"+sample.getValue("lfFloatSampleQuantity"));
			String floatSampleQty=(String)sample.getValue("lfFloatSampleQuantity").toString();
			//System.out.println("floatSampleQty sample****1111*******"+floatSampleQty);
			String intSampleQty=(String)sample.getValue("lfSampleQuantity").toString();
			//System.out.println("intSampleQty sample****1111*******"+intSampleQty);
			double doubleSamplValue = Double.parseDouble(intSampleQty);
			
			if(floatSampleQty.equalsIgnoreCase("0.0")){
				System.out.println("inside if  sample****1111*******"+doubleSamplValue);
				sample.setValue("lfFloatSampleQuantity",doubleSamplValue);
			}
            oid = sample.toString();
        }
    }
        
        
  
    request.setAttribute("contextSample", "sample");    
    FlexType iPageType = FlexTypeCache.getFlexTypeFromPath("Document\\Images Page");
    FlexType type = sample.getFlexType();    
    LCSSourcingConfigMaster scMaster = (LCSSourcingConfigMaster) sampleModel.getSourcingMaster();
    LCSProduct product = null;
    //LCSSeason season = null;
    LCSMeasurements measurements = null;
    LCSSourcingConfig sconfig = null;
    WTPartMaster specMaster = sampleModel.getSpecMaster();
    FlexSpecification spec = (FlexSpecification) VersionHelper.latestIterationOf(specMaster);
    if(scMaster != null){
        product = SeasonProductLocator.getProductARev(scMaster);
        //season = SeasonProductLocator.getSeasonRev(product);
        sconfig = (LCSSourcingConfig) VersionHelper.latestIterationOf(scMaster);
    }
    LCSFitTest fitTest = LCSMeasurementsQuery.findFitTest(sample);
	String placeholderRowSearchCriteriaKey = "";

    
    String doubleFormat = request.getParameter("measurementsFormat");
    if(fitTest!=null){
        measurements = (LCSMeasurements) VersionHelper.latestIterationOf(fitTest.getMeasurementsMaster());
		placeholderRowSearchCriteriaKey = measurements.getFlexType().getAttribute("placeholderRow").getSearchResultIndex();

        if(!FormatHelper.hasContent(doubleFormat) ){
            // jc change "!= null" to "hasContent"
            if(FormatHelper.hasContent((String)measurements.getValue("uom")) && ((String)measurements.getValue("uom")).indexOf("FRACTION")==-1){
                doubleFormat = ("si.Length." + (String)measurements.getValue("uom"));
            }else{
                doubleFormat = defaultUnitOfMeasure;
            }
         }
    }
    boolean imagesTab = ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeFromPath("Document\\Images Page"));     
   
    String fitInformationLBL = WTMessage.getLocalizedMessage ( RB.SAMPLES, "fitInformation_PG_HEAD", RB.objA) ;
    
    Date date = new Date();
	String reportDate = FormatHelper.formatWithTime(date);
	String userName=lcsContext.getUserName();
	String reportHead = FormatHelper.format(fitInformationLBL+" - ("+product.getValue("productName")+") ("+sampleRequest.getValue("requestName")+" >> "+sample.getValue("name")+")");
	if(fitTest!=null){
		reportHead = reportHead + FormatHelper.format("("+measurementsSetLabel+": "+measurements.getValue("name")+") ("+sampleSizeLabel+": "+fitTest.getSampleSize()+")");
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
    combinationColumn.setHeaderLabel(measurementsSetLabel);
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
    
    if (DISPLAY_COLORCRITERIA) {
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
    String sampleCombinationsString = combinationtg.drawTable(sampleCombinations.values(), combinationColumns, "",false, false);
  
  ///////////////////////////////////////////////////////////////    

%>

<jsp:include page="<%=subURLFolder+ VIEW_MEASUREMENTS_COLUMN_ORDER %>" flush="true">
    <jsp:param name="none" value="" />
</jsp:include>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script language="JavaScript" src="<%=URL_CONTEXT%>/javascript/ajax.js"></script>
<script language="Javascript">

    /////////////////////////////////////////////////////////////////////////////////
    function toggleSample(id){
         document.MAINFORM.oid.value = '<%= oid %>';
         document.MAINFORM.nextSampleOid.value = id;
         document.MAINFORM.LCSSAMPLE_measurementsFormat.value = '<%=doubleFormat%>';            
         document.MAINFORM.activity.value = 'VIEW_MULTIPLE_SAMPLE';
         submitForm();
    }

    /////////////////////////////////////////////////////////////////////////////////
    function refreshFitSample(){
        document.MAINFORM.oid.value = '<%= oid %>';
        document.MAINFORM.activity.value = 'UPDATE_SAMPLE';
        document.MAINFORM.action.value = 'REFRESH';
        submitForm();
    }

    /////////////////////////////////////////////////////////////////////////////////
    function displayImage(id){
        document.MAINFORM.activity.value = 'UPDATE_SAMPLE';
        document.MAINFORM.action.value = 'SAVE_AND_RETURN';
        document.MAINFORM.imagePageId.value = id;
        document.MAINFORM.hideFileTable.value = true;
        document.MAINFORM.value = "true";
        submitForm();
    }

    function setImageAttribute(image, label, saveActivity, oid){
	   document.MAINFORM.activity.value = 'SET_IMAGE';
	   document.MAINFORM.action.value = 'INIT';
	   document.MAINFORM.oid.value = oid;
	   document.MAINFORM.setImageActivity.value = saveActivity;
	   document.MAINFORM.imageAttribute.value = image;
	   document.MAINFORM.imageLabel.value = label;
	   document.MAINFORM.returnActivity.value = "VIEW_MULTIPLE_SAMPLE";
	   document.MAINFORM.returnAction.value = "INIT";
	   document.MAINFORM.returnOid.value = oid;
	   document.MAINFORM.submit();
    }


    /////////////////////////////////////////////////////////////////////////////////
    function changeTab(tabId, page) {
        document.MAINFORM.tabId.value = tabId;
        var sampleDetailTab = document.getElementById('sampleDetailTab');
        var sampleDetailDiv = document.getElementById('sampleDetailDiv');
        var docsTab = document.getElementById('docsTab');
        var docsDiv = document.getElementById('docsDiv');
        var fitTab = document.getElementById('fitTab');
        var fitDiv = document.getElementById('fitDiv');
		<%if(imagesTab){%>
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
			<%if(imagesTab){%>
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
			<%if(imagesTab){%>
            imagesTab.className='tab';
            imagesDiv.style.display = 'none';
			<%}%>

        }  else if (tabId == 'docsTab') {
            sampleDetailTab.className='tab';
            sampleDetailDiv.style.display = 'none';
            fitTab.className='tab';
            fitDiv.style.display = 'none';
            docsTab.className='tabselected';
            docsDiv.style.display = 'block';
			<%if(imagesTab){%>
            imagesTab.className='tab';
            imagesDiv.style.display = 'none';
			<%}%>
        }<%if(imagesTab){%> else if (tabId == 'imageTab') {
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
    
  
    /////////////////////////////////////////////////////////////////////////////////
    function viewSample(id){
        document.MAINFORM.activity.value = 'VIEW_MULTIPLE_SAMPLE';
        document.MAINFORM.action.value = 'INIT';
        document.MAINFORM.oid.value = id;
        document.MAINFORM.returnActivity.value = document.REQUEST.activity;
        document.MAINFORM.returnAction.value = document.REQUEST.action;
        submitForm();
    }


    /////////////////////////////////////////////////////////////////////////////////
	var divWindow;
    function findSampleComments(){

	    divWindow = new jsWindow(1000, 600,200, 100, 20, "", 20, true, true, true);
		divWindow.showProcessingMessage();
		runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/jsp/samples/SampleCommentsAJAXSearch.jsp?typeId=<%=FormatHelper.getObjectId(sampleRequestModel.getFlexType()) %>&ownerMasterId=<%=sampleRequest.getOwnerMaster().toString()%>&specMasterId=<%=FormatHelper.getObjectId((WTPartMaster)spec.getMaster())%>', 'ajaxDefaultResponse');

    }

    /////////////////////////////////////////////////////////////////////////////////


    function toggleAllItems() {
        var selectAllCheckbox = document.getElementById('selectAllCheckBox');

        var checkboxes = document.getElementsByName('selectedIds');
        for (i=0; i<checkboxes.length; i++) {

            if (selectAllCheckbox.checked) {
                checkboxes[i].checked = true;
            } else {
                checkboxes[i].checked = false;
            }
        }
    }

    
    function copyPOMsToClipboard(){
      if(document.MAINFORM.selectedIds!=undefined){
	      var group = document.MAINFORM.selectedIds;	
		  var selectedIds = getCheckBoxIds(group);
		  if(selectedIds != ""){
             var url = urlContext + '/jsp/main/Main.jsp';
			 var dataString = 'activity=COPY_TO_CLIPBOARD&action=COPY_POMS&selectedIds=' + selectedIds;
			 runPostAjaxRequest(url, dataString, 'openClipboard');
		  }
	   }
    }

	function openClipboard(xml, text){
        var selectAllCheckbox = document.getElementById('selectAllCheckBox');

        var checkboxes = document.getElementsByName('selectedIds');
		if (selectAllCheckbox.checked) {
            selectAllCheckbox.checked = false;
        }
        for (i=0; i<checkboxes.length; i++) {
            if (checkboxes[i].checked) {
                checkboxes[i].checked = false;
            } 
        }   
		lauchOrFocusWindow(clipBoardWindow, urlContext + '/jsp/main/Main.jsp?activity=COPY_TO_CLIPBOARD&action=VIEW', 'clipboard', 'dependent=yes,width=700,height=450,top=100,left=100,titlebar=yes,scrollbars=1,resizable=yes');
	}

    function backCancel(){

		document.MAINFORM.activity.value = 'VIEW_MULTIPLE_SAMPLE';
        document.MAINFORM.action.value = 'CANCEL';
	    submitForm();
    }

	/**
	* 
	* Target Point Build: 004.23
	* Request ID : <20>
	* Modified On: 22-May-2013
	* Method to Save the Copied Sample Request.
	* @author Shamel
	*/
	// ITC - Start
	function saveAs(oid){
		document.MAINFORM.activity.value = 'COPY_SAMPLE';
		document.MAINFORM.action.value = 'INIT';
		document.MAINFORM.oid.value = oid;
		document.MAINFORM.returnActivity.value = "VIEW_MULTIPLE_SAMPLE";
		document.MAINFORM.returnAction.value = "INIT";
		document.MAINFORM.returnOid.value = oid;
		submitForm();
	}
	/**
	* 
	* Target Point Build: 004.23
	* Request ID : <20>
	* Modified On: 22-May-2013
	* Method to generate PDF.
	* @author Shamel
	*/

	function generatePDFExport(oid){
		document.MAINFORM.activity.value = 'SAMPLE_REPORT';
		document.MAINFORM.action.value = 'GENERATE_PDF';
		document.MAINFORM.oid.value = oid;
		document.MAINFORM.returnActivity.value = "VIEW_MULTIPLE_SAMPLE";
		document.MAINFORM.returnAction.value = "INIT";
		document.MAINFORM.returnOid.value = oid;
		submitForm();
	}
	

//////////////////////////////////////////////////////////////////////////




</script>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input name="LCSSAMPLE_sampleRequestString" type="hidden" value="">
<input name="LCSSAMPLE_measurementsFormat" type="hidden" value="">
<input name="M_F_null_CHECKBOX_pomlist" type="hidden" value="">
<input name="nextSampleOid" type="hidden" value="">
<input name="measurementsId" type="hidden" value='<%= request.getParameter("measurementsId") %>'>
<input name="toggle" type="hidden" value='<%= request.getParameter("toggle") %>'>
<input name="imagePageId" type="hidden" value=''>
<input name="popUpWindow" type="hidden" value=''>
<input name="updateImagesPage" type="hidden" value=''>
<input name="updateDoc" type="hidden" value=''>
<input name="hideFileTable" type="hidden" value='false'>
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
                        <%=  viewSampleRequestPgHead %>
                    </td>
                    <td class="PAGEHEADINGTEXT" width="1%" nowrap>

	<%--
	/**
	* 
	* Target Point Build: 004.23
	* Request ID : <20>
	* Modified On: 22-May-2013
	* generate PDF.
	* @author Shamel
	*/
	--%>


<%
	String pdfTooltip = WTMessage.getLocalizedMessage ( RB.MAIN, "pdfTooltip", RB.objA );			
%>


<span style='padding-right:4px'>
<a id="generatePDF" onmouseover="return overlib('<%= FormatHelper.formatJavascriptString(pdfTooltip) %>');" onmouseout="return nd();" class="" href="javascript:generatePDFExport('<%= FormatHelper.getObjectId(sampleRequest) %>')">
<img border="0" width="20" src="<%=URL_CONTEXT %>/images/pdf.gif"></a>
</span>

	<%--
		/**
		* 
		* Target Point Build: 004.23
		* Request ID : <20>
		* Modified On: 22-May-2013
		* generate PDF.
		* @author Shamel
		*/
	--%>



                        <jsp:include page="<%=subURLFolder+ DISCUSSION_FORM_POSTINGS %>" flush="true">
                            <jsp:param name="oid" value="<%= FormatHelper.getObjectId(sampleRequest) %>" />
                        </jsp:include>
                        <% if("FIT_APPROVAL_PAGE".equals(request.getParameter("tabPage"))){%>
                         <a class="button"  href="javascript:backCancel()"><%= returntoFitApprovalButton %></a>
                         <%} %>
                        &nbsp;<%= actionsPgHead %>&nbsp;
                        <select  id='sampleRequestActions' onChange="evalList(this)">
                            <option>
                            <% if(ACLHelper.hasModifyAccess(sample) && ACLHelper.hasModifyAccess(sampleRequest)) { %>
                                <option value="updateObject('<%= FormatHelper.getObjectId(sample) %>','INIT','UPDATE_MULTIPLE_SAMPLE','VIEW_MULTIPLE_SAMPLE', '', '<%= FormatHelper.getObjectId(sample) %>')"><%= updateLabel %>
                            <% } %>

                            <% if(ACLHelper.hasDeleteAccess((FlexTyped)sampleRequest)){ %>
                                <option value="deleteObject('<%= FormatHelper.getObjectId(sampleRequest)%>')"><%= deleteSampleRequestLabel %>
                            <% } %>                        

                            <% if(ACLHelper.hasDeleteAccess((FlexTyped)sample)){ %>
                                <option value="deleteObject('<%= FormatHelper.getObjectId(sample)%>')"><%= deleteSampleLabel %>
                            <% } %>
   				<!-- Target Point Build : <004.23> Request ID : <20> Modified On: 22-May-2013 Author : <Shamel>
								 Description : <Added Copy option and its Function>
							-->
							<% if(ACLHelper.hasCreateAccess((FlexTyped)sampleRequest)){ %>
								<option value="saveAs('<%= FormatHelper.getObjectId(sampleRequest) %>')">Copy
                            <% } %>     
                            
  <%-- Added for story : B-109259 --%>
  <%-- Configuration of event subscription for email notification --%>
  <%-- Start --%>
  <% if(sampleRequest instanceof wt.workflow.forum.SubjectOfForum && sampleRequest instanceof wt.inf.container.WTContained) { %> 
   <% if(FORUMS_ENABLED && SUBSCRIPTION_ENABLED){ %>
    <option value="">----------------------
    &nbsp;
    <jsp:include page="<%=subURLFolder+ DISCUSSION_FORM %>" flush="true">
		<jsp:param name="type" value="<%= type %>" />
		<jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest)  %>" />
    </jsp:include>
    &nbsp;
    <jsp:include page="<%=subURLFolder+ SUBSCRIPTION_FORM %>" flush="true">
		<jsp:param name="type" value="<%= type %>" />
		<jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest)  %>" />
    </jsp:include>            
    <% } else if(FORUMS_ENABLED){ %>
    <option value="">----------------------
    <jsp:include page="<%=subURLFolder+ DISCUSSION_FORM %>" flush="true">
		<jsp:param name="type" value="<%= type %>" />
		<jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest)  %>" />
    </jsp:include>                          
    <% } else if(SUBSCRIPTION_ENABLED){ %>
    <option value="">----------------------
    <jsp:include page="<%=subURLFolder+ SUBSCRIPTION_FORM %>" flush="true">
		<jsp:param name="type" value="<%= type %>" />
		<jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest)  %>" />
    </jsp:include>                          
   <% } %>
  <% } %>
  <%-- End --%>
  &nbsp;
  
                      <option value="">----------------------
							
                            <jsp:include page="<%=subURLFolder+ LIFE_CYCLE_MANAGED %>" flush="true">
                                <jsp:param name="type" value="<%= FormatHelper.getObjectId(type) %>" />
                                <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest) %>" />
                                <jsp:param name="returnActivity" value="VIEW_MULTIPLE_SAMPLE" />
                                <jsp:param name="objectName" value="Sample-Request" />
                            </jsp:include>

                            <jsp:include page="<%=subURLFolder+ LIFE_CYCLE_MANAGED %>" flush="true">
                                <jsp:param name="type" value="<%= FormatHelper.getObjectId(type)  %>" />
                                <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sample) %>" />
                                <jsp:param name="returnActivity" value="VIEW_MULTIPLE_SAMPLE" />
                                <jsp:param name="objectName" value="Sample" />
                            </jsp:include>
        
                            <jsp:include page="<%=subURLFolder+ TEAM_MANAGED %>" flush="true">
                                <jsp:param name="type" value="<%= FormatHelper.getObjectId(type)  %>" />
                                <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest) %>" />
                                <jsp:param name="returnActivity" value="VIEW_MULTIPLE_SAMPLE" />
                                <jsp:param name="objectName" value="Sample-Request" />
                            </jsp:include>

                            <jsp:include page="<%=subURLFolder+ TEAM_MANAGED %>" flush="true">
                                <jsp:param name="type" value="<%= FormatHelper.getObjectId(type)  %>" />
                                <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sample) %>" />
                                <jsp:param name="returnActivity" value="VIEW_MULTIPLE_SAMPLE" />
                                <jsp:param name="objectName" value="Sample" />
                            </jsp:include>

							<% if(CLIENT_SIDE_EMAIL && !lcsContext.isVendor){ %>
							<option value="emailMessage('<%= mailToString %>',<%=CLIENT_SIDE_EMAIL%>)"><%= emailPageOpt %>
							<% }else{ %>
							<option value="emailMessage('<%= mailToString %>','false')"><%= emailPageOpt %>
							<% } %>

                            <option value="">----------------------

                            <% if(!lcsContext.isVendor){ %>
                     
                                <option value="whereUsed('<%= FormatHelper.getObjectId(sample) %>')"><%= whereUsed %>
                                <option value="viewCalendar('<%= FormatHelper.getObjectId(sample) %>')"><%= viewCalendar %>

                                <!-- <option value="whereUsed()">Where Used -->
                            <% } %>
                        </select>
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
                <% flexg.setScope(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE); %>
                <%= fg.createDisplay(type.getAttribute("requestName").getAttDisplay(), (String)sampleRequestModel.getValue("requestName"), FormatHelper.STRING_FORMAT) %>
                <%= fg.createDisplay(typeLabel, type.getFullNameDisplay(), FormatHelper.STRING_FORMAT) %>
            </tr>
            <tr>
                <%= fg.createDisplay(productLabel, product.getName(), FormatHelper.STRING_FORMAT) %>
                <%= fg.createDisplay(specLabel, spec.getName(), FormatHelper.STRING_FORMAT) %>
                <%  //fg.createDisplay(seasonLabel, season.getName(), FormatHelper.STRING_FORMAT) %>
            </tr>
            <tr>
                <%              
                String measurementsSetName = ""; 
                if (fitTest != null) {
                    measurementsSetName = ((LCSMeasurementsMaster) fitTest.getMeasurementsMaster()).getMeasurementsName();
                } else {
                    measurementsSetName = "";
                }
                %>
               
                <%= fg.createDisplay(sourceLabel, sconfig.getSourcingConfigName(), FormatHelper.STRING_FORMAT) %>
                <%= fg.createDisplay(measurementsSetLabel, measurementsSetName, FormatHelper.STRING_FORMAT) %>
            </tr>
            
            <tr>
                <td class="FORMLABEL" nowrap width="1%">
                      &nbsp;&nbsp;&nbsp;<%= sampleLabel %>&nbsp;
                </td>
                <td>
                    <%= fg.createDropDownList(samplesMap, "sampleId", sample.toString(), "toggleSample(this.options[this.selectedIndex].value)", 1, false, "", sortOrder) %>
					
                    &nbsp<a onmouseover="return overlib(document.getElementById('existingSampleDiv').innerHTML);" onmouseout="return nd();" href="javascript:doNothing()"><img   border="0" src="<%=WT_IMAGE_LOCATION%>/details.gif"></a>
                    &nbsp;&nbsp;<a onmouseover="return overlib('<%=FormatHelper.formatJavascriptString(sampleCommentsLabel)%>');" onmouseout="return nd();" href="javascript:findSampleComments()"><img   border="0" src="<%=URL_CONTEXT%>/images/newPostings.gif"></a>            
                </td>       
                <% if(fitTest!=null){ %>
                    <%= fg.createDisplay(sampleSizeLabel, fitTest.getSampleSize(), FormatHelper.STRING_FORMAT) %>
                <% } %>
            </tr>

            <td> </td>
            <td> </td>
            <% if(DISPLAY_COLORCRITERIA && sample.getColor()!=null) { %>
               <%= fg.createDisplay(colorLabel, (String)((LCSSKU)VersionHelper.latestIterationOf((WTPartMaster)sample.getColor())).getValue("skuName"), FormatHelper.STRING_FORMAT) %>

                <tr> </tr>

            <%}%>
            <%= tg.endContentTable() %>
            <%= tg.endTable() %>
            <%= tg.endBorder() %>
        </td>
    </tr>
</table>

<table width="100%">
    <%
    //Tab permissions
    boolean detailsTab = true;
    boolean docsTab = true;
    boolean fitTab = (fitTest != null);
    boolean commentsTab = true;
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
                table.put("level", null);

				table.put("label", sampleRequestLabel);
                table.put("typed", sampleRequest);
                table.put("multiObject_typed", sampleRequest);
                table.put("moduleName", "SAMPLE_IMAGE");
                table.put("image_typed", sampleRequest);
                scopeLevelList.add(table);
				
				table = new HashMap();
				table.put("scope", SampleRequestFlexTypeScopeDefinition.SAMPLE_SCOPE);
                table.put("level", null);

				table.put("label", sampleLabel);
				table.put("typed", sample);
				table.put("multiObject_typed", sample);
				table.put("moduleName", "SAMPLE_IMAGE");
				table.put("image_typed", sample);
				scopeLevelList.add(table);				
				flexg.setScopeLevelList(scopeLevelList);
                        flexg.setSingleLevel(true);
                        flexg.setModuleName("SAMPLE");

				%>


                <!-- Sample Details Div -->
                <tr>
                    <td colspan=2>
                        <div id='sampleDetailDiv'>
                            <%= flexg.generateDetails(sample) %>
							<%
									flexg.setScopeLevelList(null);
							%>
                            <table width="100%">
                                <tr>
                                    <td>
                                        <jsp:include page="<%= subURLFolder + SAMPLE_META_DATA %>" flush="true">
                                            <jsp:param name="targetOid" value="<%= FormatHelper.getObjectId(sampleRequest) %>" />
                                            <jsp:param name="targetOid2" value="<%= FormatHelper.getObjectId(sample) %>" />
										</jsp:include>
                                    </td>
                                </tr>

                            </table>
                        </div>
                    </td>
                </tr>

                <!-- Fit Div -->
                <tr>
                    <td colspan=2>
                        <div id="fitDiv">
                            <% if(fitTab){
            
			                    FlexType measurementType = measurements.getFlexType();
								FlexTypeAttribute requestedMeasurementAtt = measurementType.getAttribute("requestedMeasurement");
			                    String newMeasurementKey = measurementType.getAttribute("newMeasurement").getSearchResultIndex();
			                    String requestedMeasurementKey = measurementType.getAttribute("requestedMeasurement").getSearchResultIndex();

//                                Collection iPages = LCSSampleQuery.findImagePages(FormatHelper.getObjectId(sample));
                                Collection iColumns = new Vector();
                                TableColumn iColumn = new TableColumn();
            
                                // Constuct table layout
                                iColumns = new Vector();
                                iColumn = new TableColumn();
                                iColumn.setDisplayed(true);
                                iColumn.setHeaderLabel(imageNameLabel);
                                iColumn.setLinkMethod("viewObject");
                                iColumn.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
                                iColumn.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
                                iColumn.setTableIndex(iPageType.getAttribute("name").getSearchResultIndex());
                                iColumns.add(iColumn);
            
                                //add image colum and description
                                iColumns.add(flexg.createTableColumn(iPageType.getAttribute("pageDescription"), iPageType, false));
                                iColumns.add(flexg.createTableColumn(iPageType.getAttribute("pageType"), iPageType, false));
            

			
                                Collection columns = new Vector();
                                TableColumn column = null;
                                TableColumn overrideColumn = null;
                                UpdateTableColumn updateColumn;
            
                                Iterator columnIter;
                                String columnKey;
                                Collection atts = measurementType.getAllAttributes(MeasurementsFlexTypeScopeDefinition.MEASUREMENT_SCOPE, null, false);
                                Map attMap = flexg.hashAttributesByKey(atts, "LCSPOINTSOFMEASURE.");
                                FlexTypeAttribute att;
            
                                flexg.setScope(MeasurementsFlexTypeScopeDefinition.MEASUREMENT_SCOPE);
                                Vector selectedAtts = new Vector();
                                columnIter = ((ArrayList)columnList.get(0)).iterator();


								column = new TableColumn();
								column.setDisplayed(true);
								column.setHeaderAlign("left");
								column.setColumnWidth("1%");
								column.setHeaderLabel("<input type=\"checkbox\" id=\"selectAllCheckBox\" value=\"false\" onClick=\"javascript:toggleAllItems()\">" + allLabel);
								//column.setHeaderLabel("");
								TableFormElement fe = new CheckBoxTableFormElement();
								fe.setValueIndex("LCSPOINTSOFMEASURE.IDA2A2");
								fe.setValuePrefix("OR:com.lcs.wc.measurements.LCSPointsOfMeasure:");
								fe.setName("selectedIds");
								column.setFormElement(fe);
						        columns.add(column);


                                while(columnIter.hasNext()){
                                    columnKey = (String) columnIter.next();        
                                    att = (FlexTypeAttribute) attMap.get(columnKey);
                                    if(att == null || att.isAttHidden()){
                                        continue;
                                    }         
                                    selectedAtts.add(att);
                                    if(att.getAttVariableType().equals("float")){
                                        column = flexg.createTableColumn(att, measurementType, false);
                                        overrideColumn = flexg.createTableColumn(att, measurementType, false);
										overrideColumn.setShowCriteriaNumericCompare(true);
                                        overrideColumn.setShowCriteria("0");
                                        overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
                                        overrideColumn.setDisplayed(true);
                                        if (doubleFormat.startsWith("si.Length.")) {
                                            overrideColumn.setOutputUom(doubleFormat);
                                            overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT);
                                        } else {
                                            overrideColumn.setFormat(doubleFormat);
                                        }                 
                                        overrideColumn.setColumnClassIndex("POM_HIGHLIGHT");
            
                                        // handle Null Value Display if Place holder is set
                                        column.setShowCriteria(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
                                        column.setShowCriteriaNot(true);
                                        column.setShowCriteriaTarget(att.getSearchResultIndex());
                                        column.setShowCriteriaNumericCompare(true);
                                        column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn);
                                        column.setShowCriteriaOverride(true);
            
                                        if (doubleFormat.startsWith("si.Length.")) {
                                            column.setOutputUom(doubleFormat);
                                            column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT);
                                        } else {
                                            column.setFormat(doubleFormat);
                                        }                 
                                        column.setColumnClassIndex("POM_HIGHLIGHT");
                        
                                        columns.add(column);
                        
                                    }else{
                                        columns.add(flexg.createTableColumn(att, measurementType, false));
                        
                                    }
                                }
            
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
                                String plusTolAtt = measurements.getFlexType().getAttribute("plusTolerance").getSearchResultIndex();
                                String minusTolAtt = measurements.getFlexType().getAttribute("minusTolerance").getSearchResultIndex();
                                int j=0;
                                FlexTypeAttribute loopAtt = null;
                                float plusTol = 0;
                                float minusTol = 0;
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
                                    
                                    plusTol = Float.parseFloat(pom.getValue("plusTolerance").toString());
                                    minusTol =Float.parseFloat(pom.getValue("minusTolerance").toString());
            
                                    for(j=0; j<selectedAtts.size(); j++){
                                        loopAtt = (FlexTypeAttribute)selectedAtts.get(j);
                                        pomFO.put(loopAtt.getSearchResultIndex(), pom.getValue(loopAtt.getAttKey()));
                                    }
            
                                    pomValueData.add(pomFO);
                                }
            
            


                                //measurements = (LCSMeasurements) VersionHelper.latestIterationOf(fitTest.getMeasurementsMaster());
            					Collection fitTestData = LCSMeasurementsQuery.findFitTestData(fitTest).getResults();

								fitTestData = FlexObjectUtil.join(fitTestData, pomValueData, "LCSPOINTSOFMEASURE.INSTANCESOURCEID", "POM_ID", true);


			                    Collection filteredFitTestData = new ArrayList();
								Iterator fitTestDataIterator = fitTestData.iterator();
								FlexObject fitTestFO;
								float requestedValue;
								String actualValue;
								String quotedValue;
								String plusTolerance;
								String minusTolerance;
								float nullValue =  Float.parseFloat(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
								String requestedMeasurementValue;
								String newMeasurementValue;
								while(fitTestDataIterator.hasNext()){
									fitTestFO = (FlexObject)fitTestDataIterator.next();									
									requestedMeasurementValue = fitTestFO.getString(requestedMeasurementKey);									
									requestedValue = Float.parseFloat(requestedMeasurementValue);
									if(requestedValue != nullValue){
										plusTolerance = fitTestFO.getString(measurementType.getAttribute("plusTolerance").getSearchResultIndex());
										minusTolerance = fitTestFO.getString(measurementType.getAttribute("minusTolerance").getSearchResultIndex());
										actualValue = fitTestFO.getString(measurementType.getAttribute("actualMeasurement").getSearchResultIndex());
										quotedValue = fitTestFO.getString(measurementType.getAttribute("quotedMeasurement").getSearchResultIndex());
										if(Float.parseFloat(actualValue) > 0.0f && !testTolerance(requestedMeasurementValue, actualValue, plusTolerance, minusTolerance, measurementType.getAttribute("actualMeasurement").getAttDecimalFigures(), doubleFormat)){
												fitTestFO.put("ACTUAL_OVERRIDE_INDICATOR", "OUT_OF_TOLERANCE");				 
										}
										if(Float.parseFloat(quotedValue) > 0.0f && !testTolerance(requestedMeasurementValue, quotedValue, plusTolerance, minusTolerance, measurementType.getAttribute("quotedMeasurement").getAttDecimalFigures(), doubleFormat)){
												fitTestFO.put("QUOTED_OVERRIDE_INDICATOR", "OUT_OF_TOLERANCE");				 
										}
										newMeasurementValue = (String)fitTestFO.get(newMeasurementKey);
										if (!requestedMeasurementValue.equals(newMeasurementValue) && (!FormatHelper.hasContentAllowZero(newMeasurementValue))){
											fitTestFO.put(newMeasurementKey, fitTestFO.get(requestedMeasurementKey));
										}
										//Target Point Build : 004.24 
										//Request ID : 5
										//Modified On: 14-Jun-2013
										//Author : Shamel
										//Description : if measurement is differen than requested measurement, then colur sgould be green.
										String newValue = fitTestFO.getString(measurementType.getAttribute("newMeasurement").getSearchResultIndex());
										
										//requestedValue = fitTestFO.getString(measurementType.getAttribute("requestedMeasurement").getSearchResultIndex());
										if(requestedValue != Float.parseFloat(newValue) && Float.parseFloat(newValue)>0.0f){

												fitTestFO.put("_NEW_OVERRIDE_INDICATOR", "OUT_OF_TOLERANCE_HIGHLIGHT");	
												
										}

										//Target Point Build : 004.24 
										//Request ID : 5
										//Modified On: 14-Jun-2013
										//Author : Shamel
										//Description : if measurement is differen than requested measurement, then colur sgould be green.
									}
									filteredFitTestData.add(fitTestFO);
								}
								fitTestData = filteredFitTestData;
									


            

                                // JOIN MEASUREMENTS DATA TO FIT TEST DATA
                               // fitTestData = FlexObjectUtil.join(fitTestData, pomValueData, "LCSPOINTSOFMEASURE.INSTANCESOURCEID", "POM_ID", true);
                                
                                // Added by Rohini
            
                                Iterator columnIter2 = ((ArrayList)columnList.get(1)).iterator();
            
                                while(columnIter2.hasNext()){
                                    columnKey = (String) columnIter2.next();        
                                    att = (FlexTypeAttribute) attMap.get(columnKey);
                                    if(att == null){
                                        continue;
                                    }  
                                    String attCol = att.getSearchResultIndex();
                                    if(att.getAttVariableType().equals("float")){
                                        column = flexg.createTableColumn(att, measurementType, false);
                                        overrideColumn = flexg.createTableColumn(att, measurementType, false);

                                        if (doubleFormat.startsWith("si.Length.")) {
                                            overrideColumn.setOutputUom(doubleFormat);
                                            overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT);
                                        } else {
                                            overrideColumn.setFormat(doubleFormat);
                                        }     
                                        overrideColumn.setTableIndex(attCol);



                                        if (doubleFormat.startsWith("si.Length.")) {
                                            column.setOutputUom(doubleFormat);
                                            column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT);
                                        } else {
                                            column.setFormat(doubleFormat);
                                        }     
                                        column.setTableIndex(attCol);
            
                                        if(att.getAttKey().equals("quotedMeasurement") || att.getAttKey().equals("quotedMeasurementDelta") || att.getAttKey().equals("requestedMeasurement") || att.getAttKey().equals("actualMeasurement") || att.getAttKey().equals("actualMeasurementDelta") || att.getAttKey().equals("newMeasurement")){
                                            // handle Null Value Display if this is a placeholder row 
                                            overrideColumn.setShowCriteria("0");
                                            overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
                                            overrideColumn.setDisplayed(true);
										    overrideColumn.setShowCriteriaNumericCompare(true);
                                            // handle Null Value Display if this is not a placeholder row
                                            column.setShowCriteria(LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
                                            column.setShowCriteriaNot(true);
                                            column.setShowCriteriaTarget(attCol);
                                            column.setShowCriteriaNumericCompare(true);
                                            column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn);
                                            column.setShowCriteriaOverride(true);
											if(DISPLAY_DELTA){
												if(columnKey.equals("LCSPOINTSOFMEASURE.actualMeasurementDelta") || columnKey.equals("LCSPOINTSOFMEASURE.quotedMeasurementDelta")){
													if(columnKey.equals("LCSPOINTSOFMEASURE.actualMeasurementDelta")){
														column.setSpecialClassIndex("ACTUAL_OVERRIDE_INDICATOR");
													} else if(columnKey.equals("LCSPOINTSOFMEASURE.quotedMeasurementDelta")){
														column.setSpecialClassIndex("QUOTED_OVERRIDE_INDICATOR");
													}
												}      
											}else{
													if(columnKey.equals("LCSPOINTSOFMEASURE.actualMeasurement")){
														column.setSpecialClassIndex("ACTUAL_OVERRIDE_INDICATOR");
													} else if(columnKey.equals("LCSPOINTSOFMEASURE.quotedMeasurement")) {
														column.setSpecialClassIndex("QUOTED_OVERRIDE_INDICATOR");
													}											
											}
											if(att.getAttKey().equals("quotedMeasurementDelta") || att.getAttKey().equals("actualMeasurementDelta")){
												 column.setShowCriteriaTarget(requestedMeasurementAtt.getSearchResultIndex());
											}

										//Target Point Build : 004.24 
										//Request ID : 5
										//Modified On: 14-Jun-2013
										//Author : Shamel
										//Description : if measurement is differen than requested measurement, then colur sgould be green.

											if(columnKey.equals("LCSPOINTSOFMEASURE.newMeasurement")){
												column.setSpecialClassIndex("_NEW_OVERRIDE_INDICATOR");
											}
										//Target Point Build : 004.24 
										//Request ID : 5
										//Modified On: 14-Jun-2013
										//Author : Shamel
										//Description : if measurement is differen than requested measurement, then colur sgould be green.

										}
                                        overrideColumn.setColumnClassIndex("POM_HIGHLIGHT");
                                        column.setColumnClassIndex("POM_HIGHLIGHT");
            
                                        columns.add(column);

                                    }else{
                                        column = flexg.createTableColumn(att, measurementType, false);
                                        column.setColumnClassIndex("POM_HIGHLIGHT");
                                        columns.add(column);
            
                                    }
                                }
                                // End
                    

                                // CREATE UPDATE TABLE COLUMN
                                column = flexg.createTableColumn(measurementType.getAttribute("requestedMeasurement"), measurementType, false);
                                overrideColumn = flexg.createTableColumn(measurementType.getAttribute("requestedMeasurement"), measurementType, false);
                                FlexTypeAttribute attDecimalPercision = measurementType.getAttribute("requestedMeasurement");
            
                                // handle Null Value Display if this is a placeholder row 
                                overrideColumn.setShowCriteria("0");
                                overrideColumn.setShowCriteriaTarget(placeholderRowSearchCriteriaKey);
								overrideColumn.setShowCriteriaNumericCompare(true);
                                overrideColumn.setDisplayed(true);
                                overrideColumn.setHeaderLabel(currentMeasurementLabel);
                                overrideColumn.setTableIndex("POM_VALUE");
                                overrideColumn.setDisplayed(true);
                                if (doubleFormat.startsWith("si.Length.")) {
                                    overrideColumn.setOutputUom(doubleFormat);
                                    overrideColumn.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT);
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
                                column.addOverrideOption(placeholderRowSearchCriteriaKey, "1", overrideColumn);
                                column.setShowCriteriaOverride(true);
            
                                column.setHeaderLabel(currentMeasurementLabel);
                                column.setTableIndex("POM_VALUE");
                                column.setDisplayed(true);
                                if (doubleFormat.startsWith("si.Length.")) {
                                    column.setOutputUom(doubleFormat);
                                    column.setFormat(FormatHelper.MEASUREMENT_UNIT_FORMAT);
                                } else {
                                    column.setFormat(doubleFormat);
                                }
                                column.setHeaderAlign("right");
                                column.setAlign("right");
                                column.setColumnClassIndex("POM_HIGHLIGHT");
            
                                columns.add(column);
                                
                                // SORT BY SORTING NUMBER
                                Collection tableData = SortHelper.sortFlexObjectsByNumber(fitTestData, "LCSPOINTSOFMEASURE.SORTINGNUMBER");
            
                            %>
                            <input type="hidden" name="fitSample" value="true">
                            <table width='100%'>
                                <tr>
                                    <td>
                                        <table width='100%'>
                                            <tr>
                                                <td class="HEADING2">
                                                    <%= fitInformationPgHead %>
                                                </td>
                                                <td>
                                                    <% 
                                                    String pdf = request.getParameter("pdf");
                                                    if (columns != null)  {
                                                        // Tweak the column Definitions to support highlighting rows
                                                        Collection pdfColumns = new Vector();
                                                        Iterator cols = columns.iterator();
                                                        while (cols.hasNext()) {
                                                            column = new TableColumn();
                                                            column = (TableColumn)cols.next();
                                                            column.setColumnClassIndex("POM_HIGHLIGHT");
                                                            pdfColumns.add(column);
                                                        }
                                                        
                                                        request.setAttribute("columns", pdfColumns);
                                                    }
                                                    if (tableData != null) 
                                                        request.setAttribute("data", tableData);
                                                    %>
                                                    <jsp:include page="<%=subURLFolder+ PDF_GENERATOR %>" flush="true">
                                                        <jsp:param name="pdf" value="<%= pdf %>"/>
                                                        <jsp:param name="reportName" value="<%= fitInformationPgHead %>"/>
                                                        <jsp:param name="cellClassDark" value="RPT_TBD"/>
                                                        <jsp:param name="cellClassLight" value="RPT_TBL"/>
                                                        <jsp:param name="tableHeaderClass" value="RPT_HEADER"/>
                                                        <jsp:param name="tableTotalsClass" value="RPT_TOTALS"/>
                                                        <jsp:param name="reportTitle" value="<%=reportHead%>"/>
                                                        <jsp:param name="userName" value="<%=userName%>"/>
														<jsp:param name="reportDate" value="<%=reportDate%>"/>
                                                    </jsp:include>
                                                </td>
												         <td>&nbsp;&nbsp;&nbsp;
														<a onmouseover="return overlib('<%=FormatHelper.formatJavascriptString(copyPOMsToClipboardToolTip)%>');" onmouseout="return nd();" href="javascript:copyPOMsToClipboard();"><img   border="0" src="<%=WT_IMAGE_LOCATION%>/copy.gif"></a>
												</td>
                                                <td width=60%>
                                                    &nbsp;&nbsp;
                                                </td>

                                                <%
                                                    FlexTypeAttribute attCriticalPom = measurements.getFlexType().getAttribute("criticalPom");
                                                    String criticalPomDisplay = FormatHelper.formatJavascriptString(attCriticalPom.getAttDisplay());
                                                    String stringValue = attCriticalPom.getAttDefaultValue();
                                                    AttributeValueList list = attCriticalPom.getAttValueList();
                                                %>
                                                <%= fg.createDropDownListWidget(filterLabel, list.toLocalizedMapSelectable(lcsContext.getLocale()), "criticalPomFilter", stringValue, "filterTable('" + criticalPomDisplay + "')", false) %>

                                                <%
                                                    Map formats = new HashMap();
                                                    formats.put(FormatHelper.FRACTION_FORMAT, fractionLabel +" "+ baseUOMUnitLabel);
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
                                            tg.setRowIdIndex("POM_ID");
                                            tg.setSortable(true);
                                            tg.setClientSort(true);
											%>

                                            <%= tg.drawTable(tableData, columns, pomsLabel + " " + sampleSizeLabel + ": " + measurements.getSampleSize() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + sampleSizeLabel + ": " + fitTest.getSampleSize()) %>
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

     <%	String specMasterId = (sample.getSpecMaster() != null)?FormatHelper.getNumericObjectIdFromObject(sample.getSpecMaster()):"";
        Collection pages = LCSSampleQuery.findImagePages(FormatHelper.getObjectId(sample), FormatHelper.getObjectId(sample.getCopiedFrom()), specMasterId);

        // Constuct table layout
        Collection imageColumns = new Vector();
        TableColumn imageColumn = new TableColumn();

        imageColumn.setDisplayed(true);
        imageColumn.setHeaderLabel(imageNameLabel);
        imageColumn.setLinkMethod("viewObject");
        imageColumn.setLinkTableIndex("LCSDOCUMENT.IDA2A2");
        imageColumn.setLinkMethodPrefix("OR:com.lcs.wc.document.LCSDocument:");
        imageColumn.setTableIndex(iPageType.getAttribute("name").getSearchResultIndex());
        imageColumns.add(imageColumn);

        //add image colum and description
        imageColumns.add(flexg.createTableColumn(iPageType.getAttribute("pageDescription"), iPageType, false));
        imageColumns.add(flexg.createTableColumn(iPageType.getAttribute("pageType"), iPageType, false));
    %>

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
            <tr>
                <td colspan=2>
                    <div id="imagesDiv">
                        <% if (imagesTab) { 
							tg.setClientSort(true);
							%> 
                            <table width='100%'>
                                <tr>
                                    <td>
                                        <%= tg.drawTable(pages, imageColumns, "", true, false) %>
                                    </td>
                                </tr>
                            </table>
                        <% }%>
                    </div>
                </td>
                <td colspan=2>
                    <div id="existingSampleDiv">
					<%=sampleCombinationsString%>
                    </div>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>
</table>



<script>

     toggleDiv('docsDiv');
	<%if(imagesTab){%>
    toggleDiv('imagesDiv');
    <%}%>
	toggleDiv('fitDiv');
    toggleDiv('existingSampleDiv');


    <%if("fitTab".equals(request.getParameter("tabId"))){ %>
        changeTab('fitTab');
	<%
	   }else if("docsTab".equals(request.getParameter("tabId"))){
	%>
    changeTab('docsTab');

    <% }else if("imageTab".equals(request.getParameter("tabId"))){ %>
        changeTab('imageTab');

    <% }else if("sampleDetailTab".equals(request.getParameter("tabId"))){ %>
        changeTab('sampleDetailTab');

    <% }%>

</script>

<%--
	/**
	* 
	* Target Point Build: 004.23
	* Request ID : <20>
	* Modified On: 22-May-2013
	* Method to Save the Copied Sample Request.
	* generate PDF.
	*/
	--%>


	<%
	String downloadFileKey	=	"";
	String pdfURL	=	"";
	try{
		pdfURL = request.getAttribute("SAMPLE_REPORT_URL")==null?"":request.getAttribute("SAMPLE_REPORT_URL").toString();
		downloadFileKey = new java.util.Date().getTime() + "";
		lcsContext.requestedDownloadFile.put(downloadFileKey, pdfURL);
	}catch(Exception e){
		e.printStackTrace();
	}
	if(!pdfURL.equals("")) {
	%>
	<script>
		openExcel();
		function openExcel(){
			var w=window.open('Main.jsp?forwardedFileForDownload=true&forwardedFileForDownloadKey=<%=downloadFileKey%>');
			document.MAINFORM.download.value='false';
        }
    </script>
	<% }%>
	
	<%--
	/**
	* 
	* Target Point Build: 004.23
	* Request ID : <20>
	* Modified On: 22-May-2013
	* generate PDF.
	* @author Shamel
	*/
	--%>