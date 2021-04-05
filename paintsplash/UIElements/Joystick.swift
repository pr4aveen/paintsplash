//
//  JoystickMovement.swift
//  paintsplash
//
//  Created by Praveen Bala on 15/3/21.
//

import Foundation

class Joystick: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    let associatedEntity: EntityID

    private (set) var displacement: Vector2D = .zero

    private let foregroundNode: JoystickForeground

    private (set) var tracking = false

    private var backgroundRadius: Double {
        transformComponent.size.x / 2
    }

    private var handleRadius: Double {
        transformComponent.size.x / 2
    }

    init(associatedEntityID: EntityID, position: Vector2D) {
        let renderType = RenderType.sprite(spriteName: Constants.JOYSTICK_SPRITE)

        self.associatedEntity = associatedEntityID

        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0,
            size: Constants.JOYSTICK_SIZE
        )

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_UI_ELEMENT
        )

        foregroundNode = JoystickForeground(
            position: position,
            size: Constants.JOYSTICK_SIZE * 0.60,
            zPosition: renderComponent.zPosition + 1
        )

        super.init()

        EventSystem.inputEvents.touchDownEvent.subscribe(listener: onTouchDown)
        EventSystem.inputEvents.touchMovedEvent.subscribe(listener: onTouchMoved)
        EventSystem.inputEvents.touchUpEvent.subscribe(listener: onTouchUp)
    }

    override func spawn() {
        super.spawn()
        foregroundNode.spawn()
    }

    override func destroy() {
        super.destroy()
        foregroundNode.destroy()
    }

    func onTouchDown(event: TouchDownEvent) {
        guard event.associatedId == associatedEntity else {
            print("fail")
            print(event.associatedId)
            print(associatedEntity)
            return
        }

        if Vector2D.magnitude(of: event.location - transformComponent.localPosition) < backgroundRadius {
            tracking = true
        }
    }

    func onTouchMoved(event: TouchMovedEvent) {
        guard tracking,
              event.associatedId == associatedEntity else {
            return
        }

        var newLocation = event.location
        let displacement = newLocation - transformComponent.localPosition

        if displacement.magnitude > backgroundRadius {
            let newDisplacement =
                Vector2D.normalize(displacement) * backgroundRadius
            newLocation = transformComponent.localPosition + newDisplacement
        }

        foregroundNode.transformComponent.localPosition = newLocation
        self.displacement = displacement.unitVector
    }

    func onTouchUp(event: TouchUpEvent) {
        guard event.associatedId == associatedEntity else {
            return
        }

        tracking = false
        foregroundNode.transformComponent.localPosition =
            transformComponent.localPosition
        self.displacement = .zero
    }

    class JoystickForeground: UIEntity, Renderable {
        var renderComponent: RenderComponent
        var transformComponent: TransformComponent

        init(position: Vector2D, size: Vector2D, zPosition: Int) {
            let renderType = RenderType.sprite(spriteName: "joystick-foreground")

            self.renderComponent = RenderComponent(renderType: renderType, zPosition: zPosition)
            self.transformComponent = TransformComponent(position: position, rotation: 0, size: size)

            super.init()
        }
    }
}
