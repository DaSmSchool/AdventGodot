extends Node
class_name Solution

signal log_messages(messages: PackedStringArray)

var logQueue: PackedStringArray = []
var logMutex: Mutex = Mutex.new()


func flush_logs(logs: PackedStringArray) -> void:
	logMutex.lock()
	log_messages.emit(logQueue.duplicate())
	logQueue = []
	logMutex.unlock()

func _process(delta: float) -> void:
	flush_logs(logQueue)

func print_log(message: String) -> void:
	logMutex.lock()
	logQueue.append(message)
	logMutex.unlock()

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
