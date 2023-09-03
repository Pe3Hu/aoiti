extends MarginContainer


@onready var leaders = $Fractions/Leaders
@onready var murloc = $Fractions/Barbarians/Murloc

var playfield = null
var players = 1
var crowned = null


func set_attributes(input_: Dictionary) -> void:
	playfield = input_.playfield
	update_murloc_fraction()
	init_leaders()


func update_murloc_fraction() -> void:
	var input = {}
	input.playfield = playfield
	input.race = "murloc"
	input.specialization = null
	murloc.set_attributes(input)


func init_leaders() -> void:
	for _i in players:
		var input = {}
		input.playfield = playfield
		input.title = str(_i)
		var leader = Global.scene.leader.instantiate()
		leaders.add_child(leader)
		leader.set_attributes(input)


func pass_crown() -> void:
	if crowned == null:
		crowned = leaders.get_child(0)
	else:
		var index = (crowned.get_index() + 1) % leaders.get_child_count()
		
		if index == 0:
			playfield.turn += 1
			
			if playfield.turn == 1:
				playfield.end = true
		
		crowned = leaders.get_child(index)
	
	crowned.follow_phase()
