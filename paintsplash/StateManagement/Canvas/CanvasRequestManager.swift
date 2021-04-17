//
//  CanvasRequestManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/3/21.
//

class CanvasRequestManager: GameEntity, Transformable {
    var transformComponent: TransformComponent

    private(set) var requestsDisplayView: HorizontalStack<CanvasRequest>
    private(set) var maxRequests: Int = 4
    var requests: [CanvasRequest] {
        requestsDisplayView.items
    }

    override init() {
        self.transformComponent = TransformComponent(
            position: Constants.CANVAS_REQUEST_MANAGER_POSITION,
            rotation: 0.0,
            size: Constants.CANVAS_REQUEST_MANAGER_SIZE
        )

        let displayView = HorizontalStack<CanvasRequest>(
            position: transformComponent.localPosition,
            size: transformComponent.size,
            backgroundSprite: Constants.CANVAS_REQUEST_MANAGER_SPRITE,
            zPosition: Constants.ZPOSITION_REQUEST,
            leftPadding: 120,
            bottomPadding: -20
        )

        self.requestsDisplayView = displayView

        super.init()

        EventSystem.canvasEvent.canvasHitEvent.subscribe(
            listener: { [weak self] in self?.evaluateCanvases(canvasHitEvent: $0) }
        )
    }

    func addRequest(colors: Set<PaintColor>) {
        guard requestsDisplayView.items.count < maxRequests,
              let canvasRequest =
                CanvasRequest(requiredColors: colors, position: Vector2D.outOfScreen) else {
            return
        }

        requestsDisplayView.insertTop(item: canvasRequest)
        canvasRequest.paintRequiredColours()
    }

    func evaluateCanvases(canvasHitEvent: CanvasHitEvent) {
        let canvas = canvasHitEvent.canvas
        let colors = canvas.colors

        for (index, request) in requestsDisplayView.items.enumerated() {
            let requestColors = request.requiredColors
            if requestColors == colors {
                completeCanvas(index: index, request: request, canvas: canvas)
                break
            }
        }
    }

    private func completeCanvas(index: Int, request: CanvasRequest, canvas: Canvas) {
        let points = scoreCanvas(request: request)
        let event = ScoreEvent(value: points)
        EventSystem.scoreEvent.post(event: event)

        EventSystem.audioEvent.playSoundEffectEvent.post(
            event: PlaySoundEffectEvent(effect: SoundEffect.completeRequest)
        )

        requestsDisplayView.remove(at: index)

        canvas.destroy()
    }

    func scoreCanvas(request: CanvasRequest) -> Int {
        var point = 0
        for color in request.requiredColors {
            point += Points.getPoints(for: color)
        }
        return point
    }

    override func spawn() {
        super.spawn()
        requestsDisplayView.spawn()
    }

    override func destroy() {
        super.destroy()
        requestsDisplayView.destroy()
    }
}
