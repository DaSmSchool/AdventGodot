extends Control
class_name VisualizationSubMenu

@export var year: int = 2020
@export var days: int = 25

func _ready() -> void:
	add_year_solutions(year)

func add_year_solutions(year) -> void:
	for day: int in days:
		add_solution(year, day)

func add_solution(year: int, day: int) -> void:
	pass
