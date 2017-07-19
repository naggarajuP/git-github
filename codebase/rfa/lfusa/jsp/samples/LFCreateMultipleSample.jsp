<%-- Copyright (c) 2002 PTC Inc.   All Rights Reserved --%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// JSP HEADERS ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%@page language="java"
       import="com.lcs.wc.classification.ClassificationTreeLoader,
                com.lcs.wc.client.Activities,
				wt.part.WTPartMaster,
				wt.fc.WTObject,
                com.lcs.wc.client.web.*,
                com.lcs.wc.season.*,
                com.lcs.wc.sourcing.*,
                com.lcs.wc.foundation.*,
                com.lcs.wc.product.*,
                com.lcs.wc.specification.*,
                com.lcs.wc.measurements.*,
				com.lcs.wc.color.LCSColor,
                com.lcs.wc.util.*,
                com.lcs.wc.db.*,
                java.util.*,
                wt.util.*,
                wt.part.*,
                com.lcs.wc.flextype.*,
                com.lcs.wc.sample.*,
                wt.doc.DepartmentList"
%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- //////////////////////////////// BEAN INITIALIZATIONS ///////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<jsp:useBean id="sampleRequestModel" scope="request" class="com.lcs.wc.sample.LCSSampleRequestClientModel" />
<jsp:useBean id="tg" scope="request" class="com.lcs.wc.client.web.TableGenerator" />
<jsp:useBean id="fg" scope="request" class="com.lcs.wc.client.web.FormGenerator" />
<jsp:useBean id="flexg" scope="request" class="com.lcs.wc.client.web.FlexTypeGenerator" />
<jsp:useBean id="lcsContext" class="com.lcs.wc.client.ClientContext" scope="session"/>
<jsp:useBean id="appContext" class="com.lcs.wc.client.ApplicationContext" scope="session"/>
<%
    flexg.setCreate(true);
    flexg.setScope(SampleRequestFlexTypeScopeDefinition.SAMPLEREQUEST_SCOPE);
    flexg.setMultiClassForm(true);

%>
<%!
	public static final String subURLFolder = LCSProperties.get("flexPLM.windchill.subURLFolderLocation");
public static final String defaultCharsetEncoding = LCSProperties.get("com.lcs.wc.util.CharsetFilter.Charset","UTF-8");
    public static final String URL_CONTEXT = LCSProperties.get("flexPLM.urlContext.override");
    public static final String WT_IMAGE_LOCATION = LCSProperties.get("flexPLM.windchill.ImageLocation");
    public static final String CLIENT_SIDE_PLUGIN = PageManager.getPageURL("CLIENT_SIDE_PLUGINS", null);
	private Boolean flag = true;

	//Added by Rohini
	public static final boolean DISPLAY_COLORCRITERIA   = LCSProperties.getBoolean("jsp.testing.FitApproval.ColorCriteria");
	public static final boolean MEASUREMENT_SIZE_REQUIRED   = LCSProperties.getBoolean("jsp.testing.FitApproval.MeasurementSizeRequired");

	//End -- Rohini


%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ////////////////////////////// INITIALIZATION JSP CODE //////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%
   String errorMessage = request.getParameter("errorMessage");
   FlexType type = sampleRequestModel.getFlexType();
   LCSSourcingConfigMaster scMaster = (LCSSourcingConfigMaster)sampleRequestModel.getSourcingMaster();
   LCSProduct product = null;
   LCSProduct productSeasonRev = null;
   //LCSSeason season = null;
   String measurementsId = "";
   String measurementsName = "";
   String sampleSize = "";
   String quantityDefaultValue = "1";
   // Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
   // Description : <Default Value for the Custom Sample Quantity>
   String lfSampleQuantityDefaultValue = "1.00";
   // Added as a PATCH Fix (dated - 17th Jun 2014)
   String measurementDefaultKey = "";
  
   LCSMeasurements measurements = null;
   LCSSourcingConfig sconfig = null;
   WTPartMaster specMaster = sampleRequestModel.getSpecMaster();
   FlexSpecification spec = (FlexSpecification) VersionHelper.latestIterationOf(specMaster);
   if(scMaster != null){
        product = SeasonProductLocator.getProductARev(scMaster);
        //season = SeasonProductLocator.getSeasonRev(product);
        sconfig = (LCSSourcingConfig) VersionHelper.latestIterationOf(scMaster);
        // Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
        // Description : <Sets the boolean flag Basing on the Product Flex Type>
        FlexType productFlexType = product.getFlexType();
		String flexTypeName = productFlexType.getFullName();
		if (flexTypeName.contains("Apparel")||flexTypeName.contains("Footwear")){
			// Flag as False(No Changes in the Grid)
			flag = true;
		}else{
			// Flag as True(Changes in the Grid)
			flag = false;
		}
	}

   if(FormatHelper.hasContent(request.getParameter("measurementsId"))){
        measurementsId = request.getParameter("measurementsId");
        measurements = (LCSMeasurements) LCSQuery.findObjectById(measurementsId);
   }

	FlexTypeAttribute quantityAtt = null;
    try{
        quantityAtt = type.getAttribute("quantity");
	    if(FormatHelper.hasContent(quantityAtt.getAttDefaultValue())){
			quantityDefaultValue = quantityAtt.getAttDefaultValue();
		}
	}catch(WTException wte){
	}

