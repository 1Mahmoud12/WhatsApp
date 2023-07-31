abstract class BaseSignEvent {}

class SignEvent extends BaseSignEvent {
  final Map<String, dynamic> json;
  SignEvent(this.json);
}
