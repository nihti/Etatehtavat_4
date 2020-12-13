<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Tehtävä 5</title>
</head>
<body onkeydown="tutkiKey(event)">

<form id="tiedot">
	<table>
		<thead>
			<tr>
				<th colspan="5" class="right"><a href="listaaasiakkaat.jsp">Takaisin listaukseen</a></th>
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
				<td><input type="button" id="tallenna" value="Lisää" onclick="lisaaAsiakas()"></td>
			</tr>
		</tbody>
	</table>
</form>

<span id="ilmo"></span>
</body>
<script>

document.getElementById("asiakas_id").focus();

function lisaaAsiakas() {
	var ilmo="";
	
	if(document.getElementById("asiakas_id").value*1!=document.getElementById("asiakas_id").value){
		ilmo="Ei ole numero!";		
	}else if(document.getElementById("etunimi").value.length<2){
		ilmo="Liian lyhyt!";		
	}else if(document.getElementById("sukunimi").value.length<2){
		ilmo="Liian lyhyt";		
	}
	
	if(ilmo!=""){
		document.getElementById("ilmo").innerHTML=ilmo;
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
		return;
	}
	
	document.getElementById("asiakas_id").value=siivoa(document.getElementById("asiakas_id").value);
	document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
	document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
	document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
	document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
	
	var formJsonStr = formDataJsonStr(document.getElementById("tiedot")); 

	fetch("asiakkaat",{
	      method: 'POST',
	      body:formJsonStr
	    })
	.then(function (response) {	
		return response.json()
	})
	.then(function (responseJson) {
		var vastaus = responseJson.response;
		
		if (vastaus==0) {
			document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen epäonnistui";
	  	} else if (vastaus==1) {	        	
	  		document.getElementById("ilmo").innerHTML= "Asiakkaan lisääminen onnistui";		      	
		}
		setTimeout(function() { 
			document.getElementById("ilmo").innerHTML=""; 
		}, 5000);
	});

	document.getElementById("tiedot").reset();
}

</script>
</html>