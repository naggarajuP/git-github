package com.lfusa.wc.axintegration.plugins;

import java.util.ArrayList;
import java.util.Collection;

import org.apache.commons.lang.StringUtils;

import com.lcs.wc.country.LCSCountry;
import com.lcs.wc.flextype.FlexType;
import com.lcs.wc.foundation.LCSLifecycleManaged;
import com.lcs.wc.foundation.LCSLogic;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.sourcing.LCSCostSheet;
import com.lcs.wc.supplier.LCSSupplier;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;
import com.lcs.wc.util.VersionHelper;
import wt.fc.WTObject;
import wt.part.WTPartMaster;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;

public class LFCostSheetAXValidation {

	/* private constructor */

	private LFCostSheetAXValidation() {

	}

	private static final String SKUTYPE = "SKU";
	private static final String sendToSAPKey = LCSProperties.get("com.lfusa.wc.sourcing.LFCostSheetSAPValidation.sendToSAPKey");
	private static final String TYPEDELIM = "\\";
	private static final String DELIMS = "[,]";
	//private static final String TYPEATT = "textArea derivedString";
	//private static final String TYPENUM = "currency float";
	private static final String COSTSHEETSTATUS = LCSProperties.get("com.lfusa.wc.sourcing.LFCostSheetIBTValidation.costSheetStatus");

	private static final String APPARELKEYS = "com.lfusa.wc.sourcing.LFCostSheetAXValidation.apparel.validationKeyList";
	private static final String ACCESSORIESKEYS = "com.lfusa.wc.sourcing.LFCostSheetAXValidation.accessories.validationKeyList";
	private static final String HOMEKEYS = "com.lfusa.wc.sourcing.LFCostSheetAXValidation.home.validationKeyList";
	private static final String FOOTWEARKEYS = "com.lfusa.wc.sourcing.LFCostSheetAXValidation.footwear.validationKeyList";
	
	private static final String vendorKey = LCSProperties.get("com.lfusa.wc.sourcing.LFCostSheetSAPValidation.vendorKey");
	private static final String htsCatageoryCodeKey = LCSProperties.get("com.lfusa.wc.sourcing.LFCostSheetAXValidation.htsCatCodeKey");
	
	
	private static final String sapValidationCommentsKey = LCSProperties.get("com.lfusa.wc.sourcing.LFCostSheetSAPValidation.sapValidationCommentsKey");

	private static final String SUCCESS = "com.lfusa.wc.sourcing.LFCostSheetSAPValidation.success";
	private static final String FAILURE = "com.lfusa.wc.sourcing.LFCostSheetSAPValidation.failure";
	
	private static final String axDivisionList = LCSProperties.get("com.lfusa.wc.AX.applicableDivision");
		
	private static String proDivList;
	private static WTPartMaster productMaster;
	private static LCSProduct product;

	public static void validateForAX(WTObject object) throws WTException {

		System.out.println("Validate for AX:: WT OBject method is calling..");
		
		if (object instanceof LCSCostSheet) {

			FlexType flextype;
			String heirarchyName = "";
			LCSCostSheet costSheetObj;
			String costsheetType;
			boolean validationResult = false;

			Collection<String> emptyAttributeList = new ArrayList<String>();

			costSheetObj = (LCSCostSheet) object;
			costsheetType = costSheetObj.getCostSheetType();
			LCSProduct prodtctObject = (LCSProduct)VersionHelper.latestIterationOf(costSheetObj.getProductMaster());
						
			String divisionValue = (String)prodtctObject.getValue("lfDivision");
			System.out.println("divisionValue---##::" + divisionValue);
			String costsheetStatus = (String)costSheetObj.getValue(COSTSHEETSTATUS);
			System.out.println("costsheetStatus---##::" + costsheetStatus);
			
			try{
				if (!SKUTYPE.equalsIgnoreCase(costsheetType) && axDivisionList.contains(divisionValue) && costsheetStatus.equalsIgnoreCase("sentToAX")) {
				
				System.out.println("Plugin will call only for AX Division List::");

				flextype = costSheetObj.getFlexType();
				heirarchyName = flextype.getFullName();

				/* Level One Validation */

				emptyAttributeList = levelOneValidation(costSheetObj,heirarchyName);
				System.out.println("emptyAttributeList will call only for AX Division List::"+emptyAttributeList);
				if (emptyAttributeList != null && emptyAttributeList.size() > 0) {
					validationResult = false;
				}

				else {
					validationResult = true;
				}

				if (!validationResult) {
					System.out.println("validateForibt() IF LOOP : "+ validationResult);
					setAXValidationComments(validationResult,costSheetObj, emptyAttributeList);
				}
				
				else {
					
					System.out.println("validateForibt() Else Loop::: "+ validationResult);
					emptyAttributeList.clear();
					
					setAXValidationComments(validationResult,costSheetObj, emptyAttributeList);
					saveObject(costSheetObj, validationResult);
					}
			}else if (!SKUTYPE.equalsIgnoreCase(costsheetType) && axDivisionList.contains(divisionValue)){
				 costSheetObj.setValue(sendToSAPKey, false);
				 costSheetObj.setValue(sapValidationCommentsKey, "");
				 saveObject(costSheetObj, true);
				
				
			}
			}catch(Exception e){
				e.printStackTrace();
			}
		}

	}

