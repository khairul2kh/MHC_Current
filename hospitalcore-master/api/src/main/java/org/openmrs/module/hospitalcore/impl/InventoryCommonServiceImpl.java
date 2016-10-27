/**
 *  Copyright 2013 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Hospital-core module.
 *
 *  Hospital-core module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Hospital-core module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Hospital-core module.  If not, see <http://www.gnu.org/licenses/>.
 *  
 *  author: ghanshyam
 *  date: 11-01-2013
 *  issue: #556 Bangladesh
 **/

package org.openmrs.module.hospitalcore.impl;

import java.util.Date;
import java.util.List;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.APIException;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.db.InventoryCommonDAO;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugPatient;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugPatientDetail;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.model.PatientSearch;

/**
*
*/
public class InventoryCommonServiceImpl extends BaseOpenmrsService implements InventoryCommonService {

	public InventoryCommonServiceImpl() {
	}
	
	protected InventoryCommonDAO dao;
	
	public void setDao(InventoryCommonDAO dao) {
		this.dao = dao;
	}
	
	public List<InventoryStoreDrugPatient> getAllIssueDateByPatientId(Patient patient) throws APIException {
		return dao.getAllIssueDateByPatientId(patient);
	}
	
	public List<InventoryStoreDrugPatient> getDeatilOfInventoryStoreDrugPatient(Patient patient,String date) throws APIException {
		return dao.getDeatilOfInventoryStoreDrugPatient(patient,date);
	}
	
	public List<InventoryStoreDrugPatientDetail> getDrugDetailOfPatient(InventoryStoreDrugPatient isdpd) throws APIException {
		return dao.getDrugDetailOfPatient(isdpd);
	}
	
	//ghanshyam 12-june-2013 New Requirement #1635 User should be able to send pharmacy orders to issue drugs to a patient from dashboard
	public InventoryDrug getDrugByName(String name) throws APIException {
		return dao.getDrugByName(name);
	}
	
	public List<Concept> getDrugFrequency() throws APIException {
		return dao.getDrugFrequency();
	}
	
	public InventoryDrugFormulation getDrugFormulationById(Integer id) throws APIException {
		return dao.getDrugFormulationById(id);
	}
// New code enter here
    public List<PatientSearch> searchListOfPatient(Date date, String searchKey, int page) throws APIException {
        return dao.searchListOfPatient(date,searchKey,page);
    }

    public List<OpdDrugOrder> listOfDrugOrder(Integer patientId, Integer encounterId) throws APIException {
        return dao.listOfDrugOrder(patientId,encounterId);
    }

    public OpdDrugOrder getOpdDrugOrder(Integer patientId, Integer encounterId, Integer inventoryDrugId, Integer formulationId) throws APIException {
    
        return dao.getOpdDrugOrder(patientId,encounterId,inventoryDrugId,formulationId);
    }

    public List<OpdDrugOrder> listOfOrder(Integer patientId) throws APIException {
     return dao.listOfOrder(patientId);
    
    }
        
}
