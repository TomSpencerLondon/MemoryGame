"
I am announced when an MGCard disappears from the game (when a matching pair is found).

I am used by MGCard to notify observers (such as UI elements) that the card should be hidden or removed from the display.

See also: MGCard>>disappear

"
Class {
	#name : 'MGCardDisappearAnnouncement',
	#superclass : 'Announcement',
	#category : 'MemoryGame',
	#package : 'MemoryGame'
}

{ #category : 'accessing' }
MGCardDisappearAnnouncement class >> announcer [
	self shouldBeImplemented.
]
