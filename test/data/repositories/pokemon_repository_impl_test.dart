import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/data/datasources/pokemon_local_datasource.dart';
import 'package:pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_detail_model.dart';
import 'package:pokedex/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex/domain/entities/pokemon.dart';
import 'package:pokedex/domain/entities/pokemon_detail.dart';

class MockPokemonLocalDataSource extends Mock
    implements PokemonLocalDataSource {}

class MockPokemonRemoteDataSource extends Mock
    implements PokemonRemoteDataSource {}

class MockConnectivity extends Mock implements Connectivity {}

class FakePokemonModel extends Fake implements PokemonModel {}

class FakePokemonDetailModel extends Fake implements PokemonDetailModel {}

void main() {
  late PokemonRepositoryImpl repository;
  late MockPokemonLocalDataSource mockLocalDataSource;
  late MockPokemonRemoteDataSource mockRemoteDataSource;
  late MockConnectivity mockConnectivity;

  setUpAll(() {
    registerFallbackValue(FakePokemonModel());
    registerFallbackValue(FakePokemonDetailModel());
    registerFallbackValue(<PokemonModel>[]);
  });

  setUp(() {
    mockLocalDataSource = MockPokemonLocalDataSource();
    mockRemoteDataSource = MockPokemonRemoteDataSource();
    mockConnectivity = MockConnectivity();

    repository = PokemonRepositoryImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
      mockConnectivity,
    );
  });

  group('getPokemons', () {
    final tPokemonModel = PokemonModel(
      id: 1,
      name: 'bulbasaur',
      imageUrl: 'https://example.com/1.png',
      cachedAt: DateTime.now(),
    );

    test('returns cached pokemons when cache is available', () async {
      // Arrange
      when(() => mockLocalDataSource.getPokemons(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => [tPokemonModel]);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockRemoteDataSource.getPokemons(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => [tPokemonModel]);
      when(() => mockLocalDataSource.savePokemons(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getPokemons(limit: 20, offset: 0);

      // Assert
      expect(result, isA<List<Pokemon>>());
      expect(result, isNotEmpty);
      expect(result.first.name, 'bulbasaur');
      verify(() => mockLocalDataSource.getPokemons(
            limit: 20,
            offset: 0,
          )).called(1);
    });

    test('fetches from API when cache is empty and online', () async {
      // Arrange
      when(() => mockLocalDataSource.getPokemons(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => []);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockRemoteDataSource.getPokemons(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => [tPokemonModel]);
      when(() => mockLocalDataSource.savePokemons(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getPokemons(limit: 20, offset: 0);

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.name, 'bulbasaur');
      verify(() => mockRemoteDataSource.getPokemons(
            limit: 20,
            offset: 0,
          )).called(1);
      verify(() => mockLocalDataSource.savePokemons([tPokemonModel])).called(1);
    });

    test('throws NetworkException when offline and no cache', () async {
      // Arrange
      when(() => mockLocalDataSource.getPokemons(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => []);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act & Assert
      expect(
        () => repository.getPokemons(limit: 20, offset: 0),
        throwsA(isA<NetworkException>()),
      );
      verifyNever(() => mockRemoteDataSource.getPokemons(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ));
    });
  });

  group('getPokemonDetail', () {
    final tPokemonDetailModel = PokemonDetailModel(
      id: 25,
      name: 'pikachu',
      imageUrl: 'https://example.com/25.png',
      types: const ['electric'],
      height: 4,
      weight: 60,
      stats: const {'hp': 35, 'attack': 55},
      abilities: const ['static', 'lightning-rod'],
      cachedAt: DateTime.now(),
    );

    test('returns cached detail when cache is available', () async {
      // Arrange
      when(() => mockLocalDataSource.getPokemonDetail(any()))
          .thenAnswer((_) async => tPokemonDetailModel);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockRemoteDataSource.getPokemonDetail(any()))
          .thenAnswer((_) async => tPokemonDetailModel);
      when(() => mockLocalDataSource.savePokemonDetail(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getPokemonDetail(25);

      // Assert
      expect(result, isA<PokemonDetail>());
      expect(result.name, 'pikachu');
      expect(result.types, ['electric']);
      verify(() => mockLocalDataSource.getPokemonDetail(25)).called(1);
    });

    test('fetches from API when cache is empty and online', () async {
      // Arrange
      when(() => mockLocalDataSource.getPokemonDetail(any()))
          .thenAnswer((_) async => null);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockRemoteDataSource.getPokemonDetail(any()))
          .thenAnswer((_) async => tPokemonDetailModel);
      when(() => mockLocalDataSource.savePokemonDetail(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getPokemonDetail(25);

      // Assert
      expect(result, isA<PokemonDetail>());
      expect(result.name, 'pikachu');
      verify(() => mockRemoteDataSource.getPokemonDetail(25)).called(1);
      verify(() => mockLocalDataSource.savePokemonDetail(any())).called(1);
    });

    test('throws NetworkException when offline and no cache', () async {
      // Arrange
      when(() => mockLocalDataSource.getPokemonDetail(any()))
          .thenAnswer((_) async => null);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act & Assert
      expect(
        () => repository.getPokemonDetail(25),
        throwsA(isA<NetworkException>()),
      );
      verifyNever(() => mockRemoteDataSource.getPokemonDetail(any()));
    });
  });
}

