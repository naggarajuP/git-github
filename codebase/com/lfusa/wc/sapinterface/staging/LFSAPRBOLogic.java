package com.lfusa.wc.sapinterface.staging;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;
import com.lcs.wc.db.Criteria;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.db.PreparedQueryStatement;
import com.lcs.wc.flextype.FlexType;
import com.lcs.wc.flextype.FlexTypeAttribute;
import com.lcs.wc.flextype.FlexTypeCache;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.foundation.LCSRevisableEntity;
import com.lcs.wc.foundation.LCSRevisableEntityClientModel;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.product.LCSProductQuery;
import com.lcs.wc.product.LCSSKU;
import com.lcs.wc.season.LCSSeason;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.MOAHelper;
import com.lfusa.wc.sapinterface.util.LFSAPUtil;
import com.lfusa.wc.sapinterface.util.LFSapConstants;

/**
 * This class contains logic to create new revisable entity objects for sap
 * integration This class will be called everytime the user creates data in the
 * staging page.
 * 
 * @author If everything works then this file is written by Ashrujit else I do
 *         not know who has written this.
 * 
 */
public class LFSAPRBOLogic {

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

	public LFSAPRBOLogic(Map<String, String> table) throws WTException {

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
	public void prepareToCreateEntries() {

		String selectedcolors = this.requesttable.get("selectedcolors");

		try {
			if (FormatHelper.hasContent(selectedcolors)) {

				Collection stagingItems = MOAHelper
						.getMOACollection(selectedcolors);
				LCSLog.debug("stagingItems.size() -- " + stagingItems.size());
				Iterator checkboxListIter = stagingItems.iterator();
				while (checkboxListIter.hasNext()) {
					String id = (String) checkboxListIter.next();
					createEntries(id);
				}

				LCSRevisableEntityClientModel masterModel = new LCSRevisableEntityClientModel();
				masterModel
						.load(FormatHelper.getObjectId(this.masterRevEntity));
				masterModel.setValue(LFSapConstants.SAPMASTERUPDATECHECK,
						Boolean.TRUE);
				masterModel.save();

			}
		}
		catch (WTException exp) {
			LCSLog.error("WTException occurred!! " + exp.getMessage());

		}
		catch (WTPropertyVetoException exp) {
			LCSLog.error("WTPropertyVetoException occurred!!");

		}

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

	private void createEntries(String selectedId) {

		LCSProduct product = null;
		LCSSKU lcsSku = null;
		String sizedefVR = "";
		String prodVR = "";
		String colorwayVR = "";
		String reventityVR = "";
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

		String sourceName = "";
		String costName = "";
		String instoremonth = "";
		
		//Added by manoj for 7.4 build
		String colorName = this.requesttable.get(selectedId + "_COLOR_NAME");
		System.out.println("colorName in rbo logic class is   **********"+colorName);

		try {
			// get all the information from sourceVersion and costsheetVersion
			Map<String, String> map = LFSAPUtil.formatSourceOrCostsheetData(
					sourceVersion, costsheetVersion);
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

			List<String> idList = LFSAPUtil.getObjects(selectedId);

			// parse and get all data
			Map<String, String> idMap = LFSAPUtil
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
			instoremonth = this.requesttable.get(selectedId + "_INSTOREMONTH");
			String styleNumber = this.requesttable.get(selectedId + "_STYLE");
			// ITC-END
			/*
			 * If the revisable entity VR exists then update the revisable
			 * entity else create a new one.
			 */
			if (reventityVR != null) {
				LCSLog.debug("sourceVersion -- " + sourceVersion
						+ "  costsheetVersion  - " + costsheetVersion
						+ "  nrfCode -- " + nrfCode
						+ "  materialDescription --" + materialDescription
						+ " instoremonth--" + instoremonth
						+ " style Number----" + styleNumber);

				// API call to update the revisable entitity with new
				// source and cost details.

				// Updated for Build 6.14
				updateRevisableEntry(reventityVR, sourceVersion,
						costsheetVersion, nrfCode, materialDescription,
						sourceName, costName, instoremonth, styleNumber,colorName);
			}
			else {
				// API call to create fresh revisable entities.

				// Updated for Build 6.14
				createRevisableEntry(product, lcsSku, materialNumber,
						sizedefVR, sourceVersion, costsheetVersion, sourceName,
						costName, nrfCode, styleNumber, materialDescription,
						instoremonth,colorName);

			}

		}
		catch (WTException e) {
			LCSLog.error("WTException occurred!!  " + e.getMessage());
		}
		catch (WTPropertyVetoException e) {
			LCSLog.error("WTPropertyVetoException occurred!! " + e.getMessage());
		}

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
	 * @param instoremonth
	 * 
	 * @throws WTException
	 * @throws WTPropertyVetoException
	 */
	private void createRevisableEntry(LCSProduct product, LCSSKU lcsSKu,
			String materialNumber, String sizedefVR, String sourceVersion,
			String costsheetVersion, String sourceName, String costName,
			String nrfCode, String styleNumber, String materialDescription,
			String instoremonth,String colorName) throws WTException , WTPropertyVetoException {
		//System.out.println("inside create method color name values is *******************"+colorName);
		LCSLog.debug("LFSAPRBOLOGIC -- this is a fresh entry");
		// create a new model in order to create a new revisable entity.
		LCSRevisableEntityClientModel sapmaterial = new LCSRevisableEntityClientModel();
		// set the flextype to sapmaterial sub type
		sapmaterial.setFlexType(FlexTypeCache
				.getFlexTypeFromPath(LFSapConstants.sapMaterialPath));
		sapmaterial.setRevisableEntityName(FormatHelper.format(materialNumber
				+ dateFormat.format(Calendar.getInstance().getTime())));
		// set the product att in revisable entity child type
		sapmaterial.setValue(LFSapConstants.SAPPRODUCT, product);

		//PLM-170 Adding product ID change
		String prodId = String.valueOf(((Double)product.getProductARevId()).intValue());
		sapmaterial.setValue(LFSapConstants.SAPPRODUCTID, prodId);
		//PLM-170 Adding product ID change

		// setting the divison att for sap material.
		// This will drive the ACL functionality.
		String division = (String) season.getValue(divisionKey);
		LCSLog.debug("division  -- " + division);
		// setting division att in sapmaterial
		sapmaterial.setValue("lfDivision", division);

		// set the colorway att in revisable entity child type
		sapmaterial.setValue(LFSapConstants.SAPCOLORWAY, lcsSKu);
		//added by manoj for 7.4 build
		// set the colorway name in revisable entity child type
		sapmaterial.setValue(LFSapConstants.SAPCOLORNAME, colorName);
		
		// set the size definition version Id
		sapmaterial.setValue(LFSapConstants.SAPMASTERGRID, sizedefVR);
		// set the sourcing-config version
		sapmaterial.setValue(LFSapConstants.SAPSOURCINGCONFIG, sourceVersion);
		// set the cost-sheet version
		sapmaterial.setValue(LFSapConstants.SAPCOSTSHEET, costsheetVersion);
		// set the source name that is used in the staging area
		sapmaterial.setValue(LFSapConstants.STAGINGSOURCENAME, sourceName);
		// set the cost-sheet name to that is entered in staging area
		sapmaterial.setValue(LFSapConstants.STAGINGCOSTSHEETNAME, costName);
		// set the NRF code.
		sapmaterial.setValue(LFSapConstants.SAPNRFCODE, nrfCode);

		// set style number
		// Build 6.14
		sapmaterial.setValue(LFSapConstants.SAPSTYLENUMBER, styleNumber);
		// set material description
		sapmaterial.setValue(LFSapConstants.SAPMATERIALDESC,
				materialDescription);

		// set In strore Month
		sapmaterial.setValue(LFSapConstants.INSTOREMONTH, instoremonth);
		// set SAP material number
		sapmaterial.setValue(LFSapConstants.SAPMATERIALNUMBER, materialNumber);
		// set the season att
		sapmaterial.setValue(LFSapConstants.SAPMASTERSEASON, this.season);

		// set the boolean value to checked. This check is needed for the
		// plugin to pick up the revisable entity
		sapmaterial.setValue(LFSapConstants.SAPUPDATECHECK, Boolean.TRUE);
		// set the master object
		sapmaterial.setValue("lfSAPMaster", this.masterRevEntity);

		sapmaterial.save();
		// masterModel.save();
		LCSLog.debug("slave created : --  " + sapmaterial.getBusinessObject());

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
	private void updateRevisableEntry(String reventityVR, String sourceVersion,
			String costsheetVersion, String nrfCode,
			String materialDescription, String source, String costsheet,
			String instoremonth, String styleNumber,String colorName) throws WTException ,
			WTPropertyVetoException {

		LCSRevisableEntity existingentry = null;

		LCSLog.debug("LFSAPRBOLOGIC -- updateRevisableEntry -- >existing Revisable entity Id is found");
		LCSLog.debug("reventityVR -- " + reventityVR);

		// get the existing revisable entity object
		existingentry = (LCSRevisableEntity) LCSQuery
				.findObjectById("VR:com.lcs.wc.foundation.LCSRevisableEntity:"
						+ reventityVR);
		// create a new client model object and load the revisable entity
		LCSRevisableEntityClientModel existingentryModel = new LCSRevisableEntityClientModel();
		// load
		existingentryModel.load(FormatHelper.getObjectId(existingentry));
		LCSLog.debug("existingentry : --" + existingentry.getValue("name"));
		// set the value of sourcing config version ID
		existingentryModel.setValue(LFSapConstants.SAPSOURCINGCONFIG,
				sourceVersion);
		// set the value of costsheet version
		existingentryModel.setValue(LFSapConstants.SAPCOSTSHEET,
				costsheetVersion);
				//added by manoj for 7.4 build
		// set the colorway name in revisable entity child type
		existingentryModel.setValue(LFSapConstants.SAPCOLORNAME, colorName);
		// set the value of nrf code att
		if (FormatHelper.hasContent(nrfCode)) {
			existingentryModel.setValue(LFSapConstants.SAPNRFCODE, nrfCode);
		}

		// update the material description
		if (FormatHelper.hasContent(materialDescription)) {
			existingentryModel.setValue(LFSapConstants.SAPMATERIALDESC,
					materialDescription);
		}
		// update the source name
		if (FormatHelper.hasContent(source)) {
			existingentryModel.setValue(LFSapConstants.STAGINGSOURCENAME,
					source);
		}
		// update the costsheet name
		if (FormatHelper.hasContent(costsheet)) {
			existingentryModel.setValue(LFSapConstants.STAGINGCOSTSHEETNAME,
					costsheet);
		}
		// Update the In store Month
		if (FormatHelper.hasContent(instoremonth)) {
			existingentryModel.setValue(LFSapConstants.INSTOREMONTH,
					instoremonth);
		}

		// Update Style Number
		if (FormatHelper.hasContent(styleNumber)) {
			existingentryModel.setValue(LFSapConstants.SAPSTYLENUMBER,
					styleNumber);
		}

		// update the check box
		existingentryModel
				.setValue(LFSapConstants.SAPUPDATECHECK, Boolean.TRUE);
		existingentryModel.save();
		LCSLog.debug("LFSAPRBOLOGIC -- updateRevisableEntry --> Revisable entity is persisted");

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
		LCSRevisableEntity master = null;
		// get the flextype for sap master
		FlexType sapmastertype = FlexTypeCache
				.getFlexTypeFromPath(LFSapConstants.sapMasterPath);
		String flextypeIdmaster = sapmastertype.getTypeIdPath();
		// get season key from sap master
		FlexTypeAttribute sapmasterseasonAtt = sapmastertype
				.getAttribute(LFSapConstants.SAP_MASTER_SEASON_KEY);
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

	/**
	 * 
	 * @return revisableentity object of the master.
	 */
	private LCSRevisableEntity createMasterRevisableEntity() {
		LCSLog.debug("createMasterRevisableEntity start!! ");
		String seasonName = "";
		String division = "";

		try {

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
					.getFlexTypeFromPath(LFSapConstants.sapMasterPath));

			LCSLog.debug("setFlexType to ! " + LFSapConstants.sapMasterPath);
			masterRevEntityModel.setRevisableEntityName(FormatHelper
					.format(seasonName
							+ dateFormat.format(Calendar.getInstance()
									.getTime())));
			masterRevEntityModel.setValue("name", seasonName + " : "
					+ dateFormat.format(Calendar.getInstance().getTime()));
			LCSLog.debug("master name is set ! ");
			masterRevEntityModel.setValue("lfSapMasterSeason", season);
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
