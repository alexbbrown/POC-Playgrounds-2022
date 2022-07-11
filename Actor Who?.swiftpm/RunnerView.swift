import SwiftUI

class ContinuationModel: ObservableObject {
    
    @Published var question: Joke?
    
    var continuation: CheckedContinuation<Joke?, Never>?
    
    func ask(joke: Joke?) async -> Joke? {
        
        return await withCheckedContinuation { aContinuation in
            self.question = joke
            continuation = aContinuation
        }
    }
    
    func answer(joke: Joke?) {
        question = nil
        if let c = continuation {
            continuation = nil
            c.resume(returning: joke)
        }
    }
    
}

struct RunnerView: View {
    @StateObject var model = ContinuationModel()
    
    var body: some View {
        Text("runner")
            .task {
                let joke = Joke.knock
                let response = await model.ask(joke: joke)
                let response2 = await model.ask(joke: response)
                print("done with task: \(response!.line)")
            }
            .actionSheet(item: $model.question) { joke in 
                joke.sheet {
                    model.answer(joke: joke.next)
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
