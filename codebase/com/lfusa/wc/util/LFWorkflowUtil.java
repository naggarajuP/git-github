/*
 * Author : ITCINFOTECH
 */

package com.lfusa.wc.util;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import wt.fc.PersistenceHelper;
import wt.fc.PersistenceServerHelper;
import wt.fc.QueryResult;
import wt.fc.ReferenceFactory;
import wt.fc.WTObject;
import wt.fc.WTReference;
import wt.org.WTPrincipal;
import wt.org.WTPrincipalReference;
import wt.org.WTUser;
import wt.part.WTPartMaster;
import wt.pds.StatementSpec;
import wt.project.Role;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.team.Team;
import wt.team.TeamHelper;
import wt.team.TeamManaged;
import wt.team.TeamTemplate;
import wt.team.TeamTemplateReference;
import wt.util.WTException;
import wt.util.WTPropertyVetoException;
import wt.vc.Mastered;
import wt.workflow.engine.WfActivity;
import wt.workflow.engine.WfEngineHelper;
import wt.workflow.engine.WfExecutionObject;
import wt.workflow.engine.WfProcess;
import wt.workflow.work.WfAssignedActivity;
import com.lcs.wc.calendar.LCSCalendar;
import com.lcs.wc.calendar.LCSCalendarClientModel;
import com.lcs.wc.calendar.LCSCalendarQuery;
import com.lcs.wc.calendar.LCSCalendarTask;
import com.lcs.wc.calendar.LCSCalendarTaskLogic;
import com.lcs.wc.db.FlexObject;
import com.lcs.wc.flextype.FlexType;
import com.lcs.wc.foundation.LCSRevisableEntity;
import com.lcs.wc.material.LCSMaterial;
import com.lcs.wc.moa.LCSMOATable;
import com.lcs.wc.product.LCSProduct;
import com.lcs.wc.sample.LCSSampleRequest;
import com.lcs.wc.season.LCSSeason;
import com.lcs.wc.season.LCSSeasonProductLink;
import com.lcs.wc.season.SeasonProductLocator;
import com.lcs.wc.util.FormatHelper;
import com.lcs.wc.util.LCSLog;
import com.lcs.wc.util.LCSProperties;
import com.lcs.wc.util.VersionHelper;

/*
 * This class file contains all methods used in workflow tasks.
 */
public class LFWorkflowUtil {

	public static final boolean DEBUG;
	public static final String CLASSNAME = "LFWorkflowUtil";
	// Variables for Sample workflow participants
	public static final String SOURCING_CONFIG_KEY = LCSProperties
			.get("com.lfusa.wc.util.LFWorkflowUtil.scKey");
	public static final String REVISABLE_ENTITY_KEY = LCSProperties
			.get("com.lfusa.wc.util.LFWorkflowUtil.revisableEntityKey");
	public static final String USER_LIST_KEY = LCSProperties
			.get("com.lfusa.wc.util.LFWorkflowUtil.userListKey");

	public static final String CALENDAR_ID = LCSProperties
			.get("com.lfusa.wc.util.LFWorkflowUtil.calendarID");
	public static final String PRODUCT_LINE = LCSProperties.get(
			"com.lfusa.wc.util.LFWorkflowUtil.productLine", "lfProductLine");

	// Variables for Material workflow participants
	public static final String MATERIAL_DEV_OFFICE_KEY = LCSProperties.get(
			"com.lfusa.wc.util.LFWorkflowUtil.matDevelopmentOfficeKey",
			"lfMaterialDevelopmentOffice");
	public static final String REVISABLE_ENTITY_MATERIAL_KEY = LCSProperties
			.get(
					"com.lfusa.wc.util.LFWorkflowUtil.revisableEntityMOAMatSourcingKey",
					"lfMaterialSourcing");
	public static final String MAT_USER_LIST_KEY = LCSProperties.get(
			"com.lfusa.wc.util.LFWorkflowUtil.matUserListKey",
			"lfMaterialDevelopmentOffUsers");
	public static final String REVISABLE_ENTITY_LIBRARIAN_KEY = LCSProperties
			.get(
					"com.lfusa.wc.util.LFWorkflowUtil.revisableEntityMOALibrarianKey",
					"lfLibrarian");

