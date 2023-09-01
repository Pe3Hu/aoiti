extends MarginContainer

@onready var bg =  $BG

var island = null
var grid = null
var terrain = null
var protector = null
var bay = null
var ruin = null
var cave = null
var center = Vector2()
var neighbors = {}


func set_attributes(input_: Dictionary) -> void:
	island = input_.island
	grid = input_.grid
	terrain = input_.terrain
	protector = input_.protector
	bay = input_.bay
	ruin = input_.ruin
	cave = input_.cave
	
	
	if terrain != null:
		var style = StyleBoxFlat.new()
		bg.set("theme_override_styles/panel", style)
		style.bg_color = Global.color.terrain[terrain]
		
		custom_minimum_size = Global.vec.size.land
		style.corner_radius_top_left = Global.num.land.r / 2
		style.corner_radius_top_right = Global.num.land.r / 2
		style.corner_radius_bottom_left = Global.num.land.r / 2
		style.corner_radius_bottom_right = Global.num.land.r / 2
	
	center = Global.vec.size.land * (grid * 1.25 + Vector2.ONE * 0.5)
