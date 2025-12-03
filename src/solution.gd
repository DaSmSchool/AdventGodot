extends Node
class_name Solution

signal log_messages(messages: PackedStringArray)

var logQueue: PackedStringArray = []
var logMutex: Mutex = Mutex.new()

func transfer_logs() -> PackedStringArray:
	logMutex.lock()
	var newLog: PackedStringArray = logQueue.duplicate()
	logQueue = []
	logMutex.unlock()
	return newLog

func flush_logs() -> void:
	log_messages.emit(transfer_logs())
	

func _process(delta: float) -> void:
	flush_logs()

func print_log(message: Variant) -> void:
	logMutex.lock()
	logQueue.append(str(message))
	logMutex.unlock()

func solve1(input: String) -> Variant:
	var solution: int = 0
	
	return solution

func solve2(input: String) -> Variant:
	var solution: int = 0
	
	return solution
