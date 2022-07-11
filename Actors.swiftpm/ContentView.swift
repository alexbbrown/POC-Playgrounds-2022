import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Knock Knock")
                .knocker
            Text("Who's There")
                .whoever
            Text("Broken Pencil")
                .knocker
            Text("Broken Pencil who?")
                .whoever
            Text("Never mind, there's no point")
                .knocker
        }
    }
}

extension View {
    var knocker: some View {
        self
            .font(.title)
            .foregroundColor(.blue)
    }
    var whoever: some View {
        self
            .font(.title)
            .foregroundColor(.yellow)
    }
}
