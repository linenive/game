import 'dart:math';

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

class CircleFactory {
  static MyCircle createRedCircle(int index, Vector2 alignPosition) {
    var homePosition =
        Vector2(alignPosition.x + index * 100.0, alignPosition.y);
    var randomNoise = Vector2.random() * 50;
    homePosition += randomNoise;
    var color = Colors.red.withOpacity(1 - index / 10);
    Vector2 interactionPosition(
        Vector2 homePosition, Vector2 lastMousePosition, double randomNoise) {
      Vector2 direction = (lastMousePosition - homePosition).normalized();

      double followDistance = randomNoise * 2.0;
      var distance = (lastMousePosition - homePosition).length;
      if (distance < followDistance) {
        return lastMousePosition;
      } else {
        return homePosition + direction * followDistance;
      }
    }

    return MyCircle(index, homePosition, color, 20.0, interactionPosition);
  }

  static MyCircle createBlueCircle(int index, Vector2 alignPosition) {
    var homePosition =
        Vector2(alignPosition.x + index * 100.0, alignPosition.y);
    var randomNoise = Vector2.random() * 50;
    homePosition += randomNoise;
    var color = Colors.blue.withOpacity(1 - index / 10);
    Vector2 interactionPosition(
        Vector2 homePosition, Vector2 lastMousePosition, double randomNoise) {
      Vector2 direction = (lastMousePosition - homePosition).normalized();

      double followDistance = randomNoise + 50.0;
      var distance = (lastMousePosition - homePosition).length;
      if (distance < followDistance) {
        return lastMousePosition;
      } else {
        return homePosition + direction * followDistance;
      }
    }

    return MyCircle(index, homePosition, color, 24.0, interactionPosition);
  }

  static MyCircle createAmberCircle(int index, Vector2 alignPosition) {
    var homePosition =
        Vector2(alignPosition.x + index * 100.0, alignPosition.y);
    var randomNoise = Vector2.random() * 100;
    homePosition += randomNoise;
    var color = Colors.amber.withOpacity(index / 10);
    Vector2 interactionPosition(
        Vector2 homePosition, Vector2 lastMousePosition, double randomNoise) {
      Vector2 direction = (lastMousePosition - homePosition).normalized();

      double followDistance = 2 * randomNoise + 20.0;
      var distance = (lastMousePosition - homePosition).length;
      if (distance < followDistance) {
        return lastMousePosition;
      } else {
        return homePosition + direction * followDistance;
      }
    }

    return MyCircle(index, homePosition, color, 30.0, interactionPosition);
  }

  static MyCircle createRainbowCircle(int index, Vector2 alignPosition) {
    var homePosition =
        Vector2(alignPosition.x + index * 100.0, alignPosition.y);
    var randomNoise = Vector2.random() * 50;
    homePosition += randomNoise;
    var color = Colors.white.withRed(255 - index * 25).withGreen(index * 25);
    Vector2 interactionPosition(
        Vector2 homePosition, Vector2 lastMousePosition, double randomNoise) {
      Vector2 direction = (lastMousePosition - homePosition).normalized();

      double followDistance = 40.0;
      var distance = (lastMousePosition - homePosition).length;
      if (distance < followDistance) {
        return lastMousePosition;
      } else {
        return homePosition + direction * followDistance;
      }
    }

    return MyCircle(index, homePosition, color, 40.0, interactionPosition);
  }
}

class MyCircle extends PositionComponent with HasGameRef<MyGame> {
  int id;
  late Vector2 adjustedPosition;
  late Vector2 homePosition;
  late Color color;
  late Vector2 lastMousePosition = Vector2(0, 0);
  double dropSpeed;
  Vector2 Function(Vector2, Vector2, double) interactionPosition;
  double randomNoise = Random().nextDouble() * 100.0;

  MyCircle(this.id, this.homePosition, this.color, this.dropSpeed,
      this.interactionPosition)
      : super(
          position: Vector2(0, 0),
          size: Vector2(40, 40),
          anchor: Anchor.center,
        ) {
    adjustedPosition = Vector2(homePosition.x, homePosition.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(adjustedPosition.toOffset(), 20, Paint()..color = color);
  }

  @override
  void update(double dt) {
    super.update(dt);

    homePosition.y += dropSpeed * dt;
    if (homePosition.y > gameRef.size.y) {
      homePosition.y = 0;
    }

    updatePosition();
  }

  void move(Vector2 targetPosition) {
    lastMousePosition = targetPosition;
  }

  void updatePosition() {
    adjustedPosition =
        interactionPosition(homePosition, lastMousePosition, randomNoise);
  }
}

class MyGame extends FlameGame with MouseMovementDetector {
  late Player player;
  late List<MyCircle> circles = [];

  void makeCircles() {
    for (int i = 0; i < 10; i++) {
      circles.add(CircleFactory.createRedCircle(i, Vector2(10.0, 10.0)));
      circles.add(CircleFactory.createBlueCircle(i, Vector2(10.0, 110.0)));
      circles.add(CircleFactory.createAmberCircle(i, Vector2(10.0, 210.0)));
      circles.add(CircleFactory.createRainbowCircle(i, Vector2(10.0, 410.0)));
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
