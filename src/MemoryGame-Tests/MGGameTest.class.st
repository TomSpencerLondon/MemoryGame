Class {
	#name : 'MGGameTest',
	#superclass : 'TestCase',
	#category : 'MemoryGame-Tests',
	#package : 'MemoryGame-Tests'
}

{ #category : 'tests' }
MGGameTest >> testCardsCount [
	| game |
	game := MGGame new initializeForSymbols: #($A $B $C $D $E $F $G $H).
	self assert: game gridSize equals: 4
]

{ #category : 'tests' }
MGGameTest >> testGameHasAvailableCards [
	| game |
	game := MGGame new.
	self assert: game availableCards isCollection
]

{ #category : 'tests' }
MGGameTest >> testGameHasChosenCards [
	| game |
	game := MGGame new.
	self assert: game chosenCards isEmpty
]

{ #category : 'tests' }
MGGameTest >> testGridSize [
	| game |
	game := MGGame new initializeForSybols: #($A $B $C $D $E $F $G $H).
	self assert: game cardsCount equals: 16
]

{ #category : 'tests' }
MGGameTest >> testMatchesCount [
	| game |
	game := MGGame new initializeForSymbols: #($A $B $C $D $E $F $G $H).
	self assert: game matchesCount equals: 8
]
