class Apis {
  static const String _baseUrl = "https://gaa.novuslogic.in/api/";
  static const String login = "${_baseUrl}login";
  static const String startShift = "${_baseUrl}start_shift";
  static const String endShift = "${_baseUrl}end_shift";
  static const String updateLocation = "${_baseUrl}location";
  static const String allAppointments = "${_baseUrl}AllAppointments";
  static String attendance(String userId) => "${_baseUrl}attendance/$userId";
  static String upcomingAppointments(String userId) => "${_baseUrl}upcomingAppointment/$userId";
  static const String savePersonalInfo = "${_baseUrl}save_personal_information";
  static const String savePropertyInformation = "${_baseUrl}save_property_information";
  static const String saveLocationInformation = "${_baseUrl}save_location_information";
  static const String saveMoreDetails = "${_baseUrl}save_more_details";
  static const String saveAdditionalDetails = "${_baseUrl}save_additional_details";
}