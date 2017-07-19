package com.lfusa.wc.sapinterface.util;

import com.lcs.wc.util.LCSProperties;

/**
 * 
 * @author ITC INFOTECH
 * 
 */
public interface LFSapConstants {

	/**
	 * Apparel Type.
	 */
	final String APPAREL = "Apparel";
	/**
	 * Home Type.
	 */
	final String HOME = "Home";
	/**
	 * Accessories Type.
	 */
	final String ACCESSORIES = "Accessories";
	/**
	 * supplierkey Type.
	 */
	public static final String supplierKey = "supplier";

	/**
	 * Master Type.
	 */
	final String MASTERTYPE = "SAP Material Master";
	/**
	 * SAP Material type.
	 */
	final String MATERIALTYPE = "Revisable Entity\\SAP Material Master\\SAP Material";

	// SCOPE.
	/**
	 * season Scope.
	 */
	final String SEASON_OBJ = "PRODUCT-SEASON";
	/**
	 * product scope.
	 */
	final String PRODUCT = "PRODUCT";
	/**
	 * product-season.
	 */
	final String PRODUCT_SEASON = "PRODUCT-SEASON";
	/**
	 * sourcing config scope.
	 */
	final String SOURCING_CONFIG_SCOPE = "SOURCING_CONFIG_SCOPE";
	/**
	 * source to season scope.
	 */
	final String SOURCE_TO_SEASON_SCOPE = "SOURCE_TO_SEASON_SCOPE";
	/**
	 * cost sheet scope.
	 */
	final String COST_SHEET = "COST_SHEET";

	// LEVELS.
	/**
	 * colorway level.
	 */
	final String SKU = "SKU";
	/**
	 * product-colorway level.
	 */
	final String PRODUCT_SKU = "PRODUCT-SKU";

	// Types of Attributes.
	/**
	 * object ref type.
	 */
	final String OBJ_REF = "object_ref";
	/**
	 * choice type.
	 */
	final String CHOICE = "choice";
	/**
	 * Driven type.
	 */
	final String DRIVEN = "driven";
	/**
	 * sequence type.
	 */
	final String SEQUENCE = "sequence";
	/**
	 * currency type.
	 */
	final String CURRENCY = "currency";

	// Att Keys for Revisable Entity.
	/**
	 * SAP Product.
	 */
	final String SAPPRODUCT = "lfSapProduct";
	/**
	 * SAP Colorway.
	 */
	final String SAPCOLORWAY = "lfSapColorway";
	/**
	 * SAP Sourcing Config.
	 */
	final String SAPSOURCINGCONFIG = "lfSapSourcingConfig";
	/**
	 * SAP CostSheet.
	 */
	final String SAPCOSTSHEET = "lfSapCostSheet";

	/**
	 * Staging source name.
	 */
	final String STAGINGSOURCENAME = "lfSapStagingSourceName";
	/**
	 * staging cost sheet name.
	 */
	final String STAGINGCOSTSHEETNAME = "lfSapCostSheetName";
	/**
	 * staging Specification name.
	 */
	final String IBTSPECIFICATION = "lfIBTSpecification";
	/**
	 * SAP style number.
	 */
	final String SAPSTYLENUMBER = "lfSapStyleNumber";
	/**
	 * SAP Material number.
	 */
	final String SAPMATERIALNUMBER = "lfSapMaterialNumber";
	/**
	 * SAP NRF code.
	 */
	final String SAPNRFCODE = "lfSapNrfCode";
	/**
	 * SAP Master grid.
	 */
	final String SAPMASTERGRID = "lfSAPSizeCategoryToSeason";
	/**
	 * SAP Master grid.
	 */
	final String MASTERGRID = "lfSizeCategory";
	/**
	 * SAP Division.
	 */
	final String SAPDIVISION = "lfSapDivision";
	/**
	 * SAP Mat Status.
	 */
	final String SAPMATERIALSTATUS = "lfSapMatStatus";
	/**
	 * SAP Cost Status.
	 */
	final String SAPCOSTSTATUS = "lfSapCostStatus";
	/**
	 * SAP Comments.
	 */
	final String SAPSTATUS = "lfStatus";
	/**
	 * SAP Comments.
	 */
	final String SAPCOMMENTS = "lfSapComments";
	/**
	 * SAP Size Values
	 */
	final String SAPSIZEVALUE = "lfSapSizeValue";

