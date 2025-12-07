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
MGGame >> chosenCards [
	^ chosenCards
]

{ #category : 'initialization' }
MGGame >> initialize [
	super initialize.
	availableCards := OrderedCollection new.
	chosenCards := OrderedCollection new 
]
