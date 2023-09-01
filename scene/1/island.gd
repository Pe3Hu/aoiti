extends MarginContainer


@onready var lands = $Lands
@onready var boundaries = $Boundaries


var playfield = null
var title = null
var grids = {}


func set_attributes(input_: Dictionary) -> void:
	playfield = input_.playfield
	title = input_.title
	
	init_lands()
	init_boundaries()


func init_lands() -> void:
	var island_description = Global.dict.island.title[title]
	lands.columns = island_description.size.x
	lands.set("theme_override_constants/h_separation", Global.vec.size.land.x * 0.25)
	lands.set("theme_override_constants/v_separation", Global.vec.size.land.y * 0.25)
	
	for _y in island_description.size.y:
		for _x in island_description.size.x:
			var input = {}
			input.island = self
			input.grid = Vector2(_x, _y)
			input.terrain = null
			input.protector = false
			input.bay = false
			input.ruin = false
			input.cave = false
			
			if island_description.lands.has(input.grid):
				for key in input:
					if island_description.lands[input.grid].has(key) and key != "island":
						input[key] = island_description.lands[input.grid][key]
			
			var land = Global.scene.land.instantiate()
			lands.add_child(land)
			land.set_attributes(input)
			
			if input.terrain != null:
				grids[input.grid] = land


func init_boundaries() -> void:
	for grid in grids:
		var land = grids[grid]
		
		for direction in Global.dict.neighbor.hybrid2:
			var neighbor_grid = grid + direction
			
			if grids.has(neighbor_grid):
				var neighbor_land = grids[neighbor_grid]
				
				if !land.neighbors.has(neighbor_land):
					var input = {}
					input.island = self
					input.lands = [land, neighbor_land]
					var boundary = Global.scene.boundary.instantiate()
					boundaries.add_child(boundary)
					boundary.set_attributes(input)
	
