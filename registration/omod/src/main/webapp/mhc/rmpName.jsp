<%-- 
    Document   : rmpName
    Created on : May 2, 2016, 1:08:41 PM
    Author     : Khairul
--%>

<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/headerMinimal.jsp"%>
<%@ include file="../includes/js_css.jsp" %>
<br><br>
<script>
    $(document).ready(function() {
        jQuery("#rmpName").val("");

        $("input").focus(function() {
            $(this).css("background-color", "#0101DF");
            $(this).css("font-size", "16px");
            $(this).css("color", "#fff");
        });
        $("input").blur(function() {
            $(this).css("background-color", "#F7F778");
            $(this).css("color", "#000");
        });
    });

    function validate() {
        var dName = document.getElementById("rmpName").value;
        if (dName == null || dName == "")
        {
            alert("Please Enter RMP Name!!");
            return false;
        }
        setTimeout(function() {
            window.location.reload();
        }, 10)
    }
</script>
<div class="div1">
    <form method="post" class="abc" id="refRmp" action="refRmp.htm" onsubmit="return validate()">
        <h1>Add / Edit RMP Name</h1>
        <br>
        <table width="70%">
            <tr style="background:#CCCCCC;">
                <td ><b>&nbsp; RMP Name :</b></td>
                <td ><input type="text" id="rmpName" name="rmpName" placeholder="Please Enter RMP Name" autofocus/></td>
                <td><input class="button" type="submit" value="Add"   class="button"/></td>
            </tr>
        </table>
        <br>

        <table cellpadding="5" cellspacing="0" width="100%" id="queueList">
            <tr align="center" >
                <th>RMP ID</th>
                <th>RMP Name</th>
            </tr>
            <c:if test="${not empty rmp}">
                <c:forEach items="${rmp}" var="rmp" varStatus="varStatus">
                    <tr  align="center" class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow" } ' >

                        <td>${rmp.id}</td>
                        <td>${rmp.name}</td>
                        <td>        
                            <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all"  value="Edit" onclick="myFunction('${rmp.id}')"/> 
                            <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all"  value="Remove" onclick="ADMISSION.removeOrNoBed('${pAdmission.id}', '1');"/>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
        </table>
        <br>
        <input class="ui-button ui-widget ui-state-default ui-corner-all" type="button" value="Close" onclick="self.close()">
        <br>			
    </form>
    <script>
        function myFunction(id) {
            var url = "editRmp.htm?id=" + id + "&KeepThis=true&TB_iframe=true&width=800&height=500";
            tb_show("Edit RMP Name", url);
        }
    </script>

</div>
<style>
    .div1{
        width: 80%;
        min-height: 600px;
        position:absolute;
        left:300px;
        top:50px;
    }
    .abc { 
        max-width: 80%;
        min-height: 600px;
        padding: 20px 20px 20px 20px;
        font: 16px Arial, Tahoma, Helvetica, sans-serif;
        color: #000000;
        line-height: 180%;
        -moz-box-shadow: 0px 0px 0px 2px #9fb4f2;
        -webkit-box-shadow: 0px 0px 0px 2px #9fb4f2;
        background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #D2E9FF), color-stop(1, #FFFFFF));
        background:-moz-linear-gradient(top, #D2E9FF 5%, #FFFFFF 100%);
        background:-webkit-linear-gradient(top, #D2E9FF 5%, #FFFFFF 100%);
        background:-o-linear-gradient(top, #D2E9FF 5%, #FFFFFF 100%);
        background:-ms-linear-gradient(top, #D2E9FF 5%, #FFFFFF 100%);
        background:linear-gradient(to bottom, #D2E9FF 5%, #FFFFFF 100%);
        filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#476e9e',GradientType=0);
        background-color:#ffffff;
        -moz-border-radius:10px;
        -webkit-border-radius:10px;
        border-radius:10px;
        border:1px solid #4e6096;
        box-shadow: 10px 10px 5px #888888;
        cursor:pointer;
        color:#000000;
        font-family:arial;
        font-size:16px;
        padding:10px 30px;
        text-decoration:none;
    }
    .button{
        padding: 10px 30px 10px 30px;
        background: #47D147;
        border: none;
        color: #fff;
        box-shadow: 1px 1px 1px #4C6E91;
        -webkit-box-shadow: 1px 1px 1px #4C6E91;
        -moz-box-shadow: 1px 1px 1px #4C6E91;
        text-shadow: 3px 1px 5px #ffffff;
        font-size:18px;
        font-weight:bold;
        text-decoration:none;
    } 
    .button:hover{
        background: #fff;
        color:#47D147;
        text-shadow: 3px 1px 5px 4px #F7FE2E;
        box-shadow: 5px 3px 5px 3px #888;
        font-weight:bold;
    }
    .abc input[type="text"], .kha-uds input[type="email"] {
        border-radius:10px 2px 10px 2px;
        border: 1px solid #AAA;
        color: #black;
        font-size: inherit;
        margin: 10px;
        overflow: hidden;
        padding: 5px 10px;
        text-overflow: ellipsis;
        white-space: nowrap;
        width: 80%;
    }
</style>