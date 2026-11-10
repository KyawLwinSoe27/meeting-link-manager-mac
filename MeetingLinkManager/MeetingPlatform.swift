//
//  MeetingPlatform.swift
//  MeetingLinkManager
//
//  Created by Kyaw Lwin Soe on 10/11/2026.
//

import Foundation

enum MeetingPlatform: String, CaseIterable, Identifiable {
    case googleMeet
    case zoom
    case microsoftTeams
    case webex
    case other

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .googleMeet:
            return "Google Meet"
        case .zoom:
            return "Zoom"
        case .microsoftTeams:
            return "Microsoft Teams"
        case .webex:
            return "Cisco Webex"
        case .other:
            return "Other"
        }
    }
    
    static func detect(from url: String) -> MeetingPlatform {
        let lowercasedURL = url.lowercased()

        if lowercasedURL.contains("meet.google.com") {
            return .googleMeet
        }

        if lowercasedURL.contains("zoom.us") {
            return .zoom
        }

        if lowercasedURL.contains("teams.microsoft.com") {
            return .microsoftTeams
        }

        if lowercasedURL.contains("webex.com") {
            return .webex
        }

        return .other
    }
}
