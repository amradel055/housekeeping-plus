import 'package:easy_hotel/app/data/model/base_request.dart';

class AllOrdersRequestDto extends BaseRequest {
  AllOrdersRequestDto({
    this.branchId,
    this.finishBy,
  });

  int? branchId;
  int? finishBy;

  @override
  Map<String, dynamic> toJson() => {
    "branchId": branchId,
    "finishBy": finishBy,
  };
}
