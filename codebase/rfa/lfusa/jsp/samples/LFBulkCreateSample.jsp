<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ///////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="/jsp/exception/ErrorReport.jsp"
    import=" com.lcs.wc.util.*,
            com.lcs.wc.util.*,
            com.lcs.wc.color.*,
			com.lcs.wc.client.Activities,
            com.lcs.wc.client.web.*,
            com.lcs.wc.db.*,
			com.lcs.wc.flextype.*,
            com.lcs.wc.material.*,
            com.lcs.wc.sample.*,
			com.lcs.wc.season.*,
			com.lcs.wc.sizing.*,
            com.lcs.wc.specification.*,
			com.lcs.wc.sourcing.*,
			com.lcs.wc.supplier.*,
			com.lcs.wc.foundation.*,
			com.lcs.wc.measurements.*,
            com.lcs.wc.product.*,
            com.lcs.wc.vendor.*,
            java.io.*,
            java.util.*,
            wt.part.*,
            wt.util.*,
            wt.util.WTProperties,
            wt.util.WTContext,
			org.apache.commons.lang.StringUtils,
			com.lcs.wc.product.LCSSKUQuery,
			com.lfusa.wc.sample.LFSampleConstants"
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
    public static final String STANDARD_TEMPLATE_HEADER = PageManager.getPageURL("STANDARD_TEMPLATE_HEADER", null);
    public static final String STANDARD_TEMPLATE_FOOTER = PageManager.getPageURL("STANDARD_TEMPLATE_FOOTER", null);
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final String PRODUCT_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.Root");
	public static final String FIT_SAMPLE_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.Fit.Root");
    public static final String PRODUCT_TEST_REQ_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.TestingRequest.Root");
	public static final boolean MEASUREMENT_SIZE_REQUIRED   = LCSProperties.getBoolean("jsp.testing.FitApproval.MeasurementSizeRequired");


    private static final boolean DEBUG = true;

    public static String getUrl = "";
    public static String WindchillContext = "/Windchill";

	public static String EVENTTYPEKEY = "lfNewEventType";
	public static String SAMPLETYPEKEY = "sampleType";
	public static String SAMPLEREQSEASONKEY = LFSampleConstants.SEASONNAMEKEY;


    static {
        try
        {
            WTProperties wtproperties = WTProperties.getLocalProperties();
            getUrl = wtproperties.getProperty("wt.server.codebase","");
            WindchillContext = "/" + wtproperties.getProperty("wt.webapp.name");

        } catch(Exception e){
            e.printStackTrace();
        }
    }

%><%
String typeLabel = WTMessage.getLocalizedMessage ( RB.FLEXTYPE, "flexType_LBL", RB.objA ) ;
String measurementSetLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "measurementsSet_LBL", RB.objA ) ;
String productLabel = WTMessage.getLocalizedMessage ( RB.SEASON, "product_LBL", RB.objA ) ;
String specificationLabel = WTMessage.getLocalizedMessage ( RB.SOURCING, "specification_LBL", RB.objA ) ;
String actionsLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "actions_LBL", RB.objA ) ;
String closeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "close_LBL", RB.objA ) ;
String allLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "all_LBL",RB.objA ) ;
String saveButton = WTMessage.getLocalizedMessage ( RB.MAIN, "save_Btn", RB.objA ) ;
String createButton = WTMessage.getLocalizedMessage ( RB.MAIN, "create_Btn", RB.objA ) ;
String createNewSampleRequestPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES,"createNewSampleRequest_PG_HEAD", RB.objA ) ;
String sizeCategoryNameLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sizeCategory_LBL",RB.objA ) ;
String colorwayGroupLabel = WTMessage.getLocalizedMessage ( RB.SOURCING,"colorwayGroup_LBL", RB.objA ) ;
String sampleSizeLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sampleSize_LBL",RB.objA ) ;
String sizeGroupLabel = WTMessage.getLocalizedMessage ( RB.SOURCING,"sizeGroup_LBL", RB.objA ) ;
String size2GroupLabel = WTMessage.getLocalizedMessage ( RB.SOURCING,"size2Group_LBL", RB.objA ) ;
String testingLibraryHeaderSpecificationsLbl = WTMessage.getLocalizedMessage ( RB.TESTSPECIFICATION, "displayTestSpecifications_GRP_TLE", RB.objA ) ;

String sourcingConfigurationLabel = WTMessage.getLocalizedMessage ( RB.SOURCING,"sourcingConfiguration_LBL", RB.objA ) ;
String totalSampleObjectsCreatedMessage = WTMessage.getLocalizedMessage ( RB.SAMPLES, "totalSampleObjectsCreated_MSG", RB.objA ) ;
String pleaseSelectSpecificationMSG = WTMessage.getLocalizedMessage ( RB.SAMPLES, "pleaseSelectSpecification_MSG", RB.objA );
String pleaseSelectMeasurementSetMSG = WTMessage.getLocalizedMessage ( RB.SAMPLES, "pleaseSelectMeasurementSet_MSG", RB.objA );
String notApplicableLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "notApplicable_LBL",RB.objA ) ;
String noneAvailableLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "noneAvailable_LBL", RB.objA );
String newLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "new_LBL",RB.objA ) ;

response.setContentType("text/html; charset=" +defaultCharsetEncoding);%><%
//setting up which RBs to use

FlexType productSampleRootType = FlexTypeCache.getFlexTypeFromPath(PRODUCT_ROOT_TYPE);
FlexType fitSampleRootType = FlexTypeCache.getFlexTypeFromPath(FIT_SAMPLE_ROOT_TYPE);
FlexType testRequestSampleRootType = FlexTypeCache.getFlexTypeFromPath(PRODUCT_TEST_REQ_ROOT_TYPE);


boolean fromLineSheet = false;
if(request.getParameter("fromLineSheet") != null){
	fromLineSheet = true;
}

