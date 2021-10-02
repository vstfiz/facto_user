class Feed{
  String url;
  String claim;
  String truth;
  String url1;
  String urlVideo;
  String docId;

  Feed(this.url, this.claim, this.truth, this.url1,this.docId);

  Feed.video(this.urlVideo, this.claim,this.url, this.truth);
}