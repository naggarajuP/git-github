package com.lfusa.wc.ibtinterface.staging;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import org.apache.commons.lang.StringUtils;

import wt.util.WTException;
import wt.util.WTPropertyVetoException;

import com.lcs.wc.db.Criteria;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.db.PreparedQueryStatement;
import com.lcs.wc.flextype.FlexType;
import com.lcs.wc.flextype.FlexTypeAttribute;
import com.lcs.wc.flextype.FlexTypeCache;
import com.lcs.wc.foundation.LCSLifecycleManaged;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.foundation.LCSRevisableEntity;
import com.lcs.wc.foundation.LCSRevisableEntityClientModel;
import com.lcs.wc.foundation.LCSRevisableEntityLogic;
import com.lcs.wc.moa.LCSMOATable;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.product.LCSProductQuery;
import com.lcs.wc.product.LCSSKU;
import com.lcs.wc.season.LCSSeason;
import com.lcs.wc.sourcing.LCSCostSheet;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.MOAHelper;
import com.lfusa.wc.ibtinterface.dataextractor.LFGenerateXML;
import com.lfusa.wc.ibtinterface.util.LFIBTConstants;
import com.lfusa.wc.ibtinterface.util.LFIBTMaterialNumberValidator;
import com.lfusa.wc.ibtinterface.util.LFIBTUtil;
import com.lfusa.wc.jdeinterface.dataextractor.LFDataExtractor;
import com.lfusa.wc.sapinterface.util.LFSAPUtil;
import com.lfusa.wc.sapinterface.util.LFSapConstants;
import com.lcs.wc.moa.LCSMOAObjectQuery;
import com.lcs.wc.db.SearchResults;
import com.lcs.wc.moa.LCSMOAObject;
import com.lfusa.wc.ibtinterface.castor.LFIBTCastorXMLGenHelper;

/**
 * This class contains logic to create new revisable entity objects for sap
 * integration This class will be called everytime the user creates data in the
 * staging page.
 * 
 * @author If everything works then this file is written by Ashrujit else I do
 *         not know who has written this.
 * 
 */
public class LFIBTRBOLogic {

private static String CLASSNAME ="LFIBTRBOLogic:";

	/**
	 * dateformat is used to append the time stamp against the master and the
	 * other revisable entity objects.
	 */
	private final DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	/**
	 * This is the request object that contains all the values from the staging
	 * page. This is passed into the class from the controller so that this
	 * class can have access to all the form elements from the staging page.
	 */
	private Map<String, String> requesttable;

	/**
	 * season version Id is the id that is used to fetch the master revisable
	 * entity
	 */
	private String seasonVersionId = "";

	/**
	 * season object
	 */
	private LCSSeason season = null;

	/**
	 * divisionKey
	 */
	private String divisionKey = "lfDivision";

	/**
	 * nrfColorCodeKey
	 */
	private String nrfColorCodeKey = "lfNrfColorCode";

	/**
	 * This is the master revisable entity object that will be initialized based
	 * upon the season object. This object will be unique for any revisable
	 * entity that is created in this season.
	 */
	private LCSRevisableEntity masterRevEntity = null;

	/**
	 * name of the table.
	 */
	private final String revisableEntityTable = "LCSREVISABLEENTITY";

	/**
	 * This constructor is responsible for creating master revisable entity
	 * which is unique for a particular season.
	 * 
	 * @param table
	 *            .
	 * @throws WTException.
	 */

	public LFIBTRBOLogic(Map<String, String> table) throws WTException {

		// fetch and store the table.
		this.requesttable = table;

		// get the oid from the request table.
		if (FormatHelper.hasContent(this.requesttable.get("oid"))) {
			// set the season to the global variable
			this.season = (LCSSeason) LCSQuery.findObjectById(this.requesttable
					.get("oid"));
			// set the seasonVersionId global variable
			if (season != null) {
				this.seasonVersionId = FormatHelper
						.getNumericVersionIdFromObject(this.season);
			}
		}
		this.masterRevEntity = this.getSAPMaterialMasterForSeason();
		if (this.masterRevEntity == null) {
			LCSLog.debug("masterRevEntity NOT FOUND. Creating masterRevEntity");
			this.masterRevEntity = createMasterRevisableEntity();

		}
	}

	/**
	 * 
	 * This method fetches the selected Ids from the hashmap and calls the
	 * custom method to create or update entries in the revisable entity.
	 */
	public ArrayList<LCSRevisableEntity> prepareToCreateEntries(String strActivity) 
	{
		LCSLog.debug(CLASSNAME+"prepareToCreateEntries(),:"+"ACTIVITY:" +strActivity);
       ArrayList<LCSRevisableEntity> listOfRev=new ArrayList<LCSRevisableEntity>();
       LCSRevisableEntity entries=null;
		
       String selectedcolors = this.requesttable.get("selectedcolors");
	LCSLog.debug(CLASSNAME+"prepareToCreateEntries *************1**************");
		try {
			if (FormatHelper.hasContent(selectedcolors)) {
			LCSLog.debug("prepareToCreateEntries *************2**************");
				Collection stagingItems = MOAHelper
						.getMOACollection(selectedcolors);
			LCSLog.debug(CLASSNAME+"prepareToCreateEntries *************3**************");
				LCSLog.debug(CLASSNAME+"stagingItems.size() -- " + stagingItems.size());
				Iterator checkboxListIter = stagingItems.iterator();
				while (checkboxListIter.hasNext()) 
				{
					
					String id = (String) checkboxListIter.next();
					LCSLog.debug(CLASSNAME+"prepareToCreateEntries"+"Calling createEntries()");
					entries=createEntries(id);
					
					LCSLog.debug(CLASSNAME+"ENTRIES::--->" +entries);
					listOfRev.add(entries);
				   LCSLog.debug(CLASSNAME+"It is sucesess of the creat revesiable entity" +listOfRev.size());	
				}
				LCSLog.debug("prepareToCreateEntries *************4**************");
				LCSRevisableEntityClientModel masterModel = new LCSRevisableEntityClientModel();
				LCSLog.debug("prepareToCreateEntries *************5**************");
				masterModel.load(FormatHelper.getObjectId(this.masterRevEntity));
						LCSLog.debug("prepareToCreateEntries *************6**************");
				masterModel.setValue(LFIBTConstants.IBTMASTERUPDATECHECK,
						Boolean.TRUE);
			//Added for 7.6//
				if(strActivity.equalsIgnoreCase("COSTSHEET")){
					masterModel.setValue(LFIBTConstants.IBTACTIVITYSTATUS,
						"COSTSHEET");
				}else{
					masterModel.setValue(LFIBTConstants.IBTACTIVITYSTATUS,
						"PERSIST");
				}				
				//Added for 7.6//
						LCSLog.debug(CLASSNAME+"prepareToCreateEntries *************7**************");
				masterModel.save();

			}
			
		}
		catch (WTException exp) 
		{
			LCSLog.error("WTException occurred!! " + exp.getMessage());

		}
		catch (WTPropertyVetoException exp) {
			LCSLog.error("WTPropertyVetoException occurred!!");

		}
		return listOfRev;

	}

