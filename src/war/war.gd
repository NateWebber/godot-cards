extends Node2D

enum Rank {TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13, ACE = 14}

enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var current_deck
var current_card

var full_ui_deck = []
var player_one_ui_deck = []
var player_two_ui_deck = []

const UICard = preload("res://src/cards-core/UICard.tscn")

onready var DeckSpawnPos = $DeckSpawnPoint
onready var DeckDealAnchor1 = $DeckDealAnchor1
onready var DeckDealAnchor2 = $DeckDealAnchor2
onready var P1DeckAnchor = $P1DeckAnchor
onready var P2DeckAnchor = $P2DeckAnchor

export var CARD_ANIM_SPEED = 20

signal deck_spawn_anim_complete

func _ready():
	randomize()
	current_deck = Deck.new()
	current_card = current_deck.deal()
	do_start_animations()
	
func _wait(seconds):
	print("waiting")
 
func _on_DealButton_pressed():
	current_card = current_deck.deal()

func update_card_ui():
	# card textures follow format of card[SUIT][RANK].png, where rank is either the number of initial of the face card's
	print("current card: " + str(current_card.rank) + " " + str(current_card.suit)) 
	var initial = ""
	if (current_card.rank >= 11):
		match current_card.rank:
			11:
				initial = "J"
			12:
				initial = "Q"
			13:
				initial = "K"
			14:
				initial = "A"
	else:
		initial = str(current_card.rank)
	var texture_filename = "card%s%s.png" % [Suit.keys()[current_card.suit].capitalize(), initial]
	current_card.print_name()
	print("trying for filename: " + "res://sprites/cards/" + texture_filename)
	$UI/MasterContainer/GameContainer/CardImage.texture = load("res://sprites/cards/" + texture_filename) 
	
	
func do_start_animations():
	draw_ui_deck()
	yield(self, "deck_spawn_anim_complete")
	do_deck_split_anim()
	
func draw_ui_deck():
	for i in range(52):
		var newUICard = UICard.instance()
		newUICard.set_position(Vector2(DeckSpawnPos.position.x + (i * 0.5), DeckSpawnPos.position.y))
		add_child(newUICard)
		full_ui_deck.append(newUICard)
	#first animation stage, fly up from bottom
	while full_ui_deck[51].position.y > DeckDealAnchor1.position.y:
		print(full_ui_deck[51].position.y)
		#move all cards before yield so that animation is simultaneous
		for i in range(52):
			full_ui_deck[i].position.y -= CARD_ANIM_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	#second animation stage, fly over to left of screen
	while full_ui_deck[51].position.x > DeckDealAnchor2.position.x:
		#move all cards before yield so that animation is simultaneous
		for i in range(52):
			full_ui_deck[i].position.x -= CARD_ANIM_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	#signal this animation is done
	emit_signal("deck_spawn_anim_complete")
	pass
	
func do_deck_split_anim():
	for i in range(51, -1, -1):
		var current_ui_card = full_ui_deck[i]
		#redo horizontal adjustment (may look weird/need further attention)
		current_ui_card.position.x = P1DeckAnchor.position.x + 26 - (0.5 * i) #this specifically is dumb and ugly, or maybe it's the layers actually
		if (i % 2 == 0):
			player_one_ui_deck.append(current_ui_card)
			while (current_ui_card.position.y < P1DeckAnchor.position.y):
				current_ui_card.position.y += CARD_ANIM_SPEED
				yield(get_tree().create_timer(0.01), "timeout")
		else:
			player_two_ui_deck.append(current_ui_card)
			while (current_ui_card.position.y > P2DeckAnchor.position.y):
				current_ui_card.position.y -= CARD_ANIM_SPEED
				yield(get_tree().create_timer(0.01), "timeout")
			
	pass

