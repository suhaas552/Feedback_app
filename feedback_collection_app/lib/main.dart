import 'package:flutter/material.dart';

void main() {
  runApp(const FeedbackApp());
}

// 🔥 STATEFUL APP FOR THEME CONTROL
class FeedbackApp extends StatefulWidget {
  const FeedbackApp({super.key});

  @override
  State<FeedbackApp> createState() => _FeedbackAppState();
}

class _FeedbackAppState extends State<FeedbackApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: FeedbackPage(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

// 📦 MODEL CLASS
class Feedback {
  String name;
  String email;
  String summary;
  int rating;

  Feedback({
    required this.name,
    required this.email,
    required this.summary,
    required this.rating,
  });
}

// 🧾 MAIN PAGE
class FeedbackPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const FeedbackPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  List<Feedback> feedbackList = [];

  String name = "";
  String email = "";
  String summary = "";
  int rating = 0;

  int? editIndex;

  void submitForm() {
    if (_formKey.currentState!.validate() && rating != 0) {
      _formKey.currentState!.save();

      setState(() {
        if (editIndex == null) {
          // ADD
          feedbackList.add(
            Feedback(
              name: name,
              email: email,
              summary: summary,
              rating: rating,
            ),
          );
        } else {
          // UPDATE
          feedbackList[editIndex!] = Feedback(
            name: name,
            email: email,
            summary: summary,
            rating: rating,
          );
          editIndex = null;
        }
      });

      _formKey.currentState!.reset();
      rating = 0;
    }
  }

  void deleteFeedback(int index) {
    setState(() {
      feedbackList.removeAt(index);
    });
  }

  void editFeedback(int index) {
    setState(() {
      editIndex = index;
      name = feedbackList[index].name;
      email = feedbackList[index].email;
      summary = feedbackList[index].summary;
      rating = feedbackList[index].rating;
    });
  }

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () {
        setState(() {
          rating = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback CRUD App"),
        centerTitle: true,

        // 🌙☀️ THEME TOGGLE BUTTON
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.grey.shade900]
                : [Colors.blue.shade300, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          children: [

            // 🧾 FORM
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(5, (i) => buildStar(i + 1)),
                        ),

                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Name"),
                          validator: (v) =>
                              v!.isEmpty ? "Enter name" : null,
                          onSaved: (v) => name = v!,
                          initialValue: editIndex != null ? name : "",
                        ),

                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Email"),
                          validator: (v) =>
                              v!.contains('@') ? null : "Invalid email",
                          onSaved: (v) => email = v!,
                          initialValue: editIndex != null ? email : "",
                        ),

                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Summary"),
                          onSaved: (v) => summary = v!,
                          initialValue: editIndex != null ? summary : "",
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: submitForm,
                          child: Text(editIndex == null
                              ? "Add Feedback"
                              : "Update Feedback"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 📋 LIST VIEW
            Expanded(
              child: ListView.builder(
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  final fb = feedbackList[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(fb.name),
                      subtitle: Text(
                        "Email: ${fb.email}\nRating: ${fb.rating}\n${fb.summary}",
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ✏️ EDIT
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue),
                            onPressed: () => editFeedback(index),
                          ),

                          // ❌ DELETE
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () => deleteFeedback(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