	/**
	 * SAP Type Identifier.
	 */
	final String TYPE_IDENTIFIER = "";
	/**
	 * SAP mat desc.
	 */
	final String SAPMATERIALDESC = "lfSapMaterialDesc";
	/**
	 * SAP Master season.
	 */
	final String SAPMASTERSEASON = "lfSapMasterSeason";


	/**
	 * sapInentory status
	 */
	final String SAPINVENTORYSTATUS = "lfRootInventoryStatus";

	/**
	 * SAP update check.
	 */
	final String SAPUPDATECHECK = "lfSapUpdate";
	/**
	 * SAP Master update check.
	 */
	final String SAPMASTERUPDATECHECK = "lfSapMasterUpdate";
	/**
	 * SAP master.
	 */
	final String SAPMASTER = "lfSapMaster";

	/**
	 * Attribute Keys which are used to put SAP Values into the Revisable
	 * Entity.
	 */
	/**
	 * Send to SAP
	 */
	final String LFSENDTOSAP = "lfRootSentToSap";	
	/**
	 * Map Property.
	 */
	final String LFRCPROPERTY = "lfRCProperty";
	/**
	 * Property Code.
	 */
	final String LFRCPROPERTYCODE = "lfRCPropertyCode";
	/**
	 * Vendor Number.
	 */
	final String VENDORNUMBER = "lfVendorNumber";
	/**
	 * Vendor - Changed from supplier to lfVendor as part of Build 4.28
	 * CostSheet changes.
	 */
	final String VENDOR = "lfVendor";
	/**
	 * Product Type.
	 */
	final String PRODTYPE = "productType";
	/**
	 * Hts Number.
	 */
	final String LFHTSNUMBER = "lfHTSNumber";
	/**
	 * Category number.
	 */
	final String LFCATEGORYNUMBER = "lfCategoryNumber";
	/**
	 * Category number.
	 */
	final String LFITEMDESCRIPTION = "lfItemDescription";
	/**
	 * Currency.
	 */
	final String LFCURRENCY = "lfCurrency";
	/**
	 * SeasonType.
	 */
	// PLM Attributes used for SAP derived attributes
	final String SEASONTYPE = "lfRootSeason";
	/**
	 * Season Year.
	 */
	final String YEAR = "lfRootSeasonYear";
	/**
	 * Product Category
	 */
	final String PRODUCTCATEGORY = "lfRootProductProdCat";
	/**
	 * Short Description.
	 */
	//final String SHORTDESCRIPTION = "lfRootProductSilhouette";
	/**
	 * SILHOUETTE
	 */
	final String SILHOUETTE = "lfRootProductSilhouette";
	/**
	 * Freight Accessories
	 */
	final String FREIGHTACC = "lfFreight";
	/**
	 * Freight Home
	 */
	final String FREIGHTHOM = "lfFreightCostItem";
	/**
	 * FCAFreight(Common)
	 */
	final String FCAFREIGHT = "lfFCAFreight";
	/**
	 * Freight Cost Derived
	 */
	final String FREIGHTCOST = "lfSapFreightDerived";
	/**
	 * Product Category to Season ID for MAP
	 */
	final String PRODCATTOSEASONID = "lfSapPSDID";
	/**
	 * Colorway Name
	 */
	final String SKUNAME = "skuName";
	/**
	 * USD.
	 */
	final String USD = "USD";
	/**
	 * USD.
	 */
	final String CAD = "CAD";
	/**
	 * Raw mat supplier.
	 */
	final String RAW_MATERIAL_SUPPLIER_TYPE = "Raw Material Suppliers";
	/**
	 * Agent.
	 */
	final String AGENT = "Agent";
	/**
	 * OID.
	 */
	final String OID = "oidkey";
	/**
	 * mat entry.
	 */
	final String MATERIALENTRY = "materialEntry";
	/**
	 * Cost entry.
	 */
	final String COSTSHEETENTRY = "costSheetEntry";
	/**
	 * Send To SAP
	 */
	final String SENDTOSAP = "lfSapSendToSAP";
	// Constants for DB Attribute Name.
	/**
	 * Branch Id.
	 */
	final String BRANCHID = "LCSREVISABLEENTITY.BRANCHIDITERATIONINFO";
	/**
	 * Object Id.
	 */
	final String OBJECTID = "LCSREVISABLEENTITY.IDA2A2";

