extends MarginContainer


@onready var fractions = $HBox/Fractions
@onready var golds = $HBox/Golds


var playfield = null
var limit = 5
var races = []
var specializations = []


func set_attributes(input_: Dictionary) -> void:
	playfield = input_.playfield
	init_fractions()


func init_fractions() -> void:
	races.append_array(Global.dict.race.title.keys())
	specializations.append_array(Global.dict.specialization.title.keys())
	
	while fractions.get_child_count() < limit:
		add_fraction()


func add_fraction() -> void:
	if !races.is_empty() and !specializations.is_empty():
		var input = {}
		input.playfield = playfield
		input.race = races.pick_random()
		input.specialization = specializations.pick_random()
		
		var fraction = Global.scene.fraction.instantiate()
		fractions.add_child(fraction)
		fraction.set_attributes(input)
		
		races.erase(input.race)
		specializations.erase(input.specialization)
		
		input = {}
		input.type = "gold"
		input.subtype = 0
		var icon = Global.scene.icon.instantiate()
		golds.add_child(icon)
		icon.set_attributes(input)
	else:
		print("Market is empty")


func remove_fraction(slot_) -> void:
	var fraction = fractions.get_child(slot_)
	fractions.remove_child(fraction)
	fraction.queue_free()
	var gold = golds.get_child(slot_)
	golds.remove_child(gold)
	gold.queue_free()
	add_fraction()
