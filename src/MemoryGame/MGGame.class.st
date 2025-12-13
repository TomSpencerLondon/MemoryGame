Class {
	#name : 'MGGame',
	#superclass : 'Object',
	#instVars : [
		'availableCards',
		'chosenCards'
	],
	#category : 'MemoryGame',
	#package : 'MemoryGame'
}

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
	(chosenCards includes: aCard) ifTrue: [  ^ self  ].
	chosenCards add: aCard.
	aCard flip
]

{ #category : 'initialization' }
MGGame >> chosenCards [
	^ chosenCards
]

{ #category : 'initialization' }
MGGame >> gridSize [
	^ availableCards size sqrt asInteger
]

{ #category : 'initialization' }
MGGame >> initialize [
	super initialize.
	availableCards := OrderedCollection new.
	chosenCards := OrderedCollection new 
]

{ #category : 'initialization' }
MGGame >> initializeForSybols: aCollection [ 
	| cards |
	cards := (aCollection , aCollection)
		collect: [  :symbol | MGCard new symbol: symbol ].
	availableCards := cards shuffled
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
