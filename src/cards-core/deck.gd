extends Node
class_name Deck

enum Rank {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE}

enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var deck: Array

func _init():
	for rank in Rank.values():
		for suit in Suit.values():
			print("making card: [" + str(rank) + ", " + str(suit) + "]")
			deck.append(Card.new(rank, suit))
	shuffle()

# Fisher-Yates shuffle
func shuffle():
	for i in range (deck.size() - 1, 1, -1):
		#("shufflin")
		var rand = randi() % (i + 1)
		var temp = deck[rand]
		deck[rand] = deck[i]
		deck[i] = temp

func deal() -> Card:
	return deck.pop_front()
	
