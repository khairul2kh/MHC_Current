<style>
.cell {
	border-top: 1px solid lightgrey;
	padding: 20px;
}
td.border {
	border-width: 1px;
	border-right: 0px;
	border-bottom: 1px;
	border-color: lightgrey;
	border-style: solid;
}

td.bottom{
border-width: 1px;
border-bottom: 1px;
border-right: 0px;
border-top: 0px;
border-left: 0px;
border-color: lightgrey;
border-style: solid;
}
</style>
<script type="text/javascript">
	jQuery(document).ready(
			function() {

				// Fill data into address dropdowns
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#tehsils", {
					data : MODEL.tehsils[0].split(',')
				});

				// Set value for patient information
				formValues = "patient.name==" + MODEL.patientName + "||";
				formValues += "patient.birthdate==" + MODEL.patientBirthdate
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender + "||";
				formValues += "patient.identifier==" + MODEL.patientIdentifier
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender[0]
						+ "||";
				formValues += "person.attribute.8=="
						+ MODEL.patientAttributes[8] + "||";
				if (!StringUtils.isBlank(MODEL.patientAttributes[16])) {
					formValues += "person.attribute.16=="
							+ MODEL.patientAttributes[16] + "||";
				}
								
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (!StringUtils.isBlank(MODEL.patientAttributes[18])) {
					formValues += "person.attribute.18=="
							+ MODEL.patientAttributes[18] + "||";
				}
				
				// Set value for address 
				// 26-6-2012 Marta - to store address in the openmrs patient_address table #289
				addressParts = MODEL.patientAddress.split(',');
				formValues += "patient.address.postalAddress==" + StringUtils.trim(addressParts[0]) + "||";
				jQuery("#districts").val(StringUtils.trim(addressParts[2]));
				PAGE.changeDistrict();
				jQuery("#tehsils").val(StringUtils.trim(addressParts[1]));

				jQuery("#patientRegistrationForm").fillForm(formValues);
				PAGE.checkBirthDate();
				VALIDATORS.genderCheck();
				jQuery("#patientRegistrationForm").fillForm(
						"person.attribute.15==" + MODEL.patientAttributes[15]
								+ "||");


				/* Set Value For Attributes */
				// Patient Category
				attributes = MODEL.patientAttributes[14];
				jQuery.each(attributes.split(","), function(index, value) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.14==" + value + "||");
				});

				// RSBY Number
				// 01/05/2012 - Marta: Added verification to avoid show old numbers. Bug #185 
				if (!StringUtils.isBlank(MODEL.patientAttributes[11])
						&& jQuery("#rsby").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.11=="
									+ MODEL.patientAttributes[11] + "||");
				} else {
					jQuery("#rsbyField").hide();
				}

				// BPL Number
				// 01/05/2012 - Marta: Added verification to avoid show old numbers. Bug #185 
				if (!StringUtils.isBlank(MODEL.patientAttributes[10])
						&& jQuery("#bpl").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.10=="
									+ MODEL.patientAttributes[10] + "||");
				} else {
					jQuery("#bplField").hide();
				}
				

				// 01/05/2012: Marta, adding ppo number. Feature #181
				// 01/05/2012 - Marta: Added verification to avoid show old numbers. Bug #185 
				if (!StringUtils.isBlank(MODEL.patientAttributes[17])
						&& jQuery("#patPensioner").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.17=="
									+ MODEL.patientAttributes[17] + "||");
				} else {
					jQuery("#ppoField").hide();
				}
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				// Free Field
				if (!StringUtils.isBlank(MODEL.patientAttributes[18])
						&& jQuery("#patCatOthersFree").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.18=="
									+ MODEL.patientAttributes[18] + "||");
				} else {
					jQuery("#freeField").hide();
				}
				

				// binding
				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery('#birthdate').change(PAGE.checkBirthDate);

				jQuery("#bpl").click(function() {
					VALIDATORS.bplCheck();
				});
				jQuery("#rsby").click(function() {
					VALIDATORS.rsbyCheck();
				});
				jQuery("#patCatStaff").click(function() {
					VALIDATORS.staffCheck();
				});
