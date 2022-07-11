import SwiftUI

struct SampleJokeView: View {
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

struct SampleJokeView_Previews: PreviewProvider {
    static var previews: some View {
        SampleJokeView()
    }
}
