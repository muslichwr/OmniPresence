class AppConstants {
  // API Constants
  static const String appwriteEndpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String appwriteProjectId = '683fc50f003c8e35ea93';
  static const String appwriteDatabaseId = '68406fcf0038330f9b26';

  // Collection IDs
  static const String usersCollection = 'users';
  static const String classesCollection = 'classes';
  static const String subjectsCollection = 'subjects';
  static const String attendanceSessionsCollection = 'attendance_sessions';
  static const String attendanceRecordsCollection = 'attendance_records';
  static const String announcementsCollection = 'announcements';
  static const String notificationsCollection = 'notifications';
  static const String systemSettingsCollection = 'system_settings';

  // Session Code Constants
  static const int sessionCodeLength = 6;
  static const int defaultSessionDurationMinutes = 15;
  static const int lateThresholdMinutes = 10;

  // User Roles
  static const String roleStudent = 'student';
  static const String roleTeacher = 'teacher';
  static const String roleAdmin = 'admin';

  // Attendance Status
  static const String statusPresent = 'present';
  static const String statusLate = 'late';
  static const String statusAbsent = 'absent';

  // Session Status
  static const String sessionStatusActive = 'active';
  static const String sessionStatusExpired = 'expired';
  static const String sessionStatusCompleted = 'completed';

  // Announcement Priority
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';
  static const String priorityUrgent = 'urgent';

  // Announcement Target Audience
  static const String audienceAll = 'all';
  static const String audienceStudents = 'students';
  static const String audienceTeachers = 'teachers';
  static const String audienceSpecificClass = 'specific_class';

  // Notification Types
  static const String notificationAttendance = 'attendance';
  static const String notificationAnnouncement = 'announcement';
  static const String notificationSystem = 'system';
  static const String notificationReminder = 'reminder';

  // Shared Preferences Keys
  static const String prefUserId = 'user_id';
  static const String prefUserRole = 'user_role';
  static const String prefUserName = 'user_name';
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefThemeMode = 'theme_mode';

  // Validation Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String studentIdPattern = r'^\d{4}-[A-Z0-9]{4}-\d{4}$';
  static const String phonePattern = r'^(\+62|08)\d{8,12}$';

  // Error Messages
  static const String errorNetworkMessage =
      'Network error. Check your connection and try again.';
  static const String errorServerMessage =
      'Server error. Please try again later.';
  static const String errorUnauthorizedMessage =
      'You are not authorized to perform this action.';
  static const String errorInvalidCredentials = 'Invalid email or password.';
  static const String errorInvalidSessionCode =
      'Invalid session code. Please check and try again.';
  static const String errorSessionExpired = 'This session has expired.';
  static const String errorAlreadyAttended =
      'You have already marked your attendance for this session.';

  // Navigation Routes (for deep linking)
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeDashboard = '/dashboard';
  static const String routeAttendance = '/attendance';
  static const String routeAnnouncements = '/announcements';
  static const String routeProfile = '/profile';
  static const String routeReports = '/reports';
  static const String routeSettings = '/settings';
}
