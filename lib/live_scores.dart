class LiveScores {
  final String id;
  final String team1_name;
  final String team2_name;
  final int team1_score;
  final int team2_score;
  final String time;
  final int total_time;

  LiveScores({
    required this.id,
    required this.team1_name,
    required this.team2_name,
    required this.team1_score,
    required this.team2_score,
    required this.time,
    required this.total_time,
  });
}