String createButton = WTMessage.getLocalizedMessage ( RB.MAIN, "create_Btn", RB.objA ) ;
String cancelButton = WTMessage.getLocalizedMessage ( RB.MAIN, "cancel_Btn", RB.objA ) ;
String createNewSamplePgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "createNewSample_PG_HEAD", RB.objA ) ;
String sampleAttributesPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleAttributes_GRP_TLE", RB.objA ) ;
String typeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "type_LBL", RB.objA ) ;
String productLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "product_LBL", RB.objA ) ;
//String seasonLabel = WTMessage.getLocalizedMessage ( RB_MAIN, "season_LBL", RB.objA ) ;
String measurementsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "measurements_LBL", RB.objA ) ;
//Added by Rohini
String measurementSetLabel = WTMessage.getLocalizedMessage ( RB.MEASUREMENTS, "measurementSet_LBL", RB.objA ) ;
String quantityLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "quantity_LBL", RB.objA ) ;
String sizeColumnLabel = WTMessage.getLocalizedMessage ( RB.UTIL, "sizeColumn_LBL", RB.objA ) ;
String colorLabel = WTMessage.getLocalizedMessage ( RB.COLOR, "color_LBL", RB.objA ) ;
// End -- Rohini
String sourcingLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "sourcing_LBL", RB.objA);
String samplesLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "samples_LBL", RB.objA);
String sampleRequestDetailsLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequestDetails_LBL", RB.objA ) ;
String createNewSampleRequestLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "createNewSampleRequest_PG_HEAD", RB.objA ) ;
String sampleRequestAttributesPgHead = WTMessage.getLocalizedMessage ( RB.SAMPLES, "sampleRequestAttributes_GRP_TLE", RB.objA ) ;
String specLabel = WTMessage.getLocalizedMessage ( RB.SPECIFICATION, "specification_LBL", RB.objA);
String samplesRequestedLabel = WTMessage.getLocalizedMessage ( RB.SAMPLES, "samplesRequested_LBL", RB.objA);

// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
// Description : <Sample Quantity label for the Grid>
String sampleQuantityColumnLabel = "Sample Quantity";



%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// JAVSCRIPT ///////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<script language="Javascript">

    function create(){
		endCellEdit();    
        if(validate() && validate2()){
            document.MAINFORM.activity.value = 'CREATE_MULTIPLE_SAMPLE';
            document.MAINFORM.action.value = 'SAVE';
            var dataString = getDataString();
            //alert(dataString);
            document.MAINFORM.LCSSAMPLEREQUEST_sampleRequestString.value = dataString;
			// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
			// Description : <Variable to fetch the data from the Grid and set it in lfFloatSampleQuantity>
			var qtyString = getCustomValuesFromGrid();
			document.MAINFORM.lfFloatSampleQuantity.value = qtyString;
			//alert("qtyString****"qtyString);
			submitForm();
        }
    }

   function validate(){
        <%= flexg.drawFormValidation(type.getAttribute("requestName")) %>
        <%= flexg.generateFormValidation(sampleRequestModel) %>        
        return true;
    }
    

	function backCancel(){
		if(document.MAINFORM && hasContent(document.MAINFORM.returnActivity.value)){
			document.MAINFORM.activity.value = document.MAINFORM.returnActivity.value;

			if(!hasContent(document.MAINFORM.returnOid.value)){
				document.MAINFORM.oid.value ='';
			}else{
				document.MAINFORM.oid.value = document.MAINFORM.returnOid.value;
			}

			if(!hasContent(document.MAINFORM.returnAction.value)){
				document.MAINFORM.action.value = 'INIT';
			}else{
				document.MAINFORM.action.value = document.MAINFORM.returnAction.value;
			}
			<%if(FormatHelper.hasContent(request.getParameter("fromMeasurementsPage"))){%>
				document.MAINFORM.tabPage.value='MEASUREMENTS';
			<%
			}
			%>

			submitForm();
		}
	}
    


</script>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<input name="LCSSAMPLEREQUEST_sampleRequestString" type="hidden" value="">
<input name="typeId" type="hidden" value='<%= FormatHelper.getObjectId(sampleRequestModel.getFlexType()) %>'>
<% if(sconfig != null){ %>
<input name="sourcingConfigId" type="hidden" value='<%= FormatHelper.getVersionId(sconfig) %>'>
<% } %>
<% if(specMaster != null){ %>
<input name="specMasterId" type="hidden" value='<%= FormatHelper.getObjectId(specMaster) %>'>
<% } %>

<% if(product != null){ %>
<input name="ownerMasterId" type="hidden" value='<%= FormatHelper.getObjectId((WTPartMaster)product.getMaster()) %>'>
<% } %>
<% if(measurements != null){ %>
<input name="measurementsId" type="hidden" value='<%= FormatHelper.getVersionId(measurements) %>'>
<% } %>

<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
Description : <input lfFloatSampleQuantity to store data from the Grid> -->
<input name="lfFloatSampleQuantity" type="hidden" value="">



<table width="100%"  onClick="endCellEdit()">
    <tr>
        <td class="PAGEHEADING">
            <table width="100%">
                <tr>
                    <td class="PAGEHEADINGTITLE">
			<%=createNewSampleRequestLabel%>
                   </td>
                    <td class="button" align="right">
                        <a class="button" href="javascript:create()"><%= createButton %></a>&nbsp;&nbsp;|&nbsp;&nbsp;
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
         <%= tg.startGroupTitle() %><%=sampleRequestAttributesPgHead%><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>

            <col width="15%"><col width="35%">
            <col width="15%"><col width="35%">
            <input type="hidden" name="docTypeString" value="$$Document">
            <input type="hidden" name="departmentString" value="DOCUMENTATION">
            <tr>
               <%= flexg.drawFormWidget(type.getAttribute("requestName"), sampleRequestModel) %>
               <%= FormGenerator.createDisplay(typeLabel, type.getFullNameDisplay(), FormatHelper.STRING_FORMAT) %>
            </tr>
            <% if(product != null){ %>
            <tr>
                <%= fg.createDisplay(productLabel, product.getName(), FormatHelper.STRING_FORMAT) %>
                <%= fg.createDisplay(specLabel, spec.getName(), FormatHelper.STRING_FORMAT) %>
            </tr>
            <% } %>
            <% if(measurements != null){ %>

            <tr>
                <%= fg.createDisplay(sourcingLabel, sconfig.getSourcingConfigName(), FormatHelper.STRING_FORMAT) %>
            </tr>


            <% } %>


         </td>
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
        </td>
    </tr>

</table>




  <table width="100%" onClick="endCellEdit()">
   <tr>
      <td>
         <%= flexg.generateForm(sampleRequestModel) %>
      </td>
   </tr>
   </table>
   





<%
//setting up which RBs to use

String TG_MAIN = "com.lcs.wc.resource.TableGeneratorRB";

