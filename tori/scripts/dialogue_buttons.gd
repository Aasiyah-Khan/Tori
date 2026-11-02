extends Area2D

#Signal for Dialogue Manager
signal choice_selected(choice: String)

#Buttons
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#Button Choice
@export var buttonChoice: String

func _ready() -> void:
	animated_sprite.play("Idle")

func _on_mouse_entered() -> void:
	animated_sprite.play("Hover")


func _on_mouse_exited() -> void:
	animated_sprite.play("Idle")

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		choice_selected.emit(buttonChoice)
		print("Button pressed: ", buttonChoice)
