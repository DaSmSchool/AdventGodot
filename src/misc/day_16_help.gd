extends Node

var file: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file = FileAccess.get_file_as_string("res://input/2024/CompareSpots.txt")
	check_stuff(file)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func check_stuff(str: String):
	var fileSplit: PackedStringArray = str.split("\n")
	var file1: String = fileSplit[0]
	var file2: String = fileSplit[1]
	print(file1)
	print(file2)
	var file1Points: Array[Vector2i] = []
	var file2Points: Array[Vector2i] = []
	for sp1: String in file1.split("("):
		if !sp1.contains(","): continue
		var vecStr: String = sp1.substr(0, sp1.find(")"))
		var vecSplit: PackedStringArray = vecStr.split(", ")
		file1Points.append(Vector2i(vecSplit[0].to_int(), vecSplit[1].to_int()))
		print(file1Points.back())
	for sp2: String in file1.split("("):
		if !sp2.contains(","): continue
		var vecStr: String = sp2.substr(0, sp2.find(")"))
		var vecSplit: PackedStringArray = vecStr.split(", ")
		file2Points.append(Vector2i(vecSplit[0].to_int(), vecSplit[1].to_int()))
		print(file2Points.back())
	
	print()
	print("P1 Unique:")
	
	
