<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ErrorReport.jsp"
        import="com.lcs.wc.util.*,
                com.lcs.wc.client.Activities,
                com.lcs.wc.client.web.PageManager,
                wt.util.*,
                java.util.*,
                com.lcs.wc.util.json.*,
                com.lcs.wc.flextype.*,
				com.ptc.netmarkets.util.misc.NetmarketURL,
				com.ptc.netmarkets.util.beans.NmURLFactoryBean,
				com.ptc.netmarkets.util.misc.NmAction,
				com.ptc.mvc.util.MVCUrlHelper,
				wt.httpgw.URLFactory,
                com.lcs.wc.client.web.WebControllers"
%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INCLUDED FILES  //////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean  id="url_factory" class="wt.httpgw.URLFactory" scope="request" />
<jsp:useBean id="wtcontext" class="wt.httpgw.WTContextBean" scope="request"/>
<jsp:setProperty name="wtcontext" property="request" value="<%=request%>"/>
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<%
    String browser = request.getHeader("User-Agent");
    if (browser.indexOf("MSIE") > 0) {%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="X-UA-Compatible" content="IE=8,chrome=1"/>
<%  }%>
<% 
response.setDateHeader("Expires", -1);
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

lcsContext.initContext();
lcsContext.setLocale(request.getLocale());

wt.util.WTContext.getContext().setLocale(request.getLocale());%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%!
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String OHC_URL_CONTEXT = LCSProperties.get("windchill.onlineHelpCenter.urlContext","/Windchill-FHC/");
    public static final String defaultContentType = LCSProperties.get("com.lcs.wc.util.CharsetFilter.ContentType","text/html");
    public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final String PRODUCT_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Product.Root");
    public static final String MATERIAL_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sample.LCSSample.Material.Root");
    public static final boolean USE_SAMPLE = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useSample");
    public static final boolean USE_MATERIAL = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useMaterial");
	public static final boolean USE_RFQ = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useRFQ");
    public static final boolean USE_ORDERCONF = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.orderConfirmation");
    public static final String PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE = LCSProperties.get("com.lcs.wc.sourcing.OrderConfirmation.Product.Root", "Order Confirmation\\Product");
    public static final boolean USE_PRODUCT = LCSProperties.getBoolean("jsp.vendorportal.VendorPortalSideMenu.useProduct");    
    public static final boolean USE_CAD = LCSProperties.getBoolean("com.lcs.wc.specification.cadData.Enabled");
    public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    
    public static final String showChangeSinceDefault = LCSProperties.get("flexPLM.header.showChangeSince.default","days1");
	public static final String refreshDiscussionInboxFrequency = LCSProperties.get("flexPLM.header.refreshDiscussionInboxFrequency","900");
    public static final boolean FORUMS_ENABLED= LCSProperties.getBoolean("jsp.discussionforum.discussionforum.enabled");

%>
<%
	response.setContentType( defaultContentType+"; charset=" +defaultCharsetEncoding);
	
	String myHomeButton  = WTMessage.getLocalizedMessage ( RB.MAIN, "myHome_Btn", RB.objA ) ;
	String clipboardLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "clipboard_LBL", RB.objA ) ;
	String toggleSideBarButton = WTMessage.getLocalizedMessage (RB.MAIN, "toggleSideBar_LBL", RB.objA ) ;
	String searchLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "search_Btn", RB.objA ) ;
	String newLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "new_LBL", RB.objA ) ;
	String inboxLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "inbox_LBL",RB.objA ) ;
	
	
	String pLMNavigatorLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "pLMNavigator_LBL", RB.objA ) ;
	String myWorkButton = WTMessage.getLocalizedMessage ( RB.MAIN, "myWork_Btn", RB.objA ) ;
	String homeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "home_LBL", RB.objA ) ;
	String userPreferencesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "userPreferences_LBL", RB.objA ) ;
	String libraryLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "library_LBL", RB.objA ) ;
	String logoutLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "logOut_LBL", RB.objA ) ;
	String helpLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "flexPLMHelpCenter_LBL", RB.objA ) ;
	String aboutLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "aboutFlexPLM_LBL", RB.objA ) ;
	String goToWindchillLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "goToWindchill_LBL", RB.objA ) ;
	
	String searchFieldLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "search_Btn", RB.objA ) ;
	searchFieldLabel=FormatHelper.encodeForHTMLContent(searchFieldLabel);
	String quickLinksLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "quickLinks_LBL", RB.objA ) ;
	
	String skuLabel = WTMessage.getLocalizedMessage ( RB.CLIPBOARD, "skus_LBL", RB.objA ) ;
	
	String welcomeLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "welcome_LBL", RB.objA ) ;
	String gotoHomePagePgTle = WTMessage.getLocalizedMessage ( RB.MAIN, "gotoHomePage_PG_TLE",RB.objA ) ;
	String asteriskIllegalMessage = WTMessage.getLocalizedMessage ( RB.MAIN, "asteriskIllegal_MSG",RB.objA ) ;
	String blankIllegalMessage = WTMessage.getLocalizedMessage ( RB.MAIN, "blankIllegal_MSG",RB.objA ) ;
	
	//String productOptionLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "productOption_LBL",RB.objA ) ;
	//String materialOptionLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "materialOption_LBL",RB.objA ) ;
	//String documentOptionLbl = WTMessage.getLocalizedMessage ( RB.MAIN, "documentOption_LBL",RB.objA ) ;
	
	String allOptionLabel = WTMessage.getLocalizedMessage ( RB.INDEXSEARCH, "allOption_LBL",RB.objA ) ;
	String showChangeSinceLabel = WTMessage.getLocalizedMessage(RB.EVENTS, "showChangeSince_lbl",RB.objA);
	
	//String showChangeSinceDefault="";
	String jsCalendarFormat = WTMessage.getLocalizedMessage( RB.DATETIMEFORMAT, "jsCalendarFormat", RB.objA);
	String jsCalendarInputFormat = WTMessage.getLocalizedMessage( RB.DATETIMEFORMAT, "jsCalendarInputFormat", RB.objA);


        String activity = request.getParameter("activity");
        String flexTypeName = request.getParameter("flexTypeName");

        boolean allowExplorer = LCSProperties.getBoolean("webroot.jsp.main.Header.allowExplorer");
        boolean enableHelp = LCSProperties.getBoolean("webroot.jsp.main.Header.enableHelp");
        String wexplorer = url_factory.getHREF("wt/clients/folderexplorer/explorer.jsp");
        String firstTimestamp = request.getParameter("timestamp");
        boolean skipTemplateEnds = FormatHelper.parseBoolean(request.getParameter("bypassTemplateEnds"));

        boolean INDEX_ENABLED = false;
        WTProperties props = WTProperties.getLocalProperties();
        INDEX_ENABLED = props.getProperty ("wt.index.enabled", false);
		
	NmURLFactoryBean urlFactoryBean = new NmURLFactoryBean();
	String libOid =	new wt.fc.ReferenceFactory().getReferenceString(com.lcs.wc.util.FlexContainerHelper.getFlexContainer());
        String parameters = "components$loadWizardStep$" + libOid + "$|forum$discuss$" + libOid + "&oid=" + libOid;
	HashMap urlParam = new HashMap();
	urlParam.put("context", parameters);
	String discussionLink = FormatHelper.convertToShellURL(NetmarketURL.buildURL(urlFactoryBean, "forumTopic", "participationView_flex", null, urlParam, true, new NmAction()));

