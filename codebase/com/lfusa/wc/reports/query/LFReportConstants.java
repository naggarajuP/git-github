/**
 * LFReportConstants.java
 * Apr 2, 2013
 * 
 */
package com.lfusa.wc.reports.query;

import com.lcs.wc.util.LCSProperties;

/**
 * @author 10845.
 * 
 *         Modified wrt to Build 5.10.
 * 
 */
public interface LFReportConstants {

	/**
	 * Constants for Table Generator
	 */

	// ///////////// List of CustomColumn Indexes ///////////////
	/**
	 * Applicable Attribute Key List.
	 */
	public static final String DELIMS = "[,]";
	/**
	 * String variable CUSTOM.ADOPTION.
	 */
	String CUSTOMADOPTION = "CUSTOM.ADOPTION";
	/**
	 * String variable CUSTOM.SAMPLEAVERAGE.
	 */
	String CUSTOMSAMPLEAVERAGE = "CUSTOM.SAMPLEAVERAGE";
	//Added GBG_Build_11 Footwear Custmizations START//
	/**
	 * String variable CUSTOM.SAMPLEPROTOAVERAGE.
	 */
	String CUSTOMSAMPLEPROTOAVERAGE = "CUSTOM.SAMPLEPROTOAVERAGE";
	/**
	 * String variable CUSTOM.SAMPLESALESAVERAGE.
	 */
	String CUSTOMSAMPLESALESAVERAGE = "CUSTOM.SAMPLESALESAVERAGE";
	
	//Added GBG_Build_11 Footwear Custmizations END//
	/**
	 * String variable CUSTOM.SAMPLEAVERAGE.
	 */
	String PRODUCTCOLUMN = "Product Developed";
	/**
	 * String variable CUSTOM.SAMPLEAVERAGE.
	 */
	String SAMPLEQTYCOLUMN = "Samples Created";
	/**
	 * String variable CUSTOM.SAMPLEAVERAGE.
	 */
	String ADOPTEDCOLUMN = "Product Adopted";

	// ///////////// List of Constants used ///////////////
	/**
	 * String variable COUNT.
	 */
	String COUNT = "count";
	/**
	 * String variable CALCULATE.
	 */
	String CALCULATE = "calculate";
	/**
	 * String variable CALCULATE.
	 */
	String ADDVALUE = "addvalue";
	/**
	 * String variable SUBMITTED.
	 */
	String SUBMITTEDINDEX = "CUSTOM.SUBMITTED";
	/**
	 * String variable APPROVED.
	 */
	String APPROVEDINDEX = "CUSTOM.APPROVED";
	/**
	 * String variable DROPPED.
	 */
	String DROPPEDINDEX = "CUSTOM.DROPPED";
	/**
	 * String variable REWORK.
	 */
	String REWORKINDEX = "CUSTOM.REWORK";

	// ///////////// List of keys Used in Request Map ///////////////
	/**
	 * String Variable SEARCH_DIVISION.
	 */
	String SEARCH_DIVISION = "DIVISION_KEY";
	/**
	 * String Variable SEARCH_SEASON_YEAR.
	 */
	String SEARCH_SEASON_YEAR = "SEASON_YEAR_KEY";
	/**
	 * String Variable SEARCH_SEASON_TYPE.
	 */
	String SEARCH_SEASON_TYPE = "SEASON_TYPE_KEY";
	/**
	 * String Variable SEARCH_GENDER_VALUE.
	 */
	String SEARCH_GENDER_VALUE = "GENDER_KEY";
	/**
	 * String Variable SEARCH_LICENSOR.
	 */
	String SEARCH_LICENSOR = "LICENSOR_KEY";
	/**
	 * String Variable SEARCH_PROPERTY.
	 */
	String SEARCH_PROPERTY = "PROPERTY_KEY";
	/**
	 * String Variable SEARCH_BRAND.
	 */
	String SEARCH_BRAND = "BRAND_KEY";
	/**
	 * String Variable SEARCH_CUSTOMER.
	 */
	String SEARCH_CUSTOMER = "CUSTOMER_RETAILER_KEY";
	/**
	 * String Variable SEARCH_PLANNED_ITEM_COUNT.
	 */
	String SEARCH_PLANNED_ITEM_COUNT = "PLANNED_ITEM_COUNT";
	/**
	 * String Variable SEARCH_SAMPLE_TYPE.
	 */
	String SEARCH_SAMPLE_TYPE = "SAMPLE_TYPE_KEY";
	/**
	 * String Variable SEARCH_SAMPLE_TYPE.
	 */
	String SEARCH_PRODUCT_CATEGORY = "PRODUCT_CATEGORY";
	/**
	 * String Variable SEARCH_PLACEHOLDER_STATUS.
	 */
	String SEARCH_PLACEHOLDER_STATUS = "SEARCH_PLACEHOLDER_STATUS_KEY";
	/**
	 * String Variable SEARCH_PRODUCT_STATUS.
	 */
	String SEARCH_PRODUCT_STATUS = "SEARCH_PRODUCT_STATUS_KEY";
	/**
	 * String Variable SEARCH_SIZE_GROUP.
	 */
	String SEARCH_SIZE_GROUP = "SEARCH_SIZE_GROUP_KEY";
	
