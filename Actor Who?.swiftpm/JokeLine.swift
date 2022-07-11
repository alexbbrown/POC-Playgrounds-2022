import SwiftUI

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
    
    func sheet(_ action: @escaping () -> ()) -> ActionSheet {
        ActionSheet(
            title: Text("hello"),
            message: Text(self.line),
            buttons: [
                .default(Text("ouch")) {
                    action()
                }
            ]
        )
    }
}
