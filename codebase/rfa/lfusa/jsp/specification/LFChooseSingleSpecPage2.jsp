<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="com.lcs.wc.client.Activities,
                com.lcs.wc.client.web.*,
                com.lcs.wc.client.ClientContext,
                com.lcs.wc.util.*,
                com.lcs.wc.db.*,
                com.lcs.wc.flextype.*,
                com.lcs.wc.season.*,
                com.lcs.wc.changeAudit.ChangeTrackingPageHelper,
                com.lcs.wc.color.*,
                com.lcs.wc.construction.*,
                com.lcs.wc.document.*,
                com.lcs.wc.measurements.*,
                com.lcs.wc.epmstruct.*,
                com.lcs.wc.partstruct.*,
                com.lcs.wc.product.*,
				com.lcs.wc.sizing.*,
				com.lcs.wc.specification.*,
				com.lcs.wc.sourcing.*,
				com.lcs.wc.flexbom.*,
				com.lcs.wc.report.*,
				com.lcs.wc.foundation.LCSQuery,
				com.lcs.wc.sample.LCSSampleQuery,
				com.lcs.wc.sample.LCSSampleRequest,
				com.lcs.wc.sample.LCSSample,
				com.lcs.wc.specification.*,
                wt.part.WTPartMaster,
                wt.part.WTPart,
                wt.ownership.*,
                wt.fc.*,
                wt.util.*,
                wt.epm.*,
                wt.identity.IdentityFactory,
                wt.locks.LockHelper,
			    wt.org.*,
                java.text.*,
				com.lcs.wc.util.LCSLog,
				com.lcs.wc.measurements.*,
                java.util.*"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="type" scope="request" class="com.lcs.wc.flextype.FlexType" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="flexg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<% lcsContext.setLocale(request.getLocale());%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%!
    public static final String JSPNAME = "ChooseSingleSpecPage";
	public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
	boolean size2exists = false;
    public static final String TYPE_COMP_DELIM = PDFProductSpecificationGenerator2.TYPE_COMP_DELIM;
	public static final String BOM_IDENTIFIER = "BOM:  ";
	public static final String MEASUREMENTS_IDENTIFIER = "Measurements:  ";
    public static final String TRACKED_CHANGES_IDENTIFIER = "Tracked Changes:  ";
    public static final String CADDOC_VARIATIONS_IDENTIFIER = "CAD Document Variations:  ";
    public static final String PART_VARIATIONS_IDENTIFIER = "Part Variations:  ";
    public static final String SPEC_REQUESTS = LCSProperties.get("jsp.specification.ChooseSingleSpecPage2.specRequests");
	public static final String DEFAULT_ALL_COLORWAYS_CHECKED = LCSProperties.get("jsp.specification.ChooseSingleSpecPage2.defaultAllColorwaysChecked","true");
	public static final String DEFAULT_ALL_SIZES_CHECKED = LCSProperties.get("jsp.specification.ChooseSingleSpecPage2.defaultAllSizesChecked","false");
	public static final String DEFAULT_ALL_DESTINATIONS_CHECKED = LCSProperties.get("jsp.specification.ChooseSingleSpecPage2.defaultAllDestinationsChecked","false");
	public static final String DEFAULT_CHILD_SPECS_CHECKED = LCSProperties.get("jsp.specification.ChooseSingleSpecPage2.defaultChildSpecsChecked","false");
	public static final String DEFAULT_CHILD_DOCS_CHECKED = LCSProperties.get("jsp.specification.ChooseSingleSpecPage2.defaultChildDocsChecked","false");
	public static final String DEFAULT_DOCUMENT_VAULT_TYPE = LCSProperties.get("com.lcs.wc.document.documentVault.document.flexType");
	public static final boolean DEFAULT_ASYNC_SINGLE_TPGENERATION = LCSProperties.getBoolean("com.lcs.wc.specification.SingleTPGenAsyncService.defaultSelected");
	public static final boolean CADDOC_ENABLED = LCSProperties.getBoolean("com.lcs.wc.specification.cadData.Enabled");
	public static final boolean PART_ENABLED = LCSProperties.getBoolean("com.lcs.wc.specification.parts.Enabled");
    static final String ENCODING = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    static final String defaultUnitOfMeasure = LCSProperties.get("com.lcs.measurements.defaultUnitOfMeasure", "si.Length.in");
    public static String baseUOM = "";
    public static String instance = "";
    public static String cadDoc = "";
    public static final Collection<String> UOMs = new ArrayList<String>();
    //add for story B-58112 03/28/2011
    public static final boolean INCLUDED_TRACKED_CHANGES = LCSProperties.getBoolean("jsp.specification.ChooseSingleSpecPage2.includedTrackedChanges");
    public static final String showChangeSinceDefault = LCSProperties.get("flexPLM.header.showChangeSince.default","days1");
    public static final String CLEAR_CELL_VALUE = LCSProperties.get("com.lcs.wc.LCSLogic.ClearCellValue", "!CLR");
   	
	public static final boolean DEBUG;
	static {
		DEBUG = LCSProperties
				.getBoolean("rfa.lfusa.jsp.specification.LFChooseSingleSpecPage2.verbose");
	}
	
    static {
        try {
            instance = WTProperties.getLocalProperties().getProperty ("wt.federation.ie.VMName");
            Map<?,?> allUOMS = UomConversionCache.getAllUomKeys();
            HashMap<?,?> inputUnit = (HashMap<?,?>)allUOMS.get(defaultUnitOfMeasure);
            baseUOM = (String)inputUnit.get("prompt");
           
        } catch(Exception e){
            e.printStackTrace();
        }
        UOMs.add("si.Length.in");
        UOMs.add("si.Length.cm");
        UOMs.add("si.Length.ft");
        UOMs.add("si.Length.m");
    }



    public static String drawCheckBox(String name, String value, String label, boolean checked){
        StringBuffer buffer = new StringBuffer();
		if(FormatHelper.hasContentAllowZero(label)){
			buffer.append("<td class=\"FORMLABEL\">" + label + "&nbsp;&nbsp; </td>");
		}
        buffer.append("<td>");
		buffer.append("<input class=\"TABLEFORMELEMENT\" ");
        buffer.append("type=\"checkbox\" ");
        buffer.append("name=\"" + name + "\" ");
        buffer.append("value=\"" + FormatHelper.format(value) + "\" ");
        if(checked){
             buffer.append(" checked ");
        }
        buffer.append(">");
        buffer.append("<br>");
		buffer.append("</td>"); 
        return buffer.toString();
    }


	public static void addComponentToMaps(Map<Object,Object> cmap, Map<Object,String> nMap, FlexObject component){
		String ctype = component.getString("COMPONENT_TYPE_UNTRANSLATED");
		nMap.put(component.get("OID"), component.getString("NAME"));
		
		Collection<String> objs = (Collection<String>)cmap.get(ctype);
		
		if(objs == null){
			objs = new ArrayList<String>();
		}
		
		objs.add(component.getString("OID"));
		cmap.put(ctype, objs);
	}
	
	
	public static Collection sortComponents(Collection components, java.util.Locale locale) {
		
		FlexObject fo = null;
		String compName;
		List<String> keyList = new ArrayList<String>();
		Map<String, FlexObject> foMap = new HashMap<String, FlexObject>();
		Iterator<?> componentsIter = components.iterator();
		
		while(componentsIter.hasNext()){
			fo = (FlexObject) componentsIter.next();
			compName = fo.getData("NAME");
			String compType = fo.getData("COMPONENT_TYPE");
			compName =  compType + " " + compName;
			keyList.add(compName);
			foMap.put(compName, fo);
		}
		
		Collection<String> sortedKeys = SortHelper.sortStrings(keyList, locale);		
		Iterator<String> keysIter = sortedKeys.iterator();
		Collection<FlexObject> sortedComponents = new ArrayList<FlexObject>();
		while(keysIter.hasNext()){
			sortedComponents.add(foMap.get(keysIter.next()));
		}
		
		return sortedComponents;		
	}
	
