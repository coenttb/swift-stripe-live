//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 03/08/2025.
//

import Dependencies
import Foundation
import ServerFoundation

extension URL {
  package static var stripe: URL {
    .init(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
  }
}
