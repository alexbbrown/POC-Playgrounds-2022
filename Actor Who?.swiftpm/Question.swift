import SwiftUI

struct Question: Identifiable {
    typealias Answer = String
    let question: String
    let answers: [String]
    
    init(_ question: String, answers: [String]) {
        self.question = question
        self.answers = answers
    }
    
    var id: String {
        question
    }
}

extension Question {
    func sheet(_ action: @escaping (Question.Answer) -> ()) -> ActionSheet {
        ActionSheet(
            title: Text("hello"),
            message: Text(self.question),
            buttons: [
                .default(Text("ouch")) {
                    action("outch")
                },
                .default(Text("Meep")) {
                    action("meep")
                }
            ]
        )
    }
}
