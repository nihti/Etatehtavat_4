package control;

import java.io.PrintWriter;
import java.util.ArrayList;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import model.Asiakas;
import model.dao.Dao;

/**
 * Servlet implementation class Asiakkaat
 */
@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Asiakkaat() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// haetaan kutsun polkutiedot
		String pathInfo = request.getPathInfo();
		// System.out.println("polku: "+ pathInfo);
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat;
		String json = "";
		// REST konventio: hae data myös ilman kauttaviivaa urlin lopussa
		if (pathInfo == null) {
			asiakkaat = dao.listaaKaikki();
			json = new JSONObject().put("asiakkaat", asiakkaat).toString();
			// indexOf hakee merkkijonoa merkkijonon sisällä
			// pathinfo = merkkijono, indexOf("haeasiakas") = merkkijono merkkijonon sisässä
			// -1 if it never occurs eli != -1 on sama kuin ei ei koskaan
		} else if (pathInfo.indexOf("haeasiakas") != -1) {
			// poistetaan pathin "kansio-osa"
			String asiakasid = pathInfo.replace("/haeasiakas/", "");
			Asiakas asiakas = dao.etsiAsiakas(asiakasid);
			JSONObject jos = new JSONObject();
			jos.put("asiakas_id", asiakas.getAsiakas_id());
			jos.put("etunimi", asiakas.getEtunimi());
			jos.put("sukunimi", asiakas.getSukunimi());
			jos.put("puhelin", asiakas.getPuhelin());
			jos.put("sposti", asiakas.getSposti());
			json = jos.toString();
		} else {
			// hakusana lopussa
			String hakusana = pathInfo.replace("/","");
			asiakkaat = dao.listaaKaikki(hakusana);
			json = new JSONObject().put("asiakkaat", asiakkaat).toString();

		}
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(json);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); 
		//Muutetaan kutsun mukana tuleva json-string json-objektiksi
		
		Asiakas asiakas = new Asiakas();
		asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id"));
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		
		if (dao.lisaaAsiakas(asiakas)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

	/**
	 * @see HttpServlet#doPut(HttpServletRequest, HttpServletResponse)
	 */
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//System.out.println("DOPUT");
		JSONObject jsonObj = new JsonStrToObj().convert(request); 
		//Muutetaan kutsun mukana tuleva json-string json-objektiksi
		
		String oldid = jsonObj.getString("old_id");
		Asiakas asiakas = new Asiakas();
		
		asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id"));
		asiakas.setEtunimi(jsonObj.getString("etunimi"));
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		
		if (dao.muutaAsiakastiedot(asiakas, Integer.parseInt(oldid))) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

	/**
	 * @see HttpServlet#doDelete(HttpServletRequest, HttpServletResponse)
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();
		System.out.println("polku: "+ pathInfo);
		String poistettavaAsiakas = pathInfo.replace("/","");
		
		Dao dao = new Dao();
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		
		if (dao.poistaAsiakas(poistettavaAsiakas)) { //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Auton poistaminen onnistui {"response":1}
		} else {
			out.println("{\"response\":0}");  //Auton poistaminen epäonnistui {"response":0}
		}

	}

}
