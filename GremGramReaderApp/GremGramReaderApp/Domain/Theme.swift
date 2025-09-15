//
//  Theme.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/15/25.
//

import SwiftUI

enum Theme: CaseIterable, Hashable {
    case paper, night

    var background: Color {
        switch self {
        case .night: return .black
        case .paper: return Color(red: 0.98, green: 0.96, blue: 0.90)
        }
    }

    var pageFill: Color {
        switch self {
        case .night: return Color(red: 1.0, green: 0.99, blue: 0.94)
        case .paper: return Color(red: 1.0, green: 0.99, blue: 0.94)
        }
    }

    var textColor: Color {
        switch self {
        case .night: return .purple
        case .paper: return .black
        }
    }

    var accent: Color {
        switch self {
        case .night: return .blue
        case .paper: return .brown
        }
    }
}
