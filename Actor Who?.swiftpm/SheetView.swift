import SwiftUI

struct SheetView: View {
    let joke: Joke
    var body: some View {
        Text(joke.line)
    }
}

enum Joke: Identifiable {
    case knock
    case who
    
    var id: String {
        String(describing: self)
    }
    
    var line: String {
        switch self {
            case .knock:
            return "Knock Knock"
            case .who:
            return "Who's there?"
        }
    }
}

struct SheetsView: View {
    @State var joke: Joke? = .knock
    var body: some View {
        Text("placeholder")
            .sheet(item: $joke) { 
                print("hi")
            } content: { joke in
                SheetView(joke: joke)
            }
        
    }
}

struct SheetsView_Previews: PreviewProvider {
    static var previews: some View {
        SheetsView()
    }
}