	//Build 7.4 Bom Listing Report

	/**
	 * String Variable SEARCH_EVENT.
	 */
	String SEARCH_EVENT= "SEARCH_EVENT";
	
	/**
	 * String Variable SEARCH_FABRIC_CONCEPT.
	 */
	String SEARCH_FABRIC_CONCEPT = "SEARCH_FABRIC_CONCEPT_KEY";
	/**
	 * String Variable SEARCH_SEASON_LIST.
	 */
	String SEARCH_SEASON = "SEASON_LIST";
	/**
	 * String Variable SEARCH_MODULE_CHANGE.
	 */
	String SEARCH_MODULE_CHANGE = "MODULE_CHANGE_KEY";
	/**
	 * String Variable SEARCH_SEASON_DATA.
	 */
	String SEARCH_SEASON_DATA = "SEASON_DATA_KEY";
	/**
	 * String Variable SEARCH_READY_FOR_PRODUCTION.
	 */
	String SEARCH_READY_FOR_PRODUCTION = "READY_FOR_PRODUCTION_KEY";
	/**
	 * String Variable SEARCH_SHOW_CHANGES_SINCE.
	 */
	String SEARCH_SHOW_CHANGES_FROM = "SHOW_CHANGES_FROM_KEY";
	/**
	 * String Variable SEARCH_SHOW_CHANGES_SINCE.
	 */
	String SEARCH_SHOW_CHANGES_TO = "SHOW_CHANGES_TO_KEY";

	/**
	 * String Variable SEARCH_SHOW_CHANGES_SINCE.
	 */
	String SEARCH_PRODUCT_SUB_CATEGORY = "PRODUCT_SUB_CATEGORY";
	
	/**
	 * Build 6.15 - Added for Nominated Office for EZ Tracking
	 * String Variable SEARCH_NOMINATED_OFFICE.
	 */
	String SEARCH_NOMINATED_OFFICE = "SEARCH_NOMINATED_OFFICE_KEY";
	/**

	// ///////////// List of Flex Attribute keys Used ///////////////

	/**
	 * String Variable NAME_KEY.
	 */
	String NAME_KEY = "name";
	/**
	 * String Variable COLUMN_DIVISION.
	 */
	String DIVISION_KEY = "lfDivision";
	/**
	 * String Variable COLUMN_SEASON_YEAR.
	 */
	String SEASON_YEAR_KEY = "lfRootSeasonYear";
	/**
	 * String Variable COLUMN_SEASON_TYPE.
	 */
	String SEASON_TYPE_KEY = "lfRootSeason";

