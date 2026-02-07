import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/locale_repository.dart';
import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocaleRepository localeRepository;

  LocaleBloc({required this.localeRepository})
      : super(const LocaleState(locale: Locale('en'))) {
    on<LoadLocaleEvent>(_onLoadLocale);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadLocale(
    LoadLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final savedLocale = await localeRepository.getSavedLocale();
    if (savedLocale != null) {
      emit(state.copyWith(locale: savedLocale));
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    await localeRepository.saveLocale(event.locale);
    emit(state.copyWith(locale: event.locale));
  }
}
