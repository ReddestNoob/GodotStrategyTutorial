extends Node2D

@onready var map_image = $Sprite2D

const IMAGE_SIZE_FACTOR = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.scale *= IMAGE_SIZE_FACTOR
	load_regions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_regions():
	var image = map_image.get_texture().get_image()
	var pixel_color_dict = get_pixel_color_dict(image)
	var regions_dict = import_file("res://map_stuff/map.txt")
	
	for region_color in regions_dict:
		var region = load("res://region_area.tscn").instantiate()
		region.region_name = regions_dict[region_color]
		region.set_name(region.region_name + " Area")
		$Regions.add_child(region)
		var polygons = get_polygons(image, region_color, pixel_color_dict)
		
		for polygon: PackedVector2Array in polygons:
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			
			for i in range(len(polygon)):
				polygon[i] *= IMAGE_SIZE_FACTOR
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
		
			region.add_child(region_collision)
			region.add_child(region_polygon)
			
func get_pixel_color_dict(image: Image):
	var pixel_color_dict = {}
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel_color = "#" + str(image.get_pixel(int(x), int(y)).to_html(false))
			if pixel_color not in pixel_color_dict:
				pixel_color_dict[pixel_color] = []
			pixel_color_dict[pixel_color].append(Vector2(x, y))
	return pixel_color_dict
	
func get_polygons(image, region_color, pixel_color_dict):
	
	var target_image = Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	for value in pixel_color_dict[region_color]:
		target_image.set_pixel(value.x, value.y, "#ffffff")
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(target_image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0,0), bitmap.get_size()), 0.1)
	
	return polygons
	
func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		print("Failed to open file!")
		return null
