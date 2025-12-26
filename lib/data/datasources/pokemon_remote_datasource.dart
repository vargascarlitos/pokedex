import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';

class PokemonRemoteDataSource {
  PokemonRemoteDataSource(this._dio);

  final Dio _dio;
  final Map<String, Future<Response>> _ongoingRequests = {};

  Future<List<PokemonModel>> getPokemons({
    required int limit,
    required int offset,
  }) async {
    final cacheKey = 'pokemons_${limit}_$offset';

    if (_ongoingRequests.containsKey(cacheKey)) {
      final response = await _ongoingRequests[cacheKey]!;
      return _parseResponse(response);
    }

    final requestFuture = _dio.get(
      '/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    _ongoingRequests[cacheKey] = requestFuture;

    try {
      final response = await requestFuture;
      return _parseResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } finally {
      _ongoingRequests.remove(cacheKey);
    }
  }

  List<PokemonModel> _parseResponse(Response response) {
    final results = response.data['results'] as List<dynamic>;

    return results.map((item) {
      final url = item['url'] as String;
      final id = _extractIdFromUrl(url);

      return PokemonModel.fromJson(item as Map<String, dynamic>, id);
    }).toList();
  }

  int _extractIdFromUrl(String url) {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }

  NetworkException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          'Tiempo de espera agotado. Verifica tu conexión.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'Sin conexión a internet. Verifica tu red.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return const NetworkException('Recurso no encontrado');
        } else if (statusCode == 500) {
          return const NetworkException('Error en el servidor');
        }
        return NetworkException('Error HTTP $statusCode');

      case DioExceptionType.cancel:
        return const NetworkException('Petición cancelada');

      default:
        return NetworkException('Error inesperado: ${error.message}');
    }
  }
}

class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;

  @override
  String toString() => message;
}

