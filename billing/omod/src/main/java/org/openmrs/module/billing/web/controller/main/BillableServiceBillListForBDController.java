/**
 *  Copyright 2013 Society for Health Information Systems Programmes, India (HISP India)
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
 *  author: Ghanshyam
 *  date:   25-02-2013
 *  New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module
 **/

package org.openmrs.module.billing.web.controller.main;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.IpdService;

import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.billing.includable.billcalculator.BillCalculatorForBDService;
import org.openmrs.module.hospitalcore.BillingConstants;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.model.PatientServiceBill;
import org.openmrs.module.hospitalcore.util.PagingUtil;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.hospitalcore.util.RequestUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 */
@Controller
@RequestMapping("/module/billing/patientServiceBillForBD.list")
public class BillableServiceBillListForBDController {
	
	@RequestMapping(method = RequestMethod.GET)
	public String viewForm(Model model, @RequestParam("patientId") Integer patientId,
	                       @RequestParam(value = "billId", required = false) Integer billId,
	                       @RequestParam(value = "pageSize", required = false) Integer pageSize,
	                       @RequestParam(value = "currentPage", required = false) Integer currentPage,
	                       HttpServletRequest request) {
            
            BillingService billingService = Context.getService(BillingService.class);
            
		Patient patient = Context.getPatientService().getPatient(patientId);
		Map<String, String> attributes = PatientUtils.getAttributes(patient);
		//ghanshyam 25-02-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module
		BillCalculatorForBDService calculator = new BillCalculatorForBDService();
                
                // New Code Enter 'cTech Khairul'
                IpdService ipdService=Context.getService(IpdService.class);
                IpdPatientAdmitted admitted = ipdService.getAdmittedByPatientId(patientId);
                
                if (admitted != null) {
			model.addAttribute("admittedStatus", "Admitted");
                        model.addAttribute("admittedWard",admitted.getAdmittedWard());
                        model.addAttribute("bed",admitted.getBed());
                        model.addAttribute("status",admitted.getStatus());
                     
		}
              
              PersonAttribute relationNameattr = patient.getAttribute("Father/Husband Name");
               model.addAttribute("relationName", relationNameattr.getValue());             
                
              PersonAttribute relationTypeattr =patient.getAttribute("Relative Name Type");
             Date birthday = patient.getBirthdate();
              model.addAttribute("age", PatientUtils.estimateAge(birthday));
               
              if(relationTypeattr!=null){
				model.addAttribute("relationType", relationTypeattr.getValue());
			}
			else{
				model.addAttribute("relationType", "Relative Name");
			}    
		if (patient != null) {
			
			int total = billingService.countListPatientServiceBillByPatient(patient);
			// ghanshyam 12-sept-2012 Bug #357 [billing][3.2.7-SNAPSHOT] Error screen appears on clicking next page or changing page size in list of bills
			PagingUtil pagingUtil = new PagingUtil(RequestUtil.getCurrentLink(request), pageSize, currentPage, total,
			        patientId);
			model.addAttribute("pagingUtil", pagingUtil);
			model.addAttribute("patient", patient);
			model.addAttribute("listBill",
			    billingService.listPatientServiceBillByPatient(pagingUtil.getStartPos(), pagingUtil.getPageSize(), patient));
		}
		if (billId != null) {
			PatientServiceBill bill = billingService.getPatientServiceBillById(billId);
			//ghanshyam 25-02-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module
			//ghanshyam 3-june-2013 New Requirement #1632 Orders from dashboard must be appear in billing queue.User must be able to generate bills from this queue
			if (bill.getFreeBill().equals(1)) {
				String billType = "free";
				bill.setFreeBill(calculator.isFreeBill(billType));
			} else if (bill.getFreeBill().equals(2)) {
				String billType = "mixed";
				bill.setFreeBill(2);
			} else {
				String billType = "paid";
				bill.setFreeBill(calculator.isFreeBill(billType));
			}
			
			model.addAttribute("bill", bill);
		}
		User user = Context.getAuthenticatedUser();
		
		model.addAttribute("canEdit", user.hasPrivilege(BillingConstants.PRIV_EDIT_BILL_ONCE_PRINTED));
		return "/module/billing/main/billableServiceBillListForBD";
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public String onSubmit(@RequestParam("patientId") Integer patientId, @RequestParam("billId") Integer billId) {
		BillingService billingService = (BillingService) Context.getService(BillingService.class);
		PatientServiceBill patientServiceBill = billingService.getPatientServiceBillById(billId);
		if (patientServiceBill != null && !patientServiceBill.getPrinted()) {
			patientServiceBill.setPrinted(true);
			Map<String, String> attributes = PatientUtils.getAttributes(patientServiceBill.getPatient());
			//ghanshyam 25-02-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module
			BillCalculatorForBDService calculator = new BillCalculatorForBDService();
			
			//ghanshyam 3-june-2013 New Requirement #1632 Orders from dashboard must be appear in billing queue.User must be able to generate bills from this queue
			if (patientServiceBill.getFreeBill().equals(1)) {
				String billType = "free";
				patientServiceBill.setFreeBill(calculator.isFreeBill(billType));
			} else if (patientServiceBill.getFreeBill().equals(2)) {
				String billType = "mixed";
				patientServiceBill.setFreeBill(2);
			} else {
				String billType = "paid";
				patientServiceBill.setFreeBill(calculator.isFreeBill(billType));
			}
			
			billingService.saveBillEncounterAndOrder(patientServiceBill);
		}
		return "redirect:/module/billing/patientServiceBillForBD.list?patientId=" + patientId;
	}
}