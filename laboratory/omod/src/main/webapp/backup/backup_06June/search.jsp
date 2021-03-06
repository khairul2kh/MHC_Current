<%-- 
    Document   : patientInfo
    Created on : Nov 21, 2015, 11:13:48 AM
    Author     : Khairul
--%>
<%@ include file="/WEB-INF/template/include.jsp" %>
<hr/> 

<style>
    .div1 {
        width:300px;
        background-color: white;
        border:1px solid #000;
        box-shadow: 5px 5px;
    }
</style>

<center>
    <c:forEach var="test" items="${investigation}">
        <c:choose>
            <c:when test="${investigation eq '2311' || investigation eq '2577' || investigation eq '5158' || investigation eq '3937' || investigation eq '4252'}">
                <div class="div1">   <h2>BIOCHEMISTRY REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '2543'}">
                <div class="div1">   <h2>ELECTROLYTES REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '2415' || investigation eq '5148'}">
                <div class="div1">   <h2>URINE EXAMINATION REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '3117'}">
                <div class="div1">   <h2>STOOL EXAMINATION REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '2734'}">
                <div class="div1">   <h2>MICROBIOLOGY REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '3945' || investigation eq '5216' || investigation eq '3092' }">
                <div class="div1"><h2>IMMUNOLOGY REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '5142'}">
                <div class="div1">    <h2>PATHOLOGY REPORT</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '2563'}"> 
                <div class="div1">    <h2>DEPARTMENT OF HISTOPATHOLOGY</h2></div><br>
            </c:when>
            <c:when test="${investigation eq '4569'}">
                <div class="div1">    <h2>TRANSFUSION MEDICINE DEPARTMENT</h2></div><br>
            </c:when> 
            <c:when test="${investigation eq '4679'}">
                <div class="div1">    <h2>HAEMATOLOGY REPORT </h2></div><br>
            </c:when> 
            <c:when test="${investigation eq '2400' || investigation eq '5225'}">
                <div class="div1"> <h2>SEROLOGY REPORT </h2></div><br>
            </c:when> 
            <c:when test="${investigation eq '5718'}">
                <div class="div1"> <h2>MANTOUX TEST </h2></div><br>
            </c:when> 
            <c:otherwise>
                <!--  <h2>ALL TESTS BY GROUP</h2> -->
            </c:otherwise>                
        </c:choose>
    </c:forEach>
</center>

