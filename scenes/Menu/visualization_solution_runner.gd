extends Node
class_name VisualizationRunner

signal visualization_exited

func _ready() -> void:
	pass

func clear_current_visualization() -> void:
	var children: Array = get_children(true)
	for child: Node in children:
		child.queue_free()

func run_visualization(scene: PackedScene) -> void:
	clear_current_visualization()
	var visualizationScene: Visualization = scene.instantiate()
	add_child(visualizationScene)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_visualization"):
		visualization_exited.emit()
		clear_current_visualization()
		print("visualization_exited")
