extends MarginContainer


@onready var title = $VBox/HBox/Title
@onready var gold = $VBox/HBox/Gold
@onready var ancestor = $VBox/Fractions/Ancestor
@onready var descendant = $VBox/Fractions/Ancestor

var playfield = null
var phases = []


func set_attributes(input_: Dictionary) -> void:
	playfield = input_.playfield
	title.text = "Leader #" + input_.title
	gold.text = "Gold: " + str(5)


func follow_phase() -> void:
	if playfield.end:
		return
	
	if phases.is_empty():
		fill_phases()
	
	var phase = phases.pop_front()
	
	if Global.arr.phase.has(phase):
		phases.append_array(Global.arr.phase[phase])
		phase = phases.pop_front()
	
	if phase != null:
		#print([title.text, phase])
		var func_name = phase.replace(" ", "_")
		call(func_name)
	else:
		phases = ["pass crown"]
	follow_phase()


func fill_phases() -> void:
	if descendant.playfield == null:
		phases = ["lead fraction"]


func purchase_market_slot() -> void:
	var datas = []
	
	for _i in playfield.market.fractions.get_child_count():
		var data = {}
		data.fraction = playfield.market.fractions.get_child(_i)
		data.expense = playfield.market.golds.get_child(_i)
		data.slot = _i
		data.weight = 0
		
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.weight > b.weight)
	
	var options = []
	
	for data in datas:
		if data.weight == datas.front().weight:
			options.append(data.slot)
	
	var slot = options.pick_random()
	var fraction = playfield.market.fractions.get_child(slot)
	set_descendant(fraction)
	pay_expenses(slot)


func set_descendant(fraction_: MarginContainer) -> void:
	var input = fraction_.get_attributes()
	input.race = "forsaken"
	input.specialization = "lumberjacks"
	descendant.set_attributes(input)
	descendant.visible = true


func pay_expenses(slot_: int) -> void:
	var value = int(playfield.market.golds.get_child(slot_).label.text)
	change_gold_to(value)
	playfield.market.remove_fraction(slot_)


func change_gold_to(value_: int) -> void:
	var words = gold.text.split(" ")
	var value = int(words[1]) + value_
	
	if value < 0:
		print("not enough gold")
	else:
		gold.text = "Gold: " + str(value)
 

func faction_potential_assessment() -> void:
	if descendant.population.max > 4:
		phases.append("regional conquest")
	else:
		phases.append("fraction decay")


func regional_withdrawal() -> void:
	pass


func troop_assembly() -> void:
	descendant.population.current = descendant.population.max
	descendant.update_troop()


func initial_disembarkation() -> void:
	if descendant.lands.is_empty():
		descendant.point_of_interest_search()
		


func expansion() -> void:
	pass


func last_spurt() -> void:
	pass


func troop_retreat() -> void:
	pass


func fraction_auxiliary() -> void:
	pass


func tax_collection() -> void:
	pass


func enmity_bonus() -> void:
	pass


func pass_crown() -> void:
	playfield.senate.pass_crown()

