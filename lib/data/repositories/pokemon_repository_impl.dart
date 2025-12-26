import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  const PokemonRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._connectivity,
  );

  final PokemonLocalDataSource _localDataSource;
  final PokemonRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;

  @override
  Future<List<Pokemon>> getPokemons({
    required int limit,
    required int offset,
  }) async {
    // Try cache first (offline-first strategy)
    final cached = await _localDataSource.getPokemons(
      limit: limit,
      offset: offset,
    );

    if (cached.isNotEmpty) {
      // Update cache in background if online
      if (await _hasConnection()) {
        _updateCacheInBackground(limit: limit, offset: offset);
      }
      return cached.map((m) => m.toEntity()).toList();
    }

    // No cache, try API if online
    if (await _hasConnection()) {
      final remote = await _remoteDataSource.getPokemons(
        limit: limit,
        offset: offset,
      );
      await _localDataSource.savePokemons(remote);
      return remote.map((m) => m.toEntity()).toList();
    }

    throw const NetworkException('Sin conexión y sin datos en caché');
  }

  Future<bool> _hasConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  Future<void> _updateCacheInBackground({
    required int limit,
    required int offset,
  }) async {
    try {
      final remote = await _remoteDataSource.getPokemons(
        limit: limit,
        offset: offset,
      );
      await _localDataSource.savePokemons(remote);
    } catch (e) {
      // Silent fail for background updates
    }
  }
}

