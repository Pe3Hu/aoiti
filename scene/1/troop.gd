extends MarginContainer


@onready var icon = $Labels/Fraction
@onready var strength = $Labels/Strength

var fraction = null


func set_attributes(input_: Dictionary) -> void:
	fraction = input_.fraction
	strength.text = str(input_.strength)
	icon.text = fraction.race[0].capitalize()
