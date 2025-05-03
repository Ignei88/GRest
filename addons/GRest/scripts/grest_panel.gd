@tool
extends Control

@onready var httText = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer/LineEdit
@onready var http_request = $HTTPRequest
@onready var methdOption = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer/MethdOption
@onready var bodyCode = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer2/TabContainer/Body/Control/Panel/VBoxContainer/CodeEdit

@onready var header_params = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer2/TabContainer/Headers/Control/Panel/VBoxContainer

var headers := []
var request_start_tieme := 0

func _ready() -> void:
	update_headers()

func update_headers() -> void:
	headers.clear()
	var check1 = header_params.get_node("Parametro1/HBoxContainer/CheckBox")
	if check1.button_pressed == true:
		var header1 = header_params.get_node("Parametro1/HBoxContainer/LineEdit").text + ":" + header_params.get_node("Parametro1/HBoxContainer2/LineEdit").text
		headers.append(header1)
	var check2 = header_params.get_node("Parametro2/HBoxContainer/CheckBox")
	if check2.button_pressed == true:
		var header2 = header_params.get_node("Parametro2/HBoxContainer/LineEdit").text + ":"  + header_params.get_node("Parametro2/HBoxContainer2/LineEdit").text
		headers.append(header2)

func _on_btn_send_pressed() -> void:
	update_headers()
	request_start_tieme = Time.get_ticks_msec()
	var url = httText.text
	if not url.begins_with("http://") and not url.begins_with("https://"):
		url = "http://" + url
	var body = bodyCode.text
	var method = get_option_method(methdOption.get_selected_id())
	var error = http_request.request(url, headers, method, body)
	if error != OK:
		push_error("An error in the server: ", error)

func get_option_method(id: int) -> int:
	var options := [
	HTTPClient.METHOD_GET,
	HTTPClient.METHOD_POST,
	HTTPClient.METHOD_PUT,
	HTTPClient.METHOD_DELETE,
	]
	return options[id]


func _on_line_edit_text_changed(new_text: String) -> void:
	update_headers()

func _on_check_box_pressed() -> void:
	update_headers()
