extends Node
class_name AdventMenuControl

func run_raw_advent_solution(path: String) -> void:
	$VisualizationsMenu.hide()
	$RawSolutionRunner.show()
	$RawSolutionRunner.run_solutions(path)

func run_advent_visualization(path: String) -> void:
	$VisualizationsMenu.show_visualization_loading()
	print(ResourceLoader.exists(path))
	path = path.substr(6)
	print(ResourceLoader.exists(path))
	var requestResult: Error = ResourceLoader.load_threaded_request(path)
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		pass
	var result = ResourceLoader.load_threaded_get_status(path)
	assert(result == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED, "SOMETHING HAPPENED WHILE LOADING VISUALIZATION")
	var visualization = ResourceLoader.load_threaded_get(path)
	$VisualizationsMenu.hide()
	$VisualizationSolutionRunner.show()
	$VisualizationSolutionRunner.run_visualization(visualization)

func leave_visualization() -> void:
	$VisualizationsMenu.show()
	$VisualizationsMenu.hide_visualization_loading()
	$VisualizationSolutionRunner.hide()

func raw_solution_to_menu() -> void:
	$VisualizationsMenu.show()
	$RawSolutionRunner.hide()


func _on_visualization_solution_runner_visualization_exited() -> void:
	leave_visualization()
