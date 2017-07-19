package com.lfusa.wc.sample;

import org.apache.commons.lang.StringUtils;
import wt.fc.WTObject;
import wt.part.WTPartMaster;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;
import com.lcs.wc.foundation.LCSLogic;
import com.lcs.wc.sample.LCSSample;
import com.lcs.wc.sample.LCSSampleRequest;
import com.lcs.wc.product.LCSSKU;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.VersionHelper;

/**
 * @author ITC Infotech
 * 
 */
public class LFSampleNamePlugin implements LFSampleConstants {

	protected LFSampleNamePlugin() {
	}

	/**
	 * ITC Infotech
	 * void
	 * 
	 * @param obj
	 * @throws WTException
	 * @throws WTPropertyVetoException
	 *             This requirement applies across all categories of LFUSA
	 *             (Apparel, Accessories and HOME)
	 *             this method is used to derive the sample name from sample
	 *             request name, sample sequence, sample colour, and sample size
	 *             in the format
	 *             Sample name =
	 *             SampleRequestName-SampleSequence-SampleColor-(Size)
	 */
	public static void setSampleName(WTObject obj) throws WTException ,
			WTPropertyVetoException {

		/**
		 * Declaring
		 * Method level variables
		 */
		String requestName = "";
		String color = "";
		String sequence = "";
		String sampleName = "";
		StringBuffer sampleNameBuffer = new StringBuffer();
		/**
		 * If Block
		 * for checking if obj is of type LCSSample
		 */
		if (obj instanceof LCSSample) {

			LCSSample sampleObj = (LCSSample) obj;
			//gets the sample request for the sample
			LCSSampleRequest sampleReq = (LCSSampleRequest) sampleObj
					.getSampleRequest();
			if (sampleReq != null) {
				// gets the sample request name
				requestName = (String) sampleReq.getValue(REQUESTNAMEKEY);
				if (!FormatHelper.hasContent(requestName)) {
					requestName = "";
				}
			}
			/**
			 * If Block
			 * for checking sampleObj is not null
			 */
			if (sampleObj.getValue(SAMPLESEQUENCEKEY) != null) {
				// gets the sample sequence
				sequence = StringUtils.substringBeforeLast(
						(sampleObj.getValue(SAMPLESEQUENCEKEY).toString()
								.trim()), ".");
			}
			// gets the value of color for the sample
			WTPartMaster colorObj = (WTPartMaster) sampleObj.getColor();
			if (colorObj != null) {
				LCSSKU sku = (LCSSKU) VersionHelper.getVersion(colorObj, "A");
				String name = (String) sku.getValue("skuName");
				color = "-" + name;
			}
			else {
				color = "";
			}

			// defined a string buffer to append individual components

			sampleNameBuffer.append(requestName);
			sampleNameBuffer.append("-");
			sampleNameBuffer.append(sequence);
			sampleNameBuffer.append(color);
			sampleName = sampleNameBuffer.toString();
			sampleNameBuffer.setLength(0);
			// name of sample set on JSP page
			sampleObj.setSampleName(sampleName);
			// name of sample set on view page
			sampleObj.setValue(SAMPLENAMEKEY, sampleName);
		}
	}

