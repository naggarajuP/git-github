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
            com.lcs.wc.season.*,
            com.lcs.wc.util.*,
            java.util.*,
            wt.util.WTMessage,
			com.lfusa.wc.ibtinterface.util.LFIBTUtil,
			com.lfusa.wc.sapinterface.util.LFSAPUtil"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%!
    public static final String JSPNAME = "LFIBTAjaxAdoptProductValidate.jsp";
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final String NAME_SEPERATOR = ",";
    public static final boolean DEBUG = LCSProperties.getBoolean("jsp.placeholder.LFIBTAjaxAdoptProductValidate.verbose");

%>

<%
	if(DEBUG) {LCSLog.debug(JSPNAME);}
    try {
    	String message = "All The products are adopted";
		String responseString="";
    	String seasonId = request.getParameter("oid");
    	System.out.println("seasonId======1111=====" + seasonId);
		 String selectedProducts = request.getParameter("selectedProducts");
		System.out.println("selectedProducts===========" + selectedProducts);
	
		Collection productIdsList = null;
		Collection adoptedProdList = new Vector();
		Collection nonadoptedProdList = new Vector();
		LCSSeasonProductLink seasonProdLink = null;
		LCSSeason season = null;
		//String placeholderstatus = "";
		boolean isIBTValidproduct=false;
		String season_type = "";
		String season_year = "";
		boolean season_validation = false;
		
		if(FormatHelper.hasContent(seasonId)){
			season = (LCSSeason)LCSQuery.findObjectById(seasonId);
			//addded to validate season year. 
			season_type = (String)season.getValue("lfRootSeason");
			season_year = (String)season.getValue("lfRootSeasonYear");
			 if ( FormatHelper.hasContent(season_type)){
					  if ( !FormatHelper.hasContent(season_year) ) {
					  season_validation = false;
					  responseString = responseString + "|" + "stagingstatus:false|alert:true|" ;
	 			      message = "Please fill Season Year in Season Detail Page";
					   if(FormatHelper.hasContent(message)){            
							responseString = responseString + "message:" + message;
						}
					  out.print(responseString);
					}else{
					   season_validation = true;
					}
				 
			}else{
					season_validation = false;
					responseString = responseString + "|" + "stagingstatus:false|alert:true|" ;
	 			      message = "Please fill Season Type in Season Detail Page";
					   if(FormatHelper.hasContent(message)){            
							responseString = responseString + "message:" + message;
						}
					  out.print(responseString);
			}
			// end
		}


		if(season_validation){
			
		if(FormatHelper.hasContent(selectedProducts)){
			productIdsList =  MOAHelper.getMOACollection(selectedProducts);
		}

		 Iterator productObjectIterator = productIdsList.iterator();
		
	     //get the product season links for the products that have been
	     //selected since the OOTB attribute is created at product-season scope
	     responseString = responseString + "adoptedIds:";
		 LCSProduct lcsProduct = null;
		 LCSProduct lcsProductAVersion = null;
		  while(productObjectIterator.hasNext()){
			String prodId =(String)productObjectIterator.next();
			lcsProduct = (LCSProduct)LCSQuery.findObjectById(prodId);
			lcsProductAVersion = (LCSProduct) VersionHelper.getVersion(lcsProduct, "A");
			seasonProdLink = LCSSeasonQuery
				.findSeasonProductLink(lcsProduct, season);
						
			//(String)seasonProdLink.getValue("lfRootProductInStoreMonth");
			//isIBTValidproduct = (String)lcsProduct.getValue("lfRootValidatedforIBT");
			
			boolean isSAPValidproduct=LFSAPUtil.isProductvalidatedforSAP(lcsProductAVersion);
			
			boolean isprodAdopted=false;
							
			String productStatus = (String)seasonProdLink.getValue("lfRootProductStatus");
			if(productStatus!=null)
			{
			System.out.println("productStatus:"+ productStatus);
			if (productStatus.equalsIgnoreCase("adopted"))
			{
			isprodAdopted=true;
			
			} 
			else
			{
				isprodAdopted=false;
			}
			}
				
			//sort the products into seperate lists of 
			//adopted and non adopted products. 
			
			if((!isSAPValidproduct))
			{
				nonadoptedProdList.add(prodId);		
			}
			else
			{
				if(isprodAdopted){
				responseString = responseString + prodId + "~";
				adoptedProdList.add(prodId);
				}else{
					nonadoptedProdList.add(prodId);	
				}
			}

		  }
	     
		  //generate the message if even one of the products is non-adopted
	     if(nonadoptedProdList.size()>0){
	    	 if(nonadoptedProdList.size() == productIdsList.size()){

	 	    	responseString = responseString + "|" + "stagingstatus:false|alert:true|" ;
	 			message = "Please fill the AX mandatory attributes for the product before continuing.";
	    	 }
		else {	    	 
	    	responseString = responseString + "|" + "stagingstatus:false|" ;
			message = "Not every product selected is Validated for IBT. Do you want to continue without them?";
	    	 }
				
	     }
	     
	     //String adoptedIds = MOAHelper.toMOAString(adoptedProdList);
	     responseString = responseString + "|";
       if(FormatHelper.hasContent(seasonId)){
            
           responseString = responseString + "seasonId:" + seasonId +"|";
        }
		if(!(responseString.indexOf("stagingstatus")>-1)){
			responseString = responseString + "stagingstatus:true|alert:false|" ;
		}

		//generate the appropriate response strings so that 
		//it becomes easier to seperate all the data.I have not introduced any hack over here
        if(FormatHelper.hasContent(message)){
            
           responseString = responseString + "message:" + message;
        }
		System.out.println("responseString: " + responseString);
        out.print(responseString);
	}

    } catch (Exception e){
        e.printStackTrace();

    }
%>
