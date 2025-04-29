@tool
extends Control

@onready var hsplitr = $HSplitR
@onready var hsplitL = $HSplitR/HSplitL
var LIMITL := 110
var LIMITR := 855

func _on_h_split_r_dragged(offset: int) -> void:
	if offset <= LIMITL:
		hsplitr.split_offset = LIMITL

func _on_h_split_l_dragged(offset: int) -> void:
	if offset >= LIMITR:
		print("ds")
		hsplitL.split_offset = LIMITR
