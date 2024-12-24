extends Solution

# dictionary of baked keypad switching value paths
var move: Dictionary = {
	# in the key: first character is from, second character is to
	# in the value: translated movement path
	"A0":"<",
	"A1":"^<<",
	"A2":"^<",
	"A3":"^",
	"A4":"^^<<",
	"A5":"^^<",
	"A6":"^^",
	"A7":"^^^<<",
	"A8":"^^^<",
	"A9":"^^^",
	
	"0A":">",
	"01":"^<",
	"02":"^",
	"03":"^>",
	"04":"^^<",
	"05":"^^",
	"06":"^^>",
	"07":"^^^<",
	"08":"^^^",
	"09":"^^^>",
	
	"1A":">>v",
	"10":">v",
	"12":">",
	"13":">>",
	"14":"^",
	"15":"^>",
	"16":"^>>",
	"17":"^^",
	"18":"^^>",
	"19":"^^>>",
	
	"2A":">v",
	"20":"v",
	"21":"<",
	"23":">",
	"24":"^<",
	"25":"^",
	"26":"^>",
	"27":"^^<",
	"28":"^^",
	"29":"^^>",
	
	"3A":"v",
	"30":"v<",
	"31":"<<",
	"32":"<",
	"34":"<<^",
	"35":"<^",
	"36":"^",
	"37":"^^<<",
	"38":"^^<",
	"39":"^^",
	
	"4A":">>vv",
	"40":">vv",
	"41":"v",
	"42":"v>",
	"43":"v>>",
	"45":">",
	"46":">>",
	"47":"^",
	"48":"^>",
	"49":"^>>",
	
	
	"5A":">vv",
	"50":"vv",
	"51":"v<",
	"52":"v",
	"53":"v>",
	"54":"<",
	"56":">",
	"57":"^<",
	"58":"^",
	"59":"^>",
	
	"6A":"vv",
	"60":"vv<",
	"61":"v<<",
	"62":"v<",
	"63":"v",
	"64":"<<",
	"65":"<",
	"67":"^<<",
	"68":"^<",
	"69":"^",
	
	"7A":">>vvv",
	"70":">vvv",
	"71":"vv",
	"72":"vv>",
	"73":"vv>>",
	"74":"v",
	"75":"v>",
	"76":"v>>",
	"78":">",
	"79":">>",
	
	"8A":">vvv",
	"80":"vvv",
	"81":"vv<",
	"82":"vv",
	"83":"vv>",
	"84":"v<",
	"85":"v",
	"86":"v>",
	"87":"<",
	"89":">",
	
	"9A":">vvv",
	"90":"vvv",
	"91":"vv<",
	"92":"vv",
	"93":"vv>",
	"94":"v<",
	"95":"v",
	"96":"v>",
	"97":"<",
	"98":">",
	
	"A^":"<",
	"A<":"v<<",
	"Av":"v<",
	"A>":"v",
	
	"^A":">",
	"^<":"v<",
	"^v":"v",
	"^>":"v>",
	
	"<A":">>^",
	"<^":">^",
	"<v":">",
	"<>":">>",
	
	"vA":"^>",
	"v^":"^",
	"v<":"<",
	"v>":">",
	
	">A":"^",
	">^":"<^",
	"><":"<<",
	">v":"<"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func solve1(input: String) -> int:
	var solution: int = 0
	
	var inputSplit: PackedStringArray = input.split("\n")
	
	for line: String in inputSplit:
		if line == "": continue
		
	
	return solution


func solve2(input: String) -> int:
	var solution: int = 0
	
	
	
	return solution
