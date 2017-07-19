package com.lfusa.wc.axintegration.extract;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.HashSet;

import javax.xml.bind.JAXBException;

import org.apache.log4j.Logger;

import wt.util.WTException;

import com.lcs.wc.foundation.LCSRevisableEntity;
import com.lcs.wc.foundation.LCSRevisableEntityQuery;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSProperties;
import com.lfusa.wc.axintegration.bean.LFAttributes;
import com.lfusa.wc.axintegration.bean.LFBom;
import com.lfusa.wc.axintegration.bean.LFBoms;
import com.lfusa.wc.axintegration.bean.LFColorway;
import com.lfusa.wc.axintegration.bean.LFColorways;
import com.lfusa.wc.axintegration.bean.LFCost;
import com.lfusa.wc.axintegration.bean.LFCosts;
import com.lfusa.wc.axintegration.bean.LFMaterial;
import com.lfusa.wc.axintegration.bean.LFProductSizeDef;
import com.lfusa.wc.axintegration.bean.LFProductSizeDefs;
import com.lfusa.wc.axintegration.bean.LFSeason;
import com.lfusa.wc.axintegration.bean.LFSource;
import com.lfusa.wc.axintegration.bean.LFSources;
import com.lfusa.wc.axintegration.bean.LFSpecification;
import com.lfusa.wc.axintegration.bean.LFSpecifications;
import com.lfusa.wc.axintegration.bean.LFStyle;
import com.lfusa.wc.axintegration.bean.LFStyles;
import com.lfusa.wc.axintegration.util.LFAXIntegrationConstants;
import com.lfusa.wc.axintegration.util.LFAXUtil;
import com.lfusa.wc.axintegration.xmlprocessor.LFAXXMLprocessor;
/**
 * LFAXextractionHelper class for AX Extraction.
 *
 * @author Administrator
 *
 */
public final class LFAXExtractionStarter {
	
	/**
	 * LOGGER Object.
	 */
	public static Logger LOG = Logger
			.getLogger(LFAXExtractionStarter.class);
	
