# Base Flutter Project

## Overview
This is a base Flutter project utilizing the GetX package, featuring several pre-configured setups:

- **Architecture**: Widget - Controller - Service
```
base_flutter_getx/
│
├── lib/                    
│   ├── app.dart            # App
│   ├── global.dart         # Holding global data used in app
│   ├── main_dev.dart       # Main dev
│   ├── main_production.dart# Main prod
│   ├── config/             # Configuration files
│   │   ├── app_config.dart # App configuration
│   │   ├── routes.dart     # Route configuration
│   │   ├── ...
│   ├── core/               # Core utilities and constants
│   │   ├── base/           # Base widgets and controllers
│   │   ├── constants/      # Constants
│   │   ├── error_handler/  # Error handler
│   │   ├── ...
│   ├── features/           # Application features
│   │   ├── login/          # Login feature
│   │   │   ├── controllers # Controllers
│   │   │   ├── models      # Models
│   │   │   ├── screens     # Screens
│   │   │   ├── services    # Services
│   │   │   ├── ...
│   │   ├── ...
│   ├── shared/             # Shared widgets and services
│   │   ├── widgets/        # Common widgets
│   │   ├── services/       # Common services
```

- **Translation**: Built-in support for multiple languages  (check out SettingController)
- **Error Handling**: Common error handling setup
- **Features**: Includes a sample login feature


## How to use this base project
### Clone this repo
   ```sh
   git clone https://github.com/dttrung-99931/base_flutter_getx_project.git
   ```

### Rename project folder 
The default project folder is base_flutter_getx. You can rename this folder to new name you want
### Update Bundle ID
To change the bundle ID
1. Activate the package if not already:
   ```sh
   flutter pub global activate rename
   ```

2. Change the bundle ID:
   ```sh
   rename setBundleId --value your_bundle_id
   ```