	/**
	 * Delimiter used for tokenizing property Entries.
	 */
	final String DELIMS = "[,]";
	/**
	 * Delimeter type.
	 */
	final String TYPEDELIMS = "\\";
	/**
	 * Not Applicable
	 */
	final String NA = "N/A";
	final String STAGINSPECNAME = "lfIBTStagingSpecName";
	final String BOMSTATUS = "lfIBTBomStatus";
	final String SPECTATUS = "lfIBTSpecStatus";
	// Used in Xml Consumption.
	
	/**
	 * IBT Master update check.
	 */
	final String IBTMASTERUPDATECHECK = "lfIBTMasterUpdate";
	/**
	 * FlexType Path.
	 */
	public final static String REVISABLE_ENTITY_FLEXTYPE_PATH = LCSProperties
			.get("com.lfusa.wc.sap.LCSRevisableEntity.FlextypePath");
	/**
	 * DB Table Name.
	 */
	public final static String REVISABLE_ENTITY_DB_TABLENAME = LCSProperties
			.get("com.lfusa.wc.sap.LCSRevisableEntityDBTableName");
	/**
	 * BranchId Info.
	 */
	public static final String BRANCHID_ITERATION_INFO = LCSProperties
			.get("com.lfusa.wc.sap.LFSAPMaterialTab.RevisableEntityKeys.BRANCHIDITERATIONINFO");
	// End.

	/**
	 * Start : Get Revisable Entity Att.
	 */
	final String REV_ENTITY_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.sapDataExtractor.LFSAPExtractor.revisableEntAtt.direct");
	/**
	 * Start : Get Product Att.
	 * Take Att for APPAREL type.
	 */

	final String APPARAL_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.apparel.sapDataExtractor.LFSAPExtractor.productAtt");
	/**
	 * Take Att for ACCESSORIES type.
	 */
	final String ACCESSORIES_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.accessories.sapDataExtractor.LFSAPExtractor.productAtt");

	/**
	 * Take Att for HOME type.
	 */
	final String HOME_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.home.sapDataExtractor.LFSAPExtractor.productAtt");
	
	/**
	 * Take Att for FOOTWEAR type.
	 */
	final String FOOTWEAR_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.footwear.sapDataExtractor.LFSAPExtractor.productAtt");
	// End : Product Att.

	/**
	 * Start : Get season Att.
	 */
	final String SEASON_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.sapDataExtractor.LFSAPExtractor.seasonAtt");
	// End : season Att.

	/**
	 * Start : Get Cost Sheet Att.
	 * Take Att for APPAREL type.
	 */
	final String APPAREL_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.apparel.sapDataExtractor.LFSAPExtractor.costsheetAtt");
	/**
	 * Take Att for ACCESSORIES type.
	 */
	final String ACCESSORIES_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.accessories.sapDataExtractor.LFSAPExtractor.costsheetAtt");
	/**
	 * Take Att for HOME type.
	 */
	final String HOME_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.home.sapDataExtractor.LFSAPExtractor.costsheetAtt");
		
	/**
	* Take Att for FootWEAR type.
	 */
	final String FOOTWEAR_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.footwear.sapDataExtractor.LFSAPExtractor.costsheetAtt");
			
	
	// End : Cost Sheet Att.

	/**
	 * Take XML keys for Attribute Section.
	 */
	final String ATTRIBUTES_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.attributes");
	/**
	 * Take XML keys for Color Section.
	 */
	final String COLOR_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.color");
	/**
	 * Take XML keys for Hts Section.
	 */
	final String HTS_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.hts");
	/**
	 * Initialize Attribute,Condition and Prices Key.
	 * as the Key List is different.
	 */

	final String CONDITION_XML_KEY = "";
	/**
	 * PRICES_XML_KEY.
	 */
	final String PRICES_XML_KEY = "";
	/**
	 * condition label xml key.
	 */
	final String CONDITION_LABEL_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.conditionTypeLabel");
	/**
	 * Master season key.
	 */
	final String SAP_MASTER_SEASON_KEY = LCSProperties.get(
			"com.lcs.wc.sapinterface.sapmaster.seasonmasterKey",
			"lfSapMasterSeason");
	/**
	 * Product key.
	 */
	final String SAP_PRODUCT_KEY = LCSProperties.get(
			"com.lcs.wc.sapinterface.sapmaterial.productKey", "lfSapProduct");
	/**
	 * size def key.
	 */
	final String SAP_SIZEDEFINITION_KEY = LCSProperties.get(
			"com.lcs.wc.sapinterface.sapmaterial.sapSeasonalSizeDef",
			"lfSAPSizeCategoryToSeason");
	/*
	 * The keys for revisable entities go here.
	 */
	final String sapMasterPath = "Revisable Entity\\SAP Material Master";
	/**
	 * Material path.
	 */
	final String sapMaterialPath = "Revisable Entity\\SAP Material Master\\SAP Material";

