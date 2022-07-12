import SwiftUI

/// Translates question / responses into an async function 'ask'.
/// Uses continuations
class AnswerModel: ObservableObject {
    @Published var question: Question?
    typealias Answer = String
    
    var answerContinuation: CheckedContinuation<Answer, Never>?
    
    /// ask function is sent to the clients 'script' function
    func ask(_ question: Question?) async -> Answer {
        await withCheckedContinuation { continuation in
            self.question = question
            answerContinuation = continuation
        }
    }
    
    /// answer function records the result of each sheet.  
    /// Possible enhancements:
    /// * accept more types
    /// * accept a Result (errors too)
    fileprivate func answer(_ answer: String) {
        question = nil
        if let c = answerContinuation {
            answerContinuation = nil
            c.resume(returning: answer)
        }
    }
    
}

/// View that presents a series of questions.
/// Accepts a 'script' function which asks a series of questions.  
/// The script function can implement a state machine in imperative form.
struct QuestionnaireView: View {
    
    typealias Query = (String, Answers) async -> String
    
    /// The script taskes a query function, which can be called repeatedly to find the answer to several questions.
    let script: (Query) async -> String 
    
    @StateObject var model = AnswerModel()
    
    var body: some View {
        Text("runner")
            .task {
                _ = await script { question, answers in 
                    let q = Question(question: question, answers: answers)
                    return await model.ask(q)
                }
            }
            .actionSheet(item: $model.question) { question in 
                question.sheet { answer in 
                    model.answer(answer)
                }
            }
    }
}
