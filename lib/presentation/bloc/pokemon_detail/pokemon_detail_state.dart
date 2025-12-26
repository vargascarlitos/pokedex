import 'package:equatable/equatable.dart';
import '../../../domain/entities/pokemon_detail.dart';

enum PokemonDetailStatus { initial, loading, success, failure }

class PokemonDetailState extends Equatable {
  const PokemonDetailState({
    this.status = PokemonDetailStatus.initial,
    this.pokemon,
    this.errorMessage,
  });

  final PokemonDetailStatus status;
  final PokemonDetail? pokemon;
  final String? errorMessage;

  PokemonDetailState copyWith({
    PokemonDetailStatus? status,
    PokemonDetail? pokemon,
    String? errorMessage,
  }) {
    return PokemonDetailState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pokemon, errorMessage];
}

