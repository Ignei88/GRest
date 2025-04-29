@tool
extends Panel

@onready var statusR = $VBoxContainer/HBoxContainer/HBoxStatus/LblStatusR
@onready var sizeR = $VBoxContainer/HBoxContainer/HBoxSize/LblSizeR
@onready var timeR = $VBoxContainer/HBoxContainer/HBoxTime/LblTimeR
@onready var codeR = $VBoxContainer/TabContainer/Response/CodeEdit

#func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
#	statusR.text = str(response_code)
#	sizeR.text = get_element_header(headers,"Content-Length:")
#	#var response = JSON.parse_string(body.get_string_from_utf8())
#	codeR.text = body.get_string_from_utf8()
#	if not has_json_header(headers):
#		return push_error("Error in the server")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	statusR.text = str(response_code)
	sizeR.text = get_element_header(headers,"Content-Length:")
	if result != HTTPRequest.RESULT_SUCCESS:
		codeR.text = str(result)
		return
	var response_body = body.get_string_from_utf8()
	var json = JSON.new()
	var json_error = json.parse(response_body)
	if json_error == OK:
		var formatted_json = JSON.stringify(json.get_data(), "\t",true)
		codeR.text = formatted_json
	else:
		codeR.text = response_body



func has_json_header(headers: PackedStringArray) -> bool:
	for header in headers:
		if "content-type" in header.to_lower() and "application/json" in header.to_lower():
			return true
	return false

func get_element_header(headers:PackedStringArray, str:String):
	var res := ""
	for header in headers:
		if header.begins_with(str):
			res = header.split(":")[1].strip_edges()  
			break
	return res
