import SwiftUI

struct Question: Identifiable {
    let question: String
    typealias Answer = String
    
    let answers: Answers
    
    var id: String {
        question
    }
}

enum Answers {
    case multipleChoice([String])
    case confirmation
}

extension Answers {
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
    
    func sheet(_ action: @escaping (String) -> ()) -> ActionSheet {
        ActionSheet(
            title: Text(self.question)
                .font(.title),
            buttons: 
                answers.buttons(action)
        )
    }
}
