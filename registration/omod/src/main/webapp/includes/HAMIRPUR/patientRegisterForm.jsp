<style>
	.cell {
		border-top: 1px solid lightgrey;
		padding: 20px;
	}
</style>
<script type="text/javascript">

	jQuery(document).ready(function(){
		jQuery("#patientRegistrationForm").fillForm("patient.identifier==" + MODEL.patientIdentifier);			
		jQuery('#calendar').datepicker({yearRange:'c-100:c+100', dateFormat: 'dd/mm/yy', changeMonth: true, changeYear: true});	
		jQuery('#birthdate').change(PAGE.checkBirthDate);
		PAGE.fillOptions("#districts", {
			data:MODEL.districts
		});		
		PAGE.fillOptions("#tehsils", {
			data:MODEL.tehsils[0].split(',')
		});		

		MODEL.OPDs = " ,Please select an OPD room to visit|" + MODEL.OPDs;
		PAGE.fillOptions("#opdWard", {
			data:MODEL.OPDs,
			delimiter: ",",
			optionDelimiter: "|"
		});						
		PAGE.fillOptions("#referralHospitals", {
			data:MODEL.referralHospitals,
			delimiter: ",",
			optionDelimiter: "|"
		});	
		PAGE.fillOptions("#referralReasons	", {
			data:MODEL.referralReasons	,
			delimiter: ",",
			optionDelimiter: "|"
		});	
		
		jQuery("#searchbox").showPatientSearchBox({		
			searchBoxView: hospitalName + "/registration",
			resultView: "/module/registration/patientsearch/" + hospitalName + "/findCreate",
			success: function(data){
				PAGE.searchPatientSuccess(data);
			},
			beforeNewSearch: PAGE.searchPatientBefore
		});
		
		// hide bpl and rsby number
		jQuery("#bplField").hide();
		jQuery("#rsbyField").hide();
		jQuery("#patCatGeneral").attr("checked", "checked");
		
		// binding
		jQuery("#bpl").click(function(){
			VALIDATORS.bplCheck();
		});
		jQuery("#rsby").click(function(){
			VALIDATORS.rsbyCheck();
		});
		jQuery("#patCatStaff").click(function(){
			VALIDATORS.staffCheck();
		});
		jQuery("#patCatPoor").click(function(){
			VALIDATORS.poorCheck();
		});
		jQuery("#patCatGeneral").click(function(){
			VALIDATORS.generalCheck();
		});
		jQuery("#patCatGovEmp").click(function(){
			VALIDATORS.governmentCheck();
		});		
		jQuery("#calendarButton").click(function(){
			jQuery("#calendar").datepicker("show");
		});		
		jQuery("#calendar").change(function(){
			jQuery("#birthdate").val(jQuery(this).val());
			PAGE.checkBirthDate();
		});		
		jQuery("#birthdate").click(function(){
			jQuery("#birthdate").select();
		});
		jQuery("#patientGender").change(function(){
			VALIDATORS.genderCheck();
		});
	});
	
	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit: function(){						
			
			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery("#nameOrIdentifier", jQuery("#patientSearchForm")).val());
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);
			jQuery("#nameOrIdentifier", jQuery("#patientSearchForm")).val(fullNameInCapital);
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);			
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);
			
			// Validate and submit
			if(this.validateRegisterForm()){
				jQuery("#patientRegistrationForm").mask("<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");				
				jQuery("#patientRegistrationForm").ajaxSubmit({
					success: function(responseText, statusText, xhr){
						json = jQuery.parseJSON(responseText);
						if(json.status=="success"){
							window.location.href = openmrsContextPath + "/module/registration/showPatientInfo.form?patientId=" + json.patientId + "&encounterId=" + json.encounterId;
						} else {							
							alert(json.message);
						}
						jQuery("#patientRegistrationForm").unmask();
					}
				});
			}
		},
		
		/** VALIDATE BIRTHDATE */
		checkBirthDate: function() {
			jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/ajax/processPatientBirthDate.htm",
				data : ({
					birthdate: $("#birthdate").val()
				}),
				dataType: "json",
				success : function(json) {
					
					if(json.error==undefined){
						if(json.estimated == "true"){
							jQuery("#birthdateEstimated").val("true")
						} else {						
							jQuery("#birthdateEstimated").val("false");
						}
						
						jQuery("#estimatedAge").html(json.age);
						jQuery("#birthdate").val(json.birthdate);
						jQuery("#calendar").val(json.birthdate);
					} else {
						alert(json.error);	}
				},
				error : function(xhr, ajaxOptions, thrownError) {
					alert(thrownError);
				}
			});
		},
		
		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions: function(divId, option) {
			jQuery(divId).empty();
			if(option.delimiter == undefined){
				if(option.index == undefined){
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + value + "'>" + value + "</option>");
						}
					});				
				} else {
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + option.index[index] + "'>" + value + "</option>");
						}
					});
				}
			} else {
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value){
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if(optionLabel != undefined){
						if(optionLabel.length>0){
							jQuery(divId).append("<option value='" + optionValue + "'>" + optionLabel + "</option>");
						}
					}
					
				});
			}
		},
		
		/** CHANGE DISTRICT */
		changeDistrict: function() {		

			// get the list of tehsils
			tehsilList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value){
				if(value == selectedDistrict){
					tehsilList = MODEL.tehsils[index];					
				}
			});
			
			// fill tehsils into tehsil dropdown
			this.fillOptions("#tehsils", {
				data: tehsilList.split(",")
			});
		},
		
		/** SHOW OR HIDE REFERRAL INFO */
		toogleReferralInfo: function(obj){
			checkbox = jQuery(obj);
			if(checkbox.is(":checked")){
				jQuery("#referralDiv").show();
			} else {
				jQuery("#referralDiv").hide();
			}
		},
		
		/** CALLBACK WHEN SEARCH PATIENT SUCCESSFULLY */
		searchPatientSuccess: function(data){			
			jQuery("#numberOfFoundPatients").html("Similar patients: " + data.totalRow + "(<a href='javascript:PAGE.togglePatientResult();'>show/hide</a>)");
		},
		
		/** CALLBACK WHEN BEFORE SEARCHING PATIENT */
		searchPatientBefore: function(data){
			jQuery("#numberOfFoundPatients").html("<center><img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/></center>");
			jQuery("#patientSearchResult").hide();
		},
		
		/** TOGGLE PATIENT RESULT */
		togglePatientResult: function(){
			jQuery("#patientSearchResult").toggle();
		},
		
		/** VALIDATE FORM */
		validateRegisterForm: function(){			
		
			if(StringUtils.isBlank(jQuery("#patientName").val())){
				alert("Please enter patient name");
				return false;
			}			
			
			if(StringUtils.isBlank(jQuery("#patientRelativeName").val())){
				alert("Please enter relative name");
				return false;
			} else {
				if(jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length==0){
					alert("Please select relative name type");
					return false;
				}
			}

			if(StringUtils.isBlank(jQuery("#birthdate").val())){
				alert("Please enter birthdate or age");
				return false;
			}
			
			if(jQuery("#patientGender").val()=="Any"){
				alert("Please select gender");
				return false;
			}
			
			if(StringUtils.isBlank(jQuery("#opdWard").val())){
				alert("Please select OPD ward");
				return false;
			};
			
			if(!VALIDATORS.validatePatientCategory()){
				return false;
			}
			
			if(!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())){				
				if(!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())){
					alert("Please enter phone number in correct format");
					return false;
				}
			}	
			
			return true;
		}
	};
	
	/**
	 ** VALIDATORS
	 **/
	VALIDATORS = {	
	
		/** VALIDATE PATIENT CATEGORY */
	    validatePatientCategory: function () {
	        if (jQuery("#patCatGeneral").attr('checked') == false 
			 && jQuery("#patCatPoor").attr('checked') == false 
			 && jQuery("#patCatStaff").attr('checked') == false 
			 && jQuery("#patCatGovEmp").attr('checked') == false 
			 && jQuery("#rsby").attr('checked') == false 
			 && jQuery("#bpl").attr('checked') == false) {
	            alert('You didn\'t choose any of the patient categories!');
	            return false;
	        } else {
	            if (jQuery("#rsby").attr('checked')) {
	                if (jQuery("#rsbyNumber").val().length <= 0) {
	                    alert('Please enter RSBY number');
	                    return false;
	                }
	            }
	            if (jQuery("#bpl").attr('checked')) {
	                if (jQuery("#bplNumber").val().length <= 0) {
	                    alert('Please enter BPL number');
	                    return false;
	                }
	            }
	            return true;
	        }
	    },
	
		/** CHECK WHEN BPL CATEGORY IS SELECTED */
		bplCheck: function () {			
	        if (jQuery("#bpl").is(':checked')) {
	            jQuery("#bplField").show();
	            if (jQuery("#patCatGeneral").is(":checked")) jQuery("#patCatGeneral").removeAttr("checked");
	            if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
	            if (jQuery("#patCatGovEmp").is(":checked")) jQuery("#patCatGovEmp").removeAttr("checked");
				if (jQuery("#patCatPoor").is(":checked")) jQuery("#patCatPoor").removeAttr("checked");
	        } else {
	            jQuery("#bplNumber").val("");
	            jQuery("#bplField").hide();
	        }
	    },
		
		/** CHECK WHEN RSBY CATEGORY IS SELECTED */
	    rsbyCheck: function () {
	        if (jQuery("#rsby").is(':checked')) {
	            jQuery("#rsbyField").show();
	            if (jQuery("#patCatGeneral").is(":checked")) jQuery("#patCatGeneral").removeAttr("checked");
	            if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
	            if (jQuery("#patCatGovEmp").is(":checked")) jQuery("#patCatGovEmp").removeAttr("checked");       
				if (jQuery("#patCatPoor").is(":checked")) jQuery("#patCatPoor").removeAttr("checked");				
	        } else {
	            jQuery("#rsbyNumber").val("");
	            jQuery("#rsbyField").hide();
	        }
	    },
		
		/** CHECK WHEN STAFF CATEGORY IS SELECTED */
	    staffCheck: function () {			
	        if (jQuery("#patCatStaff").is(':checked')) {						
	            if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
	            if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
	            if (jQuery("#patCatPoor").is(":checked")) jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatGovEmp").is(":checked")) jQuery("#patCatGovEmp").removeAttr("checked");            
	        }
	    },
		
		/** CHECK WHEN POOR CATEGORY IS SELECTED */
	    poorCheck: function () {
	        if (jQuery("#patCatPoor").is(':checked')) {
	            if (jQuery("#patCatGeneral").is(":checked")) jQuery("#patCatGeneral").removeAttr("checked");
	            if (jQuery("#patCatStaff").is(":checked")) jQuery("#patCatStaff").removeAttr("checked");
	            if (jQuery("#patCatGovEmp").is(":checked")) jQuery("#patCatGovEmp").removeAttr("checked");
				
				if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
	            if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}				
	        }
	    },
		
		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
	    generalCheck: function (obj) {
	        if (jQuery("#patCatGeneral").is(':checked')) {
	            if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
	            if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();
				}
	            if (jQuery("#patCatPoor").is(":checked")) jQuery("#patCatPoor").removeAttr("checked");
	        }
	    },
		
		/** CHECK WHEN GOVERNMENT CATEGORY IS SELECTED */
	    governmentCheck: function () {
	        if (jQuery("#patCatGovEmp").is(':checked')) {
	            if (jQuery("#bpl").is(":checked")) {
					jQuery("#bpl").removeAttr("checked");
					jQuery("#bplNumber").val("");
					jQuery("#bplField").hide();
				}
	            if (jQuery("#rsby").is(":checked")) {
					jQuery("#rsby").removeAttr("checked");
					jQuery("#rsbyNumber").val("");
					jQuery("#rsbyField").hide();					
				}
				if (jQuery("#patCatPoor").is(":checked")) jQuery("#patCatPoor").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) jQuery("#patCatStaff").removeAttr("checked");
	        }
	    },
		
		/*
		 * Check patient gender
		 */
		 genderCheck: function() {
			
			jQuery("#patientRelativeNameSection").empty();			
			if(jQuery("#patientGender").val()=="M"){
				jQuery("#patientRelativeNameSection").html('<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
			} else {
				jQuery("#patientRelativeNameSection").html('<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
			}			
		}
	};
</script>

<h2>Patient Registration</h2>
<div id="patientSearchResult"></div>
<form id="patientRegistrationForm" method="POST">
	<table cellspacing="0">
		<tr>
			<td valign="top" class="cell"><b>Name *</b></td>
			<td class="cell">
				<input id="patientName" type="hidden" name="patient.name"/>
				<div id="searchbox"></div>
				<div id="numberOfFoundPatients"></div>
			</td>
		</tr>		
		<tr>
			<td class="cell"><b>Demographics *</b></td>
			<td class="cell">
				dd/mm/yyyy<br/>
				<table>
					<tr>
						<td>Age</td>
						<td>Birthdate</td>
						<td>Gender</td>
					</tr>
					<tr>
						<td>
							<span id="estimatedAge"/>
						</td>
						<td>
							<input type="hidden" id="calendar"/>
							<input id="birthdate" name="patient.birthdate"/>							
							<img id="calendarButton" src="moduleResources/registration/calendar.gif"/>
							<input id="birthdateEstimated" type="hidden" name="patient.birthdateEstimate" value="true"/>
						</td>
						<td>
							<select id="patientGender" name="patient.gender">
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>		
		<tr>
			<td class="cell"><b>ID Number *</b></td>
			<td class="cell"><input readonly name="patient.identifier" style="border: none;"/></td>
		</tr>
		<tr>
			<td class="cell"><b>Address</b></td>
			<td class="cell">
				<table>
					<tr>
						<td>District:</td>
						<td>
							<select id="districts" name="patient.address.district" onChange="PAGE.changeDistrict();" style="width:200px;">
							</select>
						</td>
					</tr>
					<tr>
						<td>Tehsil:</td>
						<td>
							<select id="tehsils" name="patient.address.tehsil" style="width:200px;">
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Phone number</b></td>
			<td class="cell">
				<input id="patientPhoneNumber" name="person.attribute.16" style="width:200px;"/>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Relative Name *</b></td>
			<td class="cell">
				<div id="patientRelativeNameSection">
					
				</div>
				<input id="patientRelativeName" name="person.attribute.8" style="width:200px;"/>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Visit Information</b></td>
			<td class="cell">				
				<b>Referral Information</b><br/>
				<input type="checkbox" id="referred" onClick="PAGE.toogleReferralInfo(this);" name="patient.referred" value="referred"/> Referred<br/>				
				<div id="referralDiv" style="display:none;">
					<table>
						<tr>
							<td>Referred From</td>
							<td>
								<select id="referralHospitals" name="patient.referred.from" style="width:200px;">
								</select>
							</td>
						</tr>
						<tr>
							<td>Referral Type</td>
							<td>
								<select id="referralReasons" name="patient.referred.reason" style="width:200px;">
								</select>
							</td>
						</tr>
					</table>
				</div>
				<b>OPD Room to Visit: *</b>
				<select id="opdWard" name="patient.opdWard">
				</select>
			</td>
		</tr>
		<tr>
			<td valign="top" class="cell"><b>Patient information</b></td>
			<td class="cell">
				<b>Patient category</b><br/>
				<table cellspacing="10">
					<tr>
						<td>
							<input id="patCatGeneral" type="checkbox" name="person.attribute.14" value="General"/> General 
						</td>
						<td>
							<input id="patCatPoor" type="checkbox" name="person.attribute.14" value="Poor"/> Poor 
						</td>
					</tr>
					<tr>
						<td>
							<input id="patCatStaff" type="checkbox" name="person.attribute.14" value="Staff"/> Staff 
						</td>
						<td>
							<input id="patCatGovEmp" type="checkbox" name="person.attribute.14" value="Government Employee"/> Government Employee 
						</td>
					</tr>
					<tr>
						<td>
							<input id="rsby" type="checkbox" name="person.attribute.14" value="RSBY"/> RSBY 
						</td>
						<td>
							<span id="rsbyField">RSBY Number <input id="rsbyNumber" name="person.attribute.11"/></span>
						</td>
					</tr>
					<tr>
						<td>
							<input id="bpl" type="checkbox" name="person.attribute.14" value="BPL"/> BPL 
						</td>
						<td>
							<span id="bplField">BPL Number <input id="bplNumber" name="person.attribute.10"/></span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<input type="button" value="Save" onclick="PAGE.submit();"/>
<input type="button" value="Reset" onclick="window.location.href=window.location.href"/>