	/**
	 * String Variable SIZE_GROUP_KEY from BusinessOBject.
	 */
	String SIZE_GROUP_KEY = "lfRootGenSizeGrp";
	/**
	 * String Variable COLUMN_GENDER_VALUE.
	 */
	String SEASON_GENDER_VALUE_KEY = "lfRootGenSizeGrp";
	/**
	 * String Variable COLUMN_GENDER_VALUE.
	 */
	String PRODUCT_GENDER_VALUE_KEY = "lfRootProductGenSizeGrp";
	/**
	 * String Variable COLUMN_LICENSOR.
	 */
	String PRODUCT_LICENSOR_KEY = "lfRCLicensor";
	/**
	 * String Variable COLUMN_PROPERTY.
	 */
	String PRODUCT_PROPERTY_KEY = "lfRCProperty";
	/**
	 * String Variable COLUMN_BRAND.
	 */
	String PRODUCT_BRAND_KEY = "lfRootProductBrand";
	/**
	 * String Variable COLUMN_CUSTOMER.
	 */
	String PRODUCT_CUSTOMER_KEY = "lfRootProductCust";
	/**
	 * String Variable COLUMN_PLANNED_ITEM_COUNT.
	 */
	String PLAN_TO_DEVELOP_KEY = "lfRootPlanAppNoofStyles";
	/**
	 * String Variable PLAN_TO_SELL_KEY.
	 */
	String PLAN_TO_SELL_KEY = "lfPlannedItem";
	//Added for PLM-159 change
	/**
	 * String Variable COLUMN_SAMPLEQUANTITY_VALUE.
	 */
	String SAMPLEQUANTITY_KEY = "lfFloatSampleQuantity";
	/**
	 * String Variable old sample quantity value.
	 */
	String OLDSAMPLEQUANTITY_KEY = "lfSampleQuantity";
	//Added for PLM-159 change
	/**
	 * String Variable COLUMN_SAMPLETYPE_VALUE.
	 */
	String SAMPLETYPE_KEY = "sampleType";
	/**
	 * String Variable SEASON_NAME_KEY.
	 */
	String SEASON_NAME_KEY = "seasonName";
	/**
	 * String Variable SEASON_NAME_KEY.
	 */
	String PRODUCT_NAME_KEY = "productName";
	/**
	 * String Variable PRODUCT_CATEGORY_KEY.
	 */
	String PRODUCT_CATEGORY_KEY = "lfRootProductProdCat";
	/**
	 * String Variable PRODUCT_CATEGORY_KEY.
	 */
	String PRODUCT_CATEGORY_PH_KEY = "lfRootPlanProdCatPH";
	/**
	 * String Variable DESCRIPTION_KEY.
	 */
	String DESCRIPTION_KEY = "lfRootPlanDescPH";
	/**
	 * String Variable PLACEHOLDERSTATUSKEY.
	 */
	String PLACEHOLDER_STATUS_KEY = "placeholderStatus";
	/**
	 * String Variable PRODUCT_STATUS_KEY.
	 */
	String PRODUCT_STATUS_KEY = "lfRootProductStatus";
	/**
	 * String Variable FABRIC_CONCEPT_KEY.
	 */
	String FABRIC_CONCEPT_KEY = "lfRootProductFabrication";
	
	//Build 7.4 BOM Listing Report
	
	/**
	 * String Variable EVENT_KEY.
	 */
	String EVENT_KEY = "lfRootProductEvent";

	/**
	 * String Variable SAMPLE_OVERSEAS_KEY.
	 */
	String SOURCING_SOURCE_KEY = "lfOverseasOfficeSupplier";
	/**
	 * String Variable SAMPLE_OVERSEAS_KEY.
	 */
	String SAMPLE_SOURCE_KEY = "lfOverseasOffice";
	/**
	 * String Variable SAMPLE_OVERSEAS_KEY.
	 */
	String VENDOR_USER_KEY = "vendorGroup";

	/**
	 * String Variable SAMPLE_STATUS_KEY.
	 */
	String SAMPLE_STATUS_KEY = "sampleStatus";
	/**
	 * String Variable TOTAL_NO_OF_PROTOSAMPLE_KEY.
	 */
	String TOTAL_NO_OF_PROTOSAMPLE_KEY = "lfRootPlanAppNoofProto";
	
	//Added GBG_Build_11 Footwear Adoption Report changes START//
	
	/**
	 * String Variable TOTAL_NO_OF_PROTOSAMPLE_KEY.
	 */
	 String TOTAL_NO_OF_SALESSAMPLE_KEY = "gbgPlannedSalesmanSamples";
	 
