import SwiftUI

/// Question includes a question prompt and the set of possible answers.  
/// It's the data model for the question 'View' (which is an ActionSheet).
struct Question: Identifiable {
    let question: String
    typealias Answer = String
    
    let answers: Answers
    
    var id: String {
        question
    }
}

/// The possible forms and values of an answer.
enum Answers {
    case choose([String])
    /// confirmation returns "yes" or "no"
    case confirm
}
