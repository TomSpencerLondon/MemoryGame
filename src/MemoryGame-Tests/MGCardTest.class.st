Class {
	#name : 'MGCardTest',
	#superclass : 'TestCase',
	#category : 'MemoryGame-Tests',
	#package : 'MemoryGame-Tests'
}

{ #category : 'tests' }
MGCardTest >> testCardHasSymbol [
	| card |
	card := MGCard new symbol: $A.
	self assert: card symbol equals: $A
]

{ #category : 'tests' }
MGCardTest >> testCardIsNotFlippedInitially [
	| card |
	card := MGCard new.
	self deny: card isFlipped
]
