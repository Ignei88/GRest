@tool
extends EditorPlugin

## Preload the main panel scene
const MainPanel := preload("res://addons/GRest/escene/grest_panel.tscn")
const PLUGIN_NAME := "GRest"
const PLUGIN_HANDLER_PATH := "res://addons/GRest/grest.gd"
const PLUGIN_ICON_PATH := "res://icon.svg"


var editor_view: Control
var inspector_plugin: EditorImportPlugin = null

func _init() -> void:
	self.name = "GRestPlugin"

#func _enable_plugin() -> void:
	#add_autoload_singleton()
	#add_dialogic_default_action()

#func _disable_plugin() -> void:
#	remove_autoload_singleton()

func _enter_tree() -> void:
	editor_view = MainPanel.instantiate()
	#editor_view.inspector_plugin = self
	editor_view.hide()
	get_editor_interface().get_editor_main_screen().add_child(editor_view)
	_make_visible(false)


func _exit_tree():
	if is_instance_valid(editor_view) and editor_view.is_inside_tree():
		editor_view.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible:bool) -> void:
	if not editor_view:
		return

	if editor_view.get_parent() is Window:
		if visible:
			get_editor_interface().set_main_screen_editor("GRest")
			editor_view.show()
			editor_view.get_parent().grab_focus()
	else:
		editor_view.visible = visible

func move_to_front():
	var main_screen = get_editor_interface().get_editor_main_screen()
	main_screen.move_child(editor_view, main_screen.get_child_count() - 1)

func _get_plugin_name():
	return "GRest"

func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("ExternalLink", "EditorIcons")