if(FormatHelper.hasContent(request.getParameter("errorMessage"))){
		
	String errorMessage = java.net.URLDecoder.decode(request.getParameter("errorMessage"), defaultCharsetEncoding); 
	errorMessage = MOAHelper.parseOutDelims(errorMessage, "<br><br>");
	String infoMessage = "";
	if(FormatHelper.hasContent(request.getParameter("infoMessage"))){
		infoMessage = request.getParameter("infoMessage");
		if(infoMessage.indexOf("totalCreatedObjects:")>-1){
			infoMessage = infoMessage.substring(20);
		}
	}
%>
   <tr>
      <td class = "MAINLIGHTCOLOR" width="100%" border="0">
         <table>
            <tr>
               <td class="WARNING">
                  <%= errorMessage %>
               </td>
            </tr>
			<tr>
               <td class="INFO">
			   <br>
			   <br>
                  <%= totalSampleObjectsCreatedMessage + " " + infoMessage%>
               </td>
			</tr>
         </table>
        </td>
   </tr>

<%
}else if(FormatHelper.hasContent(request.getParameter("infoMessage"))){

	String infoMessage = "";
	if(FormatHelper.hasContent(request.getParameter("infoMessage"))){
		infoMessage = request.getParameter("infoMessage");
		if(infoMessage.indexOf("totalCreatedObjects:")>-1){
			infoMessage = infoMessage.substring(20);
		}
	}
%>
 <tr>
      <td class = "MAINLIGHTCOLOR" width="100%" border="0">
         <table>
			<tr>
               <td class="INFO">
			   <br>
			   <br>
                  <%= totalSampleObjectsCreatedMessage + " " + infoMessage%>
               </td>
			</tr>
         </table>
        </td>
   </tr>
<%
}else{


     HashMap colorwayNames = new HashMap();
     Collection sourcingNames = new Vector();
     Hashtable destinationNames = new Hashtable();
	 HashMap specNames = new HashMap();
	 HashMap specIdNames = new HashMap();

	 HashMap sizeCategoryMap = new HashMap();
 	 HashMap sizeCategoryMap1 = new HashMap();
	 HashMap sizeCategoryMap2 = new HashMap();

	 String productIds = request.getParameter("productIds");	 
 	String seasonName = "";
	String seasonId = "";
	String appcontextseasonID = "";
	String seasonNameTemp="";


	 if(request.getParameter("seasonId")!=null){
		 seasonId = request.getParameter("seasonId");
	 }
	 
	 LCSSeason season = null;
	 if(FormatHelper.hasContent(seasonId)){
		 season = (LCSSeason)LCSQuery.findObjectById(seasonId);
		 System.out.println("season1 name is **************"+season);
		 seasonNameTemp=season.getIdentity();
		  System.out.println("season1 name is **************"+seasonNameTemp);
		  
		 appcontextseasonID = FormatHelper.getNumericVersionIdFromObject(season);
		 System.out.println("seasonid1 name is **************"+seasonId);
	 }
	 //Added for null chck issue
	 else{
		LCSSeason appcontextseason = appContext.getSeason();
		System.out.println("seasonid1 name is **************"+appcontextseason);
		if(appcontextseason!=null){
		seasonNameTemp = appcontextseason.getIdentity();
		System.out.println("season name is **************"+seasonNameTemp);
		appcontextseasonID = FormatHelper.getNumericVersionIdFromObject(appcontextseason);
		System.out.println("appcontextseasonID name is **************"+seasonId);
		}
	 }
	 
	


	 Vector productList = new Vector();
	 boolean sourceToSeasonLinks = false;
	 boolean skuToSourceLinks = false;
	 boolean skus = false;


	 if(FormatHelper.hasContent(productIds)){
		  if(productIds.indexOf("LCSSourceToSeasonLink")>-1){
			sourceToSeasonLinks = true;
		  }else if(productIds.indexOf("LCSSKUSourcingLink:")>-1){
			  skuToSourceLinks = true;
		  }else if(productIds.indexOf("LCSSKU:")>-1){
			  skus = true;
		  }
		  Collection productIdsList =  MOAHelper.getMOACollection(productIds);
		  Iterator productObjectIterator = productIdsList.iterator();
		  while(productObjectIterator.hasNext()){
			   productList.add((String)productObjectIterator.next());
		  }	 
	 }


	 ProductHeaderQuery phq = new ProductHeaderQuery();
	 VendorQuery vendorquery = new VendorQuery();
	
  	 FlexObject fo = null;
	 LCSSourcingConfig sc = null;


	 Iterator specIterator;
	 FlexSpecification spec;
	 Vector specCollection;
	 String specNameIndex = FlexTypeCache.getFlexTypeRoot("Specification").getAttribute("specName").getVariableName();
	 Collection specList;
	 LCSProduct product = null;
	 LCSProduct productRevA = null;

	/**
	* Target Point Build: 004.23
	* Request ID : <18>
	* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
	*				 Variable Declaration.
	* @author Archana Saha
	* Modified On: 31-May-2013
	*/
	//ITC - START
	Collection colorwayList;
	Iterator colorwayIterator;
	LCSSKU colorwayObj = null;
	Vector colorwayCollection;
	HashMap colorwayIdNames = new HashMap();
	HashMap lfColorwayNames = new HashMap();
	WTPartMaster colorwayObjMaster = null;
	//ITC - END

	 Collection vector = new Vector();
	 if(fromLineSheet){
		 Collection objectList;
		 if(skuToSourceLinks){
			 objectList = LCSQuery.getObjectsFromCollectionNonRevControlled(productList);
		 }else{
			 objectList = LCSQuery.getObjectsFromCollectionRevControlled(productList);
		 }		
		 Iterator objectIterator = objectList.iterator();

		 LCSSourceToSeasonLink stsl;
		 LCSSKUSourcingLink sksl;
		LCSSeasonProductLink spl;
		 String productId;
		 LCSSKU sku = null;
		 String skuId = "";
		 Vector addedObject = new Vector();

		 while(objectIterator.hasNext()){

			if(sourceToSeasonLinks){
				stsl = (LCSSourceToSeasonLink)objectIterator.next();
                product = SeasonProductLocator.getProductSeasonRev((LCSSourceToSeasonLinkMaster)stsl.getMaster());
				productId = FormatHelper.getNumericVersionIdFromObject(product);
				sc = (LCSSourcingConfig)VersionHelper.latestIterationOf(stsl.getSourcingConfigMaster());
			}else if(skuToSourceLinks){
				sksl = (LCSSKUSourcingLink)objectIterator.next();
                sku = SeasonProductLocator.getSKUSeasonRev(sksl);
				skuId = FormatHelper.getNumericVersionIdFromObject(sku);
				product = sku.getProduct();
				productId = FormatHelper.getNumericVersionIdFromObject(product);
				sc = (LCSSourcingConfig)VersionHelper.latestIterationOf(sksl.getConfigMaster());
			}else if(skus){
				sku = (LCSSKU)objectIterator.next();
				skuId = FormatHelper.getNumericVersionIdFromObject(sku);
				product = sku.getProduct();
				productId = FormatHelper.getNumericVersionIdFromObject(product);
				stsl = LCSSourcingConfigQuery.getPrimarySourceToSeasonLink((WTPartMaster)product.getMaster(), (WTPartMaster)season.getMaster());
				sc = (LCSSourcingConfig)VersionHelper.latestIterationOf(stsl.getSourcingConfigMaster());
			}else{
				product = (LCSProduct)objectIterator.next();
				stsl = LCSSourcingConfigQuery.getPrimarySourceToSeasonLink((WTPartMaster)product.getMaster(), (WTPartMaster)season.getMaster());
				sc = (LCSSourcingConfig)VersionHelper.latestIterationOf(stsl.getSourcingConfigMaster());				
				productId = FormatHelper.getNumericVersionIdFromObject(product);
			}
			productRevA = SeasonProductLocator.getProductARev(product);
			if(!addedObject.contains(FormatHelper.getNumericFromOid(productId) + "$" +  FormatHelper.getNumericVersionIdFromObject(sc))){
				addedObject.add(FormatHelper.getNumericFromOid(productId) + "$" +  FormatHelper.getNumericVersionIdFromObject(sc));
			}else{
				continue;
			}
			if(lcsContext.isVendor){
				 specList = vendorquery.findSpecifications(productRevA, sc, season);
			}else{
				 specList = phq.findSpecifications(productRevA, sc, season);
			}


			 /**
			* Target Point Build: 004.23
			* Request ID : <18>
			* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
			* @author Archana Saha
			* Modified On: 31-May-2013
			*/
			//ITC - START
			product = (LCSProduct) VersionHelper.latestIterationOf(product);
			if(product!=null){

				colorwayList = LCSSKUQuery.findSKUs(product);
				colorwayIterator = colorwayList.iterator();
				while(colorwayIterator.hasNext()){

					colorwayObj = (LCSSKU)colorwayIterator.next();
					colorwayObjMaster = new WTPartMaster();
					colorwayObjMaster =(WTPartMaster)colorwayObj.getMaster();
					colorwayObj =  (LCSSKU)LCSSKUQuery.getSKUVersion(colorwayObjMaster, "A");

					if(lfColorwayNames.get(FormatHelper.getNumericObjectIdFromObject(product))!=null){
						colorwayCollection = (Vector)lfColorwayNames.get(FormatHelper.getNumericObjectIdFromObject(product));
						colorwayCollection.add(FormatHelper.getVersionId(colorwayObj));
						colorwayIdNames.put(FormatHelper.getVersionId(colorwayObj), colorwayObj.getValue("skuName"));
					}else{
						colorwayCollection = new Vector();
						colorwayCollection.add(FormatHelper.getVersionId(colorwayObj));
						colorwayIdNames.put(FormatHelper.getVersionId(colorwayObj), colorwayObj.getValue("skuName"));
						lfColorwayNames.put(FormatHelper.getNumericObjectIdFromObject(product), colorwayCollection);
					}
				}	
			}
			//ITC - END

			specIterator = specList.iterator();
			while(specIterator.hasNext()){
				spec = (FlexSpecification)specIterator.next();
				if(specNames.get(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()))!=null){
					specCollection = (Vector)specNames.get(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()));
					specCollection.add(FormatHelper.getVersionId(spec));
					specIdNames.put(FormatHelper.getVersionId(spec), spec.getValue("specName"));
				}else{
					specCollection = new Vector();
					specCollection.add(FormatHelper.getVersionId(spec));
					specIdNames.put(FormatHelper.getVersionId(spec), spec.getValue("specName"));
					specNames.put(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()), specCollection);
				}
			}



			fo = new FlexObject();
			fo.put("PRODUCTNAME", productRevA.getValue("productName"));
			fo.put("SCNAME", sc.getValue("name"));
			fo.put("SCMASTERID", FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()));
			fo.put("LCSSAMPLEREQUEST.IDA2A2", FormatHelper.getNumericFromOid(productId) + "$" +  FormatHelper.getNumericVersionIdFromObject(sc)  + "$r1");
			fo.put("LCSSAMPLEREQUEST.ID", FormatHelper.getNumericFromOid(productId) + "$" +  FormatHelper.getNumericVersionIdFromObject(sc)   + "$r1");			
			fo.put("SIZE", "size");
			//fo.put("SIZEGROUP2", "sizeGroup2");
			fo.put("COLORWAY", "colorway");
			fo.put("SPECIFICATION", "specification");
			fo.put("ADDIMAGE", WT_IMAGE_LOCATION + "/add16x16.gif");
			fo.put("DELETEIMAGE", WT_IMAGE_LOCATION + "/delete.png");
			fo.put("SAMPLETYPE", "sampleTypeHierarchy");
			fo.put("MEASUREMENTSET", "measurementSet");
			fo.put("TESTSPECIFICATION", "testSpecification");
			fo.put("OBJECTTYPE", "LCSSAMPLEREQUEST");
			/**
			* Target Point Build: 005.13
			* Description : Add the EventType Object to the Vector.
			* @author Bineeta
			* Modified On: 19-Feb-2013
			*/
			//ITC - START
			fo.put("EVENTTYPE", EVENTTYPEKEY);
			//ITC -END
			
			/**
			* Target Point Build: 006.4
			* Description : Add the Sample Type Object to the Vector.
			* @author LFUSA
			* Modified On: 17-Sept-2014
			*/
			//ITC - START
			fo.put("SAMPLETYPELF", SAMPLETYPEKEY);
			//ITC -END

			/**
			* Target Point Build: 004.23
			* Request ID : <18>
			* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
			*				 Adding Product Id to the vector.
			* @author Archana Saha
			* Modified On: 31-May-2013
			*/
			//ITC - START
			fo.put("PRODUCTID", FormatHelper.getNumericObjectIdFromObject(product));
			//ITC -END
			vector.add(fo);			
			 
		 }
	 }else if(productList.size() == 1){
			seasonId = appContext.getSeasonId();
			season = appContext.getSeason();
		    colorwayNames = appContext.getSKUsMap();
			sourcingNames = appContext.getSources();
			destinationNames = (Hashtable)appContext.getProductDestinationsMap(); 
			product = (LCSProduct)LCSQuery.findObjectById(productIds);
			productRevA = SeasonProductLocator.getProductARev(product);
			Collection productSizeCats = new SizingQuery().findProductSizeCategoriesForProduct(product).getResults();
			String sizeCategoryGroup = "";
			
			Iterator productSizeCatsIter = productSizeCats.iterator();
			FlexObject fobj = null;
			while(productSizeCatsIter.hasNext()){
				fobj = (FlexObject)productSizeCatsIter.next();
				sizeCategoryMap.put("OR:com.lcs.wc.sizing.ProductSizeCategory:" + fobj.get("PRODUCTSIZECATEGORY.IDA2A2"), fobj.get("SIZECATEGORY.NAME"));
				sizeCategoryMap1.put("OR:com.lcs.wc.sizing.ProductSizeCategory:" + fobj.get("PRODUCTSIZECATEGORY.IDA2A2"), fobj.get("PRODUCTSIZECATEGORY.SIZEVALUES"));
				sizeCategoryMap2.put("OR:com.lcs.wc.sizing.ProductSizeCategory:" + fobj.get("PRODUCTSIZECATEGORY.IDA2A2"), fobj.get("PRODUCTSIZECATEGORY.SIZE2VALUES"));
			}


			if(appContext.getSourcingConfig()!=null){
					sc = appContext.getSourcingConfig();

					if(lcsContext.isVendor){
						 specList = vendorquery.findSpecifications(productRevA, sc, season);
					}else{
						 specList = phq.findSpecifications(productRevA, sc, season);
					}
					specIterator = specList.iterator();
					while(specIterator.hasNext()){
						spec = (FlexSpecification)specIterator.next();
						if(specNames.get(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()))!=null){
							specCollection = (Vector)specNames.get(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()));
							specCollection.add(FormatHelper.getVersionId(spec));
							specIdNames.put(FormatHelper.getVersionId(spec), spec.getValue("specName"));
						}else{
							specCollection = new Vector();
							specCollection.add(FormatHelper.getVersionId(spec));
							specIdNames.put(FormatHelper.getVersionId(spec), spec.getValue("specName"));
							specNames.put(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()), specCollection);
						}
					}
					fo = new FlexObject();
					fo.put("PRODUCTNAME", product.getValue("productName"));
					fo.put("SCNAME", sc.getValue("name"));
					fo.put("SCMASTERID", FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()));
					fo.put("LCSSAMPLEREQUEST.IDA2A2", FormatHelper.getNumericFromOid(productIds) + "$" +  FormatHelper.getNumericVersionIdFromObject(sc)  + "$r1");
					fo.put("LCSSAMPLEREQUEST.ID", FormatHelper.getNumericFromOid(productIds) + "$" +  FormatHelper.getNumericVersionIdFromObject(sc)  + "$r1");
					fo.put("SIZE", "size");
					//fo.put("SIZEGROUP2", "sizeGroup2");
					fo.put("COLORWAY", "colorway");
					fo.put("SPECIFICATION", "specification");
					fo.put("ADDIMAGE", WT_IMAGE_LOCATION + "/add16x16.gif");
					fo.put("DELETEIMAGE", WT_IMAGE_LOCATION + "/delete.png");
			fo.put("SAMPLETYPE", "sampleTypeHierarchy");
					fo.put("MEASUREMENTSET", "measurementSet");
					fo.put("TESTSPECIFICATION", "testSpecification");
					fo.put("OBJECTTYPE", "LCSSAMPLEREQUEST");
			/**
			* Target Point Build: 005.13
			* Description : Add the EventType Object to the Vector.
			* @author Bineeta
			* Modified On: 19-Feb-2013
			*/
			//ITC - START
			fo.put("EVENTTYPE", EVENTTYPEKEY);
			//ITC -END
			
			/**
			* Target Point Build: 006.4
			* Description : Add the Sample Type Object to the Vector.
			* @author LFUSA
			* Modified On: 17-Sept-2014
			*/
			//ITC - START
			fo.put("SAMPLETYPELF", SAMPLETYPEKEY);
			//ITC -END
					vector.add(fo);	
			}else{
				Iterator sourcingIterator = sourcingNames.iterator();
				while(sourcingIterator.hasNext()){
					sc = (LCSSourcingConfig)sourcingIterator.next();

					if(lcsContext.isVendor){
						 specList = vendorquery.findSpecifications(productRevA, sc, season);
					}else{
						 specList = phq.findSpecifications(productRevA, sc, season);
					}
					specIterator = specList.iterator();

					while(specIterator.hasNext()){
						spec = (FlexSpecification)specIterator.next();
						if(specNames.get(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()))!=null){
							specCollection = (Vector)specNames.get(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()));
							specCollection.add(FormatHelper.getVersionId(spec));
							specIdNames.put(FormatHelper.getVersionId(spec), spec.getValue("specName"));
						}else{
							specCollection = new Vector();
							specCollection.add(FormatHelper.getVersionId(spec));
							specIdNames.put(FormatHelper.getVersionId(spec), spec.getValue("specName"));
							specNames.put(FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()), specCollection);
						}
					}
					fo = new FlexObject();
					fo.put("PRODUCTNAME", product.getValue("productName"));
					fo.put("SCNAME", sc.getValue("name"));
					fo.put("SCMASTERID", FormatHelper.getNumericObjectIdFromObject((LCSSourcingConfigMaster)sc.getMaster()));
					fo.put("LCSSAMPLEREQUEST.IDA2A2", FormatHelper.getNumericFromOid(productIds) + "$" + FormatHelper.getNumericVersionIdFromObject(sc)  + "$r1");
					fo.put("LCSSAMPLEREQUEST.ID", FormatHelper.getNumericFromOid(productIds) + "$" + FormatHelper.getNumericVersionIdFromObject(sc)  + "$r1");
					fo.put("SIZE", "size");
					//fo.put("SIZEGROUP2", "sizeGroup2");
					fo.put("COLORWAY", "colorway");
					fo.put("SPECIFICATION", "specification");
					fo.put("ADDIMAGE", WT_IMAGE_LOCATION + "/add16x16.gif");
					fo.put("DELETEIMAGE", WT_IMAGE_LOCATION + "/delete.png");
			fo.put("SAMPLETYPE", "sampleTypeHierarchy");
					fo.put("MEASUREMENTSET", "measurementSet");
					fo.put("TESTSPECIFICATION", "testSpecification");
					fo.put("OBJECTTYPE", "LCSSAMPLEREQUEST");
			/**
			 * Target Point Build: 005.13
			 * Description : Add the EventType Object to the Vector.
			 * @author Bineeta
			 * Modified On: 19-Feb-2013
			 */
			//ITC - START
			fo.put("EVENTTYPE", EVENTTYPEKEY);
			//ITC - END
			
			/**
			* Target Point Build: 006.4
			* Description : Add the Sample Type Object to the Vector.
			* @author LFUSA
			* Modified On: 17-Sept-2014
			*/
			//ITC - START
			fo.put("SAMPLETYPELF", SAMPLETYPEKEY);
			//ITC -END
					vector.add(fo);			

				}
			}
	 }



	 FlexTypeAttribute requestNameAtt = productSampleRootType.getAttribute("requestName");
	 FlexTypeAttribute quantityAtt = productSampleRootType.getAttribute("quantity");
	FlexTypeAttribute sampleRequestDescriptionAtt = productSampleRootType.getAttribute("lfSampleRequestDescription");

	 Vector sortOrder = new Vector();
	 if(fromLineSheet){
	 	 sortOrder.add("PRODUCTNAME");
	 }
	 sortOrder.add("SCNAME");
	 vector = (List)(new FlexObjectSorter()).sortFlexObjects((Collection)vector, sortOrder);


	 Vector columns = new Vector();

	 TableColumn iColumn = new TableColumn();

	 Collection actions = new ArrayList();

     iColumn = new ImageWithLabelTableColumn();
	 iColumn.setDisplayed(true);
	 iColumn.setHeaderLabel("");
	 ((ImageWithLabelTableColumn)iColumn).setImageTableIndex("ADDIMAGE");
	 ((ImageWithLabelTableColumn)iColumn).setImageLinkMethod("BulkCreateSample.addNewRow");
	 ((ImageWithLabelTableColumn)iColumn).setImageLinkTableIndex("LCSSAMPLEREQUEST.IDA2A2");
	 ((ImageWithLabelTableColumn)iColumn).setImageLinkTableIndex2("OBJECTTYPE");
	 iColumn.setColumnWidth("1%");
	 columns.add(iColumn);



     iColumn = new ImageWithLabelTableColumn();
	 iColumn.setDisplayed(true);
	 iColumn.setHeaderLabel("");
	 ((ImageWithLabelTableColumn)iColumn).setImageTableIndex("DELETEIMAGE");
	 ((ImageWithLabelTableColumn)iColumn).setImageLinkMethod("BulkCreateSample.deleteRow");
	 ((ImageWithLabelTableColumn)iColumn).setImageLinkTableIndex("LCSSAMPLEREQUEST.IDA2A2");
	 ((ImageWithLabelTableColumn)iColumn).setImageLinkTableIndex2(null);
	 iColumn.setColumnWidth("1%");
	 columns.add(iColumn);

	 if(fromLineSheet){
		 iColumn = new TableColumn();
		 iColumn.setDisplayed(true);
		 iColumn.setHeaderLabel(productLabel);
		 iColumn.setTableIndex("PRODUCTNAME");
		 columns.add(iColumn);
	 }


	 iColumn = new TableColumn();
	 iColumn.setDisplayed(true);
	 iColumn.setHeaderLabel(sourcingConfigurationLabel);
	 iColumn.setTableIndex("SCNAME");
	 iColumn.setColumnWidth("8%");
	 columns.add(iColumn);

	 iColumn = new TableColumn();
	 iColumn.setDisplayed(true);
	 iColumn.setHeaderLabel("* " + typeLabel);
	 iColumn.setTableIndex("SAMPLETYPE");
	 iColumn.setColumnWidth("5%");
	 columns.add(iColumn);


	 iColumn = new TableColumn();
	 iColumn.setDisplayed(true);
	 iColumn.setHeaderLabel("* " + specificationLabel);
	 iColumn.setTableIndex("SPECIFICATION");
	 iColumn.setColumnWidth("5%");
	 columns.add(iColumn);	 

	/**
     * Target Point Build: 004.23
     * Request ID : <22,24>
     * Description : Code to hide measurement and size for Accessories and Home 
     * @author Archana Saha
     * Modified On: 10-May-2013
    */
	/***** START ****/
	FlexType productFlexType = product.getFlexType();


	String productTypeName = null;

	if(productFlexType!=null){
		productTypeName = productFlexType.getFullNameDisplay();
		//System.out.println("applinesheet"+productTypeName);
		if(StringUtils.isNotBlank(productTypeName)){
		//Checks if the product is of Apparel line, measurement and size visible only for Apparel 
			if(productTypeName.equalsIgnoreCase("Apparel")){

				iColumn = new TableColumn();
				iColumn.setDisplayed(true);
				iColumn.setHeaderLabel(measurementSetLabel);
				iColumn.setTableIndex("MEASUREMENTSET");
				iColumn.setColumnWidth("5%");
				columns.add(iColumn);	
				
				iColumn = new TableColumn();
				iColumn.setDisplayed(true);
				iColumn.setHeaderLabel(sampleSizeLabel);
				iColumn.setTableIndex("SIZE");
				iColumn.setColumnWidth("3%");
				columns.add(iColumn);
			}
		}
	}				
	/**
     * Target Point Build: 004.23
     * Request ID : <22>
     * Description : Code to hide Test Specification for Accessories and Apparel
     * @author Archana Saha
     * Modified On: 10-May-2013
    */
 
	if(productFlexType!=null){
		productTypeName = productFlexType.getTypeParent().getFullNameDisplay();
		if(StringUtils.isNotBlank(productTypeName)){
		//Test specification hidden for Products of Accessories and Apparel line.
			if(productTypeName.equalsIgnoreCase("Home")){

				iColumn = new TableColumn();
				iColumn.setDisplayed(true);
				iColumn.setHeaderLabel(testingLibraryHeaderSpecificationsLbl);
				iColumn.setTableIndex("TESTSPECIFICATION");
				iColumn.setColumnWidth("5%");
				columns.add(iColumn);
				 
			}
			
		}
	}
	/**** END ****/
	 

	/**
	 * Target Point Build: 004.23
	 * Request ID : <18>
	 * Description : Code to show Colorway dropdown, when creating samples from Linesheet.
	 *				 Commented out so that colorway down visible in Samples from linesheet.
	 * @author Archana Saha
	 * Modified On: 31-May-2013
	 */
	//ITC - START
	//if(!fromLineSheet){

	iColumn = new TableColumn();
	iColumn.setDisplayed(true);
	iColumn.setHeaderLabel(colorwayGroupLabel);
	iColumn.setTableIndex("COLORWAY");
	iColumn.setColumnWidth("5%");
	columns.add(iColumn);	 
	// }
	//ITC -END



	/**
	 * Target Point Build: 005.13
	 * Description : Add a CustomColumn for the attribute EventType in Sample Request Scope
	 * @author Bineeta Kachhap
	 * Modified On: 17-Feb-2014
	 */
	//ITC - START
	if(productFlexType!=null){
		productTypeName = productFlexType.getFullNameDisplay();
		if(StringUtils.isNotBlank(productTypeName)){
		//Checks if the product is of Apparel line
			if(productTypeName.equalsIgnoreCase("Apparel")){
				iColumn = new TableColumn();
				iColumn.setDisplayed(true);
				iColumn.setHeaderLabel("Event Type");
				iColumn.setTableIndex("EVENTTYPE");
				iColumn.setColumnWidth("10%");
				columns.add(iColumn);
			}
	//ITC -END
			
	/**
	 * Target Point Build: 006.4
	 * Description : Add a CustomColumn for the attribute Sample Type in Sample Request Scope
	 * @author LFUSA
	 * Modified On: 17-Sept-2014
	 */
	//ITC - START
			if(productTypeName.equalsIgnoreCase("Accessories")||productTypeName.equalsIgnoreCase("Home")){
				iColumn = new TableColumn();
				iColumn.setDisplayed(true);
				iColumn.setHeaderLabel("*" + "Sample Type");
				iColumn.setTableIndex("SAMPLETYPELF");
				iColumn.setColumnWidth("30%");
				columns.add(iColumn);
			}
		}
	}
	//ITC -END

	/**
	 * Target Point Build: 006.14
	 * Description : Commenting OOTB code to set "Sample Request Name" as Non Editable 
					& adding new attribute "Sample request Description"
	 * @author LFUSA
	 * Modified On: 18-May-2015
	 */
	// ITC - START
  /*iColumn = new UpdateTableColumn();
	 iColumn.setDisplayed(true);
	 iColumn.setHeaderLabel("* " + requestNameAtt.getAttDisplay());
	 iColumn.setTableIndex(requestNameAtt.getSearchResultIndex());
	 ((UpdateTableColumn)iColumn).setFlexTypeAttribute(requestNameAtt);
	 ((UpdateTableColumn)iColumn).setWorkingIdIndex("LCSSAMPLEREQUEST.IDA2A2");
	 ((UpdateTableColumn)iColumn).setRowIdIndex(requestNameAtt.getSearchResultIndex());
	columns.add(iColumn);*/
	// Sample Request Name
	iColumn = new TableColumn();
	iColumn.setDisplayed(true);
	iColumn.setHeaderLabel("*" + requestNameAtt.getAttDisplay());
	iColumn.setTableIndex(requestNameAtt.getSearchResultIndex());
	iColumn.setFlexTypeAttribute(requestNameAtt);
	iColumn.setColumnWidth("8%");
	iColumn.setRowIdIndex(requestNameAtt.getSearchResultIndex());
	columns.add(iColumn);
	
	// Sample request Description
	iColumn = new UpdateTableColumn();
	iColumn.setDisplayed(true);
	iColumn.setHeaderLabel(sampleRequestDescriptionAtt.getAttDisplay());
	iColumn.setTableIndex(sampleRequestDescriptionAtt.getSearchResultIndex());
	((UpdateTableColumn)iColumn).setFlexTypeAttribute(sampleRequestDescriptionAtt);
	((UpdateTableColumn)iColumn).setWorkingIdIndex("LCSSAMPLEREQUEST.IDA2A2");
	((UpdateTableColumn)iColumn).setRowIdIndex(sampleRequestDescriptionAtt.getSearchResultIndex());
	iColumn.setColumnWidth("5%");
	columns.add(iColumn);
	// Target Point Build: 006.14
	// ITC -END

	iColumn = new UpdateTableColumn();
	iColumn.setDisplayed(true);
	iColumn.setHeaderLabel("*" + quantityAtt.getAttDisplay());
	iColumn.setTableIndex(quantityAtt.getSearchResultIndex());
	((UpdateTableColumn)iColumn).setFlexTypeAttribute(quantityAtt);
	((UpdateTableColumn)iColumn).setWorkingIdIndex("LCSSAMPLEREQUEST.IDA2A2");
	((UpdateTableColumn)iColumn).setRowIdIndex(quantityAtt.getSearchResultIndex());
	iColumn.setColumnWidth("3%");

	 /**
     * Target Point Build: 004.23
     * Request ID : <6>
     * Description : Code to Hide Quantity column from create and View page. 
     * @author Archana Saha
     * Modified On: 16-May-2013
    */
	/**** START ****/
	// columns.add(iColumn);
	/**** END ****/


	 HashMap columnMap = new HashMap();
	 Collection attList = new ArrayList();



	 Collection searchColumns = flexg.createSearchResultColumnKeys(productSampleRootType, "Sample.");
	 Collection allAtts = productSampleRootType.getAllAttributes(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE, null);
	 Iterator allAttsIter = allAtts.iterator();
	 FlexTypeAttribute flexAtt;
	 while(allAttsIter.hasNext()){
		flexAtt = (FlexTypeAttribute)allAttsIter.next();
		if(flexAtt.isAttRequired() && !flexAtt.isAttHidden() && !searchColumns.contains("Sample." + flexAtt.getAttKey())){
			searchColumns.add("Sample." + flexAtt.getAttKey());
		}
	 }

	 /**
     * Target Point Build: 004.23
     * Request ID : <16,22>
     * Description : Code to hide Sample Type for Apparel
     * @author Archana Saha
     * Modified On: 13-May-2013
    */
	/**** START ****/
	Collection showColumns =  new Vector();
	Collection showColumns1 =  new Vector();
	if(productFlexType!=null){
		productTypeName = productFlexType.getFullNameDisplay();
		if(StringUtils.isNotBlank(productTypeName)){
		
			Iterator iterShowColumn = allAtts.iterator();
			FlexTypeAttribute flexAttShowColumn;
			if(productTypeName.equalsIgnoreCase("Apparel")){		
				while(iterShowColumn.hasNext()){
					flexAttShowColumn = (FlexTypeAttribute)iterShowColumn.next();
					
					if(!((flexAttShowColumn.getAttKey()).equalsIgnoreCase("sampleType")) && !"lfGridSampleQuantity".equalsIgnoreCase(flexAttShowColumn.getAttKey())){
						showColumns.add(flexAttShowColumn);
						//System.out.println("flexAttShowColumn for samples is *************"+flexAttShowColumn);
					}
				}
			}
			else{
				showColumns1 = productSampleRootType.getAllAttributes(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE, null, false);
				System.out.println("showColumns1 for samples is *************"+showColumns1);
				Iterator iterShowColumn1 = showColumns1.iterator();
				FlexTypeAttribute flexAttShowColumn1;
				while(iterShowColumn1.hasNext()){
					flexAttShowColumn1 = (FlexTypeAttribute)iterShowColumn1.next();
					if(!"lfGridSampleQuantity".equalsIgnoreCase(flexAttShowColumn1.getAttKey())){
						showColumns.add(flexAttShowColumn1);
						//System.out.println("flexAttShowColumn1 for samples is *************"+flexAttShowColumn1);
					}
					
				}
			}
		}
	}
	/**** END ****/
	flexg.setLevel(null);
	//flexg.createTableColumns(productSampleRootType, columnMap, productSampleRootType.getAllAttributes(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE, null, false), false, false, "Sample.", null, true, null, true);
	// createTableColumns(FlexType type, java.util.Map columns, java.util.Collection attCollection, boolean update, boolean updateRemote, java.lang.String identifierPrefix, java.util.Collection usedAttKeys, boolean forceIncludePartners, java.lang.String localTableName, boolean create) 
	
	flexg.createTableColumns(productSampleRootType, columnMap,showColumns, false, false, "Sample.", null, true, null, true);
	

	if(columnMap.get("Sample.quantity") !=null){
		columnMap.remove("Sample.quantity");
	}
	

	 flexg.extractColumns(searchColumns, columnMap, attList, columns);


	 Iterator columnsIter = columns.iterator();
	 TableColumn tc;
	 while(columnsIter.hasNext()){
		 tc = (TableColumn)columnsIter.next();
		 if(tc instanceof UpdateTableColumn){
			 if(((UpdateTableColumn)tc).getFlexTypeAttribute() != null){
			 }

			 ((UpdateTableColumn)tc).setEditMode("CREATE_VALUE");
		 }
	 }


	  tg.setShowEditTools(true);
	  tg.setRowIdIndex("LCSSAMPLEREQUEST.IDA2A2");
	  tg.setHideSearchReplaceRow(true);

	%>


	<table width="100%" align="center">
		<tr>
			<td>
				<table width="100%">
				  <tr>
					<td class="contextBarText">
					   <span class="PAGEHEADINGTITLE" style="vertical-align:bottom;"><%= createNewSampleRequestPgHead %>
					   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
					<td class="button" align="right">
						<a class="button" href="javascript:BulkCreateSample.createSamples()"><%= createButton %></a>
					</td>
				  </tr>
				</table>
			</td>
		</tr>
