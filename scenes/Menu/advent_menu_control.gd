extends Node
class_name AdventMenuControl

func run_raw_advent_solution(path: String) -> void:
	$VisualizationsMenu.hide()
	$RawSolutionRunner.show()
	$RawSolutionRunner.run_solutions(path)
