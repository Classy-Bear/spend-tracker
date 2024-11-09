import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const SUPABASE_URL = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
const ANON_KEY = String.fromEnvironment('ANON_KEY', defaultValue: '');

Future<void> main() async {
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: ANON_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todos',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final future = supabase.from('email_notifications_t').select();
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: ((context, index) {
              final todo = todos[index];
              return ExpansionTile(
                title: Text(todo['consumption_locality']),
                leading: todo['consumption_status'] == 'Aprobada'
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                trailing: Text('\$${todo['consumption_amount']}'),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.centerLeft,
                childrenPadding: const EdgeInsets.only(left: 52.0),
                children: [
                  const SizedBox(height: 8.0),
                  Text('Bank: ${todo['email_bank']}'),
                  const SizedBox(height: 8.0),
                  Text('Consumption date: ${todo['consumption_datetime']}'),
                  const SizedBox(height: 8.0),
                  Text('Consumption type: ${todo['consumption_type']}'),
                  const SizedBox(height: 8.0),
                  Text('Sender: ${todo['email_sender']}'),
                  const SizedBox(height: 8.0),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
