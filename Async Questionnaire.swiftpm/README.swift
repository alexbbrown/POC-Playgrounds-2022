/**

 Test to see if I can convert an actor 'state machine' and link its async operations to a view moving through some sort of wizard.
 
 Knock Knock!

 Possible enhancements
 
 can I make it generic?
 do I need a fixed sheet?
 does it always have to be a sheet?
 
 can a result builder generate ASYNC code?
 can a result builder build VIEWs at the SAME TIME as ASYNC code?
 
 can I make it composable - is the result of the *whole* questionnaire a value which is itself an 'answer'?  would require arbitrary type handling.  For example, after collecting details of a user, 'return' a new user record. 
 
 Log: 
 
 updated swiftUI code to use modern confirmationDialog
 added cancellation handling.  makes script more ugly though :(
 
**/


