/**
 * Copyright 2008 Society for Health Information Systems Programmes, India (HISP
 * India)
 *
 * This file is part of Registration module.
 *
 * Registration module is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Registration module is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Registration module. If not, see <http://www.gnu.org/licenses/>.
 *
 *
 */
package org.openmrs.module.registration.web.controller.patient;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
import org.openmrs.ConceptName;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Order;
import org.openmrs.OrderType;
import org.openmrs.Patient;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.DmsCommonService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.DmsOpdUnit;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmittedLog;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.ObsUtils;
import org.openmrs.module.hospitalcore.util.OrderUtil;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.model.RegistrationFee;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.PatientModel;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("RegistrationShowPatientInfoController")
@RequestMapping("/module/registration/showPatientInfo.form")
public class ShowPatientInfoController {

    private static Log logger = LogFactory.getLog(ShowPatientInfoController.class);

    @RequestMapping(method = RequestMethod.GET)
    public String showPatientInfo(@RequestParam("patientId") Integer patientId,
            @RequestParam(value = "encounterId", required = false) Integer encounterId,
            @RequestParam(value = "reprint", required = false) Boolean reprint, Model model)
            throws IOException,
            ParseException {

        Patient patient = Context.getPatientService().getPatient(patientId);
        PatientModel patientModel = new PatientModel(patient);
        model.addAttribute("patient", patientModel);
        // ghanshyam,date:20-02-2013 New Requirement #512 [Registration] module for Bangladesh hospital
        String hospitalName = GlobalPropertyUtil.getString(HospitalCoreConstants.PROPERTY_HOSPITAL_NAME, "");

        if (hospitalName.equals("BD_HOSPITAL")) {
            DmsCommonService dmsCommonService = Context.getService(DmsCommonService.class);
            List<DmsOpdUnit> opdidlist = dmsCommonService.getOpdActivatedIdList();
            List<String> lcname = new ArrayList<String>();
            for (DmsOpdUnit doci : opdidlist) {
                Concept con = doci.getOpdConceptId();
                ConceptName conname = dmsCommonService.getOpdWardNameByConceptId(con);
                if (doci.getUnitNo().equals(0)) {
                    lcname.add(con.getId() + "," + conname);
                } else {
                    lcname.add(con.getId() + "," + conname + "(Unit-" + doci.getUnitNo() + ")");
                }

            }
            model.addAttribute("OPDs", lcname);
        } else {
            model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
            model.addAttribute("referralHospitals",
                    RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
        }

        // Get current date
        SimpleDateFormat sdf = new SimpleDateFormat("EEE dd/MM/yyyy kk:mm");
        model.addAttribute("currentDateTime", sdf.format(new Date()));

        // For SKH
       // SimpleDateFormat adf = new SimpleDateFormat("dd/MM/yyyy");
      //  model.addAttribute("currentDateVisit", adf.format(new Date()));
        //Get last visit
      //  HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
     //   model.addAttribute("lastVisit", adf.format(hcs.getLastVisitTime(patientId)));

        // Get patient registration fee
        if (GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0) > 0) {
            List<RegistrationFee> fees = Context.getService(RegistrationService.class).getRegistrationFees(patient,
                    GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0));
            if (!CollectionUtils.isEmpty(fees)) {
                RegistrationFee fee = fees.get(0);
                Calendar dueDate = Calendar.getInstance();
                dueDate.setTime(fee.getCreatedOn());
                dueDate.add(Calendar.DATE, 30);
                model.addAttribute("dueDate", RegistrationUtils.formatDate(dueDate.getTime()));
                model.addAttribute("daysLeft", dateDiff(dueDate.getTime(), new Date()));
            }
        }

