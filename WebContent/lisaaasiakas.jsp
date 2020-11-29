<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Tehtävä 5</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>
			<tr>
				<th colspan="5" class="right"><span id="takaisin">Takaisin listaukseen</span></th>
			</tr>		
			<tr>
				<!-- int asiakas_id, String etunimi, String sukunimi, String puhelin, String sposti) -->
				<th>Asiakas ID: </th>
				<th>Etunimi: </th>
				<th>Sukunimi: </th>
				<th>Puhelin: </th>
				<th>Sähköposti: </th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="asiakas_id" id="asiakas_id"></td>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td>
				<td><input type="submit" id="tallenna" value="Lisää"></td>
			</tr>
		</tbody>
	</table>
</form>
<span id="ilmo"></span>
</body>
<script>
$(document).ready(function() {
	$("#takaisin").click(function() {
		document.location="listaaasiakkaat.jsp";
	});
	$("#tiedot").validate({
		rules: {
			asiakas_id:  {
				required: true,
				number: true,
				minlength: 1		
			},
			etunimi: {
				required: true,
				minlength: 2
			},
			sukunimi: {
				required: true,
				minlength: 2
			},
			puhelin: {
				required: true,
				minlength: 2
			},
			sposti: {
				required: true,
				minlength: 3,
			}
		},
		messages: {
			asiakas_id: {
				required: "Puuttuu",
				number: "Ei ole numero",
				minlength: "Liian lyhyt"
			},
			etunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sukunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			puhelin: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sposti: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			}
		},
		//rules: {
			
/*			asiakas_id: {
				required: true,
				number: true,
				minlength: 1
			},
			etunimi: {
				required: true,
				minlength: 2
			},
			sukunimi: {
				required: true,
				minlength: 2
			},
			puhelin: {
				required: true,
				minlenght: 2
			},
			sposti: {
				required: true,
				minlength: 4,
			}
		},
		messages: {
			asiakas_id: {
				required: "Puuttuu",
				minlength: "Liian lyhyt",
				number: "Ei ole numero"
			},
			etunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sukunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			puhelin: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sposti: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			}
		}, */
		// lopuksi kutsutaan lisaaTiedot() functiota
		submitHandler: function(form) {	
			lisaaTiedot();
		}
	});
});
// funktio tietojen lisäämistä varten 
function lisaaTiedot() {
	// muuttaa lomakkeen tiedot JSON objektiksi ja sitten JSON stringiksi
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray());
	$.ajax({
		url:"asiakkaat", 
		// Välitetään asiakkaat backendiin
		data:formJsonStr, 
		type:"POST", 
		dataType:"json", 
		success:function(result) { 
		//result on joko {"response:1"} tai {"response:0"}       
			if (result.response==1) {
	      		$("#ilmo").html("Asiakas lisätty onnistuneesti.");
	      	} else if (result.response==0) {			
	    	  // int asiakas_id, String etunimi, String sukunimi, String puhelin, String sposti) -->
	      		$("#ilmo").html("Asiakkaan lisääminen epäonnistui.");
	      		$("#asiakas_id", "#etunimi", "#sukunimi", "#puhelin", "#sposti").val("");
			}
		}
	});	
}

</script>
</html>