%>
<%
   String errorMessage = request.getParameter("errorMessage");

  

   String returnMethod = request.getParameter("returnMethod");
   String returnId = request.getParameter("returnId");
   appContext.setProductContext(returnId);
   String componentId = request.getParameter("componentId");

   //If we have passed a single component, we will not display all options 
   boolean allComponents = !FormatHelper.hasContent(componentId);
   boolean isBOMComponent = !allComponents && (componentId.indexOf("com.lcs.wc.flexbom.FlexBOMPart:")> -1);
   boolean isMeasureComponent = !allComponents && (componentId.indexOf("com.lcs.wc.measurements.LCSMeasurements:")> -1);

   //If we don't have a source selected, display a dropdown list of sources
   boolean needSource = !allComponents;
  



   String availableComponentsLabel = WTMessage.getLocalizedMessage (RB.SPECIFICATION, "availableComponents_LBL", RB.objA) ;
   String sampleRequestNameLabel = "Sample Request Name";
   String sampleRequestHeaderLabel = "Sample Request ";	
   String selectButton         = WTMessage.getLocalizedMessage ( RB.MAIN, "select_Btn", RB.objA ) ;
   String pageTitle            = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "createPDFSpec_PG_TLE", RB.objA ) ;
   String variationOptionsGrpTle = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "variationOptions_GRP_TLE", RB.objA ) ;
   String sourceLabel          = WTMessage.getLocalizedMessage ( RB.SEASON, "source_LBL", RB.objA ) ;//Source
   String colorwaysLabel	   = WTMessage.getLocalizedMessage ( RB.FLEXBOM, "colorwaysLabel", RB.objA ) ;
   String sizesLabel		   = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "sizes_LBL", RB.objA ) ;
   String destinationsLabel   = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "destinations_LBL", RB.objA ) ;
   String allLabel			   = WTMessage.getLocalizedMessage (RB.MAIN, "all_LBL", RB.objA ) ;
   String specComponentsLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "specComponents_LBL", RB.objA ) ;
   String includeChildSpecifications = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "includeChildSpecifications_LBL", RB.objA ) ;
   String moveUpLabel		   = WTMessage.getLocalizedMessage (RB.MAIN, "moveUp_LBL", RB.objA ) ;
   String moveDownLabel	   = WTMessage.getLocalizedMessage (RB.MAIN, "moveDown_LBL", RB.objA ) ;
   String pageOptionsGrpTle	   = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "pageOptionsAndReports_GRP_TLE", RB.objA ) ;
   String pageOptionsLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "pageOptions_LBL", RB.objA ) ;
   String specRequestLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "specRequest", RB.objA ) ;
   String numberColorwaysPerPageLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "numColorwaysPerPage_LBL", RB.objA ) ;
   String numberSizesPerPageLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "numSizesPerPage_LBL", RB.objA ) ;
   String availableReportsLabel  = WTMessage.getLocalizedMessage (RB.SPECIFICATION, "availableReports_LBL", RB.objA ) ;
   String viewOptionsLabel	   = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "viewOptions_LBL", RB.objA ) ;
   String showColorSwatchesLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "showColorSwatches_LBL", RB.objA ) ;
   String showMaterialThumbnailsLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "showMaterialThumbnails_LBL", RB.objA ) ;
   String fractionLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "fraction_LBL",RB.objA ) ;
   String measurementUOMOverrideLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "measurementUOMOverride_LBL",RB.objA ) ;
   String availableDocumentsLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "availDocs_LBL", RB.objA ) ;
   String availDescDocsLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "availDescDocs_LBL", RB.objA ) ;
   String vaultDocumentsLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "vaultDocuments_LBL", RB.objA ) ;
   String vaultDocumentTypeLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "vaultDocumentType_LBL", RB.objA ) ;
   String includeSecondaryLabel = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "includeSecondary_LBL", RB.objA );
   String asynchGenLabel = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "asynchGen_LBL", RB.objA );
   String trackedChangesLabel = WTMessage.getLocalizedMessage ( RB.CHANGE, "trackedChanges_LBL", RB.objA ) ;
   String showChangeSinceLabel = WTMessage.getLocalizedMessage( RB.EVENTS, "showChangeSince_lbl", RB.objA);
   String expandedTrackedChangesLabel = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "expandedTrackedChanges_LBL", RB.objA );
   String condensedTrackedChangesLabel = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "condensedTrackedChanges_LBL", RB.objA );
   String cadDocVariationsLabel = WTMessage.getLocalizedMessage( RB.EPMSTRUCT, "cadDocVariations_LBL", RB.objA );
   String partVariationsLabel = WTMessage.getLocalizedMessage( RB.PARTSTRUCT, "partVariations_LBL", RB.objA );
   String availableCADDocGrpHdr = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "availableCADDoc_GRPHDR", RB.objA );
   String availableCADDocLbl    = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "availableCADDoc_LBL", RB.objA );
   String cadDocFilterLabel     = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "cadDocFilter_LBL", RB.objA );
   String availablePartGrpHdr = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "availablePart_GRPHDR", RB.objA );
   String availablePartLbl    = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "availablePart_LBL", RB.objA );
   String partFilterLabel     = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "partFilter_LBL", RB.objA );
   String showIndentedBOMLabel = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "exportedIndentedBOM_LBL", RB.objA );
   String partDataOptionsLabel = WTMessage.getLocalizedMessage( RB.SPECIFICATION, "partDataOptions_LBL", RB.objA );
   
   String tabPage = request.getParameter("tabPage");
   FlexType defaultDocumentVaultType = FlexTypeCache.getFlexTypeFromPath(DEFAULT_DOCUMENT_VAULT_TYPE);
   //add for story B-58112 03/28/2011
   /*************Changes for Issue 219, 268 **********/
   String baseUOMUnitLabel = WTMessage.getLocalizedMessage ( RB.UOMRENDERER, defaultUnitOfMeasure,RB.objA ) ;
   /**************************************************/
   
   Vector<String> daysOrder = ChangeTrackingPageHelper.getChangeEventDaysDisplayOrders(lcsContext.getLocale()); 
   Map<String,String> daysDisplayMap = ChangeTrackingPageHelper.getChangeEventDaysDisplayMap(lcsContext.getLocale());
   Map<String,String> daysMap = ChangeTrackingPageHelper.getChangeEventDaysMap(lcsContext.getLocale());
   String jsCalendarFormat = WTMessage.getLocalizedMessage( RB.DATETIMEFORMAT, "jsCalendarFormat", RB.objA);
   RequestParamHolder daysHolder = new RequestParamHolder(daysMap);
   
   //Taking the values from the properties file and create map 
   // of the report types to select from.
   
   Vector bomOptions = new Vector(new ClassLoadUtil(FileLocation.productSpecBOMProperties2).getKeyList());
   Collections.sort(bomOptions);
   Vector measurementOptions = new Vector(new ClassLoadUtil(FileLocation.productSpecMeasureProperties2).getKeyList());
   Collections.sort(measurementOptions);

   Map allOptions = new HashMap();

   Map<?,?> bomOptionsMap = FormatHelper.toMap(bomOptions, RB.FLEXBOM);
   Map<?,?> measurementOptionsMap = FormatHelper.toMap(measurementOptions, RB.MEASUREMENTS);

   Iterator<?> measKeysItr = measurementOptions.iterator();
   Iterator<?> bomKeyItr = bomOptions.iterator();

   if(allComponents || isMeasureComponent) {
     String dkey = "";
     while(measKeysItr.hasNext())
     {
         dkey = (String)measKeysItr.next();
         allOptions.put(MEASUREMENTS_IDENTIFIER + dkey, measurementOptionsMap.get(dkey));
		 allOptions.put("LFFitSpecReport","Fit Spec Report");

     }
   }
	
	/**
	*	Build 6.10 - START
	*	Removed if condition as it was not necessary. 
	*	Requirement is to allow user to add Tech Pack Comment Page in all the conditions
	*/
	allOptions.put("LFTechPackComments","Tech pack Comments");
	/**
	*	Build 6.10 - END
	*/

   if(allComponents || isBOMComponent) {
	 String dkey = "";
     while(bomKeyItr.hasNext())
     {
         dkey = (String)bomKeyItr.next();
         allOptions.put(BOM_IDENTIFIER + dkey, bomOptionsMap.get(dkey));
    }
  }
   //add for story B-58112 03/28/2011
   if (allComponents && INCLUDED_TRACKED_CHANGES) {
   	   allOptions.put(TRACKED_CHANGES_IDENTIFIER + ChangeTrackingPDFGenerator.EXPANDED_REPORT, expandedTrackedChangesLabel);
   	   allOptions.put(TRACKED_CHANGES_IDENTIFIER + ChangeTrackingPDFGenerator.CONDENSED_REPORT, condensedTrackedChangesLabel);
   }
		
   if (allComponents && CADDOC_ENABLED) {
   	   allOptions.put(CADDOC_VARIATIONS_IDENTIFIER + PDFCadDocVariationsGenerator.VARIATIONS_REPORT, cadDocVariationsLabel);
   }
   
   
   if (allComponents && PART_ENABLED) {
   	   allOptions.put(PART_VARIATIONS_IDENTIFIER + PDFPartVariationsGenerator.VARIATIONS_REPORT, partVariationsLabel);
   }
		

   Collection<String> specRequests = SingleSpecPageUtil.getSpecRequests();

   Map specRequestsMap = FormatHelper.toMap(specRequests, RB.SPECIFICATION);

   FlexSpecification currentSpec;
   LCSProduct product = appContext.getProductARev(); 
   if(FormatHelper.hasContent(returnId) && (returnId.indexOf("com.lcs.wc.specification.FlexSpecification") > -1)){
	  currentSpec = (FlexSpecification)LCSQuery.findObjectById(returnId);
   } else {
	  currentSpec = (FlexSpecification)appContext.getSpecification();
   }
   
   
   
   /*
      use the method above to get all the associated CAD documents with spec, currently , I only hard coded for 
      demo, the save filters map returned as the <name,name>  since the name is unique for filters. we do not use filter id in here. 
      
   */

   // get filter to pass into helper method
   Map<String,String> specLinks = new HashMap<String,String>();
   List<String> cadDocsList = new ArrayList<String>();
   // Find associated caddocs and build MOA string to pass into helper method
   try {
   	if (currentSpec != null) {
          Collection<FlexObject> epmDocs = new LCSEPMDocumentQuery().findAssociatedEPMDocumentsByCriteria(currentSpec, new HashMap<String,String>());
          for (FlexObject flexObject : epmDocs) { 
            cadDocsList.add("VR:wt.epm.EPMDocument:"+flexObject.getString("FLEXEPMDOCTOSPECLINK.BRANCHIDA3B5"));
       	    specLinks.put("OR:com.lcs.wc.epmstruct.FlexEPMDocToSpecLink:"+flexObject.getString("FLEXEPMDOCTOSPECLINK.IDA2A2"), flexObject.getString("EPMDOCUMENTMASTER.NAME"));
	  }
	}
   } catch(Exception e){
       e.printStackTrace();
   }
   /* B-92545
   Map<String,String> saveFilters=FlexSpecHelper.getSaveFiltersForTechPack(cadDocsList);
   */
   // This is only for parts , to retrieve the parts info 
   Map<String,String> partTOSpecLinks = new HashMap<String,String>();
   List<String> partsList = new ArrayList<String>();
   // Find associated parts and build MOA string to pass into helper method
   try {
   	if (currentSpec != null) {
            
   	    Collection<FlexObject> parts = new FlexPartToSpecLinkQuery().findAssociatedPartsByCriteria(currentSpec, new HashMap<String,String>());
		Collection<WTPart> wtParts = LCSQuery.getObjectsFromResults(parts, "VR:wt.part.WTPart:",  "WTPART.BRANCHIDITERATIONINFO");		
  		//putting iteration display indentifier of WtPart into HashMap by key branch identifier of WtPart
  		HashMap  tempMap = new HashMap();		 
  		for(WTPart wtPart:wtParts) {
  			tempMap.put(wtPart.getBranchIdentifier(),  IdentityFactory.getDisplayIdentifier(wtPart).getLocalizedMessage(WTContext.getContext().getLocale()).toString());
  		} 
		for (FlexObject flexObject : parts) {
        	partsList.add("VR:wt.part.WTPart:"+flexObject.getString("FLEXPARTTOSPECLINK.BRANCHIDA3B5"));
        	partTOSpecLinks.put("OR:com.lcs.wc.partstruct.FlexPartToSpecLink:"+flexObject.getString("FLEXPARTTOSPECLINK.IDA2A2"), ""+tempMap.get(Long.valueOf(flexObject.get("WTPART.BRANCHIDITERATIONINFO").toString())));
	  }
	}
   } catch(Exception e){
       e.printStackTrace();
   }
   
   Map<String,String> savePartFilters=new FlexSpecUtil().getSaveFiltersForTechPack(partsList);
   
   FlexSpecQuery q;
   Collection<?> components = new ArrayList<Object>();
   Map<Object,Object> compMap = new HashMap<Object,Object>();
   Map<Object,String> nameMap = new HashMap<Object,String>();
   Map<String,String> listOfComp = new HashMap<String,String>();
   // for displaying the sample request table
   Map<String,String> listOfSamples = new HashMap<String,String>();
   Map<String,String> listOfDocs = new HashMap<String,String>();
   Map<String,String> listOfDescDocs = new HashMap<String,String>();
   Map<String,String> childDocs = new HashMap<String,String>();
   Map<String,String> childDescDocs = new HashMap<String,String>();
   Collection<String> parentComponents = new ArrayList<String>();
   Map<String,String> childListOfComp = new HashMap<String,String>();
   String componentSelectedValues ="";
   String sampleReqSelectedValues ="";
   String docContentSelectValue = "";
   String docContentSelectValue1 = "";
   Collection<FlexType> bomTypes = new ArrayList<FlexType>();
   FlexObject compfo = null;
   FlexBOMPart tbom;
   String compName;
   String compOid;
   String compType1;
   String compType2;
   String compId;
   LCSProduct prodB = appContext.getProductSeasonRev();
   ZipGenerator gen = new ZipGenerator();
   gen.addDocumentsToMap(product, listOfDocs, listOfDescDocs);
   gen.addDocumentsToMap(prodB, listOfDocs, listOfDescDocs);
   Iterator<?> skus = LCSSKUQuery.findSKUs(product).iterator();
   LCSSKU colorway = null;
   LCSSampleRequest sampleReq = null; 
   String sampleReqName;
   String sampleName;
   LCSDocument ldoc=null;
   String strPageType="";
   while (skus.hasNext()) {
       colorway = (LCSSKU)skus.next();
       gen.addDocumentsToMap(colorway, listOfDocs, listOfDescDocs);
   }
   if (prodB != null) {
       skus = LCSSKUQuery.findSKUs(prodB).iterator();
       while (skus.hasNext()) {
           colorway = (LCSSKU)skus.next();
           gen.addDocumentsToMap(colorway, listOfDocs, listOfDescDocs);
       }
   }
   gen.addDocumentsToMap(currentSpec, listOfDocs, listOfDescDocs);
   //new LCSProductQuery().getLinkedProducts(prodMaster, asParent, asChild)
 
   if(allComponents) {
	  if(currentSpec != null) {
		 components = FlexSpecQuery.getSpecToComponentObjectsData(currentSpec, false);
	  } else {
	     components= FlexSpecQuery.getComponentReport(product, appContext.getSourcingConfig(), appContext.getSpecification(), null);
	  }
	  components = sortComponents(components, lcsContext.getLocale());

	// Fetch sample request data Start
	  String sampleTypePrefix="Sample";
	  java.util.Hashtable criteria=new java.util.Hashtable();
	  LCSSampleQuery sampQuery=new LCSSampleQuery();
	  FlexType sampleFlexType = FlexTypeCache.getFlexTypeFromPath("Sample\\Product\\Product Sample");
	  //System.out.println("sampleFlexType================"+sampleFlexType);
	  Collection samples=sampQuery.findSamplesForProduct(product,criteria,appContext.getSourcingConfig().getFlexType(),appContext.getSourcingConfig(),sampleFlexType,appContext.getSpecification()).getResults();	

	  //System.out.println("Samples size()------- " + samples.size());
	   Iterator samplesIter = samples.iterator();

	   FlexObject sample;

       while(samplesIter.hasNext()) 
	   {
		   sample = (FlexObject) samplesIter.next();
		   if(!samples.isEmpty())
		   {
				String sampleID=(String)sample.getString("LCSSAMPLE.IDA2A2");   
				LCSSample sampleObject = (LCSSample)LCSQuery.findObjectById("OR:com.lcs.wc.sample.LCSSample:"+sampleID);
				//System.out.println("sampleObject========== >>>> "+sampleObject);
				if(!(sampleObject.getFlexType().getFullNameDisplay().contains("Product Sample")))
				{
				   //System.out.println("continue ========== >>>> "+sampleObject.getFlexType().getFullNameDisplay());
				   continue;
				}
						
				sampleReq = sampleObject.getSampleRequest();
				sampleReqName=(String)sampleReq.getName();
				
				sampleName=(String)sampleObject.getValue("name");
				String sampleWithRequestName =  sampleReqName +  " " + sampleName;
				//System.out.println("sampleReqName========== >>>> "+sampleReqName);

				String sampleOid = "OR:"+sampleObject;
				String sampId = sampleTypePrefix + TYPE_COMP_DELIM + sampleOid ;

				//System.out.println("sampId========== >>>> "+sampId);
				//System.out.println("sampleReqSelectedValues========== >>>> "+sampleReqSelectedValues);
				listOfSamples.put(sampId, sampleWithRequestName);
		   }
	   }
	   	//System.out.println("listOfSamples========== >>>> "+listOfSamples);
	   // Custom code for fetching sample request data End
	  
	  Iterator<?> compI = components.iterator();
	  while(compI.hasNext()){
		 compfo = (FlexObject)compI.next();
 		 compOid = compfo.getString("OID");
		 if(!FormatHelper.hasContent(compOid)){
			compOid = compfo.getString("COMPONENTCLASS") +compfo.getString("COMPONENTID");
			compfo.put("OID",compOid);
		 }
		 //Create component map for javascript map
		 compType1 = compfo.getData("COMPONENT_TYPE");
		 if(!FormatHelper.hasContent(compType1)) {
			compType1 = compfo.getData("COMPONENTTYPE");
		 }
		 compType2 = compfo.getData("COMPONENT_TYPE_UNTRANSLATED");
		 if(!FormatHelper.hasContent(compType2)) {
			compType2 = compfo.getData("COMPONENTTYPE");
			compfo.put("COMPONENT_TYPE_UNTRANSLATED",compType2);
		 }
		 compName =  compfo.getData("NAME");
		 if(!FormatHelper.hasContent(compName)){
			compName =  compfo.getData("COMPONENTNAME");
			compfo.put("NAME",compName);
		 }

		 compId = compType2 + TYPE_COMP_DELIM + compOid ;
         parentComponents.add(compId);
		 //Create map for component multi choice widget
            compName =  compType1 + " " + compName;


		 addComponentToMaps(compMap, nameMap, compfo);
		 //If component is a BOM, add the bom.getType() to a Collection for the BOM view options
		 if("BOM".equalsIgnoreCase(compType2) || "BOL".equalsIgnoreCase(compType2)) {
			tbom = (FlexBOMPart)LCSQuery.findObjectById(compOid );
			if(!bomTypes.contains(tbom.getFlexType())) {
			   bomTypes.add(tbom.getFlexType() );
			}
		 }
		 
		 if("Images Page".equalsIgnoreCase(compType2)) {
			ldoc = (LCSDocument)LCSQuery.findObjectById(compOid );
			//System.out.println("ldoc name in jsp is *********"+ldoc);
			if(ldoc !=null){
			strPageType=(String)ldoc.getValue("pageType");
			//System.out.println("strPageType name in jsp is *********"+strPageType);
			}
		 }
		 //System.out.println("component name in jsp is *********"+compName);
		 //System.out.println("compType2 name in jsp is *********"+compType2);
		 if(!(strPageType.equalsIgnoreCase("coverPage") && compType2.equalsIgnoreCase("Images Page"))){
		 listOfComp.put(compId, compName);
		 }
	  }

      if(currentSpec == null){
            currentSpec = appContext.getSpecification();
      }
      Collection<?> childSpecComps = FlexSpecQuery.getChildSpecComponents(currentSpec, false);
      Collection<?> children = FlexSpecQuery.findSpecToSpecLinks(currentSpec);
      gen.addLinkedProdDocs(product, childDocs, childDescDocs);
      if(childSpecComps == null || childSpecComps.isEmpty()){
        if(DEBUG)
			LCSLog.debug("\n\n\nDidn't find any child spec components");
      } else{
        Iterator<?> it = childSpecComps.iterator();
        if(DEBUG)
			LCSLog.debug("\n\n--------------\nChild Spec components");
        while(it.hasNext()){
             compfo = (FlexObject)it.next();
             if(DEBUG)
				LCSLog.debug("compfo:  " + compfo);
             compOid = compfo.getString("OID");

             //Create component map for javascript map
             compType1 = compfo.getData("COMPONENT_TYPE");

             compType2 = compfo.getData("COMPONENT_TYPE_UNTRANSLATED");

             compName =  compfo.getData("NAME");

             //Create map for component multi choice widget
             compName = compType1 + " (" + compfo.getString("PRODUCT_NAME") + ") - " + compName;

             compId = compType2 + TYPE_COMP_DELIM + compOid ;

             if(parentComponents.contains(compId)){
                //If the parent spec has this component, do nothing
                if(DEBUG)
					LCSLog.debug("//If the parent spec has this component, do nothing");
                continue;
             }
             if(DEBUG)
				LCSLog.debug("compOid:  " + compOid);
             if(nameMap.containsKey(compOid)){
                String tempName = (String)nameMap.get(compOid);
                if(DEBUG)
					LCSLog.debug("if(nameMap.containsKey(compOid))" + tempName);
                if(FormatHelper.hasContent(tempName) && tempName.indexOf(compfo.getString("PRODUCT_NAME")) == -1){
                    if(DEBUG)
						LCSLog.debug("if(FormatHelper.hasContent(tempName) && tempName.indexOf(compfo.getString(PRODUCT_NAME)) == -1)");
                    compName = tempName.substring(0, tempName.indexOf(") -") ) + ", " + compfo.getString("PRODUCT_NAME") +  tempName.substring(tempName.indexOf(") -"));
                }
             } else {
                 
                 //If component is a BOM, add the bom.getType() to a Collection for the BOM view options
                 if("BOM".equalsIgnoreCase(compType2) ||"BOL".equalsIgnoreCase(compType2)) {
                    tbom = (FlexBOMPart)LCSQuery.findObjectById(compOid );
                    if(!bomTypes.contains(tbom.getFlexType())) {
                       bomTypes.add(tbom.getFlexType() );
                    }
                 }
             }
             compfo.put("NAME", compName);
             addComponentToMaps(compMap, nameMap, compfo);
             childListOfComp.put(compId,compName);

        }
      }

      for (Iterator<?> it = children.iterator(); it.hasNext();) {
          FlexObject fo = (FlexObject)it.next();
          compOid = fo.getData("FLEXSPECIFICATION.IDA2A2");
          gen.addDocumentsToMap(compOid, childDocs);
          compOid = fo.getData("FLEXSPECIFICATION.IDA3MASTERREFERENCE");
          gen.addSpecDescDocsToMap(compOid, childDescDocs);
      }
  }else {
      compType1 = "";
      compType2 = "";
      compName = "";
      compOid = "";
   //If we only have one component do everything manually
      WTObject wo = (WTObject)LCSQuery.findObjectById(componentId);
	  compOid = componentId;
	  if(wo instanceof FlexBOMPart){
		 tbom = (FlexBOMPart)wo;
		 compName = tbom.getName();
		 if(!("LABOR".equals(tbom.getBomType())) ){
			compType1 = WTMessage.getLocalizedMessage ( RB.FLEXBOM, "BOM_short", RB.objA ) ;
			compType2= "BOM";
		 }else {
			compType1 = WTMessage.getLocalizedMessage ( RB.FLEXBOM, "BOL_short", RB.objA ) ;
			compType2= "BOL";
		 }
	     bomTypes.add(tbom.getFlexType() );

	  }else if(wo instanceof LCSMeasurements){
		 LCSMeasurements me = (LCSMeasurements)wo;
		 compName = me.getMeasurementsName();
		 compType1 = me.getFlexType().getRootType().getTypeDisplayName();
		 compType2 = "Measurements";

	  }else if(wo instanceof LCSConstructionInfo){ 
		 LCSConstructionInfo ci = (LCSConstructionInfo)wo;
		 compName = ci.getConstructionInfoName();
		 compType1 = ci.getFlexType().getRootType().getTypeDisplayName();
		 compType2 ="Construction";

	  }else if(wo instanceof LCSDocument){
		 LCSDocument doc = (LCSDocument)wo;
		 compName = doc.getName();
		 compType1 = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "impComponent_LBL", RB.objA ) ;
		 compType2 = "Images Page";
	  }
	  //Since there is only one component, select it by default.
	  compName =  compType1 + " " + compName;
	  compId = compType2 + TYPE_COMP_DELIM + compOid ;
	  componentSelectedValues = compId;

	  listOfComp.put(compId,compName);
    }



	Map<String,String> formats = new HashMap<String,String>();
	formats.put("none", " ");

	/************* Changes for issue 219,268 *********************/

	//Name change from Fractional inch to Fractional in
	formats.put(FormatHelper.FRACTION_FORMAT, fractionLabel +" "+ baseUOMUnitLabel);

	/**************************************************************/

    formats.putAll(FormatHelper.toMap(UOMs, RB.UOMRENDERER));


