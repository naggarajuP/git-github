<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>

<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// PAGE DOCUMENTATION/////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%--
      JSP Type: Presentation

--%>

<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ///////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%@ page language="java"
    errorPage="../exception/ErrorReport.jsp"
   import=" com.lcs.wc.util.*,
            com.lcs.wc.client.Activities,
            com.lcs.wc.client.web.*,
            com.lcs.wc.flextype.*,
            com.lcs.wc.season.*,
            java.io.*,
            java.util.*,
            wt.util.*,
            wt.util.WTProperties,
            wt.util.WTContext"
%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS //////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<jsp:useBean id="seasonModel" scope="request" class="com.lcs.wc.season.LCSSeasonClientModel" />
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////////////////////////////////////////////////////////////--%>
<%
//setting up which RBs to use
Object[] objA = new Object[0];
String Context_MAIN = "com.lcs.wc.resource.ContextBarsRB";

String conceptsLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "concepts_LBL", objA ) ;
String detailsLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "details_LBL", objA ) ;
String paletteLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "palette_LBL", objA ) ;
String silhouettesLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "silhouettes_LBL", objA ) ;
String calendarLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "calendar_LBL", objA ) ;
String inspirationsLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "inspirations_LBL", objA ) ;
String developmentLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "development_LBL", objA ) ;
String lineSheetLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "lineSheet_LBL", objA ) ;
String dashboardsLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "dashboards_LBL", objA ) ;
String changeReportLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "changeReport_LBL", objA ) ;
String seasonGroupConfigurationLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "seasonGroupConfiguration_LBL", objA ) ;
String presentationBoardLabel = WTMessage.getLocalizedMessage ( Context_MAIN, "presentationBoard_LBL", objA ) ;
String planningLabel = WTMessage.getLocalizedMessage ( RB.PLAN, "planning_LBL", objA ) ;

%>
<%!
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
	public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final boolean USE_SILHOUETTES = LCSProperties.getBoolean("com.lcs.wc.season.useSilhouettes");
    public static final boolean USE_INSPIRATIONS = LCSProperties.getBoolean("com.lcs.wc.season.useInspirations");

    public static final StringBuffer createSubTab(String name, String link, boolean active){
        StringBuffer buffer = new StringBuffer();

        buffer.append("<TD class=tabsel noWrap>&nbsp;</TD>");
        if(active) {
            buffer.append("<td nowrap class=\"tabsel\">");
            //buffer.append("<IMG height=2 src=\"/LCSW/images/sp.gif\">");
            buffer.append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" background=\"" + URL_CONTEXT + "/images/sp.gif\" class=\"tab\">");
            buffer.append("<TBODY><TR><TD class=subtabCnr><IMG height=1 src=\"" + URL_CONTEXT + "/images/sp.gif\"></TD><TD class=subtabBdr height=1></TD><TD class=subtabCnr height=1></TD></TR>");
            buffer.append("<TR><TD class=subtabBdr></TD><TD class=subtabBgd noWrap>");
            buffer.append("<A class=subtabTxtsel href=\""+link+"\">"+name+"</A>");
            buffer.append("</TD><TD class=subtabBdr><IMG src=\"" + URL_CONTEXT + "/images/sp.gif\"></TD></TR>");
            buffer.append("<TR><TD class=subtabCnr></TD><TD class=subtabBdr height=1></TD><TD class=subtabCnr height=1></TD></TR>");
            buffer.append("</TBODY></TABLE></td>");
        } else {
             buffer.append("<TD class=tabsel noWrap>&nbsp;</TD><TD class=tabsel noWrap>&nbsp;</TD><TD class=subtabTxtNsel noWrap>");
             buffer.append("<A class=subtabTxtNsel href=\""+link+"\">"+name+"</A></TD>");
        }
        buffer.append("<TD class=tabsel noWrap>&nbsp;</TD>");

        return buffer;
    }


%>
<%

    LCSSeason season = seasonModel.getBusinessObject();
    String activity = request.getParameter("activity");

