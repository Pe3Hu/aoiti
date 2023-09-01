extends MarginContainer


@onready var islands = $HBox/Islands
@onready var market = $HBox/Market
@onready var players = $Fractions/Players
@onready var murloc = $Fractions/Barbarians/Murloc


func _ready() -> void:
	market.playfield = self
	init_fractions()
	init_islands()


func init_islands() -> void:
	var n = 4
	islands.columns = 2
	
	for _i in n:
		var input = {}
		input.playfield = self
		input.title = _i
		var island = Global.scene.island.instantiate()
		islands.add_child(island)
		island.set_attributes(input)


func init_fractions() -> void:
	update_murloc_fraction()


func update_murloc_fraction() -> void:
	var input = {}
	input.playfield = self
	input.race = "murloc"
	input.specialization = null
	murloc.set_attributes(input)


func add_player_fraction() -> void:
	var input = {}
	input.playfield = self
	input.race = null
	input.specialization = null
	var fraction = Global.scene.fraction.instantiate()
	players.add_child(fraction)
	murloc.set_attributes(input)