%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script>

    function viewReportsList(){
        document.MAINFORM.activity.value = 'REPORTS_LIST';
        submitForm();
    }

    function PreferencesPopupPage() {
     var windowopts = "location=no,scrollbars=no,menubars=no,toolbars=no,resizable=yes,left=8,top=8,width=350,height=500";
        popup = open('<%=URL_CONTEXT%>/jsp/main/Preferences.jsp','preferencesPopup',windowopts);
     popup.focus();

    }

    function libraryPopupPage() {
     var windowopts = "location=no,scrollbars=no,menubars=no,toolbars=no,resizable=yes,left=8,top=8,width=450,height=500";
        popup = open('<%=URL_CONTEXT%>/jsp/library/libraryMain.jsp','libraryPopup',windowopts);
     popup.focus();

    }
    
     function OHCPopupPage() {
		wcHomePage('<%=OHC_URL_CONTEXT%>');

    }

    function viewExecutiveDashboard(oid){
        document.MAINFORM.activity.value = 'EXECUTIVE_DASHBOARD_CRITERIA';
        submitForm();
    }

    function toggleSideBar(image){

        var frmwidth = -1;
        var frm = window.parent.document.getElementById('sidebarframe');
        if (frm.scrollWidth) {
            frmwidth = frm.scrollWidth;
        }
        
        if(frmwidth > 0){
            frmwidth = 0;
            image.src ='<%=WT_IMAGE_LOCATION%>/show_nav2.png';
        }
        else{
            frmwidth = 250;
            image.src ='<%=WT_IMAGE_LOCATION%>/hide_nav2.png';
        }

        var wString = frmwidth + ', *';      
        window.parent.document.getElementById('contentFrameSet').cols = wString;

    }


function viewAbout(){
    var w =window.open(urlContext + '<%= JSLangFileHelper.getFile("copyright", request.getLocale())%>');
	  w.document.charset='<%=defaultCharsetEncoding%>';
	  w.history.go(0);

}


<% if(allowExplorer) { %>
   function docOpen() {
      docwin=open("<%=wexplorer%>",
            "windchill_explorer",
            "resizable=yes,scrollbars=yes,menubar=no,toolbar=no,location=no,status=yes,height=370,width=640");
   }
<% } %>

function checkSearchSubmit(navEvent){
    var enterKey = false;
    if(window.event && window.event.keyCode == 13){
        enterKey = true;
    }
    if(navEvent && navEvent.which == 13){
        enterKey = true;
    }

    if(enterKey){
		doSearch();
		return false;
    }

}



