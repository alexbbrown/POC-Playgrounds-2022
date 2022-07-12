import SwiftUI

struct HelloView: View {
    var body: some View {
        QuestionnaireView { ask in
            start: do {
                let name = try await ask(
                    "Hello!, What's your name?",
                    .multipleChoice(["Alex", "Milou", "Margot"])
                )
                
                let age = try await ask(
                    "Hi \(name), How old are you?", 
                        .multipleChoice(["10", "20", "30"])
                )
                
                let confirmed = try await ask(
                    "Is it true, \(name), that you are \(age)?",
                    .confirmation
                )
                
                print("done with task: \(confirmed)")
            } catch {
                print("Cancelled \(error)")
                
                let restart = try? await ask(
                    "Start again?",
                    .confirmation
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
