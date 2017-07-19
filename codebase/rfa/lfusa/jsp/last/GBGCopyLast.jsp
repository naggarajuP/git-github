<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="com.lcs.wc.classification.ClassificationTreeLoader,
                com.lcs.wc.client.Activities,
                com.lcs.wc.client.web.*,
                com.lcs.wc.util.*,
                java.util.*,
				wt.util.*,
                com.lcs.wc.flextype.*,
                wt.doc.DepartmentList"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="lastModel" scope="request" class="com.lcs.wc.last.LCSLastClientModel" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="flexg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<%
    flexg.setCreate(true);
%>
<%!
public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
    String errorMessage = request.getParameter("errorMessage");
   FlexType type = lastModel.getFlexType();
%>
<%
//setting up which RBs to use
Object[] objA = new Object[0];
String RB_MAIN = "com.lcs.wc.resource.MainRB";
String Last_MAIN = "com.lcs.wc.resource.LastRB";

//Task PLM-128 Implement Copy last Functionality
String createButton = "Copy" ;
String cancelButton = WTMessage.getLocalizedMessage ( RB_MAIN, "cancel_Btn", objA ) ;
String createNewLastPgHead = "Copy Last" ;
String lastAttributesGrpTle = WTMessage.getLocalizedMessage ( Last_MAIN, "lastAttributes_GRP_TLE", objA ) ;
String typeLabel = WTMessage.getLocalizedMessage ( RB_MAIN, "type_LBL", objA ) ;
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script language="Javascript">

    function copy(){
        if(validate()){
            document.MAINFORM.activity.value = 'COPY_LAST';
            document.MAINFORM.action.value = 'SAVE';
            submitForm();
        }
    }

   function validate(){
      <%= flexg.drawFormValidation(type.getAttribute("name")) %>
      <%= flexg.generateFormValidation(lastModel) %>
        return true;
    }

</script>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input name="typeId" type="hidden" value='<%= FormatHelper.getObjectId(lastModel.getFlexType()) %>'>
<table width="100%">
    <tr>
        <td class="PAGEHEADING">
            <table width="100%">
                <tr>
                    <td class="PAGEHEADINGTITLE">
                        <%= createNewLastPgHead %>
                    </td>
                    <td class="button" align="right">
                        <a class="button" href="javascript:copy()"><%= createButton %></a>&nbsp;&nbsp;|&nbsp;&nbsp;
                        <a class="button" href="javascript:backCancel()"><%= cancelButton %></a>
                    </td>
               </tr>
           </table>
       </td>
    </tr>
   <% if(FormatHelper.hasContent(errorMessage)) { %>
   <tr>
      <td class = "MAINLIGHTCOLOR" width="100%" border="0">
         <table>
            <tr>
               <td class="ERROR">
                  <%= java.net.URLDecoder.decode(errorMessage, defaultCharsetEncoding) %>
               </td>
            </tr>
         </table>
        </td>
   </tr>
   <% } %>
    <tr>
        <td>
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle() %><%= lastAttributesGrpTle %><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>

            <col width="15%"></col><col width="35%"></col>
            <col width="15%"></col><col width="35%"></col>
            <input type="hidden" name="docTypeString" value="$$Document">
            <input type="hidden" name="departmentString" value="DOCUMENTATION">
            <tr>
               <%= flexg.drawFormWidget(type.getAttribute("name"), lastModel) %>
               <%= FormGenerator.createDisplay(typeLabel, type.getFullNameDisplay(), FormatHelper.STRING_FORMAT) %>
            </tr>
         </td>
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
        </td>
    </tr>
   <tr>
      <td>
         <%= flexg.generateForm(lastModel) %>
      </td>
   </tr>
</table>
