# Pokédex App - Flutter Mobile + Web

Aplicación Pokédex con soporte mobile (iOS/Android) y web, funciona completamente offline.



https://github.com/user-attachments/assets/0fe5e8d4-cb72-47d0-b2d7-103069ab24e9



## Setup e Instalación

### Requisitos
- Flutter 3.35.3
- Dart 3.9.2

### Instalación
```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Ejecución

**Mobile:**
```bash
flutter run -d ios
flutter run -d android
```

**Web:**
```bash
flutter run -d chrome
# O con --web-browser-flag "--disable-web-security" si hay problemas de CORS en desarrollo
```

### Testing
```bash
# Unit y widget tests
flutter test

# Integration test (requiere emulador/device)
flutter test integration_test/navigation_flow_test.dart -d chrome
```

---

## Respuestas a Preguntas del Challenge

### 1. Arquitectura y escalabilidad

**Decisión:** Clean Architecture con 3 capas (Domain/Data/Presentation).

**Por qué:**
- El domain layer (entities + repository contracts) no depende de nada, permite cambiar implementaciones sin tocar lógica de negocio
- La capa de datos abstrae si viene de API o caché, el resto no lo sabe
- BLoC/Cubit en presentation hace que la UI solo "reaccione" a cambios de estado, no gestiona lógica

**Escalabilidad:**
- Para agregar búsqueda: nuevo método en repository, nuevo estado en BLoC, nueva UI
- Para cambiar de PokéAPI a otra fuente: solo cambia la capa data
- Para web vs mobile: mismo código base, solo cambian breakpoints responsive

### 2. Trade-offs por el timebox de 1 día

**Lo que prioricé:**
- Offline-first completo (funciona sin red)
- Arquitectura sólida aunque más archivos
- Testing de lo crítico (17 tests de repository, bloc y widgets)
- Responsive básico funcional

**Lo que dejé fuera o simplifiqué:**
- Búsqueda de Pokémon por nombre/número
- Filtros por tipo o generación
- Favoritos persistentes
- Más de 2 breakpoints responsive (solo mobile vs desktop)
- Testing exhaustivo (solo lo crítico testeado)
- GoRouter (usé MaterialPageRoute, para 2 pantallas es suficiente)

**Decisión clave:** Preferí tener offline-first funcionando bien que agregar features visuales. Es más difícil técnicamente y diferencia el proyecto.

### 3. Gestión de estado y side-effects

**Flujo:**
```
UI → dispatch event → BLoC/Cubit → llama repository → repository decide (caché vs API)
→ devuelve datos → BLoC emite nuevo estado → UI se reconstruye (BlocBuilder)
```

**Cómo evito acoplamiento:**
- UI solo conoce el BLoC/Cubit, no sabe que existe un repository
- BLoC solo conoce el contrato de repository (interface), no la implementación
- Repository implementación depende de datasources, pero BLoC no los conoce

**Por qué Bloc para lista y Cubit para detalle:**
- Lista necesita `throttleDroppable` transformer para evitar spam de eventos en scroll infinito
- Detalle es estado simple (load → success/error), Cubit es suficiente
- Ambos son bloc package, solo difieren en si usan eventos o métodos directos

### 4. Offline y caché

**Estrategia implementada:**

La capa repository implementa "offline-first":
1. Siempre intenta caché local primero (Hive)
2. Si hay datos, los retorna inmediatamente
3. Si hay conexión, actualiza caché en background (sin bloquear UI)
4. Si no hay caché y no hay red, lanza excepción

**Qué se guarda:**
- Lista de Pokémon (paginada)
- Detalles individuales de Pokémon vistos
- Imágenes (cached_network_image hace el trabajo)

**Caché en múltiples niveles:**
- HTTP cache (Dio interceptor) - 7 días para lista, 30 días para detalles
- Storage persistente (Hive) - mismo TTL
- Image cache (cached_network_image) - 30 días

**Invalidación:**
- Por ahora es time-based (TTL)
- Si escalara: agregaría versioning en models y migración de datos. Usaria https://pub.dev/packages/drift para eso.

**Conflictos caché vs remoto:**
- Priorizo caché para UX instantánea
- Update en background cuando hay conexión
- Si hay error en background, se ignora silenciosamente (caché sigue válido)

**Por qué Hive en lugar de SQLite:**
- Funciona nativamente en web (usa IndexedDB)
- Más rápido para reads

### 5. Flutter Web

**Decisiones tomadas:**

**Responsive:**
- LayoutBuilder calcula columnas según viewport: 2 (mobile), 3-4 (tablet), 4-6 (desktop)
- No usé MediaQuery.of(context).size directamente para evitar rebuilds innecesarios
- Grid adaptativo, mismo código funciona en todos los tamaños

**Performance web:**
- Imágenes optimizadas con `memCacheWidth/Height` (200x200) para reducir memoria
- Solo se renderizan items visibles (GridView.builder)
- Throttle en scroll evita requests excesivos

**Navegación:**
- MaterialPageRoute es suficiente para 2 pantallas
- Hero animation funciona en web (transición fluida)

**Limitaciones encontradas:**
- SQLite no funciona en web (solución: migré a Hive)
- CORS en desarrollo (solución: `--web-browser-flag "--disable-web-security"`, en producción PokéAPI lo soporta)
- IndexedDB tiene límite de storage (~50MB), suficiente para este caso

**Qué falta para producción web:**
- Service worker para PWA
- Splash screen custom
- SEO metadata (aunque SPA tiene limitaciones)

### 6. Calidad - 3 decisiones de código limpio

**1. StatelessWidget con const por defecto**

Todo widget que no necesita estado mutable es StatelessWidget con const constructor. Mejora performance porque Flutter puede reutilizar instancias.

Ejemplo: `lib/presentation/pages/pokemon_detail/pokemon_detail_view.dart` - todos los componentes privados (`_PokemonDetailAppBar`, `_LoadingContent`, etc) son StatelessWidget con const.

**2. BlocBuilder con buildWhen específico**

Evito rebuilds innecesarios con `buildWhen` que solo reconstruye cuando cambia lo relevante.

Ejemplo: `lib/presentation/pages/pokemon_list/pokemon_list_view.dart` línea 34 - el ScrollController solo se reconstruye si cambia el status o hasReachedMax, no en cada cambio del state.

**3. Repository pattern con dependency inversion**

El BLoC depende de la interfaz del repository (domain), no de la implementación concreta (data). Puedo mockear fácilmente en tests y cambiar implementación sin tocar presentation.

Ejemplo: `lib/presentation/bloc/pokemon_list/pokemon_list_bloc.dart` - recibe `PokemonRepository` (interface) en constructor, no sabe si los datos vienen de Hive o API.

### 7. Testing

**Qué testeé (17 tests):**

- Repository (6 tests): estrategia offline-first (caché hit, caché miss online, offline sin caché)
- PokemonListBloc (6 tests): paginación, throttle, hasReachedMax, success/failure
- PokemonDetailCubit (3 tests): estados loading/success/failure
- Widget PokemonCard (2 tests): render correcto, tiene elementos interactivos

**Por qué estos:**
- Repository es el corazón del offline-first, si falla ahí no hay app
- Bloc de lista tiene lógica compleja (throttle, paginación), fácil de romper
- Widget card es crítico, se usa N veces

**Qué NO testeé por tiempo:**
- Datasources (demasiado boilerplate, poco valor)
- Models (fromJson/toJson son mecánicos)
- Widgets complejos (lentos de testear)

**Si tuviera más tiempo (prioridad):**
1. Integration test del flujo completo (ya está creado pero no ejecutado a fondo)
2. Widget test de la lista completa con scroll
3. Tests de edge cases (sin conexión, API caída, caché corrupto)

**Herramientas:**
- mocktail (mejor que mockito según VGV)
- bloc_test (testing declarativo de estados)
- flutter_test e integration_test built-in

### 8. Git - Estructura de commits

**Convención:** Angular Conventional Commits

Formato: `<type>(<scope>): <subject>`

Ejemplos reales del repo:
```
feat(domain): añadir entidad PokemonDetail y extender contrato repository
feat(repository): implementar getPokemonDetail con estrategia offline-first
test(repository): agregar tests offline-first para PokemonRepository
```

**Por qué:**
- Mensajes descriptivos facilitan entender qué cambió sin ver código
- Scopes claros (domain/data/presentation) mapean a capas de arquitectura
- Commits atómicos (1 concepto por commit) facilitan revert si algo falla

### 9. Pendientes (top 5 priorizado)

**1. Búsqueda de Pokémon (alta prioridad)**
- Implementación: nuevo método `searchPokemons(String query)` en repository
- UI: SearchBar en AppBar con debounce

**2. Filtros por tipo (alta prioridad)**
- Implementación: endpoint `/type/{id}` de PokéAPI
- UI: Chips de tipos, al tap filtra lista

**3. Favoritos persistentes (media prioridad)**
- Implementación: nueva tabla en Hive con IDs favoritos
- UI: IconButton en card y detalle

**4. Dark mode (media prioridad)**
- Implementación: ThemeData.dark() pre-configurado, switch en settings
- Usar cubit global para toggle

**5. Tests exhaustivos (baja prioridad)**
- Agregar tests de datasources y models
- Widget tests de pantallas completas

---
