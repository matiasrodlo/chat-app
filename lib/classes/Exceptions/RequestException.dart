import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestException implements Exception
{
	int 			statusCode;
	String			message;
	http.Response	response;
	
	RequestException(String message, http.Response response)
	{
		this.message	= message;
		this.response	= response;
		this.statusCode	= this.response.statusCode;
	}
	Map<dynamic, dynamic> getErrorMap()
	{
		return json.decode(this.response.body);
	}
	Map<dynamic, dynamic> getData() => json.decode(this.response.body);
	String getError() 				=> this.getData().containsKey('error') ? this.getData()['error'] : 'Error desconocido';
	int getCode() 					=> this.response.statusCode;
}