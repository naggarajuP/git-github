package com.lfusa.wc.sample;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

import com.lcs.wc.db.FlexObject;
import com.lcs.wc.document.LCSDocument;
import com.lcs.wc.document.LCSDocumentClientModel;
import com.lcs.wc.document.LCSDocumentQuery;
import com.lcs.wc.flextype.FlexTypeCache;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.sample.LCSSample;
import com.lcs.wc.sample.LCSSampleQuery;
import com.lcs.wc.sample.LCSSampleRequest;
import com.lcs.wc.season.LCSSeason;
import com.lcs.wc.season.LCSSeasonProductLink;
import com.lcs.wc.season.LCSSeasonQuery;
import com.lcs.wc.season.SeasonProductLocator;
import com.lcs.wc.sourcing.LCSSourcingConfig;
import com.lcs.wc.sourcing.LCSSourcingConfigMaster;
import com.lcs.wc.specification.FlexSpecQuery;
import com.lcs.wc.specification.FlexSpecToSeasonLink;
import com.lcs.wc.specification.FlexSpecification;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;
import com.lcs.wc.util.VersionHelper;

import wt.doc.WTDocumentMaster;
import wt.fc.ObjectReference;
import wt.fc.WTObject;
import wt.part.WTPartMaster;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;
import wt.vc.Mastered;

public class LFAssociateLatestGeneratedTechpack {
	
	/**
	 * boolean DEBUG.
	 * Verbose for Debug statements.
	 * 
	 */
	private static final boolean DEBUG = LCSProperties
			.getBoolean("com.lfusa.wc.sample.LFSamplePlugins");
	
	public static final String documentType ="Generated Tech Pack";
	
	public static void AddSampleRequestOid(WTObject obj) {
		LCSSampleRequest sampleRequestObj = null;
		String sampleRequestObjId = "";
		if (obj instanceof LCSSampleRequest) {
			// get Sample Request Object
			sampleRequestObj = (LCSSampleRequest) obj;
			// Get Sample request Numeric Object Id from Object
			sampleRequestObjId = FormatHelper
					.getNumericObjectIdFromObject(sampleRequestObj);
			// Instance to add Sample Request OID to queue.
			LFTechpackDocumentAssociatoin queue = new LFTechpackDocumentAssociatoin();
			// Method to add Object Id to Queue
			queue.addQueueEntrySample(sampleRequestObjId);
		}
	}
	
	
	public static void associateGenerateTechpackToSampleRequest(String oid)
	{
		LCSLog.debug("----associateGenerateTechpackToSampleRequest START---");
		
		LCSSampleRequest sampleRequestObj = null;
		try
		{
			sampleRequestObj = (LCSSampleRequest) LCSQuery
					.findObjectById("OR:com.lcs.wc.sample.LCSSampleRequest:"
							+ oid);
			
		  	if(sampleRequestObj instanceof LCSSampleRequest)
		  	{
		  		
		  	LCSSampleRequest samObj=(LCSSampleRequest)sampleRequestObj;
		  		
		  	WTPartMaster specMaster=(WTPartMaster)samObj.getSpecMaster();
		  	
		  	FlexSpecification spec =(FlexSpecification) VersionHelper.latestIterationOf(specMaster);
		  	
		  	System.out.println("spec ---getSpecName--------------" +spec);
		  	
		  	Collection specAssociatetechpackDocuments = LCSQuery.getObjectsFromResults(new LCSDocumentQuery().findPartDocReferences(spec), "OR:com.lcs.wc.document.LCSDocument:", "LCSDocument.IDA2A2");
		  	
		  	System.out.println("Document name" +specAssociatetechpackDocuments);
		  	
		  	Iterator specDocIter =specAssociatetechpackDocuments.iterator();
							 
			 HashMap<String,LCSDocument> docObjNumber=new HashMap<String,LCSDocument>();
							 
							 while(specDocIter.hasNext())
							 {
								 LCSDocument docObj=(LCSDocument)specDocIter.next();
								 
								 //if document type id Generated Techpack get name
								 if(docObj.getTypeDisplay().equals(documentType))
								 {
									 //get document name
									 String docName=docObj.getName();
									 //get number of the document which associated to document name
									 docName=docName.substring(docName.lastIndexOf('-')+1);
									 
									 if(docName!=null)
									 {
							          docObjNumber.put(docName.trim(),docObj);
									 }
								 }
								 
							  }
							 
							 System.out.println("docObjNumber-------->" +docObjNumber);
							 //if specification does not have document it won't enter into if block of statement 
							 if(docObjNumber!=null && docObjNumber.size()>0)	 
						    {
								 System.out.println("------It is going coming to set Document object----");
								 //getting latest documnet of specification.we are iterating the code
						    	 Set Keys=docObjNumber.keySet();
								    
								    int MaxKey[]=new int[Keys.size()];
								    
								   Iterator keyItr=Keys.iterator();
								   
								   int i=0;
								   
								   while(keyItr.hasNext())
								   {
									   MaxKey[i]=Integer.parseInt(((String)keyItr.next()));
									   i++;
								    }
								 
								  int max = Integer.MIN_VALUE;
								   
								  for(int i1 = 0; i1 < MaxKey.length; i1++) {
								         if(MaxKey[i1] > max) {
								            max = MaxKey[i1];
								         }
								   }
								  
								  System.out.println("max value-------------" +max);
								  
								    //getting latest document object from map and passing to saving to sample object
								      LCSDocument docObj1=docObjNumber.get(Integer.toString(max));
								     LCSDocumentClientModel cdm = new LCSDocumentClientModel();
									 int numberOfFiles = 10;
									 String[] secondaryContentFiles = new String[numberOfFiles];
								     String[] secondaryContentComments = new String[numberOfFiles];
									 cdm.setSecondaryContentFiles(secondaryContentFiles);
									 cdm.setSecondaryContentComments(secondaryContentComments);
									 WTDocumentMaster docMaster = (WTDocumentMaster) docObj1.getMaster();
						             String docMasterId = FormatHelper.getObjectId(docMaster);
						             //Getting samplid objects from SampleRequest object.
									 Collection sampleId = new LCSSampleQuery().findSamplesIdForSampleRequest(samObj, false);
									 
									 Iterator samIte = sampleId.iterator();
										      
				                      while(samIte.hasNext())
										{
				                    	  System.out.println("It is coming to set value here-----");
										    	      FlexObject fob = (FlexObject) samIte.next();
										             LCSSample sample = (LCSSample) LCSQuery.findObjectById("OR:com.lcs.wc.sample.LCSSample:" + fob.getString("LCSSAMPLE.IDA2A2"));
										             String targetOid = FormatHelper.getObjectId(sample);
												     Collection<String> c = new Vector<String>();
												     c.add(docMasterId);
												     cdm.associateDocuments(targetOid, c);
										      }
						    }
							
						   
						    
								     
								   
								 
								
							 
								
			
		  		
		  
		  	}
		  
				
		  	
		  
		  	}
	catch(WTException wt)
		{
		   
			wt.printStackTrace();
		}
		catch(WTPropertyVetoException wpve)
		{
			  
			wpve.printStackTrace();
			
		}
		
		
		
	}

}
