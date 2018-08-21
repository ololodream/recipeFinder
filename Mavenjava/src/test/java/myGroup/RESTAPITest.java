package myGroup;
import io.restassured.RestAssured;
import static io.restassured.RestAssured.given;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import files.Payload;
import files.ReusableMethods;

import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;


public class RESTAPITest {

	private static Logger log = LogManager.getLogger(RESTAPITest.class.getName());
	Properties prop = new Properties();
	private String issueId = null;
	private String commentId = null;
	
	@BeforeTest
	public void getPro() throws IOException
	{
			FileInputStream files = new FileInputStream("src\\test\\java\\config\\env.properties");
			prop.load(files);
	}
	
	@Test(priority = 0)
	public void jiraCreateIssue()
	{
//		System.out.println("==========create issue==========");
		log.info("create issue");
		RestAssured.baseURI= prop.getProperty("JiraHost");
		Response res = given().header("Content-Type","application/json").
				//header("Cookie","JSESSIONID"+ReusableMethods.getSessionId()).
				//header("Cookie","JSESSIONID="+ReusableMethods.getSessionId()). // this is okay
				cookie("JSESSIONID", getSessionId()).// both works fine
				body(Payload.getCreateIssue()).
				when().post("/rest/api/2/issue").
				then().statusCode(201).
				extract().response();
		
		JsonPath js = ReusableMethods.rawToJson(res);
		
		String id = js.get("id");
		issueId = id;
		log.info("Issue added. issueId:"+issueId);

//		System.out.println("==========issue id==========");
//		System.out.println(id);
	}
	@Test (priority = 1)
	public void JiraAddComment()
	{
//		if(issueId.isEmpty())
//		{
//			System.out.println("==========issue not found==========");
//			return null;
//		}
		log.info("add comment.\t"+"issueId:"+issueId);
		
//		System.out.println("==========issue id==========");
//		System.out.println(issueId);
		RestAssured.baseURI= prop.getProperty("JiraHost");
		Response res = given().header("Content-Type","application/json").
				//header("Cookie","JSESSIONID"+ReusableMethods.getSessionId()).
				header("Cookie","JSESSIONID="+getSessionId()).
				body(Payload.getAddComment()).
				when().post("/rest/api/2/issue/"+issueId+"/comment").//hard code
				then().statusCode(201).
				extract().response();
		
		
		JsonPath js = ReusableMethods.rawToJson(res);
		
		String id = js.get("id");
		commentId = id;
		log.info("Comment added. commentId:"+commentId);
//		System.out.println("==========comment id==========");
//		System.out.println(issueId);
//		return id;
	}

	@Test(priority = 2)
	public void JiraUpdateComment()
	{
//		System.out.println("==========updatae comment ==========");
//		System.out.println(commentId);
//		System.out.println(issueId);
	
		log.info("Update Comment.\t"+"issueId:"+issueId+"\tcommentId:"+commentId);
		RestAssured.baseURI= prop.getProperty("JiraHost");
		Response res = given().header("Content-Type","application/json").
				pathParam("commentId", commentId).pathParam("issueId", issueId).
				//header("Cookie","JSESSIONID"+ReusableMethods.getSessionId()).
				header("Cookie","JSESSIONID="+ getSessionId()).
				body(Payload.getUpdatedComment()).
				//when().put("/rest/api/2/issue/10032/comment/10021").//hard code
				when().put("/rest/api/2/issue/{issueId}/comment/{commentId}").
//				when().put("/rest/api/2/issue/10032/comment/{commentid}").
				then().statusCode(200).
				extract().response();
		
		log.info("comment updated");
//		JsonPath js = ReusableMethods.rawToJson(res);
//		
//		String id = js.get("id");
//		System.out.println("==========issue id==========");
//		System.out.println(id);
		
	}

	private String getSessionId()
	{
		RestAssured.baseURI= prop.getProperty("JiraHost");
		Response res = given().header("Content-Type","application/json").
		body("{ \"username\": \""+
				prop.getProperty("USERNAME")+
				"\", \"password\": \""+
				prop.getProperty("PASSWORD") +"\" }").
		when().
		post("/rest/auth/1/session").then().statusCode(200).
		extract().response();
		
		JsonPath js = ReusableMethods.rawToJson(res);
		String session_id = js.get("session.value"); 
		//System.out.println("========session id========");
		//System.out.println(session_id);
		return session_id;
	}

}
