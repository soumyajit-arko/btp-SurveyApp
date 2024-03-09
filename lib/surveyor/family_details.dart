class FamilyDetails {
  final String subjectID;
  final String subjectName;
  final String spouseName;
  final String childName;
  final String? startDate;
  final String? endDate;
  FamilyDetails({
    required this.subjectID,
    required this.subjectName,
    required this.spouseName,
    required this.childName,
    this.startDate,
    this.endDate,
  });
}
