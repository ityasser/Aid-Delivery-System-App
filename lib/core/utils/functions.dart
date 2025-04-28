mixin FunctionsGeneral {
  String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    try{
      final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
      return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
    }catch(error){
      return "";
    }

  }
  String getYoutubeThumbnail(String id){
    return 'https://img.youtube.com/vi/$id/sddefault.jpg';

  }
  String getIdFromUrlYoutube(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1)
        return match.group(1)??"";
    }

    return "";
  }
  // static var maskFormatterPhone = new MaskTextInputFormatter(
  //     mask: '+(###) ##-###-####',
  //     filter: { "#": RegExp(r'[0-9]') },
  //     type: MaskAutoCompletionType.lazy
  // );
}