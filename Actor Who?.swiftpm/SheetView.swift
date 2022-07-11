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
