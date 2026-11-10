import SwiftUI
import SwiftData

struct MeetingFormView: View {
    @State private var title = ""
    @State private var url = ""
    @State private var detectedPlatform: MeetingPlatform = .other
    @State private var selectedPlatform: MeetingPlatform = .other
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var meetingDate = Date()
    @State private var hasMeetingDate = false
    
    private var isValidURL: Bool {
        guard let url = URL(string: url),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme),
              let host = url.host,
              host.contains(".")
        else {
            return false
        }

        return true
    }

    var body: some View {
        Form {
            TextField("Meeting Title", text: $title)
            if !title.isEmpty && title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Meeting title cannot contain only spaces.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            TextField("Meeting URL", text: $url)
                .onChange(of: url) { _, newValue in
                    detectedPlatform = MeetingPlatform.detect(from: newValue)
                    selectedPlatform = detectedPlatform
                }
            if !url.isEmpty && !isValidURL {
                Text("Please enter a valid HTTP or HTTPS URL.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            Picker("Platform", selection: $selectedPlatform) {
                ForEach(MeetingPlatform.allCases) { platform in
                    Text(platform.displayName)
                        .tag(platform)
                }
            }
            Toggle("Schedule Meeting", isOn: $hasMeetingDate)
            if hasMeetingDate {
                DatePicker(
                    "Meeting Date",
                    selection: $meetingDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            Button("Save Meeting") {
                let meeting = Meeting(
                    title: title,
                    url: url,
                    platform: selectedPlatform,
                    meetingDate: hasMeetingDate ? meetingDate : nil
                )

                modelContext.insert(meeting)
                dismiss()
            }
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !isValidURL)
        }
        .padding()
        .frame(width: 400)
    }
}

#Preview {
    MeetingFormView()
}
