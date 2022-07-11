import SwiftUI

struct Question: Identifiable {
    let question: String
    typealias Answer = String
    enum Answers {
        case multipleChoice([Answer])
        case confirmation
    }
    
    let answers: Answers
    
    init(_ question: String, answers: [String]) {
        self.question = question
        self.answers = .multipleChoice(answers)
    }
    
    /// Yes No type questions
    init(_ question: String) {
        self.question = question
        self.answers = .confirmation
    }
    
    var id: String {
        question
    }
}

extension Question {
    
    func buttons(_ action: @escaping (Answer) -> ()) -> [ActionSheet.Button] {
        switch answers {
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
    
    func sheet(_ action: @escaping (Question.Answer) -> ()) -> ActionSheet {
        ActionSheet(
            title: Text(self.question)
                .font(.title),
            buttons: 
                self.buttons(action)
        )
    }
}
