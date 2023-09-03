extends MarginContainer


@onready var troop = $HBox/Troop
@onready var title = $HBox/Title


var playfield = null
var race = null
var specialization = null
var population = {}
var lands = []
var priority = {}


func set_attributes(input_: Dictionary) -> void:
	playfield = input_.playfield
	race = input_.race
	specialization = input_.specialization
	
	if race != "murloc":
		population.max = 0
		population.max += Global.dict.race.title[race].population
		population.max += Global.dict.specialization.title[specialization].population
		population.current = population.max
		population.guard = 0
		
		troop.text = str(population.max)
		title.text = race + " " + specialization


func update_troop() -> void:
	troop.text = str(population.current) + "/" + str(population.max)


func get_attributes() -> Dictionary:
	var input = {}
	input.playfield = playfield
	input.race = race
	input.specialization = specialization
	return input


func point_of_interest_search() -> void:
	var description = {}
	description.race = Global.dict.race.title[race]
	description.specialization = Global.dict.specialization.title[specialization]
	var priorities = {}
	priorities.tax = []
	priorities.invasion = []
	
	for priority in priorities:
		for key in description:
			if description[key].has(priority):
				var data = description[key][priority]
				
				match priority:
					"tax":
						priorities[priority].append(data)
					"invasion":
						priorities[priority].append(data.land)
	
	#print(priorities)
	var landmarks = {}
	var datas = []
	
	for island in playfield.islands.get_children():
		for land in island.lands.get_children():
			var data = {}
			data.island = island
			data.land = land
			data.assessment = 0
			
			for priority in priorities:
				for criterion in priorities[priority]:
					if land.check_against_criterion(criterion):
						data.assessment += 1
			
			if data.assessment == 0:
				data.land.remove_token("goal")
			else:
				if !landmarks.has(island):
					landmarks[island] = {}
				
				landmarks[island][land] = data.assessment
			
			datas.append(data)
	
	for island in landmarks:
		var paths = []
		
		for bay in island.bays:
			var path = [bay]
			var troop = population.current - bay.get_capture_price()
			print([bay.grid, troop])
