<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="/rfa/jsp/exception/ControlException.jsp"
        import="com.lcs.wc.db.SearchResults,
                com.lcs.wc.client.web.PageManager,
                com.lcs.wc.client.web.WebControllers,
                com.lcs.wc.client.Activities,
                com.lcs.wc.delete.*,
                com.lcs.wc.flextype.*,
                com.lcs.wc.foundation.*,
                com.lcs.wc.testing.*,
                java.util.*,
                com.lcs.wc.db.*,
                wt.util.*,
                com.lcs.wc.sample.*,
                com.lcs.wc.util.*,
                com.lcs.wc.measurements.*,
                com.lcs.wc.sourcing.*,
                com.lcs.wc.specification.FlexSpecification,
				org.apache.commons.lang.StringUtils,
				com.lcs.wc.sample.LCSSampleClientModel"
%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INCLUDED FILES  //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="sampleModel" scope="request" class="com.lcs.wc.sample.LCSSampleClientModel" />
<jsp:useBean id="sampleRequestModel" scope="request" class="com.lfusa.wc.sample.LFLCSSampleRequestClientModel" />
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>

<% wt.util.WTContext.getContext().setLocale(request.getLocale());%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// STATIS JSP CODE //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
    public static final String JSPNAME = "SampleController";
    public static final boolean DEBUG = LCSProperties.getBoolean("jsp.sample.SampleController.verbose");
    public static final String MAINTEMPLATE = PageManager.getPageURL("MAINTEMPLATE", null);
	public static final String AJAX_TEMPLATE = PageManager.getPageURL("AJAX_TEMPLATE", null);

    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");

    public static final String PRODUCT_TEST_REQ_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.TestingRequest.Root");
    public static final String MATERIAL_TEST_REQ_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Material.TestingRequest.Root");

    public static final String FIT_SAMPLE_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.Fit.Root");
    public static final String COLOR_DEV_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Material.ColorDevelopement.Root");
    
    public static final String UPDATE_SAMPLE_AFTER_CREATION = LCSProperties.get("jsp.sample.SampleController.UpdateSampleAfterCreation", "false");

    public static boolean isChildType(FlexType parent, FlexType child){
        String pTypeId = parent.getTypeIdPath();
        String cTypeId = child.getTypeIdPath();
        if(cTypeId.startsWith(pTypeId)) return true;

        return false;
    }
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%

String templateName = MAINTEMPLATE;
//setting up which RBs to use

String viewSamplePgTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "viewSample_PG_TLE", RB.objA ) ;
String createSamplePgTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "createSample_PG_TLE", RB.objA ) ;
String updateSamplePgTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "updateSample_PG_TLE", RB.objA ) ;
String sampleDetailsPgTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleDetails_PG_TLE", RB.objA ) ;
String sampleSearchCriteriaPgTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleSearchCriteria_PG_TLE", RB.objA ) ;
String sampleLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sample_LBL", RB.objA ) ;
String sampleSearchResultsPgTle = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleSearchResults_PG_TLE", RB.objA ) ;
String updateImagesPageTle = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "updateImagesPage_PG_HEAD", RB.objA ) ;
String sampleTypeError = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleType_ERR", RB.objA ) ;//"You can not select Fit or Testing Request as a type"
String testSpecificationEditorPgTle = WTMessage.getLocalizedMessage ( RB.TESTSPECIFICATION, "testSpecificationEditor_PG_TLE", RB.objA ) ;


%>