	//END GBG_Build_11 Footwear Adoption Report changes START//
	
	/**
	 * String Variable PRODUCT_DISCUSSION_KEY.
	 */
	String PRODUCT_DISCUSSION_KEY = "lfProductDiscussion";
	/**
	 * String Variable PRODUCT_REFERENCE_NO_KEY.
	 */
	String PRODUCT_REFERENCE_NO_KEY = "lfRootProductSmartCode";
	/**
	 * String Variable IN_STORE_MONTH_KEY.
	 */
	String IN_STORE_MONTH_KEY = "lfRootProductInStoreMonth";
	
	/**
	 * String Variable PRODUCT_DISCUSSION_KEY.
	 */
	String READY_PRODUCTION_KEY = "lfRootAppStatus";
	/**
	 * String Variable PRODUCT_SUB_CATEGORY_KEY.
	 */
	String PRODUCT_SUB_CATEGORY_KEY = "lfRootProductProdSubCat";

	//Added for Nominated Office for EZ Tracking - Build 6.15
	/**
	 * String Variable NOMINATED_OFFICE_KEY
	 */
	String NOMINATED_OFFICE_KEY = LCSProperties.get("com.lcs.wc.reports.nominatedOffice");
	
	// ///////////// List of FlexType Hierarchy Used ///////////////
	/**
	 * String Variable SEASONAL_LINE_PLAN.
	 */
	String SEASONAL_LINE_PLAN = "Plan\\Seasonal Line Plan";
	/**
	 * String Variable SEASONAL_LINE_PLAN.
	 */
	String SEASONAL_LINE_PLAN_APPAREL = "Plan\\Seasonal Line Plan\\Apparel";
	//Added GBG Build Footwear 11 Adoptioin Report changes START 
	/**
	 * String Variable SEASONAL_LINE_PLAN.
	 */
	String SEASONAL_LINE_PLAN_FOOTWEAR = "Plan\\Seasonal Line Plan\\Footwear";
	//END GBG Build Footwear 11 Adoptioin Report changes END
	/**
	 * String Variable PRODUCT.
	 */
	String PRODUCT_APPAREL = "Product\\Apparel";
	/**
	 * String Variable PRODUCT.
	 */
	String PRODUCT = "Product";
	/**
	 * String Variable SEASON.
	 */
	String SEASON = "Season";
	/**
	 * String Variable SEASON HOME.
	 */
	String SEASON_HOME = "Season\\Home";
	/**
	 * String Variable SAMPLE.
	 */
	String SAMPLE = "Sample";
	/**
	 * String Variable SAMPLE.
	 */
	String SOURCINGCONFIG = "Sourcing Configuration";
	/**
	 * String Variable PROTOSAMPLE.
	 */
	String PROTOSAMPLE = "Proto or Development";
	//Added GBG Build 11 Footwear changes START
	
	/**
	 * String Variable PROTOSAMPLES.
	 */
	String PROTOSAMPLES = "Proto";
	
	/**
	 * String Variable PROTOSAMPLE.
	 */
	String SALEMANSSAMPLE = "Salesman";
	
	//END GBG Build 11 Footwear changes START
	/**
	 * String Variable BUSINESSTYPE.
	 */
	String BUSINESSTYPE = "Business Object\\Data Std Attribute List";
	/**
	 * String Variable BUSINESS_BRAND.
	 */
	String BUSINESS_BRAND = "Business Object\\Royalty Change\\Brand";
	
	/**
	 * String Variable BUSINESSTYPE.
	 */
	String OVERSEAS_OFFICE = "Revisable Entity\\Overseas office";

	// ///////////// List of LCS Flextype and DB Related Columns keys Used
	// ///////////////
	/**
	 * String variable ATT1.
	 */
	String ATT1 = "ATT1";
	/**
	 * String variable ATT1.
	 */
	String NUM1 = "NUM1";

	/**
	 * String variable ATT1.
	 */
	String DATE1 = "DATE1";

