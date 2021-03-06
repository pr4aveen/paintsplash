//
//  StateComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class StateComponentTests: XCTestCase {

    var state: EnemyState.ChasingLeft {
        EnemyState.ChasingLeft(enemy: enemy)
    }
    let enemy = Enemy(initialPosition: Vector2D.zero, color: .red)
    let component = StateComponent()

    func testConstruct() {
        XCTAssertTrue(component.currentState is NoState)
        XCTAssertTrue(component.getCurrentBehaviour() is DoNothingBehaviour)
        XCTAssertNil(component.getNextState())
    }
}
