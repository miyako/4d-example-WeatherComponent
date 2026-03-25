If (FORM Event.code=On Load)
	
	If (OB Instance of(Form.onLoad; 4D.Function))
		Form.onLoad()
	End if 
	
End if 