/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.billing.web.controller.staticreport;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.math.NumberUtils;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.MedisunService;
import org.openmrs.module.hospitalcore.model.DiaCommissionCal;
import org.openmrs.module.hospitalcore.model.DiaCommissionCalAll;
import org.openmrs.module.hospitalcore.model.DiaCommissionCalPaid;
import org.openmrs.module.hospitalcore.model.DiaCommissionCalPaidAdj;
import org.openmrs.module.hospitalcore.model.DiaRmpCommCalculationPaid;
import org.openmrs.module.hospitalcore.model.DiaRmpCommCalculationPaidAdj;
import org.openmrs.module.hospitalcore.model.DiaRmpName;
import org.openmrs.module.hospitalcore.model.DocDetail;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author Khairul
 */
@Controller("RmpCommissionReportsView")
public class RmpCommissionPayment {

    @RequestMapping(value = "/module/billing/rmpComView.htm", method = RequestMethod.GET)
    public String comView(Model model) {

        return "module/billing/reports/rmpComView";
    }

    @RequestMapping(value = "/module/billing/rmpComResult.htm", method = RequestMethod.GET)
    public String getCommision(HttpServletRequest request,
            @RequestParam("rmpIdName") Integer rmpId,
            @RequestParam(value = "sDate", required = false) String startDate,
            @RequestParam(value = "eDate", required = false) String endDate,
            @RequestParam(value = "status", required = false) int status,
            Model model) {

        MedisunService ms = Context.getService(MedisunService.class);

        model.addAttribute("status", status);

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Date date = null;
        Date date1 = null;
        try {
            date = sdf.parse(startDate);
            date1 = sdf.parse(endDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        if (status == 0) {
            List<DiaCommissionCal> diaComCal = ms.getDiaComCalRmpStatus(rmpId, status, date, date1);
            model.addAttribute("diaComCal", diaComCal);
            model.addAttribute("diaComCalSize", diaComCal.size());

            List<DiaCommissionCalAll> listDiaComAll = ms.listDiaComCalAllRmp(rmpId, status, date, date1);
            model.addAttribute("listDiaComAll", listDiaComAll);

            model.addAttribute("startDate", date);
            model.addAttribute("endDate", date1);

            DiaRmpName rmpInfo = ms.getDiaRmpById(rmpId);
            model.addAttribute("docInfo", rmpInfo);
            System.out.println("***********00000000000*****" + status);

        }
        if (status == 1) {
 
            List<DiaCommissionCal> diaComCal = ms.getDiaComRmpNew(rmpId, date, date1);
            model.addAttribute("diaComCal", diaComCal);

            List<DiaCommissionCalAll> listDiaComAll = ms.listDiaComCalAllRmp(rmpId,status, date, date1);
            model.addAttribute("listDiaComAll", listDiaComAll);

            model.addAttribute("startDate", date);
            model.addAttribute("endDate", date1);

            DiaRmpName rmpInfo = ms.getDiaRmpById(rmpId);
            model.addAttribute("docInfo", rmpInfo);

            System.out.println("***********1111111111******" + status);
        }

        if (Context.getAuthenticatedUser() != null && Context.getAuthenticatedUser().getId() != null) {
            return "module/billing/reports/rmpComView";
        } else {
            return "redirect:/login.htm";
        }

        //  return "module/studentmanagement/session/checkSession";   
    }

    @RequestMapping(value = "/module/billing/rmpComSave.form", method = RequestMethod.POST)
    public String saveCommission(HttpServletRequest request,
            @RequestParam("comId") Integer comID,
            @RequestParam("indCount") Integer indCount,
            @RequestParam("docId") Integer docId,
            @RequestParam(value = "note", required = false) String note,
            @RequestParam(value = "sDateValue", required = false) Date startDate,
            @RequestParam(value = "eDateValue", required = false) Date endDate,
            @RequestParam(value = "status", required = false) int status,
            Model model) {

        MedisunService ms = Context.getService(MedisunService.class);
        User user = Context.getAuthenticatedUser();

        BigDecimal serviceAmount = NumberUtils.createBigDecimal(request.getParameter("totalBill"));
        BigDecimal netAmount = NumberUtils.createBigDecimal(request.getParameter("dcomm"));
        BigDecimal lessAount = NumberUtils.createBigDecimal(request.getParameter("lamount"));
        BigDecimal docComm = NumberUtils.createBigDecimal(request.getParameter("docNet"));
        BigDecimal paid = NumberUtils.createBigDecimal(request.getParameter("paid"));
        BigDecimal due = NumberUtils.createBigDecimal(request.getParameter("due"));

        DiaRmpCommCalculationPaid dpaid = new DiaRmpCommCalculationPaid();
        dpaid.setServiceAmount(serviceAmount);
        dpaid.setNetAmount(netAmount);
        dpaid.setLessAmount(lessAount);
        dpaid.setRmpCommission(docComm);
        dpaid.setCreatedDate(new Date());
        dpaid.setCreator(user);
        dpaid.setRmpId(comID);
        dpaid.setPaidAmount(paid);
        dpaid.setDueAmount(due);
        dpaid.setNote(note);
        ms.saveRmpComPaid(dpaid);

        DiaRmpCommCalculationPaidAdj diaAdj = new DiaRmpCommCalculationPaidAdj();
        diaAdj.setDiaRmpComPaid(dpaid);
        diaAdj.setPayableAmount(docComm);
        diaAdj.setPaidAmount(paid);
        diaAdj.setDueAmount(due);
        diaAdj.setUser(user);
        diaAdj.setCreatedDate(new Date());
        ms.saveDiaRmpAdj(diaAdj);

        List<DiaCommissionCalAll> listDiaComAll = ms.listDiaComCalAllRmp(docId, status, startDate, endDate);
        for (int i = 0; i < listDiaComAll.size(); i++) {
            DiaCommissionCalAll dAll = (DiaCommissionCalAll) listDiaComAll.get(i);
            dAll.setStatus(Boolean.TRUE);
            ms.saveDiaComAll(dAll);
        }

        List<DiaCommissionCal> diaComCal = ms.getDiaComCalRmpStatus(comID, status, startDate, endDate);

        // List<DiaCommissionCal> diaList = ms.getDiaComCalByBillId(comID); //  Get By Ref Id then save it
        for (int i = 0; i < diaComCal.size(); i++) {
            DiaCommissionCal d = (DiaCommissionCal) diaComCal.get(i);
            d.setStatus(Boolean.TRUE);
            d.setDiaRmpComPaid(dpaid);
            ms.saveDiaComCal(d);
        }

        return "module/billing/reports/rmpComView";

    }

//    @RequestMapping(value = "/module/billing/rmpComSave.form", method = RequestMethod.POST)
//    public String saveCommission(HttpServletRequest request,
//            @RequestParam("comId") Integer comId,
//            @RequestParam("indCount") Integer indCount,
//            @RequestParam("docId") Integer docId,
//            @RequestParam(value = "note", required = false) String note,
//            @RequestParam(value = "sDateValue", required = false) Date startDate,
//            @RequestParam(value = "eDateValue", required = false) Date endDate,
//            Model model) {
//
//        MedisunService ms = Context.getService(MedisunService.class);
//        User user = Context.getAuthenticatedUser();
//
//        BigDecimal serviceAmount = NumberUtils.createBigDecimal(request.getParameter("totalBill"));
//        BigDecimal netAmount = NumberUtils.createBigDecimal(request.getParameter("dcomm"));
//        BigDecimal lessAount = NumberUtils.createBigDecimal(request.getParameter("lamount"));
//        BigDecimal docComm = NumberUtils.createBigDecimal(request.getParameter("docNet"));
//        BigDecimal paid = NumberUtils.createBigDecimal(request.getParameter("paid"));
//        BigDecimal due = NumberUtils.createBigDecimal(request.getParameter("due"));
//
//        DiaRmpCommCalculationPaid drmp = new DiaRmpCommCalculationPaid();
//        drmp.setServiceAmount(serviceAmount);
//        drmp.setNetAmount(netAmount);
//        drmp.setLessAmount(lessAount);
//        drmp.setRmpCommission(docComm);
//        drmp.setCreatedDate(new Date());
//        drmp.setCreator(user);
//        drmp.setRmpId(comId);
//        drmp.setPaidAmount(paid);
//        drmp.setDueAmount(due);
//        drmp.setNote(note);
//        ms.saveRmpComPaid(drmp);
//
//        DiaRmpCommCalculationPaidAdj diaRmpAdj = new DiaRmpCommCalculationPaidAdj();
//        diaRmpAdj.setDiaRmpComPaid(drmp);
//        diaRmpAdj.setPayableAmount(docComm);
//        diaRmpAdj.setPaidAmount(paid);
//        diaRmpAdj.setDueAmount(due);
//        diaRmpAdj.setUser(user);
//        diaRmpAdj.setCreatedDate(new Date());
//        ms.saveDiaRmpAdj(diaRmpAdj);
//
//        List<DiaCommissionCal> diaRmpComCal = ms.getDiaComCalRmp(comId, startDate, endDate);
//
//        // List<DiaCommissionCal> diaList = ms.getDiaComCalByBillId(comID); //  Get By Ref Id then save it
//        for (int i = 0; i < diaRmpComCal.size(); i++) {
//            DiaCommissionCal d = (DiaCommissionCal) diaRmpComCal.get(i);
//            d.setStatus(Boolean.TRUE);
//            d.setDiaRmpComPaid(drmp);
//            ms.saveDiaComCal(d);
//        }
//
//        return "module/billing/reports/rmpComView";
//
//    }
}
