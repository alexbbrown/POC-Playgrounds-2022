import SwiftUI

struct CancelError: Error { }

/// Translates question / responses into an async function 'ask'.
/// Uses continuations
fileprivate class Questionnaire: ObservableObject {
    /// The value passed to the QuestionView (ActionSheet)
    @Published var question: Question?
    typealias Answer = String
    
    /// Should we present this view
    var presented: Bool {
        get {
            question != nil
        }
        set {
            if !newValue {
                question = nil
            } else {
                fatalError() // Can't set this true manually
            }
        }
    }
    
    var answerContinuation: CheckedContinuation<Answer, Error>?
    
    /// ask function is sent to the clients 'script' function
    func ask(_ question: Question?) async throws -> Answer {
        try await withCheckedThrowingContinuation { continuation in
            self.question = question
            answerContinuation = continuation
        }
    }
    
    /// answer function records the result of each sheet.  
    /// Possible enhancements:
    /// * accept more types
    func answer(_ answer: String) {
        resume(Result { answer })
    }
    
    func cancel() {
        resume(Result { throw CancelError() })
    }
    
    func resume(_ result: Result<Answer, Error>) {
        question = nil
        if let continuation = answerContinuation {
            answerContinuation = nil
            continuation.resume(with: result)
        }
    }
    
}

/// View that presents a series of questions.
/// Accepts a 'script' function which asks a series of questions.  
/// The script function can implement a state machine in imperative form.
struct QuestionnaireView: View {
    
    typealias Query = (String, Answers) async throws -> String
    
    /// The script taskes a query function, which can be called repeatedly to find the answer to several questions.
    let script: (Query) async -> Void 
    
    @StateObject private var model = Questionnaire()
    
    var body: some View {
        Text("Questionnaire")
            .task {
                await script { question, answers in 
                    let q = Question(question: question, answers: answers)
                    return try await model.ask(q)
                }
            }
            .question(
                presented: $model.presented,
                question: model.question
            ) { answer in
                model.answer(answer)
            } cancel: { error in
                model.cancel()
            }
    }
}
