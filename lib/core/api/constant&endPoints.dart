class Constants {
  static String tokenKey = 'TOKEN';
  static String? token;

  static String? language;

  static String baseUrl = "https://nffpm-demo.ecom.mm4web.net";
  static String userName = "";
}

class EndPoints {
  static const String login = '/api/login';
  static const String register = '/api/signup';
  static const String forgetPassword = 'forget-password';
  static const String logout = '/api/logout';

  static const String sliders = '/api/slider';
  static const String userData = '/api/user-data';
  static const String getCard = '/api/v2/carts';

  static const String addTocard = '/api/v2/carts/add';

  static const String sendOTp = '/api/forgot';

  static const String submitOTP = '/api/submit-code';
  static const String changePassword = '/api/reset-change-password';

  static const String addresses = '/api/addresses';
  static const String teams = '/api/game-teams';
  static const String singleGame = '/api/single-game';

  static const String joinGame = '/api/join-game';
  static const String gameChallenges = '/api/game-challenges';
  static const String getPlayerGames = '/api/player-games';
  static const String submitChallenge = '/api/submit-challenge';
  static const String leaderboard = '/api/leaderboard';
  static const String gamingHub = '/api/mobile-settings';
  static const String countries = '/api/countries';

  static const String gameCategories = '/api/categories';
  static const String challengeCategories = '/api/challenge-categories';

  static const String playerChallenges = '/api/player-challenges';
  static const String playerActivity = '/api/activity';
  static const String likeActivity = '/api/like-activity';
  static const String sendMessage = '/api/send-messages';
  static const String getMessages = '/api/chat-messages/';

  static const String editprofile = '/api/profile/update';
  static const String deleteprofile = '/api/user-delete';

  static const String loginGoogle = '/api/login-google';
  static const String loginFacebook = '/api/login-facebook';
  static const String loginApple = '/api/login-apple';

  static const String notifications = '/api/notifications';
}
