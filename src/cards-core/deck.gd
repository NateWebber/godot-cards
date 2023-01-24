extends Node
class_name Deck

enum Rank {TWO = 2, THREE = 3, FOUR = 4, FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8, NINE = 9, TEN = 10, JACK = 11, QUEEN = 12, KING = 13, ACE = 14}
enum Suit {CLUBS, DIAMONDS, HEARTS, SPADES}

var deck: Array

func _init(provided_cards = null):
	if provided_cards == null:
		for rank in Rank.values():
			for suit in Suit.values():
				#print("making card: [" + str(rank) + ", " + str(suit) + "]")
				deck.append(Card.new(rank, suit))
		shuffle()
	else:
		deck = provided_cards

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
	
