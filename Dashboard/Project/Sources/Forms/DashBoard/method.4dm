If (FORM Event.code=On Load)
	
	If (OB Instance of(Form; 4D.Function))
		Form.onLoad()
	End if 
	
End if 