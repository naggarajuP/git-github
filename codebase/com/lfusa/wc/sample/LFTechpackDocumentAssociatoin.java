package com.lfusa.wc.sample;

import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTPrincipal;
import wt.pds.StatementSpec;
import wt.query.QueryException;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.queue.ProcessingQueue;
import wt.queue.QueueHelper;
import wt.util.WTException;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;

/**
 * Class LFAddSampleOidToQueue, to add entry To Queue.
 * 
 * @author "true" ITCInfotech.
 * @version 0.1.
 * 
 */
 /*
 PLM 168 Techpack associate to Sample Documents
 */
public class LFTechpackDocumentAssociatoin {

	/**
	 * boolean DEBUG.
	 * Verbose for Debug statements.
	 * 
	 */
	private static final boolean DEBUG = LCSProperties
			.getBoolean("com.lfusa.wc.sample.LFTechpackDocumentAssociatoin");

	/**
	 * String queueNameSample.
	 * 
	 */
	private static final String queueNameSample = LCSProperties
			.get("com.lfusa.wc.sample.AssociateTechpackDocument");

	/**
	 * @author "true" ITCInfotech.
	 * 
	 * @param oid
	 *            .
	 * 
	 *            Method to Add Sample OID entry to Queue.
	 * 
	 */
	public void addQueueEntrySample(String oid) {
		// Initialize
		Class<?> argTypes[];
		Object args[];
		// Extraction Queue
		ProcessingQueue extractprocessQueueSample = null;
		LCSLog.debug(" Queue Entry for Adding Sample OID ");
		try {
			
			WTPrincipal user = wt.session.SessionHelper.manager.getPrincipal();

			// The Current User
			// Processing Queue for IProfile Style Integration
			
			extractprocessQueueSample = getProcessQueueSample(queueNameSample);
			
			if (DEBUG) {
				LCSLog.debug("Processing Queue Name : "
						+ extractprocessQueueSample);
			}
			// Arg Types for Extraction Process
			argTypes = (new Class[] { String.class });
			// Arg for Extraction Process
			args = (new Object[] { oid });
			// Add new entry in the process queue Extraction

			extractprocessQueueSample.addEntry(user, "associateGenerateTechpackToSampleRequest",
					"com.lfusa.wc.sample.LFAssociateLatestGeneratedTechpack", argTypes,
					args);
		}
		catch (WTException e) {
			// TODO Auto-generated catch block
			LCSLog.error("Method :: addQueueEntry, Error while adding Queue entry::"
					+ e);
		}
		if (DEBUG) {
			LCSLog.debug(" Queue Entry for Sample Request Ref Number Done ");
		}
	}

	/**
	 * Method to get the Processing Queue.
	 * 
	 * @author "true" ITCInfotech.
	 * 
	 * @param strQueueName
	 *            .
	 * 
	 * @return ProcessingQueue.
	 * 
	 */
	public static ProcessingQueue getProcessQueueSample(String strQueueName) {
		
		
		// Initaialize
		ProcessingQueue processQueueSample = null;
		try {
			// Query for the Processs queue. Create new Queue if it is not
			// found.
			QuerySpec specSample;
			specSample = new QuerySpec(wt.queue.ProcessingQueue.class);
			
			// Searches for The respective Queue name
			SearchCondition sc = new SearchCondition(
					wt.queue.ProcessingQueue.class, "name",
					SearchCondition.LIKE, strQueueName);
			
			// append the Search Condition
			specSample.appendWhere(sc, new int[] { 0 });
			QueryResult qrSample;
			try {
				// Fetches the Queue
				qrSample = PersistenceHelper.manager
						.find((StatementSpec) specSample);
				if (!qrSample.hasMoreElements()) {
					
					processQueueSample = QueueHelper.manager
							.createQueue(strQueueName);
					// start the queue
					processQueueSample.setEnabled(true);
				}
				// Create a Queue
				else {
					
					processQueueSample = (wt.queue.ProcessingQueue) qrSample
							.nextElement();
				}
			}
			catch (WTException e) {
				// TODO Auto-generated catch block
				LCSLog.error("GetProcessQueue - WTException Caught : " + e);
			}
		}
		catch (QueryException e) {
			// TODO Auto-generated catch block
			LCSLog.error("GetProcessQueue - QueryException Caught : " + e);
		}
		return processQueueSample;
	}

}