String insertButton = WTMessage.getLocalizedMessage ( RB.MAIN, "insert_Btn", RB.objA ) ;
String clearAll = WTMessage.getLocalizedMessage ( RB.MAIN, "clearAll_ALTS",RB.objA ) ;
String selectAll = WTMessage.getLocalizedMessage ( RB.MAIN, "selectAll_ALTS",RB.objA ) ;
String deleteSelectedRows = WTMessage.getLocalizedMessage ( RB.MAIN, "deleteSelectedRows_ALTS",RB.objA ) ;
String insertBeforeSelectRows = WTMessage.getLocalizedMessage ( RB.MAIN, "insertBeforeSelectRows_ALTS",RB.objA ) ;
String insertAfterSelectRows = WTMessage.getLocalizedMessage ( RB.MAIN, "insertAfterSelectRows_ALTS",RB.objA ) ;
String insertBeforeLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "insertBefore_LBL",RB.objA ) ;
String insertAfterLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "insertAfter_LBL",RB.objA ) ;
String deleteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "delete_LBL",RB.objA ) ;
//String cutLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "cut_LBL",RB.objA ) ;
//String copyLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "copy_LBL",RB.objA ) ;
//String pasteLabel = WTMessage.getLocalizedMessage ( RB.MAIN, "paste_LBL",RB.objA ) ;
String youMustSpecifyAValueForAlrt = WTMessage.getLocalizedMessage ( RB.MAIN, "youMustSpecifyAValueFor_ALRT" , RB.objA );

Collection measurementsList = FlexSpecQuery.getSpecComponents(spec, "MEASUREMENTS");

Iterator measurementsIter = measurementsList.iterator();
Hashtable measurementsTable = new Hashtable();

%>


<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- ///////////////////////////////////////  JS  ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<link href="<%=URL_CONTEXT%>/css/domtableeditor.css" rel="stylesheet">
<script>
    var URL_CONTEXT = '<%= URL_CONTEXT %>';
    var WT_IMAGE_LOCATION = ('<%=WT_IMAGE_LOCATION%>');
</script>

