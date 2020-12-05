package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Asiakas;

// Data Access Object
public class Dao {
	private Connection con = null;
	private ResultSet rs = null;
	private PreparedStatement prep = null;
	private String sql; 
	private String db = "Myynti.sqlite";
	
	private Connection yhdista() {
		String path = System.getProperty("catalina.base");
		path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/");
		path += "/Etatehtavat_4/";
		String url = "jdbc:sqlite:"+path+db;
		
		try {
			Class.forName("org.sqlite.JDBC");
			con = DriverManager.getConnection(url);
			// System.out.println("Yhteys avattu!");
			
		} catch (Exception e) {
			// System.out.println("Yhteyden avaus ep‰onnistui :(");
			e.printStackTrace();
		}
		
		return con;
	}
	
	// Otetaan j‰lleen alkuper‰inen metodi k‰yttˆˆn
	public ArrayList<Asiakas> listaaKaikki() {
		ArrayList<Asiakas> asiakkaat = new ArrayList<Asiakas>();
		sql = "SELECT * FROM asiakkaat";
		
		try {
			con = yhdista();
			
			if (con != null) {
				prep = con.prepareStatement(sql);
				// SELECT * FROM asiakkaat 
				rs = prep.executeQuery();
				if (rs != null) {
					// k‰yd‰‰n taulun rivit l‰pi
					while (rs.next()) {
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			} 
			con.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return asiakkaat;
	}
	
	// Kuormitetaan listaaKaikki metodia hakusana-parametrilla
	public ArrayList<Asiakas> listaaKaikki(String hakusana) {
		ArrayList<Asiakas> asiakkaat = new ArrayList<Asiakas>();
		// SQL lause k‰ytt‰m‰‰n hakusanaa
		sql = "SELECT * FROM asiakkaat WHERE etunimi LIKE ? OR sukunimi LIKE ?";
		
		try {
			con = yhdista();
			
			if (con != null) {
				prep = con.prepareStatement(sql);
				prep.setString(1, "%" + hakusana + "%");
				prep.setString(2, "%" + hakusana + "%");
				
				rs = prep.executeQuery();
				if (rs != null) {
					// k‰yd‰‰n taulun rivit l‰pi
					while (rs.next()) {
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			} 
			con.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return asiakkaat;
	}
	
	public boolean lisaaAsiakas(Asiakas asiakas) {
		boolean paluuArvo = true;
		sql = "INSERT INTO asiakkaat VALUES(?,?,?,?,?)";
		
		try {
			con = yhdista();
			prep = con.prepareStatement(sql);
			prep.setInt(1, asiakas.getAsiakas_id());
			prep.setString(2, asiakas.getEtunimi());
			prep.setString(3, asiakas.getSukunimi());
			prep.setString(4, asiakas.getPuhelin());
			prep.setString(5, asiakas.getSposti());
			prep.executeUpdate();
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
			paluuArvo=false;
		}
		
		return paluuArvo;	
	}
	
	public boolean poistaAsiakas(String asiakas_id){ 
		
		boolean paluuArvo=true;
		// Poisto SQL lauseke: DELETE
		// Oikeassa el‰m‰ss‰ tiedot merkit‰‰n poistettavaksi
		sql="DELETE FROM asiakkaat WHERE asiakas_id=?";						  
		
		try {
			con = yhdista();
			prep=con.prepareStatement(sql); 
			prep.setString(1, asiakas_id);			
			prep.executeUpdate();
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		
		return paluuArvo;
	}
	
	public Asiakas etsiAsiakas(String asiakasid) {
		Asiakas asiakas = null;
		sql = "SELECT * FROM asiakkaat WHERE asiakas_id=?";
		
		try {
			con = yhdista();
			
			if (con!=null) {
				prep = con.prepareStatement(sql);
				// asiakasid pit‰‰ muuttaa kantakysely‰ varten stringist‰ numeroksi
				prep.setInt(1, Integer.parseInt(asiakasid));
				rs = prep.executeQuery();
				// jos kysely tuotti dataa
				if (rs.isBeforeFirst()) {
					rs.next();
					// luodaan palautettava asiakasobjekti
					asiakas = new Asiakas();
					// asetetaan sille arvot
					asiakas.setAsiakas_id(rs.getInt(1));
					asiakas.setEtunimi(rs.getString(2));
					asiakas.setSukunimi(rs.getString(3));
					asiakas.setPuhelin(rs.getString(4));
					asiakas.setSposti(rs.getString(5));
				}
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return asiakas;
	}
	
	public boolean muutaAsiakastiedot(Asiakas asiakas, int oldid) {
		boolean paluuArvo = true;
		sql = "UPDATE asiakkaat SET asiakas_id=?, etunimi=?, sukunimi=?, puhelin=?, sposti=? WHERE asiakas_id=?";
		
		try {
			con = yhdista();
			prep = con.prepareStatement(sql);
			prep.setInt(1, asiakas.getAsiakas_id());
			prep.setString(2, asiakas.getEtunimi());
			prep.setString(3, asiakas.getSukunimi());
			prep.setString(4, asiakas.getPuhelin());
			prep.setString(5, asiakas.getSposti());
			prep.setInt(6, oldid);
			prep.executeUpdate();
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
			paluuArvo = false; 
		}
		
		return paluuArvo;
	}
}
