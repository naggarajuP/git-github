<%-- Copyright (c) 2002 Aptavis Technologies Corporation   All Rights Reserved --%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
		import="com.lcs.wc.db.*,
				com.lcs.wc.client.*,
				com.lcs.wc.client.web.*,
				com.lcs.wc.flextype.*,
				com.lcs.wc.foundation.*,
				com.lcs.wc.placeholder.*,
				com.lcs.wc.product.*,
				java.util.regex.Pattern,
				java.util.regex.Matcher,
				wt.part.WTPartMaster,
				com.lcs.wc.sourcing.*,
				com.lfusa.wc.axintegration.util.*,
				com.lcs.wc.sourcing.*,
				com.lcs.wc.season.*,
				com.lcs.wc.util.*,
				com.lcs.wc.sizing.SizingQuery,
				com.lfusa.wc.ibtinterface.util.*,
				com.lcs.wc.sizing.ProdSizeCategoryToSeason,
				java.util.*,
				wt.util.WTMessage,
				com.lfusa.wc.sapinterface.util.*,
				com.lfusa.wc.axintegration.staging.*,
				com.lcs.wc.db.SearchResults,
				com.lcs.wc.moa.LCSMOAObjectQuery"%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session" />
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request" />
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>


<%!
	public static final String JSPNAME = "LFAXStagingPageCreate.jsp";
	public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset", "UTF-8");
	public static final String NAME_SEPERATOR = ",";
	public static final String UNDER_SCORE = "_";
	public static final String MARK_MANDATORY = "*";
	//public static final boolean DEBUG = LCSProperties.getBoolean("jsp.placeholder.LFSAPStagingPageCreate.verbose");
	public static final boolean DEBUG = false;
	
	public void printDebugStms(String strMsgToPrint, Object valueToPrint){
		if(DEBUG) LCSLog.debug(strMsgToPrint + valueToPrint );
	}
%>

<%
	String stagingHead = "PLM-AX Staging Area";
    String allLabel = WTMessage.getLocalizedMessage(RB.MAIN, "all_LBL",RB.objA);
	String cancelButton = WTMessage.getLocalizedMessage ( RB.MAIN, "cancel_Btn",RB.objA ) ;
	String submitButton="Submit";
	ArrayList tableIds = new ArrayList();
	
	String startTableId = "0";
	String endTableId = "0";
	String tableIdEnd ="0";
	String seasonId1 = request.getParameter("oid");
	String pid1 = request.getParameter("pid");
	

%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>

