package com.lfusa.wc.ibtinterface.util;

import com.lcs.wc.util.LCSProperties;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
/**
 * 
 * @author ITC INFOTECH
 * 
 */
public interface LFIBTConstants {

	/**  
	 * IBT Master update check.
	 */
	final String IBTMASTERUPDATECHECK = "lfIBTMasterUpdate";
	
	/**
	 * Master Type.
	 */
	final String MASTERTYPE = "IBT Material Master";
	
	/**
	 * IBT Material type.
	 */
	final String MATERIALTYPE = "Revisable Entity\\IBT Material Master\\IBT Material";

	/**
	 * IBT update check.
	 */
	final String IBTUPDATECHECK = "lfIBTUpdate";
	
	/**
	 * IBT master.
	 */
	final String IBTMASTER = "lfIBTMaster";
	
	/**
	 * Material path.
	 */
	final String ibtMaterialPath = "Revisable Entity\\IBT Material Master\\IBT Material";
	
	
	/**
	 * IBT Master season.
	 */
	final String IBTMASTERSEASON = "lfIBTMasterSeason";
	
	/**
	 * IBT Product.
	 */
	final String IBTPRODUCT = "lfIBTProduct";
	
	/**
	 * IBT Colorway.
	 */
	final String IBTCOLORWAY = "lfIBTColorway";
	
	/**
	 * IBT Sourcing Config.
	 */
	final String IBTSOURCINGCONFIG = "lfIBTSourcingConfig";
	

	/**
	 * IBT CostSheet.
	 */
	final String IBTCOSTSHEET = "lfIBTCostSheet";
	
	
	/**
	 * IBT Mat Status.
	 */
	final String IBTMATERIALSTATUS = "lfIBTMatStatus";
	/**
	 * IBT Cost Status.
	 */
	final String IBTCOSTSTATUS = "lfIBTCostStatus";
	
	/**
	 * Vendor Number.
	 */
	final String VENDORNUMBER = "lfVendorNumber";
	
	/**
	 * IBT NRF code.
	 */
	final String IBTNRFCODE = "lfIBTNrfCode";
	
	/**
	 * IBT style number.
	 */
	final String IBTSTYLENUMBER = "lfIBTStyleNumber";
	
	/**
	 * IBT Master grid.
	 */
	final String IBTMASTERGRID = "lfIBTSizeCategoryToSeason";
	
	/**
	 * IBT size def key.
	 */
	final String IBT_SIZEDEFINITION_KEY = LCSProperties.get(
			"com.lcs.wc.ibtinterface.ibtmaterial.ibtSeasonalSizeDef",
			"lfIBTSizeCategoryToSeason");
	
	/**
	 * IBT Inventoruy status
	 */
	final String IBTINVENTORYSTATUS = "lfRootInventoryStatus";
	
	
	/**
	 * Start : Get Revisable Entity Att IBT.
	 */
	final String IBT_REV_ENTITY_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.ibtDataExtractor.LFIBTExtractor.revisableEntAtt.direct");
	
	
	/**
	 * IBT Thumbnail Image Url.
	 */
	final String IBTTHUMBNAILURL = "lfThumbnailImageUrl";

	/**
	 * Take IBT XML keys for Color Section.
	 */
	final String COLOR_XML_KEY = LCSProperties
			.get("com.lfusa.wc.ibtinterface.xmlprocessor.LFIBTXMLGenerator.color");
	
	/**
	 * Take IBT XML keys for Hts Section.
	 */
	final String HTS_XML_KEY = LCSProperties
			.get("com.lfusa.wc.ibtinterface.xmlprocessor.LFIBTXMLGenerator.hts");

	/**
	 * Take IBT XML keys for Custom Description Section.
	 */
	final String CUSTOMSDESCRIPTION_XML_KEY = LCSProperties
			.get("com.lfusa.wc.ibtinterface.xmlprocessor.LFIBTXMLGenerator.customsDescription");
	
