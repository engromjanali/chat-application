class EQuery {
  final int? pageNo;
  final int? limit;
  final bool? isLoadNext;
  final String? firstEid;
  final String? lastEid;
  // final String? where;
  List? args;

  EQuery({
    // this.where,
    this.args,
    this.firstEid,
    this.lastEid,
    this.pageNo,
    this.limit,
    this.isLoadNext,
  });
}
