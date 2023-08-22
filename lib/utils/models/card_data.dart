class CardData {
  String? cardName;
  int? numTenTokens;
  int? numFiftyTokens;
  int? numHundredTokens;
  int? numFiveHundredTokens;
  bool? isPressed;
  CardData(
      {this.cardName,
      this.numFiftyTokens = 0,
      this.numFiveHundredTokens = 0,
      this.numHundredTokens = 0,
      this.numTenTokens = 0,
      this.isPressed = false});
}