<center>
    <!-- <div style="width:90%" id="patientReportTestInfo"></div> <br> -->
    <div style="width:90%" ><%@ include file="../patientreport/reportformat/patientInfo.jsp"%> </div> <br>
    <table class="tablesorter" style="width:90%">

        <c:forEach var="test" items="${investigation}">
            <c:choose>
                <c:when test="${investigation eq '2415' || investigation eq '3117'}">     
                </c:when>
                <c:otherwise>
                    <thead>
                        <tr>		
                            <th> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test </th>
                            <th style="padding-left:20px;"> Result </th>
                            <th style="padding-left:20px;"> Unit </th>
                            <th style="padding-left:20px; width:30%"> Reference Range </th> 
                        </tr>
                    </thead> 
                </c:otherwise>                
            </c:choose>
        </c:forEach>

        <tbody>
            <c:forEach var="test" items="${investigation}">
                <c:choose>
                    <c:when test="${investigation eq '2311' || investigation eq '4252'}">
                        <!--  <h2>DEPARTMENT OF BIOCHEMISTRY</h2> <br> -->
                    <h3>Estimations are carried out by Vitros-250 Random Access Automated Chemistry Analyzer</h3>
                </c:when>
                <c:when test="${investigation eq '5158' || investigation eq '5225'}">
                    <!--  <h2> HbA1c </h2> <br> -->
                    <h3>Estimations are carried out by Genius-PA54 Random Access Automated Specific Protein Analyzer</h3>
                </c:when>
                <c:when test="${investigation eq '2734'}">
                    <h2>DEPARTMENT OF MICROBIOLOGY</h2>
                </c:when>
                <c:when test="${investigation eq '3945'}">
                    <!-- <h2>DEPARTMENT OF IMMUNOLOGY</h2>  Estimations are carried out by Genius-PA54 Random Access Automated Specific Protein Analyzer<br> -->
                    <span style="margin-top:100px"><i>Estimations are carried out by Maglumi-800 Random Access Multibatch chemiluminescence immunoassay (CLIA) Analyzer</i></span>
                </c:when>
                <c:when test="${investigation eq '5216'}">
                    <!-- <h2> ANA </h2> --> 
                    <span style="margin-top:100px"><i>Estimations are carried out by Micro plate Reader (ELISA)</i></span>
                </c:when>
                <c:when test="${investigation eq '2543'}">
                    <!-- S. ELECTROLYTES -->
                    <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                        <i>Estimations are carried out by Vitros-250 Random Access Automated Chemistry Analyzer</i></span>			 
                    </c:when>
                    <c:when test="${investigation eq '3937'}">
                    <!-- CCR -->
                    <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                        <i>Estimations are carried out by Vitros-250 Random Access Automated Chemistry Analyzer</i></span>			 
                    </c:when>
                    <c:when test="${investigation eq '3092'}">
                    <!-- beta - hCG -->
                    <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                        <i>Estimations are carried out by Maglumi-800 Random Access Automated Immunoassay Analyzer </i>
                    </c:when>
                    <c:when test="${investigation eq '4569'}">
                        <h2>TRANSFUSION MEDICINE DEPARTMENT</h2>
                    </c:when> 
                    <c:when test="${investigation eq '4679'}">
                        <!--  <h2>DEPARTMENT OF HAEMATOLOGY</h2> -->
                        <span style="margin-top:100px;font-size:17px;"><i>(Relevent estimations were carried out by Mythic-22 Automated 5 Part Haematology Analyzer & checked manually)</i></span>
                    </c:when> 
                    <c:otherwise>
                        <!--  <h2>ALL TESTS BY GROUP</h2> -->
                    </c:otherwise>                
                </c:choose>
                <tr> <td colspan="4">&nbsp;</td></tr>

                <%@ include file="../patientreport/reportformat/bio_1.jsp"%>
                <c:forEach var="test" items="${tests}">
                    <c:if test="${(test.investigation eq 'DEPARTMENT OF BIOCHEMISTRY' && investigation eq '2311') ||
                                  (test.investigation eq 'DEPARTMENT OF CLINICAL PATHOLOGY' && investigation eq '5142') ||
                                  (test.investigation eq 'DEPARTMENT OF MICROBIOLOGY' && investigation eq '2734') ||
                                  (test.investigation eq 'DEPARTMENT OF CLINICAL IMMUNOLOGY' && investigation eq '3945') ||
                                  (test.investigation eq 'DEPARTMENT OF SEROLOGY' && investigation eq '2400') ||
                                  (test.investigation eq 'DEPARTMENT OF HAEMATOLOGY' && investigation eq '4679') ||
                                  (test.investigation eq 'DEPARTMENT OF CYTOLOGY' && investigation eq '2399')}">
                          <tr>	
                              <td>
                                 <!-- <c:if test="${test.level eq 'LEVEL_INVESTIGATION'}"><b>${test.investigation}</b></c:if> -->
                                  <c:if test="${test.level eq 'LEVEL_SET'}">
                                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                      ${test.set}
                                  </c:if>
                                  <c:if test="${test.level eq 'LEVEL_TEST'}"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                      ${test.test}</c:if>  
                                  </td>
                                  <td align="left" style="padding-left:20px;"> ${test.value}</td>
                              <td align="left" style="padding-left:20px;"> ${test.unit}</td>
                              <td align="left" style="padding-left:20px;"> 
                                  <c:if test="${not empty test.refRange}"> ${test.refRange} </c:if>
                                  <c:if test="${empty test.refRange}">
                                      ${test.lowNormal} 
                                      <c:if test="${not empty test.lowNormal and not empty test.hiNormal}">-</c:if>
                                      ${test.hiNormal}
                                  </c:if>
                              </td>
                          </tr>	
                    </c:if>
                    <c:if test="${(investigation eq 'select')}">
                        <tr>		
                            <td>
                                <c:if test="${test.level eq 'LEVEL_INVESTIGATION'}"><b>${test.investigation}</b></c:if>
                                <c:if test="${test.level eq 'LEVEL_SET'}">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    ${test.set}
                                </c:if>
                                <c:if test="${test.level eq 'LEVEL_TEST'}"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    ${test.test}</c:if>  
                                </td>
                                <td align="center">${test.value}</td>
                            <td align="center">${test.unit}</td>
                            <td align="left" style="padding-left:20px;"> 
                                <c:if test="${not empty test.refRange}"> ${test.refRange} </c:if>
                                <c:if test="${empty test.refRange}">
                                    ${test.lowNormal} 
                                    <c:if test="${not empty test.lowNormal and not empty test.hiNormal}"> - </c:if>
                                    ${test.hiNormal}
                                </c:if>
                            </td>
                        </tr>	
                    </c:if>	
                </c:forEach>
            </c:forEach>
            </tbody>
            <%@ include file="../patientreport/reportformat/bio.jsp"%>
            <%@ include file="../patientreport/reportformat/immu.jsp"%>
            <%@ include file="../patientreport/reportformat/oth.jsp"%>
            <%@ include file="../patientreport/reportformat/sero.jsp"%>

    </table>

