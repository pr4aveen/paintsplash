//
//  SinglePlayerGameManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
// swiftlint:disable function_body_length

import SpriteKit

class SinglePlayerGameManager: GameManager {
    weak var gameScene: GameScene?

    // game entities that should change
    var entities = Set<GameEntity>()

    // game entities that are specific to player and do not change
    var uiEntities = Set<GameEntity>()

    var currentLevel: Level?

    var aiSystem: StateManagerSystem!
    var audioManager: AudioSystem!
    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var collisionSystem: CollisionSystem!
    var movementSystem: MovementSystem!
    var transformSystem: TransformSystem!
    var playerSystem: PlayerSystem!

    private var collisionDetector: SKCollisionDetector!

    var player: Player!
    var gameInfoManager: GameInfoManager

    init(gameScene: GameScene) {
        self.gameScene = gameScene
        let gameInfo = GameInfo(playerPosition: Vector2D.zero, numberOfEnemies: 0)
        self.gameInfoManager = GameInfoManager(gameInfo: gameInfo)

        setupEventListeners()
        setupGame()
    }

    private func setupEventListeners() {
        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: { [weak self] event in
            self?.onAddEntity(event: event)
        })

        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: { [weak self] event in
            self?.onRemoveEntity(event: event)
        })

        EventSystem.entityChangeEvents.addUIEntityEvent.subscribe(listener: { [weak self] event in
            self?.onAddUIEntity(event: event)
        })

        EventSystem.entityChangeEvents.removeUIEntityEvent.subscribe(listener: { [weak self] event in
            self?.onRemoveUIEntity(event: event)
        })
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpPlayer()
        setUpUI()
        setUpAudio()
    }

    func setUpSystems() {
        guard let gameScene = self.gameScene else {
            fatalError("Failed to initialize gamescene")
        }

        let skRenderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = skRenderSystem

        let skCollisionSystem = SKCollisionSystem(renderSystem: skRenderSystem)
        self.collisionSystem = skCollisionSystem

        self.collisionDetector = SKCollisionDetector(renderSystem: skRenderSystem, collisionSystem: skCollisionSystem)
        gameScene.physicsWorld.contactDelegate = collisionDetector

        self.animationSystem = SKAnimationSystem(renderSystem: skRenderSystem)

        self.aiSystem = GameStateManagerSystem(gameInfo: gameInfoManager.gameInfo)

        self.audioManager = AudioManager()

        self.movementSystem = FrameMovementSystem()

        self.transformSystem = WorldTransformSystem()

        self.playerSystem = PaintSplashPlayerSystem()
    }

    func setUpPlayer() {
        player = Player(initialPosition: Vector2D.zero)
        player.spawn()
    }

    func setUpEntities() {
        let canvasSpawner = CanvasSpawner(
            initialPosition: Constants.CANVAS_SPAWNER_POSITION,
            canvasVelocity: Vector2D(0.4, 0),
            spawnInterval: 10
        )
        canvasSpawner.spawn()

        let canvasManager = CanvasRequestManager()
        canvasManager.spawn()

        let canvasEndMarker = CanvasEndMarker(
            size: Constants.CANVAS_END_MARKER_SIZE,
            position: Constants.CANVAS_END_MARKER_POSITION
        )
        canvasEndMarker.spawn()

        currentLevel = Level.getDefaultLevel(
            canvasManager: canvasManager,
            gameInfo: gameInfoManager.gameInfo
        )
        currentLevel?.run()
    }

    func setUpAudio() {
        self.audioManager.associatedDevice = player.id
        self.audioManager.playMusic(Music.backgroundMusic)
    }

    func setUpUI() {
        let background = Background()
        background.spawn()

        guard let paintGun = player.multiWeaponComponent
                .availableWeapons.compactMap({ $0 as? PaintGun }).first else {
            fatalError("PaintGun not setup properly")
        }

        let paintGunUI = PaintGunAmmoDisplay(
            weaponData: paintGun,
            associatedEntity: player.id
        )
        paintGunUI.spawn()
        paintGunUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.selectWeapon,
            interupt: true
        )

        guard let paintBucket = player.multiWeaponComponent
                .availableWeapons.compactMap({ $0 as? Bucket }).first else {
            fatalError("PaintBucket not setup properly")
        }

        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket, associatedEntity: player.id)
        paintBucketUI.spawn()
        paintBucketUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.unselectWeapon,
            interupt: true
        )

        let joystick = MovementJoystick(
            associatedEntityID: player.id,
            position: Constants.JOYSTICK_POSITION
        )
        joystick.spawn()

        let attackJoystick = AttackJoystick(
            associatedEntityID: player.id,
            position: Constants.ATTACK_BUTTON_POSITION
        )
        attackJoystick.spawn()

        let playerHealthUI = PlayerHealthDisplay(
            startingHealth: player.healthComponent.currentHealth,
            associatedEntityId: player.id
        )
        playerHealthUI.spawn()

        let bottombar = UIBar(
            position: Constants.BOTTOM_BAR_POSITION,
            size: Constants.BOTTOM_BAR_SIZE,
            spritename: Constants.BOTTOM_BAR_SPRITE
        )
        bottombar.spawn()

        let topBar = UIBar(
            position: Constants.TOP_BAR_POSITION,
            size: Constants.TOP_BAR_SIZE,
            spritename: Constants.TOP_BAR_SPRITE
        )
        topBar.spawn()
    }

    func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

    func onAddUIEntity(event: AddUIEntityEvent) {
        uiEntities.insert(event.entity)
        addObjectToSystems(event.entity)
    }

    func onRemoveUIEntity(event: RemoveUIEntityEvent) {
        uiEntities.remove(event.entity)
        removeObjectFromSystems(event.entity)
    }

    func addObjectToSystems(_ object: GameEntity) {
        transformSystem.addEntity(object)
        renderSystem.addEntity(object)
        aiSystem.addEntity(object)
        collisionSystem.addEntity(object)
        movementSystem.addEntity(object)
        animationSystem.addEntity(object)
        playerSystem.addEntity(object)
    }

    func removeObjectFromSystems(_ object: GameEntity) {
        transformSystem.removeEntity(object)
        renderSystem.removeEntity(object)
        aiSystem.removeEntity(object)
        collisionSystem.removeEntity(object)
        movementSystem.removeEntity(object)
        animationSystem.removeEntity(object)
        playerSystem.removeEntity(object)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        addObjectToSystems(object)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        removeObjectFromSystems(object)
    }

    func update() {
        currentLevel?.update()
        transformSystem?.updateEntities()
        aiSystem?.updateEntities()
        renderSystem?.updateEntities()
        animationSystem?.updateEntities()
        collisionSystem?.updateEntities()
        movementSystem?.updateEntities()
        playerSystem?.updateEntities()

        entities.forEach({ $0.update() })
    }

    deinit {
        print("deinit SinglePlayerGameManager")
    }
}