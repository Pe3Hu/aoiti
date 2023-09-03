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
var shore = null
var goal = true
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
	shore = true
	
	if terrain != null:
		set_style()
		set_protector()
		init_tokens()
	
	center = Global.vec.size.land * (grid * 1.25 + Vector2.ONE * 0.5)


func set_style() -> void:
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	style.bg_color = Global.color.terrain[terrain]
	
	custom_minimum_size = Global.vec.size.land
	style.corner_radius_top_left = Global.num.land.r / 2
	style.corner_radius_top_right = Global.num.land.r / 2
	style.corner_radius_bottom_left = Global.num.land.r / 2
	style.corner_radius_bottom_right = Global.num.land.r / 2


func set_protector() -> void:
	if protector:
		var input = {}
		input.troop = "defender"
		input.fraction = island.playfield.senate.murloc
		input.strength = 1
		set_troop(input)


func init_tokens() -> void:
	for token in Global.arr.token:
		var flag = get(token)
		
		if flag:
			var input = {}
			input.type = "token"
			input.subtype = token
			var icon = Global.scene.icon.instantiate()
			tokens.add_child(icon)
			icon.set_attributes(input)


func set_troop(input_: Dictionary) -> void:
	var troop = get(input_.troop)
	troop.set_attributes(input_)
	troop.visible = true


func remove_token(subtype_: String) -> void:
	for icon in tokens.get_children():
		if icon.subtype == subtype_:
			set(subtype_, false)
			tokens.remove_child(icon)
			icon.queue_free()
			return


func check_against_criterion(criterion_: String) -> bool:
	var flag = false
	var type = null
	
	if Global.arr.token.has(criterion_):
		type = "token"
	
	if Global.arr.terrain.has(criterion_):
		type = "terrain"
	
	print([type, criterion_])
	match type:
		"token":
			flag = get(criterion_)
		"terrain":
			flag = criterion_ == terrain
	
	
	return flag


func get_capture_price() -> int:
	var price = 2
	
	if terrain == "mountain":
		price += 1
	
	price += int(defender.strength.text)
	
	return price
