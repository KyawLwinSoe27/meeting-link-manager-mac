
import SwiftUI
import SwiftData

struct ContentView: View {

    @State private var selectedFilter: MeetingFilter? = .all
    @State private var selectedMeeting: Meeting?
    @Query(sort: \Meeting.createdAt, order: .reverse)
    private var meetings: [Meeting]
    @State private var isShowingAddMeeting = false
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirmation = false


    
    private var filteredMeetings: [Meeting] {
        switch selectedFilter {
        case .all, .none:
            return meetings

        case .upcoming:
            return meetings.filter {
                guard let date = $0.meetingDate else { return false }
                return date >= Date()
            }

        case .past:
            return meetings.filter {
                guard let date = $0.meetingDate else { return false }
                return date < Date()
            }

        case .platform(let platform):
            return meetings.filter {
                $0.platform == platform
            }
        }
    }
    
    
    var body: some View {
        NavigationSplitView {

            // Sidebar
            List(selection: $selectedFilter) {

                Section("Meetings") {
                    Label("All Meetings", systemImage: "calendar")
                        .tag(MeetingFilter.all)

                    Label("Upcoming", systemImage: "calendar.badge.clock")
                        .tag(MeetingFilter.upcoming)

                    Label("Past Meetings", systemImage: "calendar.badge.checkmark")
                        .tag(MeetingFilter.past)
                }

                Section("Platforms") {
                    ForEach(MeetingPlatform.allCases) { platform in
                        Label(platform.displayName, systemImage: "video")
                            .tag(MeetingFilter.platform(platform))
                    }
                }
            }
            .navigationTitle("Meeting Manager")
            .navigationSplitViewColumnWidth(min: 180, ideal: 220)

        } detail: {

            // Detail area
            HStack(spacing: 0) {
                Group {
                    if filteredMeetings.isEmpty {
                        ContentUnavailableView(
                            "No Meetings Yet",
                            systemImage: "calendar",
                            description: Text("Your saved meetings will appear here.")
                        )
                    } else {
                        List(selection: $selectedMeeting) {
                            ForEach(filteredMeetings) { meeting in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(meeting.title)
                                        .font(.headline)

                                    Text(meeting.platform.displayName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    Text(meeting.url)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                                .tag(meeting)
                            }
                        }
                        .frame(minWidth: 250)
                    }
                }

                Divider()

                if let selectedMeeting {
                    NavigationStack {
                        MeetingDetailView(meeting: selectedMeeting)
                    }
                    .frame(minWidth: 350)
                } else {
                    ContentUnavailableView(
                        "Select a Meeting",
                        systemImage: "calendar",
                        description: Text("Choose a meeting to see its details.")
                    )
                    .frame(minWidth: 350)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingAddMeeting = true
                } label: {
                    Label("Add Meeting", systemImage: "plus")
                }
            }
            if selectedMeeting != nil {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete Meeting", systemImage: "trash")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddMeeting) {
            MeetingFormView()
        }
        .confirmationDialog(
            "Delete this meeting?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let meeting = selectedMeeting {
                    modelContext.delete(meeting)
                    selectedMeeting = nil
                }
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Meeting.self, inMemory: true)
}
