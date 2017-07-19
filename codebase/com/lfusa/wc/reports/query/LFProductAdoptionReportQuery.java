/**
 * LFProductAdoptionReportQuery.java
 * NOV 18, 2013
 * 
 */
package com.lfusa.wc.reports.query;

import java.lang.reflect.InvocationTargetException;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.exception.ExceptionUtils;

import wt.util.WTException;

import com.lcs.wc.client.web.TableColumn;
import com.lcs.wc.db.Criteria;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.db.PreparedQueryStatement;
import com.lcs.wc.db.QueryColumn;
import com.lcs.wc.flextype.FlexTypeCache;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.util.ACLHelper;
import com.lcs.wc.util.FlexObjectUtil;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;

/**
 * @author ITC Infotech.
 * @version 2.0.
 * @since Apr 2, 2013.
 * 
 *        Updated for Build 4.24 Modified On : 12-June-2012 Description :
 *        Product Adoption Report Enhancement, adding sample type criteria. Also
 *        adding columns Sample Request Count and Sample Count. Updated for
 *        Build 5.10 Modified On : 18-NOV-2013 Description : Product Adoption
 *        Report Enhancement. Product Category and Description are added as part
 *        of Criteria. all the result are based on Division-Product
 *        Category-Description combination.
 * 
 */
public class LFProductAdoptionReportQuery implements LFReportConstants {

	/**
	 * Private Constructor for Utility Class
	 */
	protected LFProductAdoptionReportQuery() {
	}

	// //////////// Used for Prepared Query ///////////////
	/**
	 * String variable PREPAREDQUERY.
	 */
	protected static final String PREPAREDQUERY = "Prepared Query --> ";

	// ///////////// Used for Column Features ///////////////
	/**
	 * String variable CENTER.
	 */
	private static final String CENTER = "center";
	/**
	 * String variable INTEGER_KEY.
	 */
	private static final String INTEGER_KEY = "integer";
	/**
	 * String variable INTEGER_KEY.
	 */
	//Sample Quantity decimal change
		/**
		 * String variable FLOAT_KEY.
		 */
		private static final String FLOAT_KEY = "float";
		//Sample Quantity decimal change
	private static final String DOUBLE_KEY = "double";

	/**
	 * Collection<TableColumn> variable lcolumns.
	 */
	static Collection<TableColumn> lcolumns = null;

	/**
	 * String integer precision.
	 */
	private static final String integerPrecision = LCSProperties.get(
			"com.lfusa.reports.productAdoptionReport.integerPrecisionValue",
			"0");
	/**
	 * Initialization of the Criteria value used
	 */
	private static List<?> divisionValues = new ArrayList<Object>();
	/**
	 * List of Season Year Value.
	 */
	private static List<?> seasonYearValues = new ArrayList<Object>();
	/**
	 * List of Season Type Value.
	 */
	private static List<?> seasonTypeValues = new ArrayList<Object>();
	/**
	 * List of Gender Value.
	 */
	private static List<?> genderValues = new ArrayList<Object>();
	/**
	 * List of Sample Type Value.
	 */
	private static List<?> sampleTypeValues = new ArrayList<Object>();
	/**
	 * Licensor Value.
	 */
	private static List<?> licensorValues = new ArrayList<Object>();
	/**
	 * Property Value.
	 */
	private static List<?> propertyValues = new ArrayList<Object>();
	/**
	 * Customer Value.
	 */
	private static List<?> customerValues = new ArrayList<Object>();
	/**
	 * Brand Value.
	 */
	private static List<?> brandValues = new ArrayList<Object>();

	/**
	 * Initialization of DB Column/Variable names used.
	 */
	protected static String seasonNameColumn = "";
	/**
	 * Initialization of DB Column/Variable names used.
	 */
	protected static String divisionColumn = "";
	/**
	 * Plan Description Column.
	 */
	protected static String planDescriptionColumn = "";
	/**
	 * Placeholder Description Column.
	 */
	protected static String phDescriptionColumn = "";
	/**
	 * Product productCategory Column.
	 */
	protected static String prodProdCatColumn = "";
	/**
	 * Placeholder productCategory Column.
	 */
	protected static String phProdCatColumn = "";
	/**
	 * Plan productCategory Column.
	 */
	protected static String planProdCatColumn = "";
	/**
	 * PlannedItem Column.
	 */
	protected static String planToDevelopColumn = "";
	/**
	 * PlannedItem Column.
	 */
	protected static String plannedToSellColumn = "";
	/**
	 * SampleType Column.
	 */
	protected static String sampleTypeColumn = "";
	/**
	 * SampleQuantity Column.
	 */
	protected static String sampleQuantityCountColumn = "";
	//Added for PLM-159 change
	/**
	 * SampleQuantity OldColumn.
	 */
	protected static String oldSampleQuantityCountColumn = "";
	//Added for PLM-159 change
	/**
	 * Product status Column.
	 */
	protected static String productStatusColumn = "";
	/**
	 * Planned proto status Column.
	 */
	protected static String totalNoOfProtoSamplesColumn = "";
	
	//Added GBG Build 11 Footwear Adoption Report changes START
	
	/**
	 * Footwear Planned salesman status Column.
	 */
	protected static String totalNoOfSalesmanSamplesColumn = "";
	
	//END GBG Build 11 Footwear Adoption Report changes
	
	

	/**
	 * Initialization of Indexes used.
	 */
	private static String seasonNameIndex = "";
	/**
	 * Initialization of Indexes used.
	 */
	private static String divisionIndex = "";
	/**
	 * Line Plan Index.
	 */
	private static String flexPlanIndex = "";
	/**
	 * Product Planned to Sell Index.(OOTB product Count)
	 */
	private static String plannedToSellIndex = "";
	/**
	 * Product Index.
	 */
	private static String productIndex = "";
	/**
	 * Product status Index.
	 */
	private static String productStatusIndex = "";
	/**
	 * Product category Index.
	 */
	private static String productCategoryIndex = "";
	/**
	 * Line Plan Description Index.
	 */
	private static String descriptionIndex = "";
	/**
	 * Line Plan PlannedItem Index.
	 */
	private static String planToDevelopIndex = "";
	/**
	 * Sample Count Index.
	 */
	private static String sampleCountIndex = "";
	//Added GBG Build 11 Footwear Adoptioin Report changes
	
	/**
	 * Sample Count Index.
	 */
	private static String sampleProtoCountIndex = "";
	
	
	/**
	 * Footwear Sample Count Index.
	 */
	private static String PlannedSalesmanSamplesIndex = "";
	/**
	 * 
	 * Footwear Sample Count Index.
	 */
	private static String footwearTabProtoSample = "";
	/**
   /**
	 * Sample Count Index.
	 */
	private static String footwearProtoAverage = "";
	/**
	 * Sample Count Index.
	 */
	private static String footwearSalesAverage = "";
	/**
	 * Sample Count Index.
	 */
	private static String footwearProductsToDevelopIndex = "";
	
	private static String footwearDivisions =LCSProperties.get("com.lfusa.reports.footwearDivisons");
	// END GBG BUILD 11 Footwear changes
	/**
	 * Sample Ixdex.
	 */
	private static String sampleIndex = "";
	/**
	 * Custom Adoption Rate Index.
	 */
	private static String adoptionRateIndex = "";
	/**
	 * Custom Row Average Sample Index.
	 */
	private static String sampleAverageIndex = "";
	/**
	 * Sample Flex type Index.
	 */
	private static String sampleFlexTypeIndex = "";
	/**
	 * Placeholder Index.
	 */
	private static String placeholderIndex = "";

	/**
	 * DEBUG.
	 */
	public static final boolean DEBUG;
	/**
	 * Debug Statement.
	 */
	static {
		DEBUG = LCSProperties
				.getBoolean("rfa.lfusa.jsp.reports.LFProductAdoptionReport.verbose");
	}

