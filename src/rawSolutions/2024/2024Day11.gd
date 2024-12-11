extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var store1: Dictionary = {}
var store2: Dictionary = {}

func rec_rock(num: int, cache: Dictionary, trackAnswer: int) -> int:
	if trackAnswer == 0: 
		#print(num)
		return 1
	if cache.has([num, trackAnswer]): return cache[[num, trackAnswer]]
	
	var totalRocks: int = 0
	
	var numStr: String = str(num)
	
	
	if num == 0:
		var addVal: int = rec_rock(1, cache, trackAnswer-1)
		totalRocks += addVal
		cache.get_or_add([num, trackAnswer], addVal)
	elif numStr.length() % 2 == 1:
		var addVal: int = rec_rock(num*2024, cache, trackAnswer-1)
		totalRocks += addVal
		cache.get_or_add([num, trackAnswer], addVal)
	else:
		var num1: int = numStr.substr(0, numStr.length()/2).to_int()
		var num2: int = numStr.substr(numStr.length()/2).to_int()
		var addVal = 0
		addVal += rec_rock(num1, cache, trackAnswer-1)
		addVal += rec_rock(num2, cache, trackAnswer-1)
		totalRocks += addVal
		cache.get_or_add([num, trackAnswer], addVal)
	
	return totalRocks

func solve1(input: String) -> int:
	var solution: int = 0
	
	var assembleArr: Array[int] = []
	
	for num in input.split("\n")[0].split(" "):
		assembleArr.append(num.to_int())
	
	
	for num: int in assembleArr:
		solution += rec_rock(num, store1, 25)
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	var assembleArr: Array[int] = []
	
	for num in input.split("\n")[0].split(" "):
		assembleArr.append(num.to_int())
	
	
	for num: int in assembleArr:
		solution += rec_rock(num, store1, 75)
	
	return solution
