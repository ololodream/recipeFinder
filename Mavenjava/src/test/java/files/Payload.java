package files;

public class Payload {

	public static String getPayload()
	{
		String body = "{"+

				   "\"FirstName\" : \"value_miya\","+
				
				   "\"LastName\" : \"value_chen\","+
				
				   "\"UserName\" : \"value_miya05\","+
				
				   "\"Password\" : \"value\","+
				
				   "\"Email\"        : \"cmengj05@gmail.com\""+
				
					"}";
		return body;
	}

	public static String getCreateIssue()
	{
		String body= "{\r\n\t\"fields\":{\r\n\t\t\"project\":\r\n\t\t{\r\n\t\t\t\"key\":\"MYP\"\r\n\t\t},\r\n\t\t\"summary\": \"rest assured jira api test new\",\r\n\t\t\"description\": \"creating of an issue using project keys and issue type names through rest api\",\r\n\t\t\"issuetype\":{\r\n\t\t\t\"name\":\"Bug\"\r\n\t\t}\r\n\t}\r\n}";
//		System.out.println("==========json=========");
//		System.out.println(body);
		return  body;
	}
	public static String getAddComment()
	{
		String body= "{ \"body\": \"Add comment from the automation code\","+
			    "\"visibility\": {"+
		        "\"type\": \"role\","+
		        "\"value\": \"Administrators\" }"+
		"}";
		return  body;
	}
	public static String getUpdatedComment()
	{
		String body= "{ \"body\": \"Updated comment from the automation code\","+
			    "\"visibility\": {"+
		        "\"type\": \"role\","+
		        "\"value\": \"Administrators\" }"+
		"}";
		return  body;
	}
}