function doSearch(){
	var optionvalue;
	optionvalue = document.MAINFORM.searchdropdown.options[document.MAINFORM.searchdropdown.selectedIndex].value;

	document.MAINFORM.quickSearchCriteria.value = trim(document.MAINFORM.quickSearchCriteria.value);
	addHiddenElement("filterId", " ");
    // REMOVE THE OLD DISPLAY ATTRIBUTE INPUT TO AVOID
    // ISSUES WHEN SEARCHES ARE DONE FOR DIFFERETN OBJECTS
    var oldDisplayAtt = $("displayAttribute");
    if(oldDisplayAtt){
        oldDisplayAtt.parentNode.removeChild(oldDisplayAtt);
    }


    var index = document.MAINFORM.elements.length;
    displayAtt = document.createElement('input');
    displayAtt.setAttribute("type", "HIDDEN");
    displayAtt.setAttribute("name", "displayAttribute");
    displayAtt.setAttribute("value", "name");
    displayAtt.setAttribute("id", "displayAttribute");

	if(optionvalue=="Keyword"){
        indexSearch();
	} else if(optionvalue=="Product"){
        displayAtt.setAttribute("value", "productName");
        document.MAINFORM.appendChild(displayAtt);
		doProductSearch();
	} else if(optionvalue=="Material"){
        document.MAINFORM.appendChild(displayAtt);
		doMaterialSearch();
	} else if(optionvalue=="Document"){
        document.MAINFORM.appendChild(displayAtt);
		doDocumentSearch();
	} else if(optionvalue=="Sku"){
        displayAtt.setAttribute("value", "skuName");
        document.MAINFORM.appendChild(displayAtt);
		doSkuSearch();
 	}  else if(optionvalue=="Color"){
        document.MAINFORM.appendChild(displayAtt);
		doColorSearch();
	}  else if(optionvalue=="Agent"){
        document.MAINFORM.appendChild(displayAtt);
		doAgentSearch();
	}  else if(optionvalue=="BusinessObject"){
        document.MAINFORM.appendChild(displayAtt);
		doBusinessObjectSearch();
	}  else if(optionvalue=="ChangeActivity"){
        document.MAINFORM.appendChild(displayAtt);
		doChangeActivitySearch();
	}  else if(optionvalue=="Country"){
        document.MAINFORM.appendChild(displayAtt);
		doCountrySearch();
	}  else if(optionvalue=="DocumentCollection"){
        document.MAINFORM.appendChild(displayAtt);
		doDocumentCollectionSearch();
	}  else if(optionvalue=="Factory"){
        document.MAINFORM.appendChild(displayAtt);
		doFactorySearch();
	}  else if(optionvalue=="Last"){
        document.MAINFORM.appendChild(displayAtt);
		doLastSearch();
	}  else if(optionvalue=="Media"){
        document.MAINFORM.appendChild(displayAtt);
		doMediaSearch();
	}  else if(optionvalue=="OrderConfirmation"){
        document.MAINFORM.appendChild(displayAtt);
		doOrderConfirmationSearch();
	}  else if(optionvalue=="OrderConfirmation/Product"){
        document.MAINFORM.appendChild(displayAtt);
		doOrderConfirmationSearch('OrderConfirmation/Product');
	}  else if(optionvalue=="Palette"){
        document.MAINFORM.appendChild(displayAtt);
		doPaletteSearch();
	}  else if(optionvalue=="RFQ"){
        document.MAINFORM.appendChild(displayAtt);
		doRFQSearch();
	}  else if(optionvalue=="Sample"){
        document.MAINFORM.appendChild(displayAtt);
		doSampleSearch();
	}  else if(optionvalue=="Sample/Material"){
        document.MAINFORM.appendChild(displayAtt);
		doSampleSearch('Sample/Material');
	}  else if(optionvalue=="Sample/Product"){
        document.MAINFORM.appendChild(displayAtt);
		doSampleSearch('Sample/Product');
	}  else if(optionvalue=="Season"){
        document.MAINFORM.appendChild(displayAtt);
		doSeasonSearch();
	}  else if(optionvalue=="Supplier"){
        document.MAINFORM.appendChild(displayAtt);
		doSupplierSearch();
	} else if(optionvalue=="Placeholder"){
        displayAtt.setAttribute("value", "placeholderName");
        document.MAINFORM.appendChild(displayAtt);
		doPlaceholderSearch();
	} 
}


function doColorSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_COLOR';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Color")) %>';
		submitForm();
	}
}function doAgentSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_AGENT';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Agent")) %>';
		submitForm();
	}
}function doBusinessObjectSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_CONTROLLED_BUSINESS_OBJECT';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Business Object")) %>';
		submitForm();
	}
}function doChangeActivitySearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_CHANGEACTIVITY';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Change Activity")) %>';
		submitForm();
	}
}function doCountrySearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_COUNTRY';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Country")) %>';
		submitForm();
	}
}function doDocumentCollectionSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_DOCUMENTCOLLECTION';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Document Collection")) %>';
		submitForm();
	}
}function doFactorySearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_FACTORY';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Factory")) %>';
		submitForm();
	}
}function doLastSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_LAST';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Last")) %>';
		submitForm();
	}
}function doMediaSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_MEDIA';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Media")) %>';
		submitForm();
	}
}function doPaletteSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_PALETTE';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Palette")) %>';
		submitForm();
	}
}function doRFQSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_RFQ';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("RFQ")) %>';
		submitForm();
	}
}function doSampleSearch(typePath){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_SAMPLE';
		document.MAINFORM.action.value = 'SEARCH';
                if(hasContent(typePath)){
                    if(typePath == 'Sample/Material'){
                        document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath(MATERIAL_ROOT_TYPE)) %>';
                    }else if(typePath == 'Sample/Product'){
                        document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath(PRODUCT_ROOT_TYPE)) %>';
                    }
                }else{
                    document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Sample")) %>';
                }
		submitForm();
	}
}function doSeasonSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_SEASON';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Season")) %>';
		submitForm();
	}
}function doSupplierSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_SUPPLIER';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Supplier")) %>';
		submitForm();
	}
}



function doSkuSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_SKU';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Product")) %>';
		submitForm();
	}
}

function doPlaceholderSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
	
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_PLACEHOLDER';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Product")) %>';
		submitForm();
	}
}
function doProductSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_PRODUCT';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Product")) %>';
		submitForm();
	}
}


function doOrderConfirmationSearch(typePath){
	var criteria = document.MAINFORM.quickSearchCriteria.value;
    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_ORDER_CONFIRMATION';
		document.MAINFORM.action.value = 'SEARCH';

               if(hasContent(typePath)){
                    if(typePath == 'OrderConfirmation/Product'){
                        document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath(PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE)) %>';
                    }
                }else{
                    document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Order Confirmation")) %>';
                }

		submitForm();
	}
}



function doMaterialSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;

    if(hasContent(criteria)){

		document.MAINFORM.activity.value = 'FIND_ADVANCED_MATERIAL';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Material")) %>';
		submitForm();
	}
}

