class DashboardModel {
  final int totalEmployees;
  final int presentCount;
  final int leaveCount;
  final int permissionCount;
  final int halfDayCount;

  DashboardModel({
    required this.totalEmployees,
    required this.presentCount,
    required this.leaveCount,
    required this.permissionCount,
    required this.halfDayCount,
  });

  factory DashboardModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DashboardModel(
      totalEmployees:
      int.tryParse(
        json["totalEmployees"].toString(),
      ) ??
          0,

      presentCount:
      int.tryParse(
        json["presentCount"].toString(),
      ) ??
          0,

      leaveCount:
      int.tryParse(
        json["leaveCount"].toString(),
      ) ??
          0,

      permissionCount:
      int.tryParse(
        json["permissionCount"].toString(),
      ) ??
          0,

      halfDayCount:
      int.tryParse(
        json["halfDayCount"].toString(),
      ) ??
          0,
    );
  }
}