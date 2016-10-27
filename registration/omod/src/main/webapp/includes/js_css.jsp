 <%--
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 *
--%> 
<script type="text/javascript">
	$ = jQuery.noConflict();
	// Get context path
	function getContextPath(){
		return "${pageContext.request.contextPath}";
	}
</script>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/hospitalcore/styles/paging.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/registration/styles/common.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/hospitalcore/styles/jquery.loadmask.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/css/thickbox.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/css/jquery.autocomplete.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/hospitalcore/styles/tablesorter/blue/style.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.metadata.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.validate.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.PrintArea.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.thickbox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/registration/scripts/jquery/jquery.form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.search.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.patientSearch.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.loadmask.min.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.tablesorter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/jquery/jquery.formfilling.js"></script>
<script type="text/javascript"  src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/string-utils.js" ></script>
<script type="text/javascript"  src="${pageContext.request.contextPath}/moduleResources/hospitalcore/scripts/paging.js" ></script> 

<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/registration/styles/form.css" />
<script type="text/javascript"  src="${pageContext.request.contextPath}/moduleResources/registration/scripts/page-actions.js" ></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/registration/scripts/jquery/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/registration/scripts/jquery/jquery.autocomplete.new.js"></script>


<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/registration/scripts/jquery/jquery.ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/registration/scripts/page-utils.js"></script>

<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/registration/scripts/jquery/css/jquery.multiselect.css" />
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/moduleResources/registration/scripts/jquery/css/jquery.autocomplete.css" />