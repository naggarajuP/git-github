/**
 * Package
 * */
package com.lfusa.wc.product;

/**
 * Import files
 * **/

import java.util.Collection;
import java.util.Iterator;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;

import wt.fc.WTObject;
import wt.part.WTPartMaster;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;

import com.lcs.wc.flextype.FlexType;
import com.lcs.wc.foundation.LCSLogic;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.season.LCSSeason;
import com.lcs.wc.season.LCSSeasonProductLink;
import com.lcs.wc.season.LCSSeasonQuery;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;
import com.lcs.wc.util.VersionHelper;
import com.lfusa.wc.season.LFSeasonProductAdoptionPlugin;

/**
 * LFProductValidatedSAP class is used to auto populate validation for SAP.
 * 
 * @author "true" ITC INFOTECH.
 * @version "true" V2.0.
 **/
public final class LFProductValidatedSAP {

	/**
	 * Initializing the logger variable.
	 */
	private static Logger log = Logger.getLogger(LFProductValidatedSAP.class);
	
	/**
	 * Classname.
	 */
	public static final String CLASSNAME = "LFProductValidatedSAP";

	/**
	 * Default constructor
	 */
	private LFProductValidatedSAP() {

	}

	/**
	 * setValidatedSAPValue() when invoked auto populate validation for SAP.
	 * 
	 * void
	 * 
	 * @param object
	 *            - WTObject which has to be an instance of LCSProduct.
	 * @throws WTPropertyVetoException 
	 */
	public static void setValidatedSAPValue(WTObject object) throws WTPropertyVetoException {

		/*
		 * 	Start
		 * Build 7.3 JDE Integration Start
		 */
		
		String jdeDivisionsList = LCSProperties.get("com.lfusa.wc.JDE.applicableDivision");
		String axDivisionslist = LCSProperties.get("com.lfusa.wc.AX.applicableDivision");
		log.info(CLASSNAME + ":List of Applicable Divisions::" + jdeDivisionsList);

		int jdeAttCount = 0;
		int jdeAttCountPro = 0;
		int jdeAttCountSeasonPro = 0;
		int axAttCount = 0;
		int axAttCountPro = 0;
		int axAttCountSeasonPro = 0;
		String seasonProductAttribute = "";
			
		/*
		 * Build 7.3  
		 * End
		 */
		
		
		LCSProduct product = null;
		// defined to store sapAttCount.
		int sapAttCount = 0;
		String productFlexType = null;
		FlexType type = null;   
		String att = "";
		WTPartMaster master = null;

		// defined to store sapAttCountPro.
		int sapAttCountPro = 0;
		// defined to store sapAttCountSeaPro.
		int sapAttCountSeaPro = 0;
		// defined to store attribute.
		String attribute = "";
		Iterator iter = null;

		LCSSeason season = null;
		LCSSeasonProductLink spLink = null;
		boolean flag = false;
		
		product = (LCSProduct) object;

		/*
		 * Build 7.3 JDE Start:
		 * 
		 */
		
		try 
		{
			Collection seasonCol = (Collection) new LCSSeasonQuery().findSeasons(product);

			String productDivisionName = (String) product.getValue("lfDivision");
			log.info(CLASSNAME + ":Product Division Name:" + productDivisionName);
			System.out.println("productDivisionName in java is ***********"+productDivisionName);
			
			//JDE validation
			if (jdeDivisionsList.contains(productDivisionName)) 
			{
				System.out.println("inside if productDivisionName in java is ***********"+productDivisionName);
				if ((seasonCol != null) && (seasonCol.size() > 0)) {
					iter = seasonCol.iterator();
					while (iter.hasNext()) 
					{	
						master = (WTPartMaster) iter.next();
						season = (LCSSeason) VersionHelper.latestIterationOf(master);
						spLink = LCSSeasonQuery.findSeasonProductLink(product,season);
						
						String productStatus = (String) spLink.getValue(LFProductConstants.productStatus);
						String productStatusvalue = product
								.getFlexType()
								.getAttribute(LFProductConstants.productStatus)
								.getAttValueList() 
								.getValue(
										productStatus,
										com.lcs.wc.client.ClientContext
												.getContext().getLocale());
						if (FormatHelper.hasContent(productStatusvalue)&& "Adopted".equalsIgnoreCase(productStatusvalue)) {
							flag = true;
							break;
						}
					}
				}
				if(flag) 
				{
					log.info(CLASSNAME + ":FLAG Status: " + flag);   
					type = product.getFlexType();
					productFlexType = type.getFullName();
					att = LCSProperties.get("com.lfusa.wc.product.jdeOutbound.attributeKeys." + productFlexType);
					log.info(CLASSNAME + ":JDE ATT:::" + att);
					
					if(att!=null) {
						StringTokenizer proTokenizer = new StringTokenizer(att, ",");
						jdeAttCountPro = proTokenizer.countTokens();
						
						seasonProductAttribute = LCSProperties.get("com.lfusa.wc.product.jdeOutbound.seasonProductAttributeKey");
						StringTokenizer seasProTokenizer = new StringTokenizer(seasonProductAttribute, ",");
						jdeAttCountSeasonPro = seasProTokenizer.countTokens();
					
						jdeAttCount = jdeAttCountPro + jdeAttCountSeasonPro;
				
						LFSeasonProductAdoptionPlugin.setProductDataforJDE(product, spLink, jdeAttCount, proTokenizer);
						LCSLogic.persist(product, true);
					}
					else  {
						LCSLog.debug("None of the Season-Product Links: are Validated for ERP");
					}
				 }
			}
			//Added for AX Integration product validation : Start
			else if (axDivisionslist.contains(productDivisionName)) 
			{
				System.out.println("inside if axDivisionslist in java is ***********"+productDivisionName);
				
				if ((seasonCol != null) && (seasonCol.size() > 0)) {
					iter = seasonCol.iterator();
					while (iter.hasNext()) 
						{	
							master = (WTPartMaster) iter.next();
							season = (LCSSeason) VersionHelper.latestIterationOf(master);
							spLink = LCSSeasonQuery.findSeasonProductLink(product,season);
							String productStatusvalue = "";
							String productStatus = (String) spLink.getValue(LFProductConstants.productStatus);
							productStatusvalue = product
									.getFlexType()
									.getAttribute(LFProductConstants.productStatus)
									.getAttValueList() 
									.getValue(
											productStatus,
											com.lcs.wc.client.ClientContext
													.getContext().getLocale());
							System.out.println("inside if productStatusvalue in java is ***********"+productStatusvalue);
							if (FormatHelper.hasContent(productStatusvalue)&& "Adopted".equalsIgnoreCase(productStatusvalue)) {
								flag = true;
								break;
							}
						}
				}
				if(flag)
				{
					log.info(CLASSNAME + ":FLAG Status: " + flag);   
					type = product.getFlexType();
					productFlexType = type.getFullName();
					System.out.println(":productFlexType:::" + productFlexType);
					att = LCSProperties.get("com.lfusa.wc.product.axOutbound.attributeKeys." + productFlexType);
					log.info(CLASSNAME + ":JDE ATT:::" + att);
					System.out.println(CLASSNAME + ":JDE ATT:::" + att);
					if(att!=null)
					{
						StringTokenizer proTokenizer = new StringTokenizer(att, ",");
						axAttCountPro = proTokenizer.countTokens();
						System.out.println(":axAttCountPro:::" + axAttCountPro);
						seasonProductAttribute = LCSProperties.get("com.lfusa.wc.product.axOutbound.seasonProductAttributeKey");
						StringTokenizer seasProTokenizer = new StringTokenizer(seasonProductAttribute, ",");
						axAttCountSeasonPro = seasProTokenizer.countTokens();
						System.out.println(":axAttCountSeasonPro:::" + axAttCountSeasonPro);
						axAttCount = axAttCountPro + axAttCountSeasonPro;
						System.out.println(":axAttCount:::" + axAttCount);
						
						LFSeasonProductAdoptionPlugin.setProductDataforAX(product, spLink, axAttCount, proTokenizer);
						
						LCSLogic.persist(product, true);
					}
					else
					{
						LCSLog.debug("None of the Season-Product Links: are Validated for ERP");
					}
				}
				
			}
			//Added for AX Integration product validation : End

			/*
			 * Build 7.3
			 * End
			 */
			
			// SAP Functionality will start's  here.
			 else
			 {
				 System.out.println("inside else productDivisionName in java is ***********"+productDivisionName);
				 log.info(CLASSNAME + ":This is SAP Product Validation starting ");
				
				if ((seasonCol != null) && (seasonCol.size() > 0)) {
					iter = seasonCol.iterator();
					while (iter.hasNext()) {
						flag = false;
						master = (WTPartMaster) iter.next();
						season = (LCSSeason) VersionHelper.latestIterationOf(master);
						spLink = LCSSeasonQuery.findSeasonProductLink(product,season);
						String productStatusvalue = "";
						String productStatus = (String) spLink.getValue(LFProductConstants.productStatus);
						productStatusvalue = product
								.getFlexType()
								.getAttribute(LFProductConstants.productStatus)
								.getAttValueList() 
								.getValue(
										productStatus,
										com.lcs.wc.client.ClientContext
												.getContext().getLocale());
						if (FormatHelper.hasContent(productStatusvalue)&& "Adopted".equalsIgnoreCase(productStatusvalue)) {
							flag = true;
							break;
						}
					}
				}
				
				if (flag) {
					// getting type of the flex typed object.
					type = product.getFlexType();
					// getting type of full flex type.
					productFlexType = type.getFullName();
					// getting Attributes from property file.
					att = LCSProperties.get("com.lfusa.wc.product.sapOutbound.attributeKeys." + productFlexType);
					
					if (att != null) {
						// getting Attributes comma separated.
						StringTokenizer st = new StringTokenizer(att, ",");
						// getting Attributes count.
						sapAttCountPro = st.countTokens();
						// getting Attributes from property file.
						attribute = LCSProperties
								.get("com.lfusa.wc.product.sapOutbound.attributeKey");
						// getting StringTokenizer attribute with comma
						// sepatated from property file
						StringTokenizer strToken = new StringTokenizer(
								attribute, ",");
						// getting sapAttCountSeaPro value
						sapAttCountSeaPro = strToken.countTokens();

						// adding two Attributes count
						sapAttCount = sapAttCountPro + sapAttCountSeaPro;
						// caling set product data method.
						LFSeasonProductAdoptionPlugin.setProductData(product,spLink, sapAttCount, st);
						LCSLogic.persist(product, true);
					}
				} else {
					LCSLog.debug("None of the Season-Product Links is Adopted :");
				}
			 } // SAP Functionality : End
			
		
		} catch (WTException e) {
			LCSLog.stackTrace(e);
		}
	}
}
