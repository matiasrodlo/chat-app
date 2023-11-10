import 'package:http/http.dart' as http;
import 'dart:convert';

import 'RequestException.dart';

class ExceptionLogin extends RequestException
{
	
	ExceptionLogin(String error, http.Response response) :  super(error, response)
	{
	}
	String erroMsg()
	{
		return this.message;
	}
}
