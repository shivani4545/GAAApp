class AttendanceStatusResponse {
  String? message;
  DateTime? shiftStartTime;
  DateTime? shiftEndTime;
  int? status;

  AttendanceStatusResponse({
    this.message,
    this.shiftStartTime,
    this.shiftEndTime,
    this.status,
  });

  factory AttendanceStatusResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceStatusResponse(
      message: json['message'],
      shiftStartTime: json['shift_start_time'] != null
          ? DateTime.tryParse(json['shift_start_time'])
          : null,
      shiftEndTime: json['shift_end_time'] != null
          ? DateTime.tryParse(json['shift_end_time'])
          : null,
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'shift_start_time': shiftStartTime?.toIso8601String(),
      'shift_end_time': shiftEndTime?.toIso8601String(),
      'status': status,
    };
  }
}