%>
<% if(season != null){
    String seasonId = FormatHelper.getVersionId(season);
%>
<script>
    function viewLinePlanTab(){
        document.MAINFORM.activity.value = 'VIEW_LINE_PLAN';
        document.MAINFORM.oid.value = '<%= seasonId %>';
        document.MAINFORM.action.value = 'RELOAD';
        document.MAINFORM.returnActivity.value = '';
        document.MAINFORM.tabId.value = '';
        submitForm();
    }

    function viewMaterialCommitmentReport(){
        document.MAINFORM.activity.value = 'VIEW_MATERIAL_COMMITMENT_REPORT';
        document.MAINFORM.oid.value = '<%= seasonId %>';
        submitForm();
    }

    function viewSeasonChangeReport(){
        document.MAINFORM.activity.value = 'VIEW_SEASON_CHANGE_REPORT';
        document.MAINFORM.oid.value = '<%= seasonId %>';
        submitForm();
    }

    function viewSeasonPlanning(){
        document.MAINFORM.activity.value = 'VIEW_SEASON_PLANNING';
        document.MAINFORM.oid.value = '<%= seasonId %>';
        submitForm();
    }

<%if(!lcsContext.isVendor){%>

if(window.parent && window.parent.sidebarframe){
	window.parent.sidebarframe.changeSelectedSeason('<%= seasonId%>');
}
<%}%>


</script>
<tr>
    <td class="contextBar" id="contextBar">
        <table width="100%" cellspacing="0" cellpadding="0">
            <td class="contextBarText" align="left">
                <a class="contextBarText" href="javascript:viewSeason('<%= seasonId %>')"><img src="<%=WT_IMAGE_LOCATION%>/season_m.png" alt="" border="0" align="absmiddle">&nbsp;&nbsp;<%= season.getValue("seasonName") %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;

            <% if(  "VIEW_SEASON".equals(activity)  ||
                    "VIEW_SEASON_PALETTE".equals(activity)  ||
                    "VIEW_PALETTE".equals(activity)  ||
                    "VIEW_SEASON_SILHOUETTE".equals(activity)  ||
                    "VIEW_SEASON_INSPIRATION".equals(activity)
                    ){
            %>
                <a class="contextBarText" href="#"><%= conceptsLabel %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% if("VIEW_SEASON".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= detailsLabel %></a>
                <% } else if("VIEW_SEASON_PALETTE".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= paletteLabel %></a>
                <% } else if("VIEW_PALETTE".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= paletteLabel %></a>
                <% } else if("VIEW_SEASON_SILHOUETTE".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= silhouettesLabel %></a>
                <% } else if("VIEW_SEASON_INSPIRATION".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= inspirationsLabel %></a>

                <% } %>
            <% } else if(   "VIEW_LINE_PLAN".equals(activity) ||
                            "VIEW_SEASON_CALENDAR".equals(activity)  ||
                            "VIEW_SEASON_DASHBOARDS".equals(activity) ||
                            "VIEW_LINE_PRESENTATION_BOARD".equals(activity)  ||
                   			"VIEW_SEASON_PLANNING".equals(activity)  ||
                            "VIEW_SEASON_CHANGE_REPORT".equals(activity) ||
                            "CALENDAR_DASHBOARD_REPORT".equals(activity)
                        ){ %>

                <a class="contextBarText" href="#"><%= developmentLabel %></a>
                &nbsp;<span class="breadcrumbdivider">></span>&nbsp;
                <% if("VIEW_LINE_PLAN".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= lineSheetLabel %></a>
                <% } else if("VIEW_LINE_PRESENTATION_BOARD".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= presentationBoardLabel %></a>
                <% } else if("VIEW_SEASON_DASHBOARDS".equals(activity) || "CALENDAR_DASHBOARD_REPORT".equals(activity) && (!(lcsContext.isVendor))){ %>
                <a class="contextBarText" href="#"><%= dashboardsLabel %></a>
                <% } else if("VIEW_SEASON_CHANGE_REPORT".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= changeReportLabel %></a>
                <% } else if("VIEW_SEASON_CALENDAR".equals(activity)&& (!(lcsContext.isVendor))){ %>
                <a class="contextBarText" href="#"><%= calendarLabel %></a>
                <% } else if("VIEW_SEASON_PLANNING".equals(activity)){ %>
                <a class="contextBarText" href="#"><%= planningLabel %></a>



                <% } %>

            <% } else if("SELECT_SEASON_GROUPS".equals(activity)){ %>
                <%= seasonGroupConfigurationLabel %>



            <% } %>
            <td>
        </table>
    </td>
</tr>
<tr>
    <td class="CONTEXTTABS">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
            <% if(  "VIEW_SEASON".equals(activity)  ||
                    "VIEW_SEASON_PALETTE".equals(activity)  ||
                    "VIEW_PALETTE".equals(activity)  ||
                    "VIEW_SEASON_SILHOUETTE".equals(activity)  ||
                    "VIEW_SEASON_INSPIRATION".equals(activity)
                    ){
            %>
                    <%= createSubTab(detailsLabel,"javascript:viewSeason('" + seasonId +"')","VIEW_SEASON".equals(activity)) %>
                    <% if(USE_INSPIRATIONS){ %>
                        <%= createSubTab(inspirationsLabel,"javascript:viewSeasonInspiration('" + seasonId +"')","VIEW_SEASON_INSPIRATION".equals(activity)) %>
                    <% } %>

                    <%if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Palette"))){%>
                        <%= createSubTab(paletteLabel,"javascript:viewSeasonPalette('" + seasonId +"')","VIEW_SEASON_PALETTE".equals(activity)||"VIEW_PALETTE".equals(activity)) %>
                    <% } %>

                    <% if(USE_SILHOUETTES){ %>
                        <%= createSubTab(silhouettesLabel,"javascript:viewSeasonSilhouette('" + seasonId +"')","VIEW_SEASON_SILHOUETTE".equals(activity)) %>
                    <% } %>

            <% } else if(   "VIEW_LINE_PLAN".equals(activity) ||
                            "VIEW_SEASON_DASHBOARDS".equals(activity) ||
                            "VIEW_SEASON_CALENDAR".equals(activity)  ||
                            "VIEW_LINE_PRESENTATION_BOARD".equals(activity)  ||
                    		"VIEW_SEASON_PLANNING".equals(activity)  ||
                            "VIEW_SEASON_CHANGE_REPORT".equals(activity) ||
			    "CALENDAR_DASHBOARD_REPORT".equals(activity)
                        ){ %>


                    <%if(ACLHelper.hasViewAccess(FlexTypeCache.getFlexTypeRoot("Plan"))){%>
                        <%= createSubTab(planningLabel,"javascript:viewSeasonPlanning('" + seasonId +"')","VIEW_SEASON_PLANNING".equals(activity)) %>
                    <% } %>
                    <%= createSubTab(lineSheetLabel,"javascript:viewLinePlan('" + seasonId + "', true)","VIEW_LINE_PLAN".equals(activity)) %>
					<%if(!lcsContext.isVendor){%>
					 <%= createSubTab(presentationBoardLabel,"javascript:viewLineBoard('" + seasonId +"')","VIEW_LINE_PRESENTATION_BOARD".equals(activity)) %>
					 <%= createSubTab(calendarLabel,"javascript:viewSeasonCalendar('" + seasonId +"')","VIEW_SEASON_CALENDAR".equals(activity)) %>
					 <%= createSubTab(dashboardsLabel,"javascript:viewSeasonDashboards('" + seasonId +"')","VIEW_SEASON_DASHBOARDS".equals(activity)) %>
					<%}%>

                    
                    <%-- <%= createSubTab(changeReportLabel,"javascript:viewSeasonChangeReport('" + seasonId +"')","VIEW_SEASON_CHANGE_REPORT".equals(activity)) %> --%>
            <% } %>

            </tr>
        </table>
   </td>
</tr>
<% } %>