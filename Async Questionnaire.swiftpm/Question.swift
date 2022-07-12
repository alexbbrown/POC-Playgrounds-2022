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

/// The possible forms of an answer.
enum Answers {
    case multipleChoice([String])
    /// confirmation returns "yes" or "no"
    case confirmation
}

extension Answers {
    /// Each possible answer is generated as an ActionSheet.Button button 
    func buttons(_ action: @escaping (String) -> Void) -> [ActionSheet.Button] {
        switch self {
        case .multipleChoice(let answers):
            return answers.map { answer -> ActionSheet.Button in
                    .default(Text(answer)) {
                        action(answer)
                    }
            }
        case .confirmation:
            return [
                .default(Text("Yes")) {
                    action("yes")
                },
                .cancel(Text("No")) {
                    action("no")
                }
            ]
        }
    }
    
    @ViewBuilder
    func buttons2(_ action: @escaping (String) -> Void) -> some View {
        switch self {
        case .multipleChoice(let answers):
            ForEach(answers, id: \.self) { answer in
                Button(answer) { 
                    action(answer)
                }
            }
        case .confirmation:
            Button("Yes") {
                action("yes")
            }
            Button("No") {
                action("no")
            }
        }
    }
}

extension Question {
    /// Generate the actionsheet for the question
    func sheet(_ action: @escaping (String) -> ()) -> ActionSheet {
        ActionSheet(
            title: Text(self.question)
                .font(.title),
            buttons: 
                answers.buttons(action)
        )
    }
}

extension View {
    /// Convenience way to call questionModifier
    func question(presented: Binding<Bool>, question: Question?, action: @escaping (Question.Answer) -> Void) -> some View {
        modifier(QuestionModifier(
            presented: presented, 
            question: question,
            action: action
        ))
    }
}

struct QuestionModifier: ViewModifier {
    
    @Binding var presented: Bool
    let question: Question? 
    let action: (String) -> Void
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog(
                "Question",
                isPresented: $presented, 
//                titleVisibility: .visible,
                presenting: question
            ) { question in
                question.answers.buttons2 { answer in
                    action(answer)
                }
            } message: { question in
                Text(question.question)
            }
        
    }
}

struct QuestionModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Modifier")
            .question(presented: .constant(true), question: Question(question: "Is it more noble in the mind",
                                                                      answers: .multipleChoice(["To be", "Not to be"])), action: { answer in
                print("Answered \(answer)")
            })
    }
}
