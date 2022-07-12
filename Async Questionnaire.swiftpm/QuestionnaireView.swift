import SwiftUI

/// Models series of question / responses
/// client inputs questions and get output answer via an async function 'ask'
/// Uses continuations
fileprivate class Questioner: ObservableObject {
    /// The value passed to the QuestionView (ActionSheet)
    @Published var question: Question?
    typealias Answer = String
    
    typealias AnyContinuation = Any
    
    private var answerContinuation: AnyContinuation? = nil
    
    /// ask function is sent to the clients 'script' function
    func ask<Answer>(_ question: Question?) async -> Answer {
        await withCheckedContinuation { continuation in
            self.question = question
            answerContinuation = continuation
        }
    }
    
    /// answer function records the result of each sheet.  
    /// Possible enhancements:
    /// * accept more types
    /// * accept a Result (errors too)
    func answer<Answer>(_ answer: Answer) {
        assert(question == nil) // The sheet sets this to nil
        
        if let continuation = answerContinuation as? CheckedContinuation<Answer, Never> {
            answerContinuation = nil
            continuation.resume(returning: answer)
        }
    }
}

/// View that presents a series of questions.
/// Accepts a 'script' function which asks a series of questions.  
/// The script function can implement a state machine in imperative form.
struct QuestionnaireView: View {
    
    typealias Query = (String, Answers) async -> String
    
    /// The script taskes a query function, which can be called repeatedly to find the answer to several questions.
    let script: (Query) async -> Void 
    
    @StateObject private var model = Questioner()
    
    var body: some View {
        Text("Questionnaire")
            .task {
                await script { question, answers in 
                    let q = Question(question: question, answers: answers)
                    return await model.ask(q)
                }
            }
            .actionSheet(item: $model.question) { question in 
                ActionSheet(
                    title: Text(question.question)
                        .font(.title),
                    buttons: 
                        buttons(answers: question.answers)
                )
            }
    }
    
    
        /// Each possible answer is generated as an ActionSheet.Button button 
    func buttons(answers: Answers) -> [ActionSheet.Button] {
        switch answers {
        case .strings(let answers):
            return answers.map { answer -> ActionSheet.Button in
                    .default(Text(answer)) {
                        model.answer(answer)
                    }
            }
        case .ints(let answers):
            return answers.map {
                answer -> ActionSheet.Button in 
                    .default(Text("\(answer)")) {
                        model.answer(answer)
                    }
            }
        case .confirmation:
            return [
                .default(Text("Yes")) {
                    model.answer(true)
                },
                .cancel(Text("No")) {
                    model.answer(false)
                }
            ]
        }
    }
}
