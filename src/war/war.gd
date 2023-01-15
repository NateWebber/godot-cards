extends Node2D

enum Rank {TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13, ACE = 14}

enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var current_deck
var current_card

func _ready():
	randomize()
	current_deck = Deck.new()
	current_card = current_deck.deal()
	update_card_ui()
 
func _on_DealButton_pressed():
	current_card = current_deck.deal()
	update_card_ui()

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
	$UI/CardImage.texture = load("res://sprites/cards/" + texture_filename) 

