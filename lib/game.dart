import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class Player extends SpriteComponent with HasGameRef<MyGame> {
  Player()
      : super(
          size: Vector2(100, 150),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('jump.png');

    position = gameRef.size / 2;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}

class MyCircle extends PositionComponent with HasGameRef<MyGame> {
  int id;
  late Vector2 circlePosition;
  late Vector2 blueCirclePosition;
  late Vector2 amberCirclePosition;
  late Vector2 rainbowCirclePosition;

  late Vector2 homePosition;
  late Vector2 blueCircleHomePosition;
  late Vector2 amberCircleHomePosition;
  late Vector2 rainbowCircleHomePosition;

  late Vector2 randomNoise;

  late Color color;
  late Color blueColor;
  late Color rainbowColor;

  late Vector2 lastMousePosition = Vector2(0, 0);

  MyCircle(this.id, Vector2 position) {
    super.position = Vector2(0, 0);

    randomNoise = Vector2.random() * 50;
    homePosition = Vector2(position.x, position.y) + randomNoise;

    var blueRandomNoise = Vector2.random() * 50;
    blueCircleHomePosition =
        Vector2(position.x, position.y + 100) + blueRandomNoise;

    var amberRandomNoise = Vector2.random() * 100;
    amberCircleHomePosition =
        Vector2(position.x, position.y + amberRandomNoise.y + 200) +
            amberRandomNoise;

    var rainbowRandomNoise = Vector2.random() * 50;
    rainbowCircleHomePosition =
        Vector2(position.x, position.y + 400) + rainbowRandomNoise;

    circlePosition = Vector2(homePosition.x, homePosition.y);
    blueCirclePosition =
        Vector2(blueCircleHomePosition.x, blueCircleHomePosition.y);
    amberCirclePosition =
        Vector2(amberCircleHomePosition.x, amberCircleHomePosition.y);
    rainbowCirclePosition =
        Vector2(rainbowCircleHomePosition.x, rainbowCircleHomePosition.y);

    color = Colors.red;
    color = color.withOpacity(1 - id / 10);

    blueColor = Colors.blue;
    blueColor = blueColor.withOpacity(1 - id / 10);

    rainbowColor = Colors.white;
    rainbowColor = rainbowColor.withRed(255 - id * 25);
    rainbowColor = rainbowColor.withGreen(id * 25);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(circlePosition.toOffset(), 20, Paint()..color = color);
    canvas.drawCircle(
        blueCirclePosition.toOffset(), 10, Paint()..color = blueColor);
    canvas.drawCircle(
        amberCirclePosition.toOffset(), 12, Paint()..color = Colors.amber);
    canvas.drawCircle(
        rainbowCirclePosition.toOffset(), 15, Paint()..color = rainbowColor);
  }

  @override
  void update(double dt) {
    super.update(dt);

    homePosition.y += 20.0 * dt;
    if (homePosition.y > gameRef.size.y) {
      homePosition.y = 0;
    }

    blueCircleHomePosition.y += 24.0 * dt;
    if (blueCircleHomePosition.y > gameRef.size.y) {
      blueCircleHomePosition.y = 0;
    }

    amberCircleHomePosition.y += 30.0 * dt;
    if (amberCircleHomePosition.y > gameRef.size.y) {
      amberCircleHomePosition.y = 0;
    }

    rainbowCircleHomePosition.y += 40.0 * dt;
    if (rainbowCircleHomePosition.y > gameRef.size.y) {
      rainbowCircleHomePosition.y = 0;
    }

    updatePosition();
  }

  void move(Vector2 targetPosition) {
    lastMousePosition = targetPosition;
  }

  void updatePosition() {
    Vector2 direction = (lastMousePosition - homePosition).normalized();
    circlePosition = homePosition + direction * randomNoise.y * 2.0;

    Vector2 blueDirection =
        (lastMousePosition - blueCircleHomePosition).normalized();
    blueCirclePosition =
        blueCircleHomePosition + blueDirection * (randomNoise.x + 50.0);

    Vector2 amberDirection =
        (lastMousePosition - amberCircleHomePosition).normalized();
    amberCirclePosition =
        amberCircleHomePosition + amberDirection * (2 * randomNoise.x + 20.0);

    Vector2 rainbowDirection =
        (lastMousePosition - rainbowCircleHomePosition).normalized();
    rainbowCirclePosition = rainbowCircleHomePosition + rainbowDirection * 40.0;
  }
}

class MyGame extends FlameGame with MouseMovementDetector {
  late Player player;
  late List<MyCircle> circles = [];

  void makeCircles() {
    for (int i = 0; i < 10; i++) {
      circles.add(MyCircle(i, Vector2(10.0 + i * 100.0, 10.0)));
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // player = Player();
    makeCircles();

    // add(player);
    addAll(circles);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    super.onMouseMove(info);
    // player.move(info.eventPosition.global - player.position);

    for (final circle in circles) {
      circle.move(info.eventPosition.global);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // player.update(dt);

    for (final circle in circles) {
      circle.update(dt);
    }
  }

  @override
  Color backgroundColor() => Colors.white;

  @override
  void onRemove() {
    // Optional based on your game needs.
    removeAll(children);
    processLifecycleEvents();
    // Any other code that you want to run when the game is removed.
  }
}
