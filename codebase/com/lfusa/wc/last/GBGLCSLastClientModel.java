/**
 * GBGLCSLastClientModel.class
 * June, 2017
 */
package com.lfusa.wc.last;

import java.util.Collection;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.foundation.LCSQuery;
import com.lcs.wc.last.LCSLastClientModel;
import com.lcs.wc.last.LCSLast;
import com.lcs.wc.last.LCSLastHelper;
import com.lcs.wc.util.LCSLog;

/**
 * @author Thanushree.V - Acnovate Corp.
 * @version 1.0.
 * @since June, 2017.
 * 
 */
public class GBGLCSLastClientModel extends LCSLastClientModel {

	/**
	 * @return LCSLast.
	 */
	public LCSLast copyLast(){

		// New Last Object
		LCSLast lastObj = new LCSLast();
		try {
			lastObj = LCSLast.newLCSLast();
			// Initialize
			FlexObject flexObject = null;

			// Creates a copy of Last(LCSManaged Object)
			copyState(lastObj);
			// Sets the Last created in the copied newLast
			lastObj.setCopiedFrom(this.getCopiedFrom());
			
			// Saves the new Last Object
			lastObj = LCSLastHelper.service.saveLast(
					lastObj);
			}
		
		catch (WTException e) {
			// TODO Auto-generated catch block
			LCSLog.error("WTException - LFLCSLast.copyLast : "
					+ e);
		}
		catch (WTPropertyVetoException wpve) {
			// TODO Auto-generated catch block
			LCSLog.error("WTPropertyVetoException - LFLCSLastClientModel.copyLast : "
					+ wpve);
		}
		return lastObj;
	}

}