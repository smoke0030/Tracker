//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Сергей on 08.03.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
            let vc = UINavigationController(rootViewController: TabBarController())
            
            assertSnapshot(matching: vc, as: .image)                                             // 2
        }

}