<style type="text/css">
	TD.TABLESUBHEADER {
	font-weight: bold;
	vertical-align: middle;
	color: black;
	padding-left: 5px;
	padding-right: 5px;
	}.backspace 
	{ margin-left: -50px; }
	* {margin:0; padding:0}
	body {font:11px/1.5 Verdana, Arial, Helvetica, sans-serif; background:#FFF}
	#text {margin:50px auto; width:500px}.hotspot {cursor:pointer}
	 	
	#tt {position:absolute; display:block; background:url(/Windchill/rfa/lfusa/images/tt_left.gif) top left no-repeat}
	#tttop {display:block; height:5px; margin-left:5px; background:url(/Windchill/rfa/lfusa/images/tt_top.gif) top right no-repeat; overflow:hidden}
	#ttcont {display:block; padding:2px 12px 3px 7px; margin-left:5px; background:#666; color:#FFF}
	#ttbot {display:block; height:5px; margin-left:5px; background:url(/Windchill/rfa/lfusa/images/tt_bottom.gif) top right no-repeat; overflow:hidden}
</style>

	<form name="MAINFORM" id="MAINFORM" action="/Windchill/rfa/jsp/main/Main.jsp" method="post">

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script type="text/javascript" 	src="<%=URL_CONTEXT%>/lfusa/javascript/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=URL_CONTEXT%>/lfusa/javascript/season/AXCustom.js"></script>
	
<!--Staging area header..-->	
	<table  width="75%" border="0" height="25">
		<div class="BlueBody">
		<div class="BlueBox">
		<div class="BlueBoxHeader">
			<img src="<%=URL_CONTEXT%>/images/blue_topleft_w.gif" alt=""height="5" width="5">
		</div>
		<tr>
			<td class="PAGEHEADINGTITLE" align="center" height="50%"><b><font color="black" size="4"><%=stagingHead%></font></b></td>
		</tr>
	</table>
<br>
<br>

<!--Action buttons..-->	
	<table width="75%">
		<tr>
			<td class="button" align="center">
				<a class="button" id="stagingsubmit1" name="stagingsubmit" href="javascript:AxSubmit()"><%= submitButton %></a><!--&nbsp;&nbsp;|&nbsp;&nbsp
				<a class="button" href="javascript:backCancel()"><%= cancelButton %></a>-->&nbsp;&nbsp;
		</td>
		</tr>
	</table>

<br>


<%
	try	
	{
		//try catch block start
	
		String message = "";
		LCSSeason season = null;
		LCSProduct product = null;
		LCSProduct productARevision = null;
		Collection productSizeDefCollection = new Vector();
		
		FlexTypeAttribute axMaterialStyleStatusAttr = 
			FlexTypeCache.getFlexTypeFromPath(LFAXIntegrationConstants.axMaterialPath).getAttribute(LFAXIntegrationConstants.REV_STYLE_STATUS_KEY);
		String widthString = "20";
		
		String stylecode = "";
		
		FlexObject sku = null;
		String seasonVersion = ""; 
		
		//get season 
		String seasonId = request.getParameter("oid");
		printDebugStms("season id in ax is *********", seasonId );
		
		if (FormatHelper.hasContent(seasonId)) {
			season = (LCSSeason) LCSQuery.findObjectById(seasonId);
			seasonVersion = FormatHelper.getNumericVersionIdFromObject(season);
		}
		
		//get product ids
		String adoptedIds = request.getParameter("adoptedIds");
		printDebugStms("adoptedIds in IBT page is ******sesss******** ", adoptedIds);
		
		//get the list of adopted products from the custom string
		StringTokenizer tokenizer = new MultiCharDelimStringTokenizer(adoptedIds, "~");
		Collection productlist = new Vector();

		while (tokenizer.hasMoreTokens()) {
			String token = tokenizer.nextToken();
			if (FormatHelper.hasContentAllowZero(token)) {
				productlist.add(token);
			}
		}

		Iterator adopptedList = productlist.iterator();
		//Loop Products : start
		int countcs=0;
		while (adopptedList.hasNext()) 
		{
			product = (LCSProduct) LCSQuery.findObjectById((String) adopptedList.next());
			
			printDebugStms("product in ax page is ******sesss********", product);
			
		//Step 1: get product number
			String productNum="";
			Double productNumberDoubleVal=(Double)product.getValue("lfRootProductNum");
			productNum = FormatHelper.hasContent(String.valueOf(productNumberDoubleVal.intValue())) ? FormatHelper.setCharLengthPrefix(productNumberDoubleVal.intValue(),"0",6) : "";
			printDebugStms("productNumber in ax page is ******sesss********", productNum);
			printDebugStms("seasonId in ax page is ******sesss********", seasonId);
			
		//Step 2: get product A revision
			String prodVersion = FormatHelper.getNumericVersionIdFromObject(product);
			productARevision = SeasonProductLocator.getProductARev(product);
			printDebugStms("productARevision in ax page is ******sesss********", productARevision);
						
			FlexType ftype=productARevision.getFlexType();
			
		//Step 3: Initialize staging area helper to find all the products that have already been sent
			LFAXStagingDataPopulateHelper stagingHelper = new LFAXStagingDataPopulateHelper(season, product);
			
		//Step 4: Fetching related product size definitions and product categories for given Product and Season
			SizingQuery sizingQuery = new SizingQuery();
			productSizeDefCollection = sizingQuery.findPSDByProductAndSeason(null, product,season, null, null, null).getResults();
			List<String> duplicateSizeDefOnProduct = LFSAPUtil.getDuplicateSizeNames(productSizeDefCollection);
			Iterator productSizeDefCollectionItr = productSizeDefCollection.iterator();
			String sizeCategoryName = "";
			String prodsizedefOid = "";
			
		//Step 5: If there are no size definitions added then do not show staging table
		
		//int countcs=0;
			if (productSizeDefCollection.size() <= 0) 
			{
				%>
				<table>
					<tr>
						<td class="ERROR" align="center">There are no sizes for the product - <%=(String)productARevision.getValue("productName")%>
					<br>.Please ensure that the sizes and colorways are added and that the product is in adopted state before sending it to AX.This product will be skipped for now</td>
					</tr>
				</table>
				<%
				continue;
			}

		//Step 6: get Primary BOM Name
			String bomName = LFAXBOMValidtion.primaryBOMName(season,product);
			String primaryBomName="";
			String primaryBomId="";
			String primarySpecId="";
			boolean isValidBOM = false;

			if(FormatHelper.hasContent(bomName))
			{
				String st1[]=bomName.split(",");
				primaryBomName=st1[0];
				primaryBomId=st1[1];
				primarySpecId=st1[2];

				isValidBOM = ! (LFAXBOMValidtion.isPrimaryBOM(season,product)) ;
				printDebugStms("isValidBOM-----"  , isValidBOM);
				System.out.println("isValidBOM-----"  + isValidBOM);
			}

			printDebugStms("bomName---------->" , primaryBomName);
			printDebugStms("bomName---------->" , primaryBomId);
		
		//Step 7: loop through each size definition and generate staging table 	
			while (productSizeDefCollectionItr.hasNext()) 
			{
				//size Definition has start

				FlexObject sizecatprodseason = (FlexObject) productSizeDefCollectionItr.next();
				printDebugStms("sizecatprodseason is **********" , sizecatprodseason);
				sizeCategoryName = (String) sizecatprodseason.get("PRODUCTSIZECATEGORYMASTER.NAME");
				if (duplicateSizeDefOnProduct.contains(sizeCategoryName)) {
					sizeCategoryName = sizeCategoryName+ "("+ MOAHelper.parseOutDelims(sizecatprodseason.get("PRODSIZECATEGORYTOSEASON.SIZEVALUES")
										.toString()+ ")", ",");
					sizeCategoryName=sizeCategoryName.substring(0,sizeCategoryName.lastIndexOf(","))+")";

				}
				printDebugStms("sizeCategoryName  in ax jsp is **********" , sizeCategoryName);

				prodsizedefOid = (String) sizecatprodseason.get("PRODSIZECATEGORYTOSEASON.IDA2A2");
				ProdSizeCategoryToSeason sizeversion = (ProdSizeCategoryToSeason) LCSQuery.findObjectById("OR:com.lcs.wc.sizing.ProdSizeCategoryToSeason:"
										+ sizecatprodseason.get("PRODSIZECATEGORYTOSEASON.IDA2A2"));
				String psdToseasonVersionId = FormatHelper.getNumericVersionIdFromObject(sizeversion);
				printDebugStms("---------------psdToseasonVersionId------axxxxx----", psdToseasonVersionId);

		//Step 7: get costsheets -- to be moved to java file
				Collection listOfSources=com.lcs.wc.sourcing.LCSSourcingConfigQuery.getSourcingConfigForProductSeason(product, season);
								
				// getting all sources
				printDebugStms("listOfSources*****************", listOfSources);
				Iterator sourceIterator = listOfSources.iterator();
				Collection productCostSheetCollection= new ArrayList();
				Map<String,ArrayList<LCSCostSheet>> sourceCostMap = new TreeMap<String,ArrayList<LCSCostSheet>>();
				
				
				LCSCostSheet costSheet=null;
				String sourceName=null;
				
				while (sourceIterator.hasNext()) 
				{
					LCSSourcingConfig sourcingConfig=(LCSSourcingConfig)sourceIterator.next();
					String sourceVersion=FormatHelper.getNumericVersionIdFromObject(sourcingConfig);
					printDebugStms("sourcingConfig name*****************",sourcingConfig.getValue("name"));
					sourceName=(String)sourcingConfig.getValue("name");
					productCostSheetCollection = LCSCostSheetQuery
						.getCostSheetsForSourceToSeason(
								(WTPartMaster) season.getMaster(),
								(com.lcs.wc.sourcing.LCSSourcingConfigMaster) sourcingConfig
										.getMaster(), product
										.getPlaceholderMaster(),true);
										
					printDebugStms("productCostSheetCollection*****************",productCostSheetCollection);
					ArrayList<LCSCostSheet> primaryCostList= new ArrayList<LCSCostSheet>();
					Iterator productCostSheetITR = productCostSheetCollection.iterator();
					while (productCostSheetITR.hasNext()) 
					{
						costSheet = (LCSCostSheet) productCostSheetITR.next();
						printDebugStms("costSheet checkkkk******neww***********",costSheet);
						com.lcs.wc.sourcing.LCSCostSheetMaster lcscostsheetmaster = (com.lcs.wc.sourcing.LCSCostSheetMaster) costSheet.getMaster();
						costSheet = (LCSCostSheet) com.lcs.wc.util.VersionHelper.latestIterationOf(lcscostsheetmaster);
						String costValid=(String)costSheet.getValue("lfSendToSAP");
						printDebugStms("costValid checkkkk******neww***********",costValid);
						if(costValid.equalsIgnoreCase("true")){
							primaryCostList.add(costSheet);
						}
					}
					
					sourceCostMap.put(sourceName,primaryCostList);
				}			
				
				/*
				* Once we have got the size definitions, we will have to iterate through  
				* object and start filtering the objects based on the product size definition
				* version id.
				*/

		%>
			<!-- //Step 9: print staing table header : start-->
			<br>
				<table align="left" width="75%" cellspacing="0" cellpadding="0" border="0" BGCOLOR=#17406A>
					<tr>
						<td align="left">
							<%
							String imageURL = FileLocation.imageNotAvailable;
							if (FormatHelper.hasContent(productARevision.getPartPrimaryImageURL())) {
								imageURL = FormatHelper.formatImageUrl(productARevision.getPartPrimaryImageURL());
							}%>
							<img width="60"  src="<%=imageURL%>" align="left">
						</td>
						<td align="left">
						<table width="100%" cellspacing="0" cellpadding="0" border="0" align="left">
								<tr align="left">
							<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Product Name</font></b></html></td> 
							<td class='DISPLAYTEXT'><html><b><font size='2' face='Calibri' color='white'><%=(String) productARevision.getValue("productName")%></font></b></html></td>
								</tr>
								<tr>
							<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Size Definition</font></b></html></td> 
							<td class='DISPLAYTEXT'  ><html><b><font size='2' face='Calibri' color='white'><%=sizeCategoryName%></font></b></html></td>
								</tr>
								<tr>
									
							<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Primary BOM</font></b></html></td> 
							<td class='DISPLAYTEXT'><html><b><font size='2' face='Calibri' color='white'><%=primaryBomName%></font></b></html></td>
								</tr>
							<tr>
									<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Primary BOM Status</font></b></html></td> 
									<td class='DISPLAYTEXT'><html ><b><font size='2' face='Calibri' color='white'><%=(isValidBOM) ? "Valid" : "In-Valid" %></font></b></html></td>
							</tr>								
								<tr>
							<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Cost sheet</font></b></html></td> 
							
							<!-- //Step 9.6 : Iteratate all cost sheets and generate drop down..-->

<%
			//Step 10: draw staging rows
				Collection<FlexObject> skuVector = new Vector<FlexObject>();
				String skuId = "";
				LCSSKU skuobject = null;
				String SkuNumber=null;
				String NRFCode = "";
				String costsheetStatus="";
				String revEntSkuName=null;
				String colorWayName=null;
				String revItemNumber=null;
				String revStyleStatus=null;
				String errorRow=null;
				
			//Step 10.1 : get already sent row details from revisable entity library
				Collection<LCSRevisableEntity> existingEntries= stagingHelper.getRevisableEntitiesForSizeDefinition(psdToseasonVersionId, "SENT_RECEIVED_FAILED_ERROR");
				printDebugStms("---------------existingEntries------axxxxx----",existingEntries.size());
				String costVersion=null;
				String costName=null;
				String costSourceName=null;
				String costSizeversions=null;
				String existRevObjCostsheetId=null;
				String existRevObjCostsheetStatus=null;
				LCSCostSheet existCostsheetObj=null;
										
				Set<String> sourceCostMapKeys = sourceCostMap.keySet();
				Iterator<String> sourceCostMapKeysItr = sourceCostMapKeys.iterator();
				LCSRevisableEntity revEntityObjCostsheet=null;
				if(existingEntries.size()>0){
				
				Iterator existCostsheetListIter = existingEntries.iterator();
				while (existCostsheetListIter.hasNext()) 
				{
					revEntityObjCostsheet = (LCSRevisableEntity) existCostsheetListIter.next();
					printDebugStms("---------------revEntityObjCostsheet------axxxxx----", revEntityObjCostsheet);
				}
				printDebugStms("---------------revEntityObjCostsheetlatesttt------axxxxx----", revEntityObjCostsheet);
				if(revEntityObjCostsheet.getValue(LFAXIntegrationConstants.REV_COSTSHEET_SYSTEMID_KEY)!=null){
						existRevObjCostsheetId = revEntityObjCostsheet.getValue(LFAXIntegrationConstants.REV_COSTSHEET_SYSTEMID_KEY).toString();
					}
				printDebugStms("---------------existRevObjCostsheetId------axxxxx----", existRevObjCostsheetId);
				if(revEntityObjCostsheet.getValue(LFAXIntegrationConstants.REV_COST_STATUS_KEY)!=null){
						existRevObjCostsheetStatus = revEntityObjCostsheet.getValue(LFAXIntegrationConstants.REV_COST_STATUS_KEY).toString();
					}
				printDebugStms("---------------existRevObjCostsheetStatus------axxxxx----", existRevObjCostsheetStatus);
				
				//existCostsheetObj = (LCSCostSheet) LCSQuery.findObjectById("OR:com.lcs.wc.sourcing.LCSCostSheetMaster:"+ existRevObjCostsheetId);
				//printDebugStms("---------------existCostsheetObj------axxxxx----", existRevObjCostsheetId);
				
				%>
				<td>
				<select id="costsheet_<%=countcs%>">
									<%
										
										
										while(sourceCostMapKeysItr.hasNext())
										{
											String sourcingName = sourceCostMapKeysItr.next();
											ArrayList<LCSCostSheet> primaryCostList = sourceCostMap.get(sourcingName);
											Iterator<LCSCostSheet> costSheetItr = primaryCostList.iterator();
										
											while( costSheetItr.hasNext() )
											{
												costSheet = costSheetItr.next();
												costName=(String)costSheet.getValue("name");
												printDebugStms("costName object is *****************" , costName);
												costVersion=(String)FormatHelper.getNumericVersionIdFromObject(costSheet);
												printDebugStms("costVersion object is *****************", costVersion);
												costSourceName=sourcingName +" : "+costName;
												printDebugStms("costVersion object is costSourceName = *****************", costSourceName);
												costSizeversions="|~*~|"+costVersion+"_"+prodVersion+"_"+psdToseasonVersionId+"_"+primaryBomName+"_"+primaryBomId+"_"+primarySpecId;
												printDebugStms("costVersion object is costSizeversions = *****************", costSizeversions);
												if(FormatHelper.hasContent(existRevObjCostsheetId) && existRevObjCostsheetId.equalsIgnoreCase(costVersion)){%>
													<option value="<%=costSizeversions%>" selected><%=costSourceName%></option>
												<%}else{
									%>								
													<option value="<%=costSizeversions%>"><%=costSourceName%></option>
									<%  		}
											}
										}
									%>
								</select>
				</td>
				</tr>
							<tr>
							<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Cost sheet Status</font></b></html></td> 
							<%
							if(existRevObjCostsheetStatus ==null){
								existRevObjCostsheetStatus="";
							}
							%>
							<td class='DISPLAYTEXT'><html><b><font size='2' face='Calibri' color='white'><%=existRevObjCostsheetStatus%></font></b></html></td>
							</tr>
				<%}else{
				   %>			<td>				
								<select id="costsheet_<%=countcs%>">
									<%
										
										
										while(sourceCostMapKeysItr.hasNext())
										{
											String sourcingName = sourceCostMapKeysItr.next();
											ArrayList<LCSCostSheet> primaryCostList = sourceCostMap.get(sourcingName);
											Iterator<LCSCostSheet> costSheetItr = primaryCostList.iterator();
										
											while( costSheetItr.hasNext() )
											{
												costSheet = costSheetItr.next();
												costName=(String)costSheet.getValue("name");
												printDebugStms("costName object is *****************", costName);
												costVersion=(String)FormatHelper.getNumericVersionIdFromObject(costSheet);
												printDebugStms("costVersion object is *****************", costVersion);
												costSourceName=sourcingName +" : "+costName ;;
												printDebugStms("costVersion object is costSourceName = *****************", costSourceName);
												costSizeversions="|~*~|"+costVersion+"_"+prodVersion+"_"+psdToseasonVersionId+"_"+primaryBomName+"_"+primaryBomId+"_"+primarySpecId;
												printDebugStms("costVersion object is costSizeversions = *****************", costSizeversions);
									%>								
												<option value="<%=costSizeversions%>"><%=costSourceName%></option>
									<%  	}
										}
									%>
								</select>
							</td>
								</tr>
							<tr>
							<td class='FORMLABEL'><html><b><font size='2' face='Calibri' color='white'>Cost sheet Status</font></b></html></td> 
							<td class='DISPLAYTEXT'><html><b><font size='2' face='Calibri' color='white'></font></b></html></td>
							</tr>
							<%}%>
								
								
					
			<!-- //Step 9: print staing table header : end-->



					</table>
						</td>
					</tr>
				</table>
				<%
				
				
				for(LCSRevisableEntity existingRevObj: existingEntries)
				{
					FlexObject existingRevFlexObj  = new FlexObject();
					printDebugStms(" HERE THE REQURIED existingRevFlexObj inf " , existingRevObj.getName());
					
					String prodNumber=null;
					//String prodNumber=null;
					if(existingRevObj.getValue(LFAXIntegrationConstants.REV_PLM_PRODUCT_HASH_KEY)!=null){
						prodNumber = existingRevObj.getValue(LFAXIntegrationConstants.REV_PLM_PRODUCT_HASH_KEY).toString();
					}
					if(existingRevObj.getValue(LFAXIntegrationConstants.REV_COLORWAY_KEY)!=null){
						skuobject = (LCSSKU)existingRevObj.getValue(LFAXIntegrationConstants.REV_COLORWAY_KEY);
						revEntSkuName = (String)skuobject.getValue("skuName");
					}
					if(existingRevObj.getValue(LFAXIntegrationConstants.REV_NRF_CODE_KEY)!=null){
						NRFCode = existingRevObj.getValue(LFAXIntegrationConstants.REV_NRF_CODE_KEY).toString();
					}
					if(existingRevObj.getValue(LFAXIntegrationConstants.REV_ITEM_NUMBER_KEY)!=null){
						revItemNumber = existingRevObj.getValue(LFAXIntegrationConstants.REV_ITEM_NUMBER_KEY).toString();
					}
					if(existingRevObj.getValue(LFAXIntegrationConstants.REV_STYLE_STATUS_KEY)!=null){
						revStyleStatus = existingRevObj.getValue(LFAXIntegrationConstants.REV_STYLE_STATUS_KEY).toString();
						if(FormatHelper.hasContent(revStyleStatus))
							revStyleStatus = axMaterialStyleStatusAttr.getAttValueList().getValue((String)revStyleStatus,com.lcs.wc.client.ClientContext.getContext().getLocale());
					}
					
					String revNameImage=prodVersion+"_"+psdToseasonVersionId;
					String revRowscommonId=prodVersion+"_"+psdToseasonVersionId+"_"+FormatHelper.getNumericVersionIdFromObject(skuobject);
					errorRow="<img  class='hotspot' title='' onmouseover='' onmouseout='' name='"+revNameImage+"_IMAGE' id='"+revRowscommonId+"_IMAGE' src=''  height='15' width='15' border='0'>";
					
					//if primary BOM is invalid, then make row as invalid
					printDebugStms("---------------isValidBOM------axxxxx----" , isValidBOM);
					if(!isValidBOM)
					{
						errorRow="<img  class='hotspot' title='BOM is invalid' onmouseover='' onmouseout='' name='"+revNameImage+"_IMAGE' id='"+revRowscommonId+"_IMAGE' src='/Windchill/rfa/lfusa/images/error.gif'  height='15' width='15' border='0'>";
					}
					
					printDebugStms("---------------prodNumber------axxxxx----", prodNumber);
					existingRevFlexObj.put("PRODSIZECATEGORYTOSEASON.BRANCHIDITERATIONINFO", psdToseasonVersionId);
					existingRevFlexObj.put("SIZEDEFINITION.NAME", sizeCategoryName);
					existingRevFlexObj.put("LCSPRODUCT.BRANCHIDITERATIONINFO",prodVersion);
					existingRevFlexObj.put("LCSEASON.BRANCHIDITERATIONINFO",FormatHelper.getNumericVersionIdFromObject(season));
					existingRevFlexObj.put("LCSSKU.SKUID", FormatHelper.getNumericVersionIdFromObject(skuobject));
					existingRevFlexObj.put("LCSREVISABLEENTITY.BRANCHIDITERATIONINFO",FormatHelper.getNumericVersionIdFromObject(existingRevObj));
					existingRevFlexObj.put("LCSSKU.SKUNAME",revEntSkuName);
					existingRevFlexObj.put("NRF.CODE", FormatHelper.setCharLengthPrefix(NRFCode,"0",3));
					
					existingRevFlexObj.put("errorRows",errorRow);
					existingRevFlexObj.put("PRODUCTNUMBER", productNum);
					existingRevFlexObj.put("ITEM.NUMBER", revItemNumber);
					existingRevFlexObj.put("COSTSHEETBRANCHID",costVersion);
					existingRevFlexObj.put("SPEC.STATUS",revStyleStatus);
					existingRevFlexObj.put("BOM.NAME",bomName);
					existingRevFlexObj.put("BOM.STATUS",String.valueOf(isValidBOM));
					skuVector.add(existingRevFlexObj);
				}
				
			//Step 10.2 : get colorways
				Collection skus = new ArrayList();
				if(existingEntries.size()>0){
					skus = stagingHelper.getFreshSKUsForStagingArea(existingEntries);
				}else{
					ProductHeaderQuery phq = new ProductHeaderQuery();
					skus = phq.findSKUs(product, null, season,true);
				}
				
			//Step 10.3 : for each colorway 
				Iterator skuIterator = skus.iterator();
				
				while (skuIterator.hasNext()) 
				{
					FlexObject newRevFlexObj = new FlexObject();
					skuobject = (LCSSKU) skuIterator.next();
					//printDebugStms("Fresh SKus -- start" , skuobject.getValue("skuName" ));

					String nameImage=prodVersion+"_"+psdToseasonVersionId;
					String rowscommonId=prodVersion+"_"+psdToseasonVersionId+"_"+FormatHelper.getNumericVersionIdFromObject(skuobject);

					Double nrfCodeDoubleVal = (Double)skuobject.getValue("lfNrfColorCode");
					//SkuNumber = (String)skuobject.getValue("gbgskuNo");
					printDebugStms("NRF color code double value.. ****************" , nrfCodeDoubleVal);
					NRFCode = FormatHelper.hasContent(String.valueOf(nrfCodeDoubleVal.intValue())) ? FormatHelper.setCharLengthPrefix(nrfCodeDoubleVal.intValue(),"0",3) : "";
					
					errorRow="<img  class='hotspot' title='' onmouseover='' onmouseout='' name='"+nameImage+"_IMAGE' id='"+rowscommonId+"_IMAGE' src=''  height='15' width='15' border='0'>";
					String itemNumber=productNum+NRFCode;
					Pattern colorwayPattern = Pattern.compile("[^A-Za-z0-9_ -]");
					colorWayName=(String)skuobject.getValue("skuName");
					printDebugStms("colorWayName in jsp is **************", colorWayName);
					Matcher colorN = colorwayPattern.matcher(colorWayName);
					boolean con = colorN.find();
					printDebugStms("con boolean value in jsp is **************", con);

					//if primary BOM is invalid, then make row as invalid
					if(!isValidBOM)
					{
						errorRow="<img  class='hotspot' title='BOM is invalid' onmouseover='' onmouseout='' name='"+nameImage+"_IMAGE' id='"+rowscommonId+"_IMAGE' src='/Windchill/rfa/lfusa/images/error.gif'  height='15' width='15' border='0'>";
					}
					
					if(!(FormatHelper.hasContent(productNum))){
						errorRow="<img  class='hotspot' title='Product Number should be valid' onmouseover='' onmouseout='' name='"+nameImage+"_IMAGE' id='"+rowscommonId+"_IMAGE' src='/Windchill/rfa/lfusa/images/error.gif'  height='15' width='15' border='0'>";

					}else if(!(FormatHelper.hasContent(itemNumber))){
						errorRow="<img  class='hotspot' title='Item Number should be present' onmouseover='' onmouseout='' name='"+nameImage+"_IMAGE' id='"+rowscommonId+"_IMAGE' src='/Windchill/rfa/lfusa/images/error.gif'  height='15' width='15' border='0'>";

					}else if(!(FormatHelper.hasContent(colorWayName))){
						errorRow="<img  class='hotspot' title='Colorway Name should be present' onmouseover='' onmouseout='' name='"+nameImage+"_IMAGE' id='"+rowscommonId+"_IMAGE' src='/Windchill/rfa/lfusa/images/error.gif'  height='15' width='15' border='0'>";

					}else if(!(FormatHelper.hasContent(NRFCode))){
						errorRow="<img  class='hotspot' title='NRF Code should be present' onmouseover='' onmouseout='' name='"+nameImage+"_IMAGE' id='"+rowscommonId+"_IMAGE' src='/Windchill/rfa/lfusa/images/error.gif'  height='15' width='15' border='0'>";

					}
					//printDebugStms("--NRFCode--->>>>>>", NRFCode);
					newRevFlexObj.put("PRODSIZECATEGORYTOSEASON.BRANCHIDITERATIONINFO", psdToseasonVersionId);
					newRevFlexObj.put("SIZEDEFINITION.NAME", sizeCategoryName);
					newRevFlexObj.put("LCSPRODUCT.BRANCHIDITERATIONINFO",prodVersion);
					newRevFlexObj.put("LCSEASON.BRANCHIDITERATIONINFO",FormatHelper.getNumericVersionIdFromObject(season));
					newRevFlexObj.put("LCSSKU.SKUID", FormatHelper.getNumericVersionIdFromObject(skuobject));
					newRevFlexObj.put("LCSSKU.SKUNAME",colorWayName);
					newRevFlexObj.put("NRF.CODE", NRFCode);
					newRevFlexObj.put("errorRows",errorRow);
					newRevFlexObj.put("PRODUCTNUMBER", productNum);
					newRevFlexObj.put("ITEM.NUMBER", itemNumber);
					newRevFlexObj.put("COSTSHEETBRANCHID",costVersion);
					newRevFlexObj.put("SPEC.STATUS",costsheetStatus);
					newRevFlexObj.put("BOM.STATUS",String.valueOf(isValidBOM));
					newRevFlexObj.put("BOM.NAME",bomName);
					
					skuVector.add(newRevFlexObj);
				}
			
			//Step 11 : prepare table columns list 
			
				Collection columnList = new ArrayList();
				
				TableColumn column = new TableColumn();
				//error column
				column.setDisplayed(true);
				column.setHeaderLabel("");
				column.setTableIndex("errorRows");
				column.setFormatHTML(false);
				column.setFormat("UNFORMATTED_HTML");
				column.setHeaderAlign("center");
				column.setColumnWidth("3.95%");
				columnList.add(column);
				//error column
				
				column = new TableColumn();
				column.setDisplayed(true);
				 column.setHeaderLabel("");
				column.setHeaderLabel("<input class=\"checkbox\" type=\"checkbox\" id=\""+tg.getTableId()+"_product_selectAllCheckBox\" value=\"false\" onClick=\"javascript:toggleAllAxTableItems('"+tg.getTableId()+"_product_selectAllCheckBox', '"+tg.getTableId() +"_product_selectedIds')\">"  + allLabel);
				column.setHeaderLabel("<input class=\"checkbox\" type=\"checkbox\" id=\""+tg.getTableId()+"_product_selectAllCheckBox\" value=\"false\" onClick=\"javascript:toggleAllAxTableItems('"+tg.getTableId()+"_product_selectAllCheckBox', '"+tg.getTableId() +"_product_selectedIds')\">"  + allLabel);
				LFAXCheckBoxTableFormElement fe = new LFAXCheckBoxTableFormElement();
				column.setConstantDisplay(true);
				fe.setValueIndex("LCSSKU.SKUID");
				fe.setName(tg.getTableId()+"_product_selectedIds");
				fe.setUniqueIdValue("LCSSKU.SKUID");
				column.setFormElement(fe);
				columnList.add(column);

				LFAXTextBoxTableFormElement tfe = new LFAXTextBoxTableFormElement();
				/*
				 * BOM Status
				 */
				column = new TableColumn();
				column.setDisplayed(true);
				column.setHeaderLabel("Product #");
				column.setHeaderAlign("center");
				column.setColumnWidth("15%");
				tfe = new LFAXTextBoxTableFormElement();
				tfe.setValueIndex("PRODUCTNUMBER");
				tfe.setShowNonEditableValue(true);
				tfe.setUniqueIdValue("LCSSKU.SKUID");
				tfe.setName("_PRODUCTNUMBER");
				column.setFormElement(tfe);
				columnList.add(column);
				
				
				/*
				 * Add color column 
				 */
				column = new TableColumn();
				column.setDisplayed(true);
				column.setHeaderLabel("Color");
				column.setHeaderAlign("center");
				tfe = new LFAXTextBoxTableFormElement();
				tfe.setValueIndex("LCSSKU.SKUNAME");
				tfe.setUniqueIdValue("LCSSKU.SKUID");
				tfe.setName("_COLOR_NAME");
				tfe.setShowNonEditableValue(true);
				column.setFormElement(tfe);
				column.setColumnWidth("10%");
				columnList.add(column);
				
				/*
				 * Add NRF code section here
				 */
				column = new TableColumn();
				column.setDisplayed(true);
				column.setHeaderLabel(MARK_MANDATORY+"NRF Color Code");
				column.setHeaderAlign("center");
				column.setColumnWidth("10%");
				tfe = new LFAXTextBoxTableFormElement();
				tfe.setValueIndex("NRF.CODE");
				tfe.setUniqueIdValue("LCSSKU.SKUID");
				tfe.setWidth("3");
				tfe.setName("_NRF_CODE");
				tfe.setShowNonEditableValue(true);
				column.setFormElement(tfe);
				columnList.add(column);
				
				/*
				 * Add ItemNumber column
				*/
				column = new TableColumn();
				column.setDisplayed(true);
				column.setHeaderLabel("Item Number");
				column.setHeaderAlign("center");
				column.setColumnWidth("15%");
				tfe = new LFAXTextBoxTableFormElement();
				tfe.setValueIndex("ITEM.NUMBER");
				tfe.setShowNonEditableValue(true);
				tfe.setUniqueIdValue("LCSSKU.SKUID");
				tfe.setName("_ITEMNUMBER");
				column.setFormElement(tfe);
				columnList.add(column);
				
				/*
				 * Add Items Status columns
				 */
				column = new TableColumn();
				column.setDisplayed(true);
				column.setHeaderLabel("Item Status");
				column.setHeaderAlign("center");
				column.setColumnWidth("15%");
				tfe = new LFAXTextBoxTableFormElement();
				tfe.setValueIndex("SPEC.STATUS");
				tfe.setShowNonEditableValue(true);
				tfe.setUniqueIdValue("LCSSKU.SKUID");
				tfe.setName("_ITEMSTATUS");
				column.setFormElement(tfe);
				columnList.add(column);
				
			//Step 11 : generate table 
				tg.setTableWidth(75);
				out.print(tg.drawTable(skuVector, columnList, null,false, false));
				
			//Step 12 : collect tableIds 
	    		tableIdEnd = tg.getTableId();
			    tableIds.add(tableIdEnd);
				countcs++;
			} 
	%>

	<br>
	<br>
	<%	
		} // end or products loop%>
	<input type="hidden" name="countcs"   id="countcs"   value='<%=countcs%>'>	
	<%} //end of try
	catch (Exception e) 
	{
		//System.out.println(e.printStackTrace());
		LCSLog.error("--e--"+e);
		e.printStackTrace();
	%>
		<table>
			<tr>
				<br>
				<br>
				<br>
				<td class="PAGEHEADINGTITLE" align="center"><%=e.getMessage()%></td>
			</tr>
		</table>
	<% } %>
	
	<% 
	//MM:
	
	if(tableIds!=null && !tableIds.isEmpty())
	{	
		startTableId = (String)tableIds.get(0);
		endTableId = (String)tableIds.get(tableIds.size()-1);

	}
	%>
	
<table width="75%">
	<tr>
		<td class="button" align="center">
			<a class="button" id="stagingsubmit2" name="stagingsubmit" href="javascript:AxSubmit()"><%= submitButton %></a><!--&nbsp;&nbsp;|&nbsp;&nbsp
			<a class="button" href="javascript:backCancel()"><%= cancelButton %></a>-->&nbsp;&nbsp;
			<input type="hidden" name="startTableId" id="startTableId" value='<%=startTableId%>'>
			<input type="hidden" name="endTableId"   id="endTableId"   value='<%=endTableId%>'>
	 </td>
	</tr>
</table>

<input type="hidden" name="oid1"   id="oid1"   value='<%=seasonId1%>'>	
<input type="hidden" name="seasonId" value="<%=seasonId1%>">
<input type="hidden" name="pid" value="<%=pid1%>">	
</form>


	