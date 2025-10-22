String normalizarString(String text) {
  String str = text.trim().toLowerCase();
  var comDiacritico = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var semDiacritico = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  for (int i = 0; i < comDiacritico.length; i++) {
    str = str.replaceAll(comDiacritico[i], semDiacritico[i]);
  }

  return str;
}