	/**
	 * 
	 * Administrator Save the Cost Sheet Object. void
	 * 
	 * @param costSheetObj
	 *            .
	 * @param validationResult
	 *            .
	 */
	private static void saveObject(LCSCostSheet costSheetObj,boolean validationResult) {
		System.out.println("Save Object..");
		try {
			String costSheetStatusValue1 = (String) costSheetObj.getValue(COSTSHEETSTATUS);
			
			if(!costSheetStatusValue1.equalsIgnoreCase("sentToAX")){
				 costSheetObj.setValue(sendToSAPKey, false);
			}
			
			else
			{
			costSheetObj.setValue(sendToSAPKey,Boolean.toString(validationResult));
			}
			LCSLogic.persist(costSheetObj, true);
			
		} catch (WTPropertyVetoException wpe) {
			wpe.printStackTrace();
		} 
		catch (WTException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * Administrator Level One validation : to check Empty values for AX
	 * mandatory Attributes. boolean
	 * 
	 * @param costSheetObj
	 *            .
	 * @param heirarchyName
	 *            .
	 * @return boolean.
	 */
	private static Collection<String> levelOneValidation(
			LCSCostSheet costSheetObj, String heirarchyName) {


		String[] costSheetKey = null;
		Collection<String> emptyAttributeList = new ArrayList<String>();
		String typeTemp = StringUtils.substringBefore(heirarchyName, TYPEDELIM);

		if (typeTemp.equals("Cost Sheet")) {
			typeTemp = "CostSheet";
		}

		Type type = Type.valueOf(typeTemp);
		System.out.println("Type is:::" + type);
		// Product Type Check
		switch (type) {

		case Apparel: {
			costSheetKey = LCSProperties.get(APPARELKEYS).split(DELIMS);
			break;
		}

		case Accessories: {
			costSheetKey = LCSProperties.get(ACCESSORIESKEYS).split(DELIMS);
			break;
		}

		case Home: {
			costSheetKey = LCSProperties.get(HOMEKEYS).split(DELIMS);
			break;
		}

		case Footwear: {
			costSheetKey = LCSProperties.get(FOOTWEARKEYS).split(DELIMS);
			break;
		}

		default:
			return null;
		}
		if (costSheetKey != null) {
			emptyAttributeList = getValues(costSheetKey, costSheetObj);

		} else {
			LCSLog.error(".levelOneValidation() The AX mandotory Attribute List is Empty.");
		}

		return emptyAttributeList;
	}

	private static Collection<String> getValues(String[] costSheetKey,LCSCostSheet costSheetObj) {

		System.out.println("getValues()..." + costSheetKey);
		
		Collection<String> attributeList = new ArrayList<String>();
				FlexType flexType = new FlexType();
		
		try 
		{
			
		String costSheetStatusValue = (String) costSheetObj.getValue(COSTSHEETSTATUS);

		System.out.println("costSheetStatusValue:::" + costSheetStatusValue);
		
		productMaster = (WTPartMaster) costSheetObj.getProductMaster();
		product = (LCSProduct) VersionHelper.latestIterationOf(productMaster);
		proDivList = product.getValue("lfDivision").toString();

		System.out.println("Sent to Ax ::: PROD DIV LIST:::" + proDivList);
		
		flexType = costSheetObj.getFlexType();
		String heirarchyName = flexType.getFullName();
		LCSCountry countryObj = new LCSCountry();
		  LCSLifecycleManaged managedObject = null;
		  
			if (costSheetStatusValue != null) 
			{
				if (FormatHelper.hasContent(costSheetStatusValue) && (axDivisionList.contains(proDivList) && costSheetStatusValue.equalsIgnoreCase("sentToAX"))) 
				{
					System.out.println("Inside TRY Block..");
				
							if(heirarchyName.contains("Apparel") ||heirarchyName.contains("Footwear") ||heirarchyName.contains("Home"))
					{						
						if( costSheetObj.getValue("lfCountryOfOrigin") != null){
							countryObj = (LCSCountry) costSheetObj.getValue("lfCountryOfOrigin");
					}
						
						String countryValue = countryObj.getName();
						
						if(countryValue==null) 
						{
							System.out.println("Contry Code:" + countryValue);
							attributeList.add("Country of Origin");
						}
						
						String name = costSheetObj.getName();
						System.out.println("CostSheet Name::" + name);
						
						 LCSSupplier supplierObj = new LCSSupplier();
				         if(costSheetObj.getValue(vendorKey) != null)
				            {
				                supplierObj = (LCSSupplier) costSheetObj.getValue(vendorKey);
				            }
				         
				            String vendorName = supplierObj.getName();
				            if(vendorName==null)
				            {
				                System.out.println("vendorName:" + vendorName);
				                attributeList.add("Vendor");
				            }
				            
				            if(costSheetObj.getValue(htsCatageoryCodeKey) !=null)
				            {
						       managedObject = (LCSLifecycleManaged) costSheetObj.getValue(htsCatageoryCodeKey);
						     }
						            
						            if(managedObject==null)
						            {
						            	 attributeList.add("HTS 1 # / Category Code");
						            }
							}
						}
						/*else if (FormatHelper.hasContent(costSheetStatusValue) && (axDivisionList.contains(proDivList) && !(costSheetStatusValue.equalsIgnoreCase("sentToAX")))) 
							{
								System.out.println("costSheetStatusValue...." + costSheetStatusValue);
								
								if(heirarchyName.contains("Apparel") ||heirarchyName.contains("Footwear") ||heirarchyName.contains("Home"))
								{
									
									if( costSheetObj.getValue("lfCountryOfOrigin") != null){
										countryObj = (LCSCountry) costSheetObj.getValue("lfCountryOfOrigin");
									}
											
									String countryValue = countryObj.getName();
									
									if(countryValue==null) 
									{
										System.out.println("Contry Code:" + countryValue);
										attributeList.add("Country of Origin");
										
									}
									
									String name = costSheetObj.getName();
									System.out.println("CostSheet Name::" + name);
									
									 LCSSupplier supplierObj = new LCSSupplier();
							         if(costSheetObj.getValue(vendorKey) != null)
							            {
							                supplierObj = (LCSSupplier) costSheetObj.getValue(vendorKey);
							            }
							         
							            String vendorName = supplierObj.getName();
							            if(vendorName==null)
							            {
							                System.out.println("vendorName:" + vendorName);
							                attributeList.add("Vendor");
							            }
							            
							            if(costSheetObj.getValue(htsCatageoryCodeKey) !=null)
							            {
							            	 managedObject = (LCSLifecycleManaged) costSheetObj.getValue(htsCatageoryCodeKey);
							            }
							            
							            if(managedObject==null)
							            {
							            	 attributeList.add("HTS 1 # / Category Code");
							            }
							            
							           
						}
						}*/
						
				}
				}

				catch (Exception e) {
					e.printStackTrace();
				}
				return attributeList;
				}

	private static void setAXValidationComments(boolean validationResult, LCSCostSheet costSheetObj, Collection<String> attributeList) throws WTException {
	
		System.out.println("setAXValidationComments::" + validationResult +"::::" + attributeList);
			
		String comment = "";
		
		try {
			// if the Validation is True
			if (validationResult) {
				// Success Comment From custom.lfusa.property
				comment = LCSProperties.get(SUCCESS);
				// Set the Sent to AX attribute and the Comments
				costSheetObj.setValue(sapValidationCommentsKey, comment);
				// Save the Object
				saveObject(costSheetObj, validationResult);
				}
			
			else {
				StringBuffer buf = new StringBuffer();
				for (int i = 0; i < attributeList.toArray().length; i++) {
					buf.append(attributeList.toArray()[i]).append("\n");
				}
				
				comment = new StringBuilder(LCSProperties.get(FAILURE)).append("\n").append(buf.toString()).toString();

				costSheetObj.setValue(sapValidationCommentsKey, comment);
				saveObject(costSheetObj, validationResult);
				
				System.out.println(".setAXValidationComments() Comments Set Failed: "+ validationResult);
				}
		} 
		catch (WTPropertyVetoException e) {
			LCSLog.error(".setAXValidationComments() - WTPropertyVetoException : "+ e);
		} catch (WTException e) {
			LCSLog.error(".setAXValidationComments() - WTException : " + e);
		}
		
		}
	
	private enum Type {
		/**
		 * Apparel, Accessories, Home.
		 */
		Apparel, Accessories, Home, CostSheet, Footwear
	}

}
