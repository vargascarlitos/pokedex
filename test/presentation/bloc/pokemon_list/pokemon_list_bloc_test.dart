import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokedex/domain/entities/pokemon.dart';
import 'package:pokedex/domain/repositories/pokemon_repository.dart';
import 'package:pokedex/presentation/bloc/pokemon_list/pokemon_list_bloc.dart';
import 'package:pokedex/presentation/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokedex/presentation/bloc/pokemon_list/pokemon_list_state.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
  });

  group('PokemonListBloc', () {
    final mockPokemons = List.generate(
      20,
      (i) => Pokemon(
        id: i + 1,
        name: 'pokemon$i',
        imageUrl: 'https://example.com/${i + 1}.png',
      ),
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'emits [success] when PokemonFetched is successful',
      build: () {
        when(() => mockRepository.getPokemons(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => mockPokemons);
        return PokemonListBloc(pokemonRepository: mockRepository);
      },
      act: (bloc) => bloc.add(PokemonFetched()),
      expect: () => [
        PokemonListState(
          status: PokemonListStatus.success,
          pokemons: mockPokemons,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.getPokemons(limit: 20, offset: 0))
            .called(1);
      },
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'emits [failure] when PokemonFetched fails',
      build: () {
        when(() => mockRepository.getPokemons(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenThrow(const NetworkException('Network error'));
        return PokemonListBloc(pokemonRepository: mockRepository);
      },
      act: (bloc) => bloc.add(PokemonFetched()),
      expect: () => [
        const PokemonListState(
          status: PokemonListStatus.failure,
          errorMessage: 'Network error',
        ),
      ],
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'appends pokemons when fetching next page',
      build: () {
        when(() => mockRepository.getPokemons(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => mockPokemons.sublist(0, 20));
        return PokemonListBloc(pokemonRepository: mockRepository);
      },
      seed: () => PokemonListState(
        status: PokemonListStatus.success,
        pokemons: mockPokemons.sublist(0, 20),
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(PokemonFetched()),
      expect: () => [
        PokemonListState(
          status: PokemonListStatus.success,
          pokemons: [
            ...mockPokemons.sublist(0, 20),
            ...mockPokemons.sublist(0, 20),
          ],
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'does not emit anything when hasReachedMax is true',
      build: () => PokemonListBloc(pokemonRepository: mockRepository),
      seed: () => PokemonListState(
        status: PokemonListStatus.success,
        pokemons: mockPokemons,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(PokemonFetched()),
      expect: () => [],
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'throttles rapid successive PokemonFetched events',
      build: () {
        when(() => mockRepository.getPokemons(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => mockPokemons);
        return PokemonListBloc(pokemonRepository: mockRepository);
      },
      act: (bloc) async {
        bloc.add(PokemonFetched());
        bloc.add(PokemonFetched());
        bloc.add(PokemonFetched());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      expect: () => [
        PokemonListState(
          status: PokemonListStatus.success,
          pokemons: mockPokemons,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.getPokemons(limit: 20, offset: 0))
            .called(1);
      },
    );

    blocTest<PokemonListBloc, PokemonListState>(
      'sets hasReachedMax to true when receiving less than 20 pokemons',
      build: () {
        when(() => mockRepository.getPokemons(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => mockPokemons.sublist(0, 10));
        return PokemonListBloc(pokemonRepository: mockRepository);
      },
      act: (bloc) => bloc.add(PokemonFetched()),
      expect: () => [
        PokemonListState(
          status: PokemonListStatus.success,
          pokemons: mockPokemons.sublist(0, 10),
          hasReachedMax: true,
        ),
      ],
    );
  });
}

