# Client Cabinet & Trading Signals

A mobile application built with Flutter using Clean Architecture and BLoC for state management. The app integrates with two backend services (Peanut & Partner), displays user profile details, provides interactive trading signals with currency and date filtering, and parses promo materials from a SOAP service.

---

## Features

1. **Dual Service Authentication (Peanut & Partner)**
   - Concurrent authentication against Peanut (`IsAccountCredentialsCorrect`) and Partner (`RequestMoblieCabinetApiToken`) endpoints using `Future.wait()`.
   - Local token persistence via `SharedPreferences`.
   - Handles session expiration, re-authentication, and clean logout.
   - User feedback via snackbars for network and auth errors.

2. **User Profile**
   - Fetches account data from Peanut (`GetAccountInformation` and `GetLastFourNumbersPhone`).
   - Displays balance, equity, free margin, leverage, account type, and masked phone number (`********0000`).
   - Fallback data handling in case the test server encounters errors.

3. **Trading Signals**
   - Fetches signal history from Partner service (`GetAnalyticSignals/{login}`) with `passkey` header.
   - Filter chips for currency pairs (`EURUSD`, `GBPUSD`, `USDJPY`, `USDCHF`, `USDCAD`, `AUDUSD`, `NZDUSD`).
   - Date range picker to filter signals by time range.
   - Displays signal action (BUY / SELL), entry price, Take Profit, Stop Loss, timestamp, and analyst commentary.

4. **Promo Materials**
   - Calls SOAP WSDL service `GetCCPromo` with `lang=en`.
   - Extracts embedded JSON data from XML response, handling unescaped entities and non-standard boolean literals.
   - Replaces `forex-images.instaforex.com` with `forex-images.ifxdb.com`.
   - External link navigation using `url_launcher`.

---

## Technical Notes & Implementation Details

- **Dio & Retrofit Networking**: Client-server communication is handled with `Dio` and type-safe `Retrofit` services (`PeanutApiService`, `PartnerApiService`, `SoapApiService`) in the DataSource layer.
- **DTOs vs. Entities Separation**: Strict separation between Data Transfer Objects (DTOs with JSON serialization in `data/models/`) and pure domain Entities (`domain/entities/`). Repositories map DTOs to Entities via `toEntity()`.
- **Inter-Module Communication via UseCases**: Features communicate with each other through Domain UseCases (e.g. `GetProfileUseCase` and `GetSignalsUseCase` interact with `AuthRepository` to obtain session tokens) rather than coupling BLoCs or leaking state across presentation boundaries.
- **Local BLoC Scoping (No MultiBlocProvider)**: Avoids global `MultiBlocProvider` anti-pattern. Global auth status is managed with a single root `BlocProvider<AuthBloc>`, while `ProfileBloc`, `SignalsBloc`, and `PromoBloc` are scoped locally to their respective feature views.
- **Expired SSL Certificates on Test Endpoints**: The test servers (`contentdatapro.com` and `ifxdb.com`) have expired SSL certificates. To prevent `HandshakeException`, a custom `badCertificateCallback` is configured on the `IOHttpClientAdapter` in `dio_client.dart` for these hosts.
- **Parsing SOAP XML with Embedded JSON**: The `GetCCPromo` SOAP endpoint returns XML containing a JSON string inside `<GetCCPromoResult>`. The text contains HTML entities (`&lt;`, `&gt;`, `&quot;`) and Python boolean literals (`: True`, `: False`). `SoapParser` unescapes these entities and normalizes booleans before decoding with `jsonDecode()`.
- **Promo Image Domain Replacement**: As specified in the requirements, URLs pointing to `forex-images.instaforex.com` are dynamically mapped to `forex-images.ifxdb.com`.
- **Dependency Injection**: Registered with `GetIt` in `core/di/injection_container.dart` for clean decoupling and testability.

---

## Architecture

The project follows Clean Architecture principles structured by feature:

```
lib/
├── core/
│   ├── constants/       # API endpoints, colors
│   ├── di/              # GetIt dependency injection setup
│   ├── errors/          # Exceptions and Failures
│   ├── network/         # Dio client, Retrofit services, SOAP client
│   ├── storage/         # TokenStorage (SharedPreferences wrapper)
│   ├── theme/           # Light and dark Material 3 themes
│   └── utils/           # SoapParser
├── features/
│   ├── auth/            # Data (DTOs/DataSource/Repo), Domain (Entities/Repo/UseCases), Presentation (BLoC/UI)
│   ├── profile/         # Data, Domain, and Presentation for Profile
│   ├── signals/         # Data, Domain, and Presentation for Signals
│   └── promo/           # Data, Domain, and Presentation for Promo
├── main_screen.dart     # Responsive root navigation
└── main.dart            # App entry point
```