if(DEBUG){
		LCSLog.debug("compMap: " + compMap); 
		LCSLog.debug("listOfComp: " + listOfComp); 
		LCSLog.debug("nameMap: " + nameMap);
}
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script language="JavaScript" src="<%=URL_CONTEXT%>/javascript/moa.js"></script>
<script type="text/javascript" src="<%=URL_CONTEXT%>/lfusa/javascript/specPrinter.js"></script>
<script>
var CLEAR_CELL_VALUE = '<%= CLEAR_CELL_VALUE%>';

document.CHOOSE_SINGLE_SPEC = new Object();
document.CHOOSE_SINGLE_SPEC.childSpecComponentIds = new Array();
document.CHOOSE_SINGLE_SPEC.childSpecComponentNames = new Array();
document.CHOOSE_SINGLE_SPEC.childSpecDocIds = new Array();
document.CHOOSE_SINGLE_SPEC.childSpecDocNames = new Array();
document.CHOOSE_SINGLE_SPEC.childSpecDescDocIds = new Array();
document.CHOOSE_SINGLE_SPEC.childSpecDescDocNames = new Array();
<% String tempid = null;
    int incre = 0;
for(Iterator it = childListOfComp.keySet().iterator();it.hasNext(); ){
        tempid = (String)it.next();
        incre++;
%>
document.CHOOSE_SINGLE_SPEC.childSpecComponentIds[<%= incre %>] = "<%=tempid%>";
document.CHOOSE_SINGLE_SPEC.childSpecComponentNames[<%= incre %>] = '<%= FormatHelper.formatJavascriptString((String)childListOfComp.get(tempid), false)%>';
<% }
    incre = 0;
    for (Iterator it = childDocs.keySet().iterator(); it.hasNext();) {
        tempid = (String)it.next();
        incre++;
%>
document.CHOOSE_SINGLE_SPEC.childSpecDocIds[<%= incre %>] = "<%=tempid%>";
document.CHOOSE_SINGLE_SPEC.childSpecDocNames[<%= incre %>] = '<%= FormatHelper.formatJavascriptString((String)childDocs.get(tempid), false)%>';
<% }

    incre = 0;
    for (Iterator it = childDescDocs.keySet().iterator(); it.hasNext();) {
        tempid = (String)it.next();
        incre++;
%>
document.CHOOSE_SINGLE_SPEC.childSpecDescDocIds[<%= incre %>] = "<%=tempid%>";
document.CHOOSE_SINGLE_SPEC.childSpecDescDocNames[<%= incre %>] = '<%= FormatHelper.formatJavascriptString((String)childDescDocs.get(tempid), false)%>';
<% } %>

BOM_IDENTIFIER = "<%= BOM_IDENTIFIER%>";
function createMOA(group)
{
	var group = document.getElementsByName(group);
	var ids = '';
	  		// GROUP THE SELECED IDS INTO A MOA STRING
			for (var k =0; k < group.length; k++)  {
				if (group[k].checked)   {
					   ids = buildMOA(ids, group[k].value);
         		}
      		}
	        return ids;

}
function createMOAViewSelect()
{
	var group = document.getElementsByName('viewSelect');
	var ids = ' ';
	  		// GROUP THE SELECED IDS INTO A MOA STRING
			for (var k =0; k < group.length; k++)  {
				if (group[k].value!=' ')   {
					   ids = buildMOA(ids, group[k].value);
         		}
      		}
	        return ids;
}


    var compMap = new Array();
    var docMap = new Array();
    var descDocMap = new Array();
    var ctMap;
    var dMap;
<%
	Collection comptypes  = compMap.keySet();
	Iterator cti = comptypes.iterator();
	Collection ids = null;
	Iterator idi = null;
	String id = "";
	String compType = "";
	while(cti.hasNext()){
		compType = (String)cti.next();
%>
		 ctMap = new Array();
<%		
		
		ids = (Collection)compMap.get(compType);
		if(ids != null){
			idi = ids.iterator();
			while(idi.hasNext()){
				id = (String)idi.next();
%>
		ctMap['<%= id %>'] = '<%= FormatHelper.formatJavascriptString((String)nameMap.get(id)) %>';
		
<%				
			}
		}
%>
		compMap['<%= compType %>'] = ctMap;		
		
<%		
	}
%>

     var bomReports = new Array();
	 var defMap2 = new Array();
	 
<%
	String defView2 = null;
	Iterator viewIter2 = specRequests.iterator();
	while(viewIter2.hasNext()){
		defView2 = (String)viewIter2.next();
		// ITC Added by Ashrujit to obtain values for Grid Report replace function
		Collection<String> repPages = SingleSpecPageUtil.getPageOptions(defView2);
%>
			defMap1 = new Array();
            dMap = new Array();
<%
		if(!repPages.isEmpty()){
		
			for(String repPage: repPages){
				

%>
			defMap1['<%=repPage%>'] = '<%=repPage%>';
<%			}%>
			bomReports['<%=defView2%>'] = defMap1;
		
<%
		}
        Collection<String> requestDocs = gen.getRequestDocs(defView2); 
        for (Iterator it = listOfDocs.keySet().iterator(); it.hasNext(); ) {
            id = (String)it.next();
            if (requestDocs.contains(id)) {
%>
                dMap['<%= id%>'] = '<%= FormatHelper.formatJavascriptString((String)listOfDocs.get(id)) %>';
<%
            }
        }
%>
        docMap['<%= defView2%>'] = dMap;
        dMap = new Array();
<%
		for (Iterator it = listOfDescDocs.keySet().iterator(); it.hasNext(); ) {
		    id = (String)it.next();
		    if (requestDocs.contains(id)) {
%>
               dMap['<%= id%>'] = '<%= FormatHelper.formatJavascriptString((String)listOfDescDocs.get(id)) %>';
<%
            }
        }
%>
        descDocMap['<%= defView2%>'] = dMap;
        dMap = new Array();
<%
        for (Iterator it = childDocs.keySet().iterator(); it.hasNext(); ) {
            id = (String)it.next();
            if (requestDocs.contains(id)) {
%>
                dMap['<%= id%>'] = '<%= FormatHelper.formatJavascriptString((String)childDocs.get(id)) %>';
<%
            }
         }
%>
        docMap['child' + '<%= defView2%>'] = dMap;
		dMap = new Array();
<%
        for (Iterator it = childDescDocs.keySet().iterator(); it.hasNext(); ) {
            id = (String)it.next();
            if (requestDocs.contains(id)) {
%>
                dMap['<%= id%>'] = '<%= FormatHelper.formatJavascriptString((String)childDescDocs.get(id)) %>';
<%
            }
         }
%>
        docMap['childDesc' + '<%= defView2%>'] = dMap;
<%
	}
