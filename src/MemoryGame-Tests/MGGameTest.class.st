Class {
	#name : 'MGGameTest',
	#superclass : 'TestCase',
	#category : 'MemoryGame-Tests',
	#package : 'MemoryGame-Tests'
}

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
