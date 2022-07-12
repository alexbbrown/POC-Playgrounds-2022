import SwiftUI

/// Question includes a question prompt and the set of possible answers.  
/// It's the data model for the question 'View' (which is an ActionSheet).
struct Question: Identifiable {
    let question: String
    typealias Answer = String
    
    let answers: Answers
    
    var id: String {
        question
    }
}

/// The possible forms of an answer.
enum Answers {
    case multipleChoice([String])
    /// confirmation returns "yes" or "no"
    case confirmation
}

extension Answers {
    
    @ViewBuilder
    func buttons2(_ action: @escaping (String) -> Void) -> some View {
        switch self {
        case .multipleChoice(let answers):
            ForEach(answers, id: \.self) { answer in
                Button(answer) { 
                    action(answer)
                }
            }
        case .confirmation:
            Button("Yes") {
                action("yes")
            }
            Button("No") {
                action("no")
            }
        }
    }
}


