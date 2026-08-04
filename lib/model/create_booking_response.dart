class CreateBookingResponse {
  CreateBookingResponse({
      this.success, 
      this.code, 
      this.message,
      this.body,});

  CreateBookingResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }
  bool? success;
  int? code;
  String? message;
  Body? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['code'] = code;
    if (body != null) {
      map['body'] = body?.toJson();
    }
    return map;
  }

}

class Body {
  Body({
      this.paymentIntent, 
      this.ephemeralKey, 
      this.customer, 
      this.transactionId,
      this.bookingId,
  });

  Body.fromJson(dynamic json) {
    paymentIntent = json['paymentIntent'] != null ? PaymentIntent.fromJson(json['paymentIntent']) : null;
    ephemeralKey = json['ephemeralKey'];
    customer = json['customer'];
    transactionId = json['transactionId'];
    bookingId = json['bookingId'];
  }
  PaymentIntent? paymentIntent;
  String? ephemeralKey;
  String? customer;
  String? transactionId;
  String? bookingId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (paymentIntent != null) {
      map['paymentIntent'] = paymentIntent?.toJson();
    }
    map['ephemeralKey'] = ephemeralKey;
    map['customer'] = customer;
    map['transactionId'] = transactionId;
    map['bookingId'] = bookingId;
    return map;
  }

}

class PaymentIntent {
  PaymentIntent({
      this.id, 
      this.object, 
      this.amount, 
      this.amountCapturable, 
      this.amountDetails, 
      this.amountReceived, 
      this.application, 
      this.applicationFeeAmount, 
      this.automaticPaymentMethods, 
      this.canceledAt, 
      this.cancellationReason, 
      this.captureMethod, 
      this.clientSecret, 
      this.confirmationMethod, 
      this.created, 
      this.currency, 
      this.customer, 
      this.customerAccount, 
      this.description, 
      this.excludedPaymentMethodTypes, 
      this.lastPaymentError, 
      this.latestCharge, 
      this.livemode, 
      this.metadata, 
      this.nextAction, 
      this.onBehalfOf, 
      this.paymentMethod, 
      this.paymentMethodConfigurationDetails, 
      this.paymentMethodOptions, 
      this.paymentMethodTypes, 
      this.processing, 
      this.receiptEmail, 
      this.review, 
      this.setupFutureUsage, 
      this.shipping, 
      this.source, 
      this.statementDescriptor, 
      this.statementDescriptorSuffix, 
      this.status, 
      this.transferData, 
      this.transferGroup,});

  PaymentIntent.fromJson(dynamic json) {
    id = json['id'];
    object = json['object'];
    amount = json['amount'];
    amountCapturable = json['amount_capturable'];
    amountDetails = json['amount_details'] != null ? AmountDetails.fromJson(json['amount_details']) : null;
    amountReceived = json['amount_received'];
    application = json['application'];
    applicationFeeAmount = json['application_fee_amount'];
    automaticPaymentMethods = json['automatic_payment_methods'] != null ? AutomaticPaymentMethods.fromJson(json['automatic_payment_methods']) : null;
    canceledAt = json['canceled_at'];
    cancellationReason = json['cancellation_reason'];
    captureMethod = json['capture_method'];
    clientSecret = json['client_secret'];
    confirmationMethod = json['confirmation_method'];
    created = json['created'];
    currency = json['currency'];
    customer = json['customer'];
    customerAccount = json['customer_account'];
    description = json['description'];
    excludedPaymentMethodTypes = json['excluded_payment_method_types'];
    lastPaymentError = json['last_payment_error'];
    latestCharge = json['latest_charge'];
    livemode = json['livemode'];
    metadata = json['metadata'];
    nextAction = json['next_action'];
    onBehalfOf = json['on_behalf_of'];
    paymentMethod = json['payment_method'];
    paymentMethodConfigurationDetails = json['payment_method_configuration_details'] != null ? PaymentMethodConfigurationDetails.fromJson(json['payment_method_configuration_details']) : null;
    paymentMethodOptions = json['payment_method_options'] != null ? PaymentMethodOptions.fromJson(json['payment_method_options']) : null;
    paymentMethodTypes = json['payment_method_types'] != null ? json['payment_method_types'].cast<String>() : [];
    processing = json['processing'];
    receiptEmail = json['receipt_email'];
    review = json['review'];
    setupFutureUsage = json['setup_future_usage'];
    shipping = json['shipping'];
    source = json['source'];
    statementDescriptor = json['statement_descriptor'];
    statementDescriptorSuffix = json['statement_descriptor_suffix'];
    status = json['status'];
    transferData = json['transfer_data'];
    transferGroup = json['transfer_group'];
  }
  String? id;
  String? object;
  int? amount;
  int? amountCapturable;
  AmountDetails? amountDetails;
  int? amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  AutomaticPaymentMethods? automaticPaymentMethods;
  dynamic canceledAt;
  dynamic cancellationReason;
  String? captureMethod;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  String? customer;
  dynamic customerAccount;
  dynamic description;
  dynamic excludedPaymentMethodTypes;
  dynamic lastPaymentError;
  dynamic latestCharge;
  bool? livemode;
  dynamic metadata;
  dynamic nextAction;
  dynamic onBehalfOf;
  dynamic paymentMethod;
  PaymentMethodConfigurationDetails? paymentMethodConfigurationDetails;
  PaymentMethodOptions? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  dynamic processing;
  dynamic receiptEmail;
  dynamic review;
  dynamic setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String? status;
  dynamic transferData;
  dynamic transferGroup;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['object'] = object;
    map['amount'] = amount;
    map['amount_capturable'] = amountCapturable;
    if (amountDetails != null) {
      map['amount_details'] = amountDetails?.toJson();
    }
    map['amount_received'] = amountReceived;
    map['application'] = application;
    map['application_fee_amount'] = applicationFeeAmount;
    if (automaticPaymentMethods != null) {
      map['automatic_payment_methods'] = automaticPaymentMethods?.toJson();
    }
    map['canceled_at'] = canceledAt;
    map['cancellation_reason'] = cancellationReason;
    map['capture_method'] = captureMethod;
    map['client_secret'] = clientSecret;
    map['confirmation_method'] = confirmationMethod;
    map['created'] = created;
    map['currency'] = currency;
    map['customer'] = customer;
    map['customer_account'] = customerAccount;
    map['description'] = description;
    map['excluded_payment_method_types'] = excludedPaymentMethodTypes;
    map['last_payment_error'] = lastPaymentError;
    map['latest_charge'] = latestCharge;
    map['livemode'] = livemode;
    map['metadata'] = metadata;
    map['next_action'] = nextAction;
    map['on_behalf_of'] = onBehalfOf;
    map['payment_method'] = paymentMethod;
    if (paymentMethodConfigurationDetails != null) {
      map['payment_method_configuration_details'] = paymentMethodConfigurationDetails?.toJson();
    }
    if (paymentMethodOptions != null) {
      map['payment_method_options'] = paymentMethodOptions?.toJson();
    }
    map['payment_method_types'] = paymentMethodTypes;
    map['processing'] = processing;
    map['receipt_email'] = receiptEmail;
    map['review'] = review;
    map['setup_future_usage'] = setupFutureUsage;
    map['shipping'] = shipping;
    map['source'] = source;
    map['statement_descriptor'] = statementDescriptor;
    map['statement_descriptor_suffix'] = statementDescriptorSuffix;
    map['status'] = status;
    map['transfer_data'] = transferData;
    map['transfer_group'] = transferGroup;
    return map;
  }

}

