import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokedex/domain/entities/pokemon_detail.dart';
import 'package:pokedex/domain/repositories/pokemon_repository.dart';
import 'package:pokedex/presentation/bloc/pokemon_detail/pokemon_detail_cubit.dart';
import 'package:pokedex/presentation/bloc/pokemon_detail/pokemon_detail_state.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
  });

  group('PokemonDetailCubit', () {
    const mockPokemonDetail = PokemonDetail(
      id: 25,
      name: 'pikachu',
      imageUrl: 'https://example.com/25.png',
      types: ['electric'],
      height: 4,
      weight: 60,
      stats: {'hp': 35, 'attack': 55, 'defense': 40},
      abilities: ['static', 'lightning-rod'],
    );

    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'emits [loading, success] when loadPokemonDetail succeeds',
      build: () {
        when(() => mockRepository.getPokemonDetail(any()))
            .thenAnswer((_) async => mockPokemonDetail);
        return PokemonDetailCubit(pokemonRepository: mockRepository);
      },
      act: (cubit) => cubit.loadPokemonDetail(25),
      expect: () => [
        const PokemonDetailState(status: PokemonDetailStatus.loading),
        const PokemonDetailState(
          status: PokemonDetailStatus.success,
          pokemon: mockPokemonDetail,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.getPokemonDetail(25)).called(1);
      },
    );

    blocTest<PokemonDetailCubit, PokemonDetailState>(
      'emits [loading, failure] when loadPokemonDetail fails',
      build: () {
        when(() => mockRepository.getPokemonDetail(any()))
            .thenThrow(const NetworkException('Failed to load'));
        return PokemonDetailCubit(pokemonRepository: mockRepository);
      },
      act: (cubit) => cubit.loadPokemonDetail(25),
      expect: () => [
        const PokemonDetailState(status: PokemonDetailStatus.loading),
        const PokemonDetailState(
          status: PokemonDetailStatus.failure,
          errorMessage: 'Failed to load',
        ),
      ],
    );

    test('initial state is PokemonDetailStatus.initial', () {
      final cubit = PokemonDetailCubit(pokemonRepository: mockRepository);
      expect(cubit.state.status, PokemonDetailStatus.initial);
      expect(cubit.state.pokemon, isNull);
      expect(cubit.state.errorMessage, isNull);
    });
  });
}

