extends MarginContainer

@onready var islands = $Islands


func _ready() -> void:
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
