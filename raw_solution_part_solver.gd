extends Control
class_name RawSolutionPartSolver

var solvingThread: Thread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	solvingThread = Thread.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func solve_given_solution(scriptPath: String, part: int, adventInput: String) -> void:
	var solutionResource: Resource = load(scriptPath)
	var solutionScript: Solution = solutionResource.new()
	var solutionMethod: Callable = Callable(solutionScript, "solve" + str(part))
	solvingThread.start(solve_thread.bind(solutionMethod, adventInput))
	

func solve_thread(solveMethod: Callable, adventInput: String) -> void:
	var microTime: int
	var postMicroTime: int
	var partSol: String
	
	microTime = Time.get_ticks_msec()
	partSol = str(solveMethod.call(adventInput))
	postMicroTime = Time.get_ticks_msec()
	
	var partElapsed: float = postMicroTime - microTime
	print("PART SOLUTION: %d" % [partSol])
	print("TIME TAKEN:")
	print("MILLISECONDS: %dms" % [partElapsed])
	print("SECONDS: %d seconds" % [partElapsed/1000])
	print()
	
	
	
func _exit_tree() -> void:
	solvingThread.wait_to_finish()
	
