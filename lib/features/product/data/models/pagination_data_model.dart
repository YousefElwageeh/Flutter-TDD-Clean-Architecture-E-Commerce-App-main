import '../../domain/entities/pagination_meta_data.dart';

class PaginationMetaDataModel extends PaginationMetaData {
  PaginationMetaDataModel({
    required int page,
    required super.pageSize,
    required super.total,
  }) : super(
          limit: page,
        );

  factory PaginationMetaDataModel.fromJson(Map<String, dynamic> json) =>
      PaginationMetaDataModel(
        page: json["page"],
        pageSize: json["pageSize"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": limit,
        "pageSize": pageSize,
        "total": total,
      };
}
