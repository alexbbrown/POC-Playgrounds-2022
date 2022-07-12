import SwiftUI

struct HelloView: View {
    var body: some View {
        QuestionnaireView { ask in
            let name = await ask(
                "Hello!, What's your name?",
                .multipleChoice(["Alex", "Milou", "Margot"])
            )
            
            let age = await ask(
                "Hi \(name), How old are you?", 
                    .multipleChoice(["10", "20", "30"])
            )
            
            let confirmed = await ask(
                "Is it true, \(name), that you are \(age)?",
                .confirmation
            )
            
            print("done with task: \(confirmed)")
        }
    }
}



struct RunnerView_Previews: PreviewProvider {
    static var previews: some View {
        RunnerView()
    }
}