	/**
	 * String variable TYPENAME.
	 */
	String TYPENAME = "TYPENAME";
	/**
	 * String variable IDA2A2.
	 */
	String IDA2A2 = "IDA2A2";
	/**
	 * String variable FLEXTYPE.
	 */
	String FLEXTYPE = "FLEXTYPE";
	/**
	 * String variable PLAN_LINE_ITEM.
	 */
	String PLANLINEITEM = "PLANLINEITEM";
	/**
	 * String variable LCSSAMPLE.
	 */
	String LCSSAMPLE = "LCSSAMPLE";
	/**
	 * String Variable LCSSEASON.
	 */
	String LCSSEASON = "LCSSEASON";
	/**
	 * String Variable FLEXPLAN.
	 */
	String FLEXPLAN = "FLEXPLAN";
	/**
	 * String Variable LCSPRODUCT.
	 */
	String LCSPRODUCT = "LCSPRODUCT";
	/**
	 * String Variable PLACEHOLDER.
	 */
	String PLACEHOLDER = "PLACEHOLDER";
	/**
	 * String Variable LCSSAMPLEREQUEST.
	 */
	String LCSSAMPLEREQUEST = "LCSSAMPLEREQUEST";
	/**
	 * String variable LCSSEASONPRODUCTLINK.
	 */
	String LCSSEASONPRODUCTLINK = "LCSSEASONPRODUCTLINK";
	/**
	 * String variable LCSSOURCINGCONFIG.
	 */
	String LCSSOURCINGCONFIG = "LCSSOURCINGCONFIG";
	/**
	 * String variable LCSSEASONPRODUCTLINK.
	 */
	String LCSSOURCINGCONFIGMASTER = "LCSSOURCINGCONFIGMASTER";
	/**
	 * String variable PRODAREV.
	 */
	String PRODAREV = "PRODAREV";
	/**
	 * String variable PRODAREV.
	 */
	String PLANTOOWNERLINK = "PLANTOOWNERLINK";
	/**
	 * String variable IDA3MASTERREFERENCE.
	 */
	String IDA3MASTERREFERENCE = "IDA3MASTERREFERENCE";
	/**
	 * String variable LATESTITERATIONINFO.
	 */
	String LATESTITERATIONINFO = "LATESTITERATIONINFO";
	/**
	 * String variable VERSIONIDA2VERSIONINFO.
	 */
	String VERSIONIDA2VERSIONINFO = "VERSIONIDA2VERSIONINFO";
	/**
	 * String variable BRANCHIDITERATIONINFO.
	 */
	String BRANCHIDITERATIONINFO = "BRANCHIDITERATIONINFO";
	/**
	 * String variable LCSLIFECYCLEMANAGED.
	 */
	String LCSLIFECYCLEMANAGED = "LCSLIFECYCLEMANAGED";
	/**
	 * String variable LCSREVISABLEENTITY.
	 */
	String LCSREVISABLEENTITY = "LCSREVISABLEENTITY";
	/**
	 * String Variable SEASON_NAME.
	 */
	String SEASON_NAME = "LCSSEASON.ATT1";
	/**
	 * String Variable ADOPTED_STATE.
	 */
	String ADOPTED_STATE = "LCSSEASONPRODUCTLINK.ATT1";
	/**
	 * String Variable BO_IDA2A2.
	 */
	String BO_IDA2A2 = "LCSLIFECYCLEMANAGED.IDA2A2";

	/**
	 * String Variable ADOPTED.
	 */
	String ADOPTED = "Adopted";

	/**
	 * String Variable ADOPTED.
	 */
	String UNIQUEID = "UNIQUEID";
	/**
	 * String Variable LCSMOAOBJECT.
	 */
	String LCSMOAOBJECT = "LCSMOAOBJECT";
	/**
	 * String Variable FLEXTYPEATTRIBUTE.
	 */
	String FLEXTYPEATTRIBUTE = "FLEXTYPEATTRIBUTE";
	/**
	 * String Variable WTPARTMASTER.
	 */
	String WTPARTMASTER = "WTPARTMASTER";
	/**
	 * String Variable WTPARTMASTER.
	 */
	String WTUSER = "WTUSER";
	/**
	 * Product WTPARTREFERENCELINK.
	 */
	String WTPARTREFERENCELINK = "WTPARTREFERENCELINK";
	/**
	 * Product LCSDOCUMENT.
	 */
	String LCSDOCUMENT = "LCSDOCUMENT";
	/**
	 * Product IDA3A5.
	 */
	String IDA3A5 = "IDA3A5";
	/**
	 * Product IDA3B5.
	 */
	String IDA3B5 = "IDA3B5";