	/**
	 * 
	 * Target Point Build: 004.23
	 * Request ID : <7>
	 * Modified On: 22-May-2013
	 * Method to set the Sample Quantity in
	 * Sample while creating Multiple samples.
	 * 
	 * @author Archana
	 *         setSampleQuantity
	 * @param obj
	 *            void
	 * @throws WTPropertyVetoException
	 * @throws WTException
	 */
	public static void setSampleQuantity(WTObject obj)
			throws WTPropertyVetoException , WTException {

		float sampleQuantity = 0;
		double quanity = 0;
		LCSLog.debug("Set sample quantity plugin running>");
		if (obj instanceof LCSSample) {
			// typecast WTObject to sample Request Object
			LCSSample sampleObj = (LCSSample) obj;
			// gets the sample flextype
			LCSSampleRequest sampleReq = sampleObj.getSampleRequest();
			try {
				if (sampleReq != null) {
					// gets the sample quantity value entered.
					quanity = (Double) sampleReq
							.getValue(DECGRIDSAMPLEQUANTITYKEY);
					sampleQuantity = (float) quanity;
					if (sampleQuantity != 0) {
						// sets the sample quantity to the sample quantity at
						// sample request scope.
						sampleObj.setValue(DECSAMPLEQUANTITYKEY, sampleQuantity);
					}
				}
			}
			catch (WTException e) {
				// TODO Auto-generated catch block
				LCSLog.error("WTException : " + e);
			}
			catch (WTPropertyVetoException e) {
				// TODO Auto-generated catch block
				LCSLog.error("WTPropertyVetoException" + e);
			}
		}
	}
	
	public static void setSampleColorway(WTObject obj){
		
		String color = "";
		LCSLog.debug("Set Sample Colorway plugin running>");
		if (obj instanceof LCSSample) {
			// typecast WTObject to sample Request Object
			LCSSample sampleObj = (LCSSample) obj;

			// gets the value of color for the sample
			WTPartMaster colorObj = (WTPartMaster) sampleObj.getColor();
			try {
				if (colorObj != null) {
					color = colorObj.getName();
				}
				
				sampleObj.setValue(sampleColorwayKey, color);
				
			}
			catch (WTPropertyVetoException e) {
				// TODO Auto-generated catch block
				LCSLog.error("WTPropertyVetoException" + e);
			}
			catch (WTException e) {
				// TODO Auto-generated catch block
				LCSLog.error("WTException : " + e);
			}

		}
	}
	
	/**
	 * 
	 * Target Point Build: 005.16
	 * Request ID : <3>
	 * Modified On: 21-May-2014
	 * Method to set request name in the Sample
	 * @author ITC Infotech       
	 * @param obj
	 *            Sample request WTObject
	 * @return void.
	 * @throws WTException
	 * @throws WTPropertyVetoException
	 *             for Set Value
	 * Plugin Event:PRE_CREATE_PERSIST
	 * Plugin Type:LCSSample
	 * 
	 */
	public static void setMaterialSampleName(WTObject obj) throws WTPropertyVetoException, WTException {

	// Initialization

		String requestName = null;
		LCSLog.debug("Set Material Sample Name plugin running>");
	// IF Object is of Sample 
	if (obj instanceof LCSSample) {
	LCSLog.debug("Set Material Sample Name plugin running> Object is instance of Sample.");
	// get the sample object
	LCSSample sample = (LCSSample) obj;
	LCSLog.debug("Set Material Sample Name plugin running> Sample Object--->"+ sample);
	// get the sample request object
	LCSSampleRequest sampleReq = (LCSSampleRequest) sample.getSampleRequest();
	LCSLog.debug("Set Material Sample Name plugin running> Sample Request Object--->"+ sampleReq );
				
					
			if (sampleReq != null) {
				LCSLog.debug("Set Material Sample Name plugin running> SampleRequest Obj is not Null.");

				// gets the sample request name
				requestName = (String) sampleReq.getValue(REQUESTNAMEKEY);
				LCSLog.debug("Set Material Sample Name plugin requestName>" + requestName);

				if (!FormatHelper.hasContent(requestName)) {
					requestName = "";
				}
			}
		// set sample name	
		sample.setSampleName(requestName);
		LCSLog.debug("Set Material Sample Name plugin running> Set request name in Sample name");
		sample.setValue(SAMPLENAMEKEY,requestName);
		LCSLogic.persist(sample,true);
		LCSLog.debug("Set Material Sample Name plugin running> Sample Name ::" + sample.getValue(SAMPLENAMEKEY));
		LCSLog.debug("Set Material Sample Name plugin running> Material Sample Name set complete");

		}

	}	

}