</center>

<div id="patientReportPrintArea" style="display:none;">
    <style>
        table.wltable {

            font-family: Verdana, 'Lucida Grande', 'Trebuchet MS', Arial, Sans-Serif;			
            font-style: normal;
            font-size: 14px;
        }
        table.wltable th {
            border: 1px solid;
            background-color: #fff;
        }
        table.wltable td {
            padding: 5px 5px 5px 5px;
        }
        table.wltable .right {
        }
        .div1 {
            width:400px;
            background-color: white;
            border:1px solid #000;
            box-shadow: 5px 5px;
        }
    </style>
    <center>
        <c:forEach var="test" items="${investigation}">
            <c:choose>
                <c:when test="${investigation eq '2311' || investigation eq '2577' || investigation eq '5158' || investigation eq '3937' || investigation eq '4252'}">
                    <div class="div1">   <h2>BIOCHEMISTRY REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '2543'}">
                    <div class="div1">   <h2>ELECTROLYTES REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '2415' || investigation eq '5148'}">
                    <div class="div1">   <h2>URINE EXAMINATION REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '3117'}">
                    <div class="div1">   <h2>STOOL EXAMINATION REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '2734'}">
                    <div class="div1">    <h2>MICROBIOLOGY REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '3945' || investigation eq '5216' || investigation eq '3092'}">
                    <div class="div1"><h2>IMMUNOLOGY REPORT</h2></div><br>
                </c:when>				
                <c:when test="${investigation eq '5142'}">
                    <div class="div1">    <h2>PATHOLOGY REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '2563'}">
                    <div class="div1">    <h2>HISTOPATHOLOGY REPORT</h2></div><br>
                </c:when>
                <c:when test="${investigation eq '4569'}">
                    <div class="div1">    <h2>TRANSFUSION MEDICINE DEPARTMENT</h2></div><br>
                </c:when> 
                <c:when test="${investigation eq '4679'}">
                    <div class="div1">   <h2>HAEMATOLOGY REPORT</h2></div><br>
                </c:when> 
                <c:when test="${investigation eq '2400' || investigation eq '5225'}">
                    <div class="div1"> <h2>SEROLOGY REPORT </h2> </div><br>
                </c:when> 
                <c:when test="${investigation eq '5718'}">
                    <div class="div1"> <h2>MANTOUX TEST </h2></div><br>
                </c:when> 
                <c:otherwise>
                    <!--  <h2>ALL TESTS BY GROUP</h2> -->
                </c:otherwise>                
            </c:choose>
        </c:forEach>
    </center>
    <!-- <div id="printAreaTestInfo"></div><br/><br/> -->
    <%@ include file="../patientreport/reportformat/patientInfo.jsp"%> <br>
    <table class="wltable" cellspacing="0" style="width:100%; border: 0px solid; margin-left: auto; margin-right: auto;">

        <c:forEach var="test" items="${investigation}">
            <c:choose>
                <c:when test="${investigation eq '2415' || investigation eq '3117'}">     
                </c:when>
                <c:otherwise>
                    <thead>
                        <tr>
                            <th class="right" style="padding:5px 5px 5px 5px; border-right:1px solid #fff; width:40%; ">   &nbsp;   Test </th>
                            <th class="right" style="border-left:1px solid #fff; border-right:1px solid #fff; padding-left:20px;"> Result </th>
                            <th class="right" style="border-left:1px solid #fff; border-right:1px solid #fff; padding-left:20px;"> Unit </th>
                            <th class="right" style="padding-left:10px; width:30%; font-size: 13px; border-left:1px solid #fff;"> Reference Range </th>
                        </tr>
                    </thead>
                </c:otherwise>                
            </c:choose>
        </c:forEach>

        <tbody>
            <c:forEach var="test" items="${investigation}">
            <center>
                <c:choose>
                    <c:when test="${investigation eq '2311' || investigation eq '4252'}">
                        <span style="margin-top:100px; font-size:16px; font-weight: bold; text-align:center;"><i> Estimations are carried out by Vitros-250 Random Access Automated Chemistry Analyzer </i></span> <br>
                    </c:when>
                    <c:when test="${investigation eq '5158' || investigation eq '5225'}">
                        <!--  <h2> HbA1c </h2> <br> -->
                        <h2>Estimations are carried out by Genius-PA54 Random Access Automated Specific Protein Analyzer</h2>
                    </c:when>
                    <c:when test="${investigation eq '2734'}">
                        <h2>DEPARTMENT OF MICROBIOLOGY</h2>
                    </c:when>
                    <c:when test="${investigation eq '3945'}">
                        <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;"><i>Estimations are carried out by Maglumi-800 Random Access Multibatch chemiluminescence immunoassay (CLIA) Analyzer</i></span>			 
                    </c:when>
                    <c:when test="${investigation eq '2543'}">
                        <!-- S. ELECTROLYTES -->
                        <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                            <i>Estimations are carried out by Vitros-250 Random Access Automated Chemistry Analyzer</i></span>			 
                        </c:when>
                        <c:when test="${investigation eq '3937'}">
                        <!-- CCR -->
                        <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                            <i>Estimations are carried out by Vitros-250 Random Access Automated Chemistry Analyzer</i></span>			 
                        </c:when>
                        <c:when test="${investigation eq '3092'}">
                        <!-- beta - hCG -->
                        <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                            <i>Estimations are carried out by Maglumi-800 Random Access Automated Immunoassay Analyzer </i>
                        </c:when>
                        <c:when test="${investigation eq '5216'}">
                            <!-- <h2> ANA </h2> --> 
                            <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                                <i>Estimations are carried out by Micro plate Reader (ELISA)</i></span>
                            </c:when>
                            <c:when test="${investigation eq '2577'}">
                            <!-- PT -->
                            <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;">
                                <i>Estimations are carried out by ALS-SC2(ALARis TURKEY) Semi-Automated Coagulation Analyzer</i></span>			 
                            </c:when>
                            <c:when test="${investigation eq '2563'}">
                            <h2>DEPARTMENT OF HISTOPATHOLOGY</h2>
                        </c:when>
                        <c:when test="${investigation eq '4569'}">
                            <h2>TRANSFUSION MEDICINE DEPARTMENT</h2>
                        </c:when> 
                        <c:when test="${investigation eq '4679'}">
                            <span style="margin-top:100px; text-align:center; font-size:17px; font-weight: bold;"><i>(Relevent estimations were carried out by Mythic-22 Automated 5 Part Haematology Analyzer & checked manually) </i></span>
                        </c:when> 
                        <c:otherwise>
                            <!--  <h2>ALL TESTS BY GROUP</h2> -->
                        </c:otherwise>                
                    </c:choose>
            </center>

            <c:forEach var="test" items="${investigation}">
                <c:choose>
                    <c:when test="${investigation eq '2415' || investigation eq '3117'}">     
                    </c:when>
                    <c:otherwise>
                        <br>
                        <tr> <td colspan="4">&nbsp;</td></tr>
                    </c:otherwise>                
                </c:choose>
            </c:forEach>

            <!--