function doDocumentSearch(){
	var criteria = document.MAINFORM.quickSearchCriteria.value;

    if(hasContent(criteria)){
		document.MAINFORM.activity.value = 'FIND_DOCUMENT';
		document.MAINFORM.action.value = 'SEARCH';
		document.MAINFORM.type.value = '<%= FormatHelper.getObjectId(FlexTypeCache.getFlexTypeFromPath("Document")) %>';
		submitForm();
	}
}

function indexSearch(){
    if (validate_keyword()) {
        document.MAINFORM.activity.value = 'INDEX_SEARCH';
        document.MAINFORM.action.value = 'SEARCH';
        document.MAINFORM.globalSearch.value = 'true';
        document.MAINFORM.headerIndexSearchKeyword.value = document.MAINFORM.quickSearchCriteria.value;
        document.MAINFORM.quickSearchCriteria.value = '';
        submitForm();
    }
}

function validate_keyword() {
    if (trim(document.MAINFORM.quickSearchCriteria.value) == "*") {
        alert('<%=FormatHelper.formatJavascriptString(asteriskIllegalMessage, false)%>');
        return false;
    } else if (trim(document.MAINFORM.quickSearchCriteria.value) == "") {
        alert('<%=FormatHelper.formatJavascriptString(blankIllegalMessage, false)%>');
        return false;
    }
    return true;
}

function handleChangeSearchDropDown(){
    var dropDown = $('searchDropDownSelect');

    var searchButton = $('searchButton');
    var newIcon = $('newObjectIcon');

    var value = dropDown.options[dropDown.selectedIndex].value;
    if(value == 'Sku' || value == 'Sample' || value == 'Sample/Material' || value == 'Sample/Product'|| value == 'Placeholder'){
        newIcon.style.display = 'none';
        // Add space to the right of search   margin-right:25px;
        searchButton.style.marginRight = "33px";
        
    } else {
        newIcon.style.display = 'block';
        // Reset space on right of search to  margin-right:5px;
        searchButton.style.marginRight = "5px";
        
    }
    document.MAINFORM.quickSearchCriteria.focus();
    document.MAINFORM.quickSearchCriteria.select();
}

</script>

<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");

    public static final String STANDARD_TEMPLATE_HEADER = PageManager.getPageURL("STANDARD_TEMPLATE_HEADER", null);
    public static final String STANDARD_TEMPLATE_FOOTER = PageManager.getPageURL("STANDARD_TEMPLATE_FOOTER", null);

    public static final String adminGroup = LCSProperties.get("jsp.main.administratorsGroup", "Administrators");
    public static final String typeAdminGroup = LCSProperties.get("jsp.flextype.adminGroup", "Type Administrators");
    public static final String userAdminGroup = LCSProperties.get("jsp.users.adminGroup","User Administrators");
    public static final String calendarAdminGroup = LCSProperties.get("jsp.calendar.adminGroup","Calendar Administrators");
    public static final String processAdminGroup = LCSProperties.get("jsp.process.adminGroup","Process Administrators");

    public static final String COMPANY_IMAGE = PageManager.getPageURL("COMPANY_IMAGE", null);
    public static final String NEW_SELECT = PageManager.getPageURL("NEW_SELECT", null);
    public static final String FIND_SELECT = PageManager.getPageURL("FIND_SELECT", null);
    public static final boolean USE_CHANGE_ACTIVITY = LCSProperties.getBoolean("com.lcs.wc.change.useChangeActivity");

    public static String WindchillContext = "/Windchill";

    static{
        try{
            WTProperties wtproperties = WTProperties.getLocalProperties();
            WindchillContext = "/" + wtproperties.getProperty("wt.webapp.name");
        }
        catch(Throwable throwable){
            throw new ExceptionInInitializerError(throwable);
        }
    }
%>

<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////// BEGIN HTML ///////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<html>
<Head>
<link href="header.css" rel="stylesheet" type="text/css">
</Head>
<body>

<input name="<%= FlexTypeCache.getFlexTypeFromPath("Product").getAttribute("productName").getSearchCriteriaIndex() %>" value="" type="hidden">
<input name="<%= FlexTypeCache.getFlexTypeFromPath("Material").getAttribute("name").getSearchCriteriaIndex() %>" value="" type="hidden">

<% if(!skipTemplateEnds){ %>
<jsp:include page="<%=subURLFolder+ STANDARD_TEMPLATE_HEADER %>" flush="true" />
<% } %>
<input type=hidden name=skipRanges value="">
<input name="headerIndexSearchKeyword" value="" type="hidden">
<input type="hidden" name="globalSearch" value="">

