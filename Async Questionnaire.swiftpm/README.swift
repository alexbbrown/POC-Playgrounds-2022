/**

 Test to see if I can convert an actor 'state machine' and link its async operations to a view moving through some sort of wizard.
 
 Knock Knock!

 Possible enhancements
 
 1) can I make it generic?
 1.1) can it be generic over a single answer type per questionnaire?
 1.2) can it be generic over multiple answer types per questionnaire? 
 2) It's a confirmationDialog right now.  Can this be varied? can I make it work with multiple types of sheet/wizard/custom?
 2.1) Can I give developer the power to vary this?
 2.2) Can I explore things that are not sheets
 3) Pushing the boundaries of the script.  can it be a result builder? (probably not)
 3.1) can a result builder generate ASYNC code?
 3.2) can a result builder build VIEWs at the SAME TIME as ASYNC code?
 4) right now the ask function applies to a single value.
 4.1) can I make it composable - is the result of the *whole* questionnaire a value which is itself an 'answer'?  would require arbitrary type handling.  For example, after collecting details of a user, 'return' a new user record. 
 
 ## Drawbacks:
 
 Unlike state machines or structs, state restoration to a specific state of the script is hard or impossible (I think)
 going *back* arbitrary steps is hard - but can be done using label: do {} blocks 
 
 Log: 
 
 updated swiftUI code to use modern confirmationDialog
 added cancellation handling.  makes script more ugly though :(
 
**/


