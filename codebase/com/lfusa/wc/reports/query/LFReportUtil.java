package com.lfusa.wc.reports.query;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.exception.ExceptionUtils;
import wt.util.WTException;
import com.lcs.wc.db.Criteria;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.db.PreparedQueryStatement;
import com.lcs.wc.db.QueryColumn;
import com.lcs.wc.db.SearchResults;
import com.lcs.wc.flextype.FlexType;
import com.lcs.wc.flextype.FlexTypeAttribute;
import com.lcs.wc.flextype.FlexTypeCache;
import com.lcs.wc.foundation.LCSLifecycleManagedQuery;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.season.LCSSeason;
import com.lcs.wc.supplier.LCSSupplier;
import com.lcs.wc.util.FlexObjectUtil;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;

/**
 * @version 1.0
 * @author ITCInfotech.
 * 
 */
public final class LFReportUtil extends FlexObjectUtil implements
		LFReportConstants {

	/**
	 * Private Constructor for Utility Class
	 */
	private LFReportUtil() {

	}

	/**
	 * Method to roll up data in Collection.
	 * 
	 * @author ITC Infotech.
	 * @param data
	 *            Collection of SQL Output.
	 * @param strReference
	 *            Reference for rolling.
	 * @param index
	 *            Where to Roll on.
	 * @return Collection of rolled data.
	 */
	public static Collection rollupData(Collection data, String strReference,
			String index) {
		long startTime = System.currentTimeMillis();
		ArrayList mergedData = new ArrayList();
		if ((data != null) && (data.size() > 0)) {
			Iterator iter = data.iterator();
			FlexObject fob = null;
			String indexData = null;
			String dataValue = null;
			HashMap tmp = new HashMap();
			while (iter.hasNext()) {
				fob = (FlexObject) iter.next();
				indexData = fob.getString(strReference);
				dataValue = fob.getString(index);
				tmp = new HashMap();
				tmp.put(index, dataValue);
				tmp.put(strReference, indexData);
				if (mergedData.size() != 0) {
					boolean tmpFlag = false;
					for (int i = 0; i < mergedData.size(); i++) {
						FlexObject tempObj = (FlexObject) mergedData.get(i);
						if (indexData.equalsIgnoreCase(tempObj
								.getString(strReference))) {
							tmpFlag = true;
							Float tmpVal = Float.valueOf(dataValue)
									+ Float.valueOf(tempObj.getString(index));
							tempObj.setData(index, String.valueOf(tmpVal));
						}
					}
					if (!tmpFlag) {
						FlexObject tmpObj = new FlexObject();
						tmpObj.putAll(tmp);
						mergedData.add(tmpObj);
					}
				} else {
					FlexObject tmpObj = new FlexObject();
					tmpObj.putAll(tmp);
					mergedData.add(tmpObj);
				}
			}
		}
		long endTime = System.currentTimeMillis();
		long totalTime = endTime - startTime;
		return mergedData;
	}

	/**
	 * Method to grouping up data in Collection.
	 * 
	 * @author ITC Infotech.
	 * @param data
	 *            Collection of SQL data
	 * @param index
	 *            variable to index on.
	 * @param groupOnKey
	 *            group by Key.
	 * @return Collection of grouped data.
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Collection groupData(Collection data, String index,
			String groupOnKey) {

		long startTime = System.currentTimeMillis();
		Collection coll = new ArrayList();
		Map finalFob = new HashMap();
		if ((data != null) && (data.size() > 0)) {
			Iterator iter = data.iterator();
			FlexObject fob = null;
			String seasonName = null;
			String dataId = null;

			Set componentData = new HashSet();
			while (iter.hasNext()) {

				fob = (FlexObject) iter.next();

				seasonName = fob.getString(index);
				dataId = fob.getString(groupOnKey);
				if (finalFob.containsKey(seasonName)) {
					componentData = (HashSet) finalFob.get(seasonName);
					componentData.add(dataId);
					finalFob.put(seasonName, componentData);

				} else {
					Set tmpplaceHolderData = new HashSet();
					dataId = fob.getString(groupOnKey);
					if (isNotBlank(dataId)) {
						tmpplaceHolderData.add(dataId);
					}
					finalFob.put(seasonName, tmpplaceHolderData);
				}

			}

		}

		coll = covertToCollection(finalFob, index, groupOnKey);
		// convertMapToFlexObject(finalFob));
		long endTime = System.currentTimeMillis();
		long totalTime = endTime - startTime;
		return coll;
	}

	/**
	 * Method to filtering data by state.
	 * 
	 * @author ITC Infotech.
	 * @param data
	 *            Collection of data.
	 * @param index
	 *            Key to filter on.
	 * @param sStateName
	 *            State Name.
	 * @return Collection of filtered items
	 */
	public static Collection filterByState(Collection data, String index,
			String sStateName) {

		Collection retList = new ArrayList();
		FlexObject fob;
		String indexData = null;
		if ((data != null) && (data.size() > 0)) {
			Iterator iter = data.iterator();

			while (iter.hasNext()) {
				fob = (FlexObject) iter.next();
				indexData = fob.getString(index);

				if (StringUtils.isNotBlank(indexData)
						&& sStateName.equalsIgnoreCase(indexData)) {
					retList.add(fob);
				}
			}

		}

		return retList;
	}

	/**
	 * Method to convert Map to Collection of Objs.
	 * 
	 * @author ITC Infotech.
	 * @param data
	 *            Collection of data.
	 * @param index
	 *            Key to iterate.
	 * @param groupOnKey
	 *            key to group on.
	 * @return Collection of objects
	 */
	private static Collection covertToCollection(Map fob, String index,
			String groupOnKey) {

		Collection list = new ArrayList();
		FlexObject fMap;
		for (Object key : fob.keySet()) {
			Set value = (Set) fob.get(key);

			fMap = new FlexObject();
			fMap.put(index, key);
			fMap.put(groupOnKey, value.size());
			list.add(fMap);

		}
		return list;
	}

	/**
	 * Over-ridden isNotBlank to handle "null" condition.
	 * 
	 * @author ITC Infotech.
	 * @param str
	 *            String to check on.
	 * @return boolean true/false
	 */
	public static boolean isNotBlank(String str) {
		boolean bCheck = false;
		if (StringUtils.isNotBlank(str) && !str.equalsIgnoreCase("null")) {
			bCheck = true;
		}
		return bCheck;
	}

	/**
	 * 
	 * Method to count data by state.
	 * 
	 * @author ITC Infotech.
	 * 
	 * @param vSeasonProducts
	 *            Collection of Season Product Data
	 * @param seasonName
	 *            String of Season Name
	 * @param adoptedStateKey
	 *            Key of Adopted State
	 * @param adopted
	 *            Name of Adopted State
	 * @return Collection of objects
	 */

	public static Collection countDataByState(Collection vSeasonProducts,
			String seasonName, String adoptedStateKey, String adopted) {
		Map finalFob = new HashMap();
		FlexObject fob;
		String indexData = null;
		Map mp = groupIntoCollections(vSeasonProducts, seasonName);

		for (Object key : mp.keySet()) {
			Collection value = (Collection) mp.get(key);

			Iterator iter = value.iterator();
			int i = 0;
			while (iter.hasNext()) {
				fob = (FlexObject) iter.next();
				indexData = fob.getString(adoptedStateKey);

				if (StringUtils.isNotBlank(indexData)
						&& adopted.equalsIgnoreCase(indexData)) {
					i++;
				}
			}

			finalFob.put(key, i);

		}
		Collection coll = new ArrayList();
		FlexObject fMap;
		for (Object key : finalFob.keySet()) {
			int value = (Integer) finalFob.get(key);

			fMap = new FlexObject();
			fMap.put(SEASON_NAME, key);
			fMap.put(adoptedStateKey, value);

			coll.add(fMap);

		}
		return coll;
	}

	// private static Collection<?> groupByData(Collection<?> collection,
	// String index) {
	//
	// Collection<?> groupedByData = null;
	// Map<?, ?> groupedByIndexCollection = groupIntoCollections(collection,
	// index);
	// // LCSLog.debug("groupedIntoSeason : " + groupedIntoSeason);
	// // Iterating through the Collection of Flexobject in one Season
	// for (Object key : groupedByIndexCollection.keySet()) {
	// // Colleciton of flexobject in a Season
	// groupedByData = (Collection<?>) groupedByIndexCollection.get(key);
	// }
	// return groupedByData;
	// }

	// //////////////////////////////////////////////////////////////////////////////////////////
	// / THE FOLLWING FUNCTION ARE ACCORDING
	// / TO THE NEW CHANGES IN PRODUCT ADOTPTION REPORT -- BUILD 5.10
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * 
	 * ITC Infotech.
	 * 
	 * 
	 * @param dataCollection
	 *            .
	 * @param levelOne
	 *            .
	 * @param levelTwo
	 *            .
	 * @param levelThree
	 *            .
	 * @param refIndex
	 *            .
	 * @param calculateColumn
	 *            .
	 * @param countOrCalculate
	 *            .
	 * @return dataList.
	 */

	public static List<FlexObject> rollUp(Collection<?> dataCollection,
			String levelOne, String levelTwo, String levelThree,
			String refIndex, String calculateColumn, String countOrCalculate) {
		// Initialize Master List containing the FlexObject
		List<FlexObject> dataList = new java.util.ArrayList<FlexObject>();

		String divisionColumn = LFReportUtil
				.getColumnName(DIVISION_KEY, SEASON);
		String divisionIndex = LCSSEASON + "." + divisionColumn;

		// Level One Categorization(Season)
		Map<?, ?> groupedIntoLevelOne = groupIntoCollections(
				(Collection<FlexObject>) dataCollection, levelOne);

		// Iterating through the Level One Collection(Each Season Key)
		for (Object levelOneKey : groupedIntoLevelOne.keySet()) {
			// Collection of flexobjects in Level One Category(One Season)
			Collection<?> levelOneCollections = (Collection<?>) groupedIntoLevelOne
					.get(levelOneKey);
			// Level Two Categorization(Product category)
			Map<?, ?> groupedIntoLevelTwo = groupIntoCollections(
					(Collection<FlexObject>) levelOneCollections, levelTwo);
			// Iterating through the Level Two Collection(Each product category)
			for (Object levelTwoKey : groupedIntoLevelTwo.keySet()) {
				// Collection of flexobjects in Level Two Category(One product
				// category)
				Collection<?> levelTwoCollections = (Collection<?>) groupedIntoLevelTwo
						.get(levelTwoKey);
				// Level three Categorization(description/source)
				Map<?, ?> groupedIntoLevelThree = groupIntoCollections(
						(Collection<FlexObject>) levelTwoCollections,
						levelThree);
				// Iterating through the Level Three Collection(each
				// description/source key)
				for (Object levelThreeKey : groupedIntoLevelThree.keySet()) {
					String division = "";
					FlexObject resultFOB = new FlexObject();
					// Collection of flexobjects in Level Two Category(oneu
					// description/source)
					Collection<?> levelThreeCollections = (Collection<?>) groupedIntoLevelThree
							.get(levelThreeKey);

					// THE FLEXOBJECT FORMED WITH THE FINAL SET OF DATA
					division = getDivisionValue(levelThreeCollections);
					resultFOB.put(divisionIndex, division);

					resultFOB
							.put(UNIQUEID,
									levelOneKey.toString()
											+ levelTwoKey.toString()
											+ levelThreeKey.toString());
					resultFOB.put(levelOne, levelOneKey.toString());
					resultFOB.put(levelTwo, levelTwoKey.toString());
					resultFOB.put(levelThree, levelThreeKey.toString());

					// calls up internal funtion for adoption report
					if (!countOrCalculate.equalsIgnoreCase("")) {
						// THE RESULT VALUE BASED ON CALUCULATE OR COUNT THE
						// DATA
						float values = 0.0f;
						// ACTUAL METHOD
						values = internalCalculation(levelThreeCollections,
								refIndex, calculateColumn, countOrCalculate);
						resultFOB.put(calculateColumn, values);
					}
					// calls up internal funtion for sample tracking report
					else if (countOrCalculate.equalsIgnoreCase("")
							&& !calculateColumn.equalsIgnoreCase("")) {
						resultFOB = rollupExclusiveforSample(resultFOB,
								levelThreeCollections, calculateColumn);

					}

					// COLLECTION OF ALL THE FLEXOBJECTS
					dataList.add(resultFOB);
				}
			}
		}
		return dataList;
	}

	private static String getDivisionValue(Collection<?> levelThreeCollections) {
		// TODO Auto-generated method stub

		String divisionColumn = LFReportUtil
				.getColumnName(DIVISION_KEY, SEASON);
		String divisionIndex = LCSSEASON + "." + divisionColumn;
		String division = "";
		FlexObject obj = (FlexObject) levelThreeCollections.iterator().next();
		division = obj.getData(divisionIndex);
		return division;
	}

	/**
	 * 
	 * ITC INFOTECH.
	 * 
	 * 
	 * @param finalfob
	 *            .
	 * @param levelThreeCollections
	 *            .
	 * @param calculateColumn
	 *            .
	 * @return FlexObject.
	 */
	private static FlexObject rollupExclusiveforSample(FlexObject finalfob,
			Collection<?> levelThreeCollections, String calculateColumn) {
		// TODO Auto-generated method stub
		// INITIALIZATION
		FlexObject resultFOB = new FlexObject();

		int submittedCount = 0;
		int approvedCount = 0;
		int rejectedCount = 0;
		int reworkCount = 0;

		// All the Applicable Attribute List from the Property
		String[] statusArray = LCSProperties.get(
				"com.lfusa.wc.report.sampleStatusList").split(DELIMS);
		List<String> statusList = Arrays.asList(statusArray);

		// ITERATING THROUGH THE COLLECTION
		for (Object obj : levelThreeCollections) {
			//
			FlexObject fob = (FlexObject) obj;
			String sampleStatus = fob.getData(calculateColumn);
			// SAMPLE STATUS
			if ((sampleStatus != null) && !sampleStatus.isEmpty()
					&& statusList.contains(sampleStatus)) {
				Status status = Status.valueOf(sampleStatus);
				switch (status) {
				case submitted: {
					submittedCount++;
					break;
				}
				case approved: {
					approvedCount++;
					break;
				}
				case rejected: {
					rejectedCount++;
					break;
				}
				case reworked: {
					reworkCount++;
					break;
				}
				default: {
					break;
				}
				}
			}
		}
		resultFOB.put(SUBMITTEDINDEX, submittedCount);
		resultFOB.put(APPROVEDINDEX, approvedCount);
		resultFOB.put(DROPPEDINDEX, rejectedCount);
		resultFOB.put(REWORKINDEX, reworkCount);
		finalfob.putAll(resultFOB);

		return finalfob;
	}

	/**
	 * 
	 * ITC Infotech.
	 * 
	 * 
	 * @param collections
	 *            .
	 * @param refIndex
	 *            .
	 * @param calculateColumn
	 *            .
	 * @param countOrCalculate
	 *            .
	 * @return int.
	 */

	public static float internalCalculation(Collection<?> collections,
			String refIndex, String calculateColumn, String countOrCalculate) {
		// TODO Auto-generated method stub
		float values = 0.0f;
		// IF THE DATA HAS TO BE ADDED
		if (countOrCalculate.equalsIgnoreCase(CALCULATE)) {
			// COLLECTION OF UNIQUE ID FOR CALCULATION
			values = calculateFunction(collections, refIndex, calculateColumn);
		}
		// IF THE DATA HAS TO BE COUNTED UP
		else if (countOrCalculate.equalsIgnoreCase(COUNT)) {
			// Level Four Categorization
			Map<?, ?> groupedIntoCommonKey = groupIntoCollections(
					(Collection<FlexObject>) collections, calculateColumn);
			// ITERATING THROUGH THE COLLECTION
			for (Object key : groupedIntoCommonKey.keySet()) {
				// FOR CALCULATING PROTO SAMPLE TYPES
				if (calculateColumn.contains(FLEXTYPE)
						&& ((String) key).equals(PROTOSAMPLE)) {
					values = ((Collection<?>) groupedIntoCommonKey
							.get(PROTOSAMPLE)).size();
					return values;
				}
			}
			// FOR OTHERS
			values = groupedIntoCommonKey.size();
		}
		return values;
	}

	/**
	 * 
	 * ITC Infotech. int
	 * 
	 * @param collections
	 *            .
	 * @param refIndex
	 *            .
	 * @param calculateColumn
	 *            .
	 * @return values.
	 */
	private static float calculateFunction(Collection<?> collections,
			String refIndex, String calculateColumn) {
		// TODO Auto-generated method stub
		float values = 0.0f;
		// ITERATING THROUGH THE oBJECTS
		if (calculateColumn.equals(LCSSEASONPRODUCTLINK + "."
				+ LFReportUtil.getColumnName(PRODUCT_STATUS_KEY, PRODUCT))) {
			values = exclusiveForAdopted(collections, refIndex, calculateColumn);
		} else {
			values = generalCalculation(collections, refIndex, calculateColumn);
		}
		return values;
	}

	/**
	 * 
	 * ITC Infotech int.
	 * 
	 * @param collections
	 *            .
	 * @param refIndex
	 *            .
	 * @param calculateColumn
	 *            .
	 * @return values.
	 */

	private static float generalCalculation(Collection<?> collections,
			String refIndex, String calculateColumn) {
		// TODO Auto-generated method stub
		Collection<String> data = new ArrayList<String>();
		float values = 0.0f;
		for (Object flexObject : collections) {
			// INITIALIZATION
			FlexObject fob = (FlexObject) flexObject;
			String id = fob.getData(refIndex);
			String d = fob.getData(calculateColumn);
		//	System.out.println("d in generalCalculation method of LFReportsUtil is **********"+d);
			if(d!=null && d.equalsIgnoreCase("0")){
				d=fob.getData("LCSSAMPLE.num2");
				//System.out.println("d for zero method of LFReportsUtil is **********"+d);
			}
			// FOR OTHERS
			if (!data.contains(id) && (d != null)) {
				data.add(id);
				values = values + Float.parseFloat(d);
			} else {
				data.add(id);
			}
		}
		return values;
	}

	/**
	 * 
	 * ITC Infotech int.
	 * 
	 * @param collections
	 *            .
	 * @param refIndex
	 *            .
	 * @param calculateColumn
	 *            .
	 * @return values.
	 */
	private static int exclusiveForAdopted(Collection<?> collections,
			String refIndex, String calculateColumn) {
		// TODO Auto-generated method stub
		Collection<String> data = new ArrayList<String>();
		int values = 0;
		for (Object flexObject : collections) {
			// INITIALIZATION
			FlexObject fob = (FlexObject) flexObject;
			String id = fob.getData(refIndex);
			String d = fob.getData(calculateColumn);

			// CALUCALTION OF ADOPTED PRODUCTS
			if (isNotBlank(d) && !data.contains(id)
					&& d.equalsIgnoreCase(ADOPTED)) {
				data.add(id);
				values++;
			} else if (isNotBlank(d) && !data.contains(id)
					&& !d.equalsIgnoreCase(ADOPTED)) {
				// TODO do nothing.
			} else {
				data.add(id);
			}
		}
		return values;
	}

	/**
	 * 
	 * ITC Infotech.
	 * 
	 * 
	 * @param collection
	 *            .
	 * @param numeratorIndex
	 *            .
	 * @param denominatorIndex
	 *            .
	 * @param resultIndex
	 *            .
	 * @return Collection.
	 */

	public static Collection<?> rollupCustomCalculation(
			Collection<?> collection, String numeratorIndex,
			String denominatorIndex, String resultIndex) {
		// TODO Auto-generated method stub
		DecimalFormat twoDecimal = new DecimalFormat("#.##");
		Double result = 0.00d;
		int i = 0;
		// ITERATING THROUGH THE OBJECT
		for (Object obj : collection) {
			// INITIALIZATION
			result = 0.00d;
			i = 0;
			FlexObject fob = (FlexObject) obj;
			// COLUMN VALUES
			Double numeratorValue = Double.parseDouble(fob
					.getData(numeratorIndex));
			Double denominatorValue = Double.parseDouble(fob
					.getData(denominatorIndex));
			// CALCULATION
			if ((denominatorValue != 0)
					&& resultIndex.equalsIgnoreCase("CUSTOM.SAMPLEAVERAGE")) {
				result = numeratorValue / denominatorValue;
				//i = result.intValue();
				//fob.put(resultIndex, i);
				fob.put(resultIndex, result);
			} else if ((denominatorValue != 0)
					&& resultIndex.equalsIgnoreCase("CUSTOM.SAMPLEPROTOAVERAGE")) {
				result = numeratorValue / denominatorValue;
				//i = result.intValue();
				//fob.put(resultIndex, i);
				fob.put(resultIndex, result);
			}
			else if ((denominatorValue != 0)
					&& resultIndex.equalsIgnoreCase("CUSTOM.SAMPLESALESAVERAGE")) {
				result = numeratorValue / denominatorValue;
				//i = result.intValue();
				//fob.put(resultIndex, i);
				fob.put(resultIndex, result);
			}
			else if (denominatorValue != 0) {
				result = (numeratorValue / denominatorValue) * 100;
				fob.put(resultIndex, twoDecimal.format(result));
			}
		}
		return collection;
	}

	/**
	 * 
	 * ITC Infotech.
	 * 
	 * 
	 * @param collection
	 *            .
	 * @param index
	 *            .
	 * @param attKey
	 *            .
	 * @param flextype
	 *            .
	 * @return Collection<?>.
	 */
	public static Collection<?> rollupDerivedValues(Collection<?> collection,
			String index, String attKey, String flextype) {
		// TODO Auto-generated method stub

		try {
			// FLEXTYPE
			FlexType flexType = FlexTypeCache.getFlexTypeFromPath(flextype);
			// FLEXTYPE ATTRIBUTE
			FlexTypeAttribute attribute = flexType.getAttribute(attKey);

			// For Product Object
			if (flextype.equalsIgnoreCase(PRODUCT)) {
				// ITERATING THROUGH THE COLLECTION
				for (Object obj : collection) {
					String display = "";
					// EXTRACTNG THE VALUE FOR THE SINGLE LIST VALUE
					FlexObject fob = (FlexObject) obj;
					String key = fob.getData(index);
					display = attribute.getAttValueList().getValue(key, null);
					fob.put(index, display);
				}
				return collection;
			}
			// For Sourcing Configuration Object
			else if (flextype.equalsIgnoreCase(SOURCINGCONFIG)) {
				// ITERATING THROUGH THE COLLECTION
				for (Object obj : collection) {
					String display = "";
					// EXTRACTNG THE NAME OF THE OBJECT
					FlexObject fob = (FlexObject) obj;
					String key = fob.getData(index);
					if ((key != null) && !key.isEmpty() && !key.equals("0")) {
						LCSSupplier supplier = (LCSSupplier) LCSQuery
								.findObjectById("VR:com.lcs.wc.supplier.LCSSupplier:"
										+ key);
						display = (String) supplier.getValue(NAME_KEY);
						fob.put(index, display);
					} else {
						// Do Nothing
					}
				}
				return collection;
			} else if (flextype.equalsIgnoreCase(SEASON)) {
				// ITERATING THROUGH THE COLLECTION
				for (Object obj : collection) {
					String display = "";
					// EXTRACTNG THE VALUE FOR THE SINGLE LIST VALUE
					FlexObject fob = (FlexObject) obj;
					String key = fob.getData(index);
					display = attribute.getAttValueList().getValue(key, null);
					fob.put(index, display);
				}
				return collection;

			}

		} catch (WTException e) {
			// TODO Auto-generated catch block.
			LCSLog.error("Exception in rollupDerivedValues --> "
					+ org.apache.commons.lang.exception.ExceptionUtils
							.getStackTrace(e));
		}
		return collection;
	}

	/**
	 * 
	 * ITC Infotech. Map<String,String>
	 * 
	 * @param collection
	 *            .
	 * @param keyIndex
	 *            .
	 * @return map.
	 */

	public static Map<String, String> rollupGetSeasonNameList(
			Collection<?> collection, String keyIndex) {
		// TODO Auto-generated method stub
		Map<String, String> map = new HashMap<String, String>();
		Map<?, ?> groupedIntoseasonID = groupIntoCollections(
				(Collection<FlexObject>) collection, keyIndex);
		// ITERATING THROUGH THE OBJECT
		try {
			for (Object key : groupedIntoseasonID.keySet()) {
				LCSSeason season = (LCSSeason) LCSQuery
						.findObjectById("OR:com.lcs.wc.season.LCSSeason:"
								+ key.toString());
				String display = (String) season.getValue(SEASON_NAME_KEY);
				map.put(key.toString(), display);
			}
		} catch (WTException e) {
			// TODO Auto-generated catch block
			LCSLog.error("Exception in rollupGetSeasonNameList --> "
					+ ExceptionUtils.getStackTrace(e));
		}
		return map;
	}

	/**
	 * 
	 * @author ITC Infotech.
	 * 
	 */
	private enum Status {
		approved, rejected, submitted, reworked;
	}

	/**
	 * 
	 * ITC Infotech. List<?>
	 * 
	 * @param flexPath
	 *            .
	 * @param licensorColl
	 *            .
	 * @return ida2a2List.
	 */
	public static List<?> getKeyCollection(String flexPath, List<?> licensorColl) {
		List<String> ida2a2List = new ArrayList<String>();
		SearchResults results = null;
		List<?> resultList = null;
		FlexObject fo = null;
		String index = "";
		FlexTypeAttribute fa = null;
		FlexType flexType = null;
		LCSLifecycleManagedQuery lmq = new LCSLifecycleManagedQuery();
		Map<String, String> criteria = new HashMap<String, String>();
		String value = "";

		try {
			flexType = FlexTypeCache.getFlexTypeFromPath(flexPath);
			fa = flexType.getAttribute(NAME_KEY);
			index = fa.getSearchCriteriaIndex();

			for (Object obj : licensorColl) {
				results = null;
				resultList = null;
				fo = null;
				value = "";
				String name = (String) obj;
				criteria.put(index, name);
				results = lmq.findLifecycleManagedsByCriteria(criteria,
						flexType, null, null, null);

				if (results != null) {
					if (results.getResultsFound() != 0) {
						resultList = results.getResults();
						fo = (FlexObject) resultList.get(0);
						value = fo.getString(BO_IDA2A2);
					}
				} else {
					value = null;
				}
				ida2a2List.add(value);
			}
		} catch (WTException ex) {
			LCSLog.error("Exception in getKeyCollection --> "
					+ ExceptionUtils.getStackTrace(ex));
		}
		return ida2a2List;
	}

	/**
	 * 
	 * @author ITC Infotech String FIXME Timers
	 * @param bOAttKey
	 *            .
	 * @param bOFlexPath
	 *            .
	 * @return lFVariable.
	 */
	public static String getColumnName(String bOAttKey, String bOFlexPath) {
		String lFVariable = null;
		try {
			FlexType bOFlexType = FlexTypeCache.getFlexTypeFromPath(bOFlexPath);
			FlexTypeAttribute fta = new FlexTypeAttribute();
			fta = bOFlexType.getAttribute(bOAttKey);
			lFVariable = fta.getVariableName();
		} catch (WTException e) {
			LCSLog.error("Exception in getColumnName --> "
					+ org.apache.commons.lang.exception.ExceptionUtils
							.getStackTrace(e));
		}
		return lFVariable;
	}

	/**
	 * 
	 * ITC Infotech. PreparedQueryStatement.
	 * 
	 * @param pqs
	 *            .
	 * @param valuesList
	 *            .
	 * @param tableColumn
	 *            .
	 * @param flexType
	 *            .
	 * @param attKey
	 *            .
	 * @return utilPQS.
	 */

	public static PreparedQueryStatement appendInQuery(
			PreparedQueryStatement pqs, List<?> valuesList, String tableColumn,
			String flexType, String attKey) {
		// INITIALIZATION
		PreparedQueryStatement utilPQS = new PreparedQueryStatement();
		utilPQS = pqs;
		// MULTI LIST CRITERIA QUERY
		if ((valuesList != null) && !valuesList.isEmpty()) {
			utilPQS.appendInCriteria(tableColumn,
					getColumnName(attKey, flexType), valuesList);
		}
		return utilPQS;
	}

	/**
	 * 
	 * ITC Infotech. PreparedQueryStatement.
	 * 
	 * @param pqs
	 *            .
	 * @param value
	 *            .
	 * @param tableColumn
	 *            .
	 * @param flexType
	 *            .
	 * @param attKey
	 *            .
	 * @return utilPQS.
	 */
	public static PreparedQueryStatement appendQuery(
			PreparedQueryStatement pqs, String value, String tableColumn,
			String flexType, String attKey) {
		// INITIALIZATION
		PreparedQueryStatement utilPQS = new PreparedQueryStatement();
		utilPQS = pqs;
		// STRING VALUE CRITERIA QUERY
		if (LFReportUtil.isNotBlank(value)) {
			utilPQS.appendAndIfNeeded();
			utilPQS.appendCriteria(new Criteria(new QueryColumn(tableColumn,
					getColumnName(attKey, flexType)), "%" + value + "%",
					Criteria.LIKE, false));
		}
		return utilPQS;
	}

	/**
	 * Added for Nominated Office Multi List - Build 6.15 ITC Infotech.
	 * PreparedQueryStatement.
	 * 
	 * @param pqs
	 *            .
	 * @param valuesList
	 *            .
	 * @param tableColumn
	 *            .
	 * @param flexType
	 *            .
	 * @param attKey
	 *            .
	 * @return utilPQS.
	 */
	public static PreparedQueryStatement appendMultiListQuery(
			PreparedQueryStatement pqs, List<?> valuesList, String tableColumn,
			String flexType, String attKey) {
		// INITIALIZATION
		PreparedQueryStatement utilPQS = new PreparedQueryStatement();
		utilPQS = pqs;
		// STRING VALUE CRITERIA QUERY
		if ((valuesList != null) && !valuesList.isEmpty()) {
			Iterator itrList = valuesList.iterator();
			utilPQS.appendAndIfNeeded();
			utilPQS.appendOpenParen();
			while (itrList.hasNext()) {
				String listValue = (String) itrList.next();
				utilPQS.appendCriteria(new Criteria(new QueryColumn(
						tableColumn, getColumnName(attKey, flexType)), "%"
						+ listValue + "%", Criteria.LIKE, false));
				if (itrList.hasNext()) {
					utilPQS.appendOrIfNeeded();
				}
			}
			utilPQS.appendClosedParen();
		}
		return utilPQS;
	}
}
