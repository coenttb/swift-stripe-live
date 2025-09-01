//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation

public struct ApiKey: Codable, Hashable, Sendable, RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var description: String { rawValue }

    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}
