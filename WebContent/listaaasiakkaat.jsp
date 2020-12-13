<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakaslistaus</title>
</head>
<body onkeydown="tutkiKey(event)">

<table id="listaus">
	<thead>
		<tr>
			<th colspan="6" id="ilmo"></th>
		</tr>
		<tr>
			<th colspan="6" class="right"><a href="lisaaasiakas.jsp">Lisää asiakas</a></th>
		</tr>	
		<tr>
			<th colspan="3" class="right">Hakusana: </th>
			<th colspan="2"><input type="text" id="hakusana"></th>
			<th><input type="button" value="hae" id="hakunappi" onclick="haeAsiakkat()"></th>
		</tr>			
		<tr>
			<th>Asiakas ID</th>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>Sähköposti</th>
			<th></th>	
		</tr>
	</thead>
	<tbody id="tbody">
	</tbody>
</table>
<script>
haeAsiakkaat();
document.getElementById("hakusana").focus();

function haeAsiakkaat() {
	document.getElementById("tbody").innerHTML = "";
	fetch(
			"asiakkaat/" + document.getElementById("hakusana").value,
			{method: 'GET'}
	).then(function(response) {
	  return response.json()
	}).then(function(responseJson) {
		console.log(responseJson);
		var asiakkaat = responseJson.asiakkaat;
		var html="";
		for (var i=0; i < asiakkaat.length; i++) {
			html += "<tr>";
			html += "<td>" + asiakkaat[i].asiakas_id + "</td>";
			html += "<td>" + asiakkaat[i].etunimi + "</td>";
			html += "<td>" + asiakkaat[i].sukunimi + "</td>";
			html += "<td>" + asiakkaat[i].puhelin + "</td>";
			html += "<td>" + asiakkaat[i].sposti + "</td>";
			html += "<td><a href='muutaasiakas.jsp?asiakasid="+asiakkaat[i].asiakas_id+"'>Muokkaa</a>&nbsp;";
			html += "<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
		}
		document.getElementById("tbody").innerHTML = html;
	});
}

function poista(asiakasid){	
	if (confirm ("Poista asiakas "+ asiakasid +"?")) {
		fetch("asiakkaat/" + asiakasid,{
		      method: 'DELETE'		      	      
		    })
		.then(function (response) {
			return response.json()
		})
		.then(function (responseJson) {	
			var vastaus = responseJson.response;		
			if( vastaus==0 ) {
				document.getElementById("ilmo").innerHTML= "Asiakkaan poisto epäonnistui";
		    } else if( vastaus==1) {	        	
		       	document.getElementById("ilmo").innerHTML="Asiakkaan " + asiakasid +" poisto onnistui.";
				haeAsiakkaat();        	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		});
	}

}
</script>
</body>
</html>