	final static String DATE_FORMAT = LCSProperties.
			get("com.lfusa.axintegration.configuration.xml.dateFormat","yyyyMMdd");
	final static String TIME_FORMAT = LCSProperties.
			get("com.lfusa.axintegration.configuration.xml.timeFormatt","HHmmss");
	static String divisionCode="";
	/**
	 * Constructor.
	 */
	private LFAXExtractionStarter() {
		//this.styles = new LFStyles();
	}
		
	
	public static Map groupRevisableEntities(List<String> list)
			throws WTException {
	
		LOG.debug("Revisable Entities Grouped By --- " + list);
		Iterator<String> i = list.iterator();
		
		Map<String , List<LCSRevisableEntity>> map = 
				new HashMap<String, List<LCSRevisableEntity>>();
		
		
		
		while(i.hasNext()) {	
			String id = i.next();		
			
			String oid = "OR:com.lcs.wc.foundation.LCSRevisableEntity:"+id;

			LCSRevisableEntity rev = (LCSRevisableEntity) 
					//..LCSQuery.findObjectById(id);
					LCSRevisableEntityQuery.findObjectById(oid);
			
			
			LCSProduct product = LFAXExtractionHelper.getProduct(rev);
			
			String productoid = FormatHelper.getNumericObjectIdFromObject(product);
			//String skuid = (String)rev.getValue(LFAXIntegrationConstants.REV_COLORWAY_SYSTEMID_KEY);
			//String costsheetid = (String) rev.getValue(LFAXIntegrationConstants.REV_COSTSHEET_SYSTEMID_KEY);
			String sizeDefId = (String) rev.
					getValue(LFAXIntegrationConstants.REV_SIZE_DEFINITION_SYSTEMID_KEY);
			
			String unique = productoid  + sizeDefId;
			
			if(map.containsKey(unique)) {
				map.get(unique).add(rev);
			} else {
				List addingList = new ArrayList<LCSRevisableEntity>();
				addingList.add(rev);
				map.put(unique, addingList);
				
			}
		}
		return map;

	}
	/**
	 * List of REvObj Oids passed as List for extraction.
	 * @param revObjOdsList
	 * @throws WTException 
	 * @throws JAXBException 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void startingPointForAXExtraction(List<String> revObjOdsList , String userEmail) 
			throws WTException, JAXBException 
	{
		LFAXExtractionHelper.configureLogger();
		//PLM-180: set Sent to ERP = true
		//new set to capture all products sent to AX
		Set<LCSProduct> productsSet = new HashSet<LCSProduct>();
		
		LOG.info("Starting logger .... ");
		// Iterate over the list of oids to get the 
		// REvisable entity object
		
		Map map =  groupRevisableEntities(revObjOdsList);
		
		System.out.println("map------->" +map);
				
		// Get a set of the entries
		Set set = map.entrySet();
		
		// Get an iterator
		Iterator<Entry> setitr = set.iterator();

		int count = 1;
		// Display elements 
		while(setitr.hasNext()) 
		{
			Map.Entry entry = setitr.next();   
			List listofRevs = (List) entry.getValue();
			
			//Start : extraction of one Product-Size definition data
			LFStyles styles = new LFStyles();
			String dateString = new SimpleDateFormat(DATE_FORMAT).format(new Date());
			String timeString = new SimpleDateFormat(TIME_FORMAT).format(new Date());
			
			LFAXExtractionHelper.setDataForStyles(styles , dateString ,timeString , userEmail);
	
			Iterator<LCSRevisableEntity> i = listofRevs.iterator();
			
			List<LCSRevisableEntity> rev1=new ArrayList<LCSRevisableEntity>();
			
			while(i.hasNext()) 
			{
				LCSRevisableEntity rev = i.next();
				rev1.add(rev);
				//PLM-180: set Sent to ERP = true
				try{
					productsSet.add(LFAXExtractionHelper.getProduct(rev));
				}catch(Exception exp){
					exp.printStackTrace();
				}
			}
			startExtraction(rev1 , styles);
	
			LFAXXMLprocessor.generateOSCAXML(styles, dateString,timeString+"_"+count+"_"+divisionCode);
			count++;
			
			//End : extraction of one Product-Size definition data
		}
		
		//PLM-180: set Sent to ERP = true
		LFAXUtil.setSendtoAXOnProduct(productsSet);
	}

	public static void startExtraction(List<LCSRevisableEntity> rev,
			LFStyles lfStyles) 
			throws WTException  {
		lfStylesXMLNodeExtractor(rev , lfStyles);
	} 
	
	public static void lfStylesXMLNodeExtractor(List<LCSRevisableEntity> rev , 
			LFStyles lfStyles) 
			throws WTException {
				
	
		
		LFStyle style=lfStyleListXMLNodeExtractor(rev);
		lfStyles.setStyles(style);
		Iterator i=rev.iterator();
		LCSRevisableEntity revObj=null;
		while(i.hasNext())
		{
			revObj=(LCSRevisableEntity)i.next();
		}
		
		
		
		lfSeasonXMLNodeExtractor(revObj , lfStyles);
	}
	
	public static void lfSeasonXMLNodeExtractor(LCSRevisableEntity rev , 
			LFStyles lfStyles) 
			throws WTException {
		
		LFSeason lfSeason = lfStyles.getSeason();
		LFAXExtractionHelper.
				extractDataForSeasonNode(rev, lfSeason);
	}
	
	public static LFStyle lfStyleListXMLNodeExtractor(List<LCSRevisableEntity> rev) 
			throws WTException {
		
		LFStyle style = lfStyleXMLNodeExtractor(rev);
		
		return style;
	}
	
	public static LFStyle lfStyleXMLNodeExtractor(List<LCSRevisableEntity> rev) 
			throws WTException {
		
		LFStyle style = new LFStyle();
		Iterator i=rev.iterator();
		LCSRevisableEntity revObj=null;
		while(i.hasNext())
		{
			revObj=(LCSRevisableEntity)i.next();
		}
		LFAttributes attributes = style.getStyleAttributes();
		divisionCode=lfAttributesXMLNodeExtractor(revObj , attributes , style);
	
		LFColorways colorways = style.getStyleColorways();
		lfColorwaysListXMLNodeExtractor(rev , colorways);
		
		
		LFSources sources = style.getStyleSources();
		lfSourcesListXMLNodeExtractor(revObj , sources);
		
		LFSpecifications specs = style.getStyleSpecifications();
		lfSpecificationsListXMLNodeExtractor(revObj , specs);
		
		LFProductSizeDefs sizedefs = style.getStyleProductSizeDefs();
		lfProductSizeDefsListXMLNodeExtractor(revObj , sizedefs);
		return style;

	//	
	//	lfSourcesListXMLNodeExtractor(rev);
	//	lfSpecificationsListXMLNodeExtractor(rev);
	//	lfProductSizeDefsListXMLNodeExtractor(rev);
	}
	
	public static String lfAttributesXMLNodeExtractor(LCSRevisableEntity rev , 
			LFAttributes attributes , LFStyle lfStyle) throws WTException {
		
		String divCode=LFAXExtractionHelper
		.extractDataForAttributeNode(rev , attributes , lfStyle);
		return divCode;
	}
	
	public static void lfColorwaysListXMLNodeExtractor(
			List<LCSRevisableEntity> rev , 
			LFColorways lfColorways) throws WTException {
		
		Iterator i=rev.iterator();
		
		LCSRevisableEntity revObj=null;
		while(i.hasNext())
		{
			
			revObj=(LCSRevisableEntity)i.next();
			lfColorways.getStyleColorwaysList().add(
					lfColorwayXMLNodeExtractor(revObj));
		}
		
		
	}
	
	public static LFColorway lfColorwayXMLNodeExtractor(
			LCSRevisableEntity rev) throws WTException {
		
		LFColorway lfColorway = new LFColorway();
		LFAXExtractionHelper.extractDataForColorwayNode(
				rev , lfColorway);
		return lfColorway;
	}
	
	public static void lfSourcesListXMLNodeExtractor(
			LCSRevisableEntity rev , LFSources lfSources)
					throws WTException {
		
		lfSources.getStyleSourcesList().add(
				lfSourceXMLNodeExtractor(rev));
	}
	
	public static LFSource lfSourceXMLNodeExtractor(
			LCSRevisableEntity rev) throws WTException {
		
		LFSource lfSource = new LFSource();
		LFAXExtractionHelper.extractDataForSourceNode(
				rev , lfSource);
		
		lfCostsListXMLNodeExtractor(rev , lfSource);
		return lfSource;
	}
	
	public static void lfCostsListXMLNodeExtractor(LCSRevisableEntity rev , 
			LFSource lfSource) throws WTException {
		
		LFCosts costs = lfSource.getCosts();
		
		costs.getCostsList().add(lfCostXMLNodeExtractor(rev , lfSource));
		
	}
	
	public static LFCost lfCostXMLNodeExtractor(LCSRevisableEntity rev , 
			LFSource lfSource) 
			throws WTException {
		
		LFCost cost = new LFCost();
		LFAXExtractionHelper.extractDataForCostsheetNode(rev , cost , lfSource);
		return cost;
			
	}
	
	public static void lfSpecificationsListXMLNodeExtractor(
			LCSRevisableEntity rev , LFSpecifications lfSpecs)
					throws WTException {
		
		lfSpecs.getStyleSpecificationsList().add(
				lfSpecificationXMLNodeExtractor(rev));
	}
	
	public static LFSpecification lfSpecificationXMLNodeExtractor(
			LCSRevisableEntity rev) throws WTException {
	
		LFSpecification lfSpec = new LFSpecification();
		LFAXExtractionHelper.extractDataForSpecificationNode(rev, lfSpec);
		
		lfBomsListXMLNodeExtractor(rev , lfSpec);
		
		
		return lfSpec;
	}
	
	public static void lfBomsListXMLNodeExtractor(
			LCSRevisableEntity rev , LFSpecification lfSpec) 
					throws WTException {
		
		LFBoms boms = lfSpec.getSpecificationBoms();
		
		boms.getBomsList().add(lfBomXMLNodeExtractor(rev));
	}
	
	public static LFBom lfBomXMLNodeExtractor(LCSRevisableEntity rev)
			throws WTException {
		
		
		LFBom lfBom = new LFBom();
		
		LFAXExtractionHelper.extractDataForBOMNode(rev, lfBom);
		
		//lfMaterialsListXMLNodeExtractor(rev , lfBom);
	
		return lfBom;
	}
	
	public static void lfMaterialsListXMLNodeExtractor(
			LCSRevisableEntity rev , LFBom lfBom) throws WTException {
		
	//	LFMaterials lfMaterials = lfBom.getMaterials();
		
	//	lfMaterials.getMaterialsList().add(lfMaterialXMLNodeExtractor(rev));
		
	}
	
	public static LFMaterial lfMaterialXMLNodeExtractor(LCSRevisableEntity rev)
			throws WTException {
		
	//	LFMaterial lfMaterial = new LFMaterial();
		
		//LFAXExtractionHelper.extractDataForMaterialNode(rev, lfMaterial);
		return null;
	//	return lfMaterial;
	}
	
	public static void lfProductSizeDefsListXMLNodeExtractor(
			LCSRevisableEntity rev , LFProductSizeDefs lfSizeDefs) 
					throws WTException {
		
		lfSizeDefs.getStyleProductSizeDefsList().add(
				lfProductSizeDefXMLNodeExtractor(rev));
		
	}
	
	public static LFProductSizeDef lfProductSizeDefXMLNodeExtractor(LCSRevisableEntity rev) 
			throws WTException {
		
		LFProductSizeDef lfSizeDef = new LFProductSizeDef();
		
		LFAXExtractionHelper.extractDataForProductSizeDefNode(rev, lfSizeDef);
		
		return lfSizeDef;
	}
	
	
}
