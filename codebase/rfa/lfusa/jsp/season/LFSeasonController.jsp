<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// PAGE DOCUMENTATION//////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%--
    JSP Type: Controller
--%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ControlException.jsp"
        import="com.lcs.wc.db.SearchResults,
            com.lcs.wc.client.web.PageManager,
                com.lcs.wc.client.web.WebControllers,
                com.lcs.wc.client.Activities,
                com.lcs.wc.foundation.*,
                com.lcs.wc.flextype.*,
                com.lcs.wc.db.*,
                com.lcs.wc.season.*,
                com.lcs.wc.planning.*,
                com.lcs.wc.placeholder.*,
                java.util.*,
                wt.util.*,
                com.infoengine.object.factory.*,
                com.lfusa.wc.calendar.LFDashboardReportConstants,
                com.lcs.wc.product.*,
                com.lfusa.wc.reports.query.*,
                com.lcs.wc.util.*"
				
%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INCLUDED FILES  //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>
<% wt.util.WTContext.getContext().setLocale(request.getLocale());%>
<jsp:useBean id="seasonModel" scope="request" class="com.lcs.wc.season.LCSSeasonClientModel" />
<jsp:useBean id="linePlanConfig" scope="session" class="com.lcs.wc.season.LinePlanConfig" />

<%-- DMF 02/07/07  --%>
<jsp:useBean id="productModel" scope="request" class="com.lcs.wc.product.LCSProductClientModel" />

<%@ taglib uri="http://www.ptc.com/infoengine/taglib/core" prefix="ie" %>
<ie:getService varName="ie"/>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// STATIS JSP CODE //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>

<%
   String viewSeasonPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "viewSeason_PG_TLE",RB.objA ) ;
   String createPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "create_PG_TLE",RB.objA ) ;
   String viewPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "view_PG_TLE",RB.objA ) ;
   String updatePgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "update_PG_TLE",RB.objA ) ;
   String detailsPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "details_PG_TLE",RB.objA ) ;
   String styleSheetPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "styleSheet_PG_TLE",RB.objA ) ;
   String searchCriteriaPgTle = WTMessage.getLocalizedMessage ( RB.MAIN, "searchCriteria_PG_TLE",RB.objA ) ;
   String searchResultsPgTle = WTMessage.getLocalizedMessage ( RB.MAIN, "searchResults_PG_TLE",RB.objA ) ;
   String linePlanPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "linePlan_LBL",RB.objA ) ;
    String selectProductsPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "selectProducts_PG_TLE",RB.objA ) ;
   String seasonGroupTypePgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "seasonGroupOptions_GRP_TLE",RB.objA ) ;
   String seasonDashboardsPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "seasonDashboards_PG_TLE",RB.objA ) ;
   String seasonCalendarPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "seasonCalendar_PG_TLE",RB.objA ) ;
   String changeReportPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "changeReport_OPT",RB.objA ) ;
   String materialCommitmentReportPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "materialCommitmentReport_PG_TLE",RB.objA ) ;
   String costsRecalculatedMsg = WTMessage.getLocalizedMessage ( RB.SEASON, "costsRecalculated_MSG",RB.objA ) ;
   String bulkUpdateError1Msg = WTMessage.getLocalizedMessage ( RB.EXCEPTION, "bulkUpdateError1_MSG",RB.objA ) ;
   String bulkUpdateError2Msg = WTMessage.getLocalizedMessage ( RB.EXCEPTION, "bulkUpdateError2_MSG",RB.objA ) ;
   String seasonLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "seasonColon_LBL", RB.objA ) ;
   String massCopyProducts = WTMessage.getLocalizedMessage ( RB.SEASON, "massCopyProduct_PG_TLE",RB.objA ) ;
   String planningLabel = WTMessage.getLocalizedMessage ( RB.PLAN, "planning_LBL", RB.objA ) ;
   String phGenerated = WTMessage.getLocalizedMessage ( RB.SEASON, "placeholdersGenerated_MSG",RB.objA ) ;
   String colorManagerPgTle = WTMessage.getLocalizedMessage ( RB.SEASON, "colorManager_PG_TLE",RB.objA ) ;
%>
<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final String JSPNAME = "SeasonController";
    public static final boolean DEBUG = LCSProperties.getBoolean("jsp.part.SeasonController.verbose");
    public static final String MAINTEMPLATE = PageManager.getPageURL("MAINTEMPLATE", null);
	public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static String instance = "";
    static {
        try {
            instance = wt.util.WTProperties.getLocalProperties().getProperty ("wt.federation.ie.VMName");
        } catch(Exception e){
            e.printStackTrace();
        }
    }

