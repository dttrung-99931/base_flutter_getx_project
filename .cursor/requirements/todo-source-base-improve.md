```
lib/
├── main.dart
├── app/
│   ├── app.dart                    # GetMaterialApp setup
│   ├── routes/
│   │   ├── app_pages.dart          # GetPage list
│   │   └── app_routes.dart         # route name constants
│   ├── bindings/
│   │   └── initial_binding.dart    # app-wide DI (rarely used, prefer per-feature)
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
│
├── core/                           # shared, feature-agnostic
│   ├── constants/
│   ├── errors/
│   ├── network/
│   │   ├── api_client.dart
│   │   └── interceptors/
│   ├── utils/
│   │   ├── validators.dart
│   │   └── extensions.dart
│   └── widgets/                    # shared reusable widgets/components
│       ├── app_button.dart
│       └── app_loading.dart
│
├── data/                           # cross-feature data layer (if not per-feature)
│   ├── models/
│   ├── repositories/
│   └── providers/                  # API/local data sources
│
└── features/                       # <-- the main GetX pattern lives here
    ├── auth/
    │   ├── bindings/
    │   │   └── auth_binding.dart
    │   ├── controllers/
    │   │   └── auth_controller.dart
    │   ├── models/
    │   │   └── user_model.dart
    │   ├── repositories/
    │   │   └── auth_repository.dart
    │   ├── views/
    │   │   ├── login_view.dart
    │   │   └── register_view.dart
    │   └── widgets/                # widgets local to this feature only
    │       └── auth_text_field.dart
    │
    ├── home/
    │   ├── bindings/
    │   ├── controllers/
    │   ├── views/
    │   └── widgets/
    │
    └── profile/
        ├── bindings/
        ├── controllers/
        ├── views/
        └── widgets/
```
