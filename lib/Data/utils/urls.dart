class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  // Authentication
  static const String registrationUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';

  // Forgot-Password Flow
  static String recoverVerifyEmailUrl(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';

  static String recoverVerifyOtpUrl(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOTP/$email/$otp';

  // Task APIs
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String newTaskListUrl = '$_baseUrl/listTaskByStatus/New';
  static const String progressTaskListUrl =
      '$_baseUrl/listTaskByStatus/Progress';
  static const String cancelledTaskListUrl =
      '$_baseUrl/listTaskByStatus/Cancelled';
  static const String completedTaskListUrl =
      '$_baseUrl/listTaskByStatus/Completed';

  // Update Task Status
  static String updateTaskStatusUrl(String id, String newStatus) =>
      '$_baseUrl/updateTaskStatus/$id/$newStatus';

  //update profile
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';

  // Delete Task
  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';

  static String recoverResetPassUrl(String email, String otp, String password) {
    return '$_baseUrl/RecoverResetPass/'
        '${Uri.encodeComponent(email)}/'
        '${Uri.encodeComponent(otp)}/'
        '${Uri.encodeComponent(password)}';
  }

  // POST endpoints

  static String recoverResetPassPost() => '$_baseUrl/RecoverResetPass';
  static String recoverResetPasswordPost() => '$_baseUrl/RecoverResetPassword';

  // GET endpoints
  static String recoverResetPassGet(
    String email,
    String otp,
    String password,
  ) =>
      '$_baseUrl/RecoverResetPass/'
      '${Uri.encodeComponent(email)}/'
      '${Uri.encodeComponent(otp)}/'
      '${Uri.encodeComponent(password)}';

  static String recoverResetPasswordGet(
    String email,
    String otp,
    String password,
  ) =>
      '$_baseUrl/RecoverResetPassword/'
      '${Uri.encodeComponent(email)}/'
      '${Uri.encodeComponent(otp)}/'
      '${Uri.encodeComponent(password)}';
}
