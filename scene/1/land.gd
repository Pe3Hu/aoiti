extends MarginContainer


@onready var bg = $BG
@onready var defender = $VBox/Troops/Defender
@onready var invader = $VBox/Troops/Invader
@onready var tokens = $VBox/Tokens

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
		
		if protector:
			var input = {}
			input.troop = "defender"
			input.fraction = island.playfield.murloc
			input.strength = 1
			set_troop(input)
		
		for token in Global.arr.token:
			var flag = get(token)
			
			if flag:
				var input = {}
				input.type = token
				var icon = Global.scene.icon.instantiate()
				tokens.add_child(icon)
				icon.set_attributes(input)
	
	center = Global.vec.size.land * (grid * 1.25 + Vector2.ONE * 0.5)


func set_troop(input_: Dictionary) -> void:
	var troop = get(input_.troop)
	troop.set_attributes(input_)
	troop.visible = true
