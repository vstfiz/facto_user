class SearchResults {
  String news;
  String claimId;
  String requestedByUid;
  String url2;
  String status;

  SearchResults(
      {this.news,
        this.claimId,
        this.requestedByUid,
        this.url2,
        this.status});

  SearchResults.fromJson(Map<String, dynamic> json) {
    news = json['news'];
    claimId = json['claimId'];
    requestedByUid = json['requestedByUid'];
    url2 = json.containsKey('url2')?json['url2']:null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news'] = this.news;
    data['claimId'] = this.claimId;
    data['requestedByUid'] = this.requestedByUid;
    data['url2'] = this.url2;
    data['status'] = this.status;
    return data;
  }
}