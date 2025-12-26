import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    if (_instance == null) {
      _instance = Dio(
        BaseOptions(
          baseUrl: 'https://pokeapi.co/api/v2',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      _setupInterceptors(_instance!);
    }

    return _instance!;
  }

  static Future<void> _setupInterceptors(Dio dio) async {
    // 1. Logging interceptor (debug only)
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // 2. Cache interceptor
    final cacheDir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(cacheDir.path);

    dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: cacheStore,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(days: 7),
          priority: CachePriority.high,
          hitCacheOnErrorExcept: [401, 403, 404],
        ),
      ),
    );

    // 3. Retry interceptor
    dio.interceptors.add(RetryInterceptor(dio: dio));
  }

  static void resetInstance() {
    _instance?.close(force: true);
    _instance = null;
  }

  static void setInstance(Dio dio) {
    _instance = dio;
  }
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor({required this.dio});

  final Dio dio;
  static const int maxRetries = 3;
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 3),
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retry_count'] as int? ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      extra['retry_count'] = retryCount + 1;

      await Future.delayed(retryDelays[retryCount]);

      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue with error
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

