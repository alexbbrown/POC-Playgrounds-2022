import SwiftUI

/// Internal type which presents the sheet
/// See QuestionnaireView for how it interfaces with async
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

struct QuestionModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test `question` Modifier")
            .question(
                presented: .constant(true), 
                question: Question(
                    question: "Is it more noble in the mind",
                    answers: .multipleChoice(["To be", "Not to be"])
                )) { answer in
                    print("Answered \(answer)")
                }
    }
}
