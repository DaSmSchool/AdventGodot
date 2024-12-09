extends Node2D

var winSize: Vector2

var pointSpots: Array[Vector2] = [
	Vector2(50, 50),
	Vector2(150, 150),
	Vector2(250, 150),
	Vector2(150, 350),
	Vector2(30, 350),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	winSize = get_window().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	winSize = get_window().size
	
	queue_redraw()


func _draw() -> void:
	
	for pointInd: int in range(0, pointSpots.size()-1):
		draw_line(pointSpots[pointInd], pointSpots[pointInd+1], Color("#1133BB"), 5, true)
	for pointInd: int in range(0, pointSpots.size()):
		draw_circle(pointSpots[pointInd], 25, Color("#3355DD"), true, -1, true)
