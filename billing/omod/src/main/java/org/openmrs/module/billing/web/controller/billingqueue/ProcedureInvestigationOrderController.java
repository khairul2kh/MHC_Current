/**
 * Copyright 2013 Society for Health Information Systems Programmes, India (HISP
 * India)
 *
 * This file is part of Billing module.
 *
 * Billing module is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Billing module is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Billing module. If not, see <http://www.gnu.org/licenses/>.
 *
 * author: ghanshyam date: 3-june-2013 issue no: #1632
 *
 */
package org.openmrs.module.billing.web.controller.billingqueue;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAddress;
import org.openmrs.PersonAttribute;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.billing.includable.billcalculator.BillCalculatorForBDService;
import org.openmrs.module.billing.util.BillingConstants;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.BillableService;
import org.openmrs.module.hospitalcore.model.OpdTestOrder;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmittedQueueLog;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.openmrs.module.hospitalcore.model.PatientServiceBill;
import org.openmrs.module.hospitalcore.model.PatientServiceBillItem;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.hospitalcore.util.Money;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("ProcedureInvestigationOrderController")
@RequestMapping("/module/billing/procedureinvestigationorder.form")
public class ProcedureInvestigationOrderController {

    @RequestMapping(method = RequestMethod.GET)
    public String main(Model model, @RequestParam("patientId") Integer patientId,
            @RequestParam("encounterId") Integer encounterId,
            @RequestParam(value = "date", required = false) String dateStr) {
        BillingService billingService = Context.getService(BillingService.class);
        List<BillableService> serviceOrderList = billingService.listOfServiceOrder(patientId, encounterId);
        model.addAttribute("serviceOrderList", serviceOrderList);
        model.addAttribute("serviceOrderSize", serviceOrderList.size());
        model.addAttribute("patientId", patientId);
        model.addAttribute("encounterId", encounterId);
        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
        PatientSearch patientSearch = hospitalCoreService.getPatientByPatientId(patientId);
        model.addAttribute("patientSearch", patientSearch);
        model.addAttribute("date", dateStr);
        return "/module/billing/queue/procedureInvestigationOrder";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String onSubmit(Model model, Object command,
            HttpServletRequest request,
            @RequestParam("patientId") Integer patientId,
            @RequestParam("encounterId") Integer encounterId,
            @RequestParam("indCount") Integer indCount,
            // @RequestParam("admissionId") Integer admissionId,
            @RequestParam(value = "billType", required = false) String billType) {

        BillingService billingService = Context.getService(BillingService.class);

        PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);

        PatientService patientService = Context.getPatientService();

        // Get the BillCalculator to calculate the rate of bill item the patient has to pay
        Patient patient = patientService.getPatient(patientId);
        Map<String, String> attributes = PatientUtils.getAttributes(patient);

        BillCalculatorForBDService calculator = new BillCalculatorForBDService();

        PatientServiceBill bill = new PatientServiceBill();
        bill.setCreatedDate(new Date());
        bill.setPatient(patient);
        bill.setCreator(Context.getAuthenticatedUser());

        PatientServiceBillItem item;
        String servicename;
        int quantity = 0;
        String selectservice;
        BigDecimal unitPrice;
        String reschedule;
        String paybill;
        BillableService service;
        Money mUnitPrice;
        Money itemAmount;
        Money totalAmount = new Money(BigDecimal.ZERO);
        BigDecimal rate;
        String billTyp;
        BigDecimal totalActualAmount = new BigDecimal(0);
        OpdTestOrder opdTestOrder = new OpdTestOrder();
        for (Integer i = 1; i <= indCount; i++) {
            selectservice = request.getParameter(i.toString() + "selectservice");
            if ("billed".equals(selectservice)) {
                servicename = request.getParameter(i.toString() + "service");
                quantity = NumberUtils.createInteger(request.getParameter(i.toString() + "servicequantity"));
                reschedule = request.getParameter(i.toString() + "reschedule");
                paybill = request.getParameter(i.toString() + "paybill");
                unitPrice = NumberUtils.createBigDecimal(request.getParameter(i.toString() + "unitprice"));
                //ConceptService conceptService = Context.getConceptService();
                //Concept con = conceptService.getConcept("servicename");
                service = billingService.getServiceByConceptName(servicename);

                mUnitPrice = new Money(unitPrice);
                itemAmount = mUnitPrice.times(quantity);
                totalAmount = totalAmount.plus(itemAmount);

                item = new PatientServiceBillItem();
                item.setCreatedDate(new Date());
                item.setName(servicename);
                item.setPatientServiceBill(bill);
                item.setQuantity(quantity);
                item.setService(service);
                item.setUnitPrice(unitPrice);

                item.setAmount(itemAmount.getAmount());

                // Get the ratio for each bill item
                Map<String, Object> parameters = HospitalCoreUtils.buildParameters(
                        "patient", patient, "attributes", attributes, "billItem",
                        item, "request", request);

                if ("pay".equals(paybill)) {
                    billTyp = "paid";
                } else {
                    billTyp = "free";
                }

                rate = calculator.getRate(parameters, billTyp);
                item.setActualAmount(item.getAmount().multiply(rate));
                totalActualAmount = totalActualAmount.add(item.getActualAmount());
                bill.addBillItem(item);

                opdTestOrder = billingService.getOpdTestOrder(encounterId, service.getConceptId());
                opdTestOrder.setBillingStatus(1);
                patientDashboardService.saveOrUpdateOpdOrder(opdTestOrder);

                /* 
                 String bStatus=null;
                 bStatus="OK";
                
                 ConceptService conceptService = Context.getConceptService();
                 Date date = new Date();
                 IpdService ipdService = (IpdService) Context.getService(IpdService.class);
                 IpdPatientAdmission patientAdmission = new IpdPatientAdmission();
                
                 Encounter encounter = new Encounter();
                 if (servicename.equals("ADMISSION CHARGES") )
                 {
                 patientAdmission.setAdmissionDate(date);
                 patientAdmission.setAdmissionWard(conceptService.getConcept(servicename));
                 patientAdmission.setBirthDate(patient.getBirthdate());
                 patientAdmission.setGender(patient.getGender());
                 //           patientAdmission.setOpdAmittedUser(user);
                 patientAdmission.setPatient(patient);
                 patientAdmission.setStatus(bStatus);
                 patientAdmission.setOpdLog(opdTestOrder.getOpdLog());
                 patientAdmission.setEncounterId(encounterId);
                
                 patientAdmission.setPatientIdentifier(patient.getPatientIdentifier().getIdentifier());
                 patientAdmission.setPatientName(patient.getGivenName() + " " + patient.getMiddleName() + " " + patient.getFamilyName());
                 patientAdmission = ipdService.saveIpdPatientAdmission(patientAdmission);
                 }
                
                 */
                // New Code Enter Here for Billing queue submit and admitted complete
                
                IpdService ipdService = (IpdService) Context.getService(IpdService.class);
	        IpdPatientAdmittedQueueLog admission = ipdService.getIpdpatientAdmittedQueueLogNew(opdTestOrder.getEncounter().getEncounterId());
                
                Date date = new Date();
                String relationshipType = "";
                String fathername = "";
                
                IpdPatientAdmitted admitted = new IpdPatientAdmitted();
                if (servicename.equals("ADMISSION CHARGES") )
                 {
                admitted.setPatient(admission.getPatient());
                admitted.setAdmissionDate(date);
                admitted.setPatientName(admission.getPatientName());
                admitted.setPatientIdentifier(admission.getPatientIdentifier());
                admitted.setGender(admission.getGender());
                admitted.setPatientAdmissionLog(admission.getPatientAdmissionLog());
                admitted.setBirthDate(admission.getBirthDate());
                
                PersonAddress add = admission.getPatient().getPersonAddress();
                String address = add.getAddress1();
                
                PersonAttribute relationNameattr = admission.getPatient().getAttribute("Father/Husband Name");
                PersonAttribute relationTypeattr = admission.getPatient().getAttribute("Relative Name Type");
                
                admitted.setPatientAddress(StringUtils.isNotBlank(address) ? address : "");
                admitted.setUser(Context.getAuthenticatedUser());
                admitted.setAdmittedWard(admission.getAdmittedWard());
                admitted.setPatientAdmissionLog(admission.getPatientAdmissionLog());
                admitted.setIpdAdmittedUser(admission.getIpdAdmittedUser());
                admitted.setBasicPay(admission.getBasicPay());
                admitted.setCaste(admission.getCaste());
                admitted.setComments(admission.getComments());
                admitted.setMonthlyIncome(admission.getMonthlyIncome());
                if (relationNameattr != null) {

                    fathername = relationNameattr.getValue();
                }
                admitted.setFatherName(fathername);
                if (relationTypeattr != null) {
                    relationshipType = relationTypeattr.getValue();
                } else {
                    relationshipType = "Relative Name";
                }

                admitted.setBed(admission.getBed().toString());
                admitted.setRelationshipType(relationshipType);

                admitted.setStatus(BillingConstants.STATUS[0]);

                ipdService.saveIpdPatientAdmitted(admitted);
                ipdService.removeIpdPatientAdmittedQueueLogNew(admission);
                 }

                /////////////////     End    /////////////////////
                
                
            } else {
                servicename = request.getParameter(i.toString() + "service");
                service = billingService.getServiceByConceptName(servicename);
                opdTestOrder = billingService.getOpdTestOrder(encounterId, service.getConceptId());
                opdTestOrder.setCancelStatus(1);
                patientDashboardService.saveOrUpdateOpdOrder(opdTestOrder);
            }
        }

        bill.setAmount(totalAmount.getAmount());
        bill.setActualAmount(totalActualAmount);
        bill.setFreeBill(2);
        bill.setReceipt(billingService.createReceipt());
        bill = billingService.savePatientServiceBill(bill);

        return "redirect:/module/billing/patientServiceBillForBD.list?patientId=" + patientId + "&billId="
                + bill.getPatientServiceBillId() + "&billType=" + billType;
    }
}
