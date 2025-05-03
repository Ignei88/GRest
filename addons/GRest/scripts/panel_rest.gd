@tool
extends Panel

@onready var statusR = $VBoxContainer/HBoxContainer/HBoxStatus/LblStatusR
@onready var sizeR = $VBoxContainer/HBoxContainer/HBoxSize/LblSizeR
@onready var timeR = $VBoxContainer/HBoxContainer/HBoxTime/LblTimeR
@onready var codeR = $VBoxContainer/TabContainer/Response/CodeEdit
@onready var listHeaders = $VBoxContainer/TabContainer/Headers/ItemList

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var secs = get_parent().get_parent().get_parent().get_parent().get_node(".").request_start_tieme
	var request_time = Time.get_ticks_msec() - secs
	timeR.text = "%d ms" % request_time
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
	has_json_header(headers)



func has_json_header(headers: PackedStringArray) -> bool:
	var arr := []
	for header in headers:
		var parts = header.split(":", false, 1)
		listHeaders.add_item(parts[0])
		if parts.size() == 2:
			listHeaders.add_item(parts[1].strip_edges())
	return false

func get_element_header(headers:PackedStringArray, str:String):
	var res := ""
	for header in headers:
		if header.begins_with(str):
			res = header.split(":")[1].strip_edges()  
			break
	return res