<%
    FlexType fitRoot = FlexTypeCache.getFlexTypeFromPath(FIT_SAMPLE_ROOT_TYPE);
    FlexType testReqRoot = FlexTypeCache.getFlexTypeFromPath(PRODUCT_TEST_REQ_ROOT_TYPE);
    FlexType materialTestReqRoot = FlexTypeCache.getFlexTypeFromPath(MATERIAL_TEST_REQ_ROOT_TYPE);

	FlexType colorDevelopmentType = FlexTypeCache.getFlexTypeFromPath(COLOR_DEV_ROOT_TYPE);

    String activity = request.getParameter("activity");
    String action = request.getParameter("action");
    String oid = request.getParameter("oid");
    String returnActivity = request.getParameter("returnActivity");
    String returnAction = request.getParameter("returnAction");
    String returnOid = request.getParameter("returnOid");
    String measurementsId = request.getParameter("measurementsId");
    String imagePageId = request.getParameter("imagePageId");
    String tabId = request.getParameter("tabId");
    boolean forceRefreshSample = FormatHelper.parseBoolean(request.getParameter("forceRefreshSample"));
    boolean checkReturn = false;
     String origActivity = request.getParameter("origActivity");
     String origOid = request.getParameter("origOid");

    String title = "";
    String errorMessage = request.getParameter("errorMessage");
    if (FormatHelper.hasContent(errorMessage)) {
        errorMessage = java.net.URLDecoder.decode(errorMessage, defaultCharsetEncoding);
    } else {
      errorMessage = "";
    }
    String infoMessage = request.getParameter("infoMessage");
    String view = null;
    String formType = "standard";
    String type = request.getParameter("type");

    String additionalParameters = "";

    FlexType flexType = null;

    String rootTypeId = request.getParameter("rootTypeId");

	String ajaxWindow = "false";
	if(FormatHelper.hasContent(request.getParameter("ajaxWindow")) && "true".equals(request.getParameter("ajaxWindow"))){
		ajaxWindow = "true";
	}


   ///////////////////////////////////////////////////////////////////
    if("VIEW_SAMPLE".equals(activity)){
        lcsContext.setCacheSafe(true);    
        LCSSample sample = null;
        LCSSampleRequest sampleRequest = null;
        FlexType sampleType = FlexTypeCache.getFlexTypeFromPath("Sample");
        
        if(oid.indexOf("LCSSampleRequest")>-1){
           sampleRequestModel.load(oid);
           sampleRequest = sampleRequestModel.getBusinessObject();
           if(fitRoot.isAssignableFrom(sampleRequest.getFlexType()) || colorDevelopmentType.isAssignableFrom(sampleRequest.getFlexType())){
             //do nothing
           }else{
			  Collection samplesData = (new LCSSampleQuery()).findSamplesIdForSampleRequest((LCSSampleRequest)sampleRequestModel.getBusinessObject(), false);
			  if(samplesData.size()>0){
				  oid = "com.lcs.wc.sample.LCSSample:" + ((FlexObject)samplesData.iterator().next()).getString("LCSSAMPLE.IDA2A2");
					  sampleModel.load(oid);
					  sample = sampleModel.getBusinessObject();
			  }
			}
        }else{
           sampleModel.load(oid);
           sample = sampleModel.getBusinessObject();
        }


        if(sample!=null){
           sampleType = sample.getFlexType();
        }else if(sampleRequest!=null){
           sampleType = sampleRequest.getFlexType();        
        }
        
		if(fitRoot.isAssignableFrom(sampleType)){
  			if(FormatHelper.hasContent(request.getParameter("nextSampleOid"))){
               oid = request.getParameter("nextSampleOid");
            }
            if(oid.indexOf("LCSSampleRequest")>-1){
               sampleRequestModel.load(oid); 
            }else{
               sampleModel.load(oid);
            }

            returnActivity = "";
  
            view = "VIEW_MULTIPLE_SAMPLE_PAGE";
            title = viewSamplePgTle;
            flexType = sampleModel.getFlexType();
        }else{
    		if(FormatHelper.hasContent(request.getParameter("nextSampleOid"))){
               oid = request.getParameter("nextSampleOid");
            }
            if(oid.indexOf("LCSSampleRequest")>-1){
               sampleRequestModel.load(oid); 
            }else{
               sampleModel.load(oid);
            }
		
        
           returnActivity = "";

           view = "VIEW_SAMPLE_PAGE";
           title = viewSamplePgTle;
           flexType = sampleModel.getFlexType();
        }



   ///////////////////////////////////////////////////////////////////
   }else if("ASSOCIATE_SAMPLE_TO_MEASUREMENT".equals(activity)){

      if(FormatHelper.hasContent(request.getParameter("measurementsId")) && FormatHelper.hasContent(request.getParameter("oid"))){
          measurementsId = request.getParameter("measurementsId");
          oid = request.getParameter("oid");
          LCSSample sample = (LCSSample)LCSQuery.findObjectById(oid);
          LCSMeasurements measurements = (LCSMeasurements)LCSQuery.findObjectById(measurementsId);
          LCSMeasurementsHelper.service.createFitTest(sample, measurements, measurements.getSampleSize());
      view = "SAFE_PAGE";
      title = viewSamplePgTle;
      action = "INIT";
      activity = "VIEW_MULTIPLE_SAMPLE";
       }




   ///////////////////////////////////////////////////////////////////
    } else if("CREATE_SAMPLE".equals(activity)){

        if(action == null || "INIT".equals(action) || "".equals(action)){

            title = createSamplePgTle;
            view = "CLASSIFY_PAGE";
            //type="";

        } else if("CLASSIFY".equals(action)){

            AttributeValueSetter.setAllAttributes(sampleModel, RequestHelper.hashRequest(request));
            AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request));
            if(FormatHelper.hasContent(request.getParameter("contextSpecId"))){
                sampleModel.setSpecificationMasterId(request.getParameter("contextSpecId"));
                sampleRequestModel.setSpecificationMasterId(request.getParameter("contextSpecId"));

            }else{
                sampleModel.setSpecificationMasterId(request.getParameter("ownerId"));
                sampleRequestModel.setSpecificationMasterId(request.getParameter("ownerId"));
            }

            if(FormatHelper.hasContent(request.getParameter("directClassifyId"))){
                sampleModel.setTypeId(request.getParameter("directClassifyId"));
                sampleRequestModel.setTypeId(request.getParameter("directClassifyId"));

                title = createSamplePgTle;
                view = "CREATE_SAMPLE_PAGE";
            }
            else{
                //Need to check to see if it is being set to a restricted type
                FlexType selectedType = sampleModel.getFlexType();

/*
                if(isChildType(fitRoot, selectedType) || isChildType(testReqRoot, selectedType)){
                    errorMessage = sampleTypeError;
                    title = createSamplePgTle;
                    view = "CLASSIFY_PAGE";
                }
*/
                if(isChildType(fitRoot, selectedType)){
                    title = createSamplePgTle;
                    view = "CREATE_MULTIPLE_SAMPLE_PAGE";
                }
                else if (isChildType(testReqRoot, selectedType)){
                    title = createSamplePgTle;
                    view = "CREATE_TESTREQUEST_PAGE";
                }
                else{
                    title = createSamplePgTle;
                    view = "CREATE_SAMPLE_PAGE";
                }
            }

            //title = createSamplePgTle;
            //view = "CREATE_SAMPLE_PAGE";
            sampleModel.setSourcingConfigId(oid);
            sampleRequestModel.setSourcingConfigId(oid);

        } else if("SAVE".equals(action)){
             sampleModel.setTypeId(request.getParameter("typeId"));
             AttributeValueSetter.setAllAttributes(sampleModel, RequestHelper.hashRequest(request), "LCSSAMPLE");
             sampleRequestModel.setTypeId(request.getParameter("typeId"));             
             AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");

             sampleModel.setSpecificationMasterId(request.getParameter("specMasterId"));
             sampleModel.setSourcingConfigId(request.getParameter("sourcingConfigId"));
             sampleModel.setOwnerMasterId(request.getParameter("ownerMasterId"));             
             sampleRequestModel.setSpecificationMasterId(request.getParameter("specMasterId"));
             sampleRequestModel.setSourcingConfigId(request.getParameter("sourcingConfigId"));  
             sampleRequestModel.setOwnerMasterId(request.getParameter("ownerMasterId"));
             try {
                if(FormatHelper.hasContent(request.getParameter("measurementsId"))){
                    String size = request.getParameter("sampleSize");
                    sampleModel.createFitSample(request.getParameter("measurementsId"), size);
                    //additionalParameters = java.net.URLEncoder.encode("measurementsId=" + request.getParameter("measurementsId"));
                    additionalParameters = "measurementsId=" + request.getParameter("measurementsId");
                } else {
                    sampleModel.save(sampleRequestModel);
                }
                oid = FormatHelper.getObjectId(sampleModel.getBusinessObject());
                view = "SAFE_PAGE";

                if(UPDATE_SAMPLE_AFTER_CREATION.equalsIgnoreCase("true")){
                    title = updateSamplePgTle;
                    action = "INIT";
                    activity = "UPDATE_SAMPLE";
                    checkReturn = false;
                }else{
                    title = viewSamplePgTle;
                    action = "INIT";
                    activity = "VIEW_SAMPLE";
                    checkReturn = true;
                }

               } catch(LCSException e){
                    view = "CREATE_SAMPLE_PAGE";
                    title = createSamplePgTle;
                    errorMessage=e.getLocalizedMessage();
               }
               
        }
        flexType = sampleModel.getFlexType();

    ///////////////////////////////////////////////////////////////////

    /**
    * 
    * Target Point Build: 004.23
    * Request ID : <20>
    * Modified On: 22-May-2013
    * Method Copy Sample Request and all the Samples in it
    * @author Shamel
    */
	// ITC - Start
    }else if("COPY_SAMPLE".equals(activity)){
		if(action == null || "INIT".equals(action) || "".equals(action)){
			sampleRequestModel.load(oid);
			flexType = sampleRequestModel.getFlexType();
			if(flexType.getFullName(true).contains("Apparel")){
				title	= "Copy Sample Request";
				view	= "CLASSIFY_PAGE";
			}else{
				PropertyBasedAttributeValueLogic.setAttributes(sampleRequestModel, "com.lcs.wc.sample.LCSSampleRequest", "", "COPY");
				FlexTypeAttribute attributeCheck = flexType.getAttribute("requestName");
				String attType = attributeCheck.getAttVariableType();
				if(!"derivedString".equals(attType)){
					String copyOf = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "copyOf_LBL", RB.objA ) ;
					sampleRequestModel.setValue("requestName", copyOf + " " + sampleRequestModel.getValue("requestName"));
				}
				sampleRequestModel.setValue("sampleRequestRequestDate", null);

				/**
				* 
				* Target Point Build: 006.7
				* Request ID : PRODUCTION FIX
				* Modified On: 27-11-2014
				* Code added to set the value for Sent To Total source as No while Copying Samples
				* @author ITCInfotech.
				*/
				// ITC - Start
				sampleRequestModel.setValue("lfsentToTotalSource", false);
				// ITC - End

				view = "COPY_MULTIPLE_SAMPLE_PAGE";
				title = "Copy Sample Request";
			}
			
		}else if("CLASSIFY".equals(action)){
			sampleRequestModel.load(oid);
			flexType = sampleRequestModel.getFlexType();
			PropertyBasedAttributeValueLogic.setAttributes(sampleRequestModel, "com.lcs.wc.sample.LCSSampleRequest", "", "COPY");
			AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request));
			FlexTypeAttribute attributeCheck = flexType.getAttribute("requestName");
			String attType = attributeCheck.getAttVariableType();
			if(!"derivedString".equals(attType)){
				String copyOf = WTMessage.getLocalizedMessage ( RB.DOCUMENT, "copyOf_LBL", RB.objA ) ;
				sampleRequestModel.setValue("requestName", copyOf + " " + sampleRequestModel.getValue("requestName"));
			}
			sampleRequestModel.setValue("sampleRequestRequestDate", null);
			/**
				* 
				* Target Point Build: 006.7
				* Request ID : PRODUCTION FIX
				* Modified On: 27-11-2014
				* Code added to set the value for Sent To Total source as No while Copying Samples
				* @author ITCInfotech.
				*/
			// ITC - Start
			sampleRequestModel.setValue("lfsentToTotalSource", false);
			// ITC - End

			if(!isChildType(FlexTypeCache.getFlexTypeFromPath("Sample\\Product\\Product Sample\\Apparel"), sampleRequestModel.getFlexType())){
				errorMessage = "You cannot copy selected request to this sample type";
				title = "Copy Sample Request";
				view = "CLASSIFY_PAGE";
			}else{
				view = "COPY_MULTIPLE_SAMPLE_PAGE";
				title = "Copy Sample Request";
			}

			
			
		}else if("SAVE".equals(action)){
				sampleRequestModel.setSpecificationMasterId(request.getParameter("specMasterId"));
				sampleRequestModel.setTypeId(request.getParameter("typeId"));
				sampleRequestModel.setSourcingConfigId(request.getParameter("sourcingConfigId"));
				sampleRequestModel.setOwnerMasterId(request.getParameter("ownerMasterId"));
			try {
				LCSSampleRequest sampleRequest = (LCSSampleRequest)LCSQuery.findObjectById(oid);
				AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");
				sampleRequestModel.setCopiedFrom(sampleRequest);
				oid = FormatHelper.getObjectId(sampleRequestModel.saveAs());
				sampleRequestModel = new com.lfusa.wc.sample.LFLCSSampleRequestClientModel();
				sampleRequestModel.load(oid);
				
				returnOid		=	oid;
				returnActivity	=	"VIEW_MULTIPLE_SAMPLE";
				returnAction	=	"INIT";
                %>
                   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
                        <jsp:param name="oid" value="<%= oid %>" />
                        <jsp:param name="activity" value="UPDATE_MULTIPLE_SAMPLE" />
                        <jsp:param name="action" value="INIT" />
                        <jsp:param name="returnOid" value="<%= returnOid %>" />
                        <jsp:param name="returnActivity" value ="<%= returnActivity%>" />
                        <jsp:param name="returnAction" value="<%= returnAction%>" />
                    </jsp:forward>		
				<%
				additionalParameters = "sampleRequestId="+oid+"&requestTypeId="+request.getParameter("typeId")+"&runSampleSearch=true";

				view = "SAFE_PAGE";
				action = "INIT";
				activity = "UPDATE_MULTIPLE_SAMPLE";
				title = updateSamplePgTle;

			}//catch(LCSException e){
				catch(Exception e){
                view = "COPY_MULTIPLE_SAMPLE_PAGE";
				title = "Copy Sample Request";
                errorMessage=e.getLocalizedMessage();
           }
		}
	// ITC - End
    ///////////////////////////////////////////////////////////////////
    }else if("UPDATE_SAMPLE".equals(activity)){

        if(action == null || "INIT".equals(action) || "".equals(action)){
			LCSSample sample = null;
			LCSSampleRequest sampleRequest = null;

			if(oid.indexOf("LCSSampleRequest")>-1){
               sampleRequestModel.load(oid);    
			   sampleRequest = sampleRequestModel.getBusinessObject();
			   Collection samplesData = (new LCSSampleQuery()).findSamplesIdForSampleRequest(sampleRequest, false);
			   if(samplesData.size()>0){
				     String sampleOid = "com.lcs.wc.sample.LCSSample:" + ((FlexObject)samplesData.iterator().next()).getString("LCSSAMPLE.IDA2A2");
					 sampleModel.load(sampleOid);
					 sample = sampleModel.getBusinessObject();
			   }
            }else{
               sampleModel.load(oid);
			   sample = sampleModel.getBusinessObject();
            }

			FlexType sampleType = sample.getFlexType();

            if(fitRoot.isAssignableFrom(sampleType)){	%>	 
     
                   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
                        <jsp:param name="oid" value="<%= oid %>" />
                        <jsp:param name="activity" value="UPDATE_MULTIPLE_SAMPLE" />
                        <jsp:param name="action" value="INIT" />
                        <jsp:param name="returnOid" value="<%= returnOid %>" />
                        <jsp:param name="returnActivity" value ="<%= returnActivity%>" />
                        <jsp:param name="returnAction" value="<%= returnAction%>" />
                    </jsp:forward>				 
            <%
            }else if(testReqRoot.isAssignableFrom(sampleType) || materialTestReqRoot.isAssignableFrom(sampleType)){
				TestSpecification tp = (TestSpecification)(TestSpecificationQuery.getTestSpecsForSample(sample)).iterator().next();
				oid = FormatHelper.getVersionId(tp);
		%>
                   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
                        <jsp:param name="oid" value="<%= oid %>" />
                        <jsp:param name="activity" value="EDIT_SPECIFICATION" />
                        <jsp:param name="action" value="INIT" />
                        <jsp:param name="returnOid" value="<%= returnOid %>" />
                        <jsp:param name="returnActivity" value ="<%= returnActivity%>" />
                        <jsp:param name="returnAction" value="<%= returnAction%>" />
                    </jsp:forward>
		<%

			}else{
				if(!FormatHelper.hasContent(returnActivity) || "UPDATE_SAMPLE".equals(returnActivity)){
					if (!FormatHelper.hasContent(returnOid)){
						returnOid = oid;
					}
					returnActivity = "VIEW_SAMPLE";
				}
                view = "UPDATE_SAMPLE_PAGE";
                title = updateSamplePgTle;
            }
            if("UPDATE_SAMPLE".equals(returnActivity) && "INIT".equals(action) && 
                    "INIT".equals(returnAction)) {
                if (!FormatHelper.hasContent(oid) || oid.indexOf("FlexSpecification") == -1) {
					if(sample.getSpecMaster()!=null){
		                returnActivity = "VIEW_PRODUCT";
						wt.part.WTPartMaster master = sample.getSpecMaster();
						Iterator versions = VersionHelper.allVersionsOf(master).iterator();
						if (versions.hasNext()) {
							FlexSpecification spec = (FlexSpecification)versions.next();
							oid = FormatHelper.getVersionId(spec);
						}
					}
                }
            }

        } else if("SAVE".equals(action)|| "SAVE_AND_RETURN".equals(action) || "SAVE_AND_TOGGLE".equals(action) ||"SAVE_AND_DELETE_IMAGE".equals(action) || "SAVE_AND_REFRESH".equals(action) || "SAVE_AND_REF_DOC".equals(action) || "SAVE_AND_ADD_DOC".equals(action) || "SAVE_AND_REMOVE_DOC".equals(action) || "SAVE_AND_REMOVE_ALL_DOC".equals(action) || "SAVE_AND_UPDATE_DOC".equals(action) || "SAVE_AND_DOC_HISTORY".equals(action)){
            try{
                sampleModel.load(oid);
                AttributeValueSetter.setAllAttributes(sampleModel, RequestHelper.hashRequest(request), "LCSSAMPLE");

                LCSSampleRequest sampleRequest= sampleModel.getBusinessObject().getSampleRequest();
                AttributeValueSetter.setAllAttributes(sampleRequest, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");
                sampleModel.save(sampleRequest);

               oid = FormatHelper.getObjectId(sampleModel.getBusinessObject());

               if ("SAVE_AND_DELETE_IMAGE".equals(action)) {
                    %>
                    <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
                        <jsp:param name="oid" value="<%= imagePageId %>" />
                        <jsp:param name="activity" value="DELETE_IMAGEPAGE" />
                        <jsp:param name="action" value="INIT" />
                        <jsp:param name="returnOid" value="<%= returnOid %>" />
                        <jsp:param name="returnActivity" value ="<%= returnActivity%>" />
                        <jsp:param name="returnAction" value="<%= returnAction%>" />
                    </jsp:forward>
                    <%
                } else if ("SAVE_AND_RETURN".equals(action)) {
                    view = "UPDATE_SAMPLE_PAGE";
                    title = updateSamplePgTle;
                } else if ("SAVE_AND_REFRESH".equals(action)) {
                    sampleModel.load(oid);
                    //sampleModel.refreshFitSample();
                    %>

                   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
                        <jsp:param name="oid" value="<%= oid %>" />
                        <jsp:param name="activity" value="UPDATE_SAMPLE" />
                        <jsp:param name="action" value="INIT" />
                        <jsp:param name="returnOid" value="<%= returnOid %>" />
                        <jsp:param name="returnActivity" value ="<%= returnActivity%>" />
                        <jsp:param name="returnAction" value="<%= returnAction%>" />
                    </jsp:forward>
                <%
                 }else if("SAVE_AND_TOGGLE".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oid" value='<%= request.getParameter("nextSampleOid") %>' />
					<jsp:param name="activity" value="UPDATE_SAMPLE" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="returnOid" value="<%= returnOid %>" />
					<jsp:param name="returnActivity" value ="<%= returnActivity%>" />
					<jsp:param name="returnAction" value="<%= returnAction%>" />
					</jsp:forward>
               <%
                }else if("SAVE_AND_REF_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oid" value='null' />
					<jsp:param name="activity" value="CREATE_DOCUMENT" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="isDocRefActivity" value="true" />
					<jsp:param name="type" value="" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
               <%
                }else if("SAVE_AND_ADD_DOC".equals(action)){ 
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oids" value='<%= request.getParameter("oids") %>' />
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="ADD_DOCUMENT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
				<%
                }else if("SAVE_AND_REMOVE_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="docRefId" value='<%= request.getParameter("docRefId") %>' />
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="REMOVE_DOCUMENT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>

				<%
                }else if("SAVE_AND_UPDATE_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oid" value='<%= request.getParameter("docRefId") %>' />
					<jsp:param name="activity" value="UPDATE_DOCUMENT" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>

				<%
                }else if("SAVE_AND_REMOVE_ALL_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="REMOVE_DOCUMENTS" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>				

				<%
                }else if("SAVE_AND_DOC_HISTORY".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="VIEW_ITERATIONS" />
					<jsp:param name="action" value="ITERATIONS" />
					<jsp:param name="oid" value='<%= request.getParameter("docRefId") %>' />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>

               <%
               } else {
                    view = "SAFE_PAGE";
                    title = sampleDetailsPgTle;
                    action = "INIT";
                    activity = "VIEW_SAMPLE";
                    checkReturn = true;
                }

           } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = "UPDATE_SAMPLE_PAGE";
                title = updateSamplePgTle;
            }

        } else if("CANCEL".equals(action)){
            sampleModel.load(oid);
			view = "SAFE_PAGE";
			title = sampleDetailsPgTle;
			checkReturn = true;
			if(!FormatHelper.hasContent(returnActivity)){
				returnActivity = "VIEW_SAMPLE";
			}

        } else if("REFRESH".equals(action)){
            sampleModel.load(oid);
            sampleModel.refreshFitSample();
            view = "SAFE_PAGE";
            title = sampleDetailsPgTle;
            action = "INIT";
            activity = "UPDATE_SAMPLE";
        }

        flexType = sampleModel.getFlexType();

///////////////////////////////////////////////////////////////////
    }else if("VIEW_MULTIPLE_SAMPLE".equals(activity)){
                 
        if(!FormatHelper.hasContent(action) || "INIT".equals(action) || "".equals(action)){
        	lcsContext.setCacheSafe(true);  
            if(FormatHelper.hasContent(request.getParameter("nextSampleOid"))){
               oid = request.getParameter("nextSampleOid");
            }
            if(oid.indexOf("LCSSampleRequest")>-1){
               sampleRequestModel.load(oid); 
            }else{
               sampleModel.load(oid);
            }
            

        returnActivity = "";
       
        view = "VIEW_MULTIPLE_SAMPLE_PAGE";
        title = viewSamplePgTle;
        
        }else if("CANCEL".equals(action)){
        	LCSSample sample = null;
			LCSSampleRequest sampleRequest = null;
			String sampleRequestId = "";
			if(oid.indexOf("LCSSampleRequest:")>-1){
				sampleRequestModel.load(oid);
				sampleRequestId = oid;
				sampleRequest = sampleRequestModel.getBusinessObject();
				Collection samplesData = (new LCSSampleQuery()).findSamplesIdForSampleRequest(sampleRequest, false);
			    if(samplesData.size()>0){
					String sampleOid = "com.lcs.wc.sample.LCSSample:" + ((FlexObject)samplesData.iterator().next()).getString("LCSSAMPLE.IDA2A2");
				    sampleModel.load(sampleOid);
				    sample = sampleModel.getBusinessObject();
				   }
				flexType = sampleRequestModel.getFlexType();
			}else{
				sampleModel.load(oid);
				sampleRequestId = FormatHelper.getObjectId(sampleModel.getBusinessObject().getSampleRequest());
				sample = sampleModel.getBusinessObject();
				flexType = sampleModel.getFlexType();
			}
			additionalParameters = "measurementsId=" + request.getParameter("measurementsId") + "&sampleRequestId=" + sampleRequestId + "&requestTypeId=" + FormatHelper.getObjectId(flexType) + "&runSampleSearch=true";
			view = "SAFE_PAGE";
			title = sampleDetailsPgTle;
			checkReturn = true;
			if(!FormatHelper.hasContent(returnActivity)){
                returnActivity = "VIEW_SEASON_PRODUCT_LINK";
                returnOid = appContext.getActiveProductId();
                if (returnOid == null){                
			    	wt.part.WTPartMaster master = sample.getSpecMaster();
                	Iterator versions = VersionHelper.allVersionsOf(master).iterator();
	                if (versions.hasNext()) {
	                    FlexSpecification spec = (FlexSpecification)versions.next();
	                    returnOid = FormatHelper.getVersionId(spec);
	           
	                }
                }
			}

        } 
        flexType = sampleModel.getFlexType();
    ///////////////////////////////////////////////////////////////////
    /**
    * 
    * Target Point Build: 004.23
    * Request ID : <20>
    * Modified On: 14-June-2013
    * PDF Export
    * @author Shamel
    */
   }else if("SAMPLE_REPORT".equals(activity)){
		if("GENERATE_PDF".equals(action)){
			oid = request.getParameter("oid");
			sampleRequestModel.load(oid);
			
			com.lfusa.wc.sample.LFPDFSampleRequestGenerator lfPDFSampleRequestGenerator	=	new com.lfusa.wc.sample.LFPDFSampleRequestGenerator(sampleRequestModel.getBusinessObject());
			String pdfURL = lfPDFSampleRequestGenerator.generatePdf();
			//System.out.println("requestData : " + requestData);
			//DLLineSheetReport dlLineSheetReport = new DLLineSheetReport();
			//String excelURL = dlLineSheetReport.generateExcelURL(requestData);
			request.setAttribute("SAMPLE_REPORT_URL", pdfURL);     
			view = "VIEW_MULTIPLE_SAMPLE_PAGE";
            title = viewSamplePgTle;
		}

/**
    * 
    * Target Point Build: 004.23
    * Request ID : <20>
    * Modified On: 14-June-2013
    * PDF Export
    * @author Shamel
    */
   }else if("CREATE_MULTIPLE_SAMPLE".equals(activity)){

        if(action == null || "INIT".equals(action) || "".equals(action)){

            title = createSamplePgTle;
            view = "CLASSIFY_PAGE";
            //type="";

        } else if("CLASSIFY".equals(action)){
            lcsContext.setCacheSafe(true);            
            if(FormatHelper.hasContent(request.getParameter("contextSpecId"))){
                sampleRequestModel.setSpecificationMasterId(request.getParameter("contextSpecId"));
            }else{
                sampleRequestModel.setSpecificationMasterId(request.getParameter("ownerId"));
            }

            if(FormatHelper.hasContent(request.getParameter("directClassifyId"))){
                sampleRequestModel.setTypeId(request.getParameter("directClassifyId"));
                AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request));
                title = createSamplePgTle;
                view = "CREATE_MULTIPLE_SAMPLE_PAGE";
            }
            else{
            	AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request));
                //Need to check to see if it is being set to a restricted type
                FlexType selectedType = sampleRequestModel.getFlexType();

                if(isChildType(fitRoot, selectedType) || isChildType(testReqRoot, selectedType)){
                    errorMessage = sampleTypeError;
                    title = createSamplePgTle;
                    view = "CLASSIFY_PAGE";
                }
                else{
                    title = createSamplePgTle;
                    view = "CREATE_MULTIPLE_SAMPLE_PAGE";
                }
            }

            //title = createSamplePgTle;
            //view = "CREATE_SAMPLE_PAGE";
            sampleRequestModel.setSourcingConfigId(oid);

        } else if("SAVE".equals(action)){

             sampleRequestModel.setSpecificationMasterId(request.getParameter("specMasterId"));
             sampleRequestModel.setTypeId(request.getParameter("typeId"));

             sampleRequestModel.setSourcingConfigId(request.getParameter("sourcingConfigId"));
             sampleRequestModel.setOwnerMasterId(request.getParameter("ownerMasterId"));

             try {
                AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");
				sampleRequestModel.save();
				LCSSampleRequest sampleRequest=sampleRequestModel.getBusinessObject();

				/**
				* 
				* Target Point Build: 004.23
				* Request ID : <7>
				* Modified On: 22-May-2013
				* Method to copy the Sample Quantity Value from the Grid to the corresponding Sample.
				* @author  Bineeta
				*/
				// ITC -  Start
				// SampleQuantity Pair Map : Containing the branch and Sample Quantity value
				Map<String,String> sampleQtyPairMap  = new HashMap<String,String>();
				// Sample Quantity Value from the Gtid
				String qty = request.getParameter("lfFloatSampleQuantity");
				String qty1 = request.getParameter("lfSampleQuantity");
				//System.out.println("qty in controller is **************"+qty);
				//System.out.println("qty int value in controller is **************"+qty1);
				StringTokenizer st = new StringTokenizer(qty , ",");
				
				// Add the branch and Sample Quantity value pair to the Map
				while (st.hasMoreTokens()) {
					String sampleQuantityPair = (String)st.nextToken();
					StringTokenizer st1 = new StringTokenizer(sampleQuantityPair,"-");
					sampleQtyPairMap.put(st1.nextToken().toString(),st1.nextToken().toString());
				}
				// Collection of the  Samples created for the Sample Request
				Collection samplesData = (new LCSSampleQuery()).findSamplesIdForSampleRequest((LCSSampleRequest)sampleRequestModel.getBusinessObject(), false);
				// If the size of Collection of Sample obtained is greater than 0
				if(samplesData.size()>0){
					Iterator sampleIterator = samplesData.iterator();
					while (sampleIterator.hasNext()){
						// oid of the Sample
						oid = "com.lcs.wc.sample.LCSSample:" + ((FlexObject)sampleIterator.next()).getString("LCSSAMPLE.IDA2A2");
						sampleModel.load(oid);
						AttributeValueSetter.setAllAttributes(sampleModel, RequestHelper.hashRequest(request), "LCSSAMPLE");
						// temporary Sample Request Object (to persist Sample in the Updated Sample Request - For Name)
						LCSSampleRequest tempCreateSampleRequest= sampleModel.getBusinessObject().getSampleRequest();
						AttributeValueSetter.setAllAttributes(tempCreateSampleRequest, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");
						String temp = sampleModel.getValue("sampleSequence").toString();
						String sequence = StringUtils.substringBefore(temp,".");
						// Set the Sample Quantity wrt the sequence the sample is created
						//System.out.println("qty 1111 in controller is **************"+sampleQtyPairMap.get(sequence));
						sampleModel.setValue("lfFloatSampleQuantity", sampleQtyPairMap.get(sequence));
						// Save the Sample
						sampleModel.save();
					}				
				}else{
					//do nothing
				}
				// ITC - End
                oid = FormatHelper.getObjectId(sampleRequestModel.getBusinessObject());
              

				if(UPDATE_SAMPLE_AFTER_CREATION.equalsIgnoreCase("true")){%>
                   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
                        <jsp:param name="oid" value="<%= oid %>" />
                        <jsp:param name="activity" value="UPDATE_MULTIPLE_SAMPLE" />
                        <jsp:param name="action" value="INIT" />
                        <jsp:param name="returnOid" value="<%= returnOid %>" />
                        <jsp:param name="returnActivity" value ="<%= returnActivity%>" />
                        <jsp:param name="returnAction" value="<%= returnAction%>" />
                    </jsp:forward>	
               <%
				}else{
                    title = viewSamplePgTle;
                    action = "INIT";
                    activity = "VIEW_SAMPLE";
                    checkReturn = true;
                }
	
	
		additionalParameters = "sampleRequestId="+oid+"&requestTypeId="+request.getParameter("typeId")+"&runSampleSearch=true";
		//End --Rohini

               } catch(LCSException e){
                    view = "CREATE_SAMPLE_PAGE";
                    title = createSamplePgTle;
                    errorMessage=e.getLocalizedMessage();
               }
               checkReturn = true;
        }
        flexType = sampleRequestModel.getFlexType();        
        
    ///////////////////////////////////////////////////////////////////
    } else if("UPDATE_MULTIPLE_SAMPLE".equals(activity)){

        if(action == null || "INIT".equals(action) || "".equals(action)){
		
					
		
            lcsContext.setCacheSafe(true);
            if(oid.indexOf("LCSSampleRequest")>-1){
               sampleRequestModel.load(oid);          
            }else{
               sampleModel.load(oid);
				//Added for sample quantity to decimal changes
				 LCSSample sample1  = sampleModel.getBusinessObject();
			    System.out.println("lese update page started sample****1111*******"+sample1.getValue("lfSampleQuantity"));
				System.out.println("lese update page started sample****1111*******"+sample1.getValue("lfFloatSampleQuantity"));
				String floatSampleQty=(String)sample1.getValue("lfFloatSampleQuantity").toString();
				System.out.println("floatSampleQty sample****update*******"+floatSampleQty);
				String intSampleQty=(String)sample1.getValue("lfSampleQuantity").toString();
				System.out.println("intSampleQty sample****update*******"+intSampleQty);
				double doubleSamplValue = Double.parseDouble(intSampleQty);
			
				if(floatSampleQty.equalsIgnoreCase("0.0")){
					System.out.println("inside if  sample****1111*******"+doubleSamplValue);
					sample1.setValue("lfFloatSampleQuantity",doubleSamplValue);
				}
				//end of Added for sample quantity to decimal changes
               if (forceRefreshSample){
            	   sampleModel.refreshFitSample();
               }
            }
			if(!FormatHelper.hasContent(returnActivity) || "UPDATE_MULTIPLE_SAMPLE".equals(returnActivity)){
				if (!FormatHelper.hasContent(returnOid)){
					returnOid = oid;
				}
				returnActivity = "VIEW_MULTIPLE_SAMPLE";
			}

            view = "UPDATE_MULTIPLE_SAMPLE_PAGE";
            title = updateSamplePgTle;

        } else if("SAVE".equals(action)|| "SAVE_AND_RETURN".equals(action) || "SAVE_AND_TOGGLE".equals(action) ||"SAVE_AND_DELETE_IMAGE".equals(action) || "SAVE_AND_REF_DOC".equals(action) || "SAVE_AND_DESC_DOC".equals(action) || "SAVE_AND_ADD_DOC".equals(action) || "SAVE_AND_REMOVE_DOC".equals(action) || "SAVE_AND_REMOVE_ALL_DOC".equals(action) || "SAVE_AND_REMOVE_ALL_DESCRIBED_BY_DOC".equals(action) || "SAVE_AND_REMOVE_ALL_REF_DOC".equals(action) || "SAVE_AND_REFRESH_FIT".equals(action) || "SAVE_AND_UPDATE_MEASUREMENTS".equals(action) || "SAVE_AND_UPDATE_DOC".equals(action) || "SAVE_AND_DOC_HISTORY".equals(action)){
			/**
			* 
			* Target Point Build: 004.23
			* Request ID : <7>
			* Modified On: 28-May-2013
			* Method to copy the Sample Quantity Value from the Grid to the 
			* corresponding Sample from the Update Sample Request page.
			* @author  Bineeta
			*/
			// ITC -  Start
			
			// LCS Sample Client Model
			LCSSampleClientModel tempSampleClientModel = new LCSSampleClientModel();
			// Collection of Exsisting Sample Sequences
			Collection existingSampleSequences = new Vector();
			// Higest Seqence Existing
			String tempHighestSequenceStr = ""; 
			String highestSequenceStr = ""; 
			// SampleQuantity Pair Map : Containing the branch and Sample Quantity value
			Map<String,String> sampleQtyPairMap  = new HashMap<String,String>();
            try{
                sampleModel.load(oid);
                AttributeValueSetter.setAllAttributes(sampleModel, RequestHelper.hashRequest(request), "LCSSAMPLE");

                LCSSampleRequest sampleRequest= sampleModel.getBusinessObject().getSampleRequest();
                AttributeValueSetter.setAllAttributes(sampleRequest, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");
				
				// Collection of Branch ID and Custom Sample Quantity pair 
				// saved from the Sample Update Request page.
				if ("SAVE".equals(action)){
					// Sample Quantity Value from the Gtid
					String qty = request.getParameter("lfFloatSampleQuantity");
					//System.out.println("qty in update is **************"+qty);
					StringTokenizer st = new StringTokenizer(qty , ",");
					// Add the branch and Sample Quantity value pair to the Map
					while (st.hasMoreTokens()) {
						String sampleQuantityPair = (String)st.nextToken();
						StringTokenizer st1 = new StringTokenizer(sampleQuantityPair,"-");
						sampleQtyPairMap.put(st1.nextToken().toString(),st1.nextToken().toString());
					}
				}

                boolean fitSample = FormatHelper.parseBoolean(request.getParameter("fitSample"));
                if(fitSample && !"SAVE_AND_REFRESH_FIT".equals(action) && !"SAVE_AND_UPDATE_MEASUREMENTS".equals(action)){
                    String dataString = MultiObjectHelper.createPackagedStringFromMultiForm(request, LCSMeasurementsQuery.NULL_VALUE_PLACEHOLDER);
// Collection if Existing Samples OID
                    Collection existingSamples = new Vector();
					// Iterator for Collection if Existing Samples
					Iterator existingSamplesResults = (new LCSSampleQuery()).findSamplesIdForSampleRequest(sampleRequest, false).iterator();
					while (existingSamplesResults.hasNext()){
						FlexObject obj = (FlexObject) existingSamplesResults.next();
						existingSamples.add(obj.get("LCSSAMPLE.IDA2A2"));
						// OID of the Sample Object
						oid = "OR:com.lcs.wc.sample.LCSSample:"+obj.get("LCSSAMPLE.IDA2A2");
						tempSampleClientModel.load(oid);
						// Collection of Exsisting Sample Sequences
						existingSampleSequences.add(tempSampleClientModel.getValue("sampleSequence"));
					}
					
					// If Sample sequences Collectde is not Empty
					if(!existingSampleSequences.isEmpty()){
						// The Higest Sample sequences created till present
						tempHighestSequenceStr = (Collections.max(existingSampleSequences)).toString();
					}else{
						//do nothing
					}
                    
					// Update Sample Request
					sampleModel.updateFitSample(dataString, sampleRequest);
					
					// Collection of Sample OID after Update
					Collection newAndExistingSamples = new Vector();
					// Iterator for Collection of Sample OID after Update
					Iterator results = (new LCSSampleQuery()).findSamplesIdForSampleRequest(sampleRequest, false).iterator();
					while (results.hasNext()){
						FlexObject obj = (FlexObject) results.next();
						newAndExistingSamples.add(obj.get("LCSSAMPLE.IDA2A2"));
					}
					// Collection of only the new Samples Created after Updated
					newAndExistingSamples.removeAll(existingSamples);
					if(newAndExistingSamples.size()>0){
						// Iterator  for Collection of only the new Samples Created after Updated
						Iterator sampleIterator = newAndExistingSamples.iterator();
						while (sampleIterator.hasNext()){
							// oid of the Sample Object
							oid = "OR:com.lcs.wc.sample.LCSSample:" + sampleIterator.next();
							// temporary client model of the sample Object
							tempSampleClientModel.load(oid);
							AttributeValueSetter.setAllAttributes(tempSampleClientModel, RequestHelper.hashRequest(request), "LCSSAMPLE");
							// temporary Sample Request Object (to persist Sample in the Updated Sample Request - For Name)
							LCSSampleRequest tempUpdateSampleRequest= tempSampleClientModel.getBusinessObject().getSampleRequest();
							AttributeValueSetter.setAllAttributes(tempUpdateSampleRequest, RequestHelper.hashRequest(request), "LCSSAMPLEREQUEST");

							// the Sequence of the new Sample Created
							String temp = tempSampleClientModel.getValue("sampleSequence").toString();
							String actualSequenceStr = StringUtils.substringBefore(temp,".");
							// the Higest Sample sequences created before updated
							highestSequenceStr = StringUtils.substringBefore(tempHighestSequenceStr,".");
							//Integer value for operation
							int actualSequenceInt = Integer.parseInt(actualSequenceStr);
							int higestSequenceInt = Integer.parseInt(highestSequenceStr);
							// Branch ID for the Sample Quantity Pair Map
							int branchID = actualSequenceInt - higestSequenceInt;
							// Set the Sample Quantity wrt the sequence the sample is created
							tempSampleClientModel.setValue("lfFloatSampleQuantity", sampleQtyPairMap.get(String.valueOf(branchID)));
							// Save the Sample
							tempSampleClientModel.save();
							//Set the Action
							action = "SAVE_AND_RETURN";
						}
					}else{
							//do Nothing
					}
					// Update Sample Request
					oid = FormatHelper.getObjectId(tempSampleClientModel.getBusinessObject());
					//additionalParameters = java.net.URLEncoder.encode("measurementsId=" + request.getParameter("measurementsId"));
                    additionalParameters = "measurementsId=" + request.getParameter("measurementsId");
                } else {
                
                    sampleModel.save(sampleRequest);
                    oid = FormatHelper.getObjectId(sampleModel.getBusinessObject());
                }
	       additionalParameters += "&sampleRequestId=OR:"+sampleRequest+"&requestTypeId="+request.getParameter("typeId")+"&runSampleSearch=true";

               if ("SAVE_AND_DELETE_IMAGE".equals(action)) {
                    oid = request.getParameter("imagePageId");
					activity = "DELETE_IMAGEPAGE";
					action = "INIT";
		            view = "SAFE_PAGE";
                } else if ("SAVE_AND_RETURN".equals(action)) {
					activity = "UPDATE_MULTIPLE_SAMPLE";
					action = "INIT";
		            view = "SAFE_PAGE";
					if(FormatHelper.hasContent(returnOid) && returnOid.indexOf("LCSSample")>-1){
						returnOid = oid;
					}
					additionalParameters += "&measurementsFormat=" +request.getParameter("measurementsFormat") + "&imagePageId=" + request.getParameter("imagePageId");

                }else if("SAVE_AND_TOGGLE".equals(action)){    
					oid = request.getParameter("nextSampleOid");
					activity = "UPDATE_MULTIPLE_SAMPLE";
					action = "INIT";
		            view = "SAFE_PAGE";
					additionalParameters += "&measurementsFormat=" +request.getParameter("measurementsFormat");
					
                }else if("SAVE_AND_REF_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oid" value='null' />
					<jsp:param name="activity" value="CREATE_DOCUMENT" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="isDocRefActivity" value="true" />
					<jsp:param name="addReferenceDocumentType" value="referenceDoc" />
					<jsp:param name="type" value="" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
               <%
			    }else if("SAVE_AND_DESC_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oid" value='null' />
					<jsp:param name="activity" value="CREATE_DOCUMENT" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="isDocRefActivity" value="true" />
					<jsp:param name="addReferenceDocumentType" value="describedByDoc" />
					<jsp:param name="type" value="" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
               
			   <%
                }else if("SAVE_AND_ADD_DOC".equals(action)){ 
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oids" value='<%= request.getParameter("oids") %>' />
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="ADD_DOCUMENT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
				<%
                }else if("SAVE_AND_REMOVE_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="docRefId" value='<%= request.getParameter("docRefId") %>' />
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="REMOVE_DOCUMENT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>

				<%
                }else if("SAVE_AND_UPDATE_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="oid" value='<%= request.getParameter("docRefId") %>' />
					<jsp:param name="activity" value="UPDATE_DOCUMENT" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>

				<%
                }else if("SAVE_AND_REMOVE_ALL_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="REMOVE_DOCUMENTS" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
					
				<%
                }else if("SAVE_AND_REMOVE_ALL_DESCRIBED_BY_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="REMOVE_DOCUMENTS" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="removeReferenceDocuments" value ="describedByDoc" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
					
				<%
                }else if("SAVE_AND_REMOVE_ALL_REF_DOC".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="ASSOCIATE_DOCUMENTS" />
					<jsp:param name="action" value="REMOVE_DOCUMENTS" />
					<jsp:param name="targetOid" value="<%=oid%>" />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="removeReferenceDocuments" value ="referenceDoc" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
					
				<%
                }else if("SAVE_AND_REFRESH_FIT".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="action" value="REFRESH" />
					<jsp:param name="LCSSAMPLE_measurementsFormat" value='<%=request.getParameter("LCSSAMPLE_measurementsFormat")%>' />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					<jsp:param name="origActivity" value="<%= origActivity %>" />
					<jsp:param name="origOid" value="<%= origOid %>" />
					</jsp:forward>
				<%
                }else if("SAVE_AND_UPDATE_MEASUREMENTS".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="EDIT_MEASUREMENTS" />
					<jsp:param name="action" value="INIT" />
					<jsp:param name="oid" value='<%=request.getParameter("measurementsId")%>' />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					<jsp:param name="origActivity" value="<%= returnActivity %>" />
					<jsp:param name="origOid" value="<%= returnOid %>" />
					</jsp:forward>
              
			  	<%
                }else if("SAVE_AND_DOC_HISTORY".equals(action)){    
                %>
				   <jsp:forward page='<%=subURLFolder + "/jsp/main/Main.jsp" %>'>
					<jsp:param name="activity" value="VIEW_ITERATIONS" />
					<jsp:param name="action" value="ITERATIONS" />
					<jsp:param name="oid" value='<%= request.getParameter("docRefId") %>' />
					<jsp:param name="returnOid" value="<%= oid %>" />
					<jsp:param name="returnActivity" value ="UPDATE_MULTIPLE_SAMPLE" />
					<jsp:param name="returnAction" value="INIT" />
					</jsp:forward>
			   
			   <%
                    
                } else {
                    view = "SAFE_PAGE";
                    title = sampleDetailsPgTle;
                    action = "INIT";
                    activity = "VIEW_MULTIPLE_SAMPLE";
                    checkReturn = true;
                }

           } catch(LCSException e){
                errorMessage = e.getLocalizedMessage();
                view = "UPDATE_MULTIPLE_SAMPLE_PAGE";
                title = updateSamplePgTle;
            }

        } else if("CANCEL".equals(action)){
			String sampleRequestId = "";
			if(oid.indexOf("LCSSampleRequest:")>-1){
				sampleRequestModel.load(oid);
				sampleRequestId = oid;
				flexType = sampleRequestModel.getFlexType();
			}else{
				sampleModel.load(oid);
				sampleRequestId = FormatHelper.getObjectId(sampleModel.getBusinessObject().getSampleRequest());
				flexType = sampleModel.getFlexType();
			}
			
			additionalParameters = "measurementsId=" + request.getParameter("measurementsId") + "&sampleRequestId=" + sampleRequestId + "&requestTypeId=" + FormatHelper.getObjectId(flexType) + "&runSampleSearch=true" + "&measurementsFormat=" +request.getParameter("measurementsFormat");
			view = "SAFE_PAGE";
			title = sampleDetailsPgTle;
			checkReturn = true;
			if(!FormatHelper.hasContent(returnActivity)){
				returnActivity = "VIEW_MULTIPLE_SAMPLE";
			}

        } else if("REFRESH".equals(action)){
            sampleModel.load(oid);
            sampleModel.refreshFitSample();
			checkReturn = true;
            title = sampleDetailsPgTle;
            returnAction = "INIT";
            returnActivity = "UPDATE_MULTIPLE_SAMPLE";
			additionalParameters = "measurementsFormat=" +request.getParameter("measurementsFormat");
        }

        flexType = sampleRequestModel.getFlexType();
		if(flexType==null){
           flexType = sampleModel.getFlexType();
		}

	}else if("BULK_CREATE_SAMPLE".equals(activity)){

		if(action == null || "INIT".equals(action) || "".equals(action)){
            lcsContext.setCacheSafe(true);
			if(appContext.getActiveProductId() == null && !FormatHelper.hasContent(request.getParameter("fromLineSheet"))){
				appContext.setProductContext(oid);
			}
            view = "BULK_CREATE_SAMPLE_PAGE";
            title = "";

            additionalParameters = request.getParameter("additionalParameters");

        } else if("SAVE".equals(action)){
			HashMap results = new HashMap();
             String dataString = request.getParameter("dataString");

			 if(FormatHelper.hasContent(dataString)){
				HashMap map = new HashMap();
				StringTokenizer st = new MultiCharDelimStringTokenizer(dataString, MultiObjectHelper.ATTRIBUTE_DELIMITER);
				StringTokenizer st2;
				StringTokenizer st3;
				String keyValuePair = "";
				String key = "";
				String value = "";

				while(st.hasMoreTokens()){
					keyValuePair = st.nextToken();
					//System.out.println("***" + keyValuePair);
					st2 = new MultiCharDelimStringTokenizer(keyValuePair, MultiObjectHelper.NAME_VALUE_DELIMITER);
					if(st2.hasMoreTokens()){
						key = st2.nextToken();														
						if(st2.hasMoreTokens()){
							map.put(key, st2.nextToken());
						}else{
							map.put(key, "");
						}
					}
				}
				dataString = MultiObjectHelper.createPackagedStringFromMultiFormMap2(map);
			    results = new BulkSampleCreationUtility().bulkCreate(dataString, request.getLocale().toString());
				String totalObjectCreated = "0";
				if(results.get("totalCreatedObjects")!=null){
					totalObjectCreated = (String)results.get("totalCreatedObjects");
				}
				infoMessage = "totalCreatedObjects:" + totalObjectCreated;

				if(results.get("failedRows") != null){
					String failedRows = (String)results.get("failedRows");

				}
				if(results.get("errorMessages") != null){
					errorMessage = (String)results.get("errorMessages");
				}			 
			 }
			view = "BULK_CREATE_SAMPLE_PAGE";
			title = "";
			ajaxWindow = "true";
			templateName = AJAX_TEMPLATE;
		}
    } else if("UPDATE_SAMPLE_IMAGE".equals(activity)){
       if("SAVE".equals(action)){
            if(oid.indexOf("LCSSampleRequest")>-1){
                sampleRequestModel.load(oid);       
                AttributeValueSetter.setAllAttributes(sampleRequestModel, RequestHelper.hashRequest(request));
				sampleRequestModel.save();
			}else{
                sampleModel.load(oid);
                AttributeValueSetter.setAllAttributes(sampleModel, RequestHelper.hashRequest(request));
				sampleModel.save();
            }
       

	   }
		view = "SAFE_PAGE";
		title = sampleDetailsPgTle;
		action = returnAction;
		activity = returnActivity;
		checkReturn = true;

    ///////////////////////////////////////////////////////////////////
    // ACTIVITY = DELETE
    ///////////////////////////////////////////////////////////////////
    } else if("DELETE_SAMPLE".equals(activity)){
        try{
            sampleModel.load(oid);
            LCSSampleHelper.service.deleteSample(sampleModel.getBusinessObject());
            additionalParameters = "measurementsId=" + request.getParameter("measurementsId")+"&sampleRequestId="+request.getParameter("sampleRequestId")+"&requestTypeId="+request.getParameter("requestTypeId")+"&runSampleSearch=true";
            checkReturn=true;
        } catch(LCSException e){
            e.printStackTrace();
            errorMessage = e.getLocalizedMessage();
        }
     } else if("DELETE_SAMPLE_REQUEST".equals(activity)){
        try{
            sampleRequestModel.load(oid);
	    LCSSampleHelper.service.deleteSampleRequest(sampleRequestModel.getBusinessObject());
            additionalParameters = "measurementsId=" +request.getParameter("measurementsId")+"&requestTypeId="+request.getParameter("requestTypeId");
	    checkReturn=true;
        } catch(LCSException e){
            e.printStackTrace();
            errorMessage = e.getLocalizedMessage();
        }


    ///////////////////////////////////////////////////////////////////
    // ACTIVITY = FIND
    ///////////////////////////////////////////////////////////////////
    } else if("FIND_SAMPLE".equals(activity)){
        lcsContext.setCacheSafe(true);
        if(action == null || "".equals(action) || "INIT".equals(action)){
            view = "FIND_SAMPLE_CRITERIA";
            title = sampleSearchCriteriaPgTle;
            type = "";

        } else if("CHANGE_TYPE".equals(action)){
            view = "FIND_SAMPLE_CRITERIA";
            title = sampleSearchCriteriaPgTle;
            type = request.getParameter("type");
            flexType = FlexTypeCache.getFlexType(type);

        } else if("SEARCH".equals(action)){
			if("true".equals(request.getParameter("updateMode"))){
				formType = "image";
			}
            view = "FIND_SAMPLE_RESULTS";
            title = sampleSearchResultsPgTle;

        } else if("RETURN".equals(action)){
            checkReturn = true;
        }

    } else if("FIND_SAMPLE_SEARCH_CRITERIA".equals(activity)){
        lcsContext.setCacheSafe(true);
        view = "FIND_SAMPLE_SEARCH_CRITERIA";
            title = "";
            String stContentPage = PageManager.getPageURL(view,null);
            %>
            <jsp:forward page="<%= subURLFolder + stContentPage %>">
                <jsp:param name="title" value="<%= java.net.URLEncoder.encode(title, defaultCharsetEncoding)%>" />
            </jsp:forward>
    <%
	}else if("FIND_MEASUREMENTSET_AND_SIZE".equals(activity)){
        lcsContext.setCacheSafe(true);
        view = "FIND_MEASUREMENTSET_AND_SIZE";
            title = "";
            String stContentPage = PageManager.getPageURL(view,null);
            %>
            <jsp:forward page="<%= subURLFolder + stContentPage %>">
                <jsp:param name="title" value="<%= java.net.URLEncoder.encode(title, defaultCharsetEncoding)%>" />
            </jsp:forward>
    <%
	}

    ////////////////////////////////////////////////////////////////////////////
    // GET THE CLIENT MODEL'S FLEX TYPE FULL NAME
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
        view = "SAFE_PAGE";
        title = WTMessage.getLocalizedMessage (RB.MAIN, "productName", RB.objA ) ;
        action = returnAction;
        activity = returnActivity;
        oid = returnOid;
        returnActivity = "";
        returnAction = "";
        returnOid = "";
        if (FormatHelper.hasContent(origActivity))
            returnActivity = origActivity;
        if (FormatHelper.hasContent(origOid))
        	returnOid=origOid;
    }

    String contentPage = null;
    if(view != null){
        contentPage = PageManager.getPageURL(view, null);
    } else {
        contentPage = "";
    }
 %>

