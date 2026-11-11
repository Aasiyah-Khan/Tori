extends CanvasLayer

#Dialogue Stuff
@onready var dialogueBox: Control = $DialogueBox
@onready var dialogueText: Label = $DialogueBox/DialogueText

#Timer for Typing Animation
@onready var timer: Timer = $"../Timer"

#Typing Audio
@onready var typing_audio: AudioStreamPlayer2D = $"../TypingAudio"

#Animation Player for Title
@onready var tori_animation: AnimationPlayer = $"../ToriAnimation"

#Button
@onready var start_button: Button = $StartButton

#Tori Label
@onready var tori: Label = $TORI

#Dialogue Array
var dialogueLines: Array[String] = [
	"Hello there!",
	"Welcome to our prototype!",
	"We are currently still in development but we hope you enjoy!"
]

#Current Dialogue Line
var currentLineIndex: int = 0

#Checks if Dialogue is Active
var isDialogueActive: bool = false


func _ready() -> void:
	
	#Hide Dialogue Box
	dialogueBox.hide()
	
	#Hide Button
	start_button.hide()
	
	#Hide Tori Title
	tori.hide()
	
	#Automatically Start Dialogue
	startDialogue()


func startDialogue():
	dialogueBox.show()
	
	isDialogueActive = true
	
	currentLineIndex = 0
	
	#Display First Dialogue
	dialogueText.text = dialogueLines[currentLineIndex]
	dialogueText.visible_characters = 0
	
	#Start Typing Animation
	timer.start()


func _input(event):
	if not isDialogueActive:
		return
	
	if event.is_action_pressed("mouse_click"):
		
		#Check if Dialogue is Still Typing
		if dialogueText.visible_ratio < 1:
			dialogueText.visible_characters = -1 #Show all the char in the text immediately
			timer.stop()
			return
		
		#Check if There Are More Dialogue Lines
		#-1 since we start the counting at 0 
		if currentLineIndex < dialogueLines.size() - 1:
			advanceDialogue()
		
		else:
			#Dialogue is Finished
			isDialogueActive = false
			dialogueBox.hide()
			timer.stop()
			
			#Show Title Card
			tori_animation.play("fade_in")
			tori.show()
			start_button.show()


func advanceDialogue():
	currentLineIndex += 1
	
	#Updates to the next Line
	dialogueText.text = dialogueLines[currentLineIndex]
	
	#Reset Typing Animation
	dialogueText.visible_characters = 0
	
	#Start Typing Again
	timer.start()


func _on_timer_timeout() -> void:
	#get_total_character function -- > Gets the total number of characters in the Label
	if dialogueText.visible_characters < dialogueText.get_total_character_count(): #dialogueText is the current line we're on
		
		dialogueText.visible_characters += 1
		#Increase the words by 1
		
		#Play Typing Audio
		typing_audio.play()
		
	else:
		timer.stop() #Once all the words in the line have filled up the label
