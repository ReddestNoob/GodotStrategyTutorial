extends Node2D

func get_region_by_name(name: String):
	for child in get_children():
		if child.region_name == name:
			return child
	return null

var selected: String = "":
	set(value):
		var prev = get_region_by_name(selected)
		if prev != null:
			prev.set_default_color()
		selected = value
