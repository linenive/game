import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 앱 루트가 되는 위젯
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // 이 위젯은 앱의 홈 페이지입니다. Stateful입니다. 즉,
  // 하나의 State 객체(아래에 정의된)가 있으며 이 객체는 영향을 미치는 필드를 포함합니다.
  // 이 필드들은 화면이 어떻게 보이는지에 영향을 미칩니다.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // 이 setState 호출은 Flutter 프레임워크에게 이 상태에서 무언가가 변경되었음을 알려줍니다.
      // 이로 인해 아래의 build 메서드가 다시 실행되어 업데이트된 값을 반영할 수 있습니다.
      // 만약 setState()를 호출하지 않고 _counter를 변경한다면, build 메서드가 다시 호출되지 않으므로
      // 아무런 변화도 나타나지 않을 것입니다.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 이 메서드는 setState가 호출될 때마다 다시 실행됩니다.
    // 예를 들어 _incrementCounter 메서드에서 호출됩니다.
    //
    // Flutter 프레임워크는 build 메서드를 다시 실행하여 업데이트가 필요한 부분만 다시 빌드하는 최적화를 수행합니다.
    // 따라서 개별적으로 위젯 인스턴스를 변경하는 대신 업데이트가 필요한 부분만 다시 빌드할 수 있습니다.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