	/**
	 * This is the core method responsible for creating and updating revisable
	 * entities This method is called on persist action from the staging page
	 * This method is called for each and every selected ID in the staging
	 * page.The selected ids will be of 2 types a)Those which are populated from
	 * the revisable entity The formula for selected Id is
	 * 
	 * productversion_productsizedefinitionversion_colorwayversion_revisableentityversion
	 * b)Those which are fresh entries and are not coming from revisable entity
	 * The formula for selected Id is
	 * productversion_productsizedefinitionversion_colorwayversion
	 * 
	 * The attributes in the revisable entities are set for the first time or
	 * are updated if they are being submitted again
	 * 
	 * @param Id
	 *            String
	 */

	private LCSRevisableEntity createEntries(String selectedId) {
		
		LCSRevisableEntity revEntity=null;

		LCSProduct product = null;
		LCSSKU lcsSku = null;
		String sizedefVR = "";
		String prodVR = "";
		String colorwayVR = "";
		String reventityVR = "";
		
		LCSLog.debug("****************Inside createEntries ***********************");
		/*
		 * is found in the request object.
		 */
		// get division code from request.
		String divcode = this.requesttable.get(selectedId + "_DIVISION_CODE");
		// get material number from request
		String materialNumber = divcode
				+ this.requesttable.get(selectedId + "_MATERIALNUMBER");
		// get nrf code from request
		String nrfCode = "";
		// this.requesttable.get(selectedId + "_NRF_CODE");
		// get sourceVersion from request
		String sourceVersion = this.requesttable.get(selectedId + "_SOURCE");
		// get costsheetVersion from request
		String costsheetVersion = this.requesttable.get(selectedId + "_COST");
		
		String specVersion = this.requesttable.get(selectedId + "_SPEC");
		
		String bomRequestParam = this.requesttable.get("BOM"+selectedId + "_BOM");
		LCSLog.debug("bomRequestParam = "+bomRequestParam);

		String sourceName = "";
		String costName = "";
		String specName = "";
		String IBTINSTOREMONTH = "";

		try {
			// get all the information from sourceVersion and costsheetVersion
			Map<String, String> map = LFIBTUtil.formatSourceOrCostsheetData(
					sourceVersion, costsheetVersion, specVersion);
			
			// source name
			sourceName = map.get("sourceNameKey");
			// versionId
			sourceVersion = map.get("sourceVersionKey"); 
			LCSLog.debug("sourceName --- " + sourceName);
			// costsheet name
			costName = map.get("costNameKey");

			// costsheetId
			costsheetVersion = map.get("costsheetVersionKey");
			LCSLog.debug("costName --- " + costName);
			
			specName = map.get("specNameKey");

			// costsheetId
			specVersion = map.get("specVersionKey");
			LCSLog.debug("costName --- " + costName);			

			Collection<String> bomMOAStringColl = new ArrayList<String>();
			bomMOAStringColl = LFIBTUtil.formatBOMMultiChoiceValues(bomRequestParam);
			
			List<String> idList = LFIBTUtil.getObjects(selectedId);

			// parse and get all data
			Map<String, String> idMap = LFIBTUtil
					.createCustomMapFromList(idList);
			// get product ID
			prodVR = idMap.get("prodVR");

			LCSLog.debug("prodVR : --" + prodVR);
			// get the product object from productVR
			product = (LCSProduct) LCSProductQuery
					.findObjectById("VR:com.lcs.wc.product.LCSProduct:"
							+ prodVR);

			LCSLog.debug("product : --" + product);

			// size definition VR
			sizedefVR = idMap.get("sizedefVR");
			LCSLog.debug("sizedefVR -- " + sizedefVR);

			// colorway VR
			colorwayVR = idMap.get("colorwayVR");
			LCSLog.debug("colorwayVR : --" + colorwayVR);
			lcsSku = (LCSSKU) LCSProductQuery
					.findObjectById("VR:com.lcs.wc.product.LCSSKU:"
							+ colorwayVR);

			// NRF Code -- Build 5.16
			Double d = 0.00;
			d = (Double) lcsSku.getValue("lfNrfColorCode");
			nrfCode = StringUtils.substringBeforeLast(Double.toString(d), ".");

			/**
			 * Build 5.16_3 -> START
			 * Formatting NRF code to 3 digits before sending it to SAP
			 */
			// getting length of code value
			int nrfCodeValueLength = nrfCode.length();
			// TRUE - if length is 1 or 2 digit
			if (nrfCodeValueLength == 2 || nrfCodeValueLength == 1) {
				// converting the value from double to integer
				int y = d.intValue();
				// formatting the value to be 3 digit always.
				// if not, append 0 to left
				nrfCode = (String.format("%03d", y)).toString();
			}
			/**
			 * Build 5.16_3 -> END
			 */

			// get the revisable entity VR if applicable
			reventityVR = idMap.get("reventityVR");

			// Added for Build 6.14
			// ITC-START
			String materialDescription = this.requesttable.get(selectedId
					+ "_MATERIALDESC");
			IBTINSTOREMONTH = this.requesttable.get(selectedId + "_INSTOREMONTH");
			String styleNumber = this.requesttable.get(selectedId + "_STYLE");
			// ITC-END
			
			//MM : changes : Start ----
			if(!FormatHelper.hasContent(reventityVR))
				reventityVR = LFIBTMaterialNumberValidator.getExistingMaterialRecords(materialNumber,false);
			//MM : changes : End ----
			/*
			 * If the revisable entity VR exists then update the revisable
			 * entity else create a new one.
			 */
			if (reventityVR != null) 
			{
				LCSLog.debug("sourceVersion -- " + sourceVersion
						+ "  costsheetVersion  - " + costsheetVersion
						+ "  nrfCode -- " + nrfCode
						+ "  materialDescription --" + materialDescription
						+ " IBTINSTOREMONTH--" + IBTINSTOREMONTH
						+ " style Number----" + styleNumber);

				// API call to update the revisable entitity with new
				// source and cost details.

				// Updated for Build 6.14
				LCSLog.debug(CLASSNAME+"createEntries()"+"calling updateRevisableEntry()");
				revEntity=updateRevisableEntry(reventityVR, sourceVersion,
						costsheetVersion,specVersion, nrfCode, materialDescription,
						sourceName, costName,specName, IBTINSTOREMONTH, styleNumber,bomMOAStringColl);
				
				LCSLog.debug(CLASSNAME+"update revEntity---->" +revEntity);
			}
			else {
				// API call to create fresh revisable entities.

				// Updated for Build 6.14
				
				LCSLog.debug(CLASSNAME+"createEntries()"+"calling createRevisableEntry()");
				revEntity=createRevisableEntry(product, lcsSku, materialNumber,
						sizedefVR, sourceVersion, costsheetVersion, specVersion, sourceName,
						costName, specName, nrfCode, styleNumber, materialDescription,
						IBTINSTOREMONTH,bomMOAStringColl);
				
				LCSLog.debug(CLASSNAME+"create revEntity---->" +revEntity);

			}
			

		}
		catch (WTException e) {
			LCSLog.error("WTException occurred!!  " + e.getMessage());
		}
		catch (WTPropertyVetoException e) {
			LCSLog.error("WTPropertyVetoException occurred!! " + e.getMessage());
		}
				
		return revEntity;

	}

