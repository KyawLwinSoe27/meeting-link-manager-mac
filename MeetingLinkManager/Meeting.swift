//
//  Meeting.swift
//  MeetingLinkManager
//
//  Created by Kyaw Lwin Soe on 10/11/2026.
//


import Foundation
import SwiftData

@Model
final class Meeting {

    var id: UUID
    var title: String
    var url: String
    var platformRawValue: String
    var meetingDate: Date?
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    var platform: MeetingPlatform {
        get {
            MeetingPlatform(rawValue: platformRawValue) ?? .other
        }
        set {
            platformRawValue = newValue.rawValue
        }
    }
    
    init(
        title: String,
        url: String,
        platform: MeetingPlatform,
        meetingDate: Date? = nil,
        notes: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.url = url
        self.platformRawValue = platform.rawValue
        self.meetingDate = meetingDate
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }

}
