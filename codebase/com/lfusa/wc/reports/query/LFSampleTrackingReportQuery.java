/**
 * LFSampleTrackingReportQuery
 * Dec 2, 2013
 * 
 */
package com.lfusa.wc.reports.query;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.exception.ExceptionUtils;

import wt.method.RemoteAccess;
import wt.util.WTException;

import com.lcs.wc.client.web.TableColumn;
import com.lcs.wc.db.Criteria;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.db.PreparedQueryStatement;
import com.lcs.wc.db.QueryColumn;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.util.FlexObjectUtil;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;

/**
 * @author 10845.
 * @version 1.0
 * @since Dec 2, 2013
 * 
 *        Updated for Build 5.10 Modified On : 11-Dec-2013 Description : Sample
 *        Tracking report.
 */
public final class LFSampleTrackingReportQuery implements LFReportConstants {

	/**
	 * Private Constructor for Utility Class.
	 */
	private LFSampleTrackingReportQuery() {
	}

	// //////////// Used for Prepared Query ///////////////
	/**
	 * String variable PREPAREDQUERY.
	 */
	private static final String PREPAREDQUERY = "Prepared Query --> ";

	// ///////////// Used for Column Features ///////////////
	/**
	 * String variable CENTER.
	 */
	private static final String CENTER = "center";
	/**
	 * String variable INTEGER_KEY.
	 */
	private static final String INTEGER_KEY = "integer";
	//Sample Quantity decimal change
	/**
	 * String variable FLOAT_KEY.
	 */
	private static final String FLOAT_KEY = "float";
	//Sample Quantity decimal change
	/**
	 * Collection<TableColumn> variable lcolumns.
	 */
	final static Collection<TableColumn> lcolumns = new ArrayList<TableColumn>();
	/**
	 * Collection<TableColumn> variable lcolumns.
	 */
	final static Collection<TableColumn> groupByColumns = new ArrayList<TableColumn>();
	/**
	 * String integer precision.
	 */
	private static final String integerPrecision = LCSProperties.get(
			"com.lfusa.reports.productAdoptionReport.integerPrecisionValue",
			"0");

	/**
	 * Initialization of the Criteria value used.
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
	 * List of Licensor Value.
	 */
	private static List<?> licensorValues = new ArrayList<Object>();
	/**
	 * List of Property Value.
	 */
	private static List<?> propertyValues = new ArrayList<Object>();
	/**
	 * List of Customer Value.
	 */
	private static List<?> customerValues = new ArrayList<Object>();
	/**
	 * List of Brand Value.
	 */
	private static List<?> brandValues = new ArrayList<Object>();
	/**
	 * List of Product category Value.
	 */
	private static List<?> productCategoryValues = new ArrayList<Object>();
	/**
	 * List of Season Value.
	 */
	private static String seasonValue = "";
	/**
	 * Initialization of DB Column/Variable names used
	 */
	private static String seasonNameColumn = "";
	/**
	 * Product productCategory Column.
	 */
	private static String prodProdCatColumn = "";
	/**
	 * Sample Quantity Column.
	 */
	private static String sampleQuantityCountColumn = "";
	//Added for PLM-159 change
	/**
	 * SampleQuantity OldColumn.
	 */
	protected static String oldSampleQuantityCountColumn = "";
	//Added for PLM-159 change
	/**
	 * Sample Status Column.
	 */
	private static String sampleStatusColumn = "";
	/**
	 * Vendor User Group Column.
	 */
	private static String vendorUserColumn = "";
	/**
	 * Overseas Office Column.
	 */
	private static String overseasOfficeColumn = "";

	/**
	 * Season Index.
	 */
	private static String seasonIndex = "";
	/**
	 * Product category Index.
	 */
	private static String productCategoryIndex = "";
	/**
	 * Vendor User Group Index.
	 */
	private static String vendorUserIndex = "";
	/**
	 * Sample Quantity Index.
	 */
	private static String sampleQuantityCountIndex = "";
	/**
	 * Sample Status Index.
	 */
	private static String sampleStatusIndex = "";
	/**
	 * Sample Index.
	 */
	private static String sampleIndex = "";
	/**
	 * DEBUG.
	 */
	public static final boolean DEBUG;
	/**
	 * Debug Statement.
	 */
	static {
		DEBUG = true;
		// LCSProperties
		// .getBoolean("rfa.lfusa.jsp.reports.LFSampleTrackingReport.verbose");
	}

