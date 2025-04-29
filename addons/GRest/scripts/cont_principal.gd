@tool
extends VBoxContainer

@onready var param1 = $HBoxContainer2/TabContainer/Quey/Control/Panel/VBoxContainer/Parametro1
@onready var httpText = $HBoxContainer/LineEdit
@onready var check = $HBoxContainer2/TabContainer/Quey/Control/Panel/VBoxContainer/Parametro1/HBoxParam1/CheckBox
@onready var container_params = $HBoxContainer2/TabContainer/Quey/Control/Panel/VBoxContainer

var default_url := "https://www.example.com/welcome"

func _ready() -> void:
	httpText.text = default_url  # Solo al inicio
	param1.add_to_group("query_params")

func _on_line_param_p_1_text_changed(new_text: String) -> void:
	_update_http_text()
	if new_text != "":
		check.button_pressed = true
		if container_params.get_children().filter(func(c): return c.is_in_group("query_params")).size() == 1:
			_create_box_params()

func _on_line_param_p_2_text_changed(new_text: String) -> void:
	_update_http_text()
	if new_text != "":
		check.button_pressed = true
		if container_params.get_children().filter(func(c): return c.is_in_group("query_params")).size() == 1:
			_create_box_params()



func _create_box_params():
	var hbox_C = HBoxContainer.new()
	container_params.add_child(hbox_C)
	hbox_C.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_C.add_to_group("query_params")
	
	var hbox_param1 = HBoxContainer.new()
	hbox_param1.name = "HBoxParam1"
	hbox_param1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_C.add_child(hbox_param1)
	
	var check = CheckBox.new()
	hbox_param1.add_child(check)
	
	var line_param_p1 = LineEdit.new()
	line_param_p1.name = "LineParamP1"
	line_param_p1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_param1.add_child(line_param_p1)
	
	var hbox_param1_1 = HBoxContainer.new()
	hbox_param1_1.name = "HBoxParam1_1"
	hbox_param1_1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_C.add_child(hbox_param1_1)

	var line_param_p2 = LineEdit.new()
	line_param_p2.name = "LineParamP2"
	line_param_p2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox_param1_1.add_child(line_param_p2)
	
	var btn_del = Button.new()
	btn_del.text = "X"
	hbox_param1_1.add_child(btn_del)
	
	btn_del.pressed.connect(func():
		if hbox_C.get_parent():
			hbox_C.queue_free()
	)

	line_param_p1.text_changed.connect(func(new_text):
		if new_text.strip_edges() == "" and line_param_p2.text.strip_edges() == "":
			hbox_C.queue_free()
			#await get_tree().process_frame 
			if container_params.get_children().filter(func(c): return c.is_in_group("query_params")).size() == 1:
				_create_box_params()
		_update_http_text()
	)

	line_param_p2.text_changed.connect(func(new_text):
		_update_http_text()
		if new_text.strip_edges() == "" and line_param_p1.text.strip_edges() == "":
			hbox_C.queue_free()
			_update_http_text()
	)

func _update_http_text() -> void:
	var current_full_text = httpText.text
	var base_url = current_full_text.split("?")[0]
	var query = ""

	for param in container_params.get_children():
		if param.is_in_group("query_params"):
			var p1 = param.get_node("HBoxParam1/LineParamP1")
			var p2 = param.get_node("HBoxParam1_1/LineParamP2")
			if p1.text.strip_edges() != "":
				if query == "":
					query += "?%s" % p1.text
				else:
					query += "&%s" % p1.text
				if p2.text.strip_edges() != "":
					query += "=%s" % p2.text
			elif p2.text.strip_edges() != "":
				if query == "":
					query += "?=%s" % p2.text
				else:
					query += "&=%s" % p2.text

	httpText.text = base_url + query
