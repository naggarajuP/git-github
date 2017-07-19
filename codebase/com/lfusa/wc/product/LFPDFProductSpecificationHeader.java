/*
 * PDFProductSpecificationHeader.java
 * 
 * Created on August 22, 2005, 11:00 AM
 */

package com.lfusa.wc.product;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import wt.util.WTException;
import wt.util.WTProperties;

import com.lcs.wc.client.web.PDFGeneratorHelper;
import com.lcs.wc.client.web.pdf.PDFHeader;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.measurements.LCSMeasurements;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.sizing.ProductSizeCategory;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;
import com.lowagie.text.BadElementException;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Image;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;

/**
 * Generates the Header for a ProductSpecification
 * 
 * NOTE: This class is what is used for the OOB Header. In order use a different
 * Header for the Product Specification a new class needs to be created that
 * implements com.lcs.wc.client.web.pdf.PDFHeader
 * 
 * NOTE2: This implementation is an extension of PdfPTable, the getPDFHeader
 * will return another instance of PDFProductSpecificationHeader with the table
 * filled, which can be added to a Document
 * 
 * @author Ashrujit
 */
public class LFPDFProductSpecificationHeader extends PdfPTable implements
		PDFHeader {

	private PdfPCell cell = null;
	private String FORMLABEL = "FORMLABEL";
	private String DISPLAYTEXT = "DISPLAYTEXT";
	private Map params = null;
	private final PDFGeneratorHelper pgh = new PDFGeneratorHelper();
	private LFPDFHelper lfpdfHelper;
	public final String webHomeLocation = LCSProperties
			.get("flexPLM.webHome.location");
	private static String wthome = "";
	private static String imageFile = "";
	float fixedHeight = 100.0f;
	private List<LCSMeasurements> measurementcomponentList = new ArrayList<LCSMeasurements>();
	private static boolean DEBUG = true;

	// LCSProperties.getBoolean("com.lfusa.wc.product.LFPDF.verbose");

	private void init() {
		// pgh = new PDFGeneratorHelper();

		imageFile = LCSProperties.get(
				"com.lcs.wc.product.PDFProductSpecificationHeader.headerImage",
				FormatHelper.formatOSFolderLocation(webHomeLocation)
						+ "lfusa/images/LF_LOGO.gif");

		try {
			wthome = WTProperties.getServerProperties().getProperty("wt.home");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		imageFile = wthome + File.separator + imageFile;
		LCSLog.debug("PDFProductSpecificationHeader.init - imageFile :"
				+ imageFile);
	}

	/**
	 * Creates a new instance of PDFProductSpecificationHeader
	 */
	public LFPDFProductSpecificationHeader() {

	}

	private LFPDFProductSpecificationHeader(int cols) {
		super(cols);
		init();
	}

	public void InitializeComponentList(Collection KeyList) throws WTException {
		List list = new ArrayList(KeyList);
		LCSMeasurements mobject;
		for (int index = 0; index <= list.size() - 1; index++) {
			String contentsOfKeys = (String) list.get(index);

			if (contentsOfKeys.indexOf("Measurements") != -1) {
				String keyString = "";
				keyString = contentsOfKeys.substring(
						contentsOfKeys.indexOf("VR:"), contentsOfKeys.length());
				mobject = (LCSMeasurements) LCSQuery.findObjectById(keyString);
				measurementcomponentList.add(mobject);
			}
		}
	}

	/**
	 * returns another instance of PDFProductSpecificationHeader with the table
	 * filled, which can be added to a Document
	 * 
	 * @param params
	 * @throws WTException
	 * @return
	 */
	public PDFHeader getPDFHeader(Map params) throws WTException {
		printLog("LFPDFProductSpecificationHeader.getPDFHeader()");
		LFPDFProductSpecificationHeader ppsh = null;
		try {
			this.params = params;
			ppsh = new LFPDFProductSpecificationHeader(1);
			ppsh.setWidthPercentage(95.0f);
			float[] widths = { 100.0f };
			lfpdfHelper = new LFPDFHelper(params);
			ppsh.setWidths(widths);
			ppsh.addCell(firstRow());
			LCSLog.debug("LFPDFProductSpecificationHeader.init - firstRow :");
			ppsh.addCell(secondRow());
			LCSLog.debug("LFPDFProductSpecificationHeader.init - secondRow :");
			/************ Changes build 4.18 ***************/
			ppsh.addCell(thirdRow());
			/*********************************************/
			lfpdfHelper = null;
		} catch (Exception e) {
			LCSLog.debug("LFPDFProductSpecificationHeader.init - Exception :"
					+ e);
		}
		return ppsh;
	}

	/**
	 * gets the Height for this header
	 * 
	 * @return
	 */
	public float getHeight() {
		return fixedHeight;
	}

	private PdfPCell createImageCell() throws BadElementException,
			MalformedURLException, IOException {
		Image img = Image.getInstance(imageFile);
		LCSLog.debug("LFPDFProductSpecificationHeader.createImageCell - img :"
				+ img);
		PdfPCell cell = new PdfPCell(img, true);
		cell.setUseBorderPadding(true);
		cell.setPadding(1.0f);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
		return cell;

	}

	private PdfPCell firstRow() {
		PdfPCell tableCell = null;
		try {
			PdfPTable table = new PdfPTable(2);
			float[] widths = { 10.0f, 90.0f };
			table.setWidths(widths);
			table.addCell(createImageCell());
			LCSLog.debug("LFPDFProductSpecificationHeader.createImageCell - firstRow created :");
			table.addCell(createFirstRowData());

			tableCell = new PdfPCell(table);
			// tableCell.setBorder(0);
			tableCell.setBorderColor(pgh.getColor(pgh.BLACK));
			tableCell.setHorizontalAlignment(Element.ALIGN_LEFT);
			tableCell.setVerticalAlignment(Element.ALIGN_MIDDLE);

		} catch (Exception e) {
			LCSLog.debug("LFPDFProductSpecificationHeader.firstRow - Exception :"
					+ e);

		}
		return tableCell;

	}

	private PdfPCell secondRow() throws WTException {
		PdfPTable table = new PdfPTable(2);
		float[] widths = { 90.0f, 10.0f };
		PdfPCell tableCell = null;
		try {
			table.setWidths(widths);
			tableCell = new PdfPCell(table);
			// tableCell.setBorder(0);
			tableCell.setBorderColor(pgh.getColor(pgh.BLACK));
			tableCell.setHorizontalAlignment(Element.ALIGN_LEFT);
			tableCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			table.addCell(createSecondRowData());
			LCSLog.debug("PDFProductSpecificationHeader.createImageCell - secondRowData created :");
			table.addCell(LFPDFHelper.createImageCellProductThumbnail());
		} catch (Exception e) {
			LCSLog.debug("LFPDFProductSpecificationHeader.secondRow - Exception :"
					+ e);
		}
		return tableCell;
	}

	private String getUniqueSizeRanges(List<LCSMeasurements> list,
			boolean isHome) {
		String sizerangedisplay = "";
		// This set is required to collect only unique product size categories
		Set<ProductSizeCategory> set = new HashSet<ProductSizeCategory>();
		for (int index = 0; index <= list.size() - 1; index++) {
			LCSMeasurements measname = list.get(index);
			LCSLog.debug("PDFProductSpecificationHeader.getUniqueSizeRanges - measname :"
					+ measname);
			ProductSizeCategory prodsizecat = measname.getProductSizeCategory();
			String sizerangeName = "";
			if (prodsizecat != null) {
				if (set.add(prodsizecat)) {
					String size1val = prodsizecat.getSizeValues();
					if (size1val != null) {
						sizerangeName = formatsizeRange(prodsizecat
								.getSizeValues());
					}
					if (isHome) {
						LCSLog.debug("PDFProductSpecificationHeader.getUniqueSizeRanges - isHome :"
								+ isHome);
						String size2vals = prodsizecat.getSize2Values();
						if (DEBUG) {
							LCSLog.debug("LFPDFProductSpecificationHeader.getUniqueSizeRanges()home prodsizecat.getSize2Values()\t"
									+ prodsizecat.getSize2Values());
						}
						String forHomesize2val = "";
						if (size2vals != null) {
							forHomesize2val = formatsizeRange(size2vals);
						}
						if (DEBUG) {
							LCSLog.debug("LFPDFProductSpecificationHeader.getUniqueSizeRanges() forHomesize2val\t"
									+ forHomesize2val);
						}
						if (forHomesize2val != null
								&& !"".equals(forHomesize2val.trim())) {
							sizerangeName = sizerangeName + ":-"
									+ forHomesize2val;
						}
					}
					sizerangedisplay = !"".equals(sizerangedisplay.trim()) ? sizerangedisplay
							+ ";" + sizerangeName
							: sizerangeName;

				} else {
					continue;
				}

			} else {
				continue;
			}

		}
		sizerangedisplay = sizerangedisplay.trim().length() == 0 ? LFProductConstants.NA
				: sizerangedisplay;
		return sizerangedisplay;

	}

	private String formatsizeRange(String name) {

		String returnval = "";
		StringTokenizer parser = new StringTokenizer(name,
				LFProductConstants.MOA_DELIMITER);
		while (parser.hasMoreElements()) {
			String token = parser.nextToken();
			returnval = !"".equals(returnval.trim()) ? returnval + "," + token
					: token;
		}
		LCSLog.debug("PDFProductSpecificationHeader.returnval - returnval :"
				+ returnval);
		return returnval;
	}

	/*********************************** 6.11 ********************************************/
	/*
	 * Dinesh : ITC for Build 6.11 changed :: common techpack layout for all
	 * Business Areas
	 */

	private PdfPCell createFirstRowData() {

		LCSProduct product = LFPDFHelper.getProduct();
		LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - product :"
				+ product);
		String type = product.getFlexType().getFullName();
		LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - type :"
				+ type);
				
		/*
		 * Build 7.5: Start
		 */
		 
		 if(type.equalsIgnoreCase("Accessories"))
		{
			LCSLog.debug("Genarting for Accessories");
			
			PdfPTable table1 = null;
			try {
				table1 = new PdfPTable(2);
				float widths[] = { 80.0f, 20.0f };
				table1.setWidths(widths);
			} catch (Exception e) {
				LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - Exception :" + e);
			}
			
			
			// Product Name
			table1.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.prodNameKey, FORMLABEL, DISPLAYTEXT));
			// Division Name
			table1.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.divisionKey, FORMLABEL, DISPLAYTEXT));
			// Season Name
			try {
				table1.addCell(LFPDFHelper.getSeasonCell(FORMLABEL, DISPLAYTEXT));
			} 
			catch (DocumentException e) {
				LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - DocumentException :" + e);
			} catch (WTException e) {
				LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - WTException :"+ e);
			}
			
			// Date Modified
			table1.addCell(LFPDFHelper.createAttributeDataCell(
					LFProductConstants.dateModified, FORMLABEL, getCurrentDate(),
					DISPLAYTEXT));

			PdfPCell tableCell1 = new PdfPCell(table1);
			tableCell1.setPadding(1.0f);
			// tableCell.setBorder(0);
			tableCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
			tableCell1.setVerticalAlignment(Element.ALIGN_MIDDLE);

			printLog("LFPDFProductSpecificationHeader.createFirstRowData()--------------------->>END");

			return tableCell1;
		}
		
		else
		{
			LCSLog.debug("Genarting TP for either Apparel or Home");
			
		PdfPTable table = null;
		try {
			table = new PdfPTable(2);
			float widths[] = { 80.0f, 20.0f };
			table.setWidths(widths);
		} catch (Exception e) {
			LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - Exception :"
					+ e);
		}
		// Product Name
		table.addCell(LFPDFHelper.getProductAttributeCell(
				LFProductConstants.prodNameKey, FORMLABEL, DISPLAYTEXT));
		// Division Name
		table.addCell(LFPDFHelper.getProductAttributeCell(
				LFProductConstants.divisionKey, FORMLABEL, DISPLAYTEXT));
		// Season Name
		try {
			table.addCell(LFPDFHelper.getSeasonCell(FORMLABEL, DISPLAYTEXT));
		} catch (DocumentException e) {
			LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - DocumentException :"
					+ e);
		} catch (WTException e) {
			LCSLog.debug("PDFProductSpecificationHeader.createFirstRowData - WTException :"
					+ e);
		}
		// Date Printed
		table.addCell(LFPDFHelper.createAttributeDataCell(
				LFProductConstants.datePrinted, FORMLABEL, getCurrentDate(),
				DISPLAYTEXT));

		PdfPCell tableCell = new PdfPCell(table);
		tableCell.setPadding(1.0f);
		// tableCell.setBorder(0);
		tableCell.setHorizontalAlignment(Element.ALIGN_LEFT);
		tableCell.setVerticalAlignment(Element.ALIGN_MIDDLE);

		printLog("LFPDFProductSpecificationHeader.createFirstRowData()--------------------->>END");

		return tableCell;
		}
	}

	/*********************************** 6.11 ********************************************/
	/*
	 * Dinesh : ITC for Build 6.11 changed :: common techpack layout for all
	 * Business Areas
	 */
	private PdfPCell createSecondRowData() {

		printLog("LFPDFProductSpecificationHeader.createSecondRowData()--------------------->>START");

		LCSProduct product = LFPDFHelper.getProduct();
		String flexType = product.getFlexType().getFullName();
		
		
		/*
		 * Build 7.5 : ITC Start
		 * below "If" condition works only for accessories Type
		 */
		 
		 	if(flexType.equalsIgnoreCase("Accessories"))
			{
				PdfPTable accessoriesTable = null;
				PdfPCell accessoriesTableCell =null;
				
				try {
				accessoriesTable = new PdfPTable(3);
							
				float[] widths = {32.0f, 34.0f, 34.0f};
							
				accessoriesTable.setWidths(widths);
						
			// Product Reference #
			PdfPCell productRef = LFPDFHelper.getprodRefAttributeCell(LFProductConstants.SMART_CODE_KEY, FORMLABEL, DISPLAYTEXT);
			productRef.setColspan(3);
			productRef.setHorizontalAlignment(Element.ALIGN_LEFT);
			productRef.setVerticalAlignment(Element.ALIGN_MIDDLE);
						
			accessoriesTable.addCell(productRef);
			
			//	accessoriesTable.addCell(LFPDFHelper.createBlankDataCell());
			//	accessoriesTable.addCell(LFPDFHelper.createBlankDataCell());
			
			
			// Product Sub Category:			
						
			accessoriesTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.PROD_SUB_CATEGORY_KEY, FORMLABEL, DISPLAYTEXT));
			
			// Brand
			accessoriesTable.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.BRAND_KEY, FORMLABEL, DISPLAYTEXT));
			// Property
			accessoriesTable.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.propertykey, FORMLABEL, DISPLAYTEXT));
			// Size Group
			accessoriesTable.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.GENDER_KEY, FORMLABEL, DISPLAYTEXT));
			// Customer
			accessoriesTable.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.PRODUCT_CUSTOMERRETAILER_KEY, FORMLABEL,
					DISPLAYTEXT));
			// Licensor Status
			accessoriesTable.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.licensorStatusKey, FORMLABEL,
					DISPLAYTEXT));
					
			// Primary Material:
			
			float[] primaryWidths = { 11.0f, 89.0f };	
			PdfPCell primaryRef = LFPDFHelper.getProductAttributeCell(LFProductConstants.primaryMaterialKey, FORMLABEL, DISPLAYTEXT);
			primaryRef.getTable().setWidths(primaryWidths);
			primaryRef.setColspan(3);
			primaryRef.setPaddingLeft(0);
			primaryRef.setHorizontalAlignment(Element.ALIGN_LEFT);
			primaryRef.setVerticalAlignment(Element.ALIGN_MIDDLE);
			accessoriesTable.addCell(primaryRef);
			
			/* if you made primaryRef.setColspan == 2  please un-comment below one line.*/
				
			// accessoriesTable.addCell(LFPDFHelper.createBlankDataCell());
			// accessoriesTable.addCell(LFPDFHelper.createBlankDataCell());
								
			} catch (Exception e) {
				LCSLog.debug("PDFProductSpecificationHeader.createSecondRowData - Exception :" + e);
			}
	
			// Generate PDF table
				accessoriesTableCell = new PdfPCell(accessoriesTable);
				accessoriesTableCell.setPadding(1.0f);
				//accessoriesTableCell.setBorder(0);
				accessoriesTableCell.setHorizontalAlignment(Element.ALIGN_LEFT);
				accessoriesTableCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
				
				printLog("LFPDFProductSpecificationHeader.createSecondRowData()--------------------->>END !!!!!!!!!!!!!");
				return accessoriesTableCell;
		}
		
		// This Else condition will works only Apparel and Home Type.
		else if(flexType.equalsIgnoreCase("Apparel") || flexType.equalsIgnoreCase("Home"))
		{
		PdfPTable table = null;
		PdfPCell tableCell = null;

		try {

			table = new PdfPTable(3);
			float[] widths = { 33.0f, 33.0f, 34.0f };

			table.setWidths(widths);
			// Spec Name
			PdfPCell specCell = LFPDFHelper.getspecAttributeCell(
					LFProductConstants.specNameKey, FORMLABEL, DISPLAYTEXT);
			specCell.setColspan(3);
			specCell.setHorizontalAlignment(Element.ALIGN_LEFT);
			specCell.setVerticalAlignment(Element.ALIGN_MIDDLE);

			table.addCell(specCell);
			// Licensor
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.licensorKey, FORMLABEL, DISPLAYTEXT));
			// Brand
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.BRAND_KEY, FORMLABEL, DISPLAYTEXT));
			// Property
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.propertykey, FORMLABEL, DISPLAYTEXT));
			// Size Group
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.GENDER_KEY, FORMLABEL, DISPLAYTEXT));
			// Customer
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.PRODUCT_CUSTOMERRETAILER_KEY, FORMLABEL,
					DISPLAYTEXT));
			// Licensor Status
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.licensorStatusKey, FORMLABEL,
					DISPLAYTEXT));
			// Pattern/Sloper#
			table.addCell(LFPDFHelper.getProductAttributeCell(
					LFProductConstants.patternslopernoNew, FORMLABEL,
					DISPLAYTEXT));
			// two empty cells

			table.addCell(LFPDFHelper.createBlankDataCell());
			table.addCell(LFPDFHelper.createBlankDataCell());

		}
		catch (Exception e) {
			LCSLog.debug("PDFProductSpecificationHeader.createSecondRowData - Exception :" + e);
		}
			// Generate PDF table
			tableCell = new PdfPCell(table);
			tableCell.setPadding(1.0f);
			// tableCell.setBorder(0);
			tableCell.setHorizontalAlignment(Element.ALIGN_LEFT);
			tableCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
			printLog("LFPDFProductSpecificationHeader.createSecondRowData()--------------------->>END");
				
			return tableCell;
		}
		
		
		// This Condition will works only for Type: Footwear
		/*
		/ Start: Dinesh
		*/
		else if(flexType.equalsIgnoreCase("Footwear"))
		{
			System.out.println("This is Footwear only..");
			
			PdfPTable footwearTable = null;
			
			try {
				
				footwearTable = new PdfPTable(3);
				float[] widths1 = { 33.0f, 32.0f, 35.0f };
				
				footwearTable.setWidths(widths1);
				
				PdfPCell specCell1 = LFPDFHelper.getspecAttributeCell(LFProductConstants.specNameKey, FORMLABEL, DISPLAYTEXT);
				specCell1.setColspan(3);
				specCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
				specCell1.setVerticalAlignment(Element.ALIGN_MIDDLE);

				footwearTable.addCell(specCell1);
				
				// Licensor
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.licensorKey, FORMLABEL, DISPLAYTEXT));
				// Brand
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.BRAND_KEY, FORMLABEL, DISPLAYTEXT));
				// Property
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.propertykey, FORMLABEL, DISPLAYTEXT));
				// Size Group
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.GENDER_KEY, FORMLABEL, DISPLAYTEXT));
				// Customer
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.PRODUCT_CUSTOMERRETAILER_KEY, FORMLABEL,DISPLAYTEXT));
				// Licensor Status
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.licensorStatusKey, FORMLABEL,DISPLAYTEXT));
				
				// way -1
				
				// Last#
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.lastAttKey, FORMLABEL,DISPLAYTEXT));
				// Construction #
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.constructionAttKey, FORMLABEL,DISPLAYTEXT));
				//PLM 160 Techpack changes START
				// Silhouette
				footwearTable.addCell(LFPDFHelper.getProductAttributeCell(LFProductConstants.SHORTDESCRIPTION_KEY, FORMLABEL,DISPLAYTEXT));
				//PLM 160 Techpack changes END
				//footwearTable.addCell(LFPDFHelper.createBlankDataCell());
				
				// way -2
				
				/*PdfPCell constructionCell = LFPDFHelper.getProductAttributeCell(LFProductConstants.constructionAttKey, FORMLABEL,DISPLAYTEXT);
				constructionCell.setColspan(2);
				footwearTable.addCell(constructionCell);*/
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			
		PdfPCell  tableCell1 = new PdfPCell(footwearTable);
		tableCell1.setPadding(1.0f);
		tableCell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		tableCell1.setVerticalAlignment(Element.ALIGN_MIDDLE);
		printLog("LFPDFProductSpecificationHeader.createSecondRowData()--------------------->>END");
		
		return tableCell1;
	}
	
	
	/* End */
		
		return cell;
		}
		

	private String getCurrentDate() {
		DateFormat dateformat = new SimpleDateFormat("MM/dd/yyyy");
		Date date = new Date();
		return dateformat.format(date);
	}
	

	private void printLog(Object printObj) {
		if (DEBUG)
			System.out.println(printObj);
	}

	/*********************************** 6.11 ********************************************/
	/*
	 * Dinesh : ITC for Build 6.11 changed :: common techpack layout for all
	 * Business Areas
	 */
	private PdfPCell thirdRow() {
		LCSProduct product = LFPDFHelper.getProduct();
		String type = product.getFlexType().getFullName();
		PdfPCell tableCell = null;
		try {
			PdfPTable table = new PdfPTable(1);
			float[] widths = { 100.0f };
			table.setWidths(widths);
			table.addCell(LFPDFHelper.createAttributeDataCell(
					LFProductConstants.sizeRange, FORMLABEL,
					getUniqueSizeRanges(measurementcomponentList, false),
					DISPLAYTEXT));

			tableCell = new PdfPCell(table);
			// tableCell.setBorder(0);
			tableCell.setPadding(1.0f);
			tableCell.setBorderColor(pgh.getColor(pgh.BLACK));
			tableCell.setHorizontalAlignment(Element.ALIGN_LEFT);
			tableCell.setVerticalAlignment(Element.ALIGN_LEFT);

		} catch (Exception e) {
			LCSLog.debug("LFPDFProductSpecificationHeader.thirdRow - Exception :"
					+ e);
		}
		return tableCell;
	}

}