	/**
	 * 
	 * ITC INfotech void
	 * 
	 * @param searchCriteria
	 */
	private static void init(Map<String, ?> searchCriteria) {

		// The values from the request map with all the criteria
		divisionValues = (List<?>) searchCriteria.get(SEARCH_DIVISION);
		seasonYearValues = (List<?>) searchCriteria.get(SEARCH_SEASON_YEAR);
		seasonTypeValues = (List<?>) searchCriteria.get(SEARCH_SEASON_TYPE);
		genderValues = (List<?>) searchCriteria.get(SEARCH_GENDER_VALUE);
		productCategoryValues = (List<?>) searchCriteria
				.get(SEARCH_PRODUCT_CATEGORY);
		seasonValue = (String) searchCriteria.get(SEARCH_SEASON);

		licensorValues = (List<?>) searchCriteria.get(SEARCH_LICENSOR);
		propertyValues = (List<?>) searchCriteria.get(SEARCH_PROPERTY);
		customerValues = (List<?>) searchCriteria.get(SEARCH_CUSTOMER);
		brandValues = (List<?>) searchCriteria.get(SEARCH_BRAND);
	}

	/**
	 * 
	 * ITC Infotech. void
	 * 
	 * @return void.
	 */
	private static void initConstants() {

		// Name of the DatabaseColumn/VariableName used up in Querying
		// Season -- Name
		seasonNameColumn = LFReportUtil.getColumnName(SEASON_NAME_KEY, SEASON);
		// RevisibleEntity -- vendorGroup
		vendorUserColumn = LFReportUtil.getColumnName(VENDOR_USER_KEY,
				OVERSEAS_OFFICE);
		// Product -- Product Category
		prodProdCatColumn = LFReportUtil.getColumnName(PRODUCT_CATEGORY_KEY,
				PRODUCT);
		// Sample -- lfSampleQuantity
		sampleQuantityCountColumn = LFReportUtil.getColumnName(
				SAMPLEQUANTITY_KEY, SAMPLE);
		//Added for PLM-159 change
		oldSampleQuantityCountColumn= LFReportUtil.getColumnName(
				OLDSAMPLEQUANTITY_KEY, SAMPLE);
		//Added for PLM-159 change
		// Sample -- sampleStatus
		sampleStatusColumn = LFReportUtil.getColumnName(SAMPLE_STATUS_KEY,
				SAMPLE);
		// SampleRequest -- lfOverseasOffice
		overseasOfficeColumn = LFReportUtil.getColumnName(SAMPLE_SOURCE_KEY,
				SAMPLE);

		seasonIndex = LCSSEASON + "." + IDA2A2;
		productCategoryIndex = PRODAREV + "." + prodProdCatColumn;
		vendorUserIndex = LCSREVISABLEENTITY + "." + vendorUserColumn;
		sampleIndex = LCSSAMPLE + "." + IDA2A2;
		sampleQuantityCountIndex = LCSSAMPLE + "." + sampleQuantityCountColumn;
		sampleStatusIndex = LCSSAMPLE + "." + sampleStatusColumn;

	}

	// SELECT LCSSEASON.att1,LCSSEASON.IDA2A2, PRODAREV.att61,PRODAREV.IDA2A2,
	// LCSSAMPLE.ATT1, LCSSAMPLE.IDA2A2 FROM LCSSEASON LCSSEASON, PRODAREV
	// PRODAREV, LCSSEASONPRODUCTLINK LCSSEASONPRODUCTLINK, LCSSAMPLE LCSSAMPLE
	// WHERE LCSSEASONPRODUCTLINK.PRODUCTMASTERID = PRODAREV.IDA3MASTERREFERENCE
	// AND LCSSEASONPRODUCTLINK.SEASONREVID = LCSSEASON.BRANCHIDITERATIONINFO
	// AND PRODAREV.IDA3MASTERREFERENCE = LCSSAMPLE.IDA3B10 AND
	// LCSSEASONPRODUCTLINK.SEASONREMOVED = '0' AND
	// LCSSEASONPRODUCTLINK.EFFECTLATEST = '1' AND
	// LCSSEASONPRODUCTLINK.SEASONLINKTYPE = 'PRODUCT' AND
	// PRODAREV.LATESTITERATIONINFO = '1' AND
	// UPPER(PRODAREV.VERSIONIDA2VERSIONINFO) = 'A' AND
	// LCSSEASON.LATESTITERATIONINFO = '1'

