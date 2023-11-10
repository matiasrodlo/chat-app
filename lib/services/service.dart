import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/Exceptions/RequestException.dart';

class Service
{
	static	Service		_instance = Service();
	
	String	apiUrl = 'https://api-dot-hablaqui-staging-306619.rj.r.appspot.com/api/v1';
	static	String	_token;
	
	Service();
	
	
	factory Service.instance() => _instance;
	
	String setToken(String t)
	{
		_token = t;
	}
	dynamic _buildEndpoint(String path)
	{
		var endpoint = Uri.parse(this.apiUrl + path);
		
		return endpoint;
	}
	/// Get all necessary headers to send a request
	Map<String, String> getHeaders([Map<String, String> cheaders = null])
	{
		Map<String, String> headers = {
			'Content-Type': 'application/json',
		};
		if( _token != null && !_token.isEmpty )
			headers['Authorization'] = 'Bearer ${_token}';
		if( cheaders != null )
		{
			cheaders.forEach( (k, v) 
			{
				headers[k] = v;
			});
		}
		return headers;
	}
	Future<String> get(String _endpoint) async
	{
		var endpoint 	= this._buildEndpoint(_endpoint);
		print('GET: $endpoint');
		var headers 		= this.getHeaders();
		//print(headers);
		http.Response res 	= await http.get(endpoint, headers: headers);
		//print(res.body);
		//var obj = json.decode(res.body);
		print('StatusCode => ${res.statusCode}');
		if( res.statusCode != 200 )
		{
			throw new RequestException('Ocurrio un error al tratar de recuperar los datos (GET)', res);
		}	
		
		return res.body;
	}
	Future<String> post(String endpoint, Map<dynamic, dynamic> data, [Map<String, String> cheaders = null]) async
	{
		var url			= this._buildEndpoint(endpoint);
		var headers		= this.getHeaders(cheaders);
		String _json	= '';
		if( headers['Content-Type'] != 'application/json' )
		{
			_json = Uri(queryParameters: data).query;
		}
		else
		{
			_json	= json.encode(data);
		}
		
		print('headers');print(headers);print(url);print(_json);
		var response 	= await http.post(url, headers: headers, body: _json);
		print(response.statusCode);print(response.body);
		if( response.statusCode != 200 )
			throw new RequestException('Ocurrio un error al enviar la solicitud (POST)', response);
			
		return response.body;
	}
	Future<String> put(String endpoint, Map<dynamic, dynamic> data) async
	{
		var headers		= this.getHeaders();
		String _json	= json.encode(data);
		var response 	= await http.put(this._buildEndpoint(endpoint), headers: headers, body: _json);
		if( response.statusCode != 200 )
			throw new RequestException('Error en la solicitud PUT', response);
			
		return response.body;
	}
}
