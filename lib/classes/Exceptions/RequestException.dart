import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestException implements Exception
{
	final int statusCode;
	final String message;
	final http.Response response;
	
	RequestException({
		required this.statusCode,
		required this.message,
		required this.response,
	});
	
	@override
	String toString()
	{
		return 'RequestException: $message (Status Code: $statusCode)';
	}
	
	Map<dynamic, dynamic> getErrorMap()
	{
		return json.decode(this.response.body);
	}
	Map<dynamic, dynamic> getData() => json.decode(this.response.body);
	String getError() 				=> this.getData().containsKey('error') ? this.getData()['error'] : 'Error desconocido';
	int getCode() 					=> this.response.statusCode;
}