	private static Collection<?> getSeasonProdCategorySampleDetails() {
		// TODO Auto-generated method stub
		final long startTime = System.currentTimeMillis();

		final PreparedQueryStatement pqs = new PreparedQueryStatement();

		// SELECT TABLES
		pqs.appendFromTable(LCSSEASON, LCSSEASON);
		pqs.appendFromTable(PRODAREV, PRODAREV);
		pqs.appendFromTable(LCSSEASONPRODUCTLINK, LCSSEASONPRODUCTLINK);
		pqs.appendFromTable(LCSSAMPLE, LCSSAMPLE);

		// SELECT COLUMN
		pqs.appendSelectColumn(LCSSEASON, seasonNameColumn);
		pqs.appendSelectColumn(PRODAREV, prodProdCatColumn);
		pqs.appendSelectColumn(LCSSAMPLE, ATT1);
		pqs.appendSelectColumn(LCSSEASON, IDA2A2);
		pqs.appendSelectColumn(PRODAREV, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, IDA2A2);

		/**
		 * To link Season, Product, Sourcing Configuration and Sample.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSEASONPRODUCTLINK, "PRODUCTMASTERID", PRODAREV,
				IDA3MASTERREFERENCE);
		pqs.appendJoin(LCSSEASONPRODUCTLINK, "SEASONREVID", LCSSEASON,
				BRANCHIDITERATIONINFO);
		pqs.appendJoin(PRODAREV, IDA3MASTERREFERENCE, LCSSAMPLE, "IDA3B10");

		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASONPRODUCTLINK,
				"SEASONLINKTYPE"), PRODUCT, Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASONPRODUCTLINK,
				"SEASONREMOVED"), "0", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASONPRODUCTLINK,
				"EFFECTLATEST"), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
				VERSIONIDA2VERSIONINFO), "A", Criteria.EQUALS, true));
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASON,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));

		// FILTER CRITERIA FOR SEASON
		PreparedQueryStatement seasonPqs = new PreparedQueryStatement();
		seasonPqs = getSeasonFilterQuery(pqs);
		// FILTER CRITERIA FOR PRODUCT
		PreparedQueryStatement productPqs = new PreparedQueryStatement();
		productPqs = getProductFilterQuery(seasonPqs);
		// FILTER CRITERIA FOR PRODUCT and Season
		PreparedQueryStatement productSeasonPqs = new PreparedQueryStatement();
		productSeasonPqs = getSeasonProductFilterQuery(productPqs);

		if (LFReportUtil.isNotBlank(seasonValue)) {
			productSeasonPqs.appendAndIfNeeded();
			productSeasonPqs.appendCriteria(new Criteria(new QueryColumn(
					LCSSEASON, IDA2A2), "%" + seasonValue + "%", Criteria.LIKE,
					false));
		}

		if (DEBUG) {
			LCSLog.debug(PREPAREDQUERY + productSeasonPqs.toString());
		}
		Collection<?> results = null;
		try {
			results = LCSQuery.runDirectQuery(productSeasonPqs).getResults();
		} catch (WTException ex) {
			LCSLog.error("Exception in getSeasonProdCategorySampleDetails --> "
					+ ExceptionUtils.getStackTrace(ex));
		}

		final long endTime = System.currentTimeMillis();
		final long totalTime = endTime - startTime;
		if (DEBUG) {
			LCSLog.debug("Method getSeasonProdCategorySampleDetails Time taken for execution --> "
					+ totalTime);
		}
		return results;
	}

	// SELECT LCSSAMPLEREQUEST.ATT2, LCSSAMPLEREQUEST.NUM4,
	// LCSSAMPLE.IDA2A2,LCSREVISABLEENTITY.ATT1,LCSREVISABLEENTITY.ATT2 FROM
	// LCSSAMPLE LCSSAMPLE, LCSSAMPLEREQUEST LCSSAMPLEREQUEST,
	// LCSREVISABLEENTITY LCSREVISABLEENTITY WHERE
	// LCSSAMPLE.IDA3E10 = LCSSAMPLEREQUEST.IDA2A2 AND
	// LCSSAMPLEREQUEST.NUM4 = LCSREVISABLEENTITY.BRANCHIDITERATIONINFO

	private static Collection<?> getRequestSampleOverseasOfficeDetails() {

		final long startTime = System.currentTimeMillis();

		final PreparedQueryStatement pqs = new PreparedQueryStatement();

		// SELECT TABLES
		pqs.appendFromTable(LCSSAMPLEREQUEST, LCSSAMPLEREQUEST);
		pqs.appendFromTable(LCSSAMPLE, LCSSAMPLE);
		pqs.appendFromTable(LCSREVISABLEENTITY, LCSREVISABLEENTITY);

		// SELECT COLUMN
		pqs.appendSelectColumn(LCSSAMPLEREQUEST, overseasOfficeColumn);
		pqs.appendSelectColumn(LCSREVISABLEENTITY, ATT1);
		pqs.appendSelectColumn(LCSREVISABLEENTITY, vendorUserColumn);
		pqs.appendSelectColumn(LCSSAMPLE, IDA2A2);
		pqs.appendSelectColumn(LCSSAMPLE, sampleStatusColumn);
		pqs.appendSelectColumn(LCSSAMPLE, sampleQuantityCountColumn);
		//Added for PLM-159 change( int value changed to float)
		pqs.appendSelectColumn(LCSSAMPLE, oldSampleQuantityCountColumn);
		//Added for PLM-159 change( int value changed to float)

		/**
		 * To link Season, Product, Sourcing Configuration and Sample.
		 */
		// JOIN QUERY
		pqs.appendJoin(LCSSAMPLE, "IDA3E10", LCSSAMPLEREQUEST, IDA2A2);
		pqs.appendJoin(LCSSAMPLEREQUEST, overseasOfficeColumn,
				LCSREVISABLEENTITY, BRANCHIDITERATIONINFO);

		// SEARCH QUERY
		pqs.appendAndIfNeeded();
		pqs.appendCriteria(new Criteria(new QueryColumn(LCSREVISABLEENTITY,
				LATESTITERATIONINFO), "1", Criteria.EQUALS, true));

		if (DEBUG) {
			LCSLog.debug(PREPAREDQUERY + pqs.toString());
		}
		Collection<?> results = null;
		try {
			results = LCSQuery.runDirectQuery(pqs).getResults();
		} catch (WTException ex) {
			LCSLog.error("Exception in getRequestSampleOverseasOfficeDetails --> "
					+ ExceptionUtils.getStackTrace(ex));
		}

		final long endTime = System.currentTimeMillis();
		final long totalTime = endTime - startTime;
		if (DEBUG) {
			LCSLog.debug("Method getRequestSampleOverseasOfficeDetails Time taken for execution --> "
					+ totalTime);
		}
		return results;
	}

