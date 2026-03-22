property user : Text
property location : Text
property date : Text
property icon : Picture
property weather : Object
property astronomy : Object

Class constructor
	
	This.user:="Hi Keisuke Miyako!"
	This.location:="Tokyo"
	This.date:=String(Current date; "yyyy-MM-dd")
	
Function onLoad()
	
	var $apiKey : Text
	$apiKey:=This._keyForProvider("Weather")
	cs.WeatherComponent.Weather.new($apiKey).current(This.location; {onResponse: This.onCurrent})
	cs.WeatherComponent.Weather.new($apiKey).astronomy(This.location; This.date; {onResponse: This.onAstronomy})
	
Function onIcon($request : 4D.HTTPRequest; $event : Object)
	
	If (Form=Null)
		return 
	End if 
	
	If (($request.response#Null) && ($request.response.status=200))
		var $icon : Picture
		BLOB TO PICTURE($request.response.body; $icon)
		Form.icon:=$icon
	Else 
		Form.weather:={success: False; response: {}; errors: $request.response.body.error; status: $request.response.status; statusText: $request.response.statusText}
	End if 
	
Function onAstronomy($request : 4D.HTTPRequest; $event : Object)
	
	If (Form=Null)
		return 
	End if 
	
	If (($request.response#Null) && ($request.response.status=200))
		Form.astronomy:={success: True; response: $request.response.body}
	Else 
		Form.astronomy:={success: False; response: {}; errors: $request.response.body.error; status: $request.response.status; statusText: $request.response.statusText}
	End if 
	
Function onCurrent($request : 4D.HTTPRequest; $event : Object)
	
	If (Form=Null)
		return 
	End if 
	
	If (($request.response#Null) && ($request.response.status=200))
		Form.weather:={success: True; response: $request.response.body}
		Form.weather.heat:=String(Form.weather.response.current.heatindex_c)+"°C"
		var $iconUrl : Text
		$iconUrl:="https:"+Form.weather.response.current.condition.icon
		4D.HTTPRequest.new($iconUrl; {onResponse: Form.onIcon})
	Else 
		Form.weather:={success: False; response: {}; errors: $request.response.body.error; status: $request.response.status; statusText: $request.response.statusText}
	End if 
	
Function _secretsFolder() : 4D.Folder
	
	return Folder("/PACKAGE/Secrets")
	
Function _keyForProvider($provider : Text) : Text
	
	var $file : 4D.File
	$file:=This._secretsFolder().file($provider+".token")
	return $file.exists ? $file.getText() : ""