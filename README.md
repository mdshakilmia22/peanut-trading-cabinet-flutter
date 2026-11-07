# Client Cabinet & Trading Signals Application

A production-grade mobile application built using **Flutter** and **Clean Architecture** with **BLoC/Cubit** state management. The app integrates two backend authorization services (Peanut & Partner), retrieves user profile statistics, displays interactive trading signals with pair and date range filters, and parses SOAP promo materials with automated domain replacement.

---

## 🚀 Key Features

1. **Dual Service Authorization (Peanut & Partner)**
   - Concurrent token acquisition from Peanut POST `IsAccountCredentialsCorrect` and Partner POST `RequestMoblieCabinetApiToken`.
   - Local token persistence via `SharedPreferences`.
   - Re-authorization support, session expiration handling, and clean logout flow.
   - User-friendly floating error feedback.

2. **User Profile & Security**
   - Retrieves account metrics from Peanut service (`GetAccountInformation` & `GetLastFourNumbersPhone`).
   - Displays user balance, equity, free margin, leverage, location, and masked phone (`********0000`).
   - Resilient fallback handling if server endpoints return temporary 500 errors.

3. **Trading Signals Archive**
   - Interactive GET request to Partner service `GetAnalyticSignals/{login}` using `passkey` header authorization.
   - Filterable currency pair chips (`EURUSD`, `GBPUSD`, `USDJPY`, `USDCHF`, `USDCAD`, `AUDUSD`, `NZDUSD`).
   - Custom date range selector (`showDateRangePicker`).
   - Card list displaying signal action (BUY/SELL badges), entry price, Take Profit, Stop Loss, timestamp, and analyst notes.

4. **SOAP Promo Materials**
   - Executes SOAP WSDL request `GetCCPromo` (`lang=en`) to `CabinetMicroService.svc`.
   - Parses XML response to extract embedded JSON result string.
   - Automatic image domain replacement: `forex-images.instaforex.com` → `forex-images.ifxdb.com`.
   - External browser link launching using `url_launcher`.
   - Custom SSL certificate exception handling for expired backend certificate host.

---

## 🏗 Architecture & Technical Decisions

The application follows **Clean Architecture** structured by feature modules:

```
lib/
├── core/
│   ├── constants/       # API endpoints, colors, and test account credentials
│   ├── errors/          # Exception and Failure hierarchy
│   ├── network/         # ApiClient (HTTP/SOAP client with bad certificate handling)
│   ├── storage/         # TokenStorage (local persistence)
│   ├── theme/           # Material 3 Light/Dark adaptive themes
│   └── utils/           # SoapParser (XML parsing & domain replacement)
├── features/
│   ├── auth/            # Data, Domain, and Presentation (BLoC + UI) for Authentication
│   ├── profile/         # Data, Domain, and Presentation for User Profile
│   ├── signals/         # Data, Domain, and Presentation for Trading Signals Archive
│   └── promo/           # Data, Domain, and Presentation for Promo Materials
├── main_screen.dart     # Responsive Shell (BottomNavigationBar / NavigationRail)
└── main.dart            # Dependency injection & application entry point
```

### Architectural Highlights
- **Separation of Concerns**: Presentation (UI Widgets & BLoC), Domain (Pure Dart Entities & Repository Interfaces), Data (Models, Data Sources, & Repository Implementations).
- **State Management**: `flutter_bloc` with `Equatable` for immutable, predictable state transitions.
- **Responsive Layout**: Supports phones and tablets with adaptive `NavigationRail` / `BottomNavigationBar` transitions.

---

## 📋 Technical Test Answers & Candidate Information

### Prompt Survey Answers
- **1.** 1(b) - I adjusted my approach after analyzing alternatives.
- **2.** 2(b) - I’d listen and find a compromise.
- **3.** 3(b) - I’d assess feasibility and adjust if possible.
- **4.** 4(c) - I’d merge the best parts of both ideas in real-time and propose a hybrid solution.

---

### Additional Questions Answers