%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
    String activity = request.getParameter("activity");
    String action = request.getParameter("action");
    String oid = request.getParameter("oid");
    String returnActivity = request.getParameter("returnActivity");
    String returnAction = request.getParameter("returnAction");
    String returnOid = request.getParameter("returnOid");
    boolean checkReturn = false;
    String additionalParameters = request.getParameter("additionalParameters");
    if(!FormatHelper.hasContent(additionalParameters)){
        additionalParameters = "";
    }
    String workItemName = request.getParameter("workItemName");
    boolean multiple = true;
    if (FormatHelper.hasContent(request.getParameter("multiple"))) {
        multiple = FormatHelper.parseBoolean(request.getParameter("multiple"));
    }
    boolean linePlanChooser = false;
    if(FormatHelper.hasContent(request.getParameter("linePlanChooser"))){
        linePlanChooser = FormatHelper.parseBoolean(request.getParameter("linePlanChooser"));
    }

    String title = "";
    String errorMessage = request.getParameter("errorMessage");
	if (FormatHelper.hasContent(errorMessage)) {
		errorMessage = java.net.URLDecoder.decode(errorMessage, defaultCharsetEncoding);
	} else {
	  errorMessage = "";
	}
    String infoMessage = request.getParameter("infoMessage");
	infoMessage= (FormatHelper.hasContent(infoMessage))?java.net.URLDecoder.decode(infoMessage, defaultCharsetEncoding):"";
	
    String view = null;
    String type = "";

    String popupURL = "";

    FlexType flexType = null;
    String contextHeaderPage = "SEASON_CONTEXT_BAR";
    String formType = "standard";
	if(FormatHelper.hasContent(request.getParameter("formType"))){
		formType = request.getParameter("formType");
	}
	
   ///////////////////////////////////////////////////////////////////
    if(Activities.VIEW_SEASON.equals(activity)){
        lcsContext.setCacheSafe(true);
        seasonModel.load(oid);
        view = PageManager.VIEW_SEASON_PAGE;
        title = viewSeasonPgTle;
        flexType = seasonModel.getFlexType();
        appContext.setSeasonContext(oid);
    ///////////////////////////////////////////////////////////////////
    } else if("CREATE_SEASON".equals(activity)){
        if(action == null || "INIT".equals(action) || "".equals(action)){
            lcsContext.setCacheSafe(true);
            title = createPgTle + " "  + seasonLabel;
            view = PageManager.CLASSIFY_PAGE;

        } else if("CLASSIFY".equals(action)){
            lcsContext.setCacheSafe(true);
            AttributeValueSetter.setAllAttributes(seasonModel, RequestHelper.hashRequest(request));
            if(FormatHelper.hasContent(request.getParameter("directClassifyId"))){
                seasonModel.setTypeId(request.getParameter("directClassifyId"));
            }
            title = createPgTle + " "  + seasonLabel;;
            view = PageManager.CREATE_SEASON_PAGE;

        } else if("SAVE".equals(action)){

             try {
                AttributeValueSetter.setAllAttributes(seasonModel, RequestHelper.hashRequest(request));
                seasonModel.setActive(true);
                seasonModel.save();

                appContext.loadSeasonList(true);
                oid = FormatHelper.getObjectId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = viewPgTle + " "  + seasonLabel;
                action = "INIT";
                activity = Activities.VIEW_SEASON;
                checkReturn = true;
                
                additionalParameters = additionalParameters + "&forceReloadSeasonDropdown=true";
               } catch(LCSException e){
                    view = PageManager.CREATE_SEASON_PAGE;
                    title = createPgTle + " "  + seasonLabel;
                    errorMessage=e.getLocalizedMessage();
                    checkReturn = true;
               }
        }

        flexType = seasonModel.getFlexType();
    ///////////////////////////////////////////////////////////////////
    } else if(Activities.UPDATE_SEASON.equals(activity)){
        appContext.setSeasonContext(oid);
        if(action == null || "INIT".equals(action) || "".equals(action)){
            lcsContext.setCacheSafe(true);
            seasonModel.load(oid);
            view = PageManager.UPDATE_SEASON_PAGE;
            title = updatePgTle + " "  + seasonLabel;

        } else if("CHECKIN".equals(action)){

         seasonModel.load(oid);
         seasonModel.checkin();
          oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
         view = PageManager.SAFE_PAGE;
         title = seasonLabel + " " + detailsPgTle;
         action = "INIT";
         activity = Activities.VIEW_SEASON;
         checkReturn = true;

        } else if("SAVE".equals(action)){
            try{
                seasonModel.load( request.getParameter("oid"));
                AttributeValueSetter.setAllAttributes(seasonModel, RequestHelper.hashRequest(request));
                seasonModel.save();
                oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());

                view = PageManager.SAFE_PAGE;
                title = seasonLabel + " " + detailsPgTle ;
                action = "INIT";
                activity = Activities.VIEW_SEASON;
                checkReturn = true;
                
                additionalParameters = additionalParameters + "&forceReloadSeasonDropdown=true";

            } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.UPDATE_SEASON_PAGE;
                title = updatePgTle + " "  + seasonLabel;
                checkReturn = true;
            }

        } else if("ADD_PRODUCTS".equals(action) || "ADD_PRODUCTS_SEASON_AND_PLACEHOLDER".equals(action)){
            try{

            String newIds = request.getParameter("newIds");
            Collection ids = MOAHelper.getMOACollection(newIds);
            seasonModel.load(oid);
            LCSMaterialGroup materialGroup = null;
            if(FormatHelper.hasContent(request.getParameter("materialGroupId"))){
                materialGroup = (LCSMaterialGroup) LCSQuery.findObjectById(request.getParameter("materialGroupId"));

            }
            seasonModel.addProducts(ids, materialGroup);

            if("ADD_PRODUCTS".equals(action) ){
                oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                action = "LINEPLAN"; 
                activity = "VIEW_LINE_PLAN";
                checkReturn = true;
            } else{ 
			//ADD_PRODUCTS_SEASON_AND_PLACEHOLDER                
                action = "";
                activity = Activities.ADD_PRODUCTS_TO_PLACEHOLDER;
                additionalParameters = additionalParameters + "&placeholderId=" + request.getParameter("placeholderId") + "&productIds=" + newIds;
                oid = request.getParameter("placeholderId");
            }
            view = PageManager.SAFE_PAGE;
            } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                checkReturn = true;
            }

        } else if("ADD_SKUS".equals(action)){
            try{

            String newIds = request.getParameter("newIds");
            Collection ids = MOAHelper.getMOACollection(newIds);
            seasonModel.load(oid);
            LCSMaterialGroup materialGroup = null;
            if(FormatHelper.hasContent(request.getParameter("materialGroupId"))){
                materialGroup = (LCSMaterialGroup) LCSQuery.findObjectById(request.getParameter("materialGroupId"));

            }
            seasonModel.addSKUs(ids, materialGroup);

                oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                action = "LINEPLAN";
                activity = "VIEW_LINE_PLAN";
                checkReturn = true;

            } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                checkReturn = true;
            }


        } else if("REMOVE_PRODUCT".equals(action)){
            try{
                String id = request.getParameter("productId");
                seasonModel.load(oid);
                seasonModel.removeProduct(id);
                oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                action = "LINEPLAN";
                activity = Activities.VIEW_SEASON_REPORT;
                checkReturn = true;
                appContext.clearAppContext();
            	additionalParameters = additionalParameters + "&reloadFavorites=true";
            } 
			catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                checkReturn = true;
            }

        } else if("REMOVE_SKU".equals(action)){
            try{
            String id = request.getParameter("skuId");
            seasonModel.load(oid);
            seasonModel.removeSKU(id);
                oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                action = "LINEPLAN";
                activity = Activities.VIEW_SEASON_REPORT;
                checkReturn = true;
                appContext.clearAppContext();
            } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                checkReturn = true;
            }
        } else if("REMOVE_PRODUCTS".equals(action)){
        	
        	try{
	        	String oids = request.getParameter("oids");
    	    	Collection pids = MOAHelper.getMOACollection(oids);
        		seasonModel.load(oid);
        		seasonModel.removeProducts(pids);
        		
        		oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                action = "LINEPLAN";
                activity = Activities.VIEW_SEASON_REPORT;
                checkReturn = true;
                appContext.clearAppContext(); 
            	additionalParameters = additionalParameters + "&reloadFavorites=true";
        		
        	} catch (LCSException e){
        		errorMessage = e.getLocalizedMessage();
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                checkReturn = true;
        	}
        } else if("REMOVE_SKUS".equals(action)){
        	try{
        		String oids = request.getParameter("oids");
        		Collection sids = MOAHelper.getMOACollection(oids);
                seasonModel.load(oid);
                seasonModel.removeSKUs(sids);
                oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                action = "LINEPLAN";
                activity = Activities.VIEW_SEASON_REPORT;
                checkReturn = true;
                appContext.clearAppContext();
           } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = PageManager.SAFE_PAGE;
                title = styleSheetPgTle;
                checkReturn = true;
           }
        }
        flexType = seasonModel.getFlexType();
    ///////////////////////////////////////////////////////////////////
    } else if(Activities.FIND_SEASON.equals(activity)){
      contextHeaderPage = "STANDARD_LIBRARY_CONTEXT_BAR";
      lcsContext.setCacheSafe(true);
      if(action == null || "".equals(action) || "INIT".equals(action)){
            view = PageManager.FIND_SEASON_CRITERIA;
            title = seasonLabel + " " + searchCriteriaPgTle;
            type = "";
        } else if("CHANGE_TYPE".equals(action)){
            view = PageManager.FIND_SEASON_CRITERIA;
            title = seasonLabel + " " + searchCriteriaPgTle;
            type = request.getParameter("type");
            flexType = FlexTypeCache.getFlexType(type);
        } else if("SEARCH".equals(action)){
			if("true".equals(request.getParameter("updateMode"))){
				formType = "image";
			}
            type = request.getParameter("type");
            view = PageManager.FIND_SEASON_RESULTS;
            title = seasonLabel + " " + searchResultsPgTle;
        } else if("RETURN".equals(action)){
         checkReturn = true;
      }

    ///////////////////////////////////////////////////////////////////
    } else if(Activities.VIEW_SEASON_REPORT.equals(activity)){
        lcsContext.setCacheSafe(true);
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
        if(!FormatHelper.hasContent(action) || "LINEPLAN".equals(action)){
            view = PageManager.VIEW_SEASON_LINEPLAN;
            title = seasonLabel + " " + linePlanPgTle;
        } else {
            view = PageManager.VIEW_SEASON_GRAPHICALMATRIX;
            title = seasonLabel + " " + styleSheetPgTle;
        }
        flexType = seasonModel.getFlexType();
    ///////////////////////////////////////////////////////////////////
    } else if("VIEW_LINE_PLAN".equals(activity)){
        lcsContext.setCacheSafe(true);
        seasonModel.load(oid);
        appContext.setSeasonContext(oid);		
        if("CHOOSE_SEASON".equals(action)){
            view = "LINEPLAN_SEASON_SELECT";
            title = WTMessage.getLocalizedMessage ( RB.SEASON, "selectSeason_PG_TLE", RB.objA ) ;
            additionalParameters = additionalParameters + "&multiple=" + multiple;
        } 
		else if("CHOOSE_SPEC_PAGES".equals(action)){
            view = "SPEC_PAGE_SELECTION";
            title = selectProductsPgTle;
        }
		else {
            boolean setLinePlan = FormatHelper.parseBoolean(request.getParameter("setLinePlan"));
            boolean setWorkMode = FormatHelper.parseBoolean(request.getParameter("setWorkMode"));
            String productType = seasonModel.getBusinessObject().getProductType().getFullName(true);
            if (linePlanChooser) { // allow linesheet choosers to maintain their own context
                productType = productType + "_chooser";
            }
            boolean findExistingSeasonalProdMatchingPlaceholder = "completeAddProductsToPlaceholder".equals(request.getParameter("linePlanChooserReturnMethod"));

            if(setLinePlan && !"RELOAD".equals(action) || findExistingSeasonalProdMatchingPlaceholder){
                 linePlanConfig.update(productType, request);
            }
            if(setWorkMode){
                String linePlaneLevel = "";
                if("true".equals(request.getParameter("csv"))){
                    linePlaneLevel = request.getParameter("linePlanLevelHold");
                }
                else{
                    linePlaneLevel = request.getParameter("linePlanLevel");
                }
                linePlanConfig.put(productType, "linePlanLevel", linePlaneLevel);
                linePlanConfig.put(productType, "linePlanSourcing", "false");
                 }
            view = PageManager.VIEW_SEASON_LINEPLAN;
            title = seasonLabel + " " + linePlanPgTle;
        }
		
        if("CHOOSE_SEASON2".equals(action)){
            view = "LINEPLAN_SEASON_SELECT2";
            title = WTMessage.getLocalizedMessage ( RB.SEASON, "selectSeason_PG_TLE", RB.objA ) ;
            additionalParameters = additionalParameters + "&multiple=" + multiple;
		}
		
        if("VIEW2".equals(action)){
            view = "VIEW_SEASON_LINEPLAN2";
            title = seasonLabel + " " + linePlanPgTle;
		}
     
    } else if("REFRESH_SEASON_COSTS".equals(activity)){
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
        String productType = seasonModel.getBusinessObject().getProductType().getFullName(true);
        if (linePlanChooser) { 
		   productType = productType + "_chooser";
        }
        boolean setLinePlan = FormatHelper.parseBoolean(request.getParameter("setLinePlan"));
        String linePlanLevel =  (String) linePlanConfig.get(productType, "linePlanLevel");
        boolean skus = (FootwearApparelFlexTypeScopeDefinition.PRODUCT_SKU_LEVEL.equals(linePlanLevel));
        boolean allSources = "true".equals((String)linePlanConfig.get(productType, "linePlanSourcing"));
		boolean activeCostSheets = FormatHelper.parseBoolean(request.getParameter("activeCostSheets"));
		boolean whatIfCostSheets = FormatHelper.parseBoolean(request.getParameter("whatIfCostSheets"));

        if(setLinePlan){            
            linePlanConfig.update(productType, request);
            if(!linePlanConfig.get(productType).containsKey("linePlanLevel")){
                linePlanConfig.put(productType, "linePlanLevel", linePlanLevel);
            }
        }
        // RUN LINE PLAN QUERY
        Set idSet = new HashSet();
        Iterator resultsIt = new LCSSeasonQuery().runSeasonProductReport(null, seasonModel.getBusinessObject(), skus, linePlanConfig.get(productType), true, null, true, allSources, !activeCostSheets, whatIfCostSheets, new Vector(), false, true, null ).iterator();
       
	   // COLLECT IDS
        FlexObject obj;
        long recalcTime = (long)LCSProperties.get("com.lcs.wc.season.RefreshCosts.costRecalcTime", 0);
        while(resultsIt.hasNext()){
            obj = (FlexObject) resultsIt.next();
            if(recalcTime <=0 || LCSSeasonQuery.linePlanChange(obj, recalcTime, false)){
                idSet.add("VR:com.lcs.wc.sourcing.LCSCostSheet:" + obj.getString("LCSCOSTSHEET.BRANCHIDITERATIONINFO"));
            }
        }
         seasonModel.refreshCosts(idSet);
		 oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
        view = PageManager.SAFE_PAGE;
        title = linePlanPgTle;
        action = "INIT";
        activity = "VIEW_LINE_PLAN";
        checkReturn = true;
        infoMessage = costsRecalculatedMsg;
        flexType = seasonModel.getFlexType();
    } 
	else if("MOVE_SKUS".equals(activity)){
        appContext.setSeasonContext(oid);
        String oids = request.getParameter("oids");
        Collection ids = MOAHelper.getMOACollection(oids);
        seasonModel.load(oid);
        seasonModel.moveSKUs(ids);
        view = PageManager.SAFE_PAGE;
        title = linePlanPgTle;
        action = "INIT";
        activity = "VIEW_LINE_PLAN";
        checkReturn = true;
        flexType = seasonModel.getFlexType();
    }
	else if("MOVE_PRODUCTS".equals(activity) || "MOVE_PRODUCTS_ADD_TO_PLACEHOLDER".equals(activity)){
        appContext.setSeasonContext(oid);
        String oids = request.getParameter("oids");
        Collection ids = MOAHelper.getMOACollection(oids);
        seasonModel.load(oid);
        try{
            view = PageManager.SAFE_PAGE;
	        seasonModel.moveProducts(ids);
	        if("MOVE_PRODUCTS".equals(activity)){
	            title = linePlanPgTle;
	            action = "INIT";
	            activity = "VIEW_LINE_PLAN";
	            checkReturn = true;
	        }else{
	            String phId = request.getParameter("placeholderId");
	            action = "";
	                activity = Activities.ADD_PRODUCTS_TO_PLACEHOLDER;
	                additionalParameters = additionalParameters + "&placeholderId=" + phId + "&productIds=" + oids + "&placeholderMode=" + request.getParameter("placeholderMode");
	                oid = phId;
	        }
        }catch(LCSException lcsE){
            lcsE.printStackTrace();
            title = linePlanPgTle;
            action = "INIT";
            activity = "VIEW_LINE_PLAN";
            checkReturn = true;
            errorMessage = lcsE.getLocalizedMessage();
        }
        additionalParameters = additionalParameters + "&reloadFavorites=true";
        flexType = seasonModel.getFlexType();

    } else if("CARRYOVER_SKUS".equals(activity)){
        appContext.setSeasonContext(oid);
        String oids = request.getParameter("oids");
        Collection ids = MOAHelper.getMOACollection(oids);
        seasonModel.load(oid);
        seasonModel.carryOverSKUs(ids);
        view = PageManager.SAFE_PAGE;
        title = linePlanPgTle;
        action = "INIT";
        activity = "VIEW_LINE_PLAN";
        checkReturn = true;
        flexType = seasonModel.getFlexType();
    } 
	else if("CARRYOVER_PRODUCTS".equals(activity) || "CARRYOVER_PRODUCTS_ADD_TO_PLACEHOLDER".equals(activity)){
        appContext.setSeasonContext(oid);
        String oids = request.getParameter("oids");
        Collection ids = MOAHelper.getMOACollection(oids);
        seasonModel.load(oid);
        seasonModel.carryOverProducts(ids);
        if("CARRYOVER_PRODUCTS".equals(activity)){
            title = linePlanPgTle;
            action = "INIT";
            activity = "VIEW_LINE_PLAN";
            checkReturn = true;
        } else{
            String phId = request.getParameter("placeholderId");
            action = "";
                activity = Activities.ADD_PRODUCTS_TO_PLACEHOLDER;
                additionalParameters = additionalParameters + "&placeholderId=" + phId + "&productIds=" + oids + "&placeholderMode=" + request.getParameter("placeholderMode");
                oid = phId;
        }
        view = PageManager.SAFE_PAGE;
        flexType = seasonModel.getFlexType();
	} 
	else if("MASS_COPY_PRODUCTS".equals(activity)){	
        appContext.setSeasonContext(oid);
        String copyFromSeasonId = request.getParameter("copyFromSeasonId");        
        additionalParameters = additionalParameters + "&copyFromSeasonId=" + copyFromSeasonId;
        String seasonId = request.getParameter("seasonId");
		if(FormatHelper.hasContent(seasonId)){
        	productModel.setSeasonId(seasonId);
        }
		if("INIT".equals(action)){
            view = "MASS_COPY_PRODUCTS";
            title = massCopyProducts;

        } else if("COMPONENTS_OPTION".equals(action)){
			String productNameDataVal = request.getParameter("productNameDataVal");
			String productTypeDataVal = request.getParameter("productTypeDataVal");
            view = "MASS_COPY_COMPONENTS";
            title = massCopyProducts;
        }
		else if("SAVE".equals(action)){			
			String productNameDataVal = request.getParameter("productNameDataVal");
			String productTypeDataVal = request.getParameter("productTypeDataVal");	
			String componentSelections = request.getParameter("componentSelections");	
			String productOids = request.getParameter("productOidsVal");	
			String copyMode = request.getParameter("copyMode");	
			productModel.setMassCopyData(productNameDataVal, productTypeDataVal, componentSelections, productOids, copyMode, seasonId);			
			productModel.massCopy();			
            view = PageManager.SAFE_PAGE;
            title = linePlanPgTle;
            action = "INIT";
            activity = "VIEW_LINE_PLAN";
            checkReturn = true;
            flexType = seasonModel.getFlexType();			
        }
    } 
	else if("VIEW_SEASON_CALENDAR".equals(activity)){
        lcsContext.setCacheSafe(true);
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
        view = "VIEW_SEASON_CALENDAR_PAGE";
        title = seasonCalendarPgTle;
        flexType = seasonModel.getFlexType();
    } 
	else if("BULK_LINPLAN_UPDATE".equals(activity)){
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
        view = PageManager.SAFE_PAGE;
        title = seasonLabel + " " + linePlanPgTle;
        action = "COMPLETE_EDIT";
        activity = "VIEW_LINE_PLAN";
        if("true".equals(request.getParameter("maintainHiddenColumns"))&&!FormatHelper.parseBoolean(request.getParameter("deActivateHidden"))){
            additionalParameters = additionalParameters + "&maintainHiddenColumns=true";
            String tempInt = request.getParameter("HC_Col_Count");
            additionalParameters = additionalParameters + "&HC_Col_Count=" + tempInt;
            int columnCount = 0;
            if (FormatHelper.hasContent(tempInt)) {
                columnCount = Integer.parseInt(tempInt);
                int start = 1;
                int idx = 0;
                for (int i = start; i < columnCount; i++) {
                    if (FormatHelper.hasContent(request.getParameter("HC"+i))) {
                        additionalParameters = additionalParameters + "&HC"+i + "=" + request.getParameter("HC"+i);
                    }
                }
            }

        }
			if(additionalParameters.startsWith("&")){
				additionalParameters = additionalParameters.substring(1, additionalParameters.length());
			}
        workItemName = request.getParameter("workItemName");        
        String dataString = request.getParameter("dataString");
		java.util.HashMap results = new BulkObjectUpdate().bulkUpdate(dataString, request.getLocale().toString());
        String failedRows = (String) results.get("failedRows");
        failedRows = FormatHelper.removeCharacter(failedRows, "[");
        failedRows = FormatHelper.removeCharacter(failedRows, "]");
        if(FormatHelper.hasContent(failedRows)){
            String errMsg = (String) results.get("errorMessage");
            errorMessage = bulkUpdateError1Msg + " " + errMsg + " - " + bulkUpdateError2Msg + " " + failedRows;
        }
        flexType = seasonModel.getFlexType();
    } 
	else if("VIEW_SEASON_DASHBOARDS".equals(activity)){
        lcsContext.setCacheSafe(true);
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
		
     // Code added for Season Dashboard customization Start        
         view = "COMMON_SEARCH_PAGE";
          title = seasonDashboardsPgTle;
        flexType = seasonModel.getFlexType();
    } 
    
    else if("CALENDAR_DASHBOARD_REPORT".equals(activity))
    {
      Map requestMap = new HashMap();    
      String seasonVal =(String)request.getParameter(LFDashboardReportConstants.STR_PROD_SEASON);
      String yearVal =(String)request.getParameter(LFDashboardReportConstants.STR_PROD_SEASON_YEAR);    
      Collection SeasonValList = MOAHelper.getMOACollection(seasonVal);
      List seasonValues = new ArrayList(SeasonValList);
       
      Collection yearValList = MOAHelper.getMOACollection(yearVal);
      List yearValues = new ArrayList(yearValList);
       
      String SEASON_KEY_PRODUCT = "SEASON_KEY_PRODUCT";
      String YEAR_KEY_PRODUCT = "YEAR_KEY_PRODUCT";
    
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
      LCSLog.debug("productCategoryValue&&&&&>>>>"+productCategoryValue);
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

        
       /*********************** FOR OTHER PRODUCT CLASSIFICATION ***********************************/
      String otherProductClassificationValue = (String) request.getParameter("otherProductClassification");
      String OTHER_PRODUCT_CLASSIFICATION_KEY = "OTHER_PRODUCT_CLASSIFICATION_KEY";
      Collection otherProductClassificationList = MOAHelper.getMOACollection(otherProductClassificationValue);
      List otherProductClassificationValues = new ArrayList(otherProductClassificationList);
      

      /********************** Request Map ********************************/
      if(FormatHelper.hasContent(otherProductClassificationValue)) {
          requestMap.put(OTHER_PRODUCT_CLASSIFICATION_KEY,otherProductClassificationValues);
      } else {
          requestMap.put(OTHER_PRODUCT_CLASSIFICATION_KEY,"");
      }
      
      if(FormatHelper.hasContent(seasonVal))
        requestMap.put(SEASON_KEY_PRODUCT,seasonValues);
       else
        requestMap.put(SEASON_KEY_PRODUCT,"");
        
       if(FormatHelper.hasContent(yearVal))
        requestMap.put(YEAR_KEY_PRODUCT,yearValues);
       else
        requestMap.put(YEAR_KEY_PRODUCT,"");
        
      if(FormatHelper.hasContent(divisionValue))
        requestMap.put(DIVISION_KEY,divisionValue);
       else
        requestMap.put(DIVISION_KEY,"");
        
      if(FormatHelper.hasContent(productstatusValue))
        requestMap.put(STATUS_KEY,productStatusValues);
      else
        requestMap.put(STATUS_KEY,new ArrayList());

      if(FormatHelper.hasContent(productCategoryValue))
        requestMap.put(PRODUCT_CATEGORY_KEY,productCategoryValues);
      else
        requestMap.put(PRODUCT_CATEGORY_KEY,new ArrayList());

      if(FormatHelper.hasContent(licensorValue))
        requestMap.put(LICENSOR_KEY,licensorValues);
      else
        requestMap.put(LICENSOR_KEY,new ArrayList());

      if(FormatHelper.hasContent(customerValue))
        requestMap.put(CUSTOMER_RETAILER_KEY,customerValues);
      else
        requestMap.put(CUSTOMER_RETAILER_KEY,new ArrayList());
        
      if(FormatHelper.hasContent(propertyValue))
        requestMap.put(PROPERTY_KEY,propertyValues);
      else
        requestMap.put(PROPERTY_KEY,new ArrayList());

      if(FormatHelper.hasContent(brandValue))
        requestMap.put(BRAND_KEY,brandValues);
      else
        requestMap.put(BRAND_KEY,new ArrayList());

      if(FormatHelper.hasContent(seasonDataValue))
        requestMap.put(SEASON_DATA_KEY,seasonDataValues);
      else
        requestMap.put(SEASON_DATA_KEY,new ArrayList());

      if(FormatHelper.hasContent(productSubGroupValue))
        requestMap.put(PRODUCT_SUBCATEGORY_KEY,productSubGroupValues);
      else
        requestMap.put(PRODUCT_SUBCATEGORY_KEY,new ArrayList());

      if(FormatHelper.hasContent(sizeGroupValue))
        requestMap.put(SIZE_GROUP_KEY,sizeGroupValues);
      else
        requestMap.put(SIZE_GROUP_KEY,new ArrayList());  
		request.setAttribute("requestMapVal",requestMap);    
		contextHeaderPage = "SEASON_CONTEXT_BAR";
         lcsContext.setCacheSafe(true);
          appContext.setSeasonContext(oid);
          seasonModel.load(oid);
          view = "VIEW_SEASON_DASHBOARDS_PAGE";         
            title = seasonDashboardsPgTle;
          flexType = seasonModel.getFlexType();
    }
    
     // End of code for season dashboard customization.
    
    else if("VIEW_SEASON_CHANGE_REPORT".equals(activity)){
        lcsContext.setCacheSafe(true);
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
        view = "SEASON_CHANGE_REPORT";
        title = seasonLabel + " " + changeReportPgTle;
    } 
	else if("SELECT_SEASON_GROUPS".equals(activity)){
        if(!FormatHelper.hasContent(action) || "INIT".equals(action)){
            seasonModel.load(oid);
            view = "SEASON_SEASON_GROUP_SELECTION";
            title = seasonLabel + "  - " + seasonGroupTypePgTle;
        } 
		else {
            seasonModel.load(oid);
            String seasonGroupTypeIds = request.getParameter("seasonGroupTypeIds");
            seasonModel.load(oid);
            view = "SEASON_SEASON_GROUP_SELECTION";
            title = seasonLabel + "  - " + seasonGroupTypePgTle;
            seasonModel.setSeasonGroupIds(seasonGroupTypeIds);
            seasonModel.save();
            view = PageManager.SAFE_PAGE;
            title = seasonLabel + " " + detailsPgTle;
            action = "INIT";
            activity = Activities.VIEW_SEASON;
            checkReturn = true;
        }
    } 
	else if("VIEW_MATERIAL_COMMITMENT_REPORT".equals(activity)){
        lcsContext.setCacheSafe(true);
        appContext.setSeasonContext(oid);
        seasonModel.load(oid);
        view = "MATERIAL_COMMITMENT_REPORT";
        title = seasonLabel + " " + materialCommitmentReportPgTle;
    }
    else if("GENERATE_PRODUCT_SPECIFICATIONS".equals(activity)){
        // Clean up of spec folders
        DeleteFileHelper dfh = new DeleteFileHelper();
        String timeToLive = LCSProperties.get("time.before.temp.files.are.deleted", "1");
        dfh.deleteOldFiles(FileLocation.PDFDownloadLocationImages,timeToLive);
        dfh.deleteOldFiles(FileLocation.PDFDownloadLocationFiles,timeToLive);
        //end of clean up
        appContext.setSeasonContext(oid);
        String oids = request.getParameter("oids");
        Collection ids = MOAHelper.getMOACollection(oids);
        String pages = request.getParameter("selectedPages");
        Collection sPages = MOAHelper.getMOACollection(pages);
        seasonModel.load(oid);
        if(ids.size() > 0){
			String downloadFileKey = new java.util.Date().getTime() + "";
			String generatedPDF = com.lcs.wc.product.LCSProductHelper.service.createPDFSpecification(ids, true, sPages);
			lcsContext.requestedDownloadFile.put(downloadFileKey, generatedPDF);
            popupURL = "Main.jsp?forwardedFileForDownload=true&forwardedFileForDownloadKey=" + downloadFileKey;
        }
        view = PageManager.SAFE_PAGE;
        title = linePlanPgTle;
        action = "INIT";
        activity = "VIEW_LINE_PLAN";
        checkReturn = true;
        if(FormatHelper.hasContent(popupURL)){
            popupURL = java.net.URLEncoder.encode(popupURL);
            additionalParameters = additionalParameters + "&popupURL=" + popupURL;
        }
        flexType = seasonModel.getFlexType();

    }
    else if("GENERATE_PRODUCT_SPECIFICATIONS_NEW".equals(activity)){
	
        //Do clean up of spec folders		
        DeleteFileHelper dfh = new DeleteFileHelper();
        String timeToLive = LCSProperties.get("time.before.temp.files.are.deleted", "1");
        dfh.deleteOldFiles(FileLocation.PDFDownloadLocationImages,timeToLive);
        dfh.deleteOldFiles(FileLocation.PDFDownloadLocationFiles,timeToLive);
		 //end of clean up
		
        appContext.setSeasonContext(oid);
        String oids = request.getParameter("oids");
        Collection ids = MOAHelper.getMOACollection(oids);        
        LCSLog.debug(RequestHelper.hashRequest(request).toString());        
        boolean isAsyncGen = FormatHelper.parseBoolean(request.getParameter("asynchronousGeneration"));
		 seasonModel.load(oid);
      if(isAsyncGen && ids.size() > 0){
			LCSProductHelper.service.asyncCreatePDFSpecifications(ids,RequestHelper.hashRequest(request));
		}else{
	        if(ids.size() > 0){
				String downloadFileKey = new java.util.Date().getTime() + "";
				String generatedPDF = com.lcs.wc.product.LCSProductHelper.service.createPDFSpecifications(ids, true, RequestHelper.hashRequest(request));
				lcsContext.requestedDownloadFile.put(downloadFileKey, generatedPDF);
				popupURL = "Main.jsp?forwardedFileForDownload=true&forwardedFileForDownloadKey=" + downloadFileKey;
	            if(FormatHelper.hasContent(popupURL)){
					popupURL = java.net.URLEncoder.encode(popupURL);
					additionalParameters = additionalParameters + "&popupURL=" + popupURL;
        		}
	        }
	     }
         view = PageManager.SAFE_PAGE;
        title = linePlanPgTle;
        action = "INIT";
        activity = "VIEW_LINE_PLAN";
        checkReturn = true;
        flexType = seasonModel.getFlexType();
    } 
	else if("VIEW_SEASON_PLANNING".equals(activity)){
        contextHeaderPage = "SEASON_CONTEXT_BAR";
        lcsContext.setCacheSafe(true);
		if(oid.contains("com.lcs.wc.planning.FlexPlan"))
		{
			view = PageManager.SAFE_PAGE;
			returnActivity = "VIEW_PLAN";
			returnAction="INIT";
			returnOid=oid;
			checkReturn = true;
		}else{
	        appContext.setSeasonContext(oid);
	        seasonModel.load(oid);
	        view = "VIEW_SEASON_PLANNING_PAGE";
	        title = seasonLabel + planningLabel;
        } 
    } 
	else if("ADD_SEASON_PLANS".equals(activity)){
        try{
            String newIds = request.getParameter("planIds");
            Collection ids = MOAHelper.getMOACollection(newIds);
            seasonModel.load(oid);
            seasonModel.createPlans(ids);
            oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
            view = "VIEW_SEASON_PLANNING_PAGE";
            title = seasonLabel + planningLabel;            
            checkReturn = true;
        } 
		catch(LCSException e){
            errorMessage = e.getLocalizedMessage();
            view = PageManager.SAFE_PAGE;
            title = seasonLabel + planningLabel;
            checkReturn = true;
        }

    }else if("GENERATE_PLACEHOLDERS".equals(activity)){
        try{
            LCSSeason season = (LCSSeason)LCSQuery.findObjectById(oid);
            FlexPlan plan = (FlexPlan)LCSQuery.findObjectById(request.getParameter("currentPlanId"));
            Boolean forceUpdate = new Boolean("true".equals(request.getParameter("forceUpdatePH")));
            String filterBranch = request.getParameter("filterBranch");            
            Map params = new HashMap();
            params.put(PlanToPlaceholderGenerator.PLAN, plan);
            params.put(PlanToPlaceholderGenerator.SEASON, season);
            params.put(PlanToPlaceholderGenerator.BRANCH, filterBranch);
            params.put(PlanToPlaceholderGenerator.FORCE_UPDATE, forceUpdate);
            params.put(PlanLogic.PLAN_GEN_KEY, "PlanToPlaceholder");        
            PlanHelper.service.generateFromPlan(params);
            oid = FormatHelper.getVersionId(seasonModel.getBusinessObject());
            view = PageManager.SAFE_PAGE;
            title = seasonLabel + planningLabel;
            checkReturn = true;
            errorMessage = phGenerated;
        } catch(LCSException e){
            errorMessage = e.getLocalizedMessage();
            view = PageManager.SAFE_PAGE;
            title = seasonLabel + planningLabel;
            checkReturn = true;
        }
    } else if("VIEW_COLORWAY_MANAGER".equals(activity)){		
		lcsContext.setCacheSafe(true);
		if(action == null || "".equals(action) || "INIT".equals(action)){
            view = "VIEW_COLORWAY_MANAGER";
            title = colorManagerPgTle;
            type = "";
        } 
	}

	//////////////////////////////////////////////////////////////////////////////////
	//  ITC Custom Activity for Page Url 
	//////////////////////////////////////////////////////////////////////////////////
	else if("SAP_COSTSHEET_EXPORT".equals(activity)){
		view = "SAP_COSTSHEET_EXPORT_PAGE";
		title = "SAP COSTSHEET EXPORT";
	}

	/**
	 * Target Point Build: 005.16_1
	 * Request ID : <1>
	 * Description : Changes made for EZ Costing- Export , Added view for the activity
	 * @author ITC Infotech
	 * Modified On: 15th May 2014
	 */
	//ITC-START
	else if("EXPORT_EZ_COSTING".equals(activity)){
			view = "EZ_COSTING_EXPORT_PAGE";
			title = "EZ COSTING EXPORT";      
	}
	
	/**
	 * Target Point Build: 6.7
	 * Description : Mass Copy Cost Sheet from line Sheet
	 * @author ITC Infotech
	 * Modified On: 3 Dec 2014
	 */
	//ITC-START
	else if("MASS_COPY_COST_SHEET".equals(activity)){
			view = "MASS_COPY_COST_SHEET";
	}
	//ITC-END
	//---------------------------------------------------------
	/**
	 * Target Point Build: 006.2
	 * Request ID : <1>
	 * Description : Changes made for Iprofile Integratiom , Added view for the activity
	 * @author ITC Infotech
	 * Modified On: 13 Aug 2014
	 
	//ITC-START
	else if("ERP_STYLE_IPROFILE".equals(activity)){
		view = "ERP_STYLE_IPROFILE_PAGE";
	//ITC-END
	}
*/
     String contentPage = null;
    if(view != null){
        contentPage = PageManager.getPageURL(view, null);
    } else {
        contentPage = "";
    }

    ////////////////////////////////////////////////////////////////////////////
    // GET THE CLIENT MODELS FLEX TYPE FULL NAME
    ////////////////////////////////////////////////////////////////////////////
    String flexTypeName = null;
    if (flexType != null) {
        flexTypeName = flexType.getFullNameDisplay(true);
        type = "OR:com.lcs.wc.flextype.FlexType:" + flexType.getIdNumber();
    }

    ////////////////////////////////////////////////////////////////////////////
    // CHECK RETURN ACTIVITY..
    ////////////////////////////////////////////////////////////////////////////
    if(FormatHelper.hasContent(returnActivity) && checkReturn){
        view = PageManager.SAFE_PAGE;
        title = WTMessage.getLocalizedMessage (RB.MAIN, "productName", RB.objA ) ;
        action = returnAction;
        activity = returnActivity;
        oid = returnOid;
        returnActivity = "";
        returnAction = "";
        returnOid = "";
    }

	if(FormatHelper.hasContent(workItemName)){
		additionalParameters = additionalParameters + "&level1=" + request.getParameter("level1");
		additionalParameters = additionalParameters + "&level2=" + request.getParameter("level2");
		additionalParameters = additionalParameters + "&level3=" + request.getParameter("level3");
		additionalParameters = additionalParameters + "&level4=" + request.getParameter("level4");
	}

