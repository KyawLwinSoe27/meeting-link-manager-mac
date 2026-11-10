import SwiftUI
import AppKit

struct MeetingDetailView: View {
    let meeting: Meeting
    

    var body: some View {
        Form {
            Section("Meeting Information") {
                LabeledContent("Title", value: meeting.title)

                LabeledContent(
                    "Platform",
                    value: meeting.platform.displayName
                )

                LabeledContent("Meeting URL") {
                    HStack {
                        Text(meeting.url)
                            .textSelection(.enabled)
                            .lineLimit(1)

                        Button {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(
                                meeting.url,
                                forType: .string
                            )
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .help("Copy meeting URL")
                    }
                }
                Button {
                    guard let url = URL(string: meeting.url) else {
                        return
                    }

                    NSWorkspace.shared.open(url)
                } label: {
                    Label("Open Meeting", systemImage: "arrow.up.right.square")
                }
            }

            Section("Schedule") {
                if let date = meeting.meetingDate {
                    LabeledContent(
                        "Meeting Date",
                        value: date.formatted(
                            date: .long,
                            time: .shortened
                        )
                    )
                } else {
                    Text("No scheduled date")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Timestamps") {
                LabeledContent(
                    "Created",
                    value: meeting.createdAt.formatted(date: .abbreviated, time: .shortened)
                )

                LabeledContent(
                    "Last Updated",
                    value: meeting.updatedAt.formatted(date: .abbreviated, time: .shortened)
                )
            }
        }
        .formStyle(.grouped)
        .navigationTitle(meeting.title)
        .padding()
    }
}

#Preview {
    NavigationStack {
        MeetingDetailView(
            meeting: Meeting(
                title: "Team Meeting",
                url: "https://meet.google.com/abc-def",
                platform: .googleMeet
            )
        )
    }
}
