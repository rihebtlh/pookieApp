import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> data = [];
  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Chat Page", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.pink[50],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                bool isUser = data[index]['type'] == 'user';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.pinkAccent : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Text(
                        data[index]['message'] ?? "",
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black,
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
  String query = queryController.text;
  if (query.isEmpty) return;
  
  setState(() {
    data.add({'message': query, 'type': 'user'});
    queryController.clear();
  });

  var url = Uri.parse("https://api-inference.huggingface.co/models/google/gemma-2-2b-it");
  Map<String, String> userHeaders = {
    "Content-type": "application/json",
    "Authorization": "Bearer " // Replace with your Hugging Face API key
  };

  var payload = json.encode({
    "inputs": query,
  });

  // Debugging: log the request
  print("Requesting Hugging Face API with payload: $payload");

  http.post(url,
    headers: userHeaders,
    body: payload,
  ).then((resp) {
    if (resp.statusCode == 200) {
      var result = json.decode(resp.body);

      // Check if the response is not empty and extract generated text
      if (result.isNotEmpty && result[0].containsKey('generated_text')) {
        setState(() {
          data.add({
            "message": result[0]['generated_text'] ?? "No response generated.",
            "type": "assistant"
          });
        });
      } else {
        setState(() {
          data.add({
            "message": "Sorry, no valid response from the model.",
            "type": "assistant"
          });
        });
      }

      scrollController.jumpTo(scrollController.position.maxScrollExtent + 60);
    } else {
      print("Error: ${resp.statusCode} - ${resp.body}");
    }
  }).catchError((err) {
    // Debugging: log errors
    print("Error: $err");
  });
}

}
