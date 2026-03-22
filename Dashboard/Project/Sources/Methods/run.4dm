//%attributes = {"preemptive":"incapable"}
#DECLARE($params : Object)

If (Count parameters=0)
	
	CALL WORKER(1; Current method name; {})
	
Else 
	
	var $window : Integer
	$window:=Open form window("DashBoard")
	DIALOG("DashBoard"; cs.DashBoard.new(); *)
	
End if 