%>
<jsp:forward page="<%=subURLFolder+ MAINTEMPLATE %>">
    <jsp:param name="title" value="<%= java.net.URLEncoder.encode(title, defaultCharsetEncoding)%>" />
   <jsp:param name="infoMessage" value="<%= java.net.URLEncoder.encode(infoMessage, defaultCharsetEncoding) %>" />
   <jsp:param name="errorMessage" value="<%= java.net.URLEncoder.encode(errorMessage, defaultCharsetEncoding) %>" />
   <jsp:param name="requestedPage" value="<%= contentPage %>" />
   <jsp:param name="contentPage" value="<%= contentPage %>" />
    <jsp:param name="oid" value="<%= oid %>" />
    <jsp:param name="action" value="<%= action %>" />
    <jsp:param name="activity" value="<%= activity %>" />
   <jsp:param name="objectType" value="Season" />
   <jsp:param name="typeClass" value="com.lcs.wc.season.LCSSeason" />
    <jsp:param name="type" value="<%= type %>" />
    <jsp:param name="flexTypeName" value="<%= flexTypeName %>" />
    <jsp:param name="additionalParameters" value="<%= additionalParameters %>" />
    <jsp:param name="workItemName" value="<%= workItemName %>" />
    <jsp:param name="contextHeaderPage" value="<%= contextHeaderPage %>" />
    <jsp:param name="formType" value="<%= formType %>" />
    
</jsp:forward>

