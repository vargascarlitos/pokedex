import 'package:bloc/bloc.dart';
import '../../../domain/repositories/pokemon_repository.dart';
import 'pokemon_detail_state.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  PokemonDetailCubit({required this.pokemonRepository})
      : super(const PokemonDetailState());

  final PokemonRepository pokemonRepository;

  Future<void> loadPokemonDetail(int id) async {
    emit(state.copyWith(status: PokemonDetailStatus.loading));

    try {
      final detail = await pokemonRepository.getPokemonDetail(id);

      emit(
        state.copyWith(
          status: PokemonDetailStatus.success,
          pokemon: detail,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PokemonDetailStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