	/**
	 *	OPERATIONAL_DATA_XML_KEY
	 */
	
	final String OPERATIONAL_DATA_XML_KEY = LCSProperties
			.get("com.lfusa.wc.ibtinterface.xmlprocessor.LFIBTXMLGenerator.operationalData");
	
	
	/**
	 *	ORGANIZATIONAL_DATA_XML_KEY
	 */
	final String ORGANIZATIONAL_DATA_XML_KEY = LCSProperties
			.get("com.lfusa.wc.ibtinterface.xmlprocessor.LFIBTXMLGenerator.organizationData");
	
	
	/**
	 * Send to IBT
	 */
	final String LFSENDTOIBT = "lfRootSendToIBT";	
	
	
	/**
	 *	PACKAGING_TYPE_KEY.
	 */
	final String PACKAGING_TYPE_KEY = "lfRootPackagingType";
	
	/**
	 *	PLM_PRODUCT_NUMBER
	 */
	final String PLM_PRODUCT_NUMBER = "lfRootProductNum";
	
	
	/**
	 *	Royalty Code
	 */
	final String ROYALTY_CODE = "lfRCPropertyCode";
	
	
	
	/**
	 *	Royalty Code
	 */
	final String CUSTOMER = "lfRootProductCust";
	
	/**
	 *	NRF Code
	 */
	final String NRFCOLORCODE = "lfNRFColorCode";
	
	/*
	 * For Product Details Extraction !
	 */
	
	final String IBT_APPARAL_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.apparel.ibtDataExtractor.LFIBTExtractor.productAtt");
	
	final String IBT_ACCESSORIES_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.accessories.ibtDataExtractor.LFIBTExtractor.productAtt");

	final String IBT_HOME_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.home.ibtDataExtractor.LFIBTExtractor.productAtt");
	
	final String IBT_FOOTWEAR_PRODUCT_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.footwear.ibtDataExtractor.LFIBTExtractor.productAtt");
   
	
	/*
	 * For CostSheet Details Extraction !
	 */	
	final String IBT_APPAREL_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.apparel.ibtDataExtractor.LFIBTExtractor.costsheetAtt");
	
	final String IBT_ACCESSORIES_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.accessories.ibtDataExtractor.LFIBTExtractor.costsheetAtt");
	
	final String IBT_HOME_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.home.ibtDataExtractor.LFIBTExtractor.costsheetAtt");
	
	final String IBT_FOOTWEAR_COSTSHEET_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.footwear.ibtDataExtractor.LFIBTExtractor.costsheetAtt");

	
	
	
	
	
	
	
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
	 * SAP style number.
	 */
	final String SAPSTYLENUMBER = "lfSapStyleNumber";
	/**
	 * SAP NRF code.
	 */
	final String SAPNRFCODE = "lfSapNrfCode";
	
	/**
	 * SAP Master grid.
	 */
	final String MASTERGRID = "lfSizeCategory";
	/**
	 * SAP Division.
	 */
	final String SAPDIVISION = "lfSapDivision";
	
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
	// Used in Xml Consumption.
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

	/**
	 * Start : Get season Att.
	 */
	final String SEASON_ATT_KEY = LCSProperties
			.get("com.lfusa.wc.sapDataExtractor.LFSAPExtractor.seasonAtt");
	// End : season Att.

	
	/**
	 * Take XML keys for Attribute Section.
	 */
	final String ATTRIBUTES_XML_KEY = LCSProperties
			.get("com.lfusa.wc.sapinterface.xmlprocessor.LFSapXMLGenerator.attributes");
	
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
	 * Master season key.
	 */
	final String IBT_MASTER_SEASON_KEY = LCSProperties.get(
			"com.lcs.wc.sapinterface.sapmaster.seasonmasterKey",
			"lfIBTMasterSeason");
	// Att Keys for Revisable Entity.
	
	
	/**
	 * Staging source name.
	 */
	final String IBTSTAGINGSOURCENAME = "lfIBTStagingSourceName";
	/**
	 * staging cost sheet name.
	 */
	final String IBTSTAGINGCOSTSHEETNAME = "lfIBTCostSheetName";
	
