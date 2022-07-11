import SwiftUI

class ContinuationModel: ObservableObject {
    
    @Published var question: Question?
    typealias Answer = String
    
    var answerContinuation: CheckedContinuation<Answer?, Never>?
    
    func ask(_ question: Question?) async -> Answer? {
        
        return await withCheckedContinuation { continuation in
            self.question = question
            answerContinuation = continuation
        }
    }
    
    func answer(_ answer: String?) {
        question = nil
        if let c = answerContinuation {
            answerContinuation = nil
            c.resume(returning: answer)
        }
    }
    
}



struct RunnerView: View {
    @StateObject var model = ContinuationModel()
    
    var body: some View {
        Text("runner")
            .task {
                let who = Question("What's your name", answers: ["Alex", "Margot"])
                let name = await model.ask(who)
                let age = Question("Hi \(name) How old?", answers: ["10", "20", "30"])
                let response2 = await model.ask(age)
                print("done with task: \(response2)")
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

func asker(_ binding: Binding<Joke?>) -> (Joke) async -> Joke {
    { joke in
        binding.wrappedValue = joke
        return joke
    }
} 

func ask(joke: Joke) async -> Joke {
    return joke
}

/// This function should represent the imperative steps we move through as state
func run(asker: (Joke) async -> Joke) async {
    let joke = Joke.knock
    let response = await asker(joke)
    print("done with response \(response.line)")
}
