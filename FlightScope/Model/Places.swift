//
//  Places.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/28/21.
//

import Foundation

// MARK: - Places
struct Places: Codable {
    let suggestions: [Suggestion]?
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let text, magicKey: String?
    let isCollection: Bool?
}
