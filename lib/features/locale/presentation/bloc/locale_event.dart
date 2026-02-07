import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocaleEvent extends LocaleEvent {}

class ChangeLocaleEvent extends LocaleEvent {
  final Locale locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}