%>

 function changePartFilter(){
	
	 if(document.MAINFORM.exportedIndentedBOMbox.checked==true){
		document.MAINFORM.partFilter.disabled = false;
		document.MAINFORM.exportedIndentedBOM.value = "true";
	 }else{
		document.MAINFORM.partFilter.disabled = true; 
		document.MAINFORM.exportedIndentedBOM.value = "false";
	 }
 }
 

 function selectSpecificationPages(size2exists){
	  params = new Array();

	  //Source
	  var sourceVal = document.MAINFORM.source.value;
	  params[SOURCE] = sourceVal;

	 //Spec Pages
	 var specPagesVal = document.MAINFORM.specPages.value;
     var availDocsValue = document.MAINFORM.availDocs.value;
     var availDescDocsValue = document.MAINFORM.availDescDocs.value;
     var availEPMDocsValue = document.MAINFORM.availEPMDOCDocs.value;
     var availPartsValue = document.MAINFORM.availParts.value;
	 //GBG : add for build 7.2
     var availSampleValue = document.MAINFORM.availSamples.value;
	 //alert(availSampleValue);
 	 //alert("caddoc? "+ document.MAINFORM.pageOptions.value.indexOf('<%=PDFCadDocVariationsGenerator.VARIATIONS_REPORT%>'));
	 if(document.MAINFORM.pageOptions.value.indexOf('<%=PDFCadDocVariationsGenerator.VARIATIONS_REPORT%>') > -1 
			 && !hasContent(availEPMDocsValue)){
	        alert("<%= FormatHelper.encodeForJavascript(WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "noCadDocsSelected_LBL", RB.objA )) %>");
	        return;
	 } 	
	 
	 if(document.MAINFORM.pageOptions.value.indexOf('<%=PDFPartVariationsGenerator.VARIATIONS_REPORT%>') > -1 
			 && !hasContent(availPartsValue)){
	        alert("<%= FormatHelper.encodeForJavascript(WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "noPartsSelected_LBL", RB.objA )) %>");
	        return;
	 } 	
	 
	 else if(!hasContent(specPagesVal) && !hasContent(availDocsValue + availDescDocsValue+availEPMDocsValue+availPartsValue)){
        alert("<%= FormatHelper.encodeForJavascript(WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "noComponentsSelected_LBL", RB.objA )) %>");
        return;
     }
	 //GBG Build 7.0 : validation --START
	 if(hasContent(availSampleValue) )
	 {
		 //Not using for now..
		 //alert("Please select measurement set ...");
	 }
	 //GBG Build 7.0 : validation --END

	 params[SPEC_PAGES] = specPagesVal;
     params[AVAIL_DOCS] = availDocsValue + availDescDocsValue;
	 //GBG Build 7.2 : setting selected samples to Params to submit to backed -- START
	 params[SAMPLE_PAGES] = availSampleValue;
	 //GBG Build 7.2 : setting selected samples to Params to submit to backed -- END
	 
	 //Colorways
	 document.MAINFORM.colorwaydataVal.value = createMOA('colorwaydata');
     var colorwayVal = document.MAINFORM.colorwaydataVal.value;
	 params[COLORWAYS_DATA] = colorwayVal;

	 //Size 1
	 document.MAINFORM.size1dataVal.value = createMOA('size1data');
	 var size1Val =  document.MAINFORM.size1dataVal.value;
	 params[SIZE1_DATA] = size1Val;

	 //Size2
 	 if(size2exists) {
		document.MAINFORM.size2dataVal.value = createMOA('size2data');
		var size2Val = document.MAINFORM.size2dataVal.value;
		params[SIZE2_DATA] = size2Val;
	 }

	 //Destination
     if(document.MAINFORM.destinationdata){
    	document.MAINFORM.destinationdataVal.value = createMOA('destinationdata');
		var destinationsVal = document.MAINFORM.destinationdataVal.value;
		params[DESTINATION_DATA] = destinationsVal;
     }

	 //Page Options
	 var pageOptionsVal = document.MAINFORM.pageOptions.value;
	 params[PAGE_OPTIONS] = pageOptionsVal;

	 //Selected Views
	 document.MAINFORM.viewSelectedVal.value = createMOAViewSelect();
	 var viewSelectVal = document.MAINFORM.viewSelectedVal.value;
	 params[SELECTED_VIEWS] = viewSelectVal;

	 //Colorways Per Page
	 var numColorwaysPerPageVal = document.MAINFORM.numColorwaysPerPage.value
	 params[COLORWAYS_PER_PAGE] = numColorwaysPerPageVal;

	 //Sizes Per Page
	 var numSizesPerPageVal = document.MAINFORM.numSizesPerPage.value;
	 params[SIZES_PER_PAGE] = numSizesPerPageVal;


	 //Use Size1/Size2
	 params[USE_SIZE1_SIZE2] = document.MAINFORM.useSize1Size2.value;

	 //Show Swatches
	 params[SHOW_COLOR_SWATCHES] = document.MAINFORM.showColorSwatches.value;

	 //Show Material Thumbnails
	 params[SHOW_MATERIAL_THUMBNAIL] = document.MAINFORM.showMaterialThumbnail.value;

	//Added by Ashrujit to pass the selected report option	 
	//13 May 2014/Girish - Added IF condition to fix the Tech Pack PDF Issue from BOM. 
	// "isBOMComponent" will be TRUE only if Tech Pack is generated from BOM Page
	<%if (!isBOMComponent){ %>
	 params[UOM] = document.MAINFORM.uom.value + "|" + document.MAINFORM.printLayout.value;
	<%}%>
	<%if (isBOMComponent){ %>
	 params[UOM] = document.MAINFORM.uom.value;
	<%}%>

	 <%if (ACLHelper.hasViewAccess(defaultDocumentVaultType)&&ACLHelper.hasCreateAccess(defaultDocumentVaultType)){ %>
		 
		//13 May 2014/Girish - Added IF condition to enable Tech Pack generation in Background based on selections made on Choosr Page.
		// ELSE Condition to disable Tech Pack generation in Background when triggered from BOM Page
		// "isBOMComponent" will be TRUE only if Tech Pack is generated from BOM Page
		 <%if (!isBOMComponent){ %>
		 params[DOCUMENTVAULT] = document.MAINFORM.documentVault.value;
		 params[VAULTDOCUMENTTYPEID] = document.MAINFORM.vaultDocumentTypeId.value;
	     params[ASYNCH_GENERATION] = document.MAINFORM.asynchronousGeneration.value;
		<%}%>

		<%if (isBOMComponent){ %>
		 params[DOCUMENTVAULT] = "false";
		 params[ASYNCH_GENERATION] = "false";
		<%}%>

	 <%}%>
	

     params[INCLUDE_SECONDARY_CONTENT] = document.MAINFORM.includeSecondaryContent.value;
     //add for story B-58112 03/28/2011
 	 var sinceDate = getSelectedDate();
 	 document.MAINFORM.showChangeSince.value = formatDateString(sinceDate, '%Y/%m/%d');
 	 params[SHOW_CHANGE_SINCE]= document.MAINFORM.showChangeSince.value;
 	<%-- B-92545
 	params[SPEC_CAD_FILTER]=document.MAINFORM.cadDocFilter.value;
 	--%>
 	params[SPEC_CAD_DOCS]=document.MAINFORM.availEPMDOCDocs.value;
 	//spec to parts
	params[SPEC_PARTS]= availPartsValue;
	params[SPEC_PART_FILTER]=document.MAINFORM.partFilter.value;
	
	params[SHOW_INDENTED_BOM]=document.MAINFORM.exportedIndentedBOM.value;
 
    


        // EVALUATE THE RETURN CALL 
		var returnMethod = '<%= returnMethod %>';
		
		var returnId = '<%= returnId %>';

	

        
        var methodCall = 'opener.' + returnMethod + '(returnId, params)';
        //var methodCall = 'opener.' + returnMethod + '(returnId, specPagesVal, skusVal, size1Val, size2Val, destinationsVal, bomOptionsVal, viewSelectVal, numColorwaysPerPageVal, numSizesPerPageVal)';

        eval(methodCall);
   }

////////////////////////////////////////////////////////////////////////////////////////////////////////////
function select(){
      var group = document.MAINFORM.selectedIds;
      var checked = false;
      var ids = 'noneSelected';

      // GROUP THE SELECED IDS INTO A MOA STRING
      for (var k =0; k < group.length; k++)  {
         if (group[k].checked)   {
            if (ids=='noneSelected') {
              ids='';
            }
            ids = buildMOA(ids, group[k].value);
			
         }
      }
   }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
function toggleSelect(allcheck, namecheck){
        var selectAllCheckbox = document.getElementsByName(allcheck);
		var checkboxcheck = document.getElementsByName(namecheck);
		
       
        for (i=0; i<checkboxcheck.length; i++) {
		    
            if (selectAllCheckbox[0].checked && !checkboxcheck[i].disabled) {
				checkboxcheck[i].checked = true;
				
            } else {
                checkboxcheck[i].checked = false;
            }
        
			
        }
    }



function chooseView(view) {

// Clear existing Data if a NEW view is chosen


//if (document.MAINFORM.printLayout.value!=' ')
//{
    if(<%= allComponents%>){
        document.MAINFORM.specPages.value = ' ';
    }
    document.MAINFORM.pageOptions.value = ' ';

    var specPagesChosen = document.MAINFORM.specPagesChosen;
	//GBG Build 7.2 : START
    var availSamplesChosen = document.MAINFORM.availSamplesChosen;
    //GBG Build 7.2 : END
	var pageOptionsChosen = document.MAINFORM.pageOptionsChosen;
    var availDocsChosen = document.MAINFORM.availDocsChosen;
    var availDescDocsChosen = document.MAINFORM.availDescDocsChosen;
    var availEPMDocsChosen = document.MAINFORM.availEPMDOCDocsChosen;
    var availablePartsChosen = document.MAINFORM.availPartsChosen;


	if(<%= allComponents%>){
	   for(i = 0; i < specPagesChosen.options.length; i++){
			specPagesChosen.remove(i--);
	   }
	}
	//GBG Build 7.2 : START
	// Need to find out need for this logic..
    if (availSamplesChosen && availSamplesChosen.options) {
        for(i = 0; i < availSamplesChosen.options.length; i++){
			availSamplesChosen.remove(i--);
        }
    }
    //GBG Build 7.2 : END
	
    if (availDescDocsChosen && availDescDocsChosen.options) {
        for(i = 0; i < availDescDocsChosen.options.length; i++){
			availDescDocsChosen.remove(i--);
        }
    }

    if (availDocsChosen && availDocsChosen.options) {
        for(i = 0; i < availDocsChosen.options.length; i++){
            availDocsChosen.remove(i--);
        }
    }

    if (availEPMDocsChosen && availEPMDocsChosen.options) {
        for(i = 0; i < availEPMDocsChosen.options.length; i++){
            availEPMDocsChosen.remove(i--);
        }
    }
    
    if (availablePartsChosen && availablePartsChosen.options) {
        for(i = 0; i < availablePartsChosen.options.length; i++){
        	availablePartsChosen.remove(i--);
        }
    }

    for(i=0; i < pageOptionsChosen.options.length; i++) {
         pageOptionsChosen.remove(i--);
    }

    document.getElementById('numColorwaysPerPageInput').value = '';

    document.getElementById('numSizesPerPageInput').value = '';

    document.getElementById('showColorSwatchesbox').checked = false;
    document.getElementById('showColorSwatches').value = 'false';

    document.getElementById('showMaterialThumbnailbox').checked = false;
    document.getElementById('showMaterialThumbnail').value = 'false';

    var icsb = document.getElementById('includeChildSpecsbox');
    if(icsb != null){
       icsb.checked = <%=DEFAULT_CHILD_SPECS_CHECKED%>;
       includeChildSpecsfunction();
       includeChildDocsFunction();
	   includeChildDescDocsFunction();
    }
    var iscb =document.getElementById('includeSecondaryContentbox');
    if(iscb != null){ 
    	iscb.checked = false;
    }

    /******************* Issue 219,268 changes *****************************/
    //Build 6.19 : default unit of measure driven from property entry : Start
	//Setting Default value as Fraction in
	//document.getElementById('uom').value = '<%=FormatHelper.FRACTION_FORMAT%>';
	document.getElementById('uom').value = '<%=defaultUnitOfMeasure%>';
	//alert(document.getElementById('uom').value);
    //Build 6.19 : default unit of measure driven from property entry : End
    /***********************************************************************/


         var acb = document.getElementById('allColorwaysbox')
         if(acb != null){
            acb.checked = <%= DEFAULT_ALL_COLORWAYS_CHECKED%>;
            toggleSelect('allColorwaysbox', 'colorwaydata');
         }

         var asb = document.getElementById('allSizesbox');
         if(asb != null){
            asb.checked = <%= DEFAULT_ALL_SIZES_CHECKED%>;
            selectAllSizes();
         }

         var adb = document.getElementById('allDestinationsbox');
         if(adb != null){
            adb.checked = <%= DEFAULT_ALL_DESTINATIONS_CHECKED%>;
            toggleSelect('allDestinationsbox', 'destinationdata');
         }

         var uss = document.getElementById('useSize1Size2');
         if(uss != null){
            uss.value = 'size1';
         }

//}

//End clearing of values



<% 
	String defView = "";

	Iterator viewIter = specRequests.iterator();
	boolean first = true;
	while(viewIter.hasNext()){
		defView = (String)viewIter.next();
%>
		//add for SPR# 2063313 03/31/2011
		if (view == " ") {
			updatePage();
		}

		<% if(first){ %>
			if(view == '<%=defView%>'){
		<%} else {%>
			} else if(view == '<%=defView%>'){
		<% } %>
			
				//for(var n in compMap){
					//alert(n);
				//}

        document.getElementById('numColorwaysPerPageInput').value = '<%=SingleSpecPageUtil.getNumColorwaysPerPage(defView)%>';

        document.getElementById('numSizesPerPageInput').value = '<%=SingleSpecPageUtil.getNumSizesPerPage(defView)%>';

        document.getElementById('showColorSwatchesbox').checked = <%=SingleSpecPageUtil.getShowColorSwatch(defView)%>;
        document.getElementById('showColorSwatches').value = '<%=SingleSpecPageUtil.getShowColorSwatch(defView)%>';

        document.getElementById('showMaterialThumbnailbox').checked = <%=SingleSpecPageUtil.getShowMaterialThumb(defView)%>;
        document.getElementById('showMaterialThumbnail').value = '<%=SingleSpecPageUtil.getShowMaterialThumb(defView)%>';


        var icsb = document.getElementById('includeChildSpecsbox');
        if(icsb != null){
            icsb.checked = <%=SingleSpecPageUtil.getIncludeChildSpecs(defView)%>;
            includeChildSpecsfunction();
            if (document.MAINFORM.availDocsOptions) {
               var docD = docMap['child' + '<%= defView %>'];
               addToChosenList(docD, document.MAINFORM.availDocsOptions, document.MAINFORM.availDocsChosen, document.MAINFORM.availDocs);
            }
            if (document.MAINFORM.availDescDocsOptions) {
                var docD = descDocMap['child' + '<%= defView %>'];
                addToChosenList(docD, document.MAINFORM.availDescDocsOptions, document.MAINFORM.availDescDocsChosen, document.MAINFORM.availDescDocs);
             }
        }
        var iscb = document.getElementById('includeSecondaryContentbox');
        if(iscb != null){
            iscb.checked = <%=SingleSpecPageUtil.getIncludeSecondaryContent(defView)%>;
            setIncludeSecondary(iscb);
        }
        includeChildDocsFunction();
		includeChildDescDocsFunction()
 
         /******************* Issue 219,268 changes *****************************/
	 //Build 6.19 : default unit of measure driven from property entry : Start
		//Setting Default value as Fraction in
		 //document.getElementById('uom').value = '<%=FormatHelper.FRACTION_FORMAT%>';
		 
         document.getElementById('uom').value = '<%=SingleSpecPageUtil.getMeasureUOM(defView)%>';
		 //alert(document.getElementById('uom').value);
	 //Build 6.19 : default unit of measure driven from property entry : End
	 /***********************************************************************/

         var acb = document.getElementById('allColorwaysbox');
         if(acb != null){
             acb.checked = <%= SingleSpecPageUtil.getCheckAllColorways(defView)%>;
             toggleSelect('allColorwaysbox', 'colorwaydata');
         }

         var asb = document.getElementById('allSizesbox');
         if(asb != null){
             asb.checked = <%= SingleSpecPageUtil.getCheckAllSizes(defView)%>;
             selectAllSizes();
         }

         var adb = document.getElementById('allDestinationsbox');
         if(adb != null){
             adb.checked = <%= SingleSpecPageUtil.getCheckAllDestinations(defView)%>;
             toggleSelect('allDestinationsbox', 'destinationdata');
         }

         var uss = document.getElementById('useSize1Size2');
         if(uss != null){
             uss.value = '<%=SingleSpecPageUtil.getUseSize1Size2(defView)%>';
         }

         if (document.MAINFORM.availDocsOptions) {
            var docD = docMap['<%= defView %>'];
            addToChosenList(docD, document.MAINFORM.availDocsOptions,
                document.MAINFORM.availDocsChosen, document.MAINFORM.availDocs);
        }

        if (document.MAINFORM.availDescDocsOptions) {
            var docD = descDocMap['<%= defView %>'];
            addToChosenList(docD, document.MAINFORM.availDescDocsOptions,
                document.MAINFORM.availDescDocsChosen, document.MAINFORM.availDescDocs);
        }
<% 
		// ITC Added by Ashrujit to obtain values for Grid Report replace function
		for(String compPage : SingleSpecPageUtil.getSpecPages(defView)){
			//compPage = compPage.replaceAll(" ", "");
%>				
			var comps = compMap['<%= compPage %>'];
			addToChosenList(comps, document.MAINFORM.specPagesOptions, document.MAINFORM.specPagesChosen, document.MAINFORM.specPages);
<%
		}// end while
		//Add BOM Reports section here%>
        var reps = bomReports['<%=defView%>'];
	        addToChosenList(reps, document.MAINFORM.pageOptionsOptions, document.MAINFORM.pageOptionsChosen, document.MAINFORM.pageOptions);

<%
		if(!viewIter.hasNext()){
%>
		}
<%
		} // end if
		first=false;

	}// end while
%>
} // end javascript function

