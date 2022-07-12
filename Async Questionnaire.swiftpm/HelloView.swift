import SwiftUI

/// 
struct HelloView: View {
    var body: some View {
        QuestionnaireView { ask in
            let name = await ask(
                "Hello!, What's your name?",
                .strings(["Alex", "Milou", "Margot"])
            )
            
            let age: Int = await ask(
                "Hi \(name), How old are you?", 
                    .ints([10, 20, 30])
            )
            
            let confirmed: Bool = await ask(
                "Is it true, \(name), that you are \(age)?",
                .confirmation
            )
            
            print("done with task: \(confirmed)")
        }
    }
}



struct HelloView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView()
    }
}