class PaymentMethodOptions {
  PaymentMethodOptions({
      this.card, 
      this.klarna, 
      this.link,});

  PaymentMethodOptions.fromJson(dynamic json) {
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    klarna = json['klarna'] != null ? Klarna.fromJson(json['klarna']) : null;
    link = json['link'] != null ? Link.fromJson(json['link']) : null;
  }
  Card? card;
  Klarna? klarna;
  Link? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (card != null) {
      map['card'] = card?.toJson();
    }
    if (klarna != null) {
      map['klarna'] = klarna?.toJson();
    }
    if (link != null) {
      map['link'] = link?.toJson();
    }
    return map;
  }

}

class Link {
  Link({
      this.persistentToken,});

  Link.fromJson(dynamic json) {
    persistentToken = json['persistent_token'];
  }
  dynamic persistentToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['persistent_token'] = persistentToken;
    return map;
  }

}

class Klarna {
  Klarna({
      this.preferredLocale,});

  Klarna.fromJson(dynamic json) {
    preferredLocale = json['preferred_locale'];
  }
  dynamic preferredLocale;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['preferred_locale'] = preferredLocale;
    return map;
  }

}

class Card {
  Card({
      this.installments, 
      this.mandateOptions, 
      this.network, 
      this.requestThreeDSecure,});

  Card.fromJson(dynamic json) {
    installments = json['installments'];
    mandateOptions = json['mandate_options'];
    network = json['network'];
    requestThreeDSecure = json['request_three_d_secure'];
  }
  dynamic installments;
  dynamic mandateOptions;
  dynamic network;
  String? requestThreeDSecure;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['installments'] = installments;
    map['mandate_options'] = mandateOptions;
    map['network'] = network;
    map['request_three_d_secure'] = requestThreeDSecure;
    return map;
  }

}

class PaymentMethodConfigurationDetails {
  PaymentMethodConfigurationDetails({
      this.id, 
      this.parent,});

  PaymentMethodConfigurationDetails.fromJson(dynamic json) {
    id = json['id'];
    parent = json['parent'];
  }
  String? id;
  dynamic parent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['parent'] = parent;
    return map;
  }

}

class AutomaticPaymentMethods {
  AutomaticPaymentMethods({
      this.allowRedirects, 
      this.enabled,});

  AutomaticPaymentMethods.fromJson(dynamic json) {
    allowRedirects = json['allow_redirects'];
    enabled = json['enabled'];
  }
  String? allowRedirects;
  bool? enabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['allow_redirects'] = allowRedirects;
    map['enabled'] = enabled;
    return map;
  }

}

class AmountDetails {
  AmountDetails({
      this.tip,});

  AmountDetails.fromJson(dynamic json) {
    tip = json['tip'];
  }
  dynamic tip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tip'] = tip;
    return map;
  }

}