	/**
	 * This method is responsible for create revisable entities for the values
	 * entered in the staging area
	 * 
	 * @param product
	 * @param lcsSKu
	 * @param materialNumber
	 * @param prodVR
	 * @param sizedefVR
	 * @param sourceVersion
	 * @param costsheetVersion
	 * @param sourceName
	 * @param costName
	 * @param nrfCode
	 * @param styleNumber
	 * @param materialDescription
	 * @param IBTINSTOREMONTH
	 * 
	 * @throws WTException
	 * @throws WTPropertyVetoException
	 */
	private LCSRevisableEntity createRevisableEntry(LCSProduct product, LCSSKU lcsSKu,
			String materialNumber, String sizedefVR, String sourceVersion,
			String costsheetVersion, String specVersion, String sourceName, String costName,
			String specName, String nrfCode, String styleNumber, String materialDescription,
			String IBTINSTOREMONTH,Collection bomMOAStringColl) throws WTException , WTPropertyVetoException {
		
		LCSRevisableEntityLogic revisableEntityLogic = new LCSRevisableEntityLogic();
		
		LCSRevisableEntity createRevEntity=null;

		LCSLog.debug(CLASSNAME+"createRevisableEntry(), this is a fresh entry");
		
		FlexType IBTFlexType = FlexTypeCache
		.getFlexTypeFromPath(LFIBTConstants.ibtMaterialPath);
		
		LCSRevisableEntity ibtMaterialRevObj = LCSRevisableEntity.newLCSRevisableEntity();;
		String revId = "";
		// Create Blank Revisable Entity Object for the productId
		
		
		//revModel.load(FormatHelper.getObjectId(this.getRevObj()));
		// create a new model in order to create a new revisable entity.
		//LCSRevisableEntityClientModel ibtRevEntityModel = new LCSRevisableEntityClientModel();
		//ibtRevEntityModel.set
		//ibtRevEntityModel.load(FormatHelper.getObjectId(rev));
		// set the flextype to ibtRevEntityModel sub type
		ibtMaterialRevObj.setFlexType(IBTFlexType);
		//System.out.println("****************Inside setFlexType ***********************");
		//ibtMaterialRevObj.setRevisableEntityName(FormatHelper.format(materialNumber
			//	+ dateFormat.format(Calendar.getInstance().getTime())));
		// set the product att in revisable entity child type
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTPRODUCT, product);