	/**
	 * SAP Material number.
	 */
	final String IBTMATERIALNUMBER = "lfIBTMaterialNumber";
	
	/**
	 * SAP mat desc.
	 */
	final String IBTMATERIALDESC = "lfIBTMaterialDesc";
	/**
	 * In store Month
	 */
	final String IBTINSTOREMONTH = "lfIBTInStoreMonth";
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
	 * Build 6.8
	 * Set Sent To ERP on Cost Sheet as True when Data to SAP.
	 * SENTTOERP.
	 */
	final String SENTTOIBT = LCSProperties.get(
			"com.lcs.wc.ibtinterface.costsheet.sentToIBTKey", "lfSentToIBT");
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
	 *	SUB-PROFIT CENTER KEY
	 */
	final String SUBPROFIT_CENTRE_KEY = "lfRootSubProfitCenter";
	/**
	 *	PROFIT CENTER KEY
	 */
	final String PROFIT_CENTRE_KEY = "lfRootProfitCenter";
	
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
	 * Color Name
	 */
	final String SKUCOLOR = "color";
	/**
	 * IBT Color Image Url.
	 */
	final String IBTColorURL = "lfColorImageUrl";
	/**
	 * IBT Color Image Url.
	 */
	final String IBTColorHexPath = "lfColorHexValue";
		/**
	 * IBT Color Image Url.
	 */
	final String IBTPLMCOSTSHEET = "lfPlmCostSheet";
			/**
	 * IBT Color Image Url.
	 */
	final String IBTXMLMAPPING = "lfXMLMapping";
				/**
	 * IBT Color Image Url.
	 */
	final String IBTINBCOSTSHEET = "lfIbtCostSheet"; 
	/**
	 * IBT Color Image Url.
	 */
	final String IBTBOMSTATUS = "lfIBTBomStatus"; 
	
	final String BOM_DETAILS_MOA_KEY = "lfIBTBOMDetails"; 

	final String COST_SHEET_DETAILS_MOA_KEY = "lfIBTCostsheetOutboundData";
	