#### 1. Top 1 to 3 areas of expertise
1. Flutter App Architecture & BLoC State Management
2. REST & SOAP Network Integration with Offline Resilience
3. Cross-Platform Mobile UI/UX & Responsive Layouts

#### 2. Main areas worked in over past 5 years
1. Production Flutter Application Development (FinTech & E-commerce platforms)
2. Reactive Programming & Clean Architecture Implementation
3. CI/CD Pipeline Configuration & Automated Mobile Testing

#### 3. Reason for differences (if any)
My top areas of expertise align directly with my main work focus over the past 5 years, maintaining a strong commitment to high-performance Flutter engineering standards.

#### 4. Top 1 to 3 areas to develop over next 10 years
1. On-Device Machine Learning Integration (LiteRT & ML Kit)
2. Native Mobile Performance Profiling & Native C++/Rust Interoperability
3. High-Scale Mobile Ecosystem Architecture

#### 5. Driving force for future goals
The increasing demand for private on-device intelligence, ultra-low latency mobile experiences, and complex multi-platform systems.

#### 6. Strongest personal qualities
1. Analytical problem solving and architectural discipline
2. Adaptability under shifting project requirements
3. Clear technical communication and team collaboration

#### 7. Personal weaknesses
1. Tendency to over-engineer early prototypes before validation
2. High self-expectation when balancing delivery speed vs perfection

#### 8. Steps taken to address weaknesses
Applying strict time-boxing, delivering functional MVPs first, and utilizing structured design reviews before refactoring.

---

### 💼 Job Placement Details

#### 1. Flutter Developer
- **Company Name**: WebSolutionUs
- **Duration**: 1 Jul 2026 - Continuing
- **Nature of Business**: Software Solutions & Mobile Product Studio
- **Duties**: Architecting cross-platform Flutter applications, implementing BLoC state management, API integration, code review, and performance optimization.
- **Reason looking for new opportunities**: Seeking senior roles in high-growth, product-centric engineering environments.

#### 2. Flutter Developer
- **Company Name**: Acnoo
- **Duration**: 1 Jan 2023 - 1 Jul 2026
- **Nature of Business**: Mobile App Development Studio
- **Duties**: Developed feature modules, customized Material design UI components, integrated payment gateways, and wrote unit/widget test suites.
- **Leaving reason**: Transitioned to broaden technical scope and engineering impact.

- **Career Gap**: None.
- **Reference**: Available upon request.
- **Portfolio Link**: Available upon request.

---

## 🛠 Additional Architectural Question (README Requirement)

### Reusable Verification Module Flow Across Multiple Mobile Applications

When building a verification module shared across multiple applications:

1. **Module Package Isolation**: Extract the verification module into an independent Flutter package (`packages/core_verification`) containing its own data, domain, and presentation layers.
2. **Dependency Isolation**: Use abstract interfaces for external contracts (e.g., `AuthenticationProvider`, `TokenStorageProvider`, `NavigationDelegate`). The parent host application injects concrete implementations via DI (GetIt or Provider) without the package depending on host application classes.
3. **Navigation & Flow Management**:
   - Expose a clean navigator entry point (e.g., `VerificationFlow.launch(BuildContext context, {required VerificationConfig config})`).
   - Use internal nested navigation or explicit callback delegates (`onVerificationSuccess(VerificationToken token)`, `onVerificationCancelled()`) to pass flow control back to the host app cleanly.
4. **Configuration & Customization**: Pass a `VerificationThemeConfig` object to adapt branding (colors, logos, strings) per app while maintaining 100% core logic reuse across the mobile ecosystem.

---

## ⏱ Time Estimation

- **Estimated implementation time**: 6.0 hours
- **Actual time spent**: 5.5 hours

---

## ⚙️ How to Run the Project

1. Ensure Flutter SDK (3.12+) is installed.
2. Run dependency resolution:
   ```bash
   flutter pub get
   ```
3. Run unit tests:
   ```bash
   flutter test
   ```
4. Run the application:
   ```bash
   flutter run
   ```
5. Build production APK:
   ```bash
   flutter build apk --release
   ```
