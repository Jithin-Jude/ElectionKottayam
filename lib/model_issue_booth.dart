class ModelIssue{
  String rId;
  String phoneNumber;
  String issueName;
  String issueReportTime;
  String issueDescription;
  int issueCount = 1;
  String issueStatus;
  bool select;
  String boothName;
  String boothPhone;
  String sectorName;

  ModelIssue(this.rId, this.phoneNumber, this.sectorName, this.boothName, this.issueName, this.issueReportTime, this.issueDescription, this.issueStatus,this.boothPhone, this.select);
}