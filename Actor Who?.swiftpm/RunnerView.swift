import SwiftUI

struct RunnerView: View {
    var body: some View {
        Text("runner")
            
            .task {
                await run()
            }
    }
}

struct RunnerView_Previews: PreviewProvider {
    static var previews: some View {
        RunnerView()
    }
}

func ask(joke: Joke) async -> Joke {
    return joke
}

/// This function should represent the imperative steps we move through as state
func run() async {
    let joke = Joke.knock
    let response = await ask(joke: joke)
    print("done with response \(response.line)")
}
