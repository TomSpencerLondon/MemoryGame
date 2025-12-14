"
I represent a Memory matching game.

I manage a collection of cards arranged in a grid. Players choose cards to flip, trying to find matching pairs. When two cards with the same symbol are chosen, they disappear (are matched).

Instance Variables:
- availableCards: OrderedCollection of MGCard instances in the game
- chosenCards: OrderedCollection of currently selected (flipped) cards

Example:
    game := MGGame new initializeForSymbols: #($A $B $C $D).
    game gridSize. ""returns 2 (2x2 grid with 8 cards total)""
    game chooseCard: game availableCards first.

Key Methods:
- initializeForSymbols: Creates pairs of cards for each symbol and shuffles them
- chooseCard: Selects a card and flips it
- gridSize: Returns the side length of the square grid
- matchesCount: Returns the number of pairs to find
"
Class {
	#name : 'MGGame',
	#superclass : 'Object',
	#instVars : [
		'availableCards',
		'chosenCards'
	],
	#category : 'Bloc-MemoryGame',
	#package : 'Bloc-MemoryGame'
}

{ #category : 'as yet unclassified' }
MGGame class >> withNumbers [
    ^ self new initializeForSymbols: #(1 2 3 4 5 6 7 8)
]

{ #category : 'initialization' }
MGGame >> availableCards [
	^ availableCards
]

{ #category : 'initialization' }
MGGame >> cardsCount [
	^ availableCards size
]

{ #category : 'initialization' }
MGGame >> chooseCard: aCard [ 
	"Handle card selection with full game logic"
	(self chosenCards includes: aCard) ifTrue: [  ^ self  ].
	chosenCards add: aCard.
	aCard flip.
	self shouldCompleteStep
		ifTrue: [ ^ self completeStep ].
]

{ #category : 'initialization' }
MGGame >> chosenCardMatch [
	| firstCard |
	firstCard := self chosenCards first.
	^ self chosenCards allSatisfy: [ :aCard | 
	  aCard isFlipped and: [ firstCard symbol = aCard symbol ] ]
]

{ #category : 'initialization' }
MGGame >> chosenCards [
	^ chosenCards
]

{ #category : 'initialization' }
MGGame >> completeStep [
	self chosenCards 
		do: [  :aCard | aCard disappear ];
		removeAll.
]

{ #category : 'initialization' }
MGGame >> gridSize [
	^ (availableCards size sqrt) asInteger
]

{ #category : 'initialization' }
MGGame >> initialize [
	super initialize.
	availableCards := OrderedCollection new.
	chosenCards := OrderedCollection new 
]

{ #category : 'initialization' }
MGGame >> initializeForSymbols: aCollection [
    | cards |
    cards := (aCollection , aCollection)
        collect: [ :symbol | MGCard new symbol: symbol ].
    availableCards := cards shuffled
]

{ #category : 'initialization' }
MGGame >> matchesCount [
	^ availableCards size / 2
]

{ #category : 'initialization' }
MGGame >> resetStep [
	| lastCard |
	lastCard := self chosenCards last.
	self chosenCards
		allButLastDo: [ :aCard | aCard flip ];
		removeAll;
		add: lastCard
]

{ #category : 'initialization' }
MGGame >> shouldCompleteStep [
	^ self chosenCards size = self matchesCount
	  and: [ self chosenCardMatch ]
]

{ #category : 'initialization' }
MGGame >> shouldResetStep [
	^ self chosenCards size > self matchesCount
]
