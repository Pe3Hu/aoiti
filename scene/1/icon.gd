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
		"token":
			match subtype:
				"bay":
					pass
				"ruin":
					pass
				"cave":
					pass
				"shore":
					visible = false
				"goal":
					pass
					#visible = false
			
			label.text = subtype[0].capitalize()
		"gold":
			label.text = str(subtype)
