import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../domain/repositories/pokemon_repository.dart';
import 'pokemon_list_event.dart';
import 'pokemon_list_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  PokemonListBloc({required this.pokemonRepository})
      : super(const PokemonListState()) {
    on<PokemonFetched>(
      _onPokemonFetched,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
  }

  final PokemonRepository pokemonRepository;
  static const _pokemonLimit = 20;

  Future<void> _onPokemonFetched(
    PokemonFetched event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PokemonListStatus.initial) {
        final pokemons = await pokemonRepository.getPokemons(
          limit: _pokemonLimit,
          offset: 0,
        );

        return emit(
          state.copyWith(
            status: PokemonListStatus.success,
            pokemons: pokemons,
            hasReachedMax: pokemons.length < _pokemonLimit,
          ),
        );
      }

      final pokemons = await pokemonRepository.getPokemons(
        limit: _pokemonLimit,
        offset: state.pokemons.length,
      );

      emit(
        pokemons.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: PokemonListStatus.success,
                pokemons: List.of(state.pokemons)..addAll(pokemons),
                hasReachedMax: pokemons.length < _pokemonLimit,
              ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PokemonListStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

