/**
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Billing module.
 *
 *  Billing module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Billing module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Billing module.  If not, see <http://www.gnu.org/licenses/>.
 *
 **/

package org.openmrs.module.billing.util;

import static org.openmrs.module.hospitalcore.BillingConstants.MODULE;

public class BillingConstants {
	
	public static final String MODULE_ID = "billing";
	public static final String PROPERTY_ROOT_SERVICE_CONCEPT_ID = MODULE_ID + ".rootServiceConceptId";
	public static final String PROPERTY_MAINTAINCODE = MODULE_ID + ".maintainCode";	
	public static final String SERVICE_ORDER_CONCEPT_NAME = "SERVICES ORDERED";
	public static final String PROPERTY_MAINTAINCODE_ALL_PATIENT_CATEGORIES = MODULE_ID + ".allPatientCategories";
        public static String STATUS[] ={"admitted", "canceled","nobed" ,"discharge","transfer" };
        public static final String PROPERTY_ENCOUNTER_TYPE_DIRECT = MODULE_ID + ".encounterTypeIdDirect";
        public static final String GLOBAL_PROPRETY_LAB_ENCOUNTER_TYPE = MODULE
			+ ".labEncounterType";
        public static final String GLOBAL_PROPRETY_RADIOLOGY_ENCOUNTER_TYPE = MODULE
			+ ".radiologyEncounterType";
        public static final String GLOBAL_PROPRETY_LAB_ORDER_TYPE = MODULE
			+ ".labOrderType";
        public static final String GLOBAL_PROPRETY_RADIOLOGY_ORDER_TYPE = MODULE
			+ ".radiologyOrderType";
        
}