<jsp:forward page="<%=subURLFolder+ templateName %>">
   <jsp:param name="title" value="<%= java.net.URLEncoder.encode(title, defaultCharsetEncoding)%>" />
   <jsp:param name="infoMessage" value="<%= infoMessage %>" />
   <jsp:param name="errorMessage" value="<%= java.net.URLEncoder.encode(errorMessage, defaultCharsetEncoding) %>" />
   <jsp:param name="requestedPage" value="<%= contentPage %>" />
   <jsp:param name="contentPage" value="<%= contentPage %>" />
    <jsp:param name="oid" value="<%= oid %>" />
    <jsp:param name="action" value="<%= action %>" />
    <jsp:param name="formType" value="<%= formType %>" />
    <jsp:param name="activity" value="<%= activity %>" />
    <jsp:param name="measurementsId" value="<%= measurementsId %>" />
    <jsp:param name="additionalParameters" value="<%= additionalParameters %>" />
   <jsp:param name="objectType" value="Sample" />
   <jsp:param name="typeClass" value="com.lcs.wc.sample.LCSSample" />
   <jsp:param name="type" value="<%= type %>" />
   <jsp:param name="rootTypeId" value="<%= rootTypeId %>" />
   <jsp:param name="flexTypeName" value="<%= flexTypeName %>" />
    <jsp:param name="tabId" value="<%= tabId %>" />
    <jsp:param name="returnActivity" value="<%= returnActivity %>" />
    <jsp:param name="returnOid" value="<%= returnOid %>" />
    <jsp:param name="returnAction" value="<%= returnAction %>" />
    <jsp:param name="ajaxWindow" value="<%=ajaxWindow%>" />
    <jsp:param name="origActivity" value="<%=origActivity%>" />
    <jsp:param name="origOid" value="<%=origOid%>" />

</jsp:forward>