- **Data Layer**: Retrofit/Dio API data sources, DTOs (`*Dto`), and repository implementations.
- **Domain Layer**: Pure Dart entities, abstract repository contracts, and UseCases coordinating business logic and inter-module communication.
- **Presentation Layer**: Scoped BLoCs and UI widgets.

---

## Candidate Questionnaire

### Multiple Choice Questions
- **1.** 1(b) - I adjusted my approach after analyzing alternatives.
- **2.** 2(b) - I’d listen and find a compromise.
- **3.** 3(b) - I’d assess feasibility and adjust if possible.
- **4.** 4(c) - I’d merge the best parts of both ideas in real-time and propose a hybrid solution.

---

### Additional Questions

#### 1. Top 1 to 3 areas of expertise
1. Flutter App Architecture & BLoC State Management
2. REST & SOAP Network Integration with Offline Handling
3. Cross-Platform Responsive UI Development

#### 2. Main areas worked in over past 5 years
1. Production Flutter Application Development (FinTech & E-commerce)
2. State Management & Clean Architecture Implementation
3. CI/CD Pipeline Setup & Automated Testing

#### 3. Reason for differences (if any)
None. My core expertise directly aligns with my primary focus over the past 5 years.

#### 4. Top 1 to 3 areas to develop over next 10 years
1. On-Device Machine Learning (LiteRT & ML Kit)
2. Native Mobile Performance Profiling & C++/Rust interop
3. Large-Scale Mobile System Architecture

#### 5. Driving force for future goals
Interest in on-device AI integration and deeper low-level performance optimization to build faster, smarter mobile applications.

#### 6. Strongest personal qualities
1. Strong focus on clean, maintainable architecture
2. Adaptability when project requirements change
3. Clear communication and collaborative teamwork

#### 7. Personal weaknesses
1. Tendency to spend too much time perfecting early architecture before validating
2. Can be hesitant to leave code un-refactored when moving fast

#### 8. Steps taken to address weaknesses
Setting strict time limits, delivering functional MVPs first to gather early feedback, and scheduling refactoring in subsequent iterations.

---

## Job Placement Details

### 1. Flutter Developer
- **Company Name**: WebSolutionUs
- **Duration**: 1 Jul 2026 - Continuing
- **Nature of Business**: Software Solutions & Mobile Product Studio
- **Duties**: Architecting cross-platform Flutter applications, implementing BLoC state management, API integration, code reviews, and performance tuning.
- **Reason looking for new opportunities**: Looking for senior roles in product-focused engineering teams.

### 2. Flutter Developer
- **Company Name**: Acnoo
- **Duration**: 1 Jan 2023 - 1 Jul 2026
- **Nature of Business**: Mobile App Development Studio
- **Duties**: Developed feature modules, customized Material design UI components, integrated payment gateways, and wrote unit/widget tests.
- **Leaving reason**: Looking to broaden technical scope and engineering impact.

- **Career Gap**: None.
- **Reference**: Available upon request.
- **Portfolio Link**: Available upon request.

---

## Reusable Verification Module Flow (Additional Question)

When designing a verification module to be shared across multiple mobile applications:

1. **Package Isolation**:
   - Extract the verification flow into an independent Flutter package (e.g. `packages/verification_module`).
   - The package defines its own data, domain, and presentation layers without importing host app code.

2. **Dependency Inversion & Contracts**:
   - Define abstract interfaces inside the module for external dependencies (e.g. `AuthTokenProvider`, `VerificationNetworkService`, `VerificationAnalytics`).
   - The host application implements these interfaces and injects them when initializing the module.

3. **Navigation & Flow Control**:
   - Provide a simple entry point:
     ```dart
     VerificationModule.start(
       context,
       config: VerificationConfig(theme: appTheme, mode: VerificationMode.kyc),
       onSuccess: (result) => handleSuccess(result),
       onCancel: () => handleCancel(),
     );
     ```
   - Keep internal navigation self-contained within the module (using a nested Navigator or modal flow), returning results through callbacks or a returned Future.

4. **Theming & Customization**:
   - Accept a configuration object (`VerificationThemeConfig`) to allow each host app to supply its own branding (colors, typography, logo, localized strings) while sharing 100% of the underlying business logic.

---

## Time Estimation

- **Estimated implementation time**: 6.0 hours
- **Actual time spent**: 5.5 hours

---

## How to Run the Project

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run tests:
   ```bash
   flutter test
   ```
3. Run the app:
   ```bash
   flutter run
   ```
4. Build release APK:
   ```bash
   flutter build apk --release
   ```
