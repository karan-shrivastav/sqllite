import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqllite/models/sql_data_model.dart';
import '../services/database_functions.dart';
import '../widgets/add_items.dart';
import 'cart_screen.dart';

class HomePage extends StatefulWidget {
  static const route = '/home-screen';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isConnected = false;

  Future<List<SqlDataModel>>? futureTodos;
  final todoDB = DatabaseFunctions();

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  Future<void> _createLocalData() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return AddTaskLocal(
            onSubmit: (Map<String, String> data) async {
              final name = data['name'];
              final price = data['price'];

              await todoDB.create(
                name: name ?? '',
                price: price ?? '',
              );
              if (!mounted) return;
              fetchTodos();
              Navigator.of(context).pop();
            },
          );
        });
  }

  List<SqlDataModel> cartItems = [];
  void addToCart(SqlDataModel todo) {
    cartItems.add(SqlDataModel(
      id: todo.id,
      name: todo.name,
      price: todo.price ?? '0',
    ));
    setState(() {

    });
  }

  double getTotalPrice() {
    return cartItems.fold(
      0,
      (total, item) => total + double.parse(item.price) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    fetchTodos();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('All Items')),
      ),
      drawer: const SizedBox(),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(
                cartItems: cartItems,
                totalPrice: getTotalPrice(),
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(16)),
          child: const Text(
            'Go to Cart',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<SqlDataModel>>(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                final todos = snapshot.data!;
                return todos.isEmpty
                    ? const Center(
                        child: Text(
                          'No Items available.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${todo.name} is added to the cart.',
                                    ),
                                  ),
                                );
                                addToCart(todo);
                              },
                              title: Text(
                                todo.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                todo.price ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () async {
                                  await todoDB.delete(todo.id);
                                  fetchTodos();
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              } else {
                return const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () async {
            _createLocalData();
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
