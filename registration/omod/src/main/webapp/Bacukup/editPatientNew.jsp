<%-- 
    Document   : editPatientNew
    Created on : Mar 13, 2016, 2:24:28 AM
    Author     : Khairul
--%>
<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ include file="../includes/js_css.jsp"%>

<script>
    jQuery(document).ready(function() {
        jQuery('#age').datepicker({yearRange: 'c-30:c+30', dateFormat: 'dd/mm/yy', changeMonth: true, changeYear: true});
    });

    PAGE = {
        /** SUBMIT */
        submit: function() {

            jQuery("#patientRegistrationEditForm").mask("<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
            jQuery("#patientRegistrationEditForm")
                    .ajaxSubmit(
                            {
                                success: function( ) {
                                    window.location.href = openmrsContextPath
                                            + "/findPatient.htm"
                                    jQuery("#patientRegistrationEditForm").unmask();
                                }
                            });
        },
    };
</script>

<div id="patientSearchResult"></div>
<form id="patientRegistrationEditForm" method="POST" class="kha-nf">
    <h1>Edit Patient Form</h1>
    <br>
    <table cellspacing="0">
        <tr> 
            <td style="width:15%; "> Patient ID   </td>
            <td> :</td>
            <td style="color:green; font-size:18px; font-weight:bold;">
                &nbsp;&nbsp; ${patient.identifier}
            </td>
        </tr>
        <tr> 
            <td> Patient Name  </td> <td> :</td>
            <td>
                <input type="text" id="fname" name="fname" value="${patient.givenName}" /> 
                <input type="text" id="mname" name="mname" value="${patient.middleName}" />  
                <input type="text" id="lname" name="lname" value="${patient.familyName}" /> 
            </td> 
        </tr>
        <tr>
            <td> Gender  </td> <td> :</td>
            <td> &nbsp;&nbsp;<select id="gender" name="gender">
                    <option value="${patient.gender}">${patient.gender}</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="O">Others</option>
                </select></td>
        </tr>
        <tr> 
            <td> DOB / Age </td> <td> :</td>
            <td> <input type="text" id="age" name="age" value="${patient.age}"
                        style="width:auto; color:green; font-size:18px; text-align:left;" 
                        class="date-pick left" />  ${patient.estAge}
                <input type="hidden" id="ageOnly" name="ageOnly" value="${patient.ageOnly}" /></td>
        </tr>
        <tr>
            <td> Phone  </td> <td> :</td> <td><input type="text" id="phone" name="phone" value="${phone}" /> </td>
        </tr>
    </table>
    <br><br><br>
    <div style="text-align:center;">
        <input class="button" type="button"   value="Save" onclick="PAGE.submit();" />
        
    </div> 
</form>
