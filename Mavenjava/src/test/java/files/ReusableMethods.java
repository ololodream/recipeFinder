package files;

import static io.restassured.RestAssured.given;

import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.path.xml.XmlPath;
import io.restassured.response.Response;

public class ReusableMethods {

	public static XmlPath rawToXML(Response r)
	{
		String response = r.asString();
		XmlPath x = new XmlPath(response);
		return x;
	}
	
	public static JsonPath rawToJson(Response r)
	{
		String response = r.asString();
		JsonPath x = new JsonPath(response);
		return x;
	}
}