<script type="text/javascript" src="<%=URL_CONTEXT%>/javascript/domtableeditor.js"></script>
<script type="text/javascript" src="<%=URL_CONTEXT%>/javascript/datamodel.js"></script>
<script>
   var moaModel = new TableDataModel();
   var dataModel = moaModel;
   var log = new quickDoc();

    DOM_TE_ALLOW_ROW_DELETE_MESSAGE = "You do not have access to delete rows.";
    DOM_TE_ALLOW_ROW_INSERT_MESSAGE = "You do not have access to insert rows.";

 

    var sizeRuns = new Array();
    var sampleSizes = new Array();

   <%
   LCSMeasurements measurementsItem = null;
   while(measurementsIter.hasNext()){
      measurementsItem = (LCSMeasurements)measurementsIter.next();
      if(VersionHelper.isWorkingCopy(measurementsItem)){
         measurementsItem = (LCSMeasurements)VersionHelper.getOriginalCopy(measurementsItem);
      }
      if(FormatHelper.getVersionId(measurementsItem).equals(measurementsId)){
        measurementsName = measurementsItem.getValue("name").toString();
        sampleSize = measurementsItem.getSampleSize();
      }
      measurementsTable.put(FormatHelper.getVersionId(measurementsItem), measurementsItem.getValue("name").toString());
   %>
   sizeRuns['<%=FormatHelper.getVersionId(measurementsItem)%>'] = moaToArray('<%=measurementsItem.getSizeRun()%>');
   sampleSizes['<%=FormatHelper.getVersionId(measurementsItem)%>'] = '<%=measurementsItem.getSampleSize()%>';
   
   <%
   }  
   
   
   %>



    function selectRowForCellImage(img){
        var row = img.parentNode.parentNode;
        selectRow(row);
    }

    //////////////////////////////////////////////////////////////////////////////////////
    // IMPLEMENATION OF METHODS NEEDED FOR DOM TABLE EDITOR...
    // ADDED TO SPECIFIC EDITOR FOR OVERRIDING FUNCTIONALITY
    //////////////////////////////////////////////////////////////////////////////////////
    /** Pulls value from branch to be set into a widget on load.
     */
    function getValueForWidget(branch, attKey){
        return format(branch[attKey]);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    /** Pulls value from branch to be set into a widget on load.
     */
    function getDisplayForWidget(branch, attKey){
        return format(branch[attKey + "Display"]);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function getDisplayFromWidgetDisplay(branch, display, attKey){
        return format(display);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function getValueFromWidgetValue(branch, value, attKey){
        return format(value);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function isEditable(cell){

        return true;
    }

    //////////////////////////////////////////////////////////////////////////////////////
    /** Custom logic for handling a change in a cell.
     * Called after data has been set, but before widget is unloaded.
     */
    //////////////////////////////////////////////////////////////////////////////////////
   function handleChange(oldValue, newValue, branch, sourceCell, attKey){
        
        <jsp:include page="<%=subURLFolder+ CLIENT_SIDE_PLUGIN %>" flush="true" >
             <jsp:param name="type" value="<%= FormatHelper.getObjectId(type) %>"/>
             <jsp:param name="pluginType" value="DOMTE_handleChange"/>
        </jsp:include>
    }

    //////////////////////////////////////////////////////////////////////////////////////


    function insertRow(before, index, child) {
        endCellEdit();
        deSelectCell(currentCell);
        endCellEdit();
        var newBranch = dataModel.addBranch();
        var table = document.getElementById(domTableEditor_currentTable);
        var rowIndex = index;
        if(before && currentRow){
            rowIndex = currentRow.rowIndex;
        } else if(currentRow){
            rowIndex = currentRow.rowIndex + 1;
        }

		if(child){
			 var pbranch = getBranchFromRow(currentRow);

			 newBranch.parentBranchId = pbranch.branchId;
		}

        if(rowIndex == 0 || !hasContent(rowIndex)){
            rowIndex = 1;
        }


        var newRow = table.insertRow(rowIndex);
        newRow.id = "r" + newBranch.branchId;
        newRow.onmouseover = hoverRow;
        newRow.onmouseout = unHoverRow;

        var cell = newRow.insertCell(0)

		if(child){
			 cell.innerHTML = '<img id="menuImage' + newBranch.branchId + '" onclick="selectRowForCellImage(this); return overlib(menuArray[\'childMenu\'], STICKY, MOUSEOFF);" border="0" src="' + WT_IMAGE_LOCATION + '/edit.gif">';
		}else{
			 cell.innerHTML = '<img id="menuImage' + newBranch.branchId + '" onclick="selectRowForCellImage(this); return overlib(menuArray[\'tableMenu\'], STICKY, MOUSEOFF);" border="0" src="' + WT_IMAGE_LOCATION + '/edit.gif">';
		}
		cell.className = "actionsOV";

        cell = newRow.insertCell(1)
        cell.innerHTML = '<input type="checkbox" name="selectedIds" value="r'+newBranch.branchId+'">';
        cell.className = "selections";

        for (var i = 0; i < columnList.length; i++) {
            cell = newRow.insertCell(i + 2)
            cell.innerHTML = "&nbsp;";
            cell.id = "r" + newBranch.branchId + "_" + columnList[i];
            if(hasContent(defaultValues[columnList[i]])){
                cell.innerHTML = defaultValues[columnList[i]];
                // Very specific fix for Tolerance fields in an initial row, when no size run exists for the Measurements Set
                if (defaultValues[columnList[i]] == "0.000") {
                    cell.isFloat="true";
                }
            }
            if(hasContent(alignments[columnList[i]])){
                cell.align = alignments[columnList[i]];
            }
            if(hasContent(classNames[columnList[i]])){
                cell.className= classNames[columnList[i]];
            }            
            setValuesFromCell(cell);
        }
        updateSortingNumbers(table);
        selectRow(newRow);
        if(domTableEditor_postInsertMethod){
            eval(domTableEditor_postInsertMethod);
        }

        initNewRow(newRow, newBranch);   
    }

    //////////////////////////////////////////////////////////////////////////////////////
    /** Locates the proper widget for a cell and loads it.
     * The proper state of the widget is then loaded from
     * the appropriate data.
     * @param    cell    The cell to load.
     */
    function loadWidget(cell){
        //alert("loadWidget");

        if(domTableEditor_widgetCustomWidgetLoader && eval(domTableEditor_widgetCustomWidgetLoader)){
            return;
        }

        try {
            selectRow(cell.parentNode);
            var id = cell.id;

            var attKey = id.substring(id.indexOf('_') + 1, id.length);
            var branchId = id.substring(1, id.indexOf('_'));

            var branch = dataModel.getBranch(branchId);


            cellType = cellTypes[attKey];
            currentCellType = cellType;

            var currentValue = getValueForWidget(branch, attKey);
            var currentDisplay = getDisplayForWidget(branch, attKey);

            while(cell.childNodes.length > 0){
                cell.removeChild(cell.childNodes[0]);
            }


            var widgetIndex = attKey;

            var widget = widgets[widgetIndex];
            
            
            if(attKey=='size'){
                 var currentMeasurementValue = getValueForWidget(branch, "measurementsSet");
                 var sizes = sizeRuns[currentMeasurementValue];
                 var selectString = "";                 
                 if(sizes!=undefined){
		    for(var j=0; j<sizes.length; j++){
		       selectString = selectString + "<option value=\"" + sizes[j] + "\" >" + sizes[j];
		    }    
                 }
             
                 widget.innerHTML = "<select name=\"size\" id=\"size\" parent=\"size\" onkeydown=\"typeAhead()\"><option value=\" \">" + selectString + "</select>";

            }

			// Target Point Build : <004.23> Request ID : <11> Modified On: 22-May-2013 Author : <Archana>
			// Description : <Added Condition to Autopopulate if there is only one measurement.>
			// ITC - Start
			if(attKey=='measurementsSet'){
				<%//If the Size of Measurment Table is 1
				if(measurementsTable.size()==1){
					for (Object o: measurementsTable.entrySet() ) {
					// Data in the Measurment Table
					Map.Entry entry = (Map.Entry) o;
					// Added as a PATCH Fix (dated - 17th Jun 2014)
					measurementDefaultKey = (String)entry.getKey();
					%>
				//The value to be added in the Cell 
				<%}}%>
				//ITC - End
			}

			
            cell.appendChild(widget);


            widget = cell.childNodes[0];
            //widget = getWidgetFromCell(cell);
            if("composite" == cellType){
                //setChosenLabelElements(widget);
            }

            loadWidgetData(widget, cellType, currentValue, currentDisplay);
            if (!programmaticWidgetUpdate) {
                window.setTimeout('handleWidgetFocus()', 50);
            }
			
			// Target Point Build : <004.23> Request ID : <11> Modified On: 22-May-2013 Author : <Archana>
			// Description : <Added Condition to set the Size when measurement is Autopopulated.>
			// ITC - Start
			if(attKey=='measurementsSet'){
				var sizeCell = getCell(currentRow, 3);
				var branch = getBranchFromRow(currentRow);
				//reset the size to empty if no measurements set is selected
				if(currentValue==""){
					sizeCell.innerHTML = "";
					branch['size'] = ""; 
				}else{
					//set the size to the sample size of the selected measurements set
					sizeCell.innerHTML = sampleSizes[currentValue];
					branch['size'] = sampleSizes[currentValue]; 
				}
			}
			// ITC - End
       } catch (exception){
           alert('Exception occured in loadWidget: ' + exception.message);
		   for(var n in exception){
				//debug(n + ':' + exception[n]);
		   }
        }

    }

   function moveCell(directionCode){
        if(!currentCell){
            return;
        }

        if(!isEditable(currentCell)){
            return;
        }

      //var cellIndex = currentCell.cellIndex;
      var cellIndex = getCellPosition(currentCell);

        deSelectCell(currentCell);
        endCellEdit();
        var cell = findNextEditableCell(cellIndex, directionCode );
        if (cell) {
            startEditCell(cell);
        }

    }

    /**
    * Target Point Build: 004.23
    * Request ID : <7>
    * Description : <Changed the Row Number of the Columns according the new 
    * Arrangement and Set the default value for the Custom Sample Quantity>
    * @author Bineeta
    * Modified On: 22-May-2013
    */
     /////////////////////////////////////////////////////////////////////////////////////
    function initNewRow(newRow, newBranch){

		//Default the measurements set to the selected measurements set from the 
		//previous page and the size to the sample size of the measurements set.
		//Also set the quantity to "1" by default.
		var quantityCell = getCell(newRow, null);
		var measurementsSetCell = getCell(newRow, 2);
		var sizeCell = getCell(newRow, 3);
		//ITC - Added
		var sampleQuantityCell = getCell(newRow, 4);

		var measurementkey = '<%=measurementDefaultKey%>';
		// Added as a patch fix for dated 17th jun 2014
		if(measurementkey != null && measurementkey != ""){
			newBranch['measurementsSet'] = measurementkey; 
		}else{
			measurementsSetCell.innerHTML = '<%=FormatHelper.formatJavascriptString(measurementsName)%>';
			newBranch['measurementsSet'] = '<%=FormatHelper.formatJavascriptString(measurementsId)%>'; 
		}
		sizeCell.innerHTML ='<%=FormatHelper.formatJavascriptString(sampleSize)%>';
		newBranch['size'] = '<%=FormatHelper.formatJavascriptString(sampleSize)%>'; 
		quantityCell.innerHTML = '<%=quantityDefaultValue%>';
		newBranch['quantity'] = '<%=quantityDefaultValue%>';
		//ITC - Added
		sampleQuantityCell.innerHTML = '<%=lfSampleQuantityDefaultValue%>';
		newBranch['lfFloatSampleQuantity'] = '<%=lfSampleQuantityDefaultValue%>';

    }    
    
    
    
    
    
    function save(){
        endCellEdit();
        var dataString = getDataString();

    }
    //////////////////////////////////////////////////////////////////////////////////////
    function saveAndDone(){
        endCellEdit();
        var dataString = getDataString();
    }
    //////////////////////////////////////////////////////////////////////////////////////

    function validate2(){
        var branch;
        var branches = moaModel.getData();

        for(var i = 0; i < branches.length; i++){

            branch = branches[i];
            // IF DROPPED BUT NOT PERSISTED THEN SKIP
            if(branch.dropped){
                continue;
            }

            if(!checkRequiredFields(branch)){
                return false;
            }
        }
        return true;
    }
    //////////////////////////////////////////////////////////////////////////////////////
   function getDataString(){
        var dataString = new quickDoc();
        var branch;
        var branches = moaModel.getData();

        for(var i = 0; i < branches.length; i++){

            branch = branches[i];
            // IF DROPPED BUT NOT PERSISTED THEN SKIP
            if(branch.dropped && !branch.persisted){
                continue;
            }


            if(branch.touched){

                var tempString = new quickDoc();
                tempString.write('sortingNumber|&^&|' + format(branch.sortingNumber) + '|-()-|');
                tempString.write('ID|&^&|' + branch.branchId + '|-()-|');
                tempString.write('DROPPED|&^&|' + branch.dropped + '|-()-|');
                changeMade = false;
                
                    // ONLY VALUES THAT HAVE CHANGED ARE PASSED.
                    if(moaModel.hasValueChanged(branch.branchId, 'quantity') ||
                       moaModel.hasValueChanged(branch.branchId, 'sortingNumber')){
                        changeMade = true;
                        //alert("Change : quantity id = " +branch.branchId);
                    }
                
                    // ONLY VALUES THAT HAVE CHANGED ARE PASSED.
                    if(moaModel.hasValueChanged(branch.branchId, 'size') ||
                       moaModel.hasValueChanged(branch.branchId, 'sortingNumber')){
                        changeMade = true;
                        //alert("Change : size id = " +branch.branchId);
                    }

                    // ONLY VALUES THAT HAVE CHANGED ARE PASSED.
                    if(moaModel.hasValueChanged(branch.branchId, 'measurementsSet') ||
                       moaModel.hasValueChanged(branch.branchId, 'sortingNumber')){
                        changeMade = true;
                        //alert("Change : measurementsSet id = " +branch.branchId);
                    }

                    // ONLY VALUES THAT HAVE CHANGED ARE PASSED.(ITC)
                    if(moaModel.hasValueChanged(branch.branchId, 'lfFloatSampleQuantity') ||
                       moaModel.hasValueChanged(branch.branchId, 'sortingNumber')){
                        changeMade = true;
                        //alert("Change : lfFloatSampleQuantity id = " +branch.branchId);
                    }

                    // ONLY VALUES THAT HAVE CHANGED ARE PASSED.
				<%	if(DISPLAY_COLORCRITERIA){ %>
						if(moaModel.hasValueChanged(branch.branchId, 'color') ||
						   moaModel.hasValueChanged(branch.branchId, 'sortingNumber')){
							changeMade = true;
							//alert("Change : color id = " +branch.branchId);
						} 
				<%	} %>
                
                if(changeMade || branch.dropped){
                    
                        tempString.write('quantity|&^&|' + format(branch.quantity) + '|-()-|');
                    
                        tempString.write('size|&^&|' + format(branch.size) + '|-()-|');

                        tempString.write('measurementsSet|&^&|' + format(branch.measurementsSet) + '|-()-|');

						tempString.write('lfFloatSampleQuantity|&^&|' + format(branch.lfFloatSampleQuantity) + '|-()-|');

                  <%  if(DISPLAY_COLORCRITERIA){ %>
                        tempString.write('color|&^&|' + format(branch.color) + '|-()-|');
				  <%  } %>
                    dataString.write(tempString.toString());
                    dataString.write('|!#!|'); // ENTRY DELIMETER                
                 }
            }
        }
        endCellEdit();

        return dataString.toString();
    }

    /**
    * 
    * Target Point Build: 004.23
    * Request ID : <7>
    * Modified On: 22-May-2013
    * Method to get the Values from the Grid 
    * from the Sample Request Create Page
    * @author  Bineeta
    * getCustomValuesFromGrid
    * @return qtyString contains the sample quantity value
    */
	// ITC -  Start
    //////////////////////////////////////////////////////////////////////////////////////
    function getCustomValuesFromGrid(){

        var qtyString = new quickDoc();
        var branch;
        var branches = moaModel.getData();

        for(var i = 0; i < branches.length; i++){

            branch = branches[i];
            // IF DROPPED BUT NOT PERSISTED THEN SKIP
            if(branch.dropped && !branch.persisted){
                continue;
            }
            if(branch.touched){
                var tempString1 = new quickDoc();
				// The Branch ID of the Grid 
                tempString1.write('' + branch.branchId + '-');
				// The Sample Quantity value
				tempString1.write('' + format(branch.lfFloatSampleQuantity) + ',');
                qtyString.write(tempString1.toString());
            }
        }
        endCellEdit();
        return qtyString.toString();
	}
	// ITC - End

    
    //////////////////////////////////////////////////////////////////////////////////////
    function checkRequiredFields(branch){

       if(!hasContentNoZero(branch['quantity'])){
	   //alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(quantityLabel, false)%>');
	    return false;
       }

       <% //PRODUCTION FIX- Defect # 1113_ Home Sample Request Fix
		   if(flag){
		   if(MEASUREMENT_SIZE_REQUIRED){
	   %>
	       if(!hasContentAllowZero(branch['measurementsSet'])){  
		   alert("Measurement missing");
		   alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(measurementSetLabel, false)%>');
		   return false;
	       }                          
	   <%
	    }
	   %>
                           

	 if(!hasContentAllowZero(branch['size']) && hasContentAllowZero(branch['measurementsSet'])){ 
               alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(sizeColumnLabel, false)%>');
               return false;
         }

	 if(hasContentAllowZero(branch['size']) && !hasContentAllowZero(branch['measurementsSet'])){  
	      alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(measurementSetLabel, false)%>');
              return false;
         }
	 if(hasContentAllowZero(branch['size']) && !hasContentNoZero(branch['quantity'])){                   
	      alert(' <%= FormatHelper.formatJavascriptString(youMustSpecifyAValueForAlrt , false) + " " + FormatHelper.formatJavascriptString(quantityLabel, false)%>');
              return false;
         }
<%}%>
	 // Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
	 // Description : <Check for the Sample Quantity to be in between 0-40 >
	 // ITC - Start
	 if(branch['lfFloatSampleQuantity'] > 40){                   
	      alert(' Maximum Sample Quantity can be 40');
              return false;
         }

	 if(branch['lfFloatSampleQuantity'] < 0){                   
	      alert(' Minimum Sample Quantity should be 1');
              return false;
         }
	 // ITC - End
              
        return true;
    }
    //////////////////////////////////////////////////////////////////////////////////////
    function handleWidgetFocus(widget){
        if(currentWidget){
            widget = currentWidget;
        }
		if(widget.tagName == 'TEXT' || widget.tagName == 'INPUT'){
            widget.focus();
            if(widget.select){
                widget.select();
            }
        }
        else {
            widget.focus();
        }
    }

    function insertNewRow(){
        var table = document.getElementById("editorTable");
        insertRow(null, (getRowCount(table)-2)+1);
 
       
    }

    function resetSampleSize(list){
        var selectedIndex = list.selectedIndex;
		// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
		// Description : <Changed the Row number >
		var sizeCell = getCell(currentRow, 3);
		var branch = getBranchFromRow(currentRow);
		//reset the size to empty if no measurements set is selected
		if(selectedIndex==0){
			sizeCell.innerHTML = "";
			branch['size'] = ""; 
		}else{
			//set the size to the sample size of the selected measurements set
			var selectedMeasurementsSet = list.options[selectedIndex].value; 
			sizeCell.innerHTML = sampleSizes[selectedMeasurementsSet];
			branch['size'] = sampleSizes[selectedMeasurementsSet]; 
		}

	}

</script>








<%-- /////////////////////////////////////////////////////////////////////////////////////--%>
<%-- /////////////////////////////////////// HTML ////////////////////////////////////////--%>
<%-- /////////////////////////////////////////////////////////////////////////////////////--%>



<input type="hidden" name="dataString" value="">
<input type="hidden" name="maintainHiddenColumns" value="<%= request.getParameter("maintainHiddenColumns") %>">
<input type="hidden" name="color" value="<%= request.getParameter("color") %>">



<table width="100%">

   <tr>
      <td width="10%" valign="top">
         <%= tg.startGroupBorder() %>
         <%= tg.startTable() %>
         <%= tg.startGroupTitle() %><%=samplesRequestedLabel%><%= tg.endTitle() %>
         <%= tg.startGroupContentTable() %>



    <tr>
        <td>
            <a href="javascript:clearSelections()"><img src="<%=WT_IMAGE_LOCATION%>/clear_16x16.gif" alt="<%= clearAll %>" ></a>
            <a href="javascript:selectSelections(false)"><img src="<%=WT_IMAGE_LOCATION%>/select.selections.png" alt="<%= selectAll %>" ></a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="javascript:removeRows()"><img src="<%=WT_IMAGE_LOCATION%>/delete.png" alt="<%= deleteSelectedRows %>"></a>
            <a href="javascript:insertNewRow()"><img src="<%=WT_IMAGE_LOCATION%>/insert_row_below.gif" alt="<%= insertAfterSelectRows %>"></a>
        </td>
    </tr>
    <%
    int visCount = 6;;

    %>


    <tr>
        <td>
            <table id="editorTable" align=left width="100%" class="editor" border="0" cellspacing="1" onClick="handleTableClick()">
                <tr id="columns">
                   <td class="TABLESUBHEADER">&nbsp;</td>
                   <td class="TABLESUBHEADER">&nbsp;</td>

				   <!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						Description : < The OOTB Quantity Label id hidden and added condition to add the Measurement 
						and Size column header in the Grid if the Product Type is only Apparel>
					-->
					<!--  <td class="TABLESUBHEADER">&nbsp;*<%=quantityLabel%></td> -->
						<%if(flag){
							if(MEASUREMENT_SIZE_REQUIRED){
						%>
							<td class="TABLESUBHEADER">&nbsp;*<%=measurementSetLabel%></td>
							<td class="TABLESUBHEADER">&nbsp;*<%=sizeColumnLabel%></td>

						<%}else{
						%>
							<td class="TABLESUBHEADER">&nbsp;<%=measurementSetLabel%></td>
							<td class="TABLESUBHEADER">&nbsp;<%=sizeColumnLabel%></td>
							
						<%}
						}else{
							// Do nothing
						}%>
					<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						 Description : <Added Sample Quantity column Header in the Grid>
					-->
					<td class="TABLESUBHEADER">&nbsp;<%=sampleQuantityColumnLabel%></td>

						
			<% if(DISPLAY_COLORCRITERIA) { %>
				<td class="TABLESUBHEADER">&nbsp;<%=colorLabel%></td>
			<% } %>

                </tr>



                <tr id="columns">
                   <td class="TABLESUBHEADER">&nbsp;</td>
                   <td class="TABLESUBHEADER">&nbsp;</td>

				   <!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						Description : < The OOTB Quantity Label id hidden and added condition to add the Measurement 
						and Size column header in the Grid if the Product Type is only Apparel>
					-->
                   <!--   <td class="TABLESUBHEADER">&nbsp;*<%=quantityLabel%></td>  -->
                        <%if(flag){
							if(MEASUREMENT_SIZE_REQUIRED){
                        %>
                           <td class="TABLESUBHEADER">&nbsp;*<%=measurementSetLabel%></td>
                           <td class="TABLESUBHEADER">&nbsp;*<%=sizeColumnLabel%></td>

                        <%}else{
                        %>
                           <td class="TABLESUBHEADER">&nbsp;<%=measurementSetLabel%></td>
                           <td class="TABLESUBHEADER">&nbsp;<%=sizeColumnLabel%></td>                        
                        <%}
						}else{
							// Do Nothing

						}%>
					<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
						 Description : <Added Sample Quantity column Footer in the Grid>
					-->
					<td class="TABLESUBHEADER">&nbsp;<%=sampleQuantityColumnLabel%></td>

			<% if(DISPLAY_COLORCRITERIA) { %>
				<td class="TABLESUBHEADER">&nbsp;<%=colorLabel%></td>
			<% } %>
                </tr>

            </table>

        </td>
    </tr>
    <tr>
        <td>
            <a href="javascript:clearSelections()"><img src="<%=WT_IMAGE_LOCATION%>/clear_16x16.gif" alt="<%= clearAll %>"></a>
            <a href="javascript:selectSelections(false)"><img src="<%=WT_IMAGE_LOCATION%>/select.selections.png" alt="<%= selectAll %>"></a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="javascript:removeRows()"><img src="<%=WT_IMAGE_LOCATION%>/delete.png" alt="<%= deleteSelectedRows %>"></a>
            <a href="javascript:insertNewRow()"><img src="<%=WT_IMAGE_LOCATION%>/insert_row_below.gif" alt="<%= insertAfterSelectRows %>"></a>
        </td>
    </tr>
    <!-- SOURCE CELLS FOR DEFINING WIDGETS -->
    <tr>
        <td>
            <table>
	<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
					// Description : <Quantity Source Cell Hidden as not Required Any more in the Grid>
					 -->
          <!--           <td id="quantitySource"><div id="quantitySourceDiv">
<input type='text' value='' name='quantity' id='quantity' parent='quantity' onBlur='if(isValidIntegerRange(this, "<%=FormatHelper.formatJavascriptString(quantityLabel, false)%>", <%=quantityAtt.getAttLowerLimit()%>, <%=quantityAtt.getAttUpperLimit()%>, <%=quantityAtt.isAttUseUpperLimit()%>, <%=quantityAtt.isAttUseLowerLimit()%>)){handleWidgetEvent(this);}'></div></td> -->


	<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
			// Description : <Added condition to add the Measurement and Size column Cell in the Grid> -->
			<%if(flag){
			%>
                    <td id="measurementsSetSource"><div id="measurementsSetSourceDiv">
<%=FormGenerator.createDropDownList(measurementsTable, "measurementsSet", null, "resetSampleSize(this)", 1, true) %>


</td>
                
                    <td id="sizeSource"><div id="sizeSourceDiv"><select name="size" id="size" parent="size" onkeydown="typeAhead()">
<option value=" ">

</select></div></td>
	<%}else{
				// Do nothing

			}
			%>
			<!-- Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
			// Description : <Added Sample Quantity Cell to the Grid>
			 -->
			<td id="sampleQuantity"><div id="sampleQuantityDiv">
			<input type='text' value='' name='lfFloatSampleQuantity' id='lfFloatSampleQuantity' parent='lfFloatSampleQuantity' onBlur='if(isValidFloat(this, "Sample Quantity", 2)){handleWidgetEvent(this);}'></div></td>

<%
// Added by Rohini
Hashtable colorsTable = new Hashtable();
String seasonObj=(String)request.getParameter("returnOid");

LCSSeason season=null;

 //if(!seasonObj.equals("null"))
 if(seasonObj!=null)
  {
   
  WTObject wtObj=null;
  wtObj= (WTObject)LCSQuery.findObjectById(seasonObj);
  FlexSpecToSeasonLink fstsl = new FlexSpecToSeasonLink();
  if(wtObj != null && wtObj instanceof FlexSpecToSeasonLink)
  {
		fstsl = (FlexSpecToSeasonLink)wtObj;
  }
  System.out.println("fstsl **************"+fstsl);
	
	WTPartMaster flexseasonMaster;
	if(fstsl != null){
		flexseasonMaster = fstsl.getSeasonMaster();
		season = (LCSSeason)VersionHelper.latestIterationOf(flexseasonMaster);
	
	}
}


if(DISPLAY_COLORCRITERIA && season!=null)
{

	/*Iterator skuIter = LCSSKUQuery.findSKUs(product).iterator();
	LCSSKU skuObject;
	WTPartMaster skuMaster;
	String skuName = "";
	while (skuIter.hasNext()) {
		skuObject = (LCSSKU) skuIter.next();
		skuMaster =(WTPartMaster) skuObject.getMaster();
		skuName = (String)skuObject.getValue("skuName");
		colorsTable.put(FormatHelper.getNumericFromOid(skuMaster.toString()),skuName);*/
	Collection skusMasterCol = LCSSeasonQuery.getSKUMastersForSeasonAndProduct(season, product, false); 
	Iterator skuIter = skusMasterCol.iterator();
	LCSSKU skuObject;
	WTPartMaster skuMaster;
	String skuName = "";
	while (skuIter.hasNext()) {
		skuMaster = (WTPartMaster) skuIter.next();
		skuObject = (LCSSKU)VersionHelper.latestIterationOf(skuMaster) ;
		LCSSeasonProductLink sp = SeasonProductLocator.getSeasonProductLink(skuObject);
		
		if(sp!=null)
		{
		skuObject=SeasonProductLocator.getSKUARev(skuObject);
		skuName = (String)skuObject.getValue("skuName");
		colorsTable.put(FormatHelper.getNumericFromOid(skuMaster.toString()),skuName);
		}
	}
}
%>

<% if(DISPLAY_COLORCRITERIA){ %>
	<td id="colorSource"  ><div id="colorSourceDiv">
	<%=FormGenerator.createDropDownList(colorsTable, "colors", null, null, 1, true) %>
</div></td>
<% } %>


            </table>
        </td>
    </tr>
  
         <%= tg.endContentTable() %>
         <%= tg.endTable() %>
         <%= tg.endBorder() %>
      </td>
   </tr>


</table>
<div id="tableMenu" class="tableMenuStyle" onMouseover="highlightMenuOption()" onMouseout="lowlightMenuOption();checkHide();" onClick="invokeMenuAction();">
    <div class="menuItem" id="insertRow(false);"><%= insertAfterLabel %></div>
    <div class="menuItem" id="insertRow(true);"><%= insertBeforeLabel %></div>
    <div class="menuItem" id="removeRow();"><%= deleteLabel %></div>
</div>

<div id='tableMenuOV'>
<table>
    <tr><td><a href="javascript:insertRow(false);"><%= insertAfterLabel %></a></td></tr>
    <tr><td><a href="javascript:insertRow(true);"><%= insertBeforeLabel %></a></td></tr>
    <tr><td><a href="javascript:removeRow();"><%= deleteLabel %></a></td></tr>
</table>
</div>


</div>


<script>
    var menuArray = new Array();
    var tm = document.getElementById('tableMenuOV');
    menuArray['tableMenu'] = tm.innerHTML;
    tm.innerHTML = '';

    menuArray['childMenu'] = '';


    var cellTypes = new Object();
    var columnList = new Array();
    var alignments = new Object();
    var defaultValues = new Object();
    var sourceCell;
    var classNames = new Object();
    var precisions = new Object();

    var widget;
    
    DOM_TE_ALLOW_ROW_INSERT = true;
    

    
    DOM_TE_ALLOW_PERSISTED_ROW_DELETE = true;
    

	// Target Point Build : <004.23> Request ID : <7> Modified On: 22-May-2013 Author : <Bineeta>
	// Description : <Removed Quantity widget ,Added widget for Sample Quantity and condition for Measurement and Size Widget>
	<% if(flag) { %>
		sourceCell = document.getElementById('measurementsSetSource');
		widget = sourceCell.childNodes[0];
		//alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
		while(sourceCell.childNodes.length > 0){
			//alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
			var child = sourceCell.removeChild(sourceCell.childNodes[0]);
			if(!("TEXT" == child.tagName)){
				widget = child;
			}
		}
		widgets["measurementsSet"] = widget;

		cellTypes["measurementsSet"] = "choice";
		columnList[columnList.length] = "measurementsSet";
		defaultValues[columnList[columnList.length-1]] = "null";
		precisions["measurementsSet"] = 0;


		sourceCell = document.getElementById('sizeSource');
		widget = sourceCell.childNodes[0];
		//alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
		while(sourceCell.childNodes.length > 0){
			//alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
			var child = sourceCell.removeChild(sourceCell.childNodes[0]);
			if(!("TEXT" == child.tagName)){
				widget = child;
			}
		}
		widgets["size"] = widget;

		cellTypes["size"] = "choice";
		columnList[columnList.length] = "size";
		defaultValues[columnList[columnList.length-1]] = "null";
		precisions["size"] = 0;
	<%}else{

	}%>

	sourceCell = document.getElementById('sampleQuantity');
	widget = sourceCell.childNodes[0];
	//alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
	while(sourceCell.childNodes.length > 0){
		//alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
		var child = sourceCell.removeChild(sourceCell.childNodes[0]);
		if(!("TEXT" == child.tagName)){
			widget = child;
		}
	}
	widgets["lfFloatSampleQuantity"] = widget;

	cellTypes["lfFloatSampleQuantity"] = "float";
	columnList[columnList.length] = "lfFloatSampleQuantity";
	defaultValues[columnList[columnList.length-1]] = "null";
	precisions["lfFloatSampleQuantity"] = 0;

	<%	if(DISPLAY_COLORCRITERIA){ %>
			sourceCell = document.getElementById('colorSource');
			widget = sourceCell.childNodes[0];
			//alert(sourceCell.id + " child count = " + sourceCell.childNodes.length);
			while(sourceCell.childNodes.length > 0){
				//alert(sourceCell.id + " child = " + sourceCell.childNodes[0].tagName);
				var child = sourceCell.removeChild(sourceCell.childNodes[0]);
				if(!("TEXT" == child.tagName)){
					widget = child;
				}
			}
			widgets["color"] = widget;

			cellTypes["color"] = "choice";
			columnList[columnList.length] = "color";
			defaultValues[columnList[columnList.length-1]] = "null";
			precisions["color"] = 0;
		<%}%>

    


    var table = document.getElementById("editorTable");
    var tableMenu = document.getElementById("tableMenu");
    if(is.nav){
        table.addEventListener('click',handleTableClick,false);
        tableMenu.addEventListener('onmouseover',highlightMenuOption,false);
        tableMenu.addEventListener('onmouseout',checkHide,false);
        tableMenu.addEventListener('click',invokeMenuAction,false);
    }

    if(moaModel.dataModel.length == 0){
        
        insertRow(null, 1);
        //insertRow(null, 2);
        //insertRow(null, 3);
        
    }


</script>



