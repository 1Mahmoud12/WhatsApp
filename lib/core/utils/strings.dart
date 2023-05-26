class AppString {
  static const featuredMatch = 'Featured Match';
  static const tournaments = 'Tournaments';
  static const info = 'info';
  static const foundationDate = 'Foundation date';
  static const country = 'Country';
  static const venue = 'Venue';
  static const nameVenue = 'name';
  static const address = 'address';
  static const capacity = 'capacity';
  static const nationality = 'nationality';
  static const matched = 'Matches';
  static const height = 'height';
  static const weight = 'weight';

  /// Matches
  static const totalMatches = 'total matches';
  static const startedMatch = 'start';
  static const minutesPerGame = 'minutes per game';
  static const rate = 'Rate';

  ///  Duration Matches
  static Map<String,String> durationMatch={
    'NS':'NS',
    'CANC':'Cancelled',
    'PST':'Postponed',
    'HT':'Halftime',
    'FT':'Finished',
    '1H':'1nd half',
    '2H':'2nd Half',
    'TBD':'No Time ',
    'ET':'EX time',
    'BT':'Break Time',
    'P':'Penalty In Progress',
    'SUSP':'Match Suspended',
    'AET':'AET',
    'PEN':'FT Penalty',
    'INT':'Match Interrupted',
    'ABD':'Match Abandoned',
    'AWD':'Technical Loss',
    'WO':'WalkOver',
    'LIVE':'In Progress	',


  };

  /// substitutes
  static const substitutes = 'substitutes';
  static const substitutesIn = 'In';
  static const substitutesOut = 'Out';
  static const substitutesBench = 'Bench';

  /// Goals
  static const goals = 'Goals';
  static const totalGoals = 'Total';
  static const totalAssists = 'Assists';
  static const saved = 'Saved';

  /// Shots
  static const shots = 'Shots';
  static const totalShots = 'Total';
  static const onShots = 'On';

  /// Passes
  static const passes = 'Passes';
  static const totalPasses = 'Total';
  static const keyPasses = 'key';
  static const accuracyPasses = 'accuracy';

  /// Tackles
  static const tackles = 'Tackles';
  static const totalTackles = 'Total';
  static const blockTackles = 'block';
  static const interceptionsTackles = 'interceptions';

  /// dribbles
  static const dribbles = 'Dribbles';
  static const attemptsDribbles = 'attempts';
  static const successDribbles = 'success';
  static const pastDribbles = 'past';

  /// Fouls
  static const fouls = 'Fouls';
  static const drawnFouls = 'drawn';
  static const committedFouls = 'committed';

  /// Cards
  static const cards = 'Cards';
  static const yellowCards = 'drawn';
  static const redCards = 'committed';

  /// Penalty
  static const penalty = 'Penalty';
  static const wonPenalty = 'won';
  static const scoredPenalty = 'scored';
  static const missedPenalty = 'missed';

  /// position
  static const position = 'Position';
}
