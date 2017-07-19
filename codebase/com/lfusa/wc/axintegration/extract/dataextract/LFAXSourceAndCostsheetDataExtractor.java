package com.lfusa.wc.axintegration.extract.dataextract;

import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import wt.part.WTPartMaster;
import wt.util.WTException;

import com.lcs.wc.country.LCSCountry;
import com.lcs.wc.foundation.LCSLifecycleManaged;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.foundation.LCSRevisableEntity;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.sourcing.LCSCostSheet;
import com.lcs.wc.sourcing.LCSSourcingConfig;
import com.lcs.wc.sourcing.LCSSourcingConfigMaster;
import com.lcs.wc.specification.FlexSpecification;
import com.lcs.wc.supplier.LCSSupplier;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.VersionHelper;
import com.lfusa.wc.axintegration.bean.LFCost;
import com.lfusa.wc.axintegration.bean.LFSource;
import com.lfusa.wc.axintegration.extract.LFAXExtractionHelper;
import com.lfusa.wc.axintegration.util.LFAXDisplayNameUtil;
import com.lfusa.wc.axintegration.util.LFAXIntegrationConstants;

public class LFAXSourceAndCostsheetDataExtractor {
	
	/**
	 * LOGGER Object.
	 */
	public static Logger LOG = Logger
			.getLogger(LFAXSourceAndCostsheetDataExtractor.class);
	