	/*
	 * The keys for revisable entities go here.
	 */
	final String ibtMasterPath = "Revisable Entity\\IBT Material Master";
	/**
	 * Material path.
	 */
	final String ibtMaterialPath = "Revisable Entity\\IBT Material Master\\IBT Material";
	/**
	 * Master season key.
	 */
	final String IBT_MASTER_SEASON_KEY = LCSProperties.get(
			"com.lcs.wc.sapinterface.sapmaster.seasonmasterKey",
			"lfIBTMasterSeason");
	/**
	 * Product key.
	 */
	final String IBT_PRODUCT_KEY = LCSProperties.get(
			"com.lcs.wc.sapinterface.sapmaterial.productKey", "lfIBTProduct");
	// Att Keys for Revisable Entity.
	/**
	 * SAP Product.
	 */
	final String IBTPRODUCT = "lfIBTProduct";
	/**
	 * SAP Colorway.
	 */
	final String IBTCOLORWAY = "lfIBTColorway";
	/**
	 * SAP Sourcing Config.
	 */
	final String IBTSOURCINGCONFIG = "lfIBTSourcingConfig";
	/**
	 * SAP CostSheet.
	 */
	final String IBTCOSTSHEET = "lfIBTCostSheet";
	/**
	 * SAP Master grid.
	 */
	final String IBTMASTERGRID = "lfIBTSizeCategoryToSeason";
	/**
	 * Staging source name.
	 */
	final String IBTSTAGINGSOURCENAME = "lfIBTStagingSourceName";
	/**
	 * staging cost sheet name.
	 */
	final String IBTSTAGINGCOSTSHEETNAME = "lfIBTCostSheetName";
	/**
	 * SAP style number.
	 */
	final String IBTSTYLENUMBER = "lfIBTStyleNumber";
	/**
	 * SAP Material number.
	 */
	final String IBTMATERIALNUMBER = "lfIBTMaterialNumber";
	/**
	 * SAP NRF code.
	 */
	final String IBTNRFCODE = "lfIBTNrfCode";
	/**
	 * SAP mat desc.
	 */
	final String IBTMATERIALDESC = "lfIBTMaterialDesc";
	/**
	 * In store Month
	 */
	final String IBTINSTOREMONTH = "lfIBTInStoreMonth";
	/**
	 * SAP Master season.
	 */
	final String IBTMASTERSEASON = "lfIBTMasterSeason";
	/**
	 * SAP update check.
	 */
	final String IBTUPDATECHECK = "lfIBTUpdate";
	/**
	 * SAP master.
	 */
	final String IBTMASTER = "lfIBTMaster";
	/**
	 * SAP Mat Status.
	 */
	final String IBTMATERIALSTATUS = "lfIBTMatStatus";
	/**
	 * SAP Cost Status.
	 */
	final String IBTCOSTSTATUS = "lfIBTCostStatus";
	/**
	 * SAP Comments.
	 */
	final String IBTCOMMENTS = "lfIBTComments";
	//for xml consumption
	/**
	 * FlexType Path.
	 */
	public final static String IBT_REVISABLE_ENTITY_FLEXTYPE_PATH = LCSProperties
			.get("com.lfusa.wc.ibt.LCSRevisableEntity.FlextypePath");
	/**
	 * SAP Master update check.
	 */
	//final String SAPMASTERUPDATECHECK = "lfSapMasterUpdate";
	/* The various status attributes go here */
	/**
	 * material status sent.
	 */
	final String status_sent = "sent";
	/**
	 * material status received.
	 */
	final String status_received = "received";
	/**
	 * material status failed.
	 */
	final String status_failed = "failed";
	/**
	 * material status modified.
	 */
	final String status_modified = "modified";
	/**
	 * material status rejected.
	 */
	final String status_rejected = "rejected";
	/**
	 * material status completed.
	 */
	final String status_completed = "completed";
	/**
	 * material status deleted.
	 */
	final String status_deleted = "deleted";
	/**
	 * material status deleted.
	 */
	final String status_adopted = "adopted";
	/**
	 * NRF_CODE identifier.
	 */
	final String nrf_code_identifier = "_NRF_CODE";
	/**
	 * material_number_identifier.
	 */
	final String material_number_identifier = "_MATERIALNUMBER";
	/**
	 * failed status.
	 */
	final String failedStatus = "Failed";
	
