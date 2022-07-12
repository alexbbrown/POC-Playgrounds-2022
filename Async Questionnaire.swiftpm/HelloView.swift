import SwiftUI

/// Hello View welcomes the user and collects some information
/// The interaction state machine is passed as an imperative function which repeatedly calls 'ask'.
/// each call of ask pauses (awaits) the script and passes control to the UI.
/// Once the user picks an answer the script resumes.
struct HelloView: View {
    var body: some View {
        QuestionnaireView { ask in
            start: do { // if the user cancels, restart here
                let name = try await ask(
                    "Hello!, What's your name?",
                    .choose(["Alex", "Milou", "Margot", "Someone else"])
                )
                
                if name == "Someone else" {
                    let restart = try? await ask(
                        "I only talk to friends.  Try again?",
                        .confirm
                    )
                    
                    if restart == "yes" {
                        continue start
                    }
                    
                    print("Stopped at unknown user")
                    return 
                }
                
                let age = try await ask(
                    "Hi \(name), How old are you?", 
                        .choose(["10", "20", "30"])
                )
                
                let confirmed = try await ask(
                    "Is it true, \(name), that you are \(age)?",
                    .confirmation
                )
                
                if confirmed == "no" {
                    continue start
                }
                
                print("Complete.  I met \(name), age \(age)")
            } catch {
                print("Cancelled \(error)")
                
                let restart = try? await ask(
                    "You cancelled: Start again?",
                    .confirm
                )
                
                if restart == "yes" {
                    continue start
                }
                print("Done")
            }
        }
    }
}



struct HelloView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView()
    }
}
