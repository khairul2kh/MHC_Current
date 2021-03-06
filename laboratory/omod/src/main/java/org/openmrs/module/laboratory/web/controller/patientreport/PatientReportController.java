/**
 * Copyright 2011 Society for Health Information Systems Programmes, India (HISP
 * India)
 *
 * This file is part of Laboratory module.
 *
 * Laboratory module is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Laboratory module is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Laboratory module. If not, see <http://www.gnu.org/licenses/>.
 *
 *
 */
package org.openmrs.module.laboratory.web.controller.patientreport;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.openmrs.Concept;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.Lab;
import org.openmrs.module.laboratory.LaboratoryService;
import org.openmrs.module.laboratory.model.LabDoctorSeal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("LaboratoryPatientReportController")
@RequestMapping("/module/laboratory/patientReport.form")
public class PatientReportController {

    @ModelAttribute("investigations")
    public Set<Concept> getAllInvestigations() {
        LaboratoryService ls = (LaboratoryService) Context.getService(LaboratoryService.class);
        Lab department = ls.getCurrentDepartment();
        if (department != null) {
            Set<Concept> investigations = department.getInvestigationsToDisplay();
            return investigations;
        }
        return null;
    }

    @RequestMapping(method = RequestMethod.GET)
    public String showView(Model model) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String dateStr = sdf.format(new Date());
        model.addAttribute("currentDate", dateStr);

        LaboratoryService ls = (LaboratoryService) Context.getService(LaboratoryService.class);
        List<LabDoctorSeal> getAllDoc = ls.getAllListLabDocSeal();
        model.addAttribute("allDoc", getAllDoc);

        return "/module/laboratory/patientreport/list";
    }
}
