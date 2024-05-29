extends Area2D

var region_name = "" ## Has to be unique

@onready var regions_node = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_child_entered_tree(node: Node):
	if node is Polygon2D:
		node.color = Color(0,0,0,0.5)


func _on_mouse_entered():
	if region_name != regions_node.selected:
		set_children_color(Color(1, 1, 1, 0.5))


func _on_mouse_exited():
	if region_name != regions_node.selected:
		set_default_color()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			regions_node.selected = region_name
			set_children_color(Color(0, 0, 255, 1))

func set_children_color(color: Color):
	for child in get_children():
		if child is Polygon2D:
			child.color = color

func set_default_color():
	set_children_color(Color(0,0,0, 0.5))