		//PLM-170 Adding product ID change
		String prodId = String.valueOf(((Double)product.getProductARevId()).intValue());
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTPRODUCTID, prodId);
		//PLM-170 Adding product ID change

		//System.out.println("****************Inside product ***********************"+product);

		// setting the divison att for sap material. 
		// This will drive the ACL functionality.
		String division = (String) season.getValue(divisionKey);
		LCSLog.debug("division  -- " + division);
		// setting division att in ibtRevEntityModel
		ibtMaterialRevObj.setValue("lfDivision", division);

		// set the colorway att in revisable entity child type
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTCOLORWAY, lcsSKu);

		// set the size definition version Id
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTMASTERGRID, sizedefVR);
		// set the sourcing-config version
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTSOURCINGCONFIG, sourceVersion);
		// set the cost-sheet version
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTCOSTSHEET, costsheetVersion);
		
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTSPECIFICATION, specVersion);
		ibtMaterialRevObj.setValue(LFIBTConstants.STAGINSPECNAME, specName);
		// set the source name that is used in the staging area
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTSTAGINGSOURCENAME, sourceName);
		// set the cost-sheet name to that is entered in staging area
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTSTAGINGCOSTSHEETNAME, costName);
		//Added for 7.6
		if (FormatHelper.hasContent(LFIBTConstants.IBTMATERIALSTATUS)) {
			ibtMaterialRevObj.setValue(LFIBTConstants.IBTMATERIALSTATUS,
				"Create");
		}
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTCOSTSHEETSTATUS,"Sent");
		
		//Added for 7.6
	 	//Create BOM MOA Rows..
		//LFIBTUtil.setBOMMOARows(ibtRevEntityModel, "lfIBTBOMDetails", bomMOAStringColl,"create");
		// set the NRF code.
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTNRFCODE, nrfCode);
		// set style number
		// Build 6.14
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTSTYLENUMBER, styleNumber);
		// set material description
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTMATERIALDESC,
				materialDescription);

		// set In strore Month
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTINSTOREMONTH, IBTINSTOREMONTH);
		// set SAP material number
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTMATERIALNUMBER, materialNumber);
		// set the season att
		ibtMaterialRevObj.setValue(LFIBTConstants.IBTMASTERSEASON, this.season);

		// set the boolean value to checked. This check is needed for the
		// plugin to pick up the revisable entity
		//ibtRevEntityModel.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		// set the master object
		ibtMaterialRevObj.setValue("lfIBTMaster", this.masterRevEntity);
		
	//	System.out.println("****************Inside 11111111 ***********************");

		
		
		LCSRevisableEntity ibtMaterialRev = (LCSRevisableEntity)revisableEntityLogic.saveRevisableEntity(ibtMaterialRevObj);
		
		// masterModel.save();
		
		//createRevEntity=ibtRevEntityModel.getBusinessObject();
		//LCSLog.debug("slave created : --  " + ibtMaterialRevObj);
		
		LCSLog.debug(CLASSNAME+"createRevisableEntry(),Calling setBOMMOARows()");
		LFIBTUtil.setBOMMOARows(ibtMaterialRev, "lfIBTBOMDetails", bomMOAStringColl, "create");
		LCSLog.debug(CLASSNAME+"createRevisableEntry(),slave created : --  " + ibtMaterialRev);
        return ibtMaterialRev;
	}

	/**
	 * This method is used to update the revisable enitity
	 * 
	 * @param reventityVR
	 * @param sourceVersion
	 * @param costsheetVersion
	 * @param nrfCode
	 * @param materialDescription
	 * @param source
	 * @param costsheet
	 * @param styleNumber
	 * @throws WTException
	 * @throws WTPropertyVetoException
	 */
	private LCSRevisableEntity updateRevisableEntry(String reventityVR, String sourceVersion,
			String costsheetVersion,String specVersion,  String nrfCode,
			String materialDescription, String source, String costsheet,
			String specName, String IBTINSTOREMONTH, String styleNumber,Collection bomMOAStringColl) throws WTException ,
			WTPropertyVetoException 
			{
				LCSLog.debug(CLASSNAME+"updateRevisableEntry(), this is a Existing entry");
	
		LCSRevisableEntity existingIBTMaterialRevObj = null;
		LCSRevisableEntityLogic revisableEntityLogic = new LCSRevisableEntityLogic();

		LCSLog.debug(CLASSNAME+"updateRevisableEntry -- >existing Revisable entity Id is found");
		LCSLog.debug(CLASSNAME+"updateRevisableEntry(),,reventityVR -- " + reventityVR);

		// get the existing revisable entity object
		existingIBTMaterialRevObj = (LCSRevisableEntity) LCSQuery
				.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:"
						+ reventityVR);
		// create a new client model object and load the revisable entity
		//LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		//existingentryModel.load(FormatHelper.getObjectId(existingentry));
		//LCSLog.debug("existingentry : --" + existingentry.getValue("name"));
		// set the value of sourcing config version ID
		existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTSOURCINGCONFIG,
				sourceVersion);
		// set the value of costsheet version
		if (FormatHelper.hasContent(costsheetVersion)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTCOSTSHEET,
				costsheetVersion);
		}
		//added for 7.6
		
		/*if(strActivity.equalsIgnoreCase("PERSIST")){
		existingentryModel.setValue("lfIBTComments",
				"PERSIST");	
		}else{
		existingentryModel.setValue("lfIBTComments",
				"COSTSHEET");	*/
		//if (FormatHelper.hasContent(LFIBTConstants.IBTMATERIALSTATUS)) {
		//existingentryModel.setValue(LFIBTConstants.IBTMATERIALSTATUS,
		//		"Update");
		//}
		//}
		//added for 7.6
	 	//Create BOM MOA Rows..
		//LFIBTUtil.setBOMMOARows(existingentryModel, "lfIBTBOMDetails", bomMOAStringColl, "update");
		
		existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTSPECIFICATION, specVersion);
		existingIBTMaterialRevObj.setValue(LFIBTConstants.STAGINSPECNAME, specName);		
		// set the value of nrf code att
		if (FormatHelper.hasContent(nrfCode)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTNRFCODE, nrfCode);
		}

		// update the material description
		if (FormatHelper.hasContent(materialDescription)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTMATERIALDESC,
					materialDescription);
		}
		// update the source name
		if (FormatHelper.hasContent(source)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTSTAGINGSOURCENAME,
					source);
		}
		// update the costsheet name
		if (FormatHelper.hasContent(costsheet)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTSTAGINGCOSTSHEETNAME,
					costsheet);
		}
		// Update the In store Month
		if (FormatHelper.hasContent(IBTINSTOREMONTH)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTINSTOREMONTH,
					IBTINSTOREMONTH);
		}

		// Update Style Number
		if (FormatHelper.hasContent(styleNumber)) {
			existingIBTMaterialRevObj.setValue(LFIBTConstants.IBTSTYLENUMBER,
					styleNumber);
		}

		// update the check box
		//existingentryModel
		//		.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		
		LCSRevisableEntity ibtMaterialRev = (LCSRevisableEntity)revisableEntityLogic.saveRevisableEntity(existingIBTMaterialRevObj);
		
		LCSLog.debug(CLASSNAME+"updateRevisableEntry(), Calling setBOMMOARows()");
		
	
		LFIBTUtil.setBOMMOARows(ibtMaterialRev, "lfIBTBOMDetails", bomMOAStringColl, "update");
        return ibtMaterialRev;
	}

	/**
	 * 
	 * This method returns the master revisable entity
	 * 
	 * @return returns the corresponding master revisable entity object of the
	 *         season
	 * @throws WTException
	 */
	private LCSRevisableEntity getSAPMaterialMasterForSeason()
			throws WTException {
		
		LCSLog.debug(CLASSNAME+"getSAPMaterialMasterForSeason, calling");
		LCSRevisableEntity master = null;
		// get the flextype for sap master
		FlexType sapmastertype = FlexTypeCache
				.getFlexTypeFromPath(LFIBTConstants.ibtMasterPath);
		String flextypeIdmaster = sapmastertype.getTypeIdPath();
		// get season key from sap master
		FlexTypeAttribute sapmasterseasonAtt = sapmastertype
				.getAttribute(LFIBTConstants.IBT_MASTER_SEASON_KEY);
		// get att value for season
		String seasonVarName = sapmasterseasonAtt.getVariableName();
		// initialize pps
		PreparedQueryStatement preparedquerystatement = new PreparedQueryStatement();
		// add table name criteria
		preparedquerystatement.appendFromTable(revisableEntityTable);
		// select the column for the which the query has to be formulated.
		// Branch Id in this case.
		preparedquerystatement.appendSelectColumn(revisableEntityTable,
				"BRANCHIDITERATIONINFO");
		preparedquerystatement.appendAndIfNeeded();
		// add the latest iteration criteria
		preparedquerystatement.appendCriteria(new Criteria(
				revisableEntityTable, "LATESTITERATIONINFO", "1", "="));
		// add the criteria for flextypeidpath
		preparedquerystatement.appendAndIfNeeded();
		// add the criteria for selection. we want the objects for which
		// flextypeidpath matches
		// with that of the flextypeIdmaster
		preparedquerystatement.appendCriteria(new Criteria(
				revisableEntityTable, "FLEXTYPEIDPATH", flextypeIdmaster,
				Criteria.EQUALS));
		preparedquerystatement.appendAndIfNeeded();
		// add the criteria for selection. we want the objects for which the
		// season version ID
		// matches with the current season version id
		preparedquerystatement.appendCriteria(new Criteria(
				revisableEntityTable, seasonVarName, seasonVersionId,
				Criteria.EQUALS));
		Collection<FlexObject> results = LCSQuery.runDirectQuery(
				preparedquerystatement).getResults();

		LCSLog.debug(" Query results: --  " + results);

		FlexObject revMaster = null;
		if (results.size() == 1) {
			Iterator<FlexObject> iter = results.iterator();
			revMaster = iter.next();
			master = (LCSRevisableEntity) LCSQuery
					.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:"
							+ revMaster
									.getString("LCSREVISABLEENTITY.BRANCHIDITERATIONINFO"));

		}
		else if (results.size() > 1) {

			throw new WTException(
					"ERROR OCCURRED!!!More than one revisable entities containing same season reference is not allowed");
		}

		return master;

	}
	
	public void splitRevObject(Set revCostId,String colonDelimitedString,int revSize)
	{
		LCSLog.debug(CLASSNAME+"splitRevObject() Calling");
		try
	    	  {
		Iterator iterator = revCostId.iterator(); 
		
		HashMap<String,String> map=new HashMap<String,String>();		
		int i=0;
		 while (iterator.hasNext()){   
		 String strRevId=(String)iterator.next();
		System.out.println("Value: "+strRevId + " "); 
		LCSRevisableEntity revObje=(LCSRevisableEntity)LCSQuery.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:" + strRevId);
		System.out.println("revObje: "+revObje);
		String sizeDefinition=(String)revObje.getValue("lfIBTSizeCategoryToSeason");
		String styleNumber=(String)revObje.getValue("lfIBTStyleNumber");
		LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		existingentryModel.load(FormatHelper.getObjectId(revObje));
		LCSLog.debug("existingentry in splitRevObject: --" + revObje.getValue("name"));
	//	existingentryModel.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		
		if( map.size()>0 && (map.containsKey(styleNumber)))
		{
		  i++;
			 map.put(styleNumber, sizeDefinition);
			 System.out.println("It is coming to map size > zero******"+styleNumber+"*******map is****"+map);
			 existingentryModel.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
			 existingentryModel.save();
			 //LFGenerateXML.dataExtractor(revObje,colonDelimitedString,null);
		}
			
		if(map.size()>0 && (!(map.containsKey(styleNumber)))){
		i++;
			map.put(styleNumber, sizeDefinition);
			System.out.println("It is coming to map size > zero and style not equals********"+styleNumber+"*******map is****"+map);
			existingentryModel
			.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
			existingentryModel.save();
			
		}
		
		if(map.size()==0) {
		i++;
			
			 System.out.println("else part of statement" + styleNumber);
			 map.put(styleNumber, sizeDefinition);
			 existingentryModel
				.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
				existingentryModel.save();
			 //sizemap.put(sizeDefinition, styleNumber);
			// LFGenerateXML.dataExtractor(revObje,colonDelimitedString);
		}
		
			if(revSize==i){
				LCSLog.debug(CLASSNAME+"splitRevObject(), Calling dataExtractor() below....");
				LFGenerateXML.dataExtractor(revObje,colonDelimitedString,null);
			}
		
		
		System.out.println("map details of statement******" + map);
		
		// create a new client model object and load the revisable entity
		/*LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		existingentryModel.load(FormatHelper.getObjectId(revObje));
		LCSLog.debug("existingentry in splitRevObject: --" + revObje.getValue("name"));
		existingentryModel
		.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		existingentryModel.save();*/
	//LFGenerateXML.dataExtractor(revObje,colonDelimitedString);
		}
		}
		catch(WTException wt)
	    	  {
	    		  wt.printStackTrace();
	    	  }
	    	 catch(WTPropertyVetoException wt1)
	    	 {
	    		 wt1.printStackTrace();
	    	 }
      
		
	}
	public void genCostsheetXmlRevObject(Set revCostId,HashMap cmMap,int revSize)
	{
		LCSLog.debug(CLASSNAME+"genCostsheetXmlRevObject(), of rbologic java"+revCostId+"****cmMap*****"+cmMap+"******rev size****"+revSize);
		try
	    	  {
		Iterator iterator = revCostId.iterator(); 
		
		HashMap<String,String> map=new HashMap<String,String>();
		//HashMap<String,String> sizemap=new HashMap<String,String>();
		
		int i=0;
		 while (iterator.hasNext()){  
		 String strRevId=(String)iterator.next();
		System.out.println("Value: "+strRevId + " "); 
		//String colonDelimitedString= (String)cmMap.get(strRevId);
		//System.out.println("costsheet ids from map is : "+colonDelimitedString + " ");
		LCSRevisableEntity revObje=(LCSRevisableEntity)LCSQuery.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:" + strRevId);
		System.out.println("revObje: "+revObje);
		String sizeDefinition=(String)revObje.getValue("lfIBTSizeCategoryToSeason");
		String styleNumber=(String)revObje.getValue("lfIBTStyleNumber");
		
		LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		existingentryModel.load(FormatHelper.getObjectId(revObje));
		LCSLog.debug(CLASSNAME+"existingentry in splitRevObject: --" + revObje.getValue("name"));
		//existingentryModel
		//.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		//existingentryModel.save();
		
		// For Two Style's One XML
		if( map.size()>0 && (map.containsKey(styleNumber)))
		{
		  i++;
			 map.put(styleNumber, sizeDefinition);
			 System.out.println("It is coming to map size > zero******"+styleNumber+"*******map is****"+map);
			 existingentryModel
				.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
				existingentryModel.save();
			// LFGenerateXML.dataExtractor(revObje,"",cmMap);
		}
			
		if(map.size()>0 && (!(map.containsKey(styleNumber)))){
		i++;
			map.put(styleNumber, sizeDefinition);
			System.out.println("It is coming to map size > zero and style not equals********"+styleNumber+"*******map is****"+map);
			 existingentryModel.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
			 existingentryModel.save();
			 
			
		}
		
		if(map.size()==0) {
			i++;
			 System.out.println("else part of statement" + styleNumber);
			 map.put(styleNumber, sizeDefinition);
			existingentryModel.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
				existingentryModel.save(); 
		}
		
		if(revSize==i)
		{
				LCSLog.debug(CLASSNAME+"genCostsheetXmlRevObject(),Calling  dataExtractor below....");
				LFGenerateXML.dataExtractor(revObje,"",cmMap);
		}
		
		// create a new client model object and load the revisable entity
		/*LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		existingentryModel.load(FormatHelper.getObjectId(revObje));
		LCSLog.debug("existingentry in splitRevObject: --" + revObje.getValue("name"));
		existingentryModel
		.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		existingentryModel.save();*/
	//LFGenerateXML.dataExtractor(revObje,colonDelimitedString);
		}
		}
		catch(WTException wt)
	    	  {
	    		  wt.printStackTrace();
	    	  }
	    	 catch(WTPropertyVetoException wt1)
	    	 {
	    		 wt1.printStackTrace();
	    	 }
      
		
	}
	public void genXMLForRevObject(String revCostId,String colonDelimitedString)
	{
		LCSLog.debug(CLASSNAME+"genXMLForRevObject(),"+revCostId+"****colonDelimitedString*****"+colonDelimitedString);
		try
	    	  {
		//Iterator iterator = revCostId.iterator(); 
		
		// while (iterator.hasNext()){
		// String strRevId=(String)iterator.next();
		System.out.println("revisable entity is is ****Value: "+revCostId + " "); 
		LCSRevisableEntity revObje=(LCSRevisableEntity)LCSQuery.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:" + revCostId);
		LCSLog.debug(CLASSNAME+"revObje: "+revObje);
		// create a new client model object and load the revisable entity
		LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		existingentryModel.load(FormatHelper.getObjectId(revObje));
		LCSLog.debug(CLASSNAME+"genXMLForRevObject(),existingentry in splitRevObject: --" + revObje.getValue("name"));
	
		existingentryModel.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
		existingentryModel.save();
		
		LCSLog.debug(CLASSNAME+"genXMLForRevObject(),Calling  dataExtractor below....");
		LFGenerateXML.dataExtractor(revObje,colonDelimitedString,null);
		 //}
		}
		catch(WTException wt)
	    	  {
	    		  wt.printStackTrace();
	    	  }
	    	 catch(WTPropertyVetoException wt1)
	    	 {
	    		 wt1.printStackTrace();
	    	 }
      
		
	}
	public void setCostAndPlantToMOA(String strCostSheetId,String strCostSheetName,String strPlantValue,String strRevisableEntId)
	{
		LCSLog.debug(CLASSNAME+"setCostAndPlantToMOA(),strCostSheetId--"+strCostSheetId+"***strCostSheetName****"+strCostSheetName+"***strPlantValue***"+strPlantValue+"***allRevisableEntities****"+strRevisableEntId);
		
	    	 
	    	try
	    	  {
	    		
	    LCSRevisableEntity revObject123=null;
		LCSRevisableEntity revObje1=(LCSRevisableEntity)LCSQuery.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:" + strRevisableEntId);
		System.out.println("revObje1-rbo--" +revObje1);
		LCSMOATable moaObject=(LCSMOATable)revObje1.getValue("lfIBTCostsheetOutboundData");
		LCSRevisableEntityLogic existingentryLogic = new LCSRevisableEntityLogic();
		LCSRevisableEntity existingentryObj = (LCSRevisableEntity)LCSQuery.findObjectById(FormatHelper.getObjectId(revObje1));
		LCSLog.debug(CLASSNAME+"setCostAndPlantToMOA(),existingentryObj-rbo--" +existingentryObj);
		
		//System.out.println("before java castor file-rbo--" );
		//LFIBTCastorXMLGenHelper genhelper=new LFIBTCastorXMLGenHelper();
		//genhelper.setTest(strCostSheetName,strCostSheetId);
		//System.out.println("after java castor file-rbo--" );
		
		FlexType flextype = null;
		FlexTypeAttribute moaAttribute = null;
		FlexObject fo = null;
		LCSMOAObject moaObj = null;
		String costSheetOid = "";
		flextype = revObje1.getFlexType();
		moaAttribute = flextype.getAttribute("lfIBTCostsheetOutboundData"); 
		System.out.println("Att Display in rbo logic is********:" + moaAttribute.getAttDisplay());
		SearchResults moaresults = LCSMOAObjectQuery.findMOACollectionData(revObje1, moaAttribute);
		System.out.println("moaresults in rbo file is *********333*******"+moaresults.getResults().size());
		//String[] costSheetKey;
		boolean flag=false;
		if(moaresults != null && moaresults.getResults().size()>0){
		Iterator moaIter = moaresults.getResults().iterator();
		while(moaIter.hasNext()) {
				
				fo = (FlexObject)moaIter.next();
				moaObj = (LCSMOAObject) LCSQuery.findObjectById("OR:com.lcs.wc.moa.LCSMOAObject:" + fo.get("LCSMOAOBJECT.IDA2A2")); 
				System.out.println("MOA OBJECT: in rbo ***333***" + moaObj);
				
				if(moaObj != null) {
					
					System.out.println("MOA Value Found:333" + moaObj);
					
					costSheetOid = (String)moaObj.getValue("lfIBTCostSheet");
					System.out.println("CostSheet OID::rbo****333****" + costSheetOid);  //517752
					
					String plantName = (String)moaObj.getValue("lfIBTCostPlant");
					System.out.println("PLANT NAME::rbo****333*****" + plantName);   // Testplant
					//int i=0;
					if(costSheetOid!=null){
					if(costSheetOid.equalsIgnoreCase(strCostSheetId)){
					//System.out.println("u acnnot update mannnnn");
					//i++;
					flag=true;
					System.out.println("MOA Not updated---333-->"+flag);
					
					}
					}
					//costSheet = (LCSCostSheet)LCSCostSheetQuery.findObjectById("VR:com.lcs.wc.sourcing.LCSCostSheet:" + costSheetOid);
					//plantBean = new Plant();
					//plantBean.setPlant_code(plantName);
					
				//	plants.setPlant(addPlantOID);
				}
		}
		System.out.println("before flag method****333****-->"+flag);
		if(flag==false){
					System.out.println("Please carry on with update1133322211"+flag);
					HashMap<String,String> moaTable=new HashMap<String,String>();
					moaTable.put("lfIBTCostSheetName",strCostSheetName);
					moaTable.put("lfIBTCostPlant",strPlantValue);
					moaTable.put("lfIBTCostSheet",strCostSheetId); 
					moaTable.put("lfIBTCostStatus","Sent");
					moaObject.addRow(moaTable);
					existingentryObj.setValue("lfIBTCostsheetOutboundData",moaObject);
					existingentryObj.setValue(LFIBTConstants.IBTMATERIALSTATUS,"Update");
					existingentryObj.setValue(LFIBTConstants.IBTCOSTSHEETSTATUS,"Sent");
					//existingentryObj.setValue(LFIBTConstants.IBTTECHCOMMENT,costSheetSize);
					//LFIBTCastorXMLGenHelper genhelper=new LFIBTCastorXMLGenHelper();
					//genhelper.setTest(strCostSheetName,strCostSheetId);
					revObject123=existingentryLogic.saveRevisableEntity(existingentryObj);
					System.out.println("MOA updated---1111-->");
					}
		}else{
				System.out.println("Fresh entry for costsheet***222****");
					HashMap<String,String> moaTable=new HashMap<String,String>();
					moaTable.put("lfIBTCostSheetName",strCostSheetName);
					moaTable.put("lfIBTCostPlant",strPlantValue);
					moaTable.put("lfIBTCostSheet",strCostSheetId); 
					moaTable.put("lfIBTCostStatus","Sent");
					moaObject.addRow(moaTable);
					existingentryObj.setValue("lfIBTCostsheetOutboundData",moaObject);
					existingentryObj.setValue(LFIBTConstants.IBTMATERIALSTATUS,"Update");
					existingentryObj.setValue(LFIBTConstants.IBTCOSTSHEETSTATUS,"Sent");
					//existingentryObj.setValue(LFIBTConstants.IBTTECHCOMMENT,costSheetSize);
					//LFIBTCastorXMLGenHelper genhelper=new LFIBTCastorXMLGenHelper();
					//genhelper.setTest(strCostSheetName,strCostSheetId);
					revObject123=existingentryLogic.saveRevisableEntity(existingentryObj);
					System.out.println("MOA updated----->");
		
		}
		
		
		
		
		
		
		
		
	    	    
		//LCSCostSheet costsheet=(LCSCostSheet)LCSQuery.findObjectById("VR:com.lcs.wc.sourcing.LCSCostSheet:" + costObj);
		//System.out.println("costObj-rbo--" +costObj);
	    		/*LCSRevisableEntity revObject123=null;
	    	 
	    	    LCSRevisableEntity revObje=(LCSRevisableEntity)LCSQuery.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:" + rev123);
	    	    
	    	    System.out.println("revObje---" +revObje);
	    	    
	    	    LCSMOATable moaObject=(LCSMOATable)revObje.getValue("lfIBTCostsheetOutboundData");
	    	    
	    	    LCSRevisableEntityLogic existingentryLogic = new LCSRevisableEntityLogic();
	    	    
	    	    String ibtRevObj=(String)FormatHelper.getObjectId(revObje);
	    	    
	    	    LCSRevisableEntity existingentryObj = (LCSRevisableEntity)LCSQuery.findObjectById(FormatHelper.getObjectId(revObje));*/
	    	    
	    	    
	    	   /* LCSCostSheet costsheet=(LCSCostSheet)LCSQuery.findObjectById("VR:com.lcs.wc.sourcing.LCSCostSheet:" + costObj);
	    	    
	    	    String costsheetName=(String)costsheet.getName();
	    	    
	    	    LCSLifecycleManaged busineesObject=(LCSLifecycleManaged) costsheet.getValue("gbgplant");
	    	    
	    	    HashMap<String,String> moaTable=new HashMap<String,String>();
	    	    
	    	    moaTable.put("lfIBTCostSheetName",costsheetName);
	    	   
	    	    moaTable.put("lfIBTCostPlant",busineesObject.getName());
	    	    
	    	    moaTable.put("lfIBTCostSheet",costObj); 
				
				moaTable.put("lfIBTCostStatus","Sent");
	    	    
	    	    moaObject.addRow(moaTable);
	    	    
	    	    existingentryObj.setValue("lfIBTCostsheetOutboundData",moaObject);
	    	    //existingentryObj.setValue(LFIBTConstants.IBTUPDATECHECK, Boolean.TRUE);
				existingentryObj.setValue(LFIBTConstants.IBTMATERIALSTATUS,"Update");
				existingentryObj.setValue(LFIBTConstants.IBTCOSTSHEETSTATUS,"Sent");
	    	    revObject123=existingentryLogic.saveRevisableEntity(existingentryObj);
				
	    	    
	    	   com.lfusa.wc.ibtinterface.dataextractor.LFGenerateXML.dataExtractor(revObject123);*/
	    	    
	    	    
	    	    
	    	 }
	    	  catch(WTException wt)
	    	  {
	    		  wt.printStackTrace();
	    	  }
	    	 catch(WTPropertyVetoException wt1)
	    	 {
	    		 wt1.printStackTrace();
	    	 }
	    	 
	    	 
	    // }
	     
	     
	    
		 
	}
	

	/**
	 * 
	 * @return revisableentity object of the master.
	 */
	private LCSRevisableEntity createMasterRevisableEntity() {
		LCSLog.debug("****************Inside createMasterRevisableEntity ***********************");
		LCSLog.debug("createMasterRevisableEntity start!! ");
		String seasonName = "";
		String division = "";

		try {
			LCSLog.debug("createMasterRevisableEntity  *************1*************");
			// get season name and division if season is not null
			if (this.season != null) {
				seasonName = (String) season.getValue("seasonName");
				division = (String) season.getValue(divisionKey);

			}
			LCSLog.debug("seasonName !! " + seasonName);
			LCSLog.debug("division  -- " + division);
			// get the division from the season to set the division att
			// in the revisable entity object

			LCSRevisableEntityClientModel masterRevEntityModel = new LCSRevisableEntityClientModel();
			LCSLog.debug("masterRevEntityModel created!! ");

			masterRevEntityModel.setFlexType(FlexTypeCache
					.getFlexTypeFromPath(LFIBTConstants.ibtMasterPath));

			LCSLog.debug("setFlexType to ! " + LFIBTConstants.ibtMasterPath);
			masterRevEntityModel.setRevisableEntityName(FormatHelper
					.format(seasonName
							+ dateFormat.format(Calendar.getInstance()
									.getTime())));
			masterRevEntityModel.setValue("name", seasonName + " : "
					+ dateFormat.format(Calendar.getInstance().getTime()));
			LCSLog.debug("master name is set ! ");
			masterRevEntityModel.setValue("lfIBTMasterSeason", season);
			masterRevEntityModel.setValue("lfDivision", division);

			LCSLog.debug(" season master  is set ! going to save master");

			masterRevEntityModel.save();

			LCSLog.debug(" master is saved");
			masterRevEntity = masterRevEntityModel.getBusinessObject();
			LCSLog.debug("createMasterRevisableEntity master created!! ");

		}
		catch (WTException exp) {
			exp.printStackTrace();

		}
		catch (WTPropertyVetoException exp) {
			exp.printStackTrace();

		}
		return masterRevEntity;
	}

}
