import 'package:equatable/equatable.dart';
import '../../../domain/entities/pokemon.dart';

enum PokemonListStatus { initial, loading, success, failure }

class PokemonListState extends Equatable {
  const PokemonListState({
    this.status = PokemonListStatus.initial,
    this.pokemons = const [],
    this.hasReachedMax = false,
    this.errorMessage,
  });

  final PokemonListStatus status;
  final List<Pokemon> pokemons;
  final bool hasReachedMax;
  final String? errorMessage;

  PokemonListState copyWith({
    PokemonListStatus? status,
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return PokemonListState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pokemons, hasReachedMax, errorMessage];
}