function addToChosenList(comps, selectOptions, selectChosen, chosenElem){
	for(var n in comps){
		//alert(n);
		var sOptions = selectOptions.options;
		var sOption;
		for(var i = 0; i < sOptions.length; i++){
			sOption = sOptions[i];
			//alert(n + ' : ' + sOption.value);
			if(sOption.value.indexOf(n) > -1){
				addOption(selectChosen, sOption, true, false);
				ids = buildMOA(chosenElem.value, sOption.value);
				chosenElem.value = ids;
				
			}
		}
		
				
	}	
    updatePage();
    updateDoc();
}

function addResults(){ 
    add(document.MAINFORM.resultsMap, document.MAINFORM.specPagesChosen, document.MAINFORM.specPages,
    document.MAINFORM.availDocs, false);
    javascript:updatePage()
}

function selectAllSizes()
{
	toggleSelect('allSizesbox', 'size1data');
	toggleSelect('allSizesbox', 'size2data');
	
}


function chooseSize()
{
	var size1 = document.getElementsByName('size1databox');
	var size2 = document.getElementsByName('size2databox');
	var allbox = document.getElementsByName('allSizesbox');
	var size1Table = document.getElementById('size1');
	var size2Table = document.getElementById('size2');
	var sizeSelectValue = document.MAINFORM.sizeCat.value;
	
	if(sizeSelectValue=="size1") 
	{
		allbox[0].checked = false;
		size1Table.style.display ='block'
		size2Table.style.display ='none';
		
		for (i=0; i<size1.length; i++)
		{
			size1[i].disabled = false;
		}
		
		
		for (i=0; i<size2.length; i++)
		{
			size2[i].checked = false;
			size2[i].disabled = true;
		}
    }
	
	else if(sizeSelectValue=="size2")
	{
		allbox[0].checked = false;
		
		for (i=0; i<size2.length; i++)
		{
			size2[i].disabled = false;
		}
		
		size1Table.style.display ='none'
		size2Table.style.display ='block';
		
		for (i=0; i<size1.length; i++)
		{
			size1[i].checked = false;
			size1[i].disabled = true;
		}
		
	}
	
	else
	{	
		allbox[0].checked = false;
		
		for (i=0; i<size2.length; i++)
		{
			size2[i].disabled = false;
		}
		
		for (i=0; i<size1.length; i++)
		{
			size1[i].disabled = false;
		}
		
		size1Table.style.display ='block'
		size2Table.style.display ='block';
	} 
}

function updatePage() {
   var specCompOptions = document.MAINFORM.specPagesOptions;
   var specCompSelected = document.MAINFORM.specPagesChosen;
   var optionsIndex = specCompOptions.selectedIndex;
   var pageOptionsVar = document.MAINFORM.pageOptionsOptions;
   var pageOptionsChosenVar = document.MAINFORM.pageOptionsChosen;

   var division;
   var currentBom; 

   // Check to make sure only the boms selected have their views displayed
   var found = false;
   var includedTrackedChanges = false;
   var includedPartData = false;

   for(i=0; i<pageOptionsVar.length; i++){
	  found = false;
	  includedTrackedChanges = false;
	  var testVal = pageOptionsVar.options[i].value;
	  if  (testVal.indexOf(BOM_IDENTIFIER) == 0){
		 if(pageOptionsChosenVar.length > 0){
			for (j=0; j<pageOptionsChosenVar.length; j++){
			   if (pageOptionsChosenVar.options[j].value==pageOptionsVar.options[i].value){
				  found = true;
				  break;
			   }
			}
			for (j=0; j<pageOptionsChosenVar.length; j++){
				if (pageOptionsChosenVar.options[j].value == '<%=TRACKED_CHANGES_IDENTIFIER + ChangeTrackingPDFGenerator.EXPANDED_REPORT%>' || 
				        pageOptionsChosenVar.options[j].value == '<%=TRACKED_CHANGES_IDENTIFIER + ChangeTrackingPDFGenerator.CONDENSED_REPORT%>') {
					includedTrackedChanges = true;
					continue;
				}
				
				if(pageOptionsChosenVar.options[j].value == '<%=PART_VARIATIONS_IDENTIFIER + PDFPartVariationsGenerator.VARIATIONS_REPORT%>'){
				   includedPartData =true;
				   continue;
				}
				if(includedPartData&&includedTrackedChanges) break;
			}
			
		 }
		 var divIdVar = pageOptionsVar.options[i].value;
		 divIdVar = divIdVar.substring(BOM_IDENTIFIER.length);
		 division = document.getElementById(divIdVar +"div");
		 if (found && division){ // if it's not found in the chosen list, remove the views
			division.style.display ='block';
		 } else {
            if(division != null){
                division.style.display ='none';
            }
		 }
	
		 if (includedTrackedChanges) {
			 document.getElementById("divTrackedChanges").style.display='block';
		 } else {
			 document.getElementById("divTrackedChanges").style.display='none';
		 }
		 if (includedPartData) {
			 document.getElementById("divSpecPart").style.display='block';
			 document.MAINFORM.partFilter.disabled = true;
		 } else {
			 document.getElementById("divSpecPart").style.display='none';
		 }
	  }
   }
}

//gbg: build 7.2 -- START

function updateSample() {
	//no implementation required for now...
}
//gbg: build 7.2 -- END



function updateDoc() {
}

function includeChildDescDocsFunction()
{
    //alert("includeChildDescDocsFunction");
    //var checkbox = document.MAINFORM.includeChildDocsbox;
    var checkbox = document.MAINFORM.includeChildSpecsbox;
    var docs = document.CHOOSE_SINGLE_SPEC.childSpecDescDocIds;
    var docNames = document.CHOOSE_SINGLE_SPEC.childSpecDescDocNames;
    var docOptions = document.getElementById('availDescDocsOptions');
    var chosenDocs = document.getElementById('availDescDocsChosen');
    if(checkbox != null && checkbox.checked){
        //alert("checked");
        for (i = 1; i < docs.length; i++) {
            addOptionValue(docOptions, docNames[i], docs[i], "true", "true");
        }
    } else {
        //alert("unchecked");
        var removeOptions = "";
        for (i = 1; i < docs.length; i++) {
            //removeOptions = buildMOA(removoeOptions, docs[i]);
            removeOptions = removeOptions + DELIMITER + docs[i];
        }

        removeSelectOptions(docOptions, removeOptions)
        removeSelectOptions(chosenDocs, removeOptions)
    }
}

function includeChildDocsFunction()
{
    //alert("includeChildDocsFunction");
    //var checkbox = document.MAINFORM.includeChildDocsbox;
    var checkbox = document.MAINFORM.includeChildSpecsbox;
    var docs = document.CHOOSE_SINGLE_SPEC.childSpecDocIds;
    var docNames = document.CHOOSE_SINGLE_SPEC.childSpecDocNames;
    var docOptions = document.getElementById('availDocsOptions');
    var chosenDocs = document.getElementById('availDocsChosen');
    if(checkbox != null && checkbox.checked){
        //alert("checked");
        for (i = 1; i < docs.length; i++) {
            addOptionValue(docOptions, docNames[i], docs[i], "true", "true");
        }
    } else {
        //alert("unchecked");
        var removeOptions = "";
        for (i = 1; i < docs.length; i++) {
            //removeOptions = buildMOA(removoeOptions, docs[i]);
            removeOptions = removeOptions + DELIMITER + docs[i];
        }

        removeSelectOptions(docOptions, removeOptions)
        removeSelectOptions(chosenDocs, removeOptions)
    }
}

function includeChildSpecsfunction(){
    //alert("includeChildSpecsfunction");
    var checkbox = document.MAINFORM.includeChildSpecsbox;
    var ids =document.CHOOSE_SINGLE_SPEC.childSpecComponentIds;
    var names = document.CHOOSE_SINGLE_SPEC.childSpecComponentNames;
    var options = document.getElementById('specPagesOptions');
    var chosen = document.getElementById('specPagesChosen');
    if(checkbox.checked){
        //alert("checked");
        for(i = 1;i <ids.length;i++){
            //alert("ids[" + i + " --" + ids[i]);
            addOptionValue(options, names[i], ids[i], "true", "true");
        }
    } else {
        //alert("unchecked");
        var removeOptions = "";
        for(i = 1;i <ids.length;i++){
            removeOptions = buildMOA(removeOptions, ids[i]);
        }
        removeSelectOptions(options, removeOptions)
        removeSelectOptions(chosen, removeOptions)
    }
//chooseView(document.MAINFORM.printLayout.value);
}

function includeChildSpecsAndDocs() {
   includeChildSpecsfunction();
   includeChildDocsFunction();
   includeChildDescDocsFunction();
}

function setIncludeSecondary(includeSecondaryCheckbox){
    if(includeSecondaryCheckbox.checked){
    	document.getElementById('includeSecondaryContent').value = 'true';
    } else {
    	document.getElementById('includeSecondaryContent').value = 'false';
    }
}

function chooseVaultDocumentType(){
	var typeClass = 'com.lcs.wc.document.LCSDocument';
	var rootTypeId = '<%=FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath(DEFAULT_DOCUMENT_VAULT_TYPE))%>';
	launchChooser('<%=URL_CONTEXT%>/jsp/flextype/TypeChooser.jsp?typeclass=' + typeClass + '&rootTypeId='+ rootTypeId + '&accessType=CREATE_ACCESS', fkTypeDisplay, document.MAINFORM.vaultDocumentTypeId);
}

function setDocumentVaultDiv(documentVaultCheckbox){
    if(documentVaultCheckbox.checked){
    	document.getElementById('documentVault').value = 'true';
    } else {
    	document.getElementById('documentVault').value = 'false';
    }
	if (documentVaultCheckbox.checked){
		showDocumentVaultDiv();
	}else{
		hideDocumentVaultDiv();
	}
}

function showDocumentVaultDiv(){
	document.getElementById('refTypeDiv').style.display ='block';
	document.getElementById('fkTypeDisplay').style.display ='block';
}

function hideDocumentVaultDiv(){
	document.getElementById('refTypeDiv').style.display ='none';
	document.getElementById('fkTypeDisplay').style.display ='none';
}

