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
    /// Each possible answer is generated as an ActionSheet.Button button 
    func buttons(_ action: @escaping (String) -> ()) -> [ActionSheet.Button] {
        switch self {
        case .multipleChoice(let answers):
            return answers.map { answer -> ActionSheet.Button in
                    .default(Text(answer)) {
                        action(answer)
                    }
            }
        case .confirmation:
            return [
                .default(Text("Yes")) {
                    action("yes")
                },
                .cancel(Text("No")) {
                    action("no")
                }
            ]
        }
    }
}

extension Question {
    /// Generate the actionsheet for the question
    func sheet(_ action: @escaping (String) -> ()) -> ActionSheet {
        ActionSheet(
            title: Text(self.question)
                .font(.title),
            buttons: 
                answers.buttons(action)
        )
    }
}
