import SwiftUI

/// A set of buttons for a confirmation dialog
struct AnswersButtonsView: View {
    
    typealias Answer = Question.Answer
    let answers: Answers
    let action: (Answer) -> Void
    let cancel: (Error) -> Void
    
    var body: some View {
        switch answers {
        case .choose(let answers):
            ForEach(answers, id: \.self) { answer in
                Button(answer) { 
                    action(answer)
                }
            }
        case .confirm:
            Button("Yes") {
                action("yes")
            }
            Button("No") {
                action("no")
            }
        }
        Button(role: .cancel) {
            cancel(CancellationError())
        } label: {
            Text("Cancel")
        }
    }
}

/// Internal type which presents the sheet
/// See QuestionnaireView for how it interfaces with async
struct QuestionDialogModifier: ViewModifier {
    
    @Binding var presented: Bool
    let question: Question? 
    let action: (String) -> Void
    let cancel: (Error) -> Void
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog(
                "Question",
                isPresented: $presented, 
                // titleVisibility: .visible,
                presenting: question
            ) { question in
                AnswersButtonsView(
                    answers: question.answers, 
                    action: action, 
                    cancel: cancel
                )
            } message: { question in
                Text(question.question)
            }
    }
}

extension View {
    /// Convenience way to call questionModifier
    func question(presented: Binding<Bool>, question: Question?, action: @escaping (Question.Answer) -> Void, cancel: @escaping (Error) -> Void) -> some View {
        modifier(QuestionDialogModifier(
            presented: presented, 
            question: question,
            action: action,
            cancel: cancel
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
                    answers: .choose(["To be", "Not to be"])
                )) { answer in
                    print("Answered \(answer)")
                } cancel: { error in
                    print("cancelled \(error)")
                }
    }
}
