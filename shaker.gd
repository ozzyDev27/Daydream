extends Node2D  # Or whatever node you attach it to (like Camera2D, Sprite, etc.)

@export var shake_intensity: float = 8.0   # Max distance to move from original position
@export var shake_speed: float = 15.0       # How quickly the shake moves
@export var decay: float = 5.0              # How quickly the shake effect fades

var _original_position: Vector2
var _time: float = 0.0
var _current_intensity: float = 0.0

func _ready():
	_original_position = position
	start_shake()

func start_shake(intensity: float = shake_intensity):
	_current_intensity = intensity

func _process(delta: float):
	if _current_intensity > 0.0:
		_time += delta * shake_speed
		var offset = Vector2(
			randf_range(-_current_intensity, _current_intensity),
			randf_range(-_current_intensity, _current_intensity)
		)
		position = _original_position + offset

		# Decay shake over time
		_current_intensity = max(_current_intensity - decay * delta, 0.0)
	else:
		# Reset to original position once shaking stops
		position = _original_position
	
	$Timer.start()


func _on_timer_timeout() -> void:
	start_shake()
