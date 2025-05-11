# Flutter Getx Base Project

## Overview
This is a base Flutter project utilizing the GetX package, featuring several pre-configured setups:

- **Architecture**: Widget - Controller - Service
```
lib/                    
├── config/             
│   ├── app_config.dart 
│   ├── routes.dart     
│   ├── ...
├── core/               
│   ├── base/           
│   ├── constants/      
│   ├── error_handler/  
│   ├── ...
├── features/           
│   ├── login/          
│   │   ├── controllers 
│   │   ├── models      
│   │   ├── screens     
│   │   ├── services    
│   │   ├── ...
│   ├── ...
├── shared/             
│   ├── widgets/        
│   ├── services/       
├── app.dart            
├── global.dart         
├── main_dev.dart       
├── main_production.dart
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
