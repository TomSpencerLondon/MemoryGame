"
I am the visual board for the Memory Game, displaying a grid of cards.

I am a BlElement subclass that uses BlGridLayout to arrange MGCardElements in a square grid (typically 4x4 for 16 cards / 8 pairs).

Instance Variables:
    memoryGame - the MGGame model that holds the game state and logic

Usage:
    | space game gameElement |
    game := MGGame new initializeForSymbols: #(1 2 3 4 5 6 7 8).
    gameElement := MGGameElement new.
    gameElement memoryGame: game.
    space := BlSpace new.
    space root addChild: gameElement.
    space extent: 500@500.
    space show.

Key Methods:
    memoryGame: - sets the game model and creates MGCardElement children for each card

Collaborators:
    MGGame - the model providing card data and game logic
    MGCardElement - the visual representation of each card
    BlGridLayout - arranges cards in rows and columns
"
Class {
	#name : 'MGGameElement',
	#superclass : 'BlElement',
	#instVars : [
		'memoryGame'
	],
	#category : 'MemoryGame',
	#package : 'MemoryGame'
}

{ #category : 'accessing' }
MGGameElement >> initialize [
    super initialize.
    self background: Color veryLightGray.
    self layout: (BlGridLayout horizontal cellSpacing: 20).
    self constraintsDo: [ :c | 
        c horizontal fitContent.
        c vertical fitContent ]
]

{ #category : 'accessing' }
MGGameElement >> memoryGame [
	^ memoryGame
]

{ #category : 'accessing' }
MGGameElement >> memoryGame: aGameModel [
    memoryGame := aGameModel.
    self layout columnCount: memoryGame gridSize.
    memoryGame availableCards do: [ :aCard | 
        | cardElement |
        cardElement := MGCardElement new.
        cardElement memoryGame: memoryGame.
        cardElement card: aCard.
        self addChild: cardElement ]
]