	/*
	 * GLOBAL CONSTANTS
	 */
	int QUERY_IN_LIMIT = 200;

	// ///////////// List of Comments for Report ///////////////
	/*
	 * GLOBAL CONSTANTS for Comments
	 */
	String COMMENTS = "- No Changes made";
	/*
	 * GLOBAL CONSTANTS for Comments By
	 */
	String COMMENTSBYLABEL = "- Commented By:";
	/*
	 * GLOBAL CONSTANTS for Comments By
	 */
	String DATELABEL = "- Date:";
	/*
	 * GLOBAL CONSTANTS for Comments By
	 */
	String COMMENTSLABEL = "- Comments:";

	// ///////////// List of Constants for Automated Report ///////////////
	/**
	 * String Variable STRSMTPHOST.
	 */
	String STRSMTPHOST = (String) LCSProperties
			.get("com.lfusa.wc.reports.generateExcel.strSMTPHost");
	/**
	 * String Variable STRFROM.
	 */
	String STRFROM = (String) LCSProperties
			.get("com.lfusa.wc.reports.generateExcel.strFrom");
	/**
	 * String Variable username.
	 */
	String username_excel = (String) LCSProperties.get("lfusa.admin.username");
	/**
	 * String Variable password.
	 */
	String password_excel = (String) LCSProperties.get("lfusa.admin.password");
	/**
	 * String Variable MAIL_SUBJECT.
	 */
	String MAIL_SUBJECT = (String) LCSProperties
			.get("com.lfusa.wc.reports.generateExcel.mailSubject");
	/**
	 * String Variable MAIL_BODY_CONTENT.
	 */
	String MAIL_BODY_CONTENT = (String) LCSProperties
			.get("com.lfusa.wc.reports.generateExcel.mailBodyContent");

	/**
	 * Target Point Build: 004.24 Request ID : <7>
	 * 
	 * Description : ProductAdoption Enhancement, Adding new Filter - Sample
	 * Type Also adding new column Sample Request Count.
	 * 
	 * @author Archana Saha Modified On: 11-June-2013
	 */

	// ITC- START
	/**
	 * String Variable SEASON_APP_PATH.
	 */
	String SEASON_APP_PATH = LCSProperties
			.get("com.lcs.wc.reports.seasonapppath");

	/**
	 * String Variable SEASON_ACC_PATH.
	 */
	String SEASON_ACC_PATH = LCSProperties
			.get("com.lcs.wc.reports.seasonaccpath");

	/**
	 * String Variable SEASON_HOME_PATH.
	 */
	String SEASON_HOME_PATH = LCSProperties
			.get("com.lcs.wc.reports.seasonhomepath");
	
	//Added GBG Build 11 Footwear Adoption Report changes START
	
	/**
	 * String Variable SEASON_APP_PATH.
	 */
	String SEASON_FOOTWEAR_PATH = LCSProperties
			.get("com.lcs.wc.reports.seasonfootwearpath");
	
	//Added GBG Build 11 Footwear Adoption Report changes END

	/**
	 * String Variable BO_LICENSOR_PATH.
	 */
	String BO_LICENSOR_PATH = LCSProperties
			.get("com.lcs.wc.reports.BOLicensorPath");
	/**
	 * String Variable BO_PROPERTY_PATH.
	 */
	String BO_PROPERTY_PATH = LCSProperties
			.get("com.lcs.wc.reports.BOPropertyPath");
	/**
	 * String Variable BO_CUSTOMER_PATH.
	 */
	String BO_CUSTOMER_PATH = LCSProperties
			.get("com.lcs.wc.reports.BOCustomerPath");
	/**
	 * String Variable BO_BRAND_PATH.
	 */
	String BO_BRAND_PATH = LCSProperties.get("com.lcs.wc.reports.BOBrandPath");
	String PRODUCT_PATH = LCSProperties
			.get("com.lcs.wc.reports.productTypePath");
	String PRODUCT_APP_PATH = LCSProperties
			.get("com.lcs.wc.reports.productappPath");
	String PRODUCT_ACC_PATH = LCSProperties
			.get("com.lcs.wc.reports.productaccPath");
	String PRODUCT_HOME_PATH = LCSProperties
			.get("com.lcs.wc.reports.producthomePath");

