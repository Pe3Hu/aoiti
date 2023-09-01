extends MarginContainer


@onready var troop = $HBox/Troop
@onready var title = $HBox/Title


var playfield = null
var race = null
var specialization = null
var population = {}


func set_attributes(input_: Dictionary) -> void:
	playfield = input_.playfield
	race = input_.race
	specialization = input_.specialization
	
	if race != "murloc":
		population.max = 0
		population.max += Global.dict.race.title[race].population
		population.max += Global.dict.specialization.title[specialization].population
		population.current = population.max
		
		troop.text = str(population.max)
		title.text = race + " " + specialization


func update_troop() -> void:
	troop.text = str(population.current) + "/" + str(population.max)
