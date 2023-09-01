extends MarginContainer


@onready var label = $Label

var type = null
var subtype = null


func set_attributes(input_: Dictionary) -> void:
	type = input_.type
	
	if input_.has("subtype"):
		subtype = input_.subtype
	
	draw()


func draw() -> void:
	match type:
		"bay":
			label.text = type[0].capitalize()
		"ruin":
			label.text = type[0].capitalize()
		"cave":
			label.text = type[0].capitalize()
		"gold":
			label.text = str(subtype)
