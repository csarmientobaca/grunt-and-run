extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("")
	print("=== Dashboard started ===")

	var dashboard_result: Dictionary = await NakamaService.get_dashboard()

	print("DASHBOARD DATA")
	print(NakamaService.pretty(dashboard_result))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