function setAsynchGen(checkBox){
    var checkBox2 = document.getElementById('documentVaultbox');
    var gen = document.getElementById('asynchronousGeneration');
    if (checkBox.checked) {
        checkBox2.checked = 'true';
        checkBox2.disabled = 'true';
        gen.value = true;
        document.MAINFORM.documentVault.value = true;
        showDocumentVaultDiv();
    } else {
        checkBox2.checked = false;
        checkBox2.disabled = false;
        gen.value = false;
        document.MAINFORM.documentVault.value=false;
        hideDocumentVaultDiv();
    }
}
//add for story B-58112 03/28/2011
function changeSinceDate() {
	var choice = $F("daysValueId").strip();
	if(isNaN(choice)) {
			$('sinceDateCal').style.display = 'inline-block';
			$("dateTimeDisplay").style.display='none';
	} else {
		$('sinceDateCal').style.display = 'none';
		var sinceDate = new Date();
		sinceDate.setDate(sinceDate.getDate()-parseInt(choice));
		showDateTimeRightToWidget(sinceDate);
	}
}

function showDateTimeRightToWidget(sinceDate) {
		sinceDate.setHours(0);
		sinceDate.setMinutes(1);
		$("dateTimeDisplay").innerHTML = formatDateString(sinceDate, "<%= WTMessage.getLocalizedMessage ( RB.DATETIMEFORMAT, "jsCalendarShortFormat", RB.objA ) %>") ;
		$("dateTimeDisplay").style.display='inline-block';				
}


function getSelectedDate() {
	var choice = parseInt($F("daysValueId").strip());
	var sinceDate = new Date();
	if(isNaN(choice)) {
		var tStr = $F('sinceDateInput').strip();
		if(tStr == ""){						//Date input is empty
			alert(dateSelectEmpty);
			return false;
		} else  {
		    sinceDate = chkDateString(tStr, '', '<%=jsCalendarFormat%>', true);
		}
	} else {
		sinceDate.setDate(sinceDate.getDate() - choice);
	}
	return sinceDate;
}


Event.observe(window,'load',function() {
	
	if(window.opener.parent && window.opener.parent.headerframe){
		if(window.opener.parent.headerframe.getGlobalChangeTrackingSinceDate) {
			dateStr = window.opener.parent.headerframe.getGlobalChangeTrackingSinceDate();
		}
	}				
	$('sinceDateInput').value = dateStr;		
    var selectedDate = chkDateString(dateStr, '', '<%=jsCalendarFormat%>', true);
	var selectedDateStr = selectedDate.print('<%=jsCalendarFormat%>');

	var customizeElem = null;
	var specialDate = false;
	var daysMap = <%=daysHolder%>;
	var daysValueIdSelect = $('daysValueId');
	for(var i = 0 ; i < daysValueIdSelect.options.length; i++) {
		var opt = daysValueIdSelect.options[i];
		var choice = opt.value.strip();
		if(daysMap[choice]) {
			choice = daysMap[choice].strip();
			opt.value = choice;
			if(!isNaN(choice)) {
				var days = parseInt(choice);
				var date = new Date();
				date.setDate(date.getDate() - days);
				opt.dateVal = date.print('<%=jsCalendarFormat%>');
				if(selectedDateStr == opt.dateVal) {
						opt.selected=true;
						specialDate = true;
						$('sinceDateCal').style.display = 'none';
				}
			} else {
				customizeElem = opt;
			}
		}
	}
	if(! specialDate) {
		customizeElem.selected=true;
		$('sinceDateCal').style.display = 'inline-block';
	} else {
		$('sinceDateInput').value = new Date().print('<%=jsCalendarFormat%>');
		showDateTimeRightToWidget(selectedDate);
	}
});


</script>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input type="hidden" name="returnMethod" value="<%= returnMethod %>">
<input name="vaultDocumentTypeId" type="hidden" value="">
<input type="hidden" name="colorwaydataVal" value="">
<input type="hidden" name="size1dataVal" value="">
<input type="hidden" name="size2dataVal" value="">
<input type="hidden" name="destinationdataVal" value="">
<input type="hidden" name="viewSelectedVal" value="">


<%-- /////////////////////////////////////////HEADER CODE ////////////////////////////////////////////--%>

<table> 
<tr>
	<td class="PAGEHEADINGTITLE">
   <%= pageTitle %> 
   <% if (currentSpec != null) { %>
	  <%= currentSpec.getName() %>
   <% } else {%>
	  <%= product.getName()%>
   <% } %>
	</td>
	<tr><tr><td> <font point-size="90pt" color="black"><b><i>[NOTE : COVER PAGE AUTOMATICALLY INCLUDED IN TECH PACK] </i></b></font></td></tr></tr>
	
</tr>
</table> 
   <% if(FormatHelper.hasContent(errorMessage)) { %>
   <tr>
      <td class = "MAINLIGHTCOLOR" width="100%" border="0">
         <table>
            <tr>
               <td class="ERROR">
                  <%= java.net.URLDecoder.decode(errorMessage, ENCODING) %>
               </td>
            </tr>
         </table>
        </td>
   </tr>
   <% } %>
<%-- /////////////////////////////////////////VARIATION OPTIONS CODE ////////////////////////////////////////////--%>

		 <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle() %><%= variationOptionsGrpTle%>
		 <%= tg.endTitle() %>
	     <%= tg.startGroupContentTable() %>
<table border='0' halign='center' width='100%'>

  
 <tr halign='center'>
<% if(needSource){%>
 <td class="LABEL" align='center' nowrap><%=sourceLabel%></td>
<% }%>
 <td class="LABEL" align='center' nowrap><%=colorwaysLabel%></td>
 <td class="LABEL" align='center' nowrap><%= sizesLabel%></td>
 <td class="LABEL" align='center' nowrap><%=destinationsLabel%></td>
 </tr>
 <tr>

<%-- //////////////////Source selection/////////////////////////////////--%>
<%   String sourceMasterId = "";
   LCSSourcingConfig selectedSource = appContext.getSourcingConfig();
   if(selectedSource != null) {
	  selectedSource.getMaster();
	  sourceMasterId =  FormatHelper.getNumericObjectIdFromObject((WTObject)selectedSource.getMaster());
   }

 if(needSource){
   Map appContextSources = appContext.getSourcesMap();
   Map sources = new HashMap();
   
   Iterator i = appContextSources.keySet().iterator();

   String source;
   LCSSourcingConfig sc;
   String sourceId;
   while(i.hasNext()){
	  source = (String)i.next();
	  if(FormatHelper.hasContent(source)&& source.indexOf("LCSSourceToSeasonLink") > -1 ){
		 LCSSourceToSeasonLink stsl = (LCSSourceToSeasonLink)LCSQuery.findObjectById(source);
		 sourceId = FormatHelper.getNumericObjectIdFromObject((wt.fc.WTObject)stsl.getSourcingConfigMaster());
	  } else {
		 sc = (LCSSourcingConfig)LCSQuery.findObjectById(source);
		 sourceId = FormatHelper.getNumericObjectIdFromObject((wt.fc.WTObject)sc.getMaster());
	  }
	  sources.put(sourceId,appContextSources.get(source));
   }

%>
<td nowrap valign='top' align='center'>
   <table border='0' cellpadding="1" cellspacing="1">
   <col width='15%'><col width="35%">
	  <tr><td>&nbsp;</td></tr>
   </table>
   <table>
	  <tr><td class="LABEL">&nbsp;</td></tr>
   </table>
   <table cellpadding="1" cellspacing="1" border='0' align='center'>
	  <tr><%= fg.createDropDownListWidget(sourceLabel, sources, "source", sourceMasterId, null, false)%></tr>
   </table>
</td>
<% } else{ %>
<input type="hidden" name="source" value="<%= sourceMasterId%>">
<% }%>


<%-- //////////////////Colorway selection/////////////////////////////////--%>
<%
Map skuTable = appContext.getSKUsMap();
Map reversed = new HashMap();
Iterator keys = skuTable.keySet().iterator();
String key = "";
while(keys.hasNext()){
   key = (String) keys.next();
   reversed.put(skuTable.get(key), key);
}
Collection sortedSkus = SortHelper.sortStrings(reversed.keySet());
//If we have more than 0 skus, draw the section/table
if (skuTable.size() > 0)  {%>

<td nowrap valign='top' align='center'>
<table border='0' cellpadding="1" cellspacing="1">
<col width='15%'><col width="35%">
   <tr valign='bottom'><td valign='bottom'><%= fg.createCustomActionBooleanInput("allColorways", allLabel, DEFAULT_ALL_COLORWAYS_CHECKED, "javascipt:toggleSelect(\'allColorwaysbox\', \'colorwaydata\')", false)%></td></tr>
</table>
<table>
   <tr><td class="LABEL">&nbsp;</td></tr>
</table>
<table cellpadding="1" cellspacing="1" border='0' valign='baseline' align='center'>

<%
Iterator skuItr = sortedSkus.iterator(); 

String temp = "";
LCSSKU sku = null;
String numeric = "";
String label = "";
 while (skuItr.hasNext())
 {
 
	temp = (String)skuItr.next();
	
    sku = (LCSSKU)LCSQuery.findObjectById((String)reversed.get(temp)); 
	
	numeric = FormatHelper.getNumericFromReference(sku.getMasterReference());
	
	label = sku.getName();
	
	%>
	 <tr valign='baseline' ><%= drawCheckBox("colorwaydata", numeric, label, false) %></tr>
	<%
 }
 %>
</table>
</td>
<script>
toggleSelect('allColorwaysbox', 'colorwaydata');
</script>

<%
 } else {%>
<input type="hidden" name="colorwaydata" value="">
<td></td>
<% } %>

<%-- //////////////////Sizing selection/////////////////////////////////--%>
<% 
   SearchResults results = new SizingQuery().findProductSizeCategoriesForProduct(product);
   Vector resultVector = new Vector();

   resultVector = results.getResults(); 

   String sizeDataLabel = "";
   String sizeDataLabel2 = "";
   String sizeData = "";
   String size2Data = "";
   if (!resultVector.isEmpty())
   {
	FlexObject firstElement = (FlexObject)resultVector.elementAt(0);  // only concerned with the first sizing category
	sizeDataLabel = firstElement.getData("FULLSIZERANGE.SIZE1LABEL");
	sizeDataLabel2 = firstElement.getData("FULLSIZERANGE.SIZE2LABEL");
	sizeData = firstElement.getData("PRODUCTSIZECATEGORY.SIZEVALUES");	
	size2Data = firstElement.getData("PRODUCTSIZECATEGORY.SIZE2VALUES");
	
	Collection sizes = MOAHelper.getMOACollection(sizeData);

	%>

<td nowrap valign='top'align='center' >
<table cellpadding="1" cellspacing="1" border='0'>
<col width='15%'><col width="35%">
	<tr><td><%= fg.createCustomActionBooleanInput("allSizes", allLabel, DEFAULT_ALL_SIZES_CHECKED, "javascipt:selectAllSizes()", false) %></td></tr>
</table>
<table>
	<tr align='center' ><td class="LABEL" halign='center' nowrap><%=sizeDataLabel %></td><td>&nbsp;&nbsp;</td><td class="LABEL" align='center' nowrap><%=sizeDataLabel2 %></td></tr>
</table>
<table>
	<tr>
	<td  valign='top'>
	<table id="size1" cellpadding="1" cellspacing="1" border='0' valign='baseline' >

<% String temp1 = "";
   Iterator it = sizes.iterator();
   while(it.hasNext()){
	  temp1 = (String)it.next();
	   %>
	   <tr valign='baseline' ><%=drawCheckBox("size1data", temp1, temp1, false)%></tr>
	   <%
 }
%>
	</table>

  </td>
  <td>&nbsp;&nbsp;</td>
  <td nowrap > 
   <% 
        size2exists= FormatHelper.hasContent(sizeDataLabel2);
        if(size2exists){
       %>
      <table id="size2" cellpadding="1" cellspacing="1" border='0' valign='baseline' >

      <% Collection sizes2 = MOAHelper.getMOACollection(size2Data);
		 Iterator size2It = sizes2.iterator();
		  while(size2It.hasNext()) {
        String temp = (String)size2It.next();
        %>
        <tr valign='baseline' ><%= drawCheckBox("size2data", temp , temp, false)%></tr>
        <%
                
     }
     %> </table> 
    </td>
    </tr>
    <%}
    %>
    </td>
    </tr>
 </td>
	 
</table> 
 </td>
<script>
selectAllSizes();
</script>

<%
   } else {%>
<input type="hidden" name="size1data" value="">
<input type="hidden" name="size2data" value="">
<td></td>
 <%}%>
      

<%-- //////////////////Destination selection/////////////////////////////////--%>	
<%
Map hash1 = appContext.getProductDestinationsMap();
Map reversedDest = new HashMap();
Iterator keysDest = hash1.keySet().iterator();
String keyDest = "";
while(keysDest.hasNext()){
   keyDest = (String) keysDest.next();
   reversedDest.put(hash1.get(keyDest), keyDest);
}

Collection sortedDest = SortHelper.sortStrings(reversedDest.keySet());

Iterator destItr = sortedDest.iterator();

if (hash1.size() > 0) {
%>
<td nowrap valign='top' align='center'>
<table nowrap cellpadding="1" cellspacing="1" border='0'>
<col width='15%'><col width="35%">
   <tr><td><%=fg.createCustomActionBooleanInput("allDestinations", allLabel, DEFAULT_ALL_DESTINATIONS_CHECKED, "javascipt:toggleSelect(\'allDestinationsbox\', \'destinationdata\')", false)%></td></tr>
</table>
<table>
   <tr><td class="LABEL">&nbsp;</td></tr>
</table>
<table cellpadding="1" cellspacing="1" border='0' valign='baseline' align='center'>

<%
String numeric = "";
String label = "";
	while (destItr.hasNext())
	{
	   label = (String)destItr.next();
	   numeric = (String)reversedDest.get(label);
	   %>
	   <tr valign='baseline'><%=drawCheckBox("destinationdata", numeric, label, false)%></tr>
	   <%
	}
%> </table>
 </td>

 </table>
<%} else {%>
<input type="hidden" name="colorwaydata" value="">
<td></td>
<%}
 %>
<script>
toggleSelect('allDestinationsbox', 'destinationdata');
</script>

    <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>