<!--		<tr>
			<td>
				<table>
					<tr>
					   <%
						if(!fromLineSheet){
							String selectedId = "";
							if(sizeCategoryMap.size()==1){
								selectedId = (String)sizeCategoryMap.keySet().iterator().next();
							}
							%>
							<%= fg.createDropDownListWidget(sizeCategoryNameLabel, sizeCategoryMap, "sizeCategoryGroup", selectedId, "setBulkSizeOptions();", false, true) %>
							<%}%>
					</tr>
				</table>
			</td>
		</tr>-->
		<tr>
			<td>
			<%=tg.drawTable(vector, columns, "", false, true)%>

			</td>
		</tr>
        <tr>
		<td>
		<div id="tableName">TBLT<%=tg.getTableId()%></div>
		<div id="activityName">CREATE_SAMPLE</div>

		</td>
		</tr>
 


	</table>

<script>

/**
  * Target Point Build: 004.23
  * Request ID : <17>
  * Description : Code to autopopulate measurement and size if a specification has only 1 measurement.
  * @author Archana Saha
  * Modified On: 10-May-2013
  */
BulkCreateSample = {
		
		pleaseSelectSpecificationMSG : '',
		pleaseSelectMeasurementSetMSG : '',
		noneAvailableLabel : '',
		newLabel : '',
		notApplicableLabel : '',
		waitMessage : '',
		fromLineSheet : false,
		productIds : '',
		fitSampleType : new Array(),    
		testRequestSampleType : new Array(),   
		sampleTypeArray : new Array(),
		sampleTypeNameArray : new Object(),
		sizesCategoryArray : new Array(),
		sizesArray1 : new Object(),
		sizesArray2 : new Object(),
		sizes : new Object(),
		sampleSizes : new Object(),
		colorwayArray : new Object(),
		colorwayIdArray : new Array(),
		specArray : new Object(),
		specIdNameArray : new Array(),
		scArray : new Array(),
		allRows : new Array(),
		requiredAttArray : new Object(),
		/**
		* Target Point Build: 004.23
		* Request ID : <18>
		* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
		*				Added array object.
		* @author Archana Saha
		* Modified On: 31-May-2013
		*/
		//ITC - START
		productArray : new Array(),
		//ITC - END


		/**
		 * Target Point Build: 005.13
		 * Description : The Corresponding Key and Value Arrays 
		 *				for EventType Attribute List to be added in teh column
		 * @author Bineeta
		 * Modified On: 19-Feb-2013
		 */
		//ITC - START
		eventTypeKeyArray : new Array(),
		eventTypeValueArray : new Object(),
		//ITC - END
		
		
		/**
		 * Target Point Build: 006.4
		 * Description : The Corresponding Key and Value Arrays 
		 *				for Sample Type Attribute List to be added in the column
		 * @author LFUSA
		 * Modified On: 17-Sept-2014
		 */
		sampleTypeKeyLFArray : new Array(),
		sampleTypeValueLFArray : new Object(),
		//ITC - END

		 reset: function(){
			 this.fromLineSheet= false;
			 this.productIds = "";
			 this.fitSampleType = new Array();
			 this.testRequestSampleType = new Array();
			 this.sampleTypeArray = new Array();
			 this.sampleTypeNameArray = new Object();
			 this.sizesCategoryArray = new Array();
			 this.sizesArray1 = new Object();
			 this.sizesArray2 = new Object();
			 this.sizes = new Object();
			 this.sampleSizes = new Object();
			 this.colorwayArray = new Object();
			 this.colorwayIdArray = new Array();
			 this.specArray = new Object();
			 this.specIdNameArray = new Array();
			 this.scArray = new Array();
			 this.allRows = new Array();
			 this.requiredAttArray = new Object();
			/**
			* Target Point Build: 004.23
			* Request ID : <18>
			* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
			* @author Archana Saha
			* Modified On: 31-May-2013
			*/
			//ITC - START
			this.productArray = new Array();
			//ITC - END
			/**
			 * Target Point Build: 005.13
			 * Description : The Corresponding Key and Value Arrays 
			 *				for EventType Attribute List to be added in teh column
			 * @author Bineeta
			 * Modified On: 19-Feb-2013
			 */
			//ITC - START
			this.eventTypeKeyArray = new Array();
			this.eventTypeValueArray = new Object();
			//ITC - END
			
			/**
			 * Target Point Build: 006.4
			 * Description : The Corresponding Key and Value Arrays 
			 *				for Sample Type Attribute List to be added in the column
			 * @author LFUSA
			 * Modified On: 17-Sept-2014
			 */
			//ITC - START
			this.sampleTypeKeyLFArray = new Array();
			this.sampleTypeValueLFArray = new Object();
			//ITC - END
		 },


		createSamples :	function (){
		
			var dataStringArray = ajaxFormElementsArray(document.AJAXFORM);
			var missingRequiredAttribute = false;
			var tableKey;
			var attKey;

			for (tableKey in dataStringArray){  
				//alert ("tableKey"+tableKey);

				for (attKey in this.requiredAttArray){
					if(tableKey.indexOf("M_F_")>-1 && tableKey.indexOf("_" + attKey) > -1 && (tableKey.indexOf("_" + attKey) + attKey.length + 1)==tableKey.length){
						if(!hasContentAllowZero(dataStringArray[tableKey]) || (document.getElementById(tableKey + "Display") && dataStringArray[tableKey]=='0')){
							if(attKey == "measurementSet_ForCreation"){
								var sampleTypeWidget = $(replaceAll(tableKey, "measurementSet_ForCreation", "sampleType_ForCreation"));	
								missingRequiredAttribute = false;
								for(var h=0; h<this.fitSampleType.length; h++){
									if(this.fitSampleType[h] == sampleTypeWidget.value){
										missingRequiredAttribute = true;
										break;
									}
								}
							}else if(attKey == "size_ForCreation"){
								var sampleTypeWidget = $(replaceAll(tableKey, "size_ForCreation", "sampleType_ForCreation"));	
								missingRequiredAttribute = false;
								for(var h=0; h<this.fitSampleType.length; h++){
									if(this.fitSampleType[h] == sampleTypeWidget.value){
										missingRequiredAttribute = true;
										break;
									}
								}
									   
							}else if(attKey == "testSpecification_ForCreation"){
								var sampleTypeWidget = $(replaceAll(tableKey, "testSpecification_ForCreation", "sampleType_ForCreation"));	
								missingRequiredAttribute = false;
								for(var h=0; h<this.testRequestSampleType.length; h++){
									if(this.testRequestSampleType[h] == sampleTypeWidget.value){
										missingRequiredAttribute = true;
										break;
									}
								}
									   
							}else{
								missingRequiredAttribute = true;
							}
							if(missingRequiredAttribute){
								if($(tableKey) && $(tableKey).disabled == false && $(tableKey).type != "hidden"){
									$(tableKey).focus();
								}
								alert(mustEnterValueForMSG + this.requiredAttArray[attKey]);
								missingRequiredAttribute = true;
								break;
							}
						}
					}
						
				}
				if(missingRequiredAttribute){
					break;
				}
			}
			if(!missingRequiredAttribute){
				var dataString = ajaxFormElementsString(document.AJAXFORM);
				divWindow.showProcessingMessage();
				new Ajax.Updater("divContent", location.protocol + '//' + location.host + urlContext + '/jsp/main/Main.jsp', { 
					parameters : "activity=BULK_CREATE_SAMPLE&action=SAVE&dataString=" + dataString, 
					evalScripts: true
				});		
			}			
		},


		getCellSource : function(id, type, idArray, nameArray, onChangeJS){	

		   var disabled = "";
		   var idDisplay = "";
		   if(type == "size"){
			  this.allRows[this.allRows.length] = id;
			  id = id + "_size_ForCreation";
			  disabled = "disabled=true";
		   }else if(type == "size2"){
			  id = id + "_sizeGroup2_ForCreation";	  
		   }else if(type == "colorway"){
			  id = id + "_colorwayReference_ForCreation";	  
		   }else if(type == "specification"){
			  id = id + "_specReference_ForCreation";	  
		   }else if(type == "measurementSet"){
			  id = id + "_measurementSet_ForCreation";	
			  disabled = "disabled=true";
			}else if(type == "sampleTypeHierarchy"){
			  id = id + "_sampleType_ForCreation";	  
		   }else if(type == "testSpecification"){
			  idDisplay = id + "_testSpecification_ForCreationDisplay";
			  id = id + "_testSpecification_ForCreation";	  
			/**
			 * Target Point Build: 005.13
			 * Description : The Corresponding EventType Key used both as 
			 *				Type of the dropDown Element and Key to pass to the value.
			 * @author Bineeta
			 * Modified On: 19-Feb-2013
			 */
			//ITC - START
			}else if(type == '<%=EVENTTYPEKEY%>'){
				id = id + "_" + "<%=EVENTTYPEKEY%>";
			//ITC - END	
			
			/**
			 * Target Point Build: 006.4
			 * Description : The Corresponding Sample Type Key used both as 
			 *				Type of the dropDown Element and Key to pass to the value.
			 * @author LFUSA
			 * Modified On: 17-Sept-2014
			 */
			//ITC - START
			}else if(type == '<%=SAMPLETYPEKEY%>'){
				id = id + "_" + "<%=SAMPLETYPEKEY%>";
			}
			//ITC - END
			
		   var tempString = new quickDoc();
		   if(type != "testSpecification"){
			   if(onChangeJS != null){
					tempString.write('<select ' + disabled + ' name=\"' + id + '\" id=\"' + id + '\" parent=\"' + id + '\" onkeydown=\"typeAhead()\" onChange=\"' + onChangeJS  + '\">');
			   }else{
					tempString.write('<select ' + disabled + ' name=\"' + id + '\" id=\"' + id + '\" parent=\"' + id + '\" onkeydown=\"typeAhead()\">');
			   }
			  // tempString.write('<option value=\" \">');
			   if(type == "specification" && idArray){
					var entries = moaToArray(idArray, "|~*~|");
					tempString.write('<option value=\"\">');	
					for(var b=0; b<entries.length; b++){	
						  tempString.write('<option value=\"' + entries[b] + '\" >' +  nameArray[entries[b]]);
					}
				}else if((type == "colorway"||type == "sampleTypeHierarchy" ) && idArray){
						/**
						* Target Point Build: 004.23
						* Request ID : <18>
						* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
						* @author Archana Saha
						* Modified On: 31-May-2013
						*/
						//ITC - START
					   if(idArray.indexOf('|~*~|')!=-1){
							var entries = moaToArray(idArray, "|~*~|");
							tempString.write('<option value=\"\">');	
							for(var b=0; b<entries.length; b++){	
							  tempString.write('<option value=\"' + entries[b] + '\" >' +  nameArray[entries[b]]);
						}
					   }
					   //ITC - END
					   else{
						tempString.write('<option value=\"\">');	
						for(var b=0; b<idArray.length; b++){		
							  tempString.write('<option value=\"' + idArray[b] + '\" >' +  nameArray[idArray[b]]);
						}
					   }
				}else if(type == "measurementSet"){
						 tempString.write('<option value=\" \">' + this.pleaseSelectSpecificationMSG);	
				}else if(type == "size"){
						 tempString.write('<option value=\" \">' + this.pleaseSelectMeasurementSetMSG);	
				}

				/**
				 * Target Point Build: 005.13
				 * Description : The HTML construction for the EventType Column to display value.
				 * @author Bineeta
				 * Modified On: 19-Feb-2013
				 */
				//ITC - START
				else if(type == '<%=EVENTTYPEKEY%>'){
					tempString.write('<option value=\"\">');	
						for(var b=0; b<idArray.length; b++){		
							  tempString.write('<option value=\"' + idArray[b] + '\" >' +  nameArray[idArray[b]]);
					}
				}
				//ITC - END
				
				/**
				 * Target Point Build: 006.4
				 * Description : The HTML construction for the Sample Type Column to display value.
				 * @author LFUSA
				 * Modified On: 17-Sept-2014
				 */
				//ITC - START
				else if(type == '<%=SAMPLETYPEKEY%>'){
					tempString.write('<option value=\"\">');	
						for(var b=0; b<idArray.length; b++){		
							  tempString.write('<option value=\"' + idArray[b] + '\" >' +  nameArray[idArray[b]]);
					}
				}
				//ITC - END
			   tempString.write('</select>');
		   }else{
			   tempString.write('<table><tr><td id=\'' + id + 'TD\' class=\'FORMLABEL\' nowrap>' + this.notApplicableLabel + '</td></tr></table>');				   
		   }

		   return tempString.toString();
		},

		setMeasurementSet : function(rowId, selectedSpec){
			var selectedSampleTypeId = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_sampleType_ForCreation").value;
			var measurementSetSelect = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_measurementSet_ForCreation");
			var sizeSelect = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_size_ForCreation");
			var measurementSetElementId = "M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_measurementSet_ForCreation";
			var sizeElementId = "M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_size_ForCreation";
			if(selectedSpec == ""){
				removeAllOptions(measurementSetSelect);
				addOptionValue(measurementSetSelect, pleaseSelectSpecificationMSG, '');
				measurementSetSelect.disabled = true;
				removeAllOptions(sizeSelect);
				addOptionValue(sizeSelect, pleaseSelectMeasurementSetMSG, '');
				sizeSelect.disabled = true;
			
			}else{
				var currentRow = $(rowId);
				if(hasContent(currentRow.innerHTML) && currentRow.innerHTML.indexOf("$") > -1){
					for(var w=0; w<currentRow.childNodes.length; w++){
						if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML.indexOf("measurementSet")>-1){
							addOptionValue(measurementSetSelect, this.waitMessage, '');
							runPostAjaxRequest(location.protocol + '//' + location.host + urlContext + '/jsp/main/Main.jsp', "activity=FIND_MEASUREMENTSET_AND_SIZE&specificationId=" + selectedSpec + "&measurementSetElementId=" + measurementSetElementId + "&sizeElementId=" + sizeElementId + "&sampleTypeId=" + selectedSampleTypeId, 'BulkCreateSample.populateMeasurementSetAndSize');


						}		
					}
				}
			}
		},


		setSampleType : function(rowId, selectedSampleType){
			/**
			 * Target Point Build: 006.4
			 * Description : The Ajax Request to fetch the EventType Value from the Flextype Selected
			 *				through the function "BulkCreateSample.setEventType" for Apparel, and
			 *				to fetch the Sample Type Value from the Flextype Selected
			 *				through the function "BulkCreateSample.setSampleTypeValue" for
			 *				Home & Accessories.
			 * @author LFUSA
			 * Modified On: 17-Sept-2014
			 */
			//ITC - START
			<% if(productFlexType!=null){
				productTypeName = productFlexType.getFullNameDisplay();
				if(StringUtils.isNotBlank(productTypeName)){
					if(productTypeName.equalsIgnoreCase("Apparel")){ %>
						/**
						 * Target Point Build: 005.13
						 * Description : The Ajax Request to fetch the EventType Value from teh Flextype Selected
						 *				through the function "BulkCreateSample.setEventType".
						 * @author Bineeta
						 * Modified On: 19-Feb-2013
						 */
						//ITC - START
						runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/lfusa/jsp/samples/LFEventTypeAjax.jsp?&selectedSampleType='+selectedSampleType+'&rowId='+rowId,'BulkCreateSample.setEventType');
						//ITC - END
					<%}else {%>
					runAjaxRequest(location.protocol + '//' + location.host + '<%=URL_CONTEXT%>/lfusa/jsp/samples/LFSampleTypeAjax.jsp?&selectedSampleType='+selectedSampleType+'&rowId='+rowId,'BulkCreateSample.setSampleTypeValue');
					<%} 
				}
			}%>
			//ITC - END
			var specificationSelect = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_specReference_ForCreation");
			var measurementSetSelect = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_measurementSet_ForCreation");
			var sizeSelect = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_size_ForCreation");
			var testSpecificationTD = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_testSpecification_ForCreationTD");

			var isFitSample = false;
			var isTestRequest = false;

			for(var h=0; h<this.fitSampleType.length; h++){
				if(this.fitSampleType[h] == selectedSampleType){
					if(hasContent(specificationSelect.value)){
						if(measurementSetSelect.options.length > 1){
							measurementSetSelect.options[0].text = " ";
							measurementSetSelect.disabled = false;
						}else{
							measurementSetSelect.options[0].text = this.noneAvailableLabel;
						}
					}
					isFitSample =true;
					break;
				}
			}

			for(var h=0; h<this.testRequestSampleType.length; h++){
				if(this.testRequestSampleType[h] == selectedSampleType){
					var idDisplay = "M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_testSpecification_ForCreationDisplay";
					var id = "M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_testSpecification_ForCreation";	 
					var tempString = new quickDoc();
					tempString.write('<a href=\"javascript:launchModuleChooser(\'TESTSPECIFICATION\', \'\',' + idDisplay + ' , $(\'' + id + '\') , false, \'\', true , \'\', \'\')\">' + this.newLabel + ':</a>&nbsp;');
					tempString.write('<input value=\"\" name=\"' + id + '\" id=\"' + id + '\" type=\"hidden\">');
					tempString.write('<div id=\"' + idDisplay + '\"><a href=\"javascript:doNothing()\" onclick=\"showTypeAheadChooser(this, \'' + id + '\', \'TESTSPECIFICATION\', \'\', \'null\')\">------</a></div>');

					testSpecificationTD.innerHTML = tempString.toString();
					isTestRequest =true;
					break;
				}
			}
			if(!isFitSample){
			/**** START ****/
				if(selectedSampleTypeId != "" && measurementSetSelect != ""){
					measurementSetSelect.disabled = true;
				}
			/**** END ****/
				if(measurementSetSelect.disabled == false){
					measurementSetSelect.disabled = true;
					measurementSetSelect.options[0].text = this.notApplicableLabel;
					measurementSetSelect.options[0].selected = true;

					removeAllOptions(sizeSelect);
					addOptionValue(sizeSelect, pleaseSelectMeasurementSetMSG, '');
					sizeSelect.disabled = true;
				}
			}

			if(!isTestRequest){
				 testSpecificationTD.innerHTML = this.notApplicableLabel;
			}

		},

		/**
		 * Target Point Build: 005.13
		 * Description : The internal Function "setEventType" 
		 *				to set the EventType Dropdown value dynamically when Flextype is selected.
		 * @author Bineeta
		 * Modified On: 19-Feb-2013
		 */
		//ITC - START
		setEventType : function(xml, text){
			var keyValuePair = text.split('|~*~|');
			// Current Row ID 
			var row = keyValuePair[0].split('||');
			var rowId = row[1];
			// Key and Value Array
			BulkCreateSample.eventTypeKeyArray = new Array();
			BulkCreateSample.eventTypeValueArray = new Object();
			// Iterating through the data fetched from Ajax 
			for(var i=1;i<(keyValuePair.length-1);i++){
				var temp = keyValuePair[i].split('||');
				BulkCreateSample.eventTypeKeyArray[i-1]=temp[0];
				BulkCreateSample.eventTypeValueArray[BulkCreateSample.eventTypeKeyArray[i-1]]= temp[1];
			}
			// the Event Type ID and HTML Element
			var id = "M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_" + "<%=EVENTTYPEKEY%>";
			var element= document.getElementById(id);
			// Set the DropDown values
			element.parentNode.innerHTML = BulkCreateSample.getCellSource("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId ,"<%=EVENTTYPEKEY%>", BulkCreateSample.eventTypeKeyArray,			BulkCreateSample.eventTypeValueArray , "");
		},
		//ITC - END
		
		
		/**
		 * Target Point Build: 006.4
		 * Description : The internal Function "setSampleTypeValue" 
		 *				to set the Sample Type Dropdown value dynamically when Flextype is selected.
		 * @author LFUSA
		 * Modified On: 17-Sept-2014
		 */
		//ITC - START
		setSampleTypeValue : function(xml, text){
			var keyValuePair = text.split('|~*~|');
			// Current Row ID 
			var row = keyValuePair[0].split('||');
			var rowId = row[1];
			// Key and Value Array
			BulkCreateSample.sampleTypeKeyLFArray = new Array();
			BulkCreateSample.sampleTypeValueLFArray = new Object();
			// Iterating through the data fetched from Ajax 
			for(var i=1;i<(keyValuePair.length-1);i++){
				var temp = keyValuePair[i].split('||');
				BulkCreateSample.sampleTypeKeyLFArray[i-1]=temp[0];
				BulkCreateSample.sampleTypeValueLFArray[BulkCreateSample.sampleTypeKeyLFArray[i-1]]= temp[1];
			}
			// the Event Type ID and HTML Element
			var id = "M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_" + "<%=SAMPLETYPEKEY%>";var element= document.getElementById(id);
			// Set the DropDown values
			element.parentNode.innerHTML = BulkCreateSample.getCellSource("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId ,"<%=SAMPLETYPEKEY%>", BulkCreateSample.sampleTypeKeyLFArray,			BulkCreateSample.sampleTypeValueLFArray , "");
		},
		//ITC - END
		populateMeasurementSetAndSize : function(xml, text) {
			var count =0;
				var scriptText = text.substring(text.indexOf("<div id=\"scriptContent\">") + 24, text.indexOf("</div>"));
			var lines =  scriptText.split('\n');
				eval(scriptText);
			/**** START ****/
			for(var i=0; i<lines.length; i++){
					if(lines[i].indexOf('addOptionValue(measurementSetElement') !== -1){
						count= count+1;
					}
			}
			if(count == 2){
				var index1 = scriptText.indexOf('(');
				var index2 = scriptText.indexOf(');');
				var measurementSetElement = scriptText.substring(index1+2, index2-1);

				var rowIndex1 = scriptText.indexOf('F_');
				var rowIndex2 = scriptText.indexOf('_LCSSAMPLEREQUEST');
				var rowId = scriptText.substring(rowIndex1+2, rowIndex2);
				
				var measurementSetElementId = document.getElementById(measurementSetElement);
				var selectedSampleTypeId = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_sampleType_ForCreation").value;
								
				var selectedMeasurement = measurementSetElementId.options[1].value;
				measurementSetElementId.options[1].selected = true;	
				this.setSize(rowId,selectedMeasurement);
				measurementSetElementId.disabled = false;

			}
		/**** END ****/
		},


		setSize : function(rowId, selectedMeasurementSet){
			var sizeSelect = $("M_F_" + rowId + "_LCSSAMPLEREQUEST$" + rowId + "_size_ForCreation");
			removeAllOptions(sizeSelect);

			if(selectedMeasurementSet == ""){
				addOptionValue(sizeSelect, pleaseSelectMeasurementSetMSG, '');
				sizeSelect.disabled = true;

			}else{
				var sizeRun = this.sizes[selectedMeasurementSet];
				var sampleSize = this.sampleSizes[selectedMeasurementSet];
				sizeSelect.disabled = false;
				if(sizeRun){
					var sizeRunArray = moaToArray(sizeRun, "|~*~|");
					for(var j=0; j<sizeRunArray.length; j++){
						addOptionValue(sizeSelect, sizeRunArray[j], sizeRunArray[j]);
					}
					if(hasContent(sampleSize)){
						 var selectedSizeIndex = getKeyIndex(sizeSelect, sampleSize);
						 if(selectedSizeIndex > 0){
							sizeSelect.selectedIndex = selectedSizeIndex;
						 }
					}

				}else{
					addOptionValue(sizeSelect, this.noneAvailableLabel, '');

				}
			}
		},


		addNewRow : function(id, objectType){

			var currentId = id;
			var tableName = $('tableName');
			var table = $(tableName.innerHTML);
			var mytablebody = table.getElementsByTagName("tbody")[0];

			var nextCounter = 2;
			var currentCounter = 0;
			var initialCounter;
		 
			var existingRow = $(id);
			var existingRowElements = existingRow.getElementsByTagName("td");

			if(existingRow){
				initialCounter = id.substring(id.indexOf("$r")+2);
				id = replaceAll(id, "$r" + initialCounter, "$r" + nextCounter);
				while($(id)!=null){
					currentCounter = nextCounter;
					nextCounter++;
					id = replaceAll(id, "$r" + currentCounter, "$r" + nextCounter);
				}

				this.allRows[this.allRows.length] = "M_F_" + id + "_" + objectType + "$" + id;
				var newRow = existingRow.cloneNode(true);
				newRow.id = id;
				mytablebody.insertBefore(newRow, existingRow.nextSibling);        

				var newRowElements = newRow.getElementsByTagName("td");
				for(var b =0; b<newRowElements.length; b++){
					newRowElements[b].innerHTML = existingRowElements[b].innerHTML;
					newRowElements[b].innerHTML = replaceAll(newRowElements[b].innerHTML, "$r" + initialCounter, "$r" + nextCounter);
                    newRowElements[b].innerHTML = replaceAll(newRowElements[b].innerHTML, "\\x24r" + initialCounter, "\\x24r" + nextCounter);
					parseCalendarTags(newRowElements[b].innerHTML);
				}


				var formElements = existingRow.getElementsByTagName("select");
				var formElementId;
				var newFormElementId;
				var newFormElement;
				for(var b =0; b<formElements.length; b++){
					formElementId = formElements[b].id;
					newFormElementId = replaceAll(formElementId, "$r" + initialCounter, "$r" + nextCounter); 
					if(!hasContent(formElements[b].type) || (hasContent(formElements[b].type) && formElements[b].type != "select-multiple")){			
						newFormElement = $(newFormElementId);
						if(formElements[b].selectedIndex > -1){
							newFormElement.options[formElements[b].selectedIndex].setAttribute("selected","selected");
							newFormElement.selectedIndex = formElements[b].selectedIndex; 
						}
					}

				}

				formElements = existingRow.getElementsByTagName("input");
			 
				for(var b =0; b<formElements.length; b++){
					formElementId = formElements[b].id;
					newFormElementId = replaceAll(formElementId, "$r" + initialCounter, "$r" + nextCounter); 
					newFormElement = $(newFormElementId);
					newFormElement.value = formElements[b].value;
				}

				formElements = existingRow.getElementsByTagName("textarea");
			 
				for(var b =0; b<formElements.length; b++){
					formElementId = formElements[b].id;
					newFormElementId = replaceAll(formElementId, "$r" + initialCounter, "$r" + nextCounter); 
					newFormElement = $(newFormElementId);
					newFormElement.value = formElements[b].value;

				}
				parseCalendarTags(newRow.innerHTML);
			}
		},



		deleteRow : function(id){

		  if(id && hasContent(domTeConfirmRowDeleteMSG)){
			 if(!confirm(domTeConfirmRowDeleteMSG + "\n")){
				return;
			 }
		  }
			var tableName = $('tableName');
			var table = $(tableName.innerHTML);
			var mytablebody = table.getElementsByTagName("tbody")[0];
			var row =$(id);
			mytablebody.removeChild(row);

			var childNodes = mytablebody.childNodes;
			var validElementsCount = 0;
			for(var i=0; i<childNodes.length; i++){
				if(childNodes[i].nodeType == 1){
					validElementsCount++;
				}
			}
			if(validElementsCount==3){
				divWindow.showProcessingMessage();
				if(!this.fromLineSheet){
					new Ajax.Request(location.protocol + '//' + location.host + urlContext + '/jsp/main/Main.jsp', { 
						parameters : "activity=BULK_CREATE_SAMPLE&ajaxWindow=true&action=INIT&productIds=" + this.productIds + "&oid=" + document.REQUEST.oid, 
						onSuccess : function(resp) {
							var responseText = resp.responseText;
							responseText = replaceAll(responseText, "MAINFORM", "AJAXFORM");
							$("divContent").innerHTML = responseText;				
							responseText.evalScripts();
							parseCalendarTags($("divContent").innerHTML);
						}
					});
			   }else{
					var seasonId="";
					if(document.LINE_PLAN.seasonVersionId){
						seasonId = document.LINE_PLAN.seasonVersionId;
					}
					new Ajax.Request(location.protocol + '//' + location.host + urlContext + '/jsp/main/Main.jsp', { 
						parameters : "activity=BULK_CREATE_SAMPLE&ajaxWindow=true&action=INIT&fromLineSheet=true&productIds=" + selectedProducts + "&seasonId=" + seasonId, 
						onSuccess : function(resp) {
							var responseText = resp.responseText;
							responseText = replaceAll(responseText, "MAINFORM", "AJAXFORM");
							$("divContent").innerHTML = responseText;				
							responseText.evalScripts();
							parseCalendarTags($("divContent").innerHTML);
						}
					});
			   }
			}        
		}
	};

	BulkCreateSample.reset();
	BulkCreateSample.pleaseSelectSpecificationMSG = '<%=FormatHelper.formatJavascriptString(pleaseSelectSpecificationMSG, false)%>';
	BulkCreateSample.pleaseSelectMeasurementSetMSG = '<%=FormatHelper.formatJavascriptString(pleaseSelectMeasurementSetMSG, false)%>';
	BulkCreateSample.noneAvailableLabel = '<%=FormatHelper.formatJavascriptString(noneAvailableLabel, false)%>';
	BulkCreateSample.newLabel = '<%=FormatHelper.formatJavascriptString(newLabel, false)%>';
	BulkCreateSample.notApplicableLabel = '<%=FormatHelper.formatJavascriptString(notApplicableLabel, false)%>';
	BulkCreateSample.waitMessage = '<%= FormatHelper.formatJavascriptString(WTMessage.getLocalizedMessage ( RB.MAIN, "loading_MSG", RB.objA ), false)%>';
	BulkCreateSample.productIds = '<%=FormatHelper.getVersionId(productRevA)%>';

<%if(fromLineSheet){%>
	BulkCreateSample.fromLineSheet = true;

<%}%>


<%
	Map reversed = new HashMap();
	Iterator keys = colorwayNames.keySet().iterator();
	String key;
	while(keys.hasNext()){
		key = (String) keys.next();
		reversed.put(colorwayNames.get(key), key);
	}

    Collection sortedKeys = SortHelper.sortStrings(reversed.keySet());

	keys = sortedKeys.iterator();
	while(keys.hasNext()){
		key = (String)keys.next();
%>
		BulkCreateSample.colorwayArray['<%=(String)reversed.get(key)%>'] = '<%=FormatHelper.formatJavascriptString(key)%>';

		BulkCreateSample.colorwayIdArray[BulkCreateSample.colorwayIdArray.length] = '<%=(String)reversed.get(key)%>';
<%
	}
%>

<%
	Iterator iterator = sizeCategoryMap.keySet().iterator();
	String id;
	while(iterator.hasNext()){
		id = (String)iterator.next();
%>
		BulkCreateSample.sizesCategoryArray[BulkCreateSample.sizesCategoryArray.length] = '<%=id%>';

		BulkCreateSample.sizesArray1['<%=id%>'] = '<%=FormatHelper.formatJavascriptString((String)sizeCategoryMap1.get(id))%>';
		BulkCreateSample.sizesArray2['<%=id%>'] = '<%=FormatHelper.formatJavascriptString((String)sizeCategoryMap2.get(id))%>';

<%
	}
%>

<%
    specIterator = specNames.keySet().iterator();
	String scName;
	while(specIterator.hasNext()){
		scName = (String)specIterator.next();
		specCollection = (Vector)specNames.get(scName);
		
%>
		BulkCreateSample.specArray['<%=FormatHelper.formatJavascriptString(scName)%>'] = '<%=MOAHelper.toMOAString(specCollection)%>';
<%
	}
%>


<%
	/**
	* Target Point Build: 004.23
	* Request ID : <18>
	* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
	*				 Adding Product Id to the vector.
	* @author Archana Saha
	* Modified On: 31-May-2013
	*/
	//ITC - START
	if(fromLineSheet){
	 colorwayIterator = lfColorwayNames.keySet().iterator();
	String productName;
	while(colorwayIterator.hasNext()){
		productName = (String)colorwayIterator.next();
		colorwayCollection = (Vector)lfColorwayNames.get(productName);
%>
		BulkCreateSample.colorwayArray['<%=FormatHelper.formatJavascriptString(productName)%>'] = '<%=MOAHelper.toMOAString(colorwayCollection)%>';
<%
	}
}
//ITC -END
%>

<%
	Iterator specIdNameIterator = specIdNames.keySet().iterator();
	String specId;
	while(specIdNameIterator.hasNext()){
		specId = (String)specIdNameIterator.next();
		
%>
		BulkCreateSample.specIdNameArray['<%=specId%>'] = '<%=FormatHelper.formatJavascriptString((String)specIdNames.get(specId))%>';
<%
	}
%>

<%
	//ITC - START
	if(fromLineSheet){
	Iterator colorwayIdNameIterator = colorwayIdNames.keySet().iterator();
	String colorwayId;
	while(colorwayIdNameIterator.hasNext()){
		colorwayId = (String)colorwayIdNameIterator.next();
%>
		BulkCreateSample.colorwayIdArray['<%=colorwayId%>'] = '<%=FormatHelper.formatJavascriptString((String)colorwayIdNames.get(colorwayId))%>';
<%
	}
}
	//ITC- END
%>
<%
	Iterator resultIterator = vector.iterator();
	FlexObject f;
	while(resultIterator.hasNext()){
		f = (FlexObject)resultIterator.next();
		
%>
		BulkCreateSample.scArray[BulkCreateSample.scArray.length] = '<%=f.getString("SCMASTERID")%>';
		//ITC -START
		BulkCreateSample.productArray[BulkCreateSample.productArray.length] = '<%=f.getString("PRODUCTID")%>';
		//ITC -END
<%
	}
%>
<%
	Collection allCreatableChildren = productSampleRootType.getAllCreatableChildren();
	allCreatableChildren =SortHelper.sort(allCreatableChildren, "fullNameDisplay"); 
	Iterator typeKey = allCreatableChildren.iterator();
    FlexType sampleType;
%>
<% if(ACLHelper.hasCreateAccess(productSampleRootType) && productSampleRootType.isTypeActive()){%>
		BulkCreateSample.sampleTypeArray[BulkCreateSample.sampleTypeArray.length]='<%=FormatHelper.getObjectId(productSampleRootType)%>';
		BulkCreateSample.sampleTypeNameArray['<%=FormatHelper.getObjectId(productSampleRootType)%>'] = '<%=FormatHelper.formatJavascriptString(productSampleRootType.getFullNameDisplay())%>';
<%}%>
<%
    while(typeKey.hasNext()){
		sampleType = (FlexType) typeKey.next();
        if(sampleType.isTypeActive()){
%>

		//BulkCreateSample.sampleTypeArray[BulkCreateSample.sampleTypeArray.length]='<%=FormatHelper.getObjectId(sampleType)%>';
		//BulkCreateSample.sampleTypeNameArray['<%=FormatHelper.getObjectId(sampleType)%>'] = '<%=FormatHelper.formatJavascriptString(sampleType.getFullNameDisplay())%>';

		/**
		 * Target Point Build: 004.23
		 * Request ID : <3>
		 * Description : Code to Change the type display name to only subtype instead of whole path. 
		 *				Also Type will be displayed based on the Product Line.
						and Commented out the above OOTB Lines
		 * @author Archana Saha
		 * Modified On: 10-May-2013
		*/
		/**** START ****/
			<%if(productFlexType!=null){
				productTypeName = productFlexType.getFullNameDisplay();
				if(StringUtils.isNotBlank(productTypeName)){
				
					if(productTypeName.equalsIgnoreCase("Apparel")){
						if(sampleType.getFullNameDisplay().contains("Product\\Product Sample\\Apparel")){
						%>
							BulkCreateSample.sampleTypeArray[BulkCreateSample.sampleTypeArray.length]='<%=FormatHelper.getObjectId(sampleType)%>';
							BulkCreateSample.sampleTypeNameArray['<%=FormatHelper.getObjectId(sampleType)%>'] = '<%=FormatHelper.formatJavascriptString(sampleType.getTypeName())%>';	
							//alert("BulkCreateSample.sampleTypeArray : " + BulkCreateSample.sampleTypeArray.length);
						<%}
					}
					else
					if(productTypeName.equalsIgnoreCase("Accessories")){
						if(sampleType.getFullNameDisplay().contains("Product\\Product Sample\\Accessories")){%>
							BulkCreateSample.sampleTypeArray[BulkCreateSample.sampleTypeArray.length]='<%=FormatHelper.getObjectId(sampleType)%>';
							BulkCreateSample.sampleTypeNameArray['<%=FormatHelper.getObjectId(sampleType)%>'] = '<%=FormatHelper.formatJavascriptString(sampleType.getTypeName())%>';
					<%}
					}
					else
					if(productTypeName.equalsIgnoreCase("Home")){
						if(sampleType.getFullNameDisplay().contains("Product\\Product Sample\\Home")){%>
							BulkCreateSample.sampleTypeArray[BulkCreateSample.sampleTypeArray.length]='<%=FormatHelper.getObjectId(sampleType)%>';
							BulkCreateSample.sampleTypeNameArray['<%=FormatHelper.getObjectId(sampleType)%>'] = '<%=FormatHelper.formatJavascriptString(sampleType.getTypeName())%>';
					<%}
					} 
					else 
					if(productTypeName.equalsIgnoreCase("Footwear")){
						System.out.println("sampleType.getFullNameDisplay() --- " + FormatHelper.getObjectId(sampleType));
						System.out.println("Does it contain :::: " + sampleType.getFullNameDisplay().contains("Product\\Product Sample\\Footwear"));
						if(sampleType.getFullNameDisplay().contains("Product\\Product Sample\\Footwear")){%>
							BulkCreateSample.sampleTypeArray[BulkCreateSample.sampleTypeArray.length]='<%=FormatHelper.getObjectId(sampleType)%>';
							BulkCreateSample.sampleTypeNameArray['<%=FormatHelper.getObjectId(sampleType)%>'] = '<%=FormatHelper.formatJavascriptString(sampleType.getTypeName())%>';
					<%}
					
					}

				}
			}%>
			/**** END ****/
<%
		}
	}
%>

<%
	allCreatableChildren = productSampleRootType.getAllCreatableChildren();
	allCreatableChildren = SortHelper.sort(allCreatableChildren, "fullNameDisplay"); 
	typeKey = allCreatableChildren.iterator();
	while(typeKey.hasNext()){
		FlexType sampleType1 = (FlexType) typeKey.next();
		if(sampleType1.isTypeActive() && sampleType1.getFullNameDisplay().contains("Product\\Product Sample\\Apparel")){%>
		<%
		}
	}
%>

<%
    allCreatableChildren = fitSampleRootType.getAllCreatableChildren();
	typeKey = allCreatableChildren.iterator();
%>
<% if(ACLHelper.hasCreateAccess(fitSampleRootType)){%>
		BulkCreateSample.fitSampleType[BulkCreateSample.fitSampleType.length]='<%=FormatHelper.getObjectId(fitSampleRootType)%>';

<%}%>
<%
    while(typeKey.hasNext()){
		sampleType = (FlexType) typeKey.next();

%>
	BulkCreateSample.fitSampleType[BulkCreateSample.fitSampleType.length]='<%=FormatHelper.getObjectId(sampleType)%>';
<%
	}
%>		

<%
    allCreatableChildren = testRequestSampleRootType.getAllCreatableChildren();
	typeKey = allCreatableChildren.iterator();
%>
<% if(ACLHelper.hasCreateAccess(testRequestSampleRootType)){%>
		BulkCreateSample.testRequestSampleType[BulkCreateSample.testRequestSampleType.length]='<%=FormatHelper.getObjectId(testRequestSampleRootType)%>';

<%}%>
<%
    while(typeKey.hasNext()){
		sampleType = (FlexType) typeKey.next();

%>
	BulkCreateSample.testRequestSampleType[BulkCreateSample.testRequestSampleType.length]='<%=FormatHelper.getObjectId(sampleType)%>';
<%
	}
%>		




var sizeGroupSource = $("sizeGroupSourceDiv");
var table = $('TBLT<%=tg.getTableId()%>');
var mytablebody = table.getElementsByTagName("tbody")[0];

var g=0;
var thisRowArray = mytablebody.childNodes;

var thisRowArrayLength = thisRowArray.length;
var h=0;

for(g=3; g<thisRowArrayLength; g++){
	var currentRow = thisRowArray[g];
	if(hasContent(currentRow.innerHTML) && currentRow.innerHTML.indexOf("$") > -1){
		for(var w=0; w<currentRow.childNodes.length; w++){
			if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML=='size'){
				currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "size");    
				}else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML=='colorway'){
					//currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "colorway", BulkCreateSample.colorwayIdArray, BulkCreateSample.colorwayArray);    
				<%
					/**
					* Target Point Build: 004.23
					* Request ID : <18>
					* Description : Code to show Colorway dropdown, when creating samples from Linesheet.
					*				 Adding Product Id to the vector.
									and Commented out the abouve OOTB Lines
					* @author Archana Saha
					* Modified On: 31-May-2013
					*/
					//ITC - START
					if(!fromLineSheet){ %>
						currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "colorway", BulkCreateSample.colorwayIdArray, BulkCreateSample.colorwayArray);  
					<%}
					else{%>
						currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "colorway",BulkCreateSample.colorwayArray[BulkCreateSample.productArray[h]], BulkCreateSample.colorwayIdArray);  
					<%}
					//ITC - END
				%>
				}else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML=='specification'){
					currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "specification", BulkCreateSample.specArray[BulkCreateSample.scArray[h]], BulkCreateSample.specIdNameArray, "BulkCreateSample.setMeasurementSet(\'" + currentRow.id + "\', this.options[this.selectedIndex].value)");    
				}else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML=='sampleTypeHierarchy'){
					currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "sampleTypeHierarchy", BulkCreateSample.sampleTypeArray, BulkCreateSample.sampleTypeNameArray, "BulkCreateSample.setSampleType(\'" + currentRow.id + "\', this.options[this.selectedIndex].value)");    
			}else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML=='measurementSet'){
				currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "measurementSet", new Array(), new Array(), "BulkCreateSample.setSize(\'" + currentRow.id + "\', this.options[this.selectedIndex].value)");    
			}else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML=='testSpecification'){
				currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "testSpecification", new Array(), new Array(), "");    
			}
				/**
				 * Target Point Build: 005.13
				 * Description : Add BlankdropDownList in the Beginning for Event Type.
				 * @author Bineeta
				 * Modified On: 19-Feb-2013
				 */
				//ITC - START
				else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML == '<%=EVENTTYPEKEY%>'){
					currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "<%=EVENTTYPEKEY%>", BulkCreateSample.eventTypeKeyArray, BulkCreateSample.eventTypeValueArray , "");    
				}
				//ITC - END
				
				/**
				 * Target Point Build: 006.4
				 * Description : Add BlankdropDownList in the Beginning for Sample Type.
				 * @author LFUSA
				 * Modified On: 17-Sept-2014
				 */
				//ITC - START
				else if(currentRow.childNodes[w].innerHTML != null && currentRow.childNodes[w].innerHTML == '<%=SAMPLETYPEKEY%>'){
					currentRow.childNodes[w].innerHTML= BulkCreateSample.getCellSource("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id, "<%=SAMPLETYPEKEY%>", BulkCreateSample.sampleTypeKeyLFArray, BulkCreateSample.sampleTypeValueLFArray , "");    
				}
				//ITC - END
				
				/* Start of Season Requested on Sample Requeste page Issue #550*/        
				var seasonSelect = $("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id + "_" + '<%=SAMPLEREQSEASONKEY%>');
				//alert(" seasonSelect : " + seasonSelect);
				seasonSelect.disabled = true;
				var seasonDisplay = $("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id + "_"+'<%=SAMPLEREQSEASONKEY%>' + "Display");
				//alert(" seasonDisplay : " + seasonDisplay);
				seasonDisplay.disabled = true;
				var seasonLink = $("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id + "_" + '<%=SAMPLEREQSEASONKEY%>');
				//alert(" seasonLink : " + seasonLink);
				seasonLink.disabled = true;
				window.open=false;

				if(seasonDisplay.innerHTML.indexOf("showTypeAheadChooser")> -1){
					var value= '<%= appcontextseasonID%>';
					var seasonDisplayVal = seasonDisplay.innerHTML;
					

					if(value=='0'){
						seasonDisplayVal = seasonDisplayVal.substring(0, seasonDisplayVal.indexOf(">")+1);
						//alert('if seasonDisplayVal'+seasonDisplayVal);
						seasonDisplayVal = seasonDisplayVal + '------</a>';
					}else{
						seasonDisplayVal = seasonDisplayVal.substring(0, seasonDisplayVal.indexOf("showTypeAheadChooser")+1);
						//alert('else seasonDisplayVal'+seasonDisplayVal);
						seasonDisplayVal = seasonDisplayVal +'howTypeAheadChooser(null, '+'null'+','+'null'+','+'null'+','+'null'+')'+'">'+'<%= seasonNameTemp%>' + '</a>';
					}
					seasonDisplay.innerHTML = seasonDisplayVal;
					seasonSelect.value = value;
					
					var displayElement = document.getElementById("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id + "_" + '<%=SAMPLEREQSEASONKEY%>' +"Display");
					//alert('displayElement'+displayElement);

				}

				/* End of Season Requested on Sample Requeste page Issue #550*/ 

			}
			h++;

			<%if(appContext.getSpecification()!=null){%>
				
				var specSelect = $("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id + "_specReference_ForCreation");
				var selectedSpec = getKeyIndex(specSelect, '<%=FormatHelper.getVersionId(appContext.getSpecification())%>');
				specSelect.selectedIndex = selectedSpec;
				BulkCreateSample.setMeasurementSet(currentRow.id, '<%=FormatHelper.getVersionId(appContext.getSpecification())%>');

		<%}%>

		<%if(appContext.getSKUARev()!=null){%>
			var skuSelect = $("M_F_" + currentRow.id + "_LCSSAMPLEREQUEST$" + currentRow.id + "_colorwayReference_ForCreation");
			var selectedSku = getKeyIndex(skuSelect, '<%=FormatHelper.getVersionId(appContext.getSKUARev())%>');
			skuSelect.selectedIndex = selectedSku;
		<%}%>
	
	}
}

toggleDiv("tableName");
toggleDiv("activityName");


BulkCreateSample.requiredAttArray['name'] = '<%=FormatHelper.formatJavascriptString(productSampleRootType.getAttribute("requestName").getAttDisplay(), false)%>';
BulkCreateSample.requiredAttArray['specReference_ForCreation'] = '<%=FormatHelper.formatJavascriptString(specificationLabel, false)%>';
BulkCreateSample.requiredAttArray['sampleType_ForCreation'] = '<%=FormatHelper.formatJavascriptString(typeLabel, false)%>';
<%if(MEASUREMENT_SIZE_REQUIRED){%>
BulkCreateSample.requiredAttArray['measurementSet_ForCreation'] = '<%=FormatHelper.formatJavascriptString(measurementSetLabel, false)%>';
BulkCreateSample.requiredAttArray['size_ForCreation'] = '<%=FormatHelper.formatJavascriptString(sampleSizeLabel, false)%>';
<%}%>
BulkCreateSample.requiredAttArray['testSpecification_ForCreation'] = '<%=FormatHelper.formatJavascriptString(testingLibraryHeaderSpecificationsLbl, false)%>';

<%
   Iterator attIterator = productSampleRootType.getAllAttributes(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE, null).iterator();
   FlexTypeAttribute attribute;
   while(attIterator.hasNext()){
	  attribute = (FlexTypeAttribute)attIterator.next();
	  if(attribute.isAttRequired()){
  		  if("date".equals(attribute.getAttVariableType())){
   %>
			BulkCreateSample.requiredAttArray['<%=attribute.getAttKey()%>DateString'] = '<%=FormatHelper.formatJavascriptString(attribute.getAttDisplay(), false)%>';
   <%
		  }else{
   %>
	 			BulkCreateSample.requiredAttArray['<%=attribute.getAttKey()%>'] = '<%=FormatHelper.formatJavascriptString(attribute.getAttDisplay(), false)%>';

		<%}
	  }
   }

%>

</script>

<%
}
%>