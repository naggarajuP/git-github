package com.lfusa.wc.axintegration.util;

import java.util.*;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSProperties; 

import wt.util.WTException;
import wt.util.WTPropertyVetoException;

import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.product.LCSProductLogic;

	/**
	 * LFAXUtil class for util methods.
	 * @author 
	 */
	public final class LFAXUtil 
	{
		public static Logger log = Logger.getLogger(LFAXUtil.class);
		
		private static final String CLASSNAME = "LFAXUtil:";
		
		public static void setSendtoAXOnProduct(Set<LCSProduct> axProductsSet) 
		{
			log.info(CLASSNAME +"setSendtoAXOnProduct()" + axProductsSet);
			java.util.Iterator<LCSProduct> productsSetItr = axProductsSet.iterator();

			// Iterating Product OID List
			while (productsSetItr.hasNext()) 
			{
				try 
				{
					LCSProduct product=productsSetItr.next();
					LCSProductLogic lcsProductLogic=new LCSProductLogic();
					if (product!=null) 
					{
						//Get the value for status of ERP
						String statusERP = (String) product.getValue("lfRootSentToSap");
						log.info(CLASSNAME +"setSendtoAXOnProduct : SEND TO ERP" + statusERP);
						
						if (!FormatHelper.hasContent(statusERP)) 
							statusERP = "false";
						
						// settting sent to ERP
						if (statusERP.equalsIgnoreCase("false"))
						{
							product.setValue("lfRootSentToSap", Boolean.TRUE);
							lcsProductLogic.persist(product,true);
							log.info(CLASSNAME +"setSendtoAXOnProduct()+" +"Sent to ERP  was true");
						}
					}

				} catch (WTException e) {
					log.info(CLASSNAME +"setSendtoAXOnProduct - WTException : " + e);
				} catch (WTPropertyVetoException e) {
					e.printStackTrace();
					log.info(CLASSNAME  +"status To ERP Cost Sheet  - WTPropertyVetoException : "+ e);
				}
			}//end of while
			
		}//end of method
		
	}//end of class
