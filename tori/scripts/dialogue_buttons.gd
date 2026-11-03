extends Area2D

#Signal for Dialogue Manager
#choice_selected is the name of the signal 
#choice: String means the signal sends a piece of text along with it
#These are "YES" or "NO" (which we will change later to color coded
#BUT you can see these in the inspector of YesButton and NoButton
signal choice_selected(choice: String)
#THIS ALLOWS FOR SCRIPTS TO SEND MESSAGES TO EACH OTHER
#SOO CHOICE SELECTED IS OF COURSE WHAT BUTTON DID YOU CHOOSE
#AND DEPENDING ON WHAT YOU CLICKED (GREEN OR RED) THIS SCRIPT SENDS THAT MESSAGE
#TO DIALOGUE MANAGER (I RESEARCHED A BIT FOR THIS BUT IT HELPED ME A LOT)

# -- IMPORTANT --
#FINALLY IN DIALOGUE MANAGER, It will have a function that will receive this signal

#Buttons
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#These are references and stuff do basic stuff

#Button Choice
@export var buttonChoice: String
# @export allows us to enter our own data in the inspector instead of hard coding it
#this will be the message we send to dialogue manager script which is a string
#A function will in dialogue manager will receive this like I said before tho

func _ready() -> void:
	animated_sprite.play("Idle") #Idle Animation of the buttons (just 1 frame lol if you check the animation player)

#This is a signal/function (Godot automically does the code for you but it detects when the mouse enters the area2d (buttons area)
func _on_mouse_entered() -> void:
	animated_sprite.play("Hover") #Same thing but more frames
#You see that green arrow thing (it means the signal is connected which needs to be done or else this function won't know what area we're referring to (which is the yesbutton and no button)

#Same thing as enter but this time detects the exit
func _on_mouse_exited() -> void:
	animated_sprite.play("Idle") #It goes back to the idle 1 frame image

#Don't be scared of the function, it's the same as the ones before and just a signal 
#Of course it's used to detect inputs (so our mouse click)
#The arguements:
#Viewport - What screen is the input being displayed in (our game window lol)
#Event - mouse click
#shape_idx - checks what collision shape received the event
#These are automically writen by godot btw
func _on_input_event(viewport, event, shape_idx): #We're only gonna use event
	if event.is_action_pressed("mouse_click"): #"mouse_click" is an input action i made so if you go to project setting and input map YOU WILL SEE IT
		choice_selected.emit(buttonChoice) #choice_selected signal emits the string "buttonChoice (which is yes or no)
		print("Button pressed: ", buttonChoice) #Was used for testing