	/**
	 * ITC Infotech.
	 * 
	 * @param searchCriteria
	 *            .
	 * @return void.
	 * 
	 */
	protected static void init(Map<String, ?> searchCriteria) {
		// The values from the request map with all the criteria

		LCSLog.debug(" searchCriteria" + searchCriteria);

		divisionValues = (List<?>) searchCriteria.get(SEARCH_DIVISION);
		seasonYearValues = (List<?>) searchCriteria.get(SEARCH_SEASON_YEAR);
		seasonTypeValues = (List<?>) searchCriteria.get(SEARCH_SEASON_TYPE);
		genderValues = (List<?>) searchCriteria.get(SEARCH_GENDER_VALUE);
		sampleTypeValues = (List<?>) searchCriteria.get(SEARCH_SAMPLE_TYPE);
		licensorValues = (List<?>) searchCriteria.get(SEARCH_LICENSOR);
		propertyValues = (List<?>) searchCriteria.get(SEARCH_PROPERTY);
		customerValues = (List<?>) searchCriteria.get(SEARCH_CUSTOMER);
		brandValues = (List<?>) searchCriteria.get(SEARCH_BRAND);

	}

	/**
	 * 
	 * ITC Infotech.
	 * 
	 * @return void.
	 * 
	 */
	protected static void initConstants() {
		// Name of the DatabaseColumn/VariableName used up in Querying
		// Season -- Name
		seasonNameColumn = LFReportUtil.getColumnName(SEASON_NAME_KEY, SEASON);
		// Season -- Name
		divisionColumn = LFReportUtil.getColumnName(DIVISION_KEY, SEASON);
		// LinePlan -- description
		planDescriptionColumn = LFReportUtil.getColumnName(DESCRIPTION_KEY,
				SEASONAL_LINE_PLAN);
		// Placeholder -- description
		phDescriptionColumn = LFReportUtil.getColumnName(DESCRIPTION_KEY,
				PRODUCT);
		// Product -- Product Category
		prodProdCatColumn = LFReportUtil.getColumnName(PRODUCT_CATEGORY_KEY,
				PRODUCT);
		// Placeholder -- Product Category
		phProdCatColumn = LFReportUtil.getColumnName(PRODUCT_CATEGORY_PH_KEY,
				PRODUCT);
		// Lineplan -- Product Category
		planProdCatColumn = LFReportUtil.getColumnName(PRODUCT_CATEGORY_PH_KEY,
				SEASONAL_LINE_PLAN);
	
		// LinePlan -- Product Planned to Sell
		plannedToSellColumn = LFReportUtil.getColumnName(PLAN_TO_SELL_KEY,
				SEASONAL_LINE_PLAN);
		// Sample -- lfSampleQuantity
		sampleTypeColumn = LFReportUtil.getColumnName(SAMPLETYPE_KEY, SAMPLE);
		// Sample -- lfSampleQuantity
		sampleQuantityCountColumn = LFReportUtil.getColumnName(
				SAMPLEQUANTITY_KEY, SAMPLE);
		//Added for PLM-159 change
		oldSampleQuantityCountColumn= LFReportUtil.getColumnName(
				OLDSAMPLEQUANTITY_KEY, SAMPLE);
		//Added for PLM-159 change
		// SeasonProductLink -- placeholderStatus
		productStatusColumn = LFReportUtil.getColumnName(PRODUCT_STATUS_KEY,
				PRODUCT);
		// SeasonProductLink -- placeholderStatus
		//ADDED GBG BUILD 11 Footwear Adoption Report changes
		if(divisionValues.contains(footwearDivisions))
		{
		
		totalNoOfProtoSamplesColumn = LFReportUtil.getColumnName(
				TOTAL_NO_OF_PROTOSAMPLE_KEY, SEASONAL_LINE_PLAN_FOOTWEAR);
		// LinePlan -- # Product to Develop
		planToDevelopColumn = LFReportUtil.getColumnName(PLAN_TO_DEVELOP_KEY,
				SEASONAL_LINE_PLAN_FOOTWEAR);
		
		// SeasonProductLink -- placeholderStatus
		totalNoOfSalesmanSamplesColumn = LFReportUtil.getColumnName(
				TOTAL_NO_OF_SALESSAMPLE_KEY, SEASONAL_LINE_PLAN_FOOTWEAR);
		
		System.out.println("totalNoOfSalesmanSamplesColumn------" +TOTAL_NO_OF_SALESSAMPLE_KEY);
		
		}
		else
		{
			System.out.println("---------It is coming apparel else block------");
			totalNoOfProtoSamplesColumn = LFReportUtil.getColumnName(
					TOTAL_NO_OF_PROTOSAMPLE_KEY, SEASONAL_LINE_PLAN_APPAREL);
			
		  // LinePlan -- # Product to Develop
			planToDevelopColumn = LFReportUtil.getColumnName(PLAN_TO_DEVELOP_KEY,
					SEASONAL_LINE_PLAN_APPAREL);
		}
		
		//END GBG BUILD 11 Footwear Adoption Report changes
		
		seasonNameIndex = SEASON_NAME;
		divisionIndex = LCSSEASON + "." + divisionColumn;
		flexPlanIndex = FLEXPLAN + "." + IDA2A2;
		placeholderIndex = PLACEHOLDER + "." + IDA2A2;
		productIndex = PRODAREV + "." + IDA2A2;
		sampleIndex = LCSSAMPLE + "." + IDA2A2;
		productStatusIndex = LCSSEASONPRODUCTLINK + "." + productStatusColumn;
		productCategoryIndex = PRODAREV + "." + prodProdCatColumn;
		descriptionIndex = PLANLINEITEM + "." + planDescriptionColumn;
		planToDevelopIndex = PLANLINEITEM + "." + planToDevelopColumn;
		plannedToSellIndex = PLANLINEITEM + "." + plannedToSellColumn;
		sampleCountIndex = LCSSAMPLE + "." + sampleQuantityCountColumn;
		// sampleFlexTypeIndex = FLEXTYPE + "." + TYPENAME;
		adoptionRateIndex = CUSTOMADOPTION;
		sampleAverageIndex = CUSTOMSAMPLEAVERAGE;
		sampleFlexTypeIndex = PLANLINEITEM + "." + totalNoOfProtoSamplesColumn;
		
		//Added GBG Build 11 Footwear Adoption Report changes
		sampleProtoCountIndex=LCSSAMPLE+"."+"NUM0";
		footwearProtoAverage=CUSTOMSAMPLEPROTOAVERAGE;
		footwearSalesAverage=CUSTOMSAMPLESALESAVERAGE;
		PlannedSalesmanSamplesIndex=PLANLINEITEM + "." + totalNoOfSalesmanSamplesColumn;
		//END GBG Build 11 Footwear Adoption Report changes
		

	}

	// SELECT LCSSEASON.att1, PRODAREV.att61, PLANLINEITEM.att10,
	// PLANLINEITEM.num23, LCSSEASONPRODUCTLINK.att13, LCSSEASON.IDA2A2,
	// FLEXPLAN.IDA2A2, PLACEHOLDER.IDA2A2, PRODAREV.IDA2A2 FROM LCSSEASON
	// LCSSEASON, FLEXPLAN FLEXPLAN, PLANLINEITEM PLANLINEITEM, PLANTOOWNERLINK
	// =
	// PLANTOOWNERLINK, PRODAREV PRODAREV, LCSSEASONPRODUCTLINK
	// LCSSEASONPRODUCTLINK, PLACEHOLDER PLACEHOLDER WHERE
	// PLANTOOWNERLINK.IDA3A5 = LCSSEASON.IDA3MASTERREFERENCE AND
	// PLANTOOWNERLINK.IDA3B5 = FLEXPLAN.IDA3MASTERREFERENCE AND
	// PLANLINEITEM.IDA3A5 = FLEXPLAN.IDA3MASTERREFERENCE AND
	// LCSSEASONPRODUCTLINK.PRODUCTMASTERID = PRODAREV.IDA3MASTERREFERENCE AND
	// LCSSEASONPRODUCTLINK.SEASONREVID = LCSSEASON.BRANCHIDITERATIONINFO AND
	// LCSSEASONPRODUCTLINK.IDA3D8 = PLACEHOLDER.IDA2A2 AND PLACEHOLDER.IDA3A9 =
	// LCSSEASON.IDA3MASTERREFERENCE AND PLANLINEITEM.att10 = PLACEHOLDER.att4
	// AND PLACEHOLDER.att5 = PRODAREV.att61 AND PRODAREV.att61 =
	// PLANLINEITEM.att11 AND FLEXPLAN.LATESTITERATIONINFO = '1' AND
	// PLANLINEITEM.effectoutdate IS NULL AND UPPER(FLEXPLAN.statecheckoutinfo)
	// <> '%C/O%' AND PLANLINEITEM.att10 IS NOT NULL AND
	// LCSSEASONPRODUCTLINK.SEASONREMOVED = '0' AND
	// LCSSEASONPRODUCTLINK.EFFECTLATEST = '1' AND PRODAREV.LATESTITERATIONINFO
	// = '1' AND UPPER(PRODAREV.VERSIONIDA2VERSIONINFO) = 'A' AND
	// LCSSEASON.LATESTITERATIONINFO = '1' AND
	// UPPER(LCSSEASON.VERSIONIDA2VERSIONINFO) = 'A' AND LCSSEASON.att13 LIKE
	// '%oxfordWW%'