<%-- //////////////////////Specification Components///////////////////////////--%>
        
		 <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle()%><%= specComponentsLabel%><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>
		
		 <table>
		 	<tr>
			<td></td>
			<% if(allComponents &&specRequestsMap != null && specRequestsMap.size() > 0) {%>
			<%=  fg.createDropDownListWidget(specRequestLabel, specRequestsMap, "printLayout", "", "javascipt:chooseView(document.MAINFORM.printLayout.value)", false)%>
			<%}%>
			<tr>
			</tr>
			<tr>
            <td>
            <% if(!childListOfComp.isEmpty() || !childDocs.isEmpty() || !childDescDocs.isEmpty()) { %>
                <%=fg.createCustomActionBooleanInput("includeChildSpecs", includeChildSpecifications, DEFAULT_CHILD_SPECS_CHECKED, "javascript:includeChildSpecsAndDocs()", false, false )%>
            <% }else{%>
                <input type="hidden" name="includeChildSpecsbox" value="">
            <%}%>
            </td>
			</tr>
			<tr>
			</tr>
			<tr>
			<td>
		    <%= fg.createMultiChoice("specPages", availableComponentsLabel, listOfComp, componentSelectedValues, false, null, false, null, "10", "javascript:updatePage()") %> 
			</td>
			<% if(!allComponents) { %>
			<SCRIPT>
			document.MAINFORM.specPagesOptions.disabled=true;
			document.MAINFORM.specPagesChosen.disabled=true;
			</SCRIPT>
			<% }%>
			<td>
			<table>
				<tr><td>
				<a title='<%= LCSMessage.getHTMLMessage(RB.MAIN, "moveUp_LBL", RB.objA, false)%>' id='sizeRunmoveUpList' href='javascript:moveUpList(document.MAINFORM.specPagesChosen, document.MAINFORM.specPages);'><img src='<%=WT_IMAGE_LOCATION%>/page_up.png' border='1' alt='<%= FormatHelper.formatHTMLString(moveUpLabel, false)%>'></a>
				</td></tr>
				<tr><td>
				<a title='<%= FormatHelper.formatHTMLString(moveDownLabel,false)%>' id='sizeRunmoveDownList' href='javascript:moveDownList(document.MAINFORM.specPagesChosen, document.MAINFORM.specPages);'><img src='<%=WT_IMAGE_LOCATION%>/page_down.png' border='1' alt='<%= FormatHelper.formatHTMLString(moveDownLabel, false)%>'></a>
				</td></tr>
			</table>
			</td>
			</tr>

         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>

         <% 
		 //Custom code to display samples -- START
		 if (listOfSamples.isEmpty()) { %>
		 <input type="hidden" name="availSamples" id="availSamples" value="">
         <% } else { %>
  
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle()%><%= sampleRequestNameLabel %><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>
         
		 </table>
		 <table>
		 <tr><td>
                <%= fg.createMultiChoice("availSamples", sampleRequestNameLabel, listOfSamples, sampleReqSelectedValues, false, null, false, null, "10", "javascript:updateSample()") %>
         </td>
		 </tr>
		 </table>
 		 
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
         <% } 
		 //Custom code to display samples -- END
		 %>
		 
		 
         <% if (listOfDocs.isEmpty() && listOfDescDocs.isEmpty()) { %>
         <input type="hidden" name="includeSecondaryContent" id="includeSecondaryContent" value="">
         <% } else { %>
         <%= tg.startGroupBorder() %>
         <table>
         <tr><td>
            <%=fg.createCustomActionBooleanInput("includeSecondaryContent", includeSecondaryLabel, "false","javascript:setIncludeSecondary(this);", false) %>
         </td></tr>
         </table>
         <%= tg.endBorder() %>
         <% } %>

         <% if (listOfDocs.isEmpty()) { %>
		 <input type="hidden" name="availDocs" id="availDocs" value="">
         <input type="hidden" name="docOptionsOptions" id="docOptionsOptions" value="">
         <% } else { %>
  
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle()%><%= availableDocumentsLabel %><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>
         
		 </table>
		 <table>
		 <tr><td>
                <%= fg.createMultiChoice("availDocs", availableDocumentsLabel, listOfDocs, docContentSelectValue, false, null, false, null, "10", "javascript:updateDoc()") %>
         </td><td>
			<table>
				<tr><td>
				<a title='<%= LCSMessage.getHTMLMessage(RB.MAIN, "moveUp_LBL", RB.objA, false)%>' id='sizeRunmoveUpList' href='javascript:moveUpList(document.MAINFORM.availDocsChosen, document.MAINFORM.availDocs);'><img src='<%=WT_IMAGE_LOCATION%>/page_up.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveUpLabel, false)%>'></a>
				</td></tr>
				<tr><td>
				<a title='<%= FormatHelper.formatHTMLString(moveDownLabel,false)%>' id='sizeRunmoveDownList' href='javascript:moveDownList(document.MAINFORM.availDocsChosen, document.MAINFORM.availDocs);'><img src='<%=WT_IMAGE_LOCATION%>/page_down.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveDownLabel, false)%>'></a>
				</td></tr>
			</table>
		 </td></tr>
		 </table>
 
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
         <% } %>
  
         <% if (listOfDescDocs.isEmpty()) { %>
         <input type="hidden" name="availDescDocs" id="availDescDocs" value="">
         <input type="hidden" name="docOptionsOptions" id="docOptionsOptions" value="">
         <% } else { %>
  
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle()%><%= availDescDocsLabel %><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>
         
         </table>
         <table>
         <tr><td>
                <%= fg.createMultiChoice("availDescDocs", availDescDocsLabel, listOfDescDocs, docContentSelectValue1, false, null, false, null, "10", "javascript:updateDoc()") %>
         </td><td>
            <table>
                <tr><td>
                <a title='<%= LCSMessage.getHTMLMessage(RB.MAIN, "moveUp_LBL", RB.objA, false)%>' id='sizeRunmoveUpList' href='javascript:moveUpList(document.MAINFORM.availDescDocsChosen, document.MAINFORM.availDescDocs);'><img src='<%=WT_IMAGE_LOCATION%>/page_up.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveUpLabel, false)%>'></a>
                </td></tr>
                <tr><td>
                <a title='<%= FormatHelper.formatHTMLString(moveDownLabel,false)%>' id='sizeRunmoveDownList' href='javascript:moveDownList(document.MAINFORM.availDescDocsChosen, document.MAINFORM.availDescDocs);'><img src='<%=WT_IMAGE_LOCATION%>/page_down.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveDownLabel, false)%>'></a>
                </td></tr>
            </table>
         </td></tr>
         </table>
 
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
         <% } %>

      
<div id="CADDocumentDiv">
<% if (CADDOC_ENABLED&& !specLinks.isEmpty()) { %>
    <%= tg.startGroupBorder() %>
	<%= tg.startTable() %>
	<%= tg.startGroupTitle() %><%=availableCADDocGrpHdr%><%= tg.endTitle() %>
	<%= tg.startGroupContentTable() %>
	 <table width="45%">
		 <tr>
		 <td>
                <%= fg.createMultiChoice("availEPMDOCDocs", availableCADDocLbl, specLinks, "", false, null, false, null, "10", "") %>
         </td><td>
            <table>
                <tr><td>
                <a title='<%= LCSMessage.getHTMLMessage(RB.MAIN, "moveUp_LBL", RB.objA, false)%>' id='sizeRunmoveUpList' href='javascript:moveUpList(document.MAINFORM.availEPMDOCDocsChosen, document.MAINFORM.availEPMDOCDocs);'><img src='<%=WT_IMAGE_LOCATION%>/page_up.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveUpLabel, false)%>'></a>
                </td></tr>
                <tr><td>
                <a title='<%= FormatHelper.formatHTMLString(moveDownLabel,false)%>' id='sizeRunmoveDownList' href='javascript:moveDownList(document.MAINFORM.availEPMDOCDocsChosen, document.MAINFORM.availEPMDOCDocs);'><img src='<%=WT_IMAGE_LOCATION%>/page_down.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveDownLabel, false)%>'></a>
                </td></tr>
            </table>
         </td></tr>
         <%-- B-92545
	  <tr><td><%= fg.createDropDownListWidget(cadDocFilterLabel, saveFilters, "cadDocFilter", "", null, false)%></td></tr>
	 --%> 
   </table>
   <%= tg.endTable() %>
   <%= tg.endTableContentTable() %>
    <%= tg.endBorder() %>
    <div style ="border-left:770px solid #dfdfdf;height:1px;overflow:hidden;margin:0;margin-top:-17px;margin-left:8px;margin-right:8px;"> </div>

<%}else{%>
         <input type="hidden" name="availEPMDOCDocs" id="availEPMDOCDocs" value="">
         <%-- B-92545
         <input type="hidden" name="cadDocFilter" id="cadDocFilter" value="">
         --%>

<% } %>
</div>

<div id="PartsDiv" style ="margin-left:8px;margin-right:8px;">
<% if (PART_ENABLED&& !partTOSpecLinks.isEmpty()) { %>
    <%= tg.startGroupBorder() %>
	<%= tg.startTable() %>
	<%= tg.startGroupTitle() %>
	<%=availablePartGrpHdr%>
    <%= tg.endTitle() %>
	<%= tg.startGroupContentTable() %>
	 <table >
		 <tr>
		 <td>
                <%= fg.createMultiChoice("availParts", availablePartLbl, partTOSpecLinks, "", false, null, false, null, "10", "") %>
         </td><td>
            <table>
                <tr><td>
                <a title='<%= LCSMessage.getHTMLMessage(RB.MAIN, "moveUp_LBL", RB.objA, false)%>' id='sizeRunmoveUpList' href='javascript:moveUpList(document.MAINFORM.availPartsChosen, document.MAINFORM.availParts);'><img src='<%=WT_IMAGE_LOCATION%>/page_up.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveUpLabel, false)%>'></a>
                </td></tr>
                <tr><td>
                <a title='<%= FormatHelper.formatHTMLString(moveDownLabel,false)%>' id='sizeRunmoveDownList' href='javascript:moveDownList(document.MAINFORM.availPartsChosen, document.MAINFORM.availParts);'><img src='<%=WT_IMAGE_LOCATION%>/page_down.png' border='1' alt='<%= FormatHelper.formatJavascriptString(moveDownLabel, false)%>'></a>
                </td></tr>
            </table>
         </td></tr>
	
   </table>
   <%= tg.endTable() %>
   <%= tg.endTableContentTable() %>
    <div style = "border-left:770px solid #dfdfdf;height:1px;overflow:hidden;margin:0;margin-top:-10px;margin-left:8px;margin-right:8px;"> </div>
<%}else{%>
         <input type="hidden" name="availParts" id="availParts" value="">
         <input type="hidden" name="partFilter" id="partFilter" value="">

<% } %>
</div>

<%-- //////////////////////////////Page Options///////////////////////////////////--%>

<%= tg.startGroupBorder() %>
<%= tg.startTable() %>
<%= tg.startGroupTitle()%><%= pageOptionsGrpTle%><%= tg.endTitle() %>
<%= tg.startGroupContentTable() %>
<%-- Other Options--%>
<tr>
   <td class="SUBSECTION">
	  <div id='pageOptionsdiv_plus'>
		 <a href="javascript:changeDiv('pageOptionsdiv')"><img src="<%=WT_IMAGE_LOCATION%>/collapse_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
		 <a href="javascript:changeDiv('pageOptionsdiv')"><%= pageOptionsLabel%></a>
	  </div>
	  <div id='pageOptionsdiv_minus'>
		 <a href="javascript:changeDiv('pageOptionsdiv')"><img src="<%=WT_IMAGE_LOCATION%>/expand_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
		 <a href="javascript:changeDiv('pageOptionsdiv')"><%= pageOptionsLabel%></a>
	  </div>
   </td>
</tr>
<tr>
   <td>
	 <div id='pageOptionsdiv'>
	  <table>
		 <tr><td>
		 <%=fg.createIntegerInput("numColorwaysPerPage", numberColorwaysPerPageLabel, "", 2, 0, 0, false, true, false )%>
		 </td></tr>
		 <tr><td>
		 <%=fg.createIntegerInput("numSizesPerPage", numberSizesPerPageLabel, "", 2, 0, 0, false, true, false )%>
		 <%-- // Build 6.11 - START
			 // Disabling "Number of sizes per page" user selection
		--%>
		<SCRIPT>
		document.MAINFORM.numSizesPerPageInput.disabled=true;
		</SCRIPT>
		<%-- // Build 6.11 - END
		--%>
		 </td></tr>
		 <tr><td>
		 <%=fg.createStandardBooleanInput("showColorSwatches", showColorSwatchesLabel, false, false)%>
		 </td></tr>
		 <tr><td>
		 <%=fg.createStandardBooleanInput("showMaterialThumbnail", showMaterialThumbnailsLabel, false, false)%>
		 </td></tr>
		 <tr><td>

		 <!-- ******************* Issue 219,268 changes ***************************** -->

		 <!--  Setting default value of measurement UOM as Fractional in -->
		 <!-- Build 6.19 : default unit of measure driven from property entry : Start -->
         <%=fg.createDropDownListWidget(measurementUOMOverrideLabel, formats, "uom", "defaultUnitOfMeasure", null, false, false) %>
		 <!--Build 6.19 : default unit of measure driven from property entry : End-->
		 <!-- ************************************************************************* -->
		 </td></tr>
		 <tr><td>
		 <%	if(FormatHelper.hasContent(sizeDataLabel2)) {
		 Map sizeCats = new HashMap();
		 sizeCats.put("size1", sizeDataLabel);
		 sizeCats.put("size2", sizeDataLabel2);	
		 Vector order = new Vector();
		 order.add("size1");
		 order.add("size2");
		 Object[] objB = {sizeDataLabel, sizeDataLabel2};
	     String useSize1Size2Label = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "useSize1OrSize2_LBL", objB) ;

		 %><%= fg.createDropDownListWidget(useSize1Size2Label, sizeCats, "useSize1Size2", "size1", "", false, false, order) %>
		 <%} else { %>
		 <input type="hidden" name="useSize1Size2" id="useSize1Size2" value="size1">
		 <% } %>
		 </td></tr>

	  </table>
	 </div>
   </td>
