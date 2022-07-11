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
    @StateObject var model = AnswerModel()
    
    var body: some View {
        Text("runner")
            .task {
                let who = Question("What's your name", answers: ["Alex", "Milou", "Margot"])
                let name = await model.ask(who)
                let howOld = Question("Hi \(name), How old are you?", answers: ["10", "20", "30"])
                let age = await model.ask(howOld)
                let confirm = Question("Is it true, \(name), that you are \(age)?")
                let confirmed = await model.ask(confirm)
                print("done with task: \(confirmed)")
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
