import SwiftUI

class AnswerModel: ObservableObject {
    @Published var question: Question?
    typealias Answer = String
    
    var answerContinuation: CheckedContinuation<Answer, Never>?
    
    func ask(_ question: Question?) async -> Answer {
        
        return await withCheckedContinuation { continuation in
            self.question = question
            answerContinuation = continuation
        }
    }
    
    func answer(_ answer: String) {
        question = nil
        if let c = answerContinuation {
            answerContinuation = nil
            c.resume(returning: answer)
        }
    }
    
}

struct RunnerView: View {
    var body: some View {
        QuestionnaireView { ask in
            let name = await ask(
                "What's your name",
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
            
            return confirmed
        }
    }
}

struct QuestionnaireView: View {
    
    typealias Query = (String, Answers) async -> String
    
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
            .actionSheet(item: $model.question) { joke in 
                joke.sheet { answer in 
                    model.answer(answer)
                }
            }
    }
}

struct RunnerView_Previews: PreviewProvider {
    static var previews: some View {
        RunnerView()
    }
}