	String BO_PRODUCT_SUB_CATEGORY_PATH = "Business Object\\Data Std Attribute List";
	// ITC- END

	//
	// Constants Added for BOM Listing Report - Build 6.9
	//

	// ///////////// List of keys Used in Request Map ///////////////
	/**
	 * String Variable SEARCH_IN_STORE_DATE_FROM.
	 */
	String SEARCH_IN_STORE_DATE_FROM = "IN_STORE_DATE_FROM";

	/**
	 * String Variable SEARCH_IN_STORE_DATE_TO.
	 */
	String SEARCH_IN_STORE_DATE_TO = "IN_STORE_DATE_TO";

	String SEARCH_VENDOR = "VENDOR";
	// ///////////// List of Labels for Columns used in excel report
	// ///////////////
	//Build 6.13 "Style Number" LABEL changed to "Product #"
	String BOM_STYLE_NUMBER_LABEL = "Product #";
	String BOM_DESCRIPTION_LABEL = "Description";
	String BOM_COLORWAY_LABEL = "Colorway";
	String BOM_EVENT_LABEL = "Event";
	String BOM_FABRIC_CONCEPT_LABEL = "Fabric Concept";
	String BOM_VENDOR_LABEL = "Vendor";
	String BOM_IN_STORE_DATE_LABEL = "In Store Date";
	String BOM_COMPONENT_LOCATION_LABEL = "Component or Location";
	String BOM_PLACEMENT_LABEL = "Placement";
	String BOM_MATERIAL_REF_NO_LABEL = "Material Reference No.";
	String BOM_MATERIAL_LABEL = "Material";
	//Build 7.4 BOM Listing Report START
	String BOM_MATERIAL_PRICE_LABEL=" Material Price";
	String BOM_MATERIAL_PRICE_EFFECTIVE_DATE_LABEL="Material Price Effective Date";
	//Build 7.4 BOM Listing Report END
	
	String BOM_SUPPLIER_MATERIAL_REF_NO_LABEL = "Supplier Material Ref. No.";
	String BOM_DESIGNER_NAME_LABEL = "Designer Name";
	String BOM_QUANTITY_LABEL = "Quantity";
	String BOM_SUPPLIER_LABEL = "Supplier";
	String BOM_COLOR_LABEL = "Color";
	String BOM_PRODUCT_STATUS_LABEL = "Product Status";
	String BOM_SIZE_GROUP_LABEL = "Size Group";
	String BOM_BOM_NAME_LABEL = "BOM Name";
	String BOM_SPECIFICATION_LABEL = "Specification";
	String BOM_SEASON_NAME_LABEL = "Season Name";
	String BOM_PRODUCT_REFERENCE_NO_LABEL = "Product Reference #";
	String BOM_IN_STORE_MONTH_LABEL = "In Store Month";
	String BOM_SECTION_LABEL = "Section of BOM";
	String BOM_IN_STORE_DATE_FROM_LABEL = "In Store Date From";
	String BOM_IN_STORE_DATE_TO_LABEL = "In Store Date To";
	String BOM_SEASON_YEAR_LABEL = "Season Year";
	String BOM_READY_FOR_PRODUCTION_LABEL = "Ready For Production";
	String BOM_CUSTOMER_LABEL = "Customer";
	String BOM_BRAND_LABEL = "Brand";
	String BOM_LICENSOR_LABEL = "Licensor";
	String BOM_PROPERTY_LABEL = "Property";
	String BOM_PRODUCT_CATEGORY_LABEL = "Product Category";
	String BOM_SEASON_TYPE_LABEL = "Season Type";
	String BOM_DIVISION_LABEL = "Division";
	String BOM_INPUT_CRITERIA_FIELD_LABEL = "Input Criteria Field";
	String BOM_VALUE_SELECTED_LABEL = "Value Selected";
	String BOM_SEARCH_CRITERIA_LABEL = "Search Criteria";