<br>
<tr> <td colspan="4">&nbsp;</td></tr> -->
            <%@ include file="../patientreport/reportformat/bio_1.jsp"%>
            <c:forEach var="test" items="${tests}">
                <c:if test="${(test.investigation eq 'DEPARTMENT OF BIOCHEMISTRY' && investigation eq '2311') ||
                              (test.investigation eq 'DEPARTMENT OF CLINICAL PATHOLOGY' && investigation eq '5142') ||
                              (test.investigation eq 'DEPARTMENT OF MICROBIOLOGY' && investigation eq '2734') ||
                              (test.investigation eq 'DEPARTMENT OF CLINICAL IMMUNOLOGY' && investigation eq '3945') ||
                              (test.investigation eq 'DEPARTMENT OF SEROLOGY' && investigation eq '2400') ||
                              (test.investigation eq 'DEPARTMENT OF HAEMATOLOGY' && investigation eq '4679') ||
                              (test.investigation eq 'DEPARTMENT OF CYTOLOGY' && investigation eq '2399')}">
                      <tr>		
                          <td class="right">
                              <!-- <c:if test="${test.level eq 'LEVEL_INVESTIGATION'}"><b>${test.investigation}</b></c:if> -->
                              <c:if test="${test.level eq 'LEVEL_SET'}">
                                  &nbsp;&nbsp; 
                                  ${test.set}
                              </c:if>
                              <c:if test="${test.level eq 'LEVEL_TEST'}">  
                                  ${test.test}</c:if>  
                              </td>
                              <td align="left" style="padding-left:20px;"> ${test.value}</td>
                          <td align="left" style="padding-left:20px;"> ${test.unit}</td>
                          <td align="left" style="padding-left:10px; font-size:10px;"> 
                              <c:if test="${not empty test.refRange}"> ${test.refRange} </c:if>
                              <c:if test="${empty test.refRange}">
                                  ${test.lowNormal} 
                                  <c:if test="${not empty test.lowNormal and not empty test.hiNormal}">&nbsp; - &nbsp;</c:if>
                                  ${test.hiNormal}
                              </c:if>
                          </td>
                      </tr>	
                </c:if>
                <c:if test="${(investigation eq 'select')}">
                    <tr>		
                        <td class="right">
                            <c:if test="${test.level eq 'LEVEL_INVESTIGATION'}"><b>${test.investigation}</b></c:if>
                            <c:if test="${test.level eq 'LEVEL_SET'}">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                ${test.set}
                            </c:if>
                            <c:if test="${test.level eq 'LEVEL_TEST'}"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                ${test.test}</c:if>  
                            </td>
                            <td align="center">${test.value}</td>
                        <td align="center">${test.unit}</td>
                        <td align="left" style="padding-left:20px; font-size: 13px;"> 
                            <c:if test="${not empty test.refRange}"> ${test.refRange} </c:if>
                            <c:if test="${empty test.refRange}">
                                ${test.lowNormal} 
                                <c:if test="${not empty test.lowNormal and not empty test.hiNormal}"> &nbsp; - &nbsp; </c:if>
                                ${test.hiNormal}
                            </c:if>
                        </td>
                    </tr>	 
                </c:if>	 
            </c:forEach> 
        </c:forEach>
        <%@ include file="../patientreport/reportformat/bio.jsp"%>
        <%@ include file="../patientreport/reportformat/immu.jsp"%>
        <%@ include file="../patientreport/reportformat/oth.jsp"%>
        <%@ include file="../patientreport/reportformat/sero.jsp"%>
    </table>
</div>

<style>
    .absolute {
        position: absolute;
        top:1070px;
        right:0px;
        width: 800px;
        height: 0px;
    }
</style>