	/**
	 * In store Month
	 */
	final String INSTOREMONTH = "lfSapInStoreMonth";

	/**
	*	Shipping  Instructions
	*/
	final String SHIPPINGINSTRUCTIONS ="lfShippingInstruction";
	
	/**
	 * SAP Thumbnail Image Url.
	 */
	final String SAPTHUMBNAILURL = "lfThumbnailImageUrl";

	/**
	 *	Build 6.2
	 *	Defining Custom Description attribute key from Cost Sheet Root level
	 *	Replace/Change itemdescription at HTS node with Custom Description from Cost Sheet
	 */
	final String CUSTOMSDESCRIPTION_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.customsDescription");
			
	/**
	 * Build 6.8
	 * Set Sent To ERP on Cost Sheet as True when Data to SAP.
	 * SENTTOERP.
	 */
	final String SENTTOERP = LCSProperties.get(
			"com.lcs.wc.sapinterface.costsheet.sentToERPKey", "lfSentToErp");
	/**
	 * Build 6.8
	 * PLM - ERP Data Release Tracking Requirement
	 * Update Product Disscusion & comments.
	 */		
	final String MOA_COMMENT="Style, Cost Sheet and other Style information sent to ERP";		
	
	//Added for Build 6.14
	/**
	 * style_number_identifier.
	 */
	final String style_number_identifier = "_STYLE";
	/**
	 * material_desc_identifier.
	 */
	final String material_desc_identifier = "_MATERIALDESC";

	/**
	 * instore_month_identifier.
	 */
	final String instore_month_identifier = "_INSTOREMONTH";
	
	//Added for Build 6.16 - added attributes Profit Center, Sub Profit Center, NMFC, Lead Test Required, Storage Location, Packaging Type.
	/**
	 *	PLANT_XML_KEY
	 */
	final String PLANT_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.plant");
	
	/**
	 *	OPERATIONAL_DATA_XML_KEY
	 */
	final String OPERATIONAL_DATA_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.operationalData");
	/**
	 *	ORGANIZATIONAL_DATA_XML_KEY
	 */
	final String ORGANIZATIONAL_DATA_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.organizationData");
	
	/**
	 *	SUB-PROFIT CENTER KEY
	 */
	final String SUBPROFIT_CENTRE_KEY = "lfRootSubProfitCenter";
	/**
	 *	PROFIT CENTER KEY
	 */
	final String PROFIT_CENTRE_KEY = "lfRootProfitCenter";
	/**
	 *	PACKAGING_TYPE_KEY.
	 */
	final String PACKAGING_TYPE_KEY = "lfRootPackagingType";
	/**
	 *	STORAGE_LOCATION_KEY.
	 */
	final String STORAGE_LOCATION_KEY = "lfRootStorageLocation";
	/**
	 *	NMFC_KEY.
	 */
	final String NMFC_KEY = "lfRootNMFC";
	
	/**
	 *	LEAD_TEST_REQD_KEY.
	 */
	final String LEAD_TEST_REQD_KEY = "lfRootLeadTestRequired";
	
	/**
	 *	BO_SUB_PROFIT_CENTRE_KEY.
	 */
	final String BO_SUB_PROFIT_CENTRE_KEY = "lfSubProfitCenter";
	
	/**
	 *	BO_STORAGE_LOCATION_KEY.
	 */
	final String BO_STORAGE_LOCATION_KEY = "lfSLoc";
	/**
	 *	BO_PROFIT_CENTRE_KEY.
	 */
	final String BO_PROFIT_CENTRE_KEY = "lfProfitCenter";
		/**
	 * Added for 7.4 build SAP ColorName.
	 */
	final String SAPCOLORNAME = "lfColorName";
	/**
	 * SAP Product Id .
	 */
	final String SAPPRODUCTID = "gbgSapSeasonProdId";
		
}
