import 'package:flutter/material.dart';
import 'package:vazifa/db/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerNew = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controllerNew.dispose();
    super.dispose();
  }

  Future<void> _showAddTaskDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Vazifani yozing")),
        content: SizedBox(
          width: double.infinity,
          height: 100,
          child: Column(
            children: [
              // input
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await VazifaDb().openBox();
                      await VazifaDb().writeToDb(_controller.text);
                      _controller.clear();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.save_as_outlined,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditTaskDialog(int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Vazifani o'zgartirish")),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerNew,
                decoration: InputDecoration(
                  hintText: "Yangi vazifani yozing",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await VazifaDb().openBox();
                      await VazifaDb().editDbData(index, _controllerNew.text);
                      Navigator.pop(context);
                      setState(() {});
                      _controllerNew.clear();
                    },
                    icon: const Icon(
                      Icons.save_as_outlined,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("O'chirilsinmi?")),
        content: SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () async {
                  await VazifaDb().openBox();
                  await VazifaDb().deleteDbData(index);
                  setState(() {});
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, int index, List<dynamic> data) {
    return InkWell(
      onLongPress: () async {
        await _showDeleteConfirmationDialog(index);
      },
      onTap: () async {
        await _showEditTaskDialog(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xff222222),
            ),
          ),
          width: double.infinity,
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data[index].toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VAZIFALAR"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: VazifaDb().getDbData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: SizedBox.shrink());
          } else if (snapshot.data is String) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 22),
              ),
            );
          } else {
            List<dynamic> data = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemBuilder: (context, index) {
                return _buildTaskItem(context, index, data);
              },
              itemCount: data.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTaskDialog();
        },
        label: const Text("Yangi Vazifa"),
      ),
    );
  }
}
