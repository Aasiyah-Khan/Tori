extends Sprite3D

#These will be declared in the inpspector
@export var player: CharacterBody3D

#Speed of NPC
const SPEED = 1

#Bools
var can_move = false

#NPC Sprites
@onready var npc_test: Sprite3D = $"."

#Timer for NPC Spawn (We will just make the sprite visible)
@onready var spawn_timer: Timer = $SpawnTimer

#For Timer
var timeNumber = 0

#Reference for Dialogue Manager
@onready var dialogue_manager: CanvasLayer = $"../DialogueManager"

#Reference for Dialogue Data
@export var dialogue_data: DialogueData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_test.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move == true:
		npc_test.position.z += SPEED * delta
	
	if dialogue_manager.branchDialogueFinished == true:
		npc_test.hide()
		can_move = false


func _on_spawn_timer_timeout() -> void:
	timeNumber += 1
	
	if timeNumber == 1:
		npc_test.show()
		can_move = true


func _on_area_3d_body_entered(body):
	if body == player: #if the body detected is the player run this code:
		can_move = false
		
		#Specific resource for this npc with its specific dialogue will be used for this convo
		#AND Start dialogue with this resource!
		dialogue_manager.startDialogue(dialogue_data)
