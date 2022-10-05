part of virtual_keyboard;

/// Virtual Keyboard key
class VirtualKeyboardKey {
  final String text;
  final String capsText;
  final VirtualKeyboardKeyType keyType;
  final VirtualKeyboardKeyAction? action;

  VirtualKeyboardKey(
      {required this.text,
      required this.capsText,
      required this.keyType,
      this.action});
}