	static {
		DEBUG = LCSProperties
				.getBoolean("com.lfusa.wc.util.LFWorkflowUtil.verbose");

	}

	/*
	 * @ params : primaryBusinessObject (from workflow)
	 * 
	 * @ params : taskname (Calendar Task Name)
	 * 
	 * @ params : primaryBusinessObject (Activity name) This methos is used to
	 * set due date for each workflow activity based on Target End date for
	 * mapped Calendar task
	 */
	public static void setDueDateForCalendarTask(
			WTObject primaryBusinessObject, String taskName, String activityName) {
		LCSCalendarTaskLogic taskLogic = new LCSCalendarTaskLogic();
		try {
			if (DEBUG) {
				LCSLog
						.debug(CLASSNAME + " Entering setDueDateForCalendarTask() ");
			}

			taskLogic.startTask(primaryBusinessObject, taskName);
			if (DEBUG) {
				LCSLog
						.debug(CLASSNAME + " Following calendar task is started "
								+ taskName);
			}
			LCSCalendarTask currentTask = LCSCalendarQuery.getTask(
					primaryBusinessObject, taskName);

			// Timestamp endDate = currentTask.getEstEndDate();
			Timestamp endDate = currentTask.getTargetDate();
			if (endDate == null) {
				endDate = currentTask.getEstEndDate();
			}

			Date date = new Date(endDate.getTime());
			LCSProduct product = (LCSProduct) primaryBusinessObject;
			// Fetch all process associated with current primary business object
			QueryResult assocProcessResult = WfEngineHelper.service
					.getAssociatedProcesses(product, null, product
							.getContainerReference());

			if (assocProcessResult.hasMoreElements()) {
				if (DEBUG) {
					LCSLog
							.debug(CLASSNAME + "  assocProcessResult has more elements");
				}
				WfProcess process = (wt.workflow.engine.WfProcess) assocProcessResult
						.nextElement();
				Enumeration startedActivityEnum = WfEngineHelper.service
						.getProcessSteps(process, null);
				while (startedActivityEnum.hasMoreElements()) {
					if (DEBUG) {
						LCSLog
								.debug(CLASSNAME + "  startedActivityEnum has more elements");
					}
					WfActivity activity = (WfActivity) startedActivityEnum
							.nextElement();

					if (activity instanceof WfAssignedActivity) {
						if (DEBUG) {
							LCSLog
									.debug("activity instanceof WfAssignedActivity");
						}
						WfAssignedActivity assignedActivity = (WfAssignedActivity) activity;
						// check if current activity is same as given activity
						// name to set deadline date
						if (activityName.equalsIgnoreCase(assignedActivity
								.getName())) {
							if (DEBUG) {
								LCSLog
										.debug("activity equals WfAssignedActivity");
							}
							WfExecutionObject eo = (WfExecutionObject) assignedActivity;
							eo.setDeadline(endDate);
							if (DEBUG) {
								LCSLog
										.debug(CLASSNAME + " Going to set deadline");
							}
							PersistenceServerHelper.manager.update(eo);
							if (DEBUG) {
								LCSLog.debug(CLASSNAME + " Deadline "
										+ endDate + " Set for task :"
										+ activityName);
							}

						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * This method is used to check if current primary 
	 * business object is Product or ProductSeasonlink.
	 * 
	 * @param wtobject .
	 * @return .
	 */
	public static String getProductType(WTObject wtobject) {
		String enabledDivisionList = LCSProperties
				.get("com.lfusa.wc.productcalendar.enabledivisiolist");
		//Build 6.18.1 : Start
		String prodtype = "Other";
		//Build 6.18.1 : End
		
		String productDivisionKey = "lfDivision";
		Object enabledDivisionArrayList = new ArrayList();
		if (wtobject instanceof LCSProduct) {
			LCSProduct lcsproduct = (LCSProduct) wtobject;
			try {
				if (FormatHelper.hasContent(enabledDivisionList)) {
					String as[] = enabledDivisionList.split("[,]");
					enabledDivisionArrayList = Arrays.asList(as);
				}
				FlexType flextype = lcsproduct.getFlexType();
				String productDivisionValue = (String) lcsproduct
						.getValue(productDivisionKey);
				if (flextype.getTypeDisplayName().contains("Apparel")
						&& ((List) (enabledDivisionArrayList))
								.contains(productDivisionValue)) {
					LCSSeasonProductLink lcsseasonproductlink = SeasonProductLocator
							.getSeasonProductLink(lcsproduct);
					//Build 6.18.1 : Start
					LCSSeason season = (LCSSeason) VersionHelper
						.latestIterationOf((Mastered) lcsseasonproductlink.getSeasonMaster());
					
					wt.team.Team seasonTeam = wt.team.TeamHelper.service
						.getTeam((wt.team.TeamManaged) season);
						
					if (lcsseasonproductlink != null
							&& !lcsseasonproductlink.getSeasonLinkType().equalsIgnoreCase("SKU")
							&& seasonTeam != null)
						prodtype = "SeasonPrd";
					else
						prodtype = "Other";
					//Build 6.18.1 : End	
				}
			} catch (WTException wtexception) {
				wtexception.printStackTrace();
			}
		} else {
			prodtype = "Other";
		}
		if (DEBUG)
			LCSLog.debug((new StringBuilder()).append(
					CLASSNAME + ".getProductType() Workflow routed for ").append(prodtype)
					.toString());
		return prodtype;
	}

	/**
	 * This method checks for valid Season.
	 * 
	 * @param wtobject .
	 * @return .
	 */
	public static Boolean isValidSeasonDivision(WTObject wtobject) {
		
		String enabledDivisionList = LCSProperties
				.get("com.lfusa.wc.productcalendar.enabledivisiolist");
		String seasonDivisionKey = "lfDivision";
		Object enabledDivisionArrayList = new ArrayList();
		Boolean flag = false;
		if (wtobject instanceof LCSSeason) {
			try {
				LCSSeason season = (LCSSeason) wtobject;
				if (DEBUG)
					LCSLog.debug((new StringBuilder()).append(
							CLASSNAME + ".isValidSeasonDivision() Season: ")
							.append(season.getIdentity()).toString());
				
				if (FormatHelper.hasContent(enabledDivisionList)) {
					String as[] = enabledDivisionList.split("[,]");
					enabledDivisionArrayList = Arrays.asList(as);
				}
				FlexType flextype = season.getFlexType();
				String seasonDivisionValue = (String) season
						.getValue(seasonDivisionKey);
				if (DEBUG)
					LCSLog.debug((new StringBuilder()).append(
							CLASSNAME + ".isValidSeasonDivision() seasonDivisionValue: ")
							.append(seasonDivisionValue).toString());
				
				if (flextype.getTypeDisplayName().contains("Apparel")
						&& ((List) (enabledDivisionArrayList))
								.contains(seasonDivisionValue)) {
					flag = true;
				}
			} catch (WTException wtexception) {
				wtexception.printStackTrace();
			}
		}
		return flag;
	}

	/*
	 * @ params : primaryBusinessObject (from workflow)
	 * 
	 * @ returns : taskName (Activity name) This method will complete the given
	 * Calendar task
	 */
	public static void endCalendarTask(WTObject primaryBusinessObject,
			String taskName) {
		LCSCalendarTaskLogic taskLogic = new LCSCalendarTaskLogic();
		try {
			taskLogic.endTask(primaryBusinessObject, taskName);

		} catch (WTException e) {
			e.printStackTrace();
		}
		if (DEBUG) {
			LCSLog.debug(CLASSNAME + ".endCalendarTask() " + taskName);
		}
	}

	/*
	 * @ params : primaryBusinessObject (from workflow) This method fetches the
	 * associated season team and assigns it to Primary Business object.Also,
	 * initializes Calendar for Primary Business object based on Calendar Id set
	 * previously.
	 */
	public static void checkTeamAndInitializeCalendar(
			WTObject primaryBusinessObject) {

		try {
			LCSProduct product = (LCSProduct) primaryBusinessObject;
			LCSSeasonProductLink spLink = SeasonProductLocator
					.getSeasonProductLink(product);
			String calendarId = (String) spLink.getValue(CALENDAR_ID);
			if (FormatHelper.hasContent(calendarId)) {
				LCSCalendarClientModel calModel = new LCSCalendarClientModel();
				calModel.initiateCalendarFromTemplate(product, calendarId,
						new java.util.Date());
				LCSSeason season = (LCSSeason) VersionHelper
						.latestIterationOf((Mastered) spLink.getSeasonMaster());
				// Get team associated with Season
				Team seasonTeam = wt.team.TeamHelper.service
						.getTeam((wt.team.TeamManaged) season);
				//Build 6.18.1 : start
				if(seasonTeam!=null)
				{
				//Build 6.18.1 : End
					// Fetch entire Role/participant map for the given season team
					Map seasonTeamMap = (Map) seasonTeam.getRolePrincipalMap();
					if (DEBUG) {
						LCSLog.debug(CLASSNAME + " Season Team Map :"
								+ seasonTeamMap);
					}
					TeamHelper.service.reteam(product, TeamTemplateReference
											.newTeamTemplateReference(TeamHelper.service
													.getTeamTemplate((wt.team.TeamManaged) season)));
					Team prdTeam = wt.team.TeamHelper.service
							.getTeam((TeamManaged) product);
					Iterator itr = seasonTeamMap.keySet().iterator();
					// Set the same Role/participant map as seaon to current Primary
					// business Object
					while (itr.hasNext()) {
						Role tempRole = (Role) itr.next();
						Collection pricipalColl = (Collection) seasonTeamMap
								.get(tempRole);
						Iterator i = pricipalColl.iterator();
						while (i.hasNext()) {
							WTPrincipalReference tempPrincipalRef = (WTPrincipalReference) i
									.next();
							WTPrincipal tempPrincipal = tempPrincipalRef
									.getPrincipal();
							prdTeam.addPrincipal(tempRole, tempPrincipal);
						}
					}
					if (DEBUG) {
						LCSLog.debug(CLASSNAME + " Product Team Set!! ");
					}
				//Build 6.18.1 : start	
				}
				//Build 6.18.1 : End
			} else {
				if (DEBUG) {
					LCSLog.debug(CLASSNAME + " No Calendar ID Assigned for Product");
				}
			}
		} catch (WTException e) {
			e.printStackTrace();
		}
	}

	/**
	 * This method fetches the
	 * overseas office members from Business Object associated with Sourcing
	 * Conf on Product and assigns them as participants to Overseas Office Role.
	 * 
	 * @param primaryBusinessObject .
	 */
	public static void addParticipantsForPrdSample(
			WTObject primaryBusinessObject) {
		try {

			if (primaryBusinessObject instanceof LCSSampleRequest) {
				LCSSampleRequest sampleReq = (LCSSampleRequest) primaryBusinessObject;
				if (DEBUG) {
					LCSLog.debug("\n Entering Sample Requset Workflow for ::"
							+ sampleReq.getName());
				}
				// check type of Sample Request-Below mentioned code should only
				// be called for Product Samples

				Team sampleTeam = wt.team.TeamHelper.service
						.getTeam((TeamManaged) sampleReq);
				if (DEBUG) {
					LCSLog.debug("\n sampleTeam ::" + sampleTeam.getName());
				}
				Role role = null;

				Collection roleColl = TeamHelper.service.findRoles(sampleTeam);
				Iterator i = roleColl.iterator();
				while (i.hasNext()) {
					Role tempRole = (Role) i.next();
					if (tempRole.getFullDisplay().equalsIgnoreCase(
							"OVERSEAS OFFICE")) {
						if (DEBUG) {
							LCSLog.debug("\n tempRole.getName() "
									+ tempRole.getFullDisplay());
						}
						role = tempRole;
						break;
					}
				}

				LCSRevisableEntity sampleUsersObj = (LCSRevisableEntity) sampleReq
						.getValue(SOURCING_CONFIG_KEY);
				if (DEBUG) {
					LCSLog.debug("\n sampleUsersObj --"
							+ sampleUsersObj.getName());
				}

				LCSMOATable moaTable = (LCSMOATable) sampleUsersObj
						.getValue(REVISABLE_ENTITY_KEY);

				Collection coll = moaTable.getRows();
				Iterator itr = coll.iterator();
				while (itr.hasNext()) {
					FlexObject fo = (FlexObject) itr.next();

					if (DEBUG) {
						LCSLog.debug("\n FlexObject::" + fo);
					}
					// ************************** sample workflow defect
					// changes******************************
					String userID = fo.getString(USER_LIST_KEY);
					long useridValue = 0;
					if (FormatHelper.hasContent(userID)) {
						useridValue = new BigDecimal(userID).longValue();
						userID = String.valueOf(useridValue);
					} else {
						continue;
					}
					
					if (DEBUG) {
						LCSLog.debug("\n userID::" + userID);
					}

					String userOID = "wt.org.WTUser:" + userID;
					ReferenceFactory refFactory = new ReferenceFactory();
					WTReference ref = null;

					try {
						ref = refFactory.getReference(userOID);
					} catch (WTException e) {
						e.printStackTrace();
					}
					WTUser user = (WTUser) ref.getObject();

					if (role != null) {
						sampleTeam.addPrincipal(role, (WTPrincipal) user);
					}
				}
				if (DEBUG) {
					LCSLog.debug("\n Team map:::"
							+ sampleTeam.getRolePrincipalMap());
				}
			}
		} catch (WTException e) {
			e.printStackTrace();
		}
	}

	/**
	 * This
	 * method fetches the overseas office members from Business Object
	 * associated with Sourcing Conf on Product and assigns them as participants
	 * to Overseas Office Role.
	 * 
	 * @param primaryBusinessObject .
	 */
	public static void addParticipantsForMaterialSample(
			WTObject primaryBusinessObject) {
		try {
			if (primaryBusinessObject instanceof LCSSampleRequest) {
				String prdLine = "";
				LCSSampleRequest sampleReq = (LCSSampleRequest) primaryBusinessObject;
				if (DEBUG) {
					LCSLog.debug("\n Entering Sample Requset Workflow for ::"
							+ sampleReq.getName());
				}
				// check type of Sample Request-Below mentioned code should only
				// be called for Product Samples

				Team sampleTeam = wt.team.TeamHelper.service
						.getTeam((TeamManaged) sampleReq);
				if (DEBUG) {
					LCSLog.debug("\n sampleTeam ::" + sampleTeam.getName());
				}
				Role role = null;
				Collection roleColl = TeamHelper.service.findRoles(sampleTeam);

				prdLine = sampleReq.getValue(PRODUCT_LINE) != null ? (String) sampleReq.getValue(PRODUCT_LINE) : "";
				//PLM-173 : commented below code to have common w/f for all product lines
				/*Iterator i = roleColl.iterator();
				while (i.hasNext()) {
					Role tempRole = (Role) i.next();
					if (prdLine.equalsIgnoreCase("Home")
							&& tempRole.getFullDisplay().equalsIgnoreCase(
									"SOURCING")) {
						if (DEBUG) {
							LCSLog.debug("\n tempRole.getName() "
									+ tempRole.getFullDisplay());
						}
						role = tempRole;
						break;
					} else if (tempRole.getFullDisplay().equalsIgnoreCase(
							"OVERSEAS OFFICE")) {
						if (DEBUG) {
							LCSLog.debug("\n tempRole.getName() "
									+ tempRole.getFullDisplay());
						}
						role = tempRole;
						break;
					}
				}*/
				//PLM-173 : Added below code by commenting above code
				Iterator roleCollItr = roleColl.iterator();
				while (roleCollItr.hasNext()) {
					Role tempRole = (Role) roleCollItr.next();
					 if (tempRole.getFullDisplay().equalsIgnoreCase("OVERSEAS OFFICE")) {
						if (DEBUG)  LCSLog.debug("\n tempRole.getName() "+ tempRole.getFullDisplay());
						role = tempRole;
						break;
					}
				}
				
				LCSRevisableEntity sampleUsersObj = (LCSRevisableEntity) sampleReq.getValue(SOURCING_CONFIG_KEY);

				if (DEBUG) LCSLog.debug("\n sampleUsersObj --" + sampleUsersObj);

				if (sampleUsersObj != null) 
				{
					if (DEBUG)  LCSLog.debug("\n sampleUsersObj.getName()"+ sampleUsersObj.getName());

					LCSMOATable moaTable = (LCSMOATable) sampleUsersObj.getValue(REVISABLE_ENTITY_KEY);
					Collection coll = moaTable.getRows();
					Iterator itr = coll.iterator();
					while (itr.hasNext()) {
						FlexObject fo = (FlexObject) itr.next();

						if (DEBUG) {
							LCSLog.debug("\n FlexObject::" + fo);
						}

						String userID = fo.getString(USER_LIST_KEY);
						// sample workflow defect changes
						long useridValue = 0;
						if (FormatHelper.hasContent(userID)) {
							useridValue = new BigDecimal(userID).longValue();
							userID = String.valueOf(useridValue);
						} else {
							continue;
						}

						if (DEBUG) {
							LCSLog.debug("\n userID::" + userID);
						}

						String userOID = "wt.org.WTUser:" + userID;
						ReferenceFactory refFactory = new ReferenceFactory();
						WTReference ref = null;

						try {
							ref = refFactory.getReference(userOID);
						} catch (WTException e) {
							e.printStackTrace();
						}

						WTUser user = (WTUser) ref.getObject();

						if (role != null) {

							sampleTeam.addPrincipal(role, (WTPrincipal) user);
						}
					}
					if (DEBUG) {
						LCSLog.debug("\n Team map:::"
								+ sampleTeam.getRolePrincipalMap());
					}
				}
			}
		} catch (WTException e) {
			e.printStackTrace();
		}

	}

	/*
	 * @ params : primaryBusinessObject (from Material Sample workflow)
	 * This method fetches the Product Line Attribute value from
	 * associated Material Color and assigns accordingly routes the workflow
	 * tasks.
	 */
	public static String getMaterialSampleProductLine(
			WTObject primaryBusinessObject) {
		String prdLine = "";

		if (primaryBusinessObject instanceof LCSSampleRequest)

			try {
				LCSSampleRequest sampleReq = (LCSSampleRequest) primaryBusinessObject;
				prdLine = sampleReq.getValue(PRODUCT_LINE) != null ? (String) sampleReq
						.getValue(PRODUCT_LINE)
						: "";

			} catch (Exception e) {
				e.printStackTrace();
			}
		return prdLine;
	}

	/*
	 * @ params : primaryBusinessObject (from Product Sample workflow)
	 * This method fetches the Product Line Attribute value from
	 * associated Product and assigns accordingly routes the workflow tasks.
	 */
	public static String getPrdSampleProductLine(WTObject primaryBusinessObject) {
		String prdLine = "";
		if (primaryBusinessObject instanceof LCSSampleRequest)
			try {
				LCSSampleRequest sampleReq = (LCSSampleRequest) primaryBusinessObject;
				WTPartMaster master = (WTPartMaster) sampleReq.getOwnerMaster();
				WTObject object = (WTObject) VersionHelper
						.latestIterationOf((Mastered) master);
				if (object instanceof LCSProduct) {
					LCSProduct prd = (LCSProduct) object;
					FlexType productType = (FlexType) prd.getFlexType();
					String productTypeName = productType.getFullName(true);
					if (productTypeName.indexOf("Apparel") > -1)
						prdLine = "apparel";
					else if (productTypeName.indexOf("Accessories") > -1)
						prdLine = "accessories";
					else if (productTypeName.indexOf("Home") > -1)
						prdLine = "home";
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		return prdLine;
	}

	// ////////////Material Workflow////////////////////////////////
	/*
	 * @ params : primaryBusinessObject (from workflow) This method fetches the
	 * overseas office members from Business Object associated with Sourcing
	 * Conf on Product and assigns them as participants to Overseas Office Role
	 */

	public static void addParticipantsForMaterialWorkflow(
			WTObject primaryBusinessObject) {
		try {
			if (primaryBusinessObject instanceof LCSMaterial) {
				LCSMaterial material = (LCSMaterial) primaryBusinessObject;
				if (DEBUG) {
					LCSLog.debug("\n Entering Material Workflow for ::"
							+ material.getName());
				}

				Team materialTeam = wt.team.TeamHelper.service
						.getTeam((TeamManaged) material);
				if (DEBUG) {
					LCSLog
							.debug("\n Material Team ::"
									+ materialTeam.getName());
				}
				Role materialSourcingRole = null;
				Role libraraianRole = null;

				Collection roleColl = TeamHelper.service
						.findRoles(materialTeam);
				Iterator i = roleColl.iterator();
				while (i.hasNext()) {
					Role tempRole = (Role) i.next();

					if (tempRole.getFullDisplay().equalsIgnoreCase(
							"MATERIAL SOURCING")) {
						if (DEBUG) {
							LCSLog.debug("\n tempRole.getName() "
									+ tempRole.getFullDisplay());
						}
						materialSourcingRole = tempRole;
					} else if (tempRole.getFullDisplay().equalsIgnoreCase(
							"LIBRARIAN")) {
						if (DEBUG) {
							LCSLog.debug("\n tempRole.getName() "
									+ tempRole.getFullDisplay());
						}
						libraraianRole = tempRole;
					}
				}

				LCSRevisableEntity matDevlopmentObj = (LCSRevisableEntity) material
						.getValue(MATERIAL_DEV_OFFICE_KEY);

				if (DEBUG) {
					LCSLog.debug("\n matDevelopmentObj --" + matDevlopmentObj);
				}

				if (matDevlopmentObj != null) {

					if (DEBUG) {
						LCSLog.debug("\n matDevlopmentObj.getName()---"
								+ matDevlopmentObj.getName());
					}

					ReferenceFactory refFactory = new ReferenceFactory();
					WTReference ref = null;

					// Material Sourcing MOA table
					LCSMOATable moaTable = (LCSMOATable) matDevlopmentObj
							.getValue(REVISABLE_ENTITY_MATERIAL_KEY);

					if (moaTable != null) {
						if (DEBUG) {
							LCSLog
									.debug("\n Got moaTable for REVISABLE_ENTITY_MATERIAL_KEY --");
						}

						Collection coll = moaTable.getRows();
						Iterator itr = coll.iterator();
						while (itr.hasNext()) {
							FlexObject fo = (FlexObject) itr.next();
							String userID = fo.getString(MAT_USER_LIST_KEY);
							// ************************** sample workflow defect
							// changes******************************
							long useridValue = 0;
							if (FormatHelper.hasContent(userID)) {
								useridValue = new BigDecimal(userID)
										.longValue();
								userID = String.valueOf(useridValue);
							} else {
								continue;
							}
							String userOID = "wt.org.WTUser:" + userID;
							try {
								ref = refFactory.getReference(userOID);
							} catch (WTException e) {
								e.printStackTrace();
							}

							WTUser user = (WTUser) ref.getObject();

							if (materialSourcingRole != null) {
								materialTeam.addPrincipal(materialSourcingRole,
										(WTPrincipal) user);
							}

						}
					}
					// Librarian MOA Table
					LCSMOATable librarianMOATable = (LCSMOATable) matDevlopmentObj
							.getValue(REVISABLE_ENTITY_LIBRARIAN_KEY);

					if (librarianMOATable != null) {

						if (DEBUG) {
							LCSLog
									.debug("\n Got librarianMOATable for REVISABLE_ENTITY_LIBRARIAN_KEY --");
						}

						Collection collection = librarianMOATable.getRows();
						Iterator iterator = collection.iterator();
						while (iterator.hasNext()) {
							FlexObject fObject = (FlexObject) iterator.next();
							String librarianID = fObject
									.getString(MAT_USER_LIST_KEY);
							// ************************** sample workflow defect
							// changes******************************
							long useridValue = 0;
							if (FormatHelper.hasContent(librarianID)) {
								useridValue = new BigDecimal(librarianID)
										.longValue();
								librarianID = String.valueOf(useridValue);
							} else {
								continue;
							}
							String librarianOID = "wt.org.WTUser:"
									+ librarianID;
							try {
								ref = refFactory.getReference(librarianOID);
							} catch (WTException e) {
								e.printStackTrace();
							}

							WTUser user = (WTUser) ref.getObject();

							if (libraraianRole != null) {
								materialTeam.addPrincipal(libraraianRole,
										(WTPrincipal) user);
							}

						}
						if (DEBUG) {
							LCSLog.debug("\n Team map:::"
									+ materialTeam.getRolePrincipalMap());
						}
					}
				}
			}

		} catch (WTException e) {
			e.printStackTrace();
		}

	}

	public static void completeAllCalendarTasks(WTObject primaryBusinessObject)
			throws WTException, wt.util.WTPropertyVetoException {

		if (DEBUG) {
			LCSLog.debug(" Inside completeAllCalendarTasks ");
		}
		LCSCalendar prodCalendar = LCSCalendarQuery
				.findByOwner((WTObject) primaryBusinessObject);
		Collection allTasks = LCSCalendarQuery.findTasks(prodCalendar);
		Iterator tasks = null;
		if (allTasks != null) {
			if (DEBUG) {
				LCSLog.debug("\n allTasks size:::" + allTasks.size());
			}

			tasks = allTasks.iterator();
		}

		LCSCalendarTaskLogic taskLogic = new LCSCalendarTaskLogic();

		while (tasks != null && tasks.hasNext()) {

			LCSCalendarTask task = (LCSCalendarTask) tasks.next();
			String taskName = task.getName();
			if (DEBUG) {
				LCSLog.debug("\n Ending task " + taskName);
			}
			taskLogic.endTask(primaryBusinessObject, taskName);

		}

	}

	public static TeamTemplate findTeamTemplate(String teamName)
			throws WTException {
		if (DEBUG) {
			LCSLog.error(CLASSNAME + ".findTeamTemplate() teamName "
					+ teamName);
		}
		TeamTemplate result = null;
		QuerySpec qs = new QuerySpec(TeamTemplate.class);
		qs.appendWhere(new SearchCondition(TeamTemplate.class,
				TeamTemplate.NAME, SearchCondition.EQUAL, teamName),
				new int[] { 0 });
		QueryResult qr = PersistenceHelper.manager.find((StatementSpec) qs);
		if (DEBUG) {
			LCSLog.error(CLASSNAME + ".findTeamTemplate() qr " + qr);
		}
		if (qr.size() > 0) {
			result = (TeamTemplate) qr.nextElement();
		}
		LCSLog.error(CLASSNAME + ".findTeamTemplate() result  " + result);
		if (result != null) {
			LCSLog.error(CLASSNAME + "\n result.getName() " + result.getName());
		}
		return result;
	}

	public static void assignTeamToSeason(WTObject primarybusinessobject)
			throws WTException, WTPropertyVetoException {
		String teamName = "";
		if (primarybusinessobject instanceof LCSSeason) {
			if (DEBUG) {
				LCSLog
						.debug(CLASSNAME + ".assignTeamToSeason() teamName ");
			}
			LCSSeason season = (LCSSeason) primarybusinessobject;
			teamName = (String) season.getValue("lfTeam");
			if (DEBUG) {
				LCSLog.debug(CLASSNAME + ".assignTeamToSeason() teamName "
						+ teamName);
			}
			if (FormatHelper.hasContent(teamName)) {
				TeamTemplate template = findTeamTemplate(teamName);
				if (template != null) {
					TeamHelper.service.reteam(season, TeamTemplateReference
							.newTeamTemplateReference(template));

				}
			}
		}
	}
}