	/**
	 * 
	 * ITC INFOTECH. PreparedQueryStatement.
	 * 
	 * @param pqs
	 *            .
	 * @return seasonPqs.
	 */
	private static PreparedQueryStatement getSeasonFilterQuery(
			PreparedQueryStatement pqs) {
		// TODO Auto-generated method stub
		PreparedQueryStatement seasonPqs = new PreparedQueryStatement();
		seasonPqs = pqs;
		// FILTER CRITERIA FOR SEASON
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
	 * ITC INFOTECH. PreparedQueryStatement.
	 * 
	 * @param pqs
	 *            .
	 * @return productPqs.
	 */

	private static PreparedQueryStatement getProductFilterQuery(
			PreparedQueryStatement pqs) {
		// TODO Auto-generated method stub
		PreparedQueryStatement productPqs = new PreparedQueryStatement();
		productPqs = pqs;

		// FILTER CRITERIA FOR SEASON
		// LICENSOR - MULTI SELECT
		productPqs = LFReportUtil.appendInQuery(productPqs, licensorValues,
				PRODAREV, PRODUCT, PRODUCT_LICENSOR_KEY);
		// PROPERTY - MULTI SELECT
		productPqs = LFReportUtil.appendInQuery(productPqs, propertyValues,
				PRODAREV, PRODUCT, PRODUCT_PROPERTY_KEY);
		// BRAND - MULTI SELECT
		productPqs = LFReportUtil.appendInQuery(productPqs, brandValues,
				PRODAREV, PRODUCT, PRODUCT_BRAND_KEY);
		// CUSTOMER - MULTI SELECT
		productPqs = LFReportUtil.appendInQuery(productPqs, customerValues,
				PRODAREV, PRODUCT, PRODUCT_CUSTOMER_KEY);
		// PRODUCT CATEGORY - MULTI SELECT
		productPqs = LFReportUtil.appendInQuery(productPqs,
				productCategoryValues, PRODAREV, PRODUCT, PRODUCT_CATEGORY_KEY);
		// Return
		return productPqs;
	}

	/**
	 * 
	 * ITC Infotech. PreparedQueryStatement.
	 * 
	 * @param pqs
	 *            .
	 * @return pqs.
	 */
	private static PreparedQueryStatement getSeasonProductFilterQuery(
			PreparedQueryStatement pqs) {
		// TODO Auto-generated method stub
		// GENDER MULTI SELECT
		if ((genderValues != null) && !genderValues.isEmpty()) {
			pqs.appendAndIfNeeded();
			pqs.appendOpenParen();
			Iterator<?> itr = genderValues.iterator();
			while (itr.hasNext()) {
				String genderValue = (String) itr.next();

				pqs.appendOpenParen();
				pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASON,
						LFReportUtil.getColumnName(SEASON_GENDER_VALUE_KEY,
								SEASON)), genderValue, Criteria.EQUALS, true));
				pqs.appendAndIfNeeded();
				pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
						LFReportUtil.getColumnName(PRODUCT_GENDER_VALUE_KEY,
								PRODUCT)), genderValue, Criteria.EQUALS, true));
				pqs.appendClosedParen();
				if (itr.hasNext()) {
					pqs.appendOrIfNeeded();
				}
			}
			pqs.appendClosedParen();

		}
		// DIVISION MULTI SELECT
		if ((divisionValues != null) && !divisionValues.isEmpty()) {
			pqs.appendAndIfNeeded();
			pqs.appendOpenParen();

			Iterator<?> itr1 = divisionValues.iterator();
			while (itr1.hasNext()) {
				String divisionValue = (String) itr1.next();

				pqs.appendOpenParen();

				pqs.appendCriteria(new Criteria(new QueryColumn(LCSSEASON,
						LFReportUtil.getColumnName(DIVISION_KEY, SEASON)), "%"
						+ divisionValue + "%", Criteria.LIKE, false));
				pqs.appendAndIfNeeded();
				pqs.appendCriteria(new Criteria(new QueryColumn(PRODAREV,
						LFReportUtil.getColumnName(DIVISION_KEY, PRODUCT)), "%"
						+ divisionValue + "%", Criteria.LIKE, false));
				pqs.appendClosedParen();
				if (itr1.hasNext()) {
					pqs.appendOrIfNeeded();
				}
			}
			pqs.appendClosedParen();
		}

		return pqs;
	}

	/**
	 * 
	 * 13160 Collection.
	 * 
	 * @param filterMap
	 *            .
	 * @return void.
	 * @throws RemoteException.
	 * @throws InvocationTargetException.
	 */

	public static Collection<?> getSampleTrackingData(Map<String, ?> filterMap) {
		Collection sampleReportResult = null;
		try {
			sampleReportResult = getSampleTrackingReport(filterMap);
		} catch (WTException e) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in Sample Tracking Report :: LFSampleTrackingReportQuery getSampleTrackingData()::"
					+ e);
		}
		return sampleReportResult;
	}

	/**
	 * 
	 * @author ITC Infotech . Collection FIXME Timers.
	 * @param searchCriteria
	 *            .
	 * @return lreport.
	 * 
	 */

	public static Collection<?> getSampleTrackingReport(
			Map<String, ?> searchCriteria) throws WTException {

		// Collection<?> lreport = new ArrayList();
		init(searchCriteria);
		initConstants();
		Collection<?> lreport = new ArrayList();
		if (DEBUG) {
			LCSLog.debug("Start Extraction - getSampleTrackingReport");
		}

		// List of all the Season, Product and Source
		final Collection<?> seasonProdCategorySample = getSeasonProdCategorySampleDetails();
		// List of all the Product and Source and Sample
		final Collection<?> requestSampleOverseasOffice = getRequestSampleOverseasOfficeDetails();

		// Complete list of Season, Product, Source and Sample
		lreport = FlexObjectUtil.join(
				(Collection<FlexObject>) seasonProdCategorySample,
				(Collection<FlexObject>) requestSampleOverseasOffice,
				sampleIndex, sampleIndex, true);

		// Combined Data
		// if (DEBUG) {
		// LCSLog.debug("Combined Data" + lreport);
		// }

		// PRODUCT CATEGORY AND SOURCE ROLL UP
		final List<FlexObject> prodCategorySourceData = LFReportUtil.rollUp(
				seasonProdCategorySample, "", productCategoryIndex,
				vendorUserIndex, "", "", "");
		// SAMPLE QUANTITY COUNT
		final List<FlexObject> sampleQuantityCountData = LFReportUtil.rollUp(
				lreport, "", productCategoryIndex, vendorUserIndex,
				sampleIndex, sampleQuantityCountIndex, CALCULATE);
		// SAMPLE STATUS COUNT
		final List<FlexObject> sampleStatusCountData = LFReportUtil.rollUp(
				lreport, "", productCategoryIndex, vendorUserIndex, "",
				sampleStatusIndex, "");

		// COLABORATED COLLECTION OF ALL THE RESULT
		lreport = FlexObjectUtil.join(prodCategorySourceData,
				sampleQuantityCountData, UNIQUEID, UNIQUEID, true);
		lreport = FlexObjectUtil.join((Collection<FlexObject>) lreport,
				(Collection<FlexObject>) sampleStatusCountData, UNIQUEID,
				UNIQUEID, true);

		lreport = LFReportUtil.rollupDerivedValues(lreport,
				productCategoryIndex, PRODUCT_CATEGORY_KEY, PRODUCT);
		if (DEBUG) {
			LCSLog.debug(" End Data" + lreport);
		}

		return lreport;
	}

	/**
	 * 
	 * Itc Infotech. Map<String,String>.
	 * 
	 * @param searchCriteria
	 *            .
	 * @return seasonSingleDynamicListMap.
	 */
	public static Map<String, String> getSeasonNameListDetails(
			Map<String, ?> searchCriteria) {
		if (DEBUG) {
			LCSLog.debug("Season Name, search Criteria : " + searchCriteria);
		}
		init(searchCriteria);
		initConstants();
		Map<String, String> seasonSingleDynamicListMap = new HashMap<String, String>();
		Collection<?> lreport = new ArrayList();
		lreport = getSeasonProdCategorySampleDetails();
		seasonSingleDynamicListMap = LFReportUtil.rollupGetSeasonNameList(
				lreport, seasonIndex);
		if (DEBUG) {
			LCSLog.debug("seasonSingleDynamicListMap : "
					+ seasonSingleDynamicListMap);
		}
		return seasonSingleDynamicListMap;

	}

	/**
	 * 
	 * ITC Infotech. Collection<TableColumn>.
	 * 
	 * @return lcolumns.
	 */
	public static Collection<TableColumn> getSampleTrackingReportColumns() {

		initConstants();
		final TableColumn tabProductCategory = new TableColumn(
				productCategoryIndex, "Product Category");
		final TableColumn tabSource = new TableColumn(vendorUserIndex,
				"Vendor User Group");
		final TableColumn tabTotalSamples = new TableColumn(
				sampleQuantityCountIndex, "Total Samples");
		final TableColumn tabSamplesSubmitted = new TableColumn(SUBMITTEDINDEX,
				"Samples Submitted");
		final TableColumn tabamplesApproved = new TableColumn(APPROVEDINDEX,
				"Samples Approved");
		final TableColumn tabSamplesDropped = new TableColumn(DROPPEDINDEX,
				"Samples Dropped");
		final TableColumn tabSamplesReworked = new TableColumn(REWORKINDEX,
				"Samples Reworked");

		// Set the Alignment
		tabProductCategory.setAlign(CENTER);
		tabSource.setAlign(CENTER);
		tabTotalSamples.setAlign(CENTER);
		tabSamplesSubmitted.setAlign(CENTER);
		tabamplesApproved.setAlign(CENTER);
		tabSamplesDropped.setAlign(CENTER);
		tabSamplesReworked.setAlign(CENTER);

		// Set the Total as true
		tabTotalSamples.setTotal(true);
		tabSamplesSubmitted.setTotal(true);
		tabamplesApproved.setTotal(true);
		tabSamplesDropped.setTotal(true);
		tabSamplesReworked.setTotal(true);

		// Set the Column Width
		tabProductCategory.setExcelColumnWidthAutoFitContent(true);
		tabSource.setExcelColumnWidthAutoFitContent(true);
		tabTotalSamples.setExcelColumnWidthAutoFitContent(true);
		tabSamplesSubmitted.setExcelColumnWidthAutoFitContent(true);
		tabamplesApproved.setExcelColumnWidthAutoFitContent(true);
		tabSamplesDropped.setExcelColumnWidthAutoFitContent(true);
		tabSamplesReworked.setExcelColumnWidthAutoFitContent(true);

		// Set the Header Wrapper
		tabProductCategory.setExcelHeaderWrapping(true);
		tabSource.setExcelHeaderWrapping(true);
		tabTotalSamples.setExcelHeaderWrapping(true);
		tabSamplesSubmitted.setExcelHeaderWrapping(true);
		tabamplesApproved.setExcelHeaderWrapping(true);
		tabSamplesDropped.setExcelHeaderWrapping(true);
		tabSamplesReworked.setExcelHeaderWrapping(true);

		// Set the Integer Format

		//Added for PLM-159 change
		tabTotalSamples.setFormat(FormatHelper.FLOAT_FORMAT);
		tabTotalSamples.setAttributeType(FLOAT_KEY);
		tabTotalSamples.setDecimalPrecision(2);
		//Added for PLM-159 change

		tabSamplesSubmitted.setFormat(FormatHelper.INT_FORMAT);
		tabSamplesSubmitted.setAttributeType(INTEGER_KEY);
		tabSamplesSubmitted.setDecimalPrecision(Integer
				.parseInt(integerPrecision));

		tabamplesApproved.setFormat(FormatHelper.INT_FORMAT);
		tabamplesApproved.setAttributeType(INTEGER_KEY);
		tabamplesApproved.setDecimalPrecision(Integer
				.parseInt(integerPrecision));

		tabSamplesDropped.setFormat(FormatHelper.INT_FORMAT);
		tabSamplesDropped.setAttributeType(INTEGER_KEY);
		tabSamplesDropped.setDecimalPrecision(Integer
				.parseInt(integerPrecision));

		tabSamplesReworked.setFormat(FormatHelper.INT_FORMAT);
		tabSamplesReworked.setAttributeType(INTEGER_KEY);
		tabSamplesReworked.setDecimalPrecision(Integer
				.parseInt(integerPrecision));

		if (lcolumns.size() <= 0) {
			lcolumns.add(tabProductCategory);
			lcolumns.add(tabSource);
			lcolumns.add(tabTotalSamples);
			lcolumns.add(tabSamplesSubmitted);
			lcolumns.add(tabamplesApproved);
			lcolumns.add(tabSamplesDropped);
			lcolumns.add(tabSamplesReworked);
		}
		return lcolumns;
	}

	/**
	 * 
	 * ITC Infotech. Collection<TableColumn>.
	 * 
	 * @return groupByColumns.
	 */
	public static Collection<TableColumn> getGroupByColumns() {
		initConstants();
		final TableColumn tabProductCategory = new TableColumn(
				productCategoryIndex, "Product Category");
		// Set the Alignment
		tabProductCategory.setAlign(CENTER);
		// Set the Column Width
		tabProductCategory.setExcelColumnWidthAutoFitContent(true);
		// Set the Header Wrapper
		tabProductCategory.setExcelHeaderWrapping(true);

		if (groupByColumns.size() <= 0) {
			groupByColumns.add(tabProductCategory);
		}
		return groupByColumns;
	}
}