	/**
	 * IBT Incoterms Url.
	 */
	final String IBTINCOTERM = "lfIncoTerms"; 
	/**
	 * IBT Standard cost Url.
	 */
	final String IBTSTDCOST = "lfStandardCost";
		/**
	 * IBT MOQ  Url.
	 */
	final String IBTMOQ = "lfMOQ";  
			/**
	 * IBT vendorPriceEffFrom  Url.
	 */
	final String IBTPRICEEFFECTFROM = "vendorPriceEffFrom";
	/**
	 * IBT vendorPriceEffTo  Url.
	 */
	final String IBTPRICEEFFECTTO = "vendorPriceEffTo";
	/**
	 * IBT lfGrossPriceItem  Url.
	 */
	final String IBTGROSSFOB = "lfGrossPriceItem";
	/**
	 * IBT lfFirstCostItem  Url.
	 */
	final String IBTFIRSTCOST = "lfFirstCostItem";
		/**
	 * IBT lfHTSValue1Item  Url.
	 */
	final String IBTHTSVALUE1 = "lfHTSValue1Item";
	/**
	 * IBT lfHTSValue2Item  Url.
	 */
	final String IBTHTSVALUE2 = "lfHTSValue2Item";
	/**
	 * IBT lfHTSValue3Item  Url.
	 */
	final String IBTHTSVALUE3 = "lfHTSValue3Item";
	/**
	 * IBT lfHTSValue4Item  Url.
	 */
	final String IBTHTSVALUE4 = "lfHTSValue4Item";
	/**
	 * IBT lfHTSValue5Item  Url.
	 */
	final String IBTHTSVALUE5 = "lfHTSValue5Item";
	/**
	 * IBT lfHTSValue6Item  Url.
	 */
	final String IBTHTSVALUE6 = "lfHTSValue6Item";
	/**
	 * IBT lfAdditionalDutyItem  Url.
	 */
	final String IBTADDITIONDUTY = "lfAdditionalDutyItem";
	/**
	 * IBT lfFreightCostItem  Url.
	 */
	final String IBTFREIGTH = "lfFreightCostItem";
	/**
	 * IBT lfCommission  Url.
	 */
	final String IBTCOMMISSION = "lfCommission";
	/**
	 * IBT lfDrayageItem  Url.
	 */
	final String IBTDRAYAGE = "lfDrayageItem";
	/**
	 * IBT lfMiscCostItem  Url.
	 */
	final String IBTMISCCOST = "lfMiscCostItem";
	/**
	 * IBT lfMisc  Url.
	 */
	final String IBTMISC = "lfMisc";
	/**
	 * IBT lfOtherCostItem  Url.
	 */
	final String IBTOTHERCOST = "lfOtherCostItem";
	/**
	 * IBT lfRetailPriceUSorCA  Url.
	 */
	final String IBTMSRP = "lfRetailPriceUSorCA";
	/**
	 * IBT lfSalesPriceUSorCA  Url.
	 */
	final String IBTSELLPRICE = "lfSalesPriceUSorCA";
	/**
	 * IBT lfHTSDuty1  Url.
	 */
	final String IBTHTSDUTY1 = "lfHTSDuty1";
	/**
	 * IBT lfHTSDuty2  Url.
	 */
	final String IBTHTSDUTY2 = "lfHTSDuty2";
	/**
	 * IBT lfHTSDuty3  Url.
	 */
	final String IBTHTSDUTY3 = "lfHTSDuty3";
	/**
	 * IBT lfHTSDuty4  Url.
	 */
	final String IBTHTSDUTY4 = "lfHTSDuty4";
	/**
	 * IBT lfHTSDuty5  Url.
	 */
	final String IBTHTSDUTY5 = "lfHTSDuty5";
	/**
	 * IBT lfHTSDuty6  Url.
	 */
	final String IBTHTSDUTY6 = "lfHTSDuty6";
	/**
	 * IBT lfCustomsDescription1  Url.
	 */
	final String IBTCUSTDESC1 = "lfCustomsDescription1";
	/**
	 * IBT lfCustomsDescription2  Url.
	 */
	final String IBTCUSTDESC2 = "lfCustomsDescription2";
	/**
	 * IBT lfCustomsDescription3  Url.
	 */
	final String IBTCUSTDESC3 = "lfCustomsDescription3";
	/**
	 * IBT lfCustomsDescription4  Url.
	 */
	final String IBTCUSTDESC4 = "lfCustomsDescription4";
	/**
	 * IBT lfCustomsDescription5  Url.
	 */
	final String IBTCUSTDESC5 = "lfCustomsDescription5";
	/**
	 * IBT lfCustomsDescription6  Url.
	 */
	final String IBTCUSTDESC6 = "lfCustomsDescription6";
		/**
	 * IBT lfCustomsDescription6  Url.
	 */
	final String IBTTECHCOMMENT = "lfIbttechstatus";
			/**
	 * FlexType Path.
	 */
	public final static String IBT_REVISABLE_ENTITY_FLEXTYPE_PATH = LCSProperties
			.get("com.lfusa.wc.ibt.LCSRevisableEntity.FlextypePath");
	/**
	 * staging spec name.
	 */
	final String IBTSPECIFICATION = "lfIBTSpecification";	
	
	/**
	 * Staging SPEC name.
	 */
	final String STAGINSPECNAME = "lfIBTStagingSpecName";
	
	
	
