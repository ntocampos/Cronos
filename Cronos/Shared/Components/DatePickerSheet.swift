import SwiftUI

struct DatePickerSheet: View {
  @Binding var selection: Date
  let accentColor: Color
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      DatePicker(
        "Select Date",
        selection: $selection,
        displayedComponents: [.date, .hourAndMinute]
      )
      .datePickerStyle(.graphical)
      .tint(accentColor)
      .navigationTitle("Due Date")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") { dismiss() }
        }
      }
    }
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var date = Date().addingTimeInterval(86400)
    @State private var showSheet = true

    var body: some View {
      Button("Show Picker") {
        showSheet = true
      }
      .sheet(isPresented: $showSheet) {
        DatePickerSheet(selection: $date, accentColor: .blue)
          .presentationDetents([.medium])
      }
    }
  }

  return PreviewWrapper()
}
