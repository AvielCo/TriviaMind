String decodeUTF8String(String str) {
  // Decode URL encoded string (e.g: "Some%20String" => "Some String")
  return Uri.decodeFull((str));
}
