import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_assignment/live_scores.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MatchList());
  }
}

class MatchList extends StatefulWidget {
  const MatchList({super.key});

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<LiveScores> _listOfScores = [];
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("football")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match List", style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: _usersStream,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error.toString()));
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasData) {
            _listOfScores.clear();

            for (QueryDocumentSnapshot doc in asyncSnapshot.data!.docs) {
              LiveScores liveScores = LiveScores(
                id: doc.id,
                team1_name: doc.get("team1_name"),
                team2_name: doc.get("team2_name"),
                team1_score: doc.get("team1_score"),
                team2_score: doc.get("team2_score"),
                time: {doc.get("time") as num}.toString(),
                total_time: doc.get("total_time"),
              );
              _listOfScores.add(liveScores);
            }
            //setState(() {});
          }
          {
            return ListView.builder(
              itemCount: _listOfScores.length,
              itemBuilder: (context, index) {
                LiveScores liveScores = _listOfScores[index];
                return ListTile(
                  title: Text(liveScores.id),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            id: liveScores.id,
                            team1_name: liveScores.team1_name,
                            team2_name: liveScores.team2_name,
                            team1_score: liveScores.team1_score,
                            team2_score: liveScores.team2_score,
                            time: liveScores.time,
                            total_time: liveScores.total_time,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_right),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final String id;
  final String team1_name;
  final String team2_name;
  final int team1_score;
  final int team2_score;
  final String time;
  final int total_time;

  const DetailsScreen({
    super.key,
    required this.id,
    required this.team1_name,
    required this.team2_name,
    required this.team1_score,
    required this.team2_score,
    required this.time,
    required this.total_time,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id, style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.id, style: TextStyle(fontSize: 30)),
                    Text(
                      "${widget.team1_score} : ${widget.team2_score}",
                      style: TextStyle(fontSize: 34),
                    ),
                    Text("Time : ${widget.time}"),
                    Text("Total Time : ${widget.total_time}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
