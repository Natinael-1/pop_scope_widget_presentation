import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PopScope demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Opens the second screen and waits until it closes.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateSomethingScreen()),
            );
          },
          child: const Text('Create Something'),
        ),
      ),
    );
  }
}

class CreateSomethingScreen extends StatefulWidget {
  const CreateSomethingScreen({super.key});

  @override
  State<CreateSomethingScreen> createState() => _CreateSomethingScreenState();
}

class _CreateSomethingScreenState extends State<CreateSomethingScreen> {
  bool hasChanges = false; // checks if user typed something
  bool protect = true; // checks if PopScope is turned on

  Future<void> _askBeforeLeaving() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change not saved.'),
        content: const Text('You have unsaved changes. Do you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (leave == true && mounted) {
      // Navigator.pop is not blocked by PopScope, so this closes the screen.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // false = the back button is blocked
      canPop: !(protect && hasChanges),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // the screen already closed, nothing to do
        _askBeforeLeaving(); // the back button was blocked, so ask the user
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Something')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Protect with PopScope'),
                value: protect,
                onChanged: (value) => setState(() => protect = value),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Write something..',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) => setState(() => hasChanges = text.isNotEmpty),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'saved'),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}