extends Node
class_name AdventMenuControl

func run_raw_advent_solution(path: String) -> void:
	$RawSolutionRunner.run_solutions(path)
