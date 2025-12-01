extends Control
class_name RawSolutionPartSolver

@onready var logLabel: RichTextLabel = $VBoxContainer/ScrollContainer/LogMessages

var solvingThread: Thread

var solutionMutex: Mutex
var solutionDisplay: Label

var millisecondsTaken: int = 0
var startingMicroTime: int = 0
var currentMicroTime: int = 0
var timeChanging: bool = false
var timeDisplay: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	solvingThread = Thread.new()
	solutionMutex = Mutex.new()
	solutionDisplay = %SolutionDisplay
	timeDisplay = %TimeMsDisplay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timeChanging:
		currentMicroTime = Time.get_ticks_msec()
		millisecondsTaken = currentMicroTime - startingMicroTime
	set_time_text(millisecondsTaken)

func add_logs(messages: PackedStringArray) -> void:
	var totalLog: String = ""
	for message: String in messages:
		totalLog += message + "\n"
	logLabel.text += totalLog

func solve_given_solution(scriptPath: String, part: int, adventInput: String) -> void:
	var solutionResource: Resource = load(scriptPath)
	var solutionScript: Solution = solutionResource.new()
	add_child(solutionScript)
	solutionScript.log_messages.connect(add_logs)
	var solutionMethod: Callable = Callable(solutionScript, "solve" + str(part))
	startingMicroTime = Time.get_ticks_msec()
	timeChanging = true
	solvingThread.start(solve_thread.bind(solutionMethod, adventInput))
	

func solve_thread(solveMethod: Callable, adventInput: String) -> void:
	var microTime: int
	var postMicroTime: int
	var partSol: String
	
	microTime = Time.get_ticks_msec()
	partSol = str(solveMethod.call(adventInput))
	postMicroTime = Time.get_ticks_msec()
	
	var partElapsed: int = postMicroTime - microTime
	print("PART SOLUTION: %s" % [partSol])
	print("TIME TAKEN:")
	print("MILLISECONDS: %dms" % [partElapsed])
	print("SECONDS: %d seconds" % [partElapsed/1000.0])
	print()
	
	timeChanging = false
	millisecondsTaken = partElapsed
	
	call_deferred("set_solution_text", partSol)
	
	
	

func set_solution_text(solution: String) -> void:
	solutionMutex.lock()
	solutionDisplay.text = solution
	solutionMutex.unlock()

func set_time_text(ms: int) -> void:
	timeDisplay.text = str(ms) + "ms"

func _on_copy_button_pressed() -> void:
	solutionMutex.lock()
	DisplayServer.clipboard_set(solutionDisplay.text)
	solutionMutex.unlock()

func _exit_tree() -> void:
	solvingThread.wait_to_finish()
