abstract class ChatState {}

class InitialState extends ChatState {}

class BottomNavigationChangeState extends ChatState {}

class AddMessageState extends ChatState {}

class GetContactState extends ChatState {}

class GetImageState extends ChatState {}

class GetNameState extends ChatState {}

class ChangeBoolState extends ChatState {}

class GetAllUsersLoadingState extends ChatState {}

class GetAllUsersSuccessState extends ChatState {}

class GetAllUsersErrorState extends ChatState {}

/// images

class GetImageLoadingState extends ChatState {}

class GetImageSuccessState extends ChatState {}

/// Create Messages
class CreateMessageLoadingState extends ChatState {}

class CreateMessageSuccessState extends ChatState {}

/// Get Chats
class GetChatsLoadingState extends ChatState {}

class GetChatsSuccessState extends ChatState {}

/// Get Chats
class GetMessagesSuccessState extends ChatState {}

class GetMessagesErrorState extends ChatState {}

class GetMessagesLoadingState extends ChatState {}

/// Get Chats
class RemoveMessagesSuccessState extends ChatState {}

class RemoveMessagesErrorState extends ChatState {}

class RemoveMessagesLoadingState extends ChatState {}

/// Get Calls
class GetCallsSuccessState extends ChatState {}

class GetCallsErrorState extends ChatState {}

class GetCallsLoadingState extends ChatState {}

/// Add Calls
class AddCallsSuccessState extends ChatState {}

class AddCallsErrorState extends ChatState {}

class AddCallsLoadingState extends ChatState {}

/// Get Last Message
class GetLastMessagesState extends ChatState {}

class AddAudioState extends ChatState {}

/// control with emoji
class ChangeEmojiState extends ChatState {}

class IncrementState extends ChatState {}
