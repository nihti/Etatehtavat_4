<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakaslistaus</title>
</head>
<body>
<table id="listaus">
	<thead>
		<tr>
			<th colspan="6" class="right"><span id="lisaaasiakas">Lisää asiakas</span></th>
		</tr>	
		<tr>
			<th colspan="3" class="right">Hakusana: </th>
			<th colspan="2"><input type="text" id="hakusana"></th>
			<th><input type="button" value="hae" id="hakunappi"></th>
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
	<tbody>
	</tbody>
</table>
<script>
$(document).ready(function(){
	/*
	$.ajax({ 
		// WebServletin osoite
		url:"asiakkaat", 
		type:"GET", 
		dataType:"json", 
		success: function(result) {
			console.log(result);
		}
	});
	*/
	// lisää asiakas
	$("#lisaaasiakas").click(function() {
		document.location="lisaaasiakas.jsp";
	});
	// klikki 
	haeAsiakkaat();
	$("#hakunappi").click(function() {
		console.log($("#hakusana").val());
		haeAsiakkaat();
	});
	// enter
	$(document.body).on("keydown", function(event) {
		if (event.which==13) {
			haeAsiakkaat();
		}
	});
	// kursori focus
	$("#hakusana").focus();
});	

function haeAsiakkaat() {
	$("#listaus tbody").empty();
	$.ajax({
		// Webservletin osoite
		url:"asiakkaat/"+$("#hakusana").val(), 
		type:"GET", 
		dataType:"json", 
		success:function(result){//Funktio palauttaa tiedot json-objektina		
		$.each(result.asiakkaat, function(i, field){  
	    	var htmlStr;
	    	htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
	    	htmlStr+="<td>"+field.asiakas_id+"</td>";
	    	htmlStr+="<td>"+field.etunimi+"</td>";
	    	htmlStr+="<td>"+field.sukunimi+"</td>";
	    	htmlStr+="<td>"+field.puhelin+"</td>";
	    	htmlStr+="<td>"+field.sposti+"</td>";
	    	htmlStr+="<td><span class='poista' onclick=poista('"+field.asiakas_id+"')>Poista</span></td>";
	    	htmlStr+="</tr>";
	    	$("#listaus tbody").append(htmlStr);
	    });	
	}});
}

function poista(asiakas_id){
	if(confirm("Poista asiakas " + asiakas_id +"?")){
		$.ajax({
			url:"asiakkaat/"+asiakas_id, 
			type:"DELETE", 
			dataType:"json", 
			success:function(result) { 
				//result on joko {"response:1"} tai {"response:0"}
	        	if (result.response==0) {
	        		$("#ilmo").html("Asiakkaan poistaminen epäonnistui.");
	        	} else if (result.response==1) {
	        		$("#rivi_"+asiakas_id).css("background-color", "red"); 
	        		//Värjätään poistetun asiakkaan rivi
	        		alert("Asiakkaan " + asiakas_id +" poisto onnistui.");
					haeAsiakkaat();        	
				}
	        }
		});
	}
}
</script>
</body>
</html>