<div class="pageheader" id="container" >

		  
		  <div id="leftWelcomeSection"  >
			<div id="image" >
          		<a href="javascript:home()" tabindex="0"><img id="logo" title='<%= FormatHelper.formatHTMLString(gotoHomePagePgTle)%>' border="0" src="<%=URL_CONTEXT%><%=COMPANY_IMAGE%>"></a>
			</div>
			
			<div id="welcome" >
			  <img id="sidebarButton" tabindex="1" onClick="toggleSideBar(this)" title='<%= FormatHelper.formatHTMLString(toggleSideBarButton) %>' src="<%=WT_IMAGE_LOCATION%>/hide_nav2.png">
	            
	          <img id="homeButton" tabindex="2" onClick="home()" title='<%= FormatHelper.formatHTMLString(myHomeButton) %>' src="<%=WT_IMAGE_LOCATION%>/home.png">
	        
            </div>    
            
			   	<%if(FORUMS_ENABLED){%>
				 <div id="discussionForumImg">
	                <img id="discussionForumButton" tabindex="3" onClick="javascript:createDialogWindow('<%=discussionLink%>','Inbox', '700', '700')" title='<%= FormatHelper.formatHTMLString(inboxLabel) %>' src="<%=WT_IMAGE_LOCATION%>/topic.gif">
                 </div>
				 <div id="discussionCountDiv">
				     <font id="discussionCountLabel"></font>
                 </div>
				<%}%>
			<div id="userLabelDiv">
	          	<font id="userNameLabel" >&nbsp;Welcome&nbsp;<%= lcsContext.getUser().getFullName() %></font>
            </div>
		   </div>
		   
                  <% 
                  /** Creating change Widget */
                  FlexType changeTrackSinceType =  FlexTypeCache.getFlexTypeFromPath("Business Object\\Common Attribute Lists"); 
	          		AttributeValueList CTSValList=null;
	          		Vector order = new Vector();
	          		try{
	              		if(changeTrackSinceType.getAttribute("changeTrackingSince")!=null){
	              			//showChangeSinceDefault = changeTrackSinceType.getAttribute("changeTrackingSince").getAttDefaultValue();
	              			CTSValList = changeTrackSinceType.getAttribute("changeTrackingSince").getAttValueList();
	                          order.addAll(CTSValList.getSelectableKeys(lcsContext.getLocale(), true));
	              		}
	          		}catch(FlexTypeException fte){
	          			System.out.println(fte.getLocalizedMessage());
	          		}
	          		
	          		
	          		HashMap<String, String> daysMap = new HashMap<String, String>();
	          		Map daysDisplayMap = new HashMap();
	          		String defaultDaysValue="";
	          		if(null!=CTSValList){
	          			defaultDaysValue=CTSValList.get(showChangeSinceDefault, "days");
	              		String localeString = lcsContext.getLocale().toString().toUpperCase();
	              		daysDisplayMap = CTSValList.toLocalizedMapSelectable(lcsContext.getLocale());
	              		
	              		Collection<String> keys = daysDisplayMap.keySet();
	              		Iterator<String> keysIt = keys.iterator();
	              		while(keysIt.hasNext()){
	              			String key = keysIt.next();
	              			String daysValue=CTSValList.get(key, "days");
	              			daysMap.put(key, daysValue);
	              		}
	          		}

                  %>
                 
	          	 

					  <% if(enableHelp) { %>
	
	                   <jsp:include page='<%=subURLFolder  + "/jsp/help/HelpLinkPlugin.jsp"%>' flush="true">
	                        <jsp:param name="activity" value='<%= request.getParameter("activity") %>'/>
	                        <jsp:param name="objType" value='<%= request.getParameter("flexTypeName") %>'/>
	                        <jsp:param name="windowTitle" value='Create Product'/>
	                   </jsp:include>
	                   <%}%>
				   
			   <div id="showSearchSection">
                   
                	
	                                   
	                    <div id="quickLinkDiv" >                         

                        <% 
                				/* Create the Menu for the Quick Links. JS function gotoQuickLink will fire on Change.*/
                				Map<String, String> quickLinkMenuMap = new LinkedHashMap<String, String>();
                			
                        		quickLinkMenuMap.put("quicklinks", quickLinksLabel);
                        		quickLinkMenuMap.put("showClipboard", clipboardLabel);
                        		quickLinkMenuMap.put("showPreferences", userPreferencesLabel);
                        		quickLinkMenuMap.put("logout", logoutLabel);
                				
                	            if(lcsContext.inGroup(adminGroup.toUpperCase()) || lcsContext.inGroup("DEVELOPERS"))
                	            { 
                	            	quickLinkMenuMap.put("showLibrary", libraryLabel);
                	            }
                	            
                	            quickLinkMenuMap.put("showHelp", helpLabel);
                	            
                	            /* If the CAD view is enabled, add */
                	            if(USE_CAD)
                	            { 
                	            	quickLinkMenuMap.put("showGoToWindchill", goToWindchillLabel);
                	            }
                     			
                	            quickLinkMenuMap.put("showAbout", aboutLabel);
                				  
                				%>
        				
        				<%=fg.createMenuDropDownList(quickLinkMenuMap, "quickLinkSelectionId", quickLinksLabel, "gotoQuickLink()", 1, "") %>
        
        				</div>
           				<div id="searchDropDown" >
        				<img id='newObjectIcon' title='<%= FormatHelper.formatHTMLString(newLabel) %>' onClick='createObject(document.MAINFORM.searchdropdown.options[document.MAINFORM.searchdropdown.selectedIndex].value)' src="<%=WT_IMAGE_LOCATION%>/object_new.png">
        				
        				<img id='searchButton' title='<%= FormatHelper.formatHTMLString(searchLabel) %>' onClick="doSearch()" src="<%=WT_IMAGE_LOCATION%>/find_flex.png">
        				
        				<input id='searchField' type="text" name="quickSearchCriteria" onKeyPress="return checkSearchSubmit(event)"  placeholder="<%= searchFieldLabel %>...">
                				
                		<select id="searchDropDownSelect" name="searchdropdown" onChange="handleChangeSearchDropDown()">
	
                                        <%                               
                                        FlexType agent = FlexTypeCache.getFlexTypeRoot("Agent");
                                        FlexType businessObject = FlexTypeCache.getFlexTypeRoot("Business Object");
                                        FlexType changeActivity = FlexTypeCache.getFlexTypeRoot("Change Activity");
                                        FlexType country = FlexTypeCache.getFlexTypeRoot("Country");
                                        FlexType color = FlexTypeCache.getFlexTypeRoot("Color");
                                        FlexType document = FlexTypeCache.getFlexTypeRoot("Document");
                                        FlexType documentCollection = FlexTypeCache.getFlexTypeRoot("Document Collection");
                                        FlexType factory = FlexTypeCache.getFlexTypeRoot("Factory");
                                        FlexType last = FlexTypeCache.getFlexTypeRoot("Last");
                                        FlexType material = FlexTypeCache.getFlexTypeRoot("Material");
                                        FlexType media = FlexTypeCache.getFlexTypeRoot("Media");
                                        FlexType orderConfirmation = FlexTypeCache.getFlexTypeRoot("Order Confirmation");
                                        FlexType orderConfirmationProdType = FlexTypeCache.getFlexTypeFromPath(PRODUCT_ORDER_CONFIRMATION_ROOT_TYPE);
                                        FlexType palette = FlexTypeCache.getFlexTypeRoot("Palette");
                                        FlexType product = FlexTypeCache.getFlexTypeRoot("Product");
                                        FlexType rfq = FlexTypeCache.getFlexTypeRoot("RFQ");
                                        FlexType sample = FlexTypeCache.getFlexTypeRoot("Sample");
                                        FlexType season = FlexTypeCache.getFlexTypeRoot("Season");
                                        FlexType supplier = FlexTypeCache.getFlexTypeRoot("Supplier");
                                        FlexType prodSampleType = FlexTypeCache.getFlexTypeFromPath(PRODUCT_ROOT_TYPE);
                                        FlexType matSampleType = FlexTypeCache.getFlexTypeFromPath(MATERIAL_ROOT_TYPE);

                                        boolean hasSupplierLinks = false;

                                        if(lcsContext.isVendor){

                                            for(Iterator vendorObjsItr = lcsContext.getVendorObjects().iterator();vendorObjsItr.hasNext(); ){
                                                    if(hasSupplierLinks){
                                                            break;
                                                    }else if(vendorObjsItr.next().toString().indexOf("LCSSupplier:") > -1){
                                                            hasSupplierLinks = true;
                                                    }
                                            }
                                        }
                                        
                                        
                                        
                                        if(!lcsContext.isVendor){%>
                                            <%if(INDEX_ENABLED){%><option value="Keyword"><%=allOptionLabel%></option><%}%>
                                            <!--<%if(ACLHelper.hasViewAccess(agent)){%><option value="Agent"><%= FormatHelper.formatHTMLString(agent.getTypeDisplayName()) %></option><%}%>-->
                                            <%if(ACLHelper.hasViewAccess(businessObject)){%><option value="BusinessObject"><%= FormatHelper.formatHTMLString(businessObject.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(changeActivity)){%><option value="ChangeActivity"><%= FormatHelper.formatHTMLString(changeActivity.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(product)){%><option value="Sku"><%= FormatHelper.formatHTMLString(skuLabel) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(country)){%><option value="Country"><%= FormatHelper.formatHTMLString(country.getTypeDisplayName()) %></option><%}%>
                                        <%}%>

                                        <%if(ACLHelper.hasViewAccess(color)){%><option value="Color"><%= FormatHelper.formatHTMLString(color.getTypeDisplayName()) %></option><%}%>
										<!--//PLM -172 : Added condition to remove access to Vendor portal users -->	
                                        <%if(!lcsContext.isVendor){%>
											<%if(ACLHelper.hasViewAccess(document)){%><option value="Document"><%= FormatHelper.formatHTMLString(document.getTypeDisplayName()) %></option><%}%>
										<%}%>

                                        <%if(!lcsContext.isVendor){%>
                                            <%if(ACLHelper.hasViewAccess(documentCollection)){%><option value="DocumentCollection"><%= FormatHelper.formatHTMLString(documentCollection.getTypeDisplayName()) %></option><%}%>
                                            <!--<%if(ACLHelper.hasViewAccess(factory)){%><option value="Factory"><%= FormatHelper.formatHTMLString(factory.getTypeDisplayName()) %></option><%}%>-->
                                            <%if(ACLHelper.hasViewAccess(last)){%><option value="Last"><%= FormatHelper.formatHTMLString(last.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(material)){%><option value="Material"><%= FormatHelper.formatHTMLString(material.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(media)){%><option value="Media"><%= FormatHelper.formatHTMLString(media.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(palette)){%><option value="OrderConfirmation"><%= FormatHelper.formatHTMLString(orderConfirmation.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(palette)){%><option value="Palette"><%= FormatHelper.formatHTMLString(palette.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(product)){%> <option value="Placeholder"><%= LCSMessage.getHTMLMessage(RB.PLACEHOLDER, "placeholder_LBL", RB.objA) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(product)){%> <option selected value="Product"><%= FormatHelper.formatHTMLString(product.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(rfq)){%> <option value="RFQ"><%= LCSMessage.getHTMLMessage(RB.RFQ, "rfq_LBL", RB.objA) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(sample)){%><option value="Sample"><%= FormatHelper.formatHTMLString(sample.getTypeDisplayName()) %></option><%}%>
                                           <%if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Material"))){%>
                                                <%if(ACLHelper.hasViewAccess(matSampleType)){%><option value="Sample/Material"><%= FormatHelper.formatHTMLString(matSampleType.getFullNameDisplay(true)) %></option><%}%>
                                            <%}%>
                                           <%if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product"))){%>
                                                <%if(ACLHelper.hasViewAccess(prodSampleType)){%><option value="Sample/Product"><%= FormatHelper.formatHTMLString(prodSampleType.getFullNameDisplay(true)) %></option><%}%>
                                            <%}%>
                                        <%}else{%>

                                           <%if(USE_MATERIAL &&  ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Material")) && hasSupplierLinks) {%>
                                                <%if(ACLHelper.hasViewAccess(material)){%><option value="Material"><%= FormatHelper.formatHTMLString(material.getTypeDisplayName())%></option><%}%>
                                           <%}%>

                                           <%if(USE_ORDERCONF &&  ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Order Confirmation")) && hasSupplierLinks) {%>
                                                <%if(ACLHelper.hasViewAccess(palette)){%><option value="OrderConfirmation/Product"><%= FormatHelper.formatHTMLString(orderConfirmationProdType.getFullNameDisplay(true)) %></option><%}%>
                                           <%}%>

                                           <%if(USE_PRODUCT &&  ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product"))  && hasSupplierLinks) {%>
                                                <%if(ACLHelper.hasViewAccess(product)){%> <option selected value="Product"><%= FormatHelper.formatHTMLString(product.getTypeDisplayName()) %></option><%}%>
                                           <%}%>

                                          <%if(USE_RFQ && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("RFQ")) && hasSupplierLinks) {%>
                                                <%if(ACLHelper.hasViewAccess(rfq)){%> <option value="RFQ"><%= LCSMessage.getHTMLMessage(RB.RFQ, "rfq_LBL", RB.objA) %></option><%}%>
                                           <%}%>

                                           <%if(USE_SAMPLE && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Material"))){%>
                                                <%if(ACLHelper.hasViewAccess(matSampleType)){%><option value="Sample/Material"><%= FormatHelper.formatHTMLString(matSampleType.getFullNameDisplay(true)) %></option><%}%>
                                            <%}%>

                                           <%if(USE_SAMPLE && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Sample")) && ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Product"))){%>
                                                <%if(ACLHelper.hasViewAccess(prodSampleType)){%><option value="Sample/Product"><%= FormatHelper.formatHTMLString(prodSampleType.getFullNameDisplay(true)) %></option><%}%>
                                            <%}%>
                                         <%}%>

                                       <%if(!lcsContext.isVendor){%>
                                            <%if(ACLHelper.hasViewAccess(season)){%><option value="Season"><%= FormatHelper.formatHTMLString(season.getTypeDisplayName()) %></option><%}%>
                                            <%if(ACLHelper.hasViewAccess(supplier)){%><option value="Supplier"><%= FormatHelper.formatHTMLString(supplier.getTypeDisplayName()) %></option><%}%>
                                        <%}%>
                         </select>
                				
                          <div id="sinceChangesWidget" style="">                                

			          	  <%	
		                  if(!daysDisplayMap.isEmpty()){ %>

									<div id="divDropDown" style="float:right;width=120px;margin-right:0px">
									
		                  			<%= fg.createDropDownList(daysDisplayMap, "daysValueId", showChangeSinceDefault, "setShowChangeSince()", 1, false, "",order,null,false,"setOnMouseDown()", "setOnMouseOut()")  %>
		                  		
		                  			</div>
			                  		<div id="divLabel" align="right" >		                  		
			                  		<div id="showChangeLabel"><%= showChangeSinceLabel %></div>			                  		
			                  		<div id="showChangeSinceDiv"></div>
			                  		</div>
		                  </div>
  				 
  				  <%} %>
                                
       				 </div>
  </div>
                
                    
</div>

<% if(!skipTemplateEnds){ %>
<jsp:include page="<%=subURLFolder+ STANDARD_TEMPLATE_FOOTER %>" flush="true" />
<% } %>

<script language="Javascript">

var daysValueMap = <%= JSONHelper.toJSONMap(daysMap) %>;

var daysDD = $("daysValueId");
var preIndex = daysDD.selectedIndex;
if(daysDD){
	var defaultVal = '<%=defaultDaysValue%>';
	if(hasContent(defaultVal)){
		setShowChangeSince(defaultVal);
		for(var i=0;i<daysDD.options.length;i++){
	        if(daysDD.options[i].value==defaultVal){
	        	daysDD.options[i].selected='selected';
	        	break;
	        }
	    }
	}
}

function  setOnMouseDown() {
	if (document.MAINFORM.daysValueId.selectedIndex != -1) {
	   preIndex = document.MAINFORM.daysValueId.selectedIndex;
	}
	daysDD.selectedIndex = -1;
}

var isChrome = navigator.userAgent.indexOf("Chrome") > -1;
var isSafari = navigator.userAgent.indexOf("Safari") > -1;
function setOnMouseOut() {
    if (!isChrome && !isSafari || preIndex == -1 || daysDD.options[preIndex].value != 'selectDate') {
        daysDD.selectedIndex = preIndex;
    }
}

if (daysDD.addEventListener) { // all browsers except IE before version 9
    daysDD.addEventListener('blur', resetShowChangesSinceSelection, false);
} else if (daysDD.attachEvent) { // IE before version 9
    daysDD.attachEvent('onblur', resetShowChangesSinceSelection);
}

function resetShowChangesSinceSelection() {
    if (daysDD.selectedIndex == -1) {
        daysDD.selectedIndex = preIndex;
    }
}

function setShowChangeSince(defaultVal){
	var daysVal;
	if(hasContent(defaultVal)){
		daysVal = defaultVal;
	}else{
		daysVal = daysValueMap[document.MAINFORM.daysValueId.value];
	}
	if (document.MAINFORM.daysValueId.selectedIndex == -1) {
		document.MAINFORM.daysValueId.selectedIndex = preIndex;
	}
	if(daysVal=='SelectDate'){
		CalendarPopup();
	}else if(isNumber(daysVal)){
		var sinceDate = new Date();
		sinceDate.setDate(sinceDate.getDate()-parseInt(daysVal));
		sinceDate.setHours(0);
		sinceDate.setMinutes(1);

		$("showChangeSinceDiv").innerHTML = formatDateString(sinceDate, "<%= WTMessage.getLocalizedMessage ( RB.DATETIMEFORMAT, "jsCalendarFormat", RB.objA ) %>") ;
		changeSelectedDateHiddenValue(sinceDate);
	}
	
	preIndex = document.MAINFORM.daysValueId.selectedIndex;

}

function changeSelectedDateHiddenValue(dateVal){
		curDateStr = dateVal.print('<%=jsCalendarFormat%>');
		var globalHidden = window.parent.frames['contentframe'].document.getElementById('globalChangeTrackingSinceDate');
		 if(globalHidden) {
				globalHidden.value=curDateStr;
		 }
		 var sideBarHidden = window.parent.frames['sidebarframe'].document.getElementById('globalChangeTrackingSinceDate');
		 if(sideBarHidden) {
				sideBarHidden.value=curDateStr;
		 }
		 
}

function setSelectedDateCallback(dateString){
		var sinceDate = chkDateString(dateString,
				   '<%= FormatHelper.formatJavascriptString(jsCalendarInputFormat, false) %>',
				   '<%= jsCalendarFormat %>',
				   true);
		sinceDate.setHours(0);
		sinceDate.setMinutes(1);
		
		$("showChangeSinceDiv").innerHTML = formatDateString(sinceDate, "<%= WTMessage.getLocalizedMessage ( RB.DATETIMEFORMAT, "jsCalendarFormat", RB.objA ) %>") ;
		changeSelectedDateHiddenValue(sinceDate);
}

function CalendarPopup(){
	var additionalParams='?activity=POPUP_CALENDAR&action=INIT';
	window.open(urlContext + '/jsp/main/Main.jsp' + additionalParams ,'chooser','dependent=yes,width=290,height=200,top=100,left=100,titlebar=yes,resizable=no');
}


var curDateStr;
function getGlobalChangeTrackingSinceDate() {
	return curDateStr;
}

var ajaxUpdater;
var refreshFreq = <%=refreshDiscussionInboxFrequency%>;

function showDiscussionSubscription() {
	ajaxUpdater = new Ajax.PeriodicalUpdater({success: "discussionCountLabel", failure: "discussionCountLabel"},  urlContext + '/jsp/main/Main.jsp', {
		parameters : "activity=QUERY_DISCUSSION_INBOX&templateType=AJAX&isSystemFunctionCall=true", 
		method: 'post', frequency:refreshFreq, decay: 0});
}

/** 
 * 
 *Function to process events from the QuickLink menu
 * 
 */
function gotoQuickLink()
{
	    var selectedIndex  = $('quickLinkSelectionId').selectedIndex;
	    var selectValue = $('quickLinkSelectionId').options[selectedIndex].value;
	    switch (selectValue)
	    {
		    case "showGoToWindchill":
	            
	    		window.top.location.href = "<%=WindchillContext%>/app/#ptc1/homepage";					    		
	    		$('quickLinkSelectionId').selectedIndex = 0;
	    		break;
	    	    
	    
		    case "showHelp":
	            
	    		OHCPopupPage();					    		
	    		$('quickLinkSelectionId').selectedIndex = 0;
	    		break;
	    		
	    	case "showAbout":

	    		viewAbout();
	    		$('quickLinkSelectionId').selectedIndex = 0;
	    		break;
	    	
		    case "showClipboard":
		    	
	    		viewClipboard();
	    		$('quickLinkSelectionId').selectedIndex = 0;
	    		break;
	
		    case "showPreferences":
		    	
		    	PreferencesPopupPage();
		    	$('quickLinkSelectionId').selectedIndex = 0;
	    		break;                				
	    		
		    case "logout":
		    	
	    		logOut();
	    		
    			break;
	    
   			<% if(lcsContext.inGroup(adminGroup.toUpperCase()) || lcsContext.inGroup("DEVELOPERS")){
   				%>
   				case "showLibrary": 
   					libraryPopupPage();
   					$('quickLinkSelectionId').selectedIndex = 0;
   					break;
	            	<%
	            }%>		
    			
	    	default:
	    		$('quickLinkSelectionId').selectedIndex = 0;
	    		// do nothing
	    }
	    
	    
	    return true;
}




// Catch the onresize event to show/hide content 
window.onresize = function() {
    
    showHideWidgetsWithWidth();
 };

 
 // Hide parts of the header whenever the user collapses the windows width to avoid widgets disorderly collapsing. 
function showHideWidgetsWithWidth()
{
	
	if (getWidth() < 900)
	{
		$('sinceChangesWidget').style.display="none";
		$('searchDropDown').style.display="none";
		
				
		$('leftWelcomeSection').style.width = "64.5%";
		$('showSearchSection').style.width = "35%";
	}	
	 
	if (getWidth() >= 900)
	{
		$('sinceChangesWidget').style.display="block";
		$('searchDropDown').style.display="block";
		
		
		$('leftWelcomeSection').style.width = "29.5%";
		$('showSearchSection').style.width = "70%";
	}

}
 

  // Get the screen width and height. Any browser. 
  function getWidth()
  {
    xWidth = null;
    if(window.screen != null)
      xWidth = window.screen.availWidth;
 
    if(window.innerWidth != null)
      xWidth = window.innerWidth;
 
    if(document.body != null)
      xWidth = document.body.clientWidth;
 
    return xWidth;
  }

  function getHeight() {
	  xHeight = null;
	  if(window.screen != null)
	    xHeight = window.screen.availHeight;
	 
	  if(window.innerHeight != null)
	    xHeight =   window.innerHeight;
	 
	  if(document.body != null)
	    xHeight = document.body.clientHeight;
	 
	  return xHeight;
	}
 
  
   // Show discussion if enabled
   <%if(FORUMS_ENABLED){%>
	showDiscussionSubscription();
	<%}%>

  
  // Do once the document is ready. (initialization)
  document.observe("dom:loaded", function() {
	  // initially hide all containers for tab content
	  showHideWidgetsWithWidth();
	  
	  $('daysValueId').tabIndex="5";
	  
	  $('searchDropDownSelect').tabIndex="6";
	  
	  $('searchField').tabIndex="7";
	  $('searchButton').tabIndex="8";
	  $('newObjectIcon').tabIndex="9";
	  
	  $('quickLinkSelectionId').tabIndex="10";
	});
  
</script>

</body>

</html>