/* 				jQuery("#patCatPoor").click(function() {
					VALIDATORS.poorCheck();
				}); */
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				jQuery("#patPunjabGovernmentEmployee").click(function() {
					VALIDATORS.punjabGovernmentEmployeeCheck();
				});
				jQuery("#patExServicemen").click(function() {
					VALIDATORS.exServicemenCheck();
				});
				jQuery("#patPensioner").click(function() {
					VALIDATORS.pensionerCheck();
				});
				// 30/04/2012: Marta added for Punjab new categories validation - Bug #177
				jQuery("#patCatAntenatal").click(function() {
					VALIDATORS.antenatalCheck();
				});
				jQuery("#patCatTB").click(function() {
					VALIDATORS.TBCheck();
				});
				jQuery("#patCatSchool").click(function() {
					VALIDATORS.schoolCheck();
				});
				jQuery("#patCatCancer").click(function() {
					VALIDATORS.cancerCheck();
				});
				jQuery("#patCatOthersFree").click(function() {
					VALIDATORS.othersFreeCheck();
				});
				jQuery("#calendarButton").click(function() {
					jQuery("#calendar").datepicker("show");
				});
				jQuery("#calendar").change(function() {
					jQuery("#birthdate").val(jQuery(this).val());
					PAGE.checkBirthDate();
				});
				jQuery("#birthdate").click(function() {
					jQuery("#birthdate").select();
				});
				jQuery("#patCatSeniorCitizen").click(function() {
					VALIDATORS.seniorCitizenCheck();
				});
				jQuery("#patientGender").change(function() {
					VALIDATORS.genderCheck();
				});

			});

	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit : function() {

			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery("#patientName",
					jQuery("#patientRegistrationForm")).val());
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
					fullNameInCapital);
			relativeNameInCaptital = StringUtils.capitalize(jQuery(
					"#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

			// Validate and submit
			if (this.validateRegisterForm()) {
				jQuery("#patientRegistrationForm")
						.mask(
								"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
				jQuery("#patientRegistrationForm").ajaxSubmit(
						{
							success : function(responseText, statusText, xhr) {
								json = jQuery.parseJSON(responseText);
								if (json.status == "success") {
									window.location.href = openmrsContextPath
											+ "/findPatient.htm";
								} else {
									alert(json.message);
								}
								jQuery("#patientRegistrationForm").unmask();
							}
						});
			}
		},

		/** VALIDATE BIRTHDATE */
		checkBirthDate : function() {
			jQuery
					.ajax({
						type : "GET",
						url : getContextPath()
								+ "/module/registration/ajax/processPatientBirthDate.htm",
						data : ({
							birthdate : $("#birthdate").val()
						}),
						dataType : "json",
						success : function(json) {

							if (json.error == undefined) {
								if (json.estimated == "true") {
									jQuery("#birthdateEstimated").val("true")
								} else {
									jQuery("#birthdateEstimated").val("false");
								}

								jQuery("#estimatedAge").html(json.age);
								jQuery("#birthdate").val(json.birthdate);
							} else {
								alert(json.error);
								// 28/04/12: Added by Marta to avoid commiting wrong birthdates - Bug #163
								jQuery("#birthdate").val("");

							}
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
		fillOptions : function(divId, option) {
			jQuery(divId).empty();
			if (option.delimiter == undefined) {
				if (option.index == undefined) {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + value + "'>" + value
											+ "</option>");
						}
					});
				} else {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + option.index[index] + "'>"
											+ value + "</option>");
						}
					});
				}
			} else {

				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value) {

					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if (optionLabel != undefined) {
						if (optionLabel.length > 0) {
							jQuery(divId).append(
									"<option value='" + optionValue + "'>"
											+ optionLabel + "</option>");
						}
					}

				});
			}
		},

		/** CHANGE DISTRICT */
		changeDistrict : function() {

			// get the list of tehsils
			tehsilList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value) {
				if (value == selectedDistrict) {
					tehsilList = MODEL.tehsils[index];
				}
			});

			// fill tehsils into tehsil dropdown
			this.fillOptions("#tehsils", {
				data : tehsilList.split(",")
			});
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {

			if (StringUtils.isBlank(jQuery("#patientName").val())) {
				alert("Please enter patient name");
				return false;
			} // 30/04/2012: Marta, Added pattern checking to avoid special characters in patient name - Bug #157
			else {
				value = jQuery("#patientName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter patient name/identifier in correct format.");
						return false;
					}
				}
			}

			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter relative name");
				return false;
			} else {
				if (jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length == 0) {
					alert("Please select relative name type");
					return false;
				}
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter birthdate or age");
				return false;
			}

			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender");
				return false;
			}

			if (!VALIDATORS.validatePatientCategory()) {
				return false;
			}

			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
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
		validatePatientCategory : function() {
			if (jQuery("#patCatGeneral").attr('checked') == false
					/* && jQuery("#patCatPoor").attr('checked') == false */
					&& jQuery("#patCatStaff").attr('checked') == false
					&& jQuery("#rsby").attr('checked') == false
					&& jQuery("#bpl").attr('checked') == false
					// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
					&& jQuery("#patPensioner").attr('checked') == false
					&& jQuery("#patPunjabGovernmentEmployee").attr('checked') == false
					&& jQuery("#patExServicemen").attr('checked') == false
					&& jQuery("#patCatAntenatal").attr('checked') == false
					&& jQuery("#patCatTB").attr('checked') == false
					&& jQuery("#patCatSchool").attr('checked') == false
					&& jQuery("#patCatCancer").attr('checked') == false
					&& jQuery("#patCatOthersFree").attr('checked') == false) {
				alert('You didn\'t choose any of the patient category!');
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
				// 01/05/2012: Marta, adding ppo number. Feature #181
				if (jQuery("#patPensioner").attr('checked')) {
					if (jQuery("#ppoNumber").val().length <= 0) {
						alert('Please enter PPO number');
						return false;
					}
					
				}
				
				return true;
			}
		},

		/** CHECK WHEN BPL CATEGORY IS SELECTED */
		bplCheck : function() {
			if (jQuery("#bpl").is(':checked')) {
				// 01/05/2012 - Marta: To load current number. Bug #185
				if (!StringUtils.isBlank(MODEL.patientAttributes[10])) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.10=="
									+ MODEL.patientAttributes[10] + "||");
				}
				jQuery("#bplField").show();
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
				
			} else {
				jQuery("#bplNumber").val("");
				jQuery("#bplField").hide();
			}
		},

		/** CHECK WHEN RSBY CATEGORY IS SELECTED */
		rsbyCheck : function() {
			if (jQuery("#rsby").is(':checked')) {
				// 01/05/2012 - Marta: To load current number. Bug #185
				if (!StringUtils.isBlank(MODEL.patientAttributes[11])) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.11=="
									+ MODEL.patientAttributes[11] + "||");
				}
				jQuery("#rsbyField").show();
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked")) {
					jQuery("#patCatStaff").removeAttr("checked");
				}
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			} else {
				jQuery("#rsbyNumber").val("");
				jQuery("#rsbyField").hide();
			}
		},

		/** CHECK WHEN STAFF CATEGORY IS SELECTED */
		staffCheck : function() {
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/** CHECK WHEN POOR CATEGORY IS SELECTED */
		poorCheck : function() {
			if (jQuery("#patCatPoor").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
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
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patCatSeniorCitizen").is(":checked"))
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
		generalCheck : function(obj) {
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/** CHECK WHEN PUNJAB GOVERNMENT EMPLOYEE CATEGORY IS SELECTED */
		punjabGovernmentEmployeeCheck : function() {
			if (jQuery("#patPunjabGovernmentEmployee").is(':checked')) {

				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
			}
		},

		/** CHECK WHEN EX SERVICE MEN CATEGORY IS SELECTED */
		exServicemenCheck : function() {
			if (jQuery("#patExServicemen").is(':checked')) {

				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
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
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/** CHECK WHEN PENSIONER CATEGORY IS SELECTED */
		pensionerCheck : function() {
			if (jQuery("#patPensioner").is(':checked')) {
				// 01/05/2012 - Marta: To load current number. Bug #185
				if (!StringUtils.isBlank(MODEL.patientAttributes[17])) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.17=="
									+ MODEL.patientAttributes[17] + "||");
				}
				// 01/05/2012: Marta, adding ppo number. Feature #181
				jQuery("#ppoField").show();
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				// 28/04/2012: Marta fixed for Punjab validation - Bug #159
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
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
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				// 30/04/2012: Marta fixed for Punjab new Categories validation - Bug #177
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}// 01/05/2012: Marta, adding ppo number. Feature #181
			else {
				jQuery("#ppoNumber").val("");
				jQuery("#ppoField").hide();
			}
		},

		/** CHECK WHEN SENIOR CITIZEN CATEGORY IS SELECTED */
		seniorCitizenCheck : function() {
			if (jQuery("#patCatSeniorCitizen").is(':checked')) {
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
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (!VALIDATORS.checkPatientAgeForSeniorCitizen()) {
					jQuery("#patCatSeniorCitizen").removeAttr("checked");
				}
				;
			}
		},

		/* CHECK WHEN ANTENATAL CATEGORY IS SELECTED */
		// 30/04/2012: Marta added for Punjab new categories validation - Bug #177
		antenatalCheck : function() {
			if (jQuery("#patCatAntenatal").is(':checked')) {
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/* CHECK WHEN TB CATEGORY IS SELECTED */
		// 30/04/2012: Marta added for Punjab new categories validation - Bug #177
		TBCheck : function() {
			if (jQuery("#patCatTB").is(':checked')) {
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/* CHECK WHEN SCHOOL CATEGORY IS SELECTED */
		// 30/04/2012: Marta added for Punjab new categories validation - Bug #177
		schoolCheck : function() {
			if (jQuery("#patCatSchool").is(':checked')) {
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/* CHECK WHEN CANCER CATEGORY IS SELECTED */
		// 30/04/2012: Marta added for Punjab new categories validation - Bug #177
		cancerCheck : function() {
			if (jQuery("#patCatCancer").is(':checked')) {
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
				if (jQuery("#patCatOthersFree").is(":checked")){
					jQuery("#patCatOthersFree").removeAttr("checked");
					jQuery("#freeCategory").val("");
					jQuery("#freeField").hide();
				}
				
			}
		},

		/* CHECK WHEN OTHER CATEGORY IS SELECTED */
		// 30/04/2012: Marta added for Punjab new categories validation - Bug #177
		othersFreeCheck : function() {
			if (jQuery("#patCatOthersFree").is(':checked')) {	
				jQuery("#freeField").show();
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
/* 				if (jQuery("#patCatPoor").is(":checked"))
					jQuery("#patCatPoor").removeAttr("checked"); */
				if (jQuery("#patExServicemen").is(":checked"))
					jQuery("#patExServicemen").removeAttr("checked");
				if (jQuery("#patPensioner").is(":checked")) {
					jQuery("#patPensioner").removeAttr("checked");
					// 01/05/2012: Marta, adding ppo number. Feature #181
					jQuery("#ppoNumber").val("");
					jQuery("#ppoField").hide();
				}
				if (jQuery("#patCatGeneral").is(":checked"))
					jQuery("#patCatGeneral").removeAttr("checked");
				if (jQuery("#patPunjabGovernmentEmployee").is(":checked"))
					jQuery("#patPunjabGovernmentEmployee")
							.removeAttr("checked");
				if (jQuery("#patCatStaff").is(":checked"))
					jQuery("#patCatStaff").removeAttr("checked");
				if (jQuery("#patCatAntenatal").is(":checked"))
					jQuery("#patCatAntenatal").removeAttr("checked");
				if (jQuery("#patCatTB").is(":checked"))
					jQuery("#patCatTB").removeAttr("checked");
				if (jQuery("#patCatSchool").is(":checked"))
					jQuery("#patCatSchool").removeAttr("checked");
				if (jQuery("#patCatCancer").is(":checked"))
					jQuery("#patCatCancer").removeAttr("checked");
				
			}else {
				jQuery("#freeCategory").val("");
				jQuery("#freeField").hide();
			}
		},

		/*
		 * Check patient age for senior citizen
		 */
		checkPatientAgeForSeniorCitizen : function() {
			// check whether patient age is more than 60
			estAge = jQuery("#estimatedAge").html();
			var digitPattern = /[0-9]+/;
			var age = digitPattern.exec(estAge);
			if (age < 60) {
				if (jQuery("#patCatSeniorCitizen").is(':checked')) {
					alert("Senior citizen category is only for patient over 60 years old!");
					return false;
				}
			}
			return true;
		},

		/*
		 * Check patient gender
		 */
		genderCheck : function() {

			jQuery("#patientRelativeNameSection").empty();
			if (jQuery("#patientGender").val() == "M") {
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
			} else  if(jQuery("#patientGender").val() == "F"){
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
			}else if(jQuery("#patientGender").val() == "O"){
				jQuery("#patientRelativeNameSection")
				.html(
				'<input hidden type="radio" name="person.attribute.15" value="Relative of" checked="checked"/>');
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
			<td class="cell"><input id="patientName" name="patient.name"
				style="width: 300px;" /></td>

				<!--  12/06/2012: Kesavulu: added Screen mock up for registration module[Punjab]- New Requirement #251 -->
				<td class="cell"><b>ID Number *  &nbsp;&nbsp; <input name="patient.identifier" style="border: none;" /></b></td>	
		</tr>
		<tr>
			<td class="cell"><b>Demographics *</b></td>
			<td class="cell">dd/mm/yyyy<br />
				<table>
					<tr>
						<td>Age</td>
						<td>Birthdate</td>
						<td>Gender</td>
					</tr>
					<tr>
						<td><span id="estimatedAge" /></td>
						<td><input type="hidden" id="calendar" /> <input
							id="birthdate" name="patient.birthdate" /> <img
							id="calendarButton"
							src="../../moduleResources/registration/calendar.gif" /> <input
							id="birthdateEstimated" type="hidden"
							name="patient.birthdateEstimate" value="true" /></td>
						<td><select id="patientGender" name="patient.gender">
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
								<option value="O">Others</option>
						</select></td>
					</tr>
				</table>
			</td>		
		<!--  12/06/2012: Kesavulu: added Screen mock up for registration module[Punjab]- New Requirement #251 -->
		<td rowspan="2" class="border">
					<!-- <b>&nbsp;&nbsp;Patient information</b> <br /> -->
					<b>&nbsp;&nbsp;Patient category</b><br />
					<table cellspacing="10" >
					<tr>
						<td><input id="patCatGeneral" type="checkbox"
							name="person.attribute.14" value="General" /> General</td>
						<!-- <td><input id="patCatPoor" type="checkbox"
							name="person.attribute.14" value="Poor" /> Poor</td>  -->
							<!-- <td><input id="patCatStaff" type="checkbox"
							name="person.attribute.14" value="Staff" /> Staff</td> -->
						<td><input id="patPunjabGovernmentEmployee" type="checkbox"
							name="person.attribute.14" value="Punjab Government Employee" />
							Punjab Government Employee</td>
							<td><input id="rsby" type="checkbox"
							name="person.attribute.14" value="RSBY" /> RSBY</td>
						<td><span id="rsbyField">RSBY Number <input
								id="rsbyNumber" name="person.attribute.11" />
						</span></td>
					</tr>					
					<tr>
					 	<td></td>
					<!-- 30/04/12: Marta, Added categories Antenatal, TB, School, Cancer, Others. - Bug #177 -->
						<td><input id="patCatAntenatal" type="checkbox"
							name="person.attribute.14" value="Antenatal" /> Antenatal
							Patient</td>
						<td><input id="bpl" type="checkbox"
							name="person.attribute.14" value="BPL" /> BPL</td>
						<td><span id="bplField">BPL Number <input
								id="bplNumber" name="person.attribute.10" />
						</span></td>
					</tr>
					<tr>
					<td></td>
					<td><input id="patCatSchool" type="checkbox"
							name="person.attribute.14" value="School" /> School Health
							Programme</td>
						<td><input id="patPensioner" type="checkbox"
							name="person.attribute.14" value="Pensioner" /> Pensioner</td>
						<!-- 01/05/2012: Marta, adding a field for ppo number. Feature #181 -->
						<td><span id="ppoField">PPO Number<input
								id="ppoNumber" name="person.attribute.17" />
						</span></td>
					</tr>					
					<tr>
					<td></td>
						<td><input id="patExServicemen" type="checkbox"
							name="person.attribute.14" value="Ex Servicemen" /> Ex
							Servicemen</td>
						<td><input id="patCatOthersFree" type="checkbox"
							name="person.attribute.14" value="Other Free" /> Other Free</td>
						<!-- 07/06/2012 Kesavulu: #245 [PUNJAB] Text box in 'other free' category -->
						<td><span id="freeField"> <input id="freeCategory"
								name="person.attribute.18" /></span></td>
					</tr>
					<tr>
						<td></td>
						<td><input id="patCatTB" type="checkbox"
							name="person.attribute.14" value="TB Patient" /> TB Patient</td>
					</tr>
					<tr>
						<td></td>
						<td><input id="patCatCancer" type="checkbox"
							name="person.attribute.14" value="Cancer" /> Cancer Patient</td>
					</tr>
				</table>
			</td>

		</tr>
		<tr>
			<td class="cell"><b>Address</b></td>
			<td class="cell">
				<table>
					<tr>
						<!--  01/05/2012: Marta, adding a field for address. Feature #183   -->
						<td>Postal Address:</td>
						<td> <!-- <input id="patientPostalAddress" name="person.attribute.18" style="width: 300px;" />  -->
						<!-- 26-6-2012 Marta - to store address in the openmrs patient_address table #289-->
							<input id="patientPostalAddress" name="patient.address.postalAddress" style="width: 300px;" />
						</td>
					</tr>
					<tr>
						<td>District:</td>
						<td><select id="districts" name="patient.address.district"
							onChange="PAGE.changeDistrict();" style="width: 200px;">
						</select></td>
					</tr>
					<tr>
						<td>Tehsil:</td>
						<td><select id="tehsils" name="patient.address.tehsil"
							style="width: 200px;">
						</select></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Phone number</b></td>
			<td class="cell"><input id="patientPhoneNumber"
				name="person.attribute.16" style="width: 200px;" /></td>
				<td class="bottom"></td>
		</tr>
		<tr>
			<td class="cell"><b>Relative Name *</b></td>
			<td class="cell">
				<div id="patientRelativeNameSection"></div> <input
				id="patientRelativeName" name="person.attribute.8"
				style="width: 200px;" />
			</td>
		</tr>
		<!--  12/06/2012: Kesavulu: added Screen mock up for registration module[Punjab]- New Requirement #251 -->
		<tr>
			<td colspan="3" style="padding: 0em 30em 0em 30em;">
			<input type="button" value="Save" onclick="PAGE.submit();" />
			<input type="button" value="Reset"
	onclick="window.location.href=window.location.href" /></td>
			</tr>
	</table>
</form>