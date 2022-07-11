import SwiftUI

struct RunnerView: View {
    @State var joke: Joke?
    
    var body: some View {
        Text("runner")
            .task {
                let asker0 = asker($joke) 
                await run(asker: asker0)
            }
            .actionSheet(item: $joke) { joke in 
                joke.sheet {
                    self.joke = joke.next
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
