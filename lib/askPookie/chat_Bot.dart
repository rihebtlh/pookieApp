import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List<dynamic> data = [];
  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, // Gradient starts from the top left
        end: Alignment.bottomRight, // Ends at the bottom right
        colors: [
          Colors.lightBlue.shade100,  // First color (cute pink)
          Colors.pink.shade100, // Second color (cute purple)
        ],
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Ask Pookie", style: TextStyle(color: Colors.white)),
      ),
      body: Stack( // Use Stack to position the image freely
        children: [
          Column(
            children: [
              // Quick Topic Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTopicButton("🛏️ Bedtime Story", "Tell me a bedtime story."),
                    SizedBox(width: 8),
                    _buildTopicButton("😂 Joke", "Tell me a funny joke!"),
                    SizedBox(width: 8),
                    _buildTopicButton("🤯 Fun Fact", "Tell me a fun fact!"),
                  ],
                ),
              ),
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
                            color: isUser ? Theme.of(context).colorScheme.primary : Colors.white,
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
                              color: isUser ? Colors.white : Theme.of(context).colorScheme.secondary,
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
                        style: TextStyle(color: Colors.black), // Set text color to black
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Background color remains white
                          hintText: "Ask me anything...",
                          hintStyle: TextStyle(color: Colors.grey), // Optional: Set hint text color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
          Positioned(
            top: 10, // Adjust to position the image
            left: 20, // Adjust left positioning
            child: Image.asset(
              'assets/cat1.png',
              width: 87.5,
              height: 50,
            ),
          ),
          /*Positioned(
            top: 50, // Adjust to position the image
            left: 20, // Adjust left positioning
            child: Image.asset(
              'assets/stars.png',
              width: 175,
              height: 100,
            ),
          ),*/
        ],
      ),
    ),
  );
}


  // Function to clean unwanted characters from the response
String cleanResponse(String response) {
  // Regular expression to remove non-ASCII characters
  return response.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
}

Future<void> sendMessage() async {
  String query = queryController.text;
  if (query.isEmpty) return;

  // Add user's message to chat
  setState(() {
    data.add({'message': query, 'type': 'user'});
    queryController.clear();
  });

  var url = Uri.parse("https://api-inference.huggingface.co/v1/chat/completions");

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer "  // Replace with your actual Hugging Face API key
  };

  var payload = json.encode({
    "model": "mistralai/Mistral-7B-Instruct-v0.3",
    "messages": [
      {"role": "system", "content": "You are a friendly AI assistant for kids. Use simple words, talk only when necessary, and make learning fun!"},
      {"role": "user", "content": query}
    ],
    "parameters": {
      "max_length": 200,
      "temperature": 0.7,
      "top_p": 0.9
    }
  });

  try {
    var response = await http.post(url, headers: headers, body: payload);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print("Response: $result");  // Debugging

      if (result.containsKey("choices") && result["choices"].isNotEmpty) {
        // Clean the generated text before displaying it
        String cleanMessage = cleanResponse(result["choices"][0]["message"]["content"] ?? "No response.");
        setState(() {
          data.add({
            "message": result["choices"][0]["message"]["content"] ?? "No response.",
            "type": "assistant"
          });
        });
      } else {
        setState(() {
          data.add({"message": "Unexpected response format.", "type": "assistant"});
        });
      }

      scrollController.jumpTo(scrollController.position.maxScrollExtent + 60);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      setState(() {
        data.add({"message": "Error: ${response.statusCode} - ${response.body}", "type": "assistant"});
      });
    }
  } catch (e) {
    print("Request failed: $e");
    setState(() {
      data.add({"message": "Request failed: $e", "type": "assistant"});
    });
  }
}


  Widget _buildTopicButton(String text, String query) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        //backgroundColor: Colors.pinkAccent,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () {
        queryController.text = query;
        sendMessage();
      },
      child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14, // 👈 Adjust this to make the text larger
        fontWeight: FontWeight.bold, // Optional: Makes text bold for better visibility
      ),
    ),
    );
  }
}
