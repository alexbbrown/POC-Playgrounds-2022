import SwiftUI

struct SheetView: View {
    let joke: Joke
    let action: () -> ()
    var body: some View {
        Form {
            Text(joke.line)
                
            Button(role: .destructive) { 
                action()
            } label: { 
                Text("Next")
            }
        }
    }
}

enum Joke: Identifiable {
    case knock
    case who
    
    var next: Joke {
        switch self {
            case .knock:
            return .who
            default: 
            return self
        }
    }
    
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
    
    func sheet() -> ActionSheet {
        ActionSheet(
            title: Text("hello"),
            message: Text(self.line),
            buttons: [
                .default(Text("ouch")) {
                    
                }
            ]
        )
    }
}

typealias response = Void
typealias Sheet = (Joke) -> ActionSheet


struct SheetsView: View {
    @State var joke: Joke? = .knock
    func clicked() {
        print("clicked")
    }
    var body: some View {
        Text("placeholder")
            .actionSheet(item: $joke) { joke in
                joke.sheet()
            }
    }
}

struct SheetsView_Previews: PreviewProvider {
    static var previews: some View {
        SheetsView()
    }
}
