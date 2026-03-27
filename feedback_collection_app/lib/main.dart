import 'package:flutter/material.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FeedbackPage(),
    );
  }
}

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

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback CRUD App"),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade900],
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
                          children: List.generate(5, (i) => buildStar(i + 1)),
                        ),

                        TextFormField(
                          decoration: const InputDecoration(labelText: "Name"),
                          validator: (v) =>
                              v!.isEmpty ? "Enter name" : null,
                          onSaved: (v) => name = v!,
                          initialValue: editIndex != null ? name : "",
                        ),

                        TextFormField(
                          decoration: const InputDecoration(labelText: "Email"),
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
                          "Email: ${fb.email}\nRating: ${fb.rating}\n${fb.summary}"),
                      isThreeLine: true,

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ✏️ EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editFeedback(index),
                          ),

                          // ❌ DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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