	//PLM Admin EMAIL ID
	String PLM_ADMIN_EMAIL_ID = "plmadmin@lfusa.com";
	

	// ///////////// List of Keys for Columns used in excel report
	// ///////////////
	String PRODUCT_STYLE_NUMBER_KEY = "lfRootProductNum";
	String PRODUCT_DESCRIPTION_KEY = "lfRootProductLongDesc";
	String CS_VENDOR_KEY = "lfVendor";
	String PRODUCT_IN_STORE_DATE_KEY = "lfRootProductAppInStoreDate";
	String BOM_COMPONENT_LOCATION_KEY = "partName";
	String BOM_PLACEMENT_KEY = "placement";
	String MATERIAL_REF_NO_KEY = "lfReferenceNo";
	String MATERIAL_NAME_KEY = "name";
	//Build 7.4 BOM Listing Report START
	String MATERIAL_PRICE_KEY = "materialPrice";
	String MATERIAL_PRICE_EFF_DATE_KEY = "gbgMaterialPriceEffDate";
	//Build 7.4 BOM Listing Report END
	String MATERIAL_SUPPLIER_MATERIAL_REF_NO_KEY = "supplierMaterialRefNo";
	String MATERIAL_DESIGNER_NAME_KEY = "lfDesignerNameNew";
	String BOM_QUANTITY_KEY = "quantity";
	String MATERIAL_SUPPLIER_NAME_KEY = "supplierMaterialName";
	String BOM_COLOR_KEY = "colorDescription";
	String BOM_NAME_KEY = "name";
	String BOM_SECTION_KEY = "section";
	String SPECIFICATION_NAME_KEY = "specName";
	String COLORWAY_NAME_KEY = "skuName";
	String COSTSHEET_NAME_KEY = "name";
	String READY_FOR_PRODUCTION_HOME_KEY = "lfreadyforproduction";
	String USER_EMAIL_KEY = "lfUserEmailID";
	String PRODUCT_SIZE_GROUP_KEY = "lfRootProductGenSizeGrp";

	// ///////////// List of FlexType Paths used in excel report ///////////////
	String COSTSHEET = "Cost Sheet";
	String BOM = "BOM";
	String MATERIAL = "Material";
	String MATERIAL_APPAREL = "Material\\Apparel";
	String APPAREL = "Apparel";
	String SPECIFICATION = "Specification";
	String LCSCOSTSHEET = "LCSCOSTSHEET";
	String FLEXBOMPART = "FLEXBOMPART";
	String LCSMATERIAL = "LCSMATERIAL";
	String LCSMATERIALSUPPLIER = "LCSMATERIALSUPPLIER";
	String FLEXSPECIFICATION = "FLEXSPECIFICATION";

	/**
	 * String defaultCharsetEncoding.
	 */
	final String defaultCharsetEncoding = LCSProperties.get(
			"com.lcs.wc.util.CharsetFilter.Charset", "UTF-8");
	/**
	 * String VENDOR_SEARCHTERM_ONE_KEY.
	 */
	String VENDOR_SEARCHTERM_ONE_KEY = "lfSearchTermOne";
	
	/**
	 * String searchTermVNPath.
	 */
	final String searchTermVNPath = LCSProperties
			.get("com.lfusa.wc.sapfeed.VN.flexType");

	/**
	 * String searchTermDVNPath.
	 */
	final String searchTermDVNPath = LCSProperties
			.get("com.lfusa.wc.sapfeed.DVN.flexType");
	
	/**
	 * String VN.
	 */
	final String VN = "VN";
	
	/**
	 * String DVN.
	 */
	final String DVN = "DVN";
	/**
	 * String lcsSupplier.
	 */
	final String lcsSupplier = "LCSSUPPLIER";
	/**
	 * String ida3a10.
	 */
	final String ida3a10 = "IDA3A10";
	
	final String twelvePercent = "12%";

	
}
