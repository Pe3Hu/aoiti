extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.token = ["bay", "ruin", "cave", "shore", "goal"]
	arr.terrain = ["forest", "swamp", "steppe", "hill", "mountain", "pond"]
	arr.invasion = []
	arr.tax = []
	
	
	arr.phase = {
		"lead fraction": [
			"purchase market slot",
			"strategic choice"
			],
		"strategic choice": [
			"faction potential assessment"
		],
		"regional conquest": [
			"regional withdrawal",
			"troop assembly",
			"initial disembarkation",
			"expansion",
			"last spurt",
			"coin receipt"
		],
		"fraction decay": [
			"troop retreat",
			"fraction auxiliary",
			"coin receipt"
		],
		"coin receipt": [
			"tax collection",
			"enmity bonus",
			"pass crown"
		],
	}


func init_num() -> void:
	num.index = {}
	
	num.land = {}
	num.land.r = 50


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal2 = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.neighbor.hybrid2 = []
	
	for _i in dict.neighbor.linear2.size():
		dict.neighbor.hybrid2.append(dict.neighbor.linear2[_i])
		dict.neighbor.hybrid2.append(dict.neighbor.diagonal2[_i])
	
	init_land()
	init_race()
	init_specialization()


func init_land() -> void:
	dict.island = {}
	dict.island.title = {}
	dict.land = {}
	dict.land.index = {}
	var path = "res://asset/json/aoiti_land.json"
	var array = load_data(path)
	
	for land in array:
		var island_title = int(land.island)
		
		if !dict.island.title.has(island_title):
			dict.island.title[island_title] = {}
			dict.island.title[island_title].size = Vector2()
			dict.island.title[island_title].lands = {}
		
		var data = {}
		data.grid = Vector2()
		
		for key in land:
			var words = key.split(" ")
			
			if typeof(land[key]) == TYPE_FLOAT:
				land[key] = int(land[key])
			
			if words.has("grid"):
				data.grid[words[1]] = land[key]
				
				if dict.island.title[island_title].size[words[1]] < land[key]:
					dict.island.title[island_title].size[words[1]] = land[key]
			else:
				var value = land[key]
				
				match value:
					"no":
						value = false
					"yes":
						value = true
				
				data[key] = value
		
		data.erase("index")
		#dict.land.index[land.index] = data
		dict.island.title[island_title].lands[data.grid] = data
		dict.island.title[island_title].lands[data.grid].erase("grid")
	
	for title in dict.island.title:
		dict.island.title[title].size += Vector2.ONE
	
	dict.crossroads = {}
	dict.crossroads[0] = []
	dict.crossroads[0].append([Vector2(1, 0), Vector2(0, 1)])
	dict.crossroads[0].append([Vector2(1, 1), Vector2(0, 2)])
	dict.crossroads[0].append([Vector2(2, 2), Vector2(1, 3)])
	dict.crossroads[1] = []
	dict.crossroads[1].append([Vector2(1, 0), Vector2(0, 1)])
	dict.crossroads[1].append([Vector2(2, 0), Vector2(1, 1)])
	dict.crossroads[1].append([Vector2(2, 1), Vector2(1, 2)])
	dict.crossroads[1].append([Vector2(3, 1), Vector2(2, 2)])
	dict.crossroads[2] = []
	dict.crossroads[2].append([Vector2(2, 0), Vector2(1, 1)])
	dict.crossroads[2].append([Vector2(2, 0), Vector2(3, 1)])
	dict.crossroads[2].append([Vector2(1, 1), Vector2(2, 2)])
	dict.crossroads[2].append([Vector2(2, 1), Vector2(1, 2)])
	dict.crossroads[2].append([Vector2(0, 2), Vector2(1, 1)])
	#dict.crossroads[2].append([Vector2(1, 1), Vector2(2, 2)])
	#dict.crossroads[1].append([Vector2(2, 0), Vector2(1, 1)])
	#dict.crossroads[2].append([Vector2(3, 0), Vector2(2, 1)])
	#dict.crossroads[2].append([Vector2(1, 1), Vector2(2, 2)])
	#dict.crossroads[2].append([Vector2(2, 1), Vector2(3, 2)])
	dict.crossroads[3] = []
	dict.crossroads[3].append([Vector2(1, 0), Vector2(0, 1)])
	dict.crossroads[3].append([Vector2(2, 1), Vector2(1, 2)])


func init_race() -> void:
	dict.race = {}
	dict.race.title = {}
	var path = "res://asset/json/aoiti_race.json"
	var array = load_data(path)
	
	for race in array:
		if race.available == "yes":
			var data = {}
			data.invasion = {}
			
			for key in race:
				var words = key.split(" ")
				
				if typeof(race[key]) == TYPE_FLOAT:
					race[key] = int(race[key])
				
				if words.has("invasion"):
					data.invasion[words[1]] = race[key]
				else:
					var value = race[key]
					
					match value:
						"no":
							value = false
					
					data[key] = value
					
					if typeof(value) == TYPE_BOOL:
						data.erase(key)
			
			if data.invasion.strength == 0:
				data.erase("invasion")
			
			data.erase("available")
			dict.race.title[data.title] = data
			dict.race.title[data.title].erase("title")


func init_specialization() -> void:
	dict.specialization = {}
	dict.specialization.title = {}
	var path = "res://asset/json/aoiti_specialization.json"
	var array = load_data(path)
	
	for specialization in array:
		if specialization.available == "yes":
			var data = {}
			data.invasion = {}
			
			for key in specialization:
				var words = key.split(" ")
				
				if typeof(specialization[key]) == TYPE_FLOAT:
					specialization[key] = int(specialization[key])
				
				if words.has("invasion"):
					data.invasion[words[1]] = specialization[key]
				else:
					var value = specialization[key]
					
					match value:
						"no":
							value = false
					
					data[key] = value
					
					if typeof(value) == TYPE_BOOL:
						data.erase(key)
			
			if data.invasion.strength == 0:
				data.erase("invasion")
			else:
				arr.invasion.append(data.invasion.land)
			
			if data.has("tax"):
				arr.tax.append(data.tax)
			
			data.erase("available")
			dict.specialization.title[data.title] = data
			dict.specialization.title[data.title].erase("title")


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.sketch = load("res://scene/0/sketch.tscn")
	
	scene.playfield = load("res://scene/1/playfield.tscn")
	scene.island = load("res://scene/1/island.tscn")
	scene.land = load("res://scene/1/land.tscn")
	scene.boundary = load("res://scene/1/boundary.tscn")
	scene.icon = load("res://scene/1/icon.tscn")
	scene.troop = load("res://scene/1/troop.tscn")
	
	scene.fraction = load("res://scene/2/fraction.tscn")
	scene.leader = load("res://scene/2/leader.tscn")
	
	
	pass


func init_vec():
	vec.size = {}
	
	
	vec.size.land = Vector2(num.land.r, num.land.r)
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}
	
	
	color.terrain = {}
	color.terrain["forest"] = Color.from_hsv(120.0/360.0, 0.8, 0.9)
	color.terrain["swamp"] = Color.from_hsv(30.0/360.0, 0.8, 0.9)
	color.terrain["steppe"] = Color.from_hsv(60.0/360.0, 0.8, 0.9)
	color.terrain["hill"] = Color.from_hsv(80.0/360.0, 0.8, 0.9)
	color.terrain["mountain"] = Color.from_hsv(180.0/360.0, 0.2, 0.9)
	color.terrain["pond"] = Color.from_hsv(210.0/360.0, 0.8, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()
