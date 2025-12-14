Class {
	#name : 'MGGameElement',
	#superclass : 'BlElement',
	#instVars : [
		'memoryGame'
	],
	#category : 'Bloc-Memory',
	#package : 'Bloc-Memory'
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
        cardElement card: aCard.
        self addChild: cardElement ]
]