	public static void sourceDataExtractor(
			LCSSourcingConfig source , LFSource lfSource) 
					throws WTException {
		
		lfSource.setSourceName((String)source.getName());
		lfSource.setSourceSystemId(((Long)source.
				getBranchIdentifier()).toString());
		
	}
	public static void costsheetDataExtractor(
			LCSRevisableEntity rev , LFCost cost , LFSource lfSource ,  List<String> keys) 
					throws WTException {
	
		
		//LCSCostSheet cs = (LCSCostSheet)LCSCostSheetQuery.
		//		findObjectById(id);
		
		try {
			
			String id = (String) rev.
					getValue(LFAXIntegrationConstants.
							REV_COSTSHEET_SYSTEMID_KEY);
			LCSLifecycleManaged htsTarrif;
			
			String oid = "VR:com.lcs.wc.sourcing.LCSCostSheet:"+id;
			LCSCostSheet cs = (LCSCostSheet) VersionHelper.latestIterationOf(
					(LCSCostSheet)LCSQuery.findObjectById(oid));
			
			cs = (LCSCostSheet)VersionHelper.latestIterationOf(cs.getMaster());
			LCSSourcingConfigMaster sourceMaster = cs.getSourcingConfigMaster();

			LCSProduct product = (LCSProduct) VersionHelper.
					latestIterationOf(cs.getProductMaster());
			String productType = product.getFlexType().getTypeDisplayName();
			
			LCSSourcingConfig source = (LCSSourcingConfig)VersionHelper.
					latestIterationOf(sourceMaster);
			
			sourceDataExtractor(source, lfSource);
	
			Iterator<String> i = keys.iterator();
			
			LCSSupplier vendor = (LCSSupplier) cs.getValue("lfVendor");
			
			if(vendor != null) {
				cost.setCostsheetVendor(vendor.getName());
				cost.setXtsCode((String) vendor.getValue("lfSearchTermTwo"));
				cost.setCostsheetVendorCode((String)vendor.
						getValue("lfVendorNumber"));
			}
					
			LCSCountry country = (LCSCountry) cs.getValue("lfCountryOfOrigin");
			
			cost.setCostsheetName(cs.getName());
			
			if(cs.isPrimaryCostSheet()) {
				cost.setCostsheetIsPrimary("Yes");
			} else {
				cost.setCostsheetIsPrimary("No");
			}
			
	
			cost.setCostsheetSystemId(((Long) cs.
					getBranchIdentifier()).toString());
			
			String sizeDefSystemId = (String) rev.getValue(
					LFAXIntegrationConstants.REV_SIZE_DEFINITION_SYSTEMID_KEY);
			
			cost.setCostSizedefSystemId(sizeDefSystemId);
			
			WTPartMaster specMaster = cs.getSpecificationMaster();
			if(specMaster != null){
				FlexSpecification spec = (FlexSpecification)VersionHelper.
						latestIterationOf(specMaster);
				cost.setCostSpecification(spec.getName());
				cost.setCostSpecificationSystemId(((Long)spec.
						getBranchIdentifier()).toString());
			}	
			
			
		
				Pattern pattern = Pattern.compile("\\|~\\*~\\|");
			  
			  String sizeCatNames = cs.getApplicableSizeCategoryNames();
			  String applicableSizes = cs.getApplicableSizes();
			  
			  if(FormatHelper.hasContent(sizeCatNames)) {
				  Matcher matcher1 = pattern.matcher(sizeCatNames);
				  sizeCatNames =  matcher1.replaceAll(",");
				  sizeCatNames = sizeCatNames.replaceAll(",$", "");	
					cost.setCostProductSizeDefinition(sizeCatNames); 
			  }
			  
			  if(FormatHelper.hasContent(applicableSizes)) {
				  Matcher matcher2 = pattern.matcher(applicableSizes);
				  applicableSizes = matcher2.replaceAll(",");
				  applicableSizes = applicableSizes.replaceAll(",$", "");	  
					cost.setCostSize(applicableSizes);
			  }

	
			
			if(country != null){
				cost.setCOO(country.getName());
				cost.setCOOAcronym((String) country.
						getValue("countryAcronym"));
			}
			
			
			htsTarrif = (LCSLifecycleManaged) cs
					.getValue("lfHTSDuty1");
			if(htsTarrif != null){
				cost.setHTSTariff1(htsTarrif.getName());
			}
		
			htsTarrif = (LCSLifecycleManaged) cs
					.getValue("lfHTSDuty2");
			if(htsTarrif != null){
				cost.setHTSTariff2(htsTarrif.getName());
			}	
			
			htsTarrif = (LCSLifecycleManaged) cs
					.getValue("lfHTSDuty3");
			if(htsTarrif != null){
				cost.setHTSTariff3(htsTarrif.getName());
			}			
			
			htsTarrif = (LCSLifecycleManaged) cs
					.getValue("lfHTSDuty4");
			if(htsTarrif != null){
				cost.setHTSTariff4(htsTarrif.getName());
			}
			
			htsTarrif = (LCSLifecycleManaged) cs
					.getValue("lfHTSDuty5");
			if(htsTarrif != null){
				cost.setHTSTariff5(htsTarrif.getName());
			}	
			
			htsTarrif = (LCSLifecycleManaged) cs
					.getValue("lfHTSDuty6");
			if(htsTarrif != null){
				cost.setHTSTariff6(htsTarrif.getName());
			}
			
			
			
			
			while(i.hasNext()) {
				
				String key = i.next();
				LOG.debug("which key caused exception --- " + key);
				String value = LFAXDisplayNameUtil.getDisplayName(cs, key);
				
				
				if("lfCurrency".equalsIgnoreCase(key)) {
					cost.setCostsheetCurrency(value);
				}
				if("lfIncoTerms".equalsIgnoreCase(key)) {
					cost.setCostsheetIncoterms(value);
				}
				if("lfHTSValue1Item".equalsIgnoreCase(key)) {
					cost.setHTSValue1(value);
				}
				if("lfHTSValue2Item".equalsIgnoreCase(key)) {
					cost.setHTSValue2(value);
				}
				if("lfHTSValue3Item".equalsIgnoreCase(key)) {
					cost.setHTSValue3(value);
				}
				if("lfHTSValue4Item".equalsIgnoreCase(key)) {
					cost.setHTSValue4(value);
				}
				if("lfHTSValue5Item".equalsIgnoreCase(key)) {
					cost.setHTSValue5(value);
				}
				if("lfHTSValue6Item".equalsIgnoreCase(key)) {
					cost.setHTSValue6(value);
				}
	
				if("lfFirstCostItem".equalsIgnoreCase(key)) {
					cost.setFirstCost(value);
				}
				if("lfGrossPriceItem".equalsIgnoreCase(key)) {
					cost.setGrossPrice(value);
				}
				if("lfFreightCostItem".equalsIgnoreCase(key)) {
					cost.setFreight(value);
				}
				if("lfDrayageItem".equalsIgnoreCase(key)){
					cost.setDrayage(value);
				}					
				if("lfAdditionalDutyItem".equalsIgnoreCase(key)) {
					cost.setAdditionalDuty(value);
				}
				if("lfCommission".equalsIgnoreCase(key)) {
					cost.setCommission(value);
				}
				if("lfOtherCostItem".equalsIgnoreCase(key)) {
					cost.setOtherCostIncurredForLanding(value);
				}
				if("lfStandardCost".equalsIgnoreCase(key)) {
					cost.setStandardCost(value);
				}			
				
				if("Footwear".equalsIgnoreCase(productType) || "Apparel".equalsIgnoreCase(productType)) {
					
					if("lfSalesPriceUSorCA".equalsIgnoreCase(key)) {
						cost.setSellPrice(value);
					}
					
					if("lfRetailPriceUSorCA".equalsIgnoreCase(key)) {
						cost.setMSRP(value);
					}
				} else {
					
					if("lfSalesPriceUS$orCA$".equalsIgnoreCase(key)) {
						cost.setSellPrice(value);
					}	
					if("lfRetailPriceUS$orCA$".equalsIgnoreCase(key)) {
						cost.setMSRP(value);
					}
				}
				
				if("lfDistributionExpensesPer".equalsIgnoreCase(key)) {
					cost.setDistributionStorageExpPercentage(value);
				}	
				if("lfDistributionExpenses".equalsIgnoreCase(key)) {
					cost.setDistributionStorageExp(value);
				}			
				
				if("lfCustomerDiscountPer".equalsIgnoreCase(key)) {
					cost.setCustomerDiscountPercentage(value);
				}
				if("lfCustomerDiscount".equalsIgnoreCase(key)) {
					cost.setCustomerDiscount(value);
				}
				if("lfCustomerAllowancesPer".equalsIgnoreCase(key)) {
					cost.setCustomerAllowancePercentage(value);
				}	
				if("lfCustomerAllowances".equalsIgnoreCase(key)) {
					cost.setCustomerAllowance(value);
				}	
						
				if("lfRoyaltyFeesPer".equalsIgnoreCase(key)) {
					cost.setRoyaltyMarketingFeePercentage(value);
				}
				if("lfRoyaltyFees".equalsIgnoreCase(key)) {
					cost.setRoyaltyMarketingFee(value);
				}
				if("lfTotalIntExtExpenseUnit".equalsIgnoreCase(key)) {
					cost.setTotalInternalExternalExp(value);
				}	
				if("lfMisc".equalsIgnoreCase(key)) {
					cost.setMiscPercentage(value);
				}	
		
				if("lfMiscCostItem".equalsIgnoreCase(key)) {
					cost.setMiscCost(value);
				}
				if("status".equalsIgnoreCase(key)) {
					cost.setCostsheetStatus(value);
				}
				if("lfDuty".equalsIgnoreCase(key)) {
					cost.setTotalDuty(value);
				}
				if("gbgIntlGrossPriceItem".equalsIgnoreCase(key)) {
					cost.setFobPriceOc(value);
				}	
				if("gbgIntlGrossPriceCurrency".equalsIgnoreCase(key)) {
					cost.setFobCurrencyOc(value);
				}	
		
				if("gbgIntlSalesPriceUSorCA".equalsIgnoreCase(key)) {
					cost.setSellPriceOc(value);
				}
				if("gbgIntlSalesPriceUSorCACurrency".equalsIgnoreCase(key)) {
					cost.setSellPriceCurrencyOc(value);
				}
	
			}	
		} catch (NullPointerException ne) {
			LOG.error("No Cost sheet provided");
		} catch(NumberFormatException nfe) {
				LOG.error("No Cost sheet provided");
		}
	}
}
