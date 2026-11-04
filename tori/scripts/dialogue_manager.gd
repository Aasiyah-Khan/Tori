extends CanvasLayer

#Dialogue Stuff
@onready var dialogueBox: Control = $DialogueBox
@onready var dialogueText: Label = $DialogueBox/DialogueText

#Dialogue Buttons
@onready var green_button: Area2D = $ButtonContainer/GreenButton
@onready var red_button: Area2D = $ButtonContainer/RedButton

#Dialogue Choices
#Green or Red
var currentDialogueData: DialogueData #This is the class name thats in dialogue data script

#Check if choices should appear
var showChoicesAfterDialogue: bool = false

#Timer for Typing Animation
@onready var timer: Timer = $Timer

#Array Organiztion
var dialogueLines: Array[String] = []
var currentLineIndex: int = 0
var isDialogueActive: bool = false

#Will be used to make dialogueBox disappear after convo is over
#Checks when convo is over
#Also allows the npc to disappear as well
var branchDialogueFinished: bool = false #tracks whether the GREEN or RED response dialogue has finished
var isBranchDialogue: bool = false #checks whether the player is currently reading a response dialogue

#ANIMATION FOR PPL POPPING UP LIKE PERSONA

#NPC Images
@onready var npc_1: TextureRect = $"NPC Images/NPC1"
@onready var advisor_npc: TextureRect = $"NPC Images/AdvisorNPC"

#Animation Players
@onready var npc_1_animation_player: AnimationPlayer = $NPC1_AnimationPlayer
@onready var advisor_npc_animation_player: AnimationPlayer = $AdvisorNPC_AnimationPlayer


#Choice Text
@onready var green_text: Label = $ChoiceText/GreenText
@onready var red_text: Label = $ChoiceText/RedText

func _ready() -> void:
	#Controlling UI
	dialogueBox.visible = false
	green_button.visible = false
	red_button.visible = false
	
	npc_1.hide()
	advisor_npc.hide()
	
	green_text.hide()
	red_text.hide()
	
	#Connect button signals
	#THIS IS WHERE WE GET THE SIGNAL FROM THE BUTTONS AND ITS THEN CONNECTED TO THIS FUNCTION IN THE ()
	green_button.choice_selected.connect(_on_dialogue_button_selected)
	red_button.choice_selected.connect(_on_dialogue_button_selected)

#data: DialogueData means the function receives a DialogueData Resource (it can be multiple and you can assign resources to different npc's)
#A resource is like a regular node but it contains the dialogue for us and we can edit it in the inspector
#The resource's behaviors are edited in the dialogue_data script
func startDialogue(data: DialogueData):
	currentDialogueData = data #initialization, it sends the npc's dialogue information into your DialogueManager
	branchDialogueFinished = false #no branch dialogue finished
	isBranchDialogue = false #we are not reading a green or red response

	dialogueLines = data.openingDialogue #Opening dialogue is shown first and we store its dialogue into the array
	currentLineIndex = 0 #we start at the beginning of course
	isDialogueActive = true #used to control input like our mouse clicks and makes dialogue active
	showChoicesAfterDialogue = true #tells the dialogue system that GREEN and RED choices should appear after the opening dialogue
	
	#UI Control
	dialogueBox.visible = true
	green_button.visible = false
	red_button.visible = false
	green_text.hide()
	red_text.hide()
	
	#NPC Pop Up Animation
	npc_1.show()
	advisor_npc.show()
	
	npc_1_animation_player.play("pop_up")
	advisor_npc_animation_player.play("pop_up")

	dialogueText.text = dialogueLines[currentLineIndex]
	dialogueText.visible_characters = 0
	timer.start()


func _input(event):
	if not isDialogueActive:
		return

	if event.is_action_pressed("mouse_click"):
		#Don't advance dialogue when buttons are visible
		if green_button.visible or red_button.visible:
			return

		#Check if the dialogue is still typing
		if dialogueText.visible_ratio < 1:
			dialogueText.visible_characters = -1
			timer.stop()
			return

		#Check if this is the final sentence
		if currentLineIndex == dialogueLines.size() - 1:
			if showChoicesAfterDialogue == true:
				green_button.visible = true
				red_button.visible = true

				green_text.text = currentDialogueData.greenChoiceText
				red_text.text = currentDialogueData.redChoiceText
				
				green_text.show()
				red_text.show()
			else:
				advanceDialogue()

		else:
			advanceDialogue()


func advanceDialogue():
	if currentLineIndex < dialogueLines.size() - 1:
		currentLineIndex += 1

		dialogueText.text = dialogueLines[currentLineIndex]

		#Reset typing animation
		dialogueText.visible_characters = 0

		#Start typing again
		timer.start()

	else:
		isDialogueActive = false
		showChoicesAfterDialogue = false
		dialogueBox.visible = false
		green_button.visible = false
		red_button.visible = false
		green_text.hide()
		red_text.hide()
		timer.stop()
		
		#Check if the YES or NO dialogue has finished
		if isBranchDialogue == true:
			npc_1_animation_player.play("pop_down")
			advisor_npc_animation_player.play("pop_down")
			await npc_1_animation_player.animation_finished
			#We really only need one animation to stop playing since they have the same animation time

			npc_1.hide()
			advisor_npc.hide()
			dialogueBox.hide()
			green_button.hide()
			red_button.hide()

			branchDialogueFinished = true


func _on_timer_timeout() -> void:
	if dialogueText.visible_characters < dialogueText.get_total_character_count():
		dialogueText.visible_characters += 1

	else:
		timer.stop()
	
	#Only show choices after the final sentence has finished typing
	if currentLineIndex == dialogueLines.size() - 1 and dialogueText.visible_ratio >= 1:
		if showChoicesAfterDialogue == true:
			green_button.visible = true
			red_button.visible = true

			green_text.text = currentDialogueData.greenChoiceText
			red_text.text = currentDialogueData.redChoiceText

			green_text.show()
			red_text.show()


func _on_dialogue_button_selected(choice: String) -> void:
	#Testing
	print("Dialogue Manager received: ", choice)

	#Hide the choice text after a button is selected
	green_text.hide()
	red_text.hide()

	if choice == "GREEN":
		playBranchDialogue(currentDialogueData.yesDialogue)
		
	elif choice == "RED":
		playBranchDialogue(currentDialogueData.noDialogue)


func playBranchDialogue(lines: Array[String]):
	if lines.is_empty():
		print("There is no dialogue")
		return
	
	showChoicesAfterDialogue = false
	isBranchDialogue = true
	
	dialogueLines = lines
	currentLineIndex = 0

	green_button.visible = false
	red_button.visible = false
	green_text.hide()
	red_text.hide()
	
	dialogueText.show() #Show regular dialogue again

	dialogueText.text = dialogueLines[currentLineIndex]
	dialogueText.visible_characters = 0

	isDialogueActive = true
	branchDialogueFinished = false
	timer.start()