        // Get selected OPD room if this is the first time of visit
        if (encounterId != null) {
            Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
            for (Obs obs : encounter.getObs()) {
                if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
                    model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
                }

            }
        }

        if (encounterId != null) {
            Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
            for (Obs obs : encounter.getObs()) {
                if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM)) {
                    model.addAttribute("selectedReffered", obs.getValueCoded().getName());
                }

            }
        }

        // If reprint, get the latest registration encounter
        if ((reprint != null) && reprint) {

            /**
             * June 7th 2012 - Supported #250 - Registration 2.2.14 (Mohali):
             * Date on Reprint
             */
            //HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
//            model.addAttribute("currentDateTime", sdf.format(hcs.getLastVisitTime(patientId)));

            Encounter encounter = Context.getService(RegistrationService.class).getLastEncounter(patient);
            if (encounter != null) {
                Map<Integer, String> observations = new HashMap<Integer, String>();

                for (Obs obs : encounter.getAllObs()) {
                    if (obs.getConcept().getDisplayString()
                            .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TEMPORARY_CATEGORY)) {
                        model.addAttribute("tempCategoryId", obs.getConcept().getConceptId());
                    } else if (obs.getConcept().getDisplayString()
                            .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
                        model.addAttribute("opdWardId", obs.getConcept().getConceptId());
                    }
                    observations.put(obs.getConcept().getConceptId(), ObsUtils.getValueAsString(obs));
                }
                model.addAttribute("observations", observations);
            }
        }
        /////////   New Code for MCHTI /////////////////
        User user = Context.getAuthenticatedUser();
        SimpleDateFormat sdff = new SimpleDateFormat("yyyy-MM-dd");
        RegistrationService rs = Context.getService(RegistrationService.class);

        Date d = new Date();
        String da = sdff.format(d);

        Date date2 = null;
        try {
            date2 = sdff.parse(da);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        List<Encounter> e = rs.countPatientByUser(user.getId(), date2);
        int count = 1;
        for (int i = 0; i < e.size(); i++) {
            count++;
        }
        model.addAttribute("count", count);
        model.addAttribute("user", user.getGivenName());

        //// End Code
        //ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
        Concept conforregfee = Context.getConceptService().getConcept("REGISTRATION FEE");
        Integer conforregfeeid = conforregfee.getConceptId();
        model.addAttribute("regFeeConId", conforregfeeid);
        Concept conforregfreereason = Context.getConceptService().getConcept("REGISTRATION FEE FREE REASON");
        Integer conforregfreereasonid = conforregfreereason.getConceptId();
        model.addAttribute("regFeeReasonConId", conforregfreereasonid);
        model.addAttribute("regFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_REGISTRATION_FEE, ""));
        if (hospitalName.equals("BD_HOSPITAL")) {
            return "/module/registration/patient/showPatientInfoBdHospital";
        } else {
            return "/module/registration/patient/showPatientInfo";
        }
    }

    /**
     * Get date diff betwwen 2 dates
     *
     * @param d1
     * @param d2
     * @return
     */
    private long dateDiff(Date d1, Date d2) {
        long diff = Math.abs(d1.getTime() - d2.getTime());
        return (diff / (1000 * 60 * 60 * 24));
    }

    @RequestMapping(method = RequestMethod.POST)
    public void savePatientInfo(@RequestParam("patientId") Integer patientId,
            @RequestParam(value = "encounterId", required = false) Integer encounterId,
            HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {

        Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);

        // get patient
        Patient patient = Context.getPatientService().getPatient(patientId);

        /*
         * SAVE ENCOUNTER
         */
        Encounter encounter = null;
        if (encounterId != null) {
            encounter = Context.getEncounterService().getEncounter(encounterId);
        } else {
            encounter = RegistrationWebUtils.createEncounter(patient, true);

            // create OPD obs
            Concept opdWardConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_OPD_WARD);
            Concept selectedOPDConcept = Context.getConceptService().getConcept(
                    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD)));
            Obs opd = new Obs();
            opd.setConcept(opdWardConcept);
            opd.setValueCoded(selectedOPDConcept);
            encounter.addObs(opd);

			// send patient to opd room/bloodbank
			//harsh 5/10/2012 changed the way to get blood bank concept->shifted hardcoded dependency from id to name
            //			Concept bloodbankConcept = Context.getConceptService().getConcept(
            //			    GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_BLOODBANK_CONCEPT_ID, 6425));
            String bloodBankWardName = GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_BLOODBANK_OPDWARD_NAME,
                    "Blood Bank Room");

            //ghanshyam 6-august-2013 code review bug
            if (!selectedOPDConcept.getName().toString().equals(bloodBankWardName)) {
                RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, true);
            } else {
                OrderType orderType = null;
                String orderTypeName = Context.getAdministrationService().getGlobalProperty("bloodbank.orderTypeName");
                orderType = OrderUtil.getOrderTypeByName(orderTypeName);

                Order order = new Order();
                order.setConcept(selectedOPDConcept);
                order.setCreator(Context.getAuthenticatedUser());
                order.setDateCreated(new Date());
                order.setOrderer(Context.getAuthenticatedUser());
                order.setPatient(patient);
                order.setStartDate(new Date());
                order.setAccessionNumber("0");
                order.setOrderType(orderType);
                order.setEncounter(encounter);
                encounter.addOrder(order);
            }
        }

        // create temporary attributes
        for (String name : parameters.keySet()) {
            if ((name.contains(".attribute.")) && (!StringUtils.isBlank(parameters.get(name)))) {
                String[] parts = name.split("\\.");
                String idText = parts[parts.length - 1];
                Integer id = Integer.parseInt(idText);

                //ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
                Concept concept = Context.getConceptService().getConcept(id);
                String conname = concept.getName().toString();

                if (conname.equals("REGISTRATION FEE")) {
                    Obs registrationFeeAttribute = new Obs();
                    registrationFeeAttribute.setConcept(concept);
                    registrationFeeAttribute.setValueAsString(parameters.get(name));
                    encounter.addObs(registrationFeeAttribute);
                }

                if (conname.equals("REGISTRATION FEE FREE REASON")) {
                    Obs registrationFeeFreeReasonAttribute = new Obs();
                    registrationFeeFreeReasonAttribute.setConcept(concept);
                    registrationFeeFreeReasonAttribute.setValueAsString(parameters.get(name));
                    encounter.addObs(registrationFeeFreeReasonAttribute);
                }

                if (conname.equals("TEMPORARY CATEGORY")) {
                    Obs temporaryAttribute = new Obs();
                    temporaryAttribute.setConcept(concept);
                    temporaryAttribute.setValueAsString(parameters.get(name));
                    encounter.addObs(temporaryAttribute);
                }

            }
        }

        // save encounter
        Context.getEncounterService().saveEncounter(encounter);
        logger.info(String.format("Save encounter for the visit of patient [encounterId=%s, patientId=%s]",
                encounter.getId(), patient.getId()));

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("success");
    }

}
