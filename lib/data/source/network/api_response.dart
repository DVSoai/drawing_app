
import '../../../core/utils/enum/status_api.dart';
class ApiResponse<T> {
  final int? code;
  final Status status;
  final T? data;
  final String? message;

  const ApiResponse._(
      {required this.status, this.data, this.code, this.message});

  const ApiResponse.loading() : this._(status: Status.loading);

  const ApiResponse.completed(T data, {int? code})
      : this._(status: Status.completed, data: data, code: code);

  const ApiResponse.error(String message, {int? code})
      : this._(status: Status.error, message: message, code: code);
  const ApiResponse.canceled() : this._(status: Status.canceled);

  @override
  String toString() {
    return "Status: $status\nMessage: $message\nData: $data";
  }
}

extension ApiResponseWhen<T> on ApiResponse<T> {
  R when<R>({
    required R Function() loading,
    required R Function(String? message) error,
    required R Function(T data) completed,
    R Function()? canceled,
  }) {
    switch (status) {
      case Status.loading:
        return loading();
      case Status.error:
        return error(message);
      case Status.completed:
        return completed(data as T);
      case Status.canceled:
        if (canceled != null) return canceled();
        throw Exception('Canceled handler not provided');
      default:
        throw Exception('Unknown status');
    }
  }
}

// class ApiResponse<T> {
//   Status? status;
//   T? data;
//   String? message;
//
//   ApiResponse(this.status, this.data, this.message);
//
//   ApiResponse.loading() : status = Status.loading;
//
//   ApiResponse.completed(this.data) : status = 24 Status.completed;
//
//   ApiResponse.error(this.message) : status = Status.error;
//
//   @override
//   String toString() {
//     return "Status : $status \n Message : $message \n Data: $data";
//   }
// }