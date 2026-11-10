//
//  MeetingFilter.swift
//  MeetingLinkManager
//
//  Created by Kyaw Lwin Soe on 10/11/2026.
//

import Foundation

enum MeetingFilter: Hashable {
    case all
    case upcoming
    case past
    case platform(MeetingPlatform)
}