</tr>
<script>
   toggleDiv('pageOptionsdiv');
   toggleDiv('pageOptionsdiv_minus');
</script>
<tr>
   <td><hr></td>
</tr>
<%-- Reports--%>
<tr>
   <td>
	 <table>
	 <%= fg.createMultiChoice("pageOptions", availableReportsLabel, allOptions, null, false, null, false, null, "6", "javascript:updatePage()") %>
	  </td>
	  <td>
		  <table>
				  <tr><td>
				  <a title='<%= FormatHelper.formatHTMLString(moveUpLabel,false)%>' id='sizeRunmoveUpList' href='javascript:moveUpList(document.MAINFORM.pageOptionsChosen, document.MAINFORM.pageOptions);'><img src='<%=WT_IMAGE_LOCATION%>/page_up.png' border='1' alt='<%=FormatHelper.formatJavascriptString(moveUpLabel, false)%>'></a>
				  </td></tr>
				  <tr><td>
				  <a title='<%= FormatHelper.formatHTMLString(moveDownLabel,false)%>' id='sizeRunmoveDownList' href='javascript:moveDownList(document.MAINFORM.pageOptionsChosen, document.MAINFORM.pageOptions);'><img src='<%=WT_IMAGE_LOCATION%>/page_down.png' border='1' alt='<%=FormatHelper.formatJavascriptString(moveDownLabel, false)%>'></a>
				  </td></tr>
			  </table>
	  </table>
   </td>
</tr>
<%-- Section Views--%>
<tr><td>
   <% Iterator bomOptionsIt = bomOptions.iterator();
   Iterator bomTypesIt;
   AttributeValueList sectionAttList;
   Collection section = new ArrayList();
   Iterator sectionItr;
   String editBomActivity = "EDIT_BOM";
   Collection reportColumns = new ArrayList();
   Map reportOptions = new HashMap();
   String defaultViewId = "";
   String bomOption = "";
   FlexType bomType;
   FlexObject fobj;
   String bomTypeId = "";
   if( (bomOptions != null && bomOptions.size() >0) && (bomTypes != null && bomTypes.size() > 0)) {
   while(bomOptionsIt.hasNext()) {
	  bomOption = (String)bomOptionsIt.next();
	  bomTypesIt = bomTypes.iterator();%>
	  <div nowrap id="<%=bomOption+"div"%>">
	  <table id="<%=bomOption%>" border='0' width='100%'>
		<%while(bomTypesIt.hasNext()) {
		 bomType = (FlexType)bomTypesIt.next();
         bomTypeId = FormatHelper.getNumericObjectIdFromObject(bomType);
		 lcsContext.viewCache.clearCache(FormatHelper.getObjectId(bomType), editBomActivity );
		 reportColumns = lcsContext.viewCache.getViews(FormatHelper.getObjectId(bomType), editBomActivity);
		 defaultViewId = lcsContext.viewCache.getDefaultViewId(FormatHelper.getObjectId(bomType), editBomActivity);
		 if(reportColumns != null && reportColumns.size() > 0) {//If we don't have any views, don't draw the div
			Object[] objC = {bomType.getFullNameDisplay(true)};%>
			<tr>
                <td class="SUBSECTION" nowrap colspan='2'> 
                  <div id='<%= bomOption %>_<%= bomTypeId %>_div_plus'>
                     <a href="javascript:changeDiv('<%= bomOption %>_<%= bomTypeId %>_div')"><img src="<%=WT_IMAGE_LOCATION%>/collapse_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
                     <a href="javascript:changeDiv('<%= bomOption %>_<%= bomTypeId %>_div')"><%=bomOptionsMap.get(bomOption) + ":  " + WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "type_LBL", objC )+ "  "+ viewOptionsLabel%></a>
                  </div>
                  <div id='<%= bomOption %>_<%= bomTypeId %>_div_minus'>
                     <a href="javascript:changeDiv('<%= bomOption %>_<%= bomTypeId %>_div')"><img src="<%=WT_IMAGE_LOCATION%>/expand_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
                     <a href="javascript:changeDiv('<%= bomOption %>_<%= bomTypeId %>_div')"><%=bomOptionsMap.get(bomOption) + ":  " + WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "type_LBL", objC ) + "  "+ viewOptionsLabel%></a>
                  </div>
                </td>
            </tr> 
<%
			   sectionAttList = bomType.getAttribute("section").getAttValueList();
			   section = sectionAttList.getSelectableKeys(lcsContext.getContext().getLocale(), true);

			   sectionItr = section.iterator();
%>
			<tr>
                <td>
                    <div id='<%= bomOption %>_<%= bomTypeId %>_div'>
                    <table>
<%
			   while (sectionItr.hasNext()){
				  String secID = (String)sectionItr.next(); %>
			   <tr>
				  <%reportOptions = new HashMap();
					Iterator ri = reportColumns.iterator();
					while(ri.hasNext()) {
					 fobj = (FlexObject)ri.next();
					 reportOptions.put(bomOption + TYPE_COMP_DELIM + FormatHelper.getObjectId(bomType)+ TYPE_COMP_DELIM + secID + TYPE_COMP_DELIM+"ColumnList:"+fobj.getString("COLUMNLIST.IDA2A2"),fobj.getString("COLUMNLIST.DISPLAYNAME"));
					}
					String selectedViewId = null;
					if(FormatHelper.hasContent(defaultViewId)){
					 selectedViewId = bomOption + TYPE_COMP_DELIM + FormatHelper.getObjectId(bomType)+ TYPE_COMP_DELIM + secID + TYPE_COMP_DELIM+"ColumnList"+ defaultViewId.substring(defaultViewId.lastIndexOf(":"));
					}
					%><%=fg.createDropDownListWidget(sectionAttList.getValue(secID, lcsContext.getContext().getLocale()), reportOptions, "viewSelect", selectedViewId, "", false) %>
			   </tr>
			<%}//End section loop%>
                    </div>
                    </table>
                </td>
            </tr>
<script>
    toggleDiv('<%= bomOption %>_<%= bomTypeId %>_div_plus');
</script>
<tr><td><hr></td><tr>
		 <%}%>
	  <%}//End bomType loop
%>
	  </table></div>
	  <script>
	  document.getElementById('<%=bomOption +"div"%>').style.display ='none';
	  </script>
<%
   }//End bom options loop
   } else {%>
   <input type="hidden" name="viewSelect" value="">
   <%}%>

</td></tr>
<!--add for story B-58112 03/28/2011-->
<tr><td>
<div id="divTrackedChanges" style="display:none">
<table id="tblTrackedChanges" border='0' width='100%'>
<tr>
	<td class="SUBSECTION" nowrap colspan='2'> 
	<div id='trackedChanges_div_plus'>
		<a href="javascript:changeDiv('trackedChanges_div')"><img src="<%=WT_IMAGE_LOCATION%>/collapse_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
		<a href="javascript:changeDiv('trackedChanges_div')"><%=trackedChangesLabel + " : "+ showChangeSinceLabel%></a>
	</div>
	<div id='trackedChanges_div_minus'>
		<a href="javascript:changeDiv('trackedChanges_div')"><img src="<%=WT_IMAGE_LOCATION%>/expand_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
		<a href="javascript:changeDiv('trackedChanges_div')"><%=trackedChangesLabel + " : "+ showChangeSinceLabel%></a>
    </div>
    </td>
</tr>

<tr>
	<td>
	<div id="trackedChanges_div">
		<!-- span class="FORMLABEL" style="display:inline-block;width:150px;font-size:11px;padding:0;"><%=showChangeSinceLabel %>:</span-->
		
		<%=fg.createHiddenInput("showChangeSince", "") %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%= fg.createDropDownList(daysDisplayMap, "daysValueId", showChangeSinceDefault, "changeSinceDate()", 1,false,null,daysOrder) %>
		<span id="sinceDateCal" style="display:none;">
			<%=FormGenerator.createDateInputField("sinceDate","","",10,10,false)%>
		</span> 
		<span id="dateTimeDisplay" class="FORMLABEL" style="display:none;"></span>
	</div>
	</td>
</tr>
<script>
    toggleDiv('trackedChanges_div_plus');
</script> 
<tr><td><hr></td></tr>
</table>
</div>
</td></tr>

<tr>
	<td>
<div id="divSpecPart" style="display:none">
<table id="tblSpecPart" border='0' width='100%'>
<tr>
	<td class="SUBSECTION" nowrap colspan='2'> 
	<div id='partData_div_plus'>
		<a href="javascript:changeDiv('divExportedIndentedBOM')"><img src="<%=WT_IMAGE_LOCATION%>/collapse_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
		<a href="javascript:changeDiv('divExportedIndentedBOM')"><%=partDataOptionsLabel%></a>
	</div>
	<div id='partData_div_minus'>
		<a href="javascript:changeDiv('divExportedIndentedBOM')"><img src="<%=WT_IMAGE_LOCATION%>/expand_tree.png" alt="" border="0" align="absmiddle"></a>&nbsp;&nbsp;
		<a href="javascript:changeDiv('divExportedIndentedBOM')"><%=partDataOptionsLabel%></a>
    </div>
    </td>
</tr>
<tr><td>
<div id="divExportedIndentedBOM">
<table id="tblexportedIndentedBOM" border='0' width='20%'>
<tr><td>
<%=fg.createCustomActionBooleanInput("exportedIndentedBOM", showIndentedBOMLabel, "false", "javascript:changePartFilter();", false, true) %>
</td>
</tr>
 <tr><td><%= fg.createDropDownListWidget(partFilterLabel, savePartFilters, "partFilter", "Default", null,false,false)%></td></tr>
</table>
</div>
</td></tr>
<script>
    toggleDiv('partData_div_plus');
</script> 
<tr><td><hr></td></tr>
</table>
</div>
</td></tr>

<%= tg.endContentTable() %>
<%= tg.endTable() %>
<%= tg.endBorder() %>
<%-- ////////////////////////////// End Page Options///////////////////////////////////--%>
<%if (ACLHelper.hasViewAccess(defaultDocumentVaultType)&&ACLHelper.hasCreateAccess(defaultDocumentVaultType)){ %>

<div id="documentVaultDiv">
	         <%= tg.startGroupBorder() %>
	         <%= tg.startTable() %>
	         <%= tg.startGroupTitle("DocumentVaultGroup") %>
	         <%=vaultDocumentsLabel%>
	         <%= tg.endTitle() %>
	         <%= tg.startGroupContentTable("DocumentVaultGroup") %>

         <table width="45%"><tr>
                 <%=fg.createCustomActionBooleanInput("asynchronousGeneration", asynchGenLabel, "false", "javascript:setAsynchGen(this);", false, true) %>
            </tr><tr>
                <%=fg.createCustomActionBooleanInput("documentVault", vaultDocumentsLabel, "false", "javascript:setDocumentVaultDiv(this);", false, false) %>
            </tr><tr>
             <td class="FORMLABEL" align="left" nowrap width="150px"><div id="refTypeDiv" nowrap>&nbsp;&nbsp;<a href="javascript:chooseVaultDocumentType()"><%= vaultDocumentTypeLabel %></a>&nbsp;</div></td>
             <td class="FORMELEMENT"  align="left" nowrap>
                <b><div id="fkTypeDisplay" nowrap>------</div></b>
             </td>
      </tr>
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
</div>
<%} %>
<table> <tr> 
    <td class="button" align="right">
    <a class="button" href="javascript:selectSpecificationPages(<%=size2exists%>)"><%= selectButton %></a>&nbsp;&nbsp;&nbsp;
   </td>
</tr> </table> 
<script>
<%
if (ACLHelper.hasViewAccess(defaultDocumentVaultType)&&ACLHelper.hasCreateAccess(defaultDocumentVaultType)){
	if (!"SPEC_SUMMARY".equals(tabPage)){%>
		document.getElementById('documentVaultDiv').style.display ='none';
	<%}%>
	document.getElementById('fkTypeDisplay').innerHTML = '<%=FormatHelper.formatJavascriptString(FlexTypeCache.getFlexTypeFromPath(DEFAULT_DOCUMENT_VAULT_TYPE).getFullNameDisplay())%>';
	document.MAINFORM.vaultDocumentTypeId.value = '<%=FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath(DEFAULT_DOCUMENT_VAULT_TYPE))%>';
	hideDocumentVaultDiv();
	<%if(DEFAULT_ASYNC_SINGLE_TPGENERATION){%>
	   var dvCheckBox = document.getElementById('documentVaultbox');
	   var dvInput = document.getElementById('documentVault');
	   var agCheckBox = document.getElementById('asynchronousGenerationbox');
	   var agInput = document.getElementById('asynchronousGeneration');
	   dvCheckBox.disabled = 'true';
	   dvCheckBox.checked = 'true';
	   dvInput.value = true;
	   agCheckBox.checked='true';
	   agInput.value = true;
	   showDocumentVaultDiv();
	<%}%>
<%}%>
includeChildSpecsfunction();
includeChildDocsFunction();
includeChildDescDocsFunction();
//modified to enable runnning in background for LFUSA
//runInBackGround checkbox is set as true as the default value
var runInBackGround = document.getElementById('asynchronousGenerationbox');

//13 May 2014/Girish - Added IF condition to enable Tech Pack generation in Background based on selections made on Choosr Page.
// ELSE Condition to disable Tech Pack generation in Background when triggered from BOM Page
// "isBOMComponent" will be TRUE only if Tech Pack is generated from BOM Page

	<%if (!isBOMComponent){ %>
	 runInBackGround.checked = 'true';
	<%}%>
	<%if (isBOMComponent){ %>
	 runInBackGround.checked = 'false';
	<%}%>

setAsynchGen(runInBackGround);

</script>
