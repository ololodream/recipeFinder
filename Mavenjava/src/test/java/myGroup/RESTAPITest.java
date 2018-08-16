package myGroup;
import io.restassured.RestAssured;
import static io.restassured.RestAssured.given;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import files.Payload;
import files.ReusableMethods;

import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;

public class RESTAPITest {

//	@Test
//	public void postJira()
//	{
//		System.out.println("postJira");	
//	}
//	@Test
//	public void dummy()
//	{
//		System.out.println("dummy");
//	}
	

	Properties prop = new Properties();
	@BeforeTest
	public void getPro() throws IOException
	{
			FileInputStream files = new FileInputStream("C:\\workspace\\RestAssuredDemo\\src\\files\\env.properties");
			prop.load(files);
	}
	
	@Test
	public void JiraAPI()
	{
		
		RestAssured.baseURI= prop.getProperty("JiraHost");
		Response res = given().header("Content-Type","application/json").
				//header("Cookie","JSESSIONID"+ReusableMethods.getSessionId()).
				//header("Cookie","JSESSIONID="+ReusableMethods.getSessionId()). // this is okay
				cookie("JSESSIONID",ReusableMethods.getSessionId()).// both works fine
				body(Payload.getCreateIssue()).
				when().post("/rest/api/2/issue").
				then().statusCode(201).
				extract().response();
		
		JsonPath js = ReusableMethods.rawToJson(res);
		
		String id = js.get("id");
		System.out.println("==========issue id==========");
		System.out.println(id);
		
	}

}
