extends Sprite

enum Rank {TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13, ACE = 14}
enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var CARD_ANIM_FLIP_SPEED = 0.07

signal flip_finished

func set_card_image(game_card: Card):
	# card textures follow format of card[SUIT][RANK].png, where rank is either the number of initial of the face card's
	var initial = ""
	if (game_card.rank >= 11):
		match game_card.rank:
			11:
				initial = "J"
			12:
				initial = "Q"
			13:
				initial = "K"
			14:
				initial = "A"
	else:
		initial = str(game_card.rank)
	var texture_filename = "card%s%s.png" % [Suit.keys()[game_card.suit].capitalize(), initial]
	print("trying for filename: " + "res://sprites/cards/" + texture_filename)
	self.texture = load("res://sprites/cards/" + texture_filename) 

#if not provided with a game card to target, will set texture to card back
func do_flip_anim(game_card: Card = null):
	while self.scale.x > 0:
		self.scale.x -= CARD_ANIM_FLIP_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	if game_card == null:
		self.texture = load("res://sprites/cards/cardBack_red2.png")
	else:
		set_card_image(game_card)
	while self.scale.x < 1:
		self.scale.x += CARD_ANIM_FLIP_SPEED
		yield(get_tree().create_timer(0.01), "timeout")
	emit_signal("flip_finished")
	pass