	/**
	 * 
	 * ITC Infotech.
	 * 
	 * @return Collection<?>.
	 * 
	 */
	private static Collection<?> getSeasonProdCategoryDescDetails() {

		final long startTime = System.currentTimeMillis();

		final PreparedQueryStatement pqs = new PreparedQueryStatement();

		// JOIN TABLES
		pqs.appendFromTable(LCSSEASON, LCSSEASON);
		pqs.appendFromTable(FLEXPLAN, FLEXPLAN);
		pqs.appendFromTable(PLANLINEITEM, PLANLINEITEM);
		pqs.appendFromTable(PLANTOOWNERLINK, PLANTOOWNERLINK);
		pqs.appendFromTable(PRODAREV, PRODAREV);
		pqs.appendFromTable(LCSSEASONPRODUCTLINK, LCSSEASONPRODUCTLINK);
		pqs.appendFromTable(PLACEHOLDER, PLACEHOLDER);

		// SELECT COLUMN
		pqs.appendSelectColumn(LCSSEASON, seasonNameColumn);
		pqs.appendSelectColumn(LCSSEASON, divisionColumn);
		pqs.appendSelectColumn(PRODAREV, prodProdCatColumn);
		pqs.appendSelectColumn(PLANLINEITEM, planDescriptionColumn);
		pqs.appendSelectColumn(PLANLINEITEM, planToDevelopColumn);
		pqs.appendSelectColumn(PLANLINEITEM, plannedToSellColumn);
		pqs.appendSelectColumn(PLANLINEITEM, totalNoOfProtoSamplesColumn);
		if(divisionValues.contains(footwearDivisions))
		{
	     pqs.appendSelectColumn(PLANLINEITEM, totalNoOfSalesmanSamplesColumn);
		}
		pqs.appendSelectColumn(LCSSEASONPRODUCTLINK, productStatusColumn);
		pqs.appendSelectColumn(LCSSEASON, IDA2A2);
		pqs.appendSelectColumn(FLEXPLAN, IDA2A2);
		pqs.appendSelectColumn(PLACEHOLDER, IDA2A2);
		pqs.appendSelectColumn(PRODAREV, IDA2A2);

		/**
		 * To link Season and Plan.
		 */
		// JOIN QUERY
		pqs.appendJoin(PLANTOOWNERLINK, "IDA3A5", LCSSEASON,
				IDA3MASTERREFERENCE);
		pqs.appendJoin(PLANTOOWNERLINK, "IDA3B5", FLEXPLAN, IDA3MASTERREFERENCE);
		pqs.appendJoin(PLANLINEITEM, "IDA3A5", FLEXPLAN, IDA3MASTERREFERENCE);
		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(FLEXPLAN,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PLANLINEITEM,
				"effectoutdate"), null, Criteria.IS_NULL, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(FLEXPLAN,
				"statecheckoutinfo"), "%c/o%", Criteria.NOT_EQUAL_TO, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PLANLINEITEM,
				planDescriptionColumn), null, Criteria.IS_NOT_NULL, true));
		pqs.appendSortBy(new QueryColumn(LCSSEASON, seasonNameColumn));

		/**
		 * To link season and Product.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSEASONPRODUCTLINK, "PRODUCTMASTERID", PRODAREV,
				IDA3MASTERREFERENCE);
		pqs.appendJoin(LCSSEASONPRODUCTLINK, "SEASONREVID", LCSSEASON,
				BRANCHIDITERATIONINFO);
		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASONPRODUCTLINK,
				"SEASONREMOVED"), "0", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASONPRODUCTLINK,
				"EFFECTLATEST"), "1", Criteria.EQUALS, true));

		/**
		 * To link the Placeholder and Season.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSEASONPRODUCTLINK, "IDA3D8", PLACEHOLDER, IDA2A2);
		pqs.appendJoin(PLACEHOLDER, "IDA3A9", LCSSEASON, IDA3MASTERREFERENCE);

		/**
		 * Latest Product and Season.
		 */
		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				VERSIONIDA2VERSIONINFO), "A", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASON,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASON,
				VERSIONIDA2VERSIONINFO), "A", Criteria.EQUALS, true));

		/**
		 * Product Category and Description Verfication.
		 */
		pqs.appendJoin(PLANLINEITEM, planDescriptionColumn, PLACEHOLDER,
				phDescriptionColumn);
		pqs.appendJoin(PLACEHOLDER, phProdCatColumn, PRODAREV,
				prodProdCatColumn);
		pqs.appendJoin(PRODAREV, prodProdCatColumn, PLANLINEITEM,
				planProdCatColumn);

		// FILTER CRITERIA FOR SEASON
		PreparedQueryStatement seasonPqs = new PreparedQueryStatement();
		seasonPqs = getSeasonFilterQuery(pqs);
		// FILTER CRITERIA FOR PRODUCT
		PreparedQueryStatement productSeasonPqs = new PreparedQueryStatement();
		productSeasonPqs = getProductFilterQuery(seasonPqs);
		if (DEBUG) {
			LCSLog.debug(PREPAREDQUERY + productSeasonPqs.toString());
		}
		Collection<?> results = null;
		try {
			// QUERY EXECUTION
			results = LCSQuery.runDirectQuery(productSeasonPqs).getResults();
		} catch (WTException ex) {
			LCSLog.error("Exception in getSeasonProdCategoryDescDetails --> "
					+ ExceptionUtils.getStackTrace(ex));
		}

		final long endTime = System.currentTimeMillis();
		final long totalTime = endTime - startTime;
		if (DEBUG) {
			LCSLog.debug("Method getSeasonProdCategoryDescDetails Time taken for execution --> "
					+ totalTime);
		}
		return results;
	}

	// SELECT PRODAREV.IDA2A2, LCSSAMPLE.IDA2A2, LCSSAMPLE.num4,
	// LCSSAMPLEREQUEST.att11, FLEXTYPE.TYPENAME FROM PRODAREV PRODAREV,
	// LCSSOURCINGCONFIGMASTER LCSSOURCINGCONFIGMASTER, LCSSAMPLE LCSSAMPLE,
	// LCSSAMPLEREQUEST LCSSAMPLEREQUEST, FLEXTYPE FLEXTYPE WHERE
	// LCSSAMPLE.IDA3A10 = LCSSOURCINGCONFIGMASTER.IDA2A2 AND
	// LCSSOURCINGCONFIGMASTER.PRODUCTAREVID = PRODAREV.BRANCHIDITERATIONINFO
	// AND LCSSAMPLE.IDA3E10= LCSSAMPLEREQUEST.IDA2A2 AND FLEXTYPE.IDA2A2 =
	// LCSSAMPLE.IDA3A8 AND PRODAREV.LATESTITERATIONINFO = '1' AND
	// UPPER(PRODAREV.VERSIONIDA2VERSIONINFO) = 'A' AND ( FLEXTYPE.TYPENAME =
	// 'Proto or Development' OR LCSSAMPLEREQUEST.att11 = 'Proto or Development'
	// )
	
	
	//Added GBG Build 11 Footwear Adoption Report changes
	/*
	 * This method is used for getting proto samples for the product
	 */
	private static Collection<?> getProductProtoSampleDetails() {

		final long startTime = System.currentTimeMillis();
		final PreparedQueryStatement pqs = new PreparedQueryStatement();
		// Initialize Master List of Map
		List<FlexObject> dataList = new java.util.ArrayList<FlexObject>();

		// JOIN TABLES
		pqs.appendFromTable(PRODAREV, PRODAREV);
		pqs.appendFromTable(LCSSOURCINGCONFIGMASTER, LCSSOURCINGCONFIGMASTER);
		pqs.appendFromTable(LCSSAMPLE, LCSSAMPLE);
		pqs.appendFromTable(LCSSAMPLEREQUEST, LCSSAMPLEREQUEST);

		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_FOOTWEAR_PATH))) {
				pqs.appendFromTable(FLEXTYPE, FLEXTYPE);
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		// SELECT COLUMN
		pqs.appendSelectColumn(PRODAREV, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, sampleQuantityCountColumn);
		//Added for PLM-159 change
		pqs.appendSelectColumn(LCSSAMPLE, oldSampleQuantityCountColumn);
		//Added for PLM-159 change
		pqs.appendSelectColumn(LCSSAMPLEREQUEST, sampleTypeColumn);
		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_FOOTWEAR_PATH))) {
				pqs.appendSelectColumn(FLEXTYPE, TYPENAME);
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		/**
		 * To link the Sample SourcingConfiguration.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSAMPLE, "IDA3A10", LCSSOURCINGCONFIGMASTER, IDA2A2);
		pqs.appendJoin(LCSSOURCINGCONFIGMASTER, "PRODUCTAREVID", PRODAREV,
				BRANCHIDITERATIONINFO);
		pqs.appendJoin(LCSSAMPLE, "IDA3E10", LCSSAMPLEREQUEST, IDA2A2);
		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_FOOTWEAR_PATH))) {
				pqs.appendJoin(FLEXTYPE, IDA2A2, LCSSAMPLE, "IDA3A8");
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getSeasonSampleRequestDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		/**
		 * Latest Product and Season.
		 */
		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				VERSIONIDA2VERSIONINFO), "A", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(FLEXTYPE,
				TYPENAME), PROTOSAMPLES, Criteria.EQUALS, true));

		PreparedQueryStatement productPqs = new PreparedQueryStatement();
		productPqs = getProductFilterQuery(pqs);

		PreparedQueryStatement sampleProductPqs = new PreparedQueryStatement();
		sampleProductPqs = getSampleTypeFilterQuery(productPqs,
				sampleTypeValues);
		if (DEBUG) {
			LCSLog.debug(PREPAREDQUERY + sampleProductPqs.toString());
		}
		Collection<?> results = null;
		try {
			// Query Execution
			results = LCSQuery.runDirectQuery(sampleProductPqs).getResults();
		} catch (WTException ex) {
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(ex));
		}
		final long endTime = System.currentTimeMillis();
		final long totalTime = endTime - startTime;
		if (DEBUG) {
			LCSLog.debug("Method getProductSampleDetails Time taken for execution --> "
					+ totalTime);
		}

		/**
		 * Grouping the Sample Data.
		 */
		// GROUP SAMPLE DATA ACCORDING TO THE PRODUCT
		Map<?, ?> groupedIntoProduct = FlexObjectUtil.groupIntoCollections(
				(Collection<FlexObject>) results, productIndex);
		// ITERATING THROUGH THE COLLECTION
		for (Object key : groupedIntoProduct.keySet()) {
			FlexObject resultFOB = new FlexObject();
			Collection<?> collection = (Collection<?>) groupedIntoProduct
					.get(key);
			// SAMPLE QUANTITY VALUE
			float sampleQtyValue = LFReportUtil.internalCalculation(collection,
					sampleIndex, sampleCountIndex, CALCULATE);
		
			resultFOB.put(productIndex, key);
			resultFOB.put(sampleIndex, collection.size());
			resultFOB.put(sampleProtoCountIndex, sampleQtyValue);
			
			
			System.out.println("dataList--------------->" +dataList);
			dataList.add(resultFOB);
		}

		return dataList;
	}
	
	//END GBG Build 11 Footwear Adoption Report changes END
	
	/*
	 * This method is used for getting sales sample details
	 */
	
	//Added GBG Build 11 Footwear changes
	private static Collection<?> getProductSalesSampleDetails() {

		final long startTime = System.currentTimeMillis();
		final PreparedQueryStatement pqs = new PreparedQueryStatement();
		// Initialize Master List of Map
		List<FlexObject> dataList = new java.util.ArrayList<FlexObject>();

		// JOIN TABLES
		pqs.appendFromTable(PRODAREV, PRODAREV);
		pqs.appendFromTable(LCSSOURCINGCONFIGMASTER, LCSSOURCINGCONFIGMASTER);
		pqs.appendFromTable(LCSSAMPLE, LCSSAMPLE);
		pqs.appendFromTable(LCSSAMPLEREQUEST, LCSSAMPLEREQUEST);

		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_FOOTWEAR_PATH))) {
				pqs.appendFromTable(FLEXTYPE, FLEXTYPE);
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		// SELECT COLUMN
		pqs.appendSelectColumn(PRODAREV, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, sampleQuantityCountColumn);
		//Added for PLM-159 change
		pqs.appendSelectColumn(LCSSAMPLE, oldSampleQuantityCountColumn);
		//Added for PLM-159 change
		pqs.appendSelectColumn(LCSSAMPLEREQUEST, sampleTypeColumn);
		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_FOOTWEAR_PATH))) {
				pqs.appendSelectColumn(FLEXTYPE, TYPENAME);
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		/**
		 * To link the Sample SourcingConfiguration.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSAMPLE, "IDA3A10", LCSSOURCINGCONFIGMASTER, IDA2A2);
		pqs.appendJoin(LCSSOURCINGCONFIGMASTER, "PRODUCTAREVID", PRODAREV,
				BRANCHIDITERATIONINFO);
		pqs.appendJoin(LCSSAMPLE, "IDA3E10", LCSSAMPLEREQUEST, IDA2A2);
		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_APP_PATH))) {
				pqs.appendJoin(FLEXTYPE, IDA2A2, LCSSAMPLE, "IDA3A8");
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getSeasonSampleRequestDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		/**
		 * Latest Product and Season.
		 */
		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				VERSIONIDA2VERSIONINFO), "A", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(FLEXTYPE,
				TYPENAME), SALEMANSSAMPLE, Criteria.EQUALS, true));

		PreparedQueryStatement productPqs = new PreparedQueryStatement();
		productPqs = getProductFilterQuery(pqs);

		PreparedQueryStatement sampleProductPqs = new PreparedQueryStatement();
		sampleProductPqs = getSampleTypeFilterQuery(productPqs,
				sampleTypeValues);
		if (DEBUG) {
			LCSLog.debug(PREPAREDQUERY + sampleProductPqs.toString());
		}
		Collection<?> results = null;
		try {
			// Query Execution
			results = LCSQuery.runDirectQuery(sampleProductPqs).getResults();
		} catch (WTException ex) {
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(ex));
		}
		final long endTime = System.currentTimeMillis();
		final long totalTime = endTime - startTime;
		if (DEBUG) {
			LCSLog.debug("Method getProductSampleDetails Time taken for execution --> "
					+ totalTime);
		}

		/**
		 * Grouping the Sample Data.
		 */
		// GROUP SAMPLE DATA ACCORDING TO THE PRODUCT
		Map<?, ?> groupedIntoProduct = FlexObjectUtil.groupIntoCollections(
				(Collection<FlexObject>) results, productIndex);
		// ITERATING THROUGH THE COLLECTION
		for (Object key : groupedIntoProduct.keySet()) {
			FlexObject resultFOB = new FlexObject();
			Collection<?> collection = (Collection<?>) groupedIntoProduct
					.get(key);
			// SAMPLE QUANTITY VALUE
			float sampleQtyValue = LFReportUtil.internalCalculation(collection,
					sampleIndex, sampleCountIndex, CALCULATE);
			// PROTO SAMPLE TYPE COUNT VALUE
			// int protoQtyValue = LFReportUtil.internalCalculation(collection,
			// "", sampleFlexTypeIndex, COUNT);
			// SAMPLE DATA DETAILS
			resultFOB.put(productIndex, key);
			resultFOB.put(sampleIndex, collection.size());
			resultFOB.put(sampleCountIndex, sampleQtyValue);
			// resultFOB.put(sampleFlexTypeIndex, protoQtyValue);
			
			System.out.println("dataList--------------->" +dataList);
			dataList.add(resultFOB);
		}

		return dataList;
	}
	
	//END GBG Build 11 Footwear changes 
	
	

	/**
	 * ITC Infotech.
	 * 
	 * @return Collection<?>.
	 */

	private static Collection<?> getProductSampleDetails() {

		final long startTime = System.currentTimeMillis();
		final PreparedQueryStatement pqs = new PreparedQueryStatement();
		// Initialize Master List of Map
		List<FlexObject> dataList = new java.util.ArrayList<FlexObject>();

		// JOIN TABLES
		pqs.appendFromTable(PRODAREV, PRODAREV);
		pqs.appendFromTable(LCSSOURCINGCONFIGMASTER, LCSSOURCINGCONFIGMASTER);
		pqs.appendFromTable(LCSSAMPLE, LCSSAMPLE);
		pqs.appendFromTable(LCSSAMPLEREQUEST, LCSSAMPLEREQUEST);

		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_APP_PATH))) {
				pqs.appendFromTable(FLEXTYPE, FLEXTYPE);
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		// SELECT COLUMN
		pqs.appendSelectColumn(PRODAREV, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, sampleQuantityCountColumn);
		//Added for PLM-159 change
		pqs.appendSelectColumn(LCSSAMPLE, oldSampleQuantityCountColumn);
		//Added for PLM-159 change
		pqs.appendSelectColumn(LCSSAMPLEREQUEST, sampleTypeColumn);
		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_APP_PATH))) {
				pqs.appendSelectColumn(FLEXTYPE, TYPENAME);
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		/**
		 * To link the Sample SourcingConfiguration.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSAMPLE, "IDA3A10", LCSSOURCINGCONFIGMASTER, IDA2A2);
		pqs.appendJoin(LCSSOURCINGCONFIGMASTER, "PRODUCTAREVID", PRODAREV,
				BRANCHIDITERATIONINFO);
		pqs.appendJoin(LCSSAMPLE, "IDA3E10", LCSSAMPLEREQUEST, IDA2A2);
		// Added for Apparel
		try {
			if (ACLHelper.hasViewAccess(FlexTypeCache
					.getFlexTypeFromPath(SEASON_APP_PATH))) {
				pqs.appendJoin(FLEXTYPE, IDA2A2, LCSSAMPLE, "IDA3A8");
			}
		} catch (WTException e1) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in getSeasonSampleRequestDetails --> "
					+ ExceptionUtils.getStackTrace(e1));
			e1.printStackTrace();
		}

		/**
		 * Latest Product and Season.
		 */
		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				VERSIONIDA2VERSIONINFO), "A", Criteria.EQUALS, true));

		PreparedQueryStatement productPqs = new PreparedQueryStatement();
		productPqs = getProductFilterQuery(pqs);

		PreparedQueryStatement sampleProductPqs = new PreparedQueryStatement();
		sampleProductPqs = getSampleTypeFilterQuery(productPqs,
				sampleTypeValues);
		if (DEBUG) {
			LCSLog.debug(PREPAREDQUERY + sampleProductPqs.toString());
		}
		Collection<?> results = null;
		try {
			// Query Execution
			results = LCSQuery.runDirectQuery(sampleProductPqs).getResults();
		} catch (WTException ex) {
			LCSLog.error("Exception in getProductSampleDetails --> "
					+ ExceptionUtils.getStackTrace(ex));
		}
		final long endTime = System.currentTimeMillis();
		final long totalTime = endTime - startTime;
		if (DEBUG) {
			LCSLog.debug("Method getProductSampleDetails Time taken for execution --> "
					+ totalTime);
		}

		/**
		 * Grouping the Sample Data.
		 */
		// GROUP SAMPLE DATA ACCORDING TO THE PRODUCT
		Map<?, ?> groupedIntoProduct = FlexObjectUtil.groupIntoCollections(
				(Collection<FlexObject>) results, productIndex);
		// ITERATING THROUGH THE COLLECTION
		for (Object key : groupedIntoProduct.keySet()) {
			FlexObject resultFOB = new FlexObject();
			Collection<?> collection = (Collection<?>) groupedIntoProduct
					.get(key);
			// SAMPLE QUANTITY VALUE
			float sampleQtyValue = LFReportUtil.internalCalculation(collection,
					sampleIndex, sampleCountIndex, CALCULATE);
			// PROTO SAMPLE TYPE COUNT VALUE
			// int protoQtyValue = LFReportUtil.internalCalculation(collection,
			// "", sampleFlexTypeIndex, COUNT);
			// SAMPLE DATA DETAILS
			resultFOB.put(productIndex, key);
			resultFOB.put(sampleIndex, collection.size());
			resultFOB.put(sampleCountIndex, sampleQtyValue);
			// resultFOB.put(sampleFlexTypeIndex, protoQtyValue);
			dataList.add(resultFOB);
		}

		return dataList;
	}

	/**
	 * 
	 * ITC INFOTECH.
	 * 
	 * @param pqs
	 *            .
	 * @return PreparedQueryStatement.
	 */
	protected static PreparedQueryStatement getProductFilterQuery(
			PreparedQueryStatement pqs) {
		// TODO Auto-generated method stub
		PreparedQueryStatement productPqs = new PreparedQueryStatement();
		productPqs = pqs;
		// GENDER MULTI SELECT
		productPqs = LFReportUtil.appendInQuery(productPqs, genderValues,
				PRODAREV, PRODUCT, PRODUCT_GENDER_VALUE_KEY);
		// LICENSOR - SINGLE
		productPqs = LFReportUtil.appendInQuery(productPqs, licensorValues,
				PRODAREV, PRODUCT, PRODUCT_LICENSOR_KEY);
		// PROPERTY - SINGLE
		productPqs = LFReportUtil.appendInQuery(productPqs, propertyValues,
				PRODAREV, PRODUCT, PRODUCT_PROPERTY_KEY);
		// BRAND - SINGLE
		productPqs = LFReportUtil.appendInQuery(productPqs, brandValues,
				PRODAREV, PRODUCT, PRODUCT_BRAND_KEY);
		// CUSTOMER - SINGLE
		productPqs = LFReportUtil.appendInQuery(productPqs, customerValues,
				PRODAREV, PRODUCT, PRODUCT_CUSTOMER_KEY);
		return productPqs;
	}

	/**
	 * 
	 * ITC INFOTECH.
	 * 
	 * @param pqs
	 *            .
	 * @return PreparedQueryStatement.
	 */
	protected static PreparedQueryStatement getSeasonFilterQuery(
			PreparedQueryStatement pqs) {
		// TODO Auto-generated method stub
		PreparedQueryStatement seasonPqs = new PreparedQueryStatement();
		seasonPqs = pqs;
		// FILTER CRITERIA FOR SEASON
		// GENDER MULTI SELECT
		seasonPqs = LFReportUtil.appendInQuery(seasonPqs, genderValues,
				LCSSEASON, SEASON, SEASON_GENDER_VALUE_KEY);
		// DIVISION - SINGLE
		seasonPqs = LFReportUtil.appendInQuery(seasonPqs, divisionValues,
				LCSSEASON, SEASON, DIVISION_KEY);
		// SEASON YEAR - MULTI SELECT
		seasonPqs = LFReportUtil.appendInQuery(seasonPqs, seasonYearValues,
				LCSSEASON, SEASON, SEASON_YEAR_KEY);
		// SEASON TYPE - MULTI SELECT
		seasonPqs = LFReportUtil.appendInQuery(seasonPqs, seasonTypeValues,
				LCSSEASON, SEASON, SEASON_TYPE_KEY);
		return seasonPqs;
	}

	/**
	 * 
	 * ITC INFOTECH
	 * 
	 * 
	 * @param pqs
	 *            .
	 * @param sampleTypeValues
	 *            .
	 * @return PreparedQueryStatement.
	 */

	private static PreparedQueryStatement getSampleTypeFilterQuery(
			PreparedQueryStatement pqs, List<?> sampleTypeValues) {
		/*
		 * Added for Build 4.24- Product adoption report Enhancement. Added
		 * Sample type Filter Criteria
		 */
		PreparedQueryStatement pqsSampleType = new PreparedQueryStatement();
		pqsSampleType = pqs;
		// SAMPLE TYPE- MULTI SELECT
		if ((sampleTypeValues != null) && !sampleTypeValues.isEmpty()) {
			try {
				// For Accessories/Home/Apparel
				if (ACLHelper.hasViewAccess(FlexTypeCache
						.getFlexTypeFromPath(SEASON_ACC_PATH))
						&& ACLHelper.hasViewAccess(FlexTypeCache
								.getFlexTypeFromPath(SEASON_HOME_PATH))
						&& ACLHelper.hasViewAccess(FlexTypeCache
								.getFlexTypeFromPath(SEASON_APP_PATH))
						&& ACLHelper.hasViewAccess(FlexTypeCache
								.getFlexTypeFromPath(SEASON_FOOTWEAR_PATH))) {
					// ADDITION OF BOTH THE CRITERIAS ATTRIBUTE VALUE OR
					// HIERARCHY TYPE
					pqsSampleType.appendAndIfNeeded();
					pqsSampleType.appendOpenParen();
					Iterator<?> sampleTypeValuesITR = sampleTypeValues
							.iterator();
					pqsSampleType = getSampleTypeAdminQuery(pqsSampleType,
							sampleTypeValuesITR);
					pqsSampleType.appendClosedParen();
				} else {
					// For Accessories/Home
					if (ACLHelper.hasViewAccess(FlexTypeCache
							.getFlexTypeFromPath(SEASON_ACC_PATH))
							|| ACLHelper.hasViewAccess(FlexTypeCache
									.getFlexTypeFromPath(SEASON_HOME_PATH))) {
						// CRITERIAS FOR ATTRIBUTE VALUE
						pqsSampleType.appendInCriteria(LCSSAMPLEREQUEST,
								sampleTypeColumn, sampleTypeValues);
					} else {
						// For Apparel
						// CRITERIAS FOR HIERARCHY TYPE
						pqsSampleType.appendInCriteria(FLEXTYPE, TYPENAME,
								sampleTypeValues);
					}
				}
			} catch (WTException e) {
				// TODO Auto-generated catch block
				LCSLog.error("Exception in getSampleTypeFilterQuery --> "
						+ ExceptionUtils.getStackTrace(e));
				e.printStackTrace();
			}
		}
		return pqsSampleType;
	}

	/**
	 * 
	 * ITCC INFOTECH.
	 * 
	 * 
	 * @param pqs
	 *            .
	 * @param sampleTypeValuesITR
	 *            .
	 * @return PreparedQueryStatement.
	 */

	private static PreparedQueryStatement getSampleTypeAdminQuery(
			PreparedQueryStatement pqs, Iterator<?> sampleTypeValuesITR) {
		while (sampleTypeValuesITR.hasNext()) {
			// ADDITION OF BOTH THE CRITERIAS ATTRIBUTE VALUE OR HIERARCHY TYPE
			String sampleTypeValue = (String) sampleTypeValuesITR.next();
			pqs.appendCriteria(new Criteria(FLEXTYPE, TYPENAME,
					sampleTypeValue, Criteria.EQUALS));
			pqs.appendOrIfNeeded();
			pqs.appendCriteria(new Criteria(LCSSAMPLEREQUEST, sampleTypeColumn,
					sampleTypeValue, Criteria.EQUALS));
			if (sampleTypeValuesITR.hasNext()) {
				pqs.appendOrIfNeeded();
			}
		}
		return pqs;
	}

	/**
	 * 
	 * 13160 Collection
	 * 
	 * @param filterMap
	 *            .
	 * @return void.
	 * @throws RemoteException.
	 * @throws InvocationTargetException.
	 * @throws RemoteException.
	 */

	public void publishReport() throws RemoteException,
			InvocationTargetException {
		Map filterMap = new java.util.HashMap();
		// populate default values in the map from property files
	}

	/**
	 * 
	 * 13160 Collection.
	 * 
	 * @param filterMap
	 * @return Collection<?>.
	 * @throws RemoteException.
	 * @throws InvocationTargetException.
	 */

	public static Collection<?> getData(Map<String, ?> filterMap) {
		Collection adoptionReportResult = null;
		try {
			adoptionReportResult = getProductAdoptionReport(filterMap);
		} catch (WTException e) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in Product Adoption Report :: LFProductAdoptionReportQuery getData()::"
					+ e);
		}
		return adoptionReportResult;
	}

	/**
	 * 
	 * @author ITC Infotech Collection FIXME Timers.
	 * @param searchCriteria
	 *            .
	 * @return lreport.
	 * 
	 */

	public static Collection getProductAdoptionReport(
			Map<String, ?> searchCriteria) throws WTException {

		Collection<?> lreport = new ArrayList();
		init(searchCriteria);
		initConstants();

		// COLLECTION OF SEASON PRODUCT LINEPLAN DETAILS
		final Collection seasonProdCatDescCollection = getSeasonProdCategoryDescDetails();
		// PLACEHOLDER COUNT
		final List<FlexObject> placeholderCountData = LFReportUtil.rollUp(
				seasonProdCatDescCollection, seasonNameIndex,
				productCategoryIndex, descriptionIndex, "", placeholderIndex,
				COUNT);

		// COLLECTION OF SEASON PRODUCT LINEPLAN DETAILS
		final Collection<?> seasonProdCatCollection = LFProductAdoptionQueryHelper
				.getSeasonProdCategoryDetails(searchCriteria);
		// JOINT COLLECTION OF SEASON WITH AND WITHOUT PLACEHOLDER
		seasonProdCatDescCollection.addAll(seasonProdCatCollection);
		
     //Added GBG Build 11 Footwear changes Adoption Report		
		
	 Collection<?> productSampleDetail =null;
	 
	 Collection<?>  productprotoSampleDetail=null;

		// COLLECTION OF PRODUCT SAMPLE DETAILS
		if(divisionValues.contains(footwearDivisions))
		{ 
			productSampleDetail = getProductSalesSampleDetails();
			productprotoSampleDetail= getProductProtoSampleDetails();
		}
		else
		{
			 productSampleDetail = getProductSampleDetails();
		}
		
		//END GBG Build 11 Footwear changes Adoption Report	

		// JOINT COLLECTION OF SEASON PRODUCT LINEPLAN SAMPLE DETAILS
		final Collection<?> seasonProductSampleCountDetail = LFReportUtil.join(
				(Collection<FlexObject>) seasonProdCatDescCollection,
				(Collection<FlexObject>) productSampleDetail, productIndex,
				productIndex, true);
		
		//Added GBG Build 11 Footwear changes Adoption Report
		
		//Sales Sample value added to report
		// JOINT COLLECTION OF SEASON PRODUCT LINEPLAN SAMPLE DETAILS
		 Collection<?> seasonProductSampleCountDetail1=null;
		if(divisionValues.contains(footwearDivisions) && productprotoSampleDetail!=null)
		{
				 seasonProductSampleCountDetail1 = LFReportUtil.join(
						(Collection<FlexObject>) seasonProdCatDescCollection,
						(Collection<FlexObject>) productprotoSampleDetail, productIndex,
						productIndex, true);
		}
				
		//END GBG Build 11 Footwear changes Adoption Report		

		// PLLANNED TO SELL COUNT
		final List<FlexObject> plannedToSellCountData = LFReportUtil.rollUp(
				seasonProdCatDescCollection, seasonNameIndex,
				productCategoryIndex, descriptionIndex, flexPlanIndex,
				plannedToSellIndex, CALCULATE);
		// PRODUCT CREATED IN LINESHEET COUNT
		final List<FlexObject> productCountData = LFReportUtil
				.rollUp(seasonProdCatDescCollection, seasonNameIndex,
						productCategoryIndex, descriptionIndex, "",
						productIndex, COUNT);
		// TOTAL PLANNED LINEITEM VALUE.
		final List<FlexObject> planlineItemCalculatedData = LFReportUtil
				.rollUp(seasonProdCatDescCollection, seasonNameIndex,
						productCategoryIndex, descriptionIndex, flexPlanIndex,
						planToDevelopIndex, CALCULATE);
		// TOTAL ADOPTED PRODUCT
		final List<FlexObject> adoptedCalculatedData = LFReportUtil.rollUp(
				seasonProdCatDescCollection, seasonNameIndex,
				productCategoryIndex, descriptionIndex, productIndex,
				productStatusIndex, CALCULATE);
		// TOTAL SAMPLE CREATED
		final List<FlexObject> sampleCountData = LFReportUtil.rollUp(
				seasonProductSampleCountDetail, seasonNameIndex,
				productCategoryIndex, descriptionIndex, productIndex,
				sampleIndex, CALCULATE);
		// TOTAL SAMPLE QUANTITY VALUE
		final List<FlexObject> sampleQtyCalculatedData = LFReportUtil.rollUp(
				seasonProductSampleCountDetail, seasonNameIndex,
				productCategoryIndex, descriptionIndex, productIndex,
				sampleCountIndex, CALCULATE);
		//Added GBG Build 11 Footwear changes START
		 List<FlexObject> protoSampleQtyCalculatedData=null;
		if(divisionValues.contains(footwearDivisions))
		{
				 protoSampleQtyCalculatedData = LFReportUtil.rollUp(
						seasonProductSampleCountDetail1, seasonNameIndex,
						productCategoryIndex, descriptionIndex, productIndex,
						sampleProtoCountIndex, CALCULATE);
		}
				
		// TOTAL NO OF PROTO SAMPLE TYPE CREATED
		final List<FlexObject> protoSampleCalculatedData = LFReportUtil.rollUp(
				seasonProdCatDescCollection, seasonNameIndex,
				productCategoryIndex, descriptionIndex, flexPlanIndex,
				sampleFlexTypeIndex, CALCULATE);
		
		final List<FlexObject> salesSampleCalculatedData = LFReportUtil.rollUp(
				seasonProdCatDescCollection, seasonNameIndex,
				productCategoryIndex, descriptionIndex, flexPlanIndex,
				PlannedSalesmanSamplesIndex, CALCULATE);
		//END GBG Build 11 Footwear changes START
		
		

		// COLABORATED COLLECTION OF ALL THE RESULT
		lreport = LFReportUtil.join(plannedToSellCountData, productCountData,
				UNIQUEID, UNIQUEID, true);
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
				planlineItemCalculatedData, UNIQUEID, UNIQUEID, true);
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
				adoptedCalculatedData, UNIQUEID, UNIQUEID, true);
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
				sampleCountData, UNIQUEID, UNIQUEID, true);
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
				sampleQtyCalculatedData, UNIQUEID, UNIQUEID, true);
	
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
				placeholderCountData, UNIQUEID, UNIQUEID, true);

		// COSTUM CALCULATION
		lreport = LFReportUtil.rollupCustomCalculation(lreport,
				productStatusIndex, productIndex, adoptionRateIndex);
		lreport = LFReportUtil.rollupCustomCalculation(lreport,
				sampleCountIndex, productStatusIndex, sampleAverageIndex);
		//Added GBG Build 11 Footwear adoption report changes
		
		if(divisionValues.contains(footwearDivisions))
		{
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
					salesSampleCalculatedData, UNIQUEID, UNIQUEID, true);
		
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
					protoSampleCalculatedData, UNIQUEID, UNIQUEID, true);	
			
		lreport = LFReportUtil.join((Collection<FlexObject>) lreport,
					protoSampleQtyCalculatedData, UNIQUEID, UNIQUEID, false);	
		// COSTUM CALCULATION
		lreport = LFReportUtil.rollupCustomCalculation(lreport,
				sampleProtoCountIndex, productStatusIndex, footwearProtoAverage);
		
		lreport = LFReportUtil.rollupCustomCalculation(lreport,
				sampleCountIndex, productStatusIndex, footwearSalesAverage);
		}
		//END GBG Build 11 Footwear adoption report changes

		// DERIVED VALUE EXTRACTION LIKE PRODUCT CATEGORY
		lreport = LFReportUtil.rollupDerivedValues(lreport,
				productCategoryIndex, PRODUCT_CATEGORY_KEY, PRODUCT);
		lreport = LFReportUtil.rollupDerivedValues(lreport, divisionIndex,
				DIVISION_KEY, SEASON);
		// LCSLog.debug("lreport" + lreport);
		return lreport;
	}

	/**
	 * 
	 * ITC INFOTECH. Collection<TableColumn>
	 * 
	 * @return lcolumns.
	 */
	public static Collection<TableColumn> getProductAdoptionReportColumns(String footDivType) {
		
		// INITIALIEZE THE CONSTANTS
		initConstants();

		// TABLE COLUMN INITIALIZATION
		final TableColumn tabSeason = new TableColumn(seasonNameIndex, "Season");
		final TableColumn tabDivision = new TableColumn(divisionIndex,
				"Division");
		final TableColumn tabProductCategory = new TableColumn(
				productCategoryIndex, "Product Category");
		final TableColumn tabDescription = new TableColumn(descriptionIndex,
				"Description");
		final TableColumn tabPlaceHolder = new TableColumn(placeholderIndex,
				"PH Count");
		final TableColumn tabPlannedToSell = new TableColumn(
				plannedToSellIndex, "Product Planned to Sell");
		final TableColumn tabPlanToDevelopItem = new TableColumn(
				planToDevelopIndex, "Product Planned to Develop");
		final TableColumn tabProduct = new TableColumn(productIndex,
				"Product Developed");
		final TableColumn tabProtoSample = new TableColumn(sampleFlexTypeIndex,
				"Total Planned Proto Samples");
		final TableColumn tabSample = new TableColumn(sampleCountIndex,
				"Samples Created");
		//Added GBG Build 11 Footwear changes
		final TableColumn tabSample1 = new TableColumn(sampleCountIndex,
				"Sales Samples Created");
		final TableColumn tabFootProductsToDevelop = new TableColumn(footwearProductsToDevelopIndex,
						"Products Planned to Develop");
		final TableColumn tabFootPlannedSalesmanSamples = new TableColumn(PlannedSalesmanSamplesIndex,
				"Total Planned Salesman Samples");
		
		final TableColumn tabFootPlannedProtoSamples = new TableColumn(footwearTabProtoSample,
				"Total Planned Proto Samples");
		
		final TableColumn tabFootProtoSample = new TableColumn(sampleProtoCountIndex,
				"Proto Samples Created");
		
		final TableColumn tabFootProtoAverage = new TableColumn(footwearProtoAverage,
				"Average # of Proto Sample/Product Adopted");
		final TableColumn tabFootSalesAverage = new TableColumn(footwearSalesAverage,
				"Average # of Sales Sample/Product Adopted");
		//END GBG Build 11 Footwear changes
		final TableColumn tabState = new TableColumn(productStatusIndex,
				"Product Adopted");
		final TableColumn tabAdoptionRate = new TableColumn(adoptionRateIndex,
				"Product Adoption Rate");
		final TableColumn tabSampleAverage = new TableColumn(
				sampleAverageIndex, "Average # of Sample/Product Adopted");

		// Set the Alignment
		tabSeason.setAlign(CENTER);
		tabDivision.setAlign(CENTER);
		tabProductCategory.setAlign(CENTER);
		tabDescription.setAlign(CENTER);
		tabPlaceHolder.setAlign(CENTER);
		tabPlannedToSell.setAlign(CENTER);
		tabPlanToDevelopItem.setAlign(CENTER);
		tabProduct.setAlign(CENTER);
		tabProtoSample.setAlign(CENTER);
		tabSample.setAlign(CENTER);
		//added by manoj
		tabSample1.setAlign(CENTER);
		tabFootProductsToDevelop.setAlign(CENTER);
		tabFootPlannedSalesmanSamples.setAlign(CENTER);
		tabFootPlannedProtoSamples.setAlign(CENTER);
		tabFootProtoSample.setAlign(CENTER);
		tabFootProtoAverage.setAlign(CENTER);
		tabFootSalesAverage.setAlign(CENTER);
		//added by manoj
		tabState.setAlign(CENTER);
		tabAdoptionRate.setAlign(CENTER);
		tabSampleAverage.setAlign(CENTER);

		// Set the Total as true
		tabPlaceHolder.setTotal(true);
		tabPlannedToSell.setTotal(true);
		tabPlanToDevelopItem.setTotal(true);
		tabProduct.setTotal(true);
		tabProtoSample.setTotal(true);
		tabSample.setTotal(true);
		//added by manoj
		tabSample1.setTotal(true);
		tabFootProductsToDevelop.setTotal(true);
		tabFootPlannedSalesmanSamples.setTotal(true);
		tabFootPlannedProtoSamples.setTotal(true);
		tabFootProtoSample.setTotal(true);
		tabFootProtoAverage.setTotal(true);
		tabFootSalesAverage.setTotal(true);
		//added by manoj
		tabState.setTotal(true);
		tabAdoptionRate.setTotal(true);
		tabSampleAverage.setTotal(true);

		// Set the Column Width
		tabSeason.setExcelColumnWidthAutoFitContent(true);
		tabDivision.setExcelColumnWidthAutoFitContent(true);
		tabProductCategory.setExcelColumnWidthAutoFitContent(true);
		tabDescription.setExcelColumnWidthAutoFitContent(true);
		tabPlaceHolder.setExcelColumnWidthAutoFitContent(true);
		tabPlannedToSell.setExcelColumnWidthAutoFitContent(true);
		tabPlanToDevelopItem.setExcelColumnWidthAutoFitContent(true);
		tabProduct.setExcelColumnWidthAutoFitContent(true);
		tabProtoSample.setExcelColumnWidthAutoFitContent(true);
		tabSample.setExcelColumnWidthAutoFitContent(true);
		//added by manoj
		tabSample1.setExcelColumnWidthAutoFitContent(true);
		tabFootProductsToDevelop.setExcelColumnWidthAutoFitContent(true);
		tabFootPlannedSalesmanSamples.setExcelColumnWidthAutoFitContent(true);
		tabFootPlannedProtoSamples.setExcelColumnWidthAutoFitContent(true);
		tabFootProtoSample.setExcelColumnWidthAutoFitContent(true);
		tabFootProtoAverage.setExcelColumnWidthAutoFitContent(true);
		tabFootSalesAverage.setExcelColumnWidthAutoFitContent(true);
		//added by manoj
		tabState.setExcelColumnWidthAutoFitContent(true);
		tabAdoptionRate.setExcelColumnWidthAutoFitContent(true);
		tabSampleAverage.setExcelColumnWidthAutoFitContent(true);

		// Set the Header Wrapper
		tabSeason.setExcelHeaderWrapping(true);
		tabDivision.setExcelHeaderWrapping(true);
		tabProductCategory.setExcelHeaderWrapping(true);
		tabDescription.setExcelHeaderWrapping(true);
		tabPlaceHolder.setExcelHeaderWrapping(true);
		tabPlannedToSell.setExcelHeaderWrapping(true);
		tabPlanToDevelopItem.setExcelHeaderWrapping(true);
		tabProduct.setExcelHeaderWrapping(true);
		tabProtoSample.setExcelHeaderWrapping(true);
		tabSample.setExcelHeaderWrapping(true);
		//Added GBG Build 11 Footwear adoption Report changes START
		tabSample1.setExcelHeaderWrapping(true);
		tabFootProductsToDevelop.setExcelHeaderWrapping(true);
		tabFootPlannedSalesmanSamples.setExcelHeaderWrapping(true);
		tabFootPlannedProtoSamples.setExcelHeaderWrapping(true);
		tabFootProtoSample.setExcelHeaderWrapping(true);
		tabFootProtoAverage.setExcelHeaderWrapping(true);
		tabFootSalesAverage.setExcelHeaderWrapping(true);
		//Added GBG Build 11 Footwear adoption Report changes END
		tabState.setExcelHeaderWrapping(true);
		tabAdoptionRate.setExcelHeaderWrapping(true);
		tabSampleAverage.setExcelHeaderWrapping(true);

		// Set the Integer Format
		tabPlaceHolder.setFormat(FormatHelper.INT_FORMAT);
		tabPlaceHolder.setAttributeType(INTEGER_KEY);
		tabPlaceHolder.setDecimalPrecision(Integer.parseInt(integerPrecision));

		tabPlannedToSell.setFormat(FormatHelper.INT_FORMAT);
		tabPlannedToSell.setAttributeType(INTEGER_KEY);
		tabPlannedToSell
				.setDecimalPrecision(Integer.parseInt(integerPrecision));

		tabPlanToDevelopItem.setFormat(FormatHelper.INT_FORMAT);
		tabPlanToDevelopItem.setAttributeType(INTEGER_KEY);
		tabPlanToDevelopItem.setDecimalPrecision(Integer
				.parseInt(integerPrecision));

		tabProduct.setFormat(FormatHelper.INT_FORMAT);
		tabProduct.setAttributeType(INTEGER_KEY);
		tabProduct.setDecimalPrecision(Integer.parseInt(integerPrecision));

		tabProtoSample.setFormat(FormatHelper.INT_FORMAT);
		tabProtoSample.setAttributeType(INTEGER_KEY);
		tabProtoSample.setDecimalPrecision(Integer.parseInt(integerPrecision));

		//Added for PLM-159 change( int value changed to float)
		tabSample.setFormat(FormatHelper.FLOAT_FORMAT);
		tabSample.setAttributeType(FLOAT_KEY);
		tabSample.setDecimalPrecision(2);

		//Added GBG Build 11 Footwear adoption Report changes START
		tabSample1.setFormat(FormatHelper.FLOAT_FORMAT);
		tabSample1.setAttributeType(FLOAT_KEY);
		tabSample1.setDecimalPrecision(2);
		//Added for PLM-159 change( int value changed to float)
		
		tabFootProductsToDevelop.setFormat(FormatHelper.INT_FORMAT);
		tabFootProductsToDevelop.setAttributeType(INTEGER_KEY);
		tabFootProductsToDevelop.setDecimalPrecision(Integer
				.parseInt(integerPrecision));
		
		tabFootPlannedSalesmanSamples.setFormat(FormatHelper.DOUBLE_FORMAT);
		tabFootPlannedSalesmanSamples.setAttributeType(DOUBLE_KEY);
		tabFootPlannedSalesmanSamples.setDecimalPrecision(2);
		
		tabFootPlannedProtoSamples.setFormat(FormatHelper.INT_FORMAT);
		tabFootPlannedProtoSamples.setAttributeType(INTEGER_KEY);
		tabFootPlannedProtoSamples.setDecimalPrecision(Integer
				.parseInt(integerPrecision));
		
		//Added for PLM-159 change( int value changed to float)
		tabFootProtoSample.setFormat(FormatHelper.FLOAT_FORMAT);
		tabFootProtoSample.setAttributeType(FLOAT_KEY);
		tabFootProtoSample.setDecimalPrecision(2);
		
		tabFootProtoAverage.setFormat(FormatHelper.FLOAT_FORMAT);
		tabFootProtoAverage.setAttributeType(FLOAT_KEY);
		tabFootProtoAverage
				.setDecimalPrecision(2);
		
		tabFootSalesAverage.setFormat(FormatHelper.FLOAT_FORMAT);
		tabFootSalesAverage.setAttributeType(FLOAT_KEY);
		tabFootSalesAverage
				.setDecimalPrecision(2);
		//Added for PLM-159 change ( int value changed to float)
		
		//Added GBG Build 11 Footwear adoption Report changes START
		tabState.setFormat(FormatHelper.INT_FORMAT);
		tabState.setAttributeType(INTEGER_KEY);
		tabState.setDecimalPrecision(Integer.parseInt(integerPrecision));

		tabAdoptionRate.setFormat(FormatHelper.DOUBLE_FORMAT);
		tabAdoptionRate.setAttributeType(DOUBLE_KEY);
		tabAdoptionRate.setDecimalPrecision(2);

		tabSampleAverage.setFormat(FormatHelper.FLOAT_FORMAT);
		tabSampleAverage.setAttributeType(FLOAT_KEY);
		tabSampleAverage
				.setDecimalPrecision(2);

		// ADDITION OF THE COLUMN
		//if (lcolumns.size() <= 0) {
			lcolumns = new ArrayList<TableColumn>();
			if(footDivType.equalsIgnoreCase("gbgFootwear")){
				System.out.println("inside bbbbbbb"+footDivType);
				lcolumns.add(tabSeason);
				lcolumns.add(tabDivision);
				lcolumns.add(tabProductCategory);
				lcolumns.add(tabDescription);
				lcolumns.add(tabProtoSample);
				lcolumns.add(tabFootProtoSample);
				lcolumns.add(tabFootPlannedSalesmanSamples);
				lcolumns.add(tabSample1);
				lcolumns.add(tabPlanToDevelopItem);
				lcolumns.add(tabProduct);
				lcolumns.add(tabState);
				lcolumns.add(tabAdoptionRate);
				lcolumns.add(tabFootProtoAverage);
				lcolumns.add(tabFootSalesAverage);
			}else{
			lcolumns.add(tabSeason);
			lcolumns.add(tabDivision);
			lcolumns.add(tabProductCategory);
			lcolumns.add(tabDescription);
			lcolumns.add(tabPlannedToSell);
			lcolumns.add(tabPlanToDevelopItem);
			lcolumns.add(tabProduct);
			lcolumns.add(tabProtoSample);
			lcolumns.add(tabSample);
			lcolumns.add(tabState);
			lcolumns.add(tabAdoptionRate);
			lcolumns.add(tabSampleAverage);
		}
		return lcolumns;
	}
}
