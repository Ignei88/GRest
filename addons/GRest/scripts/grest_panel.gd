@tool
extends Control

@onready var httText = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer/LineEdit
@onready var http_request = $HTTPRequest
@onready var methdOption = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer/MethdOption
@onready var bodyCode = $UI/HSplitR/HSplitL/ContPrincipal/HBoxContainer2/TabContainer/Body/Control/Panel/VBoxContainer/CodeEdit

func _on_btn_send_pressed() -> void:
	var url = httText.text
	if not url.begins_with("http://") and not url.begins_with("https://"):
		url = "http://" + url
	var body = bodyCode.text
	var headers = ["Content-Type: application/json"]
	var method = get_option_method(methdOption.get_selected_id())
	print(body)
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