	/**for btech pack name
	 * IBT Techpack Name.
	 */
	final String IBTTECHPACKNAME = "lfTechpackName";
	/**for btech pack name
	 * IBT Techpack Name.
	 */
	final String IBTGROSSWEIGHT = "lfRootgrossweight";
	/**for btech pack name
	 * IBT Techpack Name.
	 */
	final String IBTTECHPACKID = "lfTechPackId";
	/**for btech pack name
	 * IBT IBTPRODSEASONID .
	 */
	final String IBTPRODSEASONID = "lfProdSeasonId";

	//Added for 7.6 IBT 
	final String IBTACTIVITYSTATUS = "lfActivityStatus";
	/**
	 * material status sent.
	 */
	final String status_create = "create";
	final String status_update = "update";
	/**for btech pack name
	 * IBT COSTSHEETSTATUS .
	 */
	final String IBTCOSTSHEETSTATUS = "lfIBTCostStatus";
	/**for btech pack name
	 * IBT COSTSHEETSTATUS .
	 */
	final String IBTCOSTPLANT = "lfIBTCostPlant";
	/**for btech pack name
	 * IBT COSTSHEETSTATUS .
	 */
	final String IBTCOSTSHEETNAME = "lfIBTCostSheetName";
	/**for btech pack name
	 * IBT COSTSHEETSTATUS .
	 */
	final String IBTCOSTSHEETID = "lfIBTCostSheet";
final String IBTSPECSTATUS = "lfIBTSpecStatus";

final String IBTCOMMENTS = "lfIBTComments";
	
	//List of cost sheet attributes to compare
	public final List<String> apparelCostSheetCompareAtts = new ArrayList<String>(Arrays.asList(
				IBTCUSTDESC1,IBTCUSTDESC2,IBTCUSTDESC3,IBTCUSTDESC4,IBTCUSTDESC5,IBTCUSTDESC6,
				IBTHTSDUTY1,IBTHTSDUTY2,IBTHTSDUTY3,IBTHTSDUTY4,IBTHTSDUTY5,IBTHTSDUTY6,
				IBTHTSVALUE1,IBTHTSVALUE2,IBTHTSVALUE3,IBTHTSVALUE4,IBTHTSVALUE5,IBTHTSVALUE6));

	public final List<String> homeCostSheetCompareAtts = new ArrayList<String>(Arrays.asList(
				IBTCUSTDESC1,IBTCUSTDESC2,IBTCUSTDESC3,IBTCUSTDESC4,IBTCUSTDESC5,IBTCUSTDESC6,
				IBTHTSDUTY1,IBTHTSDUTY2,IBTHTSDUTY3,IBTHTSDUTY4,IBTHTSDUTY5,IBTHTSDUTY6,
				IBTHTSVALUE1,IBTHTSVALUE2,IBTHTSVALUE3,IBTHTSVALUE4,IBTHTSVALUE5,IBTHTSVALUE6));

	public final List<String> accessoriesCostSheetCompareAtts = new ArrayList<String>(Arrays.asList(
				IBTCUSTDESC1,IBTCUSTDESC2,IBTCUSTDESC3,IBTCUSTDESC4,IBTCUSTDESC5,IBTCUSTDESC6,
				IBTHTSDUTY1,IBTHTSDUTY2,IBTHTSDUTY3,IBTHTSDUTY4,IBTHTSDUTY5,IBTHTSDUTY6));

	public final List<String> footwearCostSheetCompareAtts = new ArrayList<String>(Arrays.asList(
				IBTCUSTDESC1,IBTCUSTDESC2,IBTCUSTDESC3,IBTCUSTDESC4,IBTCUSTDESC5,IBTCUSTDESC6,
				IBTHTSDUTY1,IBTHTSDUTY2,IBTHTSDUTY3,IBTHTSDUTY4,IBTHTSDUTY5,IBTHTSDUTY6,
				IBTHTSVALUE1,IBTHTSVALUE2,IBTHTSVALUE3,IBTHTSVALUE4,IBTHTSVALUE5,IBTHTSVALUE6));

	/**
	 * IBT Product Id .
	 */
	final String IBTPRODUCTID = "gbgSeasonProdId";
}
