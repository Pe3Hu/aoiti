extends MarginContainer


@onready var islands = $HBox/Islands
@onready var market = $HBox/Market
@onready var senate = $HBox/Senate

var end = false
var turn = 0


func _ready() -> void:
	var input = {}
	input.playfield = self
	market.set_attributes(input)
	senate.set_attributes(input)
	init_islands()
	start()


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


func start() -> void:
	senate.pass_crown()
