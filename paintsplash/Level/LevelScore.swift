//
//  LevelScore.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 19/3/21.
//

class LevelScore: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    var score = 0
    var freeze = true

    override init() {
        let renderType = RenderType.label(text: "\(score)")

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_UI_ELEMENT + 1
        )

        self.transformComponent = TransformComponent(
            position: Constants.LEVEL_SCORE_POSITION,
            rotation: 0,
            size: Constants.LEVEL_SCORE_SIZE
        )

        super.init()

        EventSystem.scoreEvent.subscribe(listener: onScoreEvent)
        self.spawn()
    }

    func onScoreEvent(event: ScoreEvent) {
        if !freeze {
            score += event.value
            let renderType = RenderType.label(text: "\(score)")
            renderComponent.renderType = renderType
        }
    }

    func reset() {
        score = 0
    }
}
