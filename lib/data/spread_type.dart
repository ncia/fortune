enum SpreadType {
  oneCard,
  twoCard,
  threeCard,
  fourCard,
  fiveCard,
  celticCross,
}

extension SpreadTypeExtension on SpreadType {
  int get cardCount {
    switch (this) {
      case SpreadType.oneCard:
        return 1;
      case SpreadType.twoCard:
        return 2;
      case SpreadType.threeCard:
        return 3;
      case SpreadType.fourCard:
        return 4;
      case SpreadType.fiveCard:
        return 5;
      case SpreadType.celticCross:
        return 10;
    }
  }
}
