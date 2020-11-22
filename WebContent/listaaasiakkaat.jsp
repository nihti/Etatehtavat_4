<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Insert title here</title>
<style>
	thead {
		background: lightgreen;
	}
	tbody tr:nth-child(even) {
		background: lightgrey;
	}
	.right {
		text-align: right;
	}
</style>
</head>
<body>
<table id="listaus">
	<thead>	
		<tr>
			<th colspan="2" class="right">Hakusana: </th>
			<th colspan="2"><input type="text" id="hakusana"></th>
			<th><input type="button" value="hae" id="hakunappi"></th>
		</tr>			
		<tr>
			<th>Asiakas ID</th>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>S�hk�posti</th>							
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
	    	htmlStr+="<tr>";
	    	htmlStr+="<td>"+field.asiakas_id+"</td>";
	    	htmlStr+="<td>"+field.etunimi+"</td>";
	    	htmlStr+="<td>"+field.sukunimi+"</td>";
	    	htmlStr+="<td>"+field.puhelin+"</td>";
	    	htmlStr+="<td>"+field.sposti+"</td>";
	    	htmlStr+="</tr>";
	    	$("#listaus tbody").append(htmlStr);
	    });	
	}});
}
</script>
</body>
</html>