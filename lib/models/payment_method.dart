enum PaymentMethod {
  upi,
  creditCard,
  debitCard,
  netBanking,
  wallet,
  cash,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.cash:
        return 'Cash';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.upi:
        return '📱';
      case PaymentMethod.creditCard:
        return '💳';
      case PaymentMethod.debitCard:
        return '💳';
      case PaymentMethod.netBanking:
        return '🏦';
      case PaymentMethod.wallet:
        return '👛';
      case PaymentMethod.cash:
        return '💵';
    }
  }

  String get description {
    switch (this) {
      case PaymentMethod.upi:
        return 'Pay via UPI (GPay, PhonePe, Paytm)';
      case PaymentMethod.creditCard:
        return 'Visa, Mastercard, RuPay';
      case PaymentMethod.debitCard:
        return 'Debit Card Payment';
      case PaymentMethod.netBanking:
        return 'Internet Banking';
      case PaymentMethod.wallet:
        return 'Paytm, PhonePe Wallet';
      case PaymentMethod.cash:
        return 'Pay at the parking location';
    }
  }
}

