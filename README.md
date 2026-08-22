# Flutter Getx Base Project

## Overview

This is a base Flutter project utilizing the GetX package, featuring several pre-configured setups:

- **Architecture**: Widget - Controller - Service

```
lib/
├── config/
│   ├── assets/         # Assets class
│   ├── app_config.dart
│   ├── routes.dart
├── core/
│   ├── base/
│   ├── constants/
│   ├── translation/
│   ├── utils/
├── features/
│   ├── login/
│   │   ├── dtos/
│   │   │   ├── login_dto.dart   # Dto data class
│   │   │   ├── login_response_dto.dart  # Dto data class
│   │   ├── services/
│   │   │   ├── login_service.dart       # Absctract service
│   │   │   ├── login_service_impl.dart  # Implementation
│   │   ├── models/
│   │   │   ├── login_response_model.dart      # Business data class
│   │   ├── controllers/
│   │   │   ├── login_controller.dart    # Getx controller, hanlde feature logic: service - controller - ui
│   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   ├── login_screen.dart
│   │   ├── login_route.dart             # Declare route, dependencies using GetPage
├── shared/
│   ├── widgets/
│   ├── services/
├── app.dart                             # Hold app data for accessing globally
├── global.dart
├── main_dev.dart
├── main_production.dart
```

- **Translation**: Built-in support for multiple languages (check out SettingController)
- **Error Handling**: Common error handling setup
- **Features**: Includes a sample login feature

## Source Base Guide & Conventions

### Add a new feature

New feature should be placed in lib/features/${feature_name}
Ex: adding settings feature
=> lib/features/settings which includes

- services/setting_service.dart // api call
- dtos/settings_dto.dart // represent setting response structure from api
- services/setting_controller.dart // is GetxController, control setting state: Rx<SettingModel>, ...
- models/settings_model.dart // business app model that mapped from dto
- screens/settings_screen.dart // ui screen
- widgets/setting_item.dart, ... // widgets that are used by the screens

### Roles of components: screen, model, controller, dto, service, route in a feature

- Screen: flutter widget ui of the feature
- Controller:
  - Hold & manage feature states via observable fields like RxString, RxInt, Rx<SettingModel>
- Model:
  - Is business data class that will be used in controller, screen
  - Controller will provide these data model to screen via obversable fields (Rx<SettingModel>, RxString, ...)
  - Model is mapped from dto in controller
- Dto:
  - Is api data class / 3rd lib that is created from model data class  
    that help app business is not dependant on api / 3rd libs
  - A dto class have method like toJson, fromJson, toMap, fromMap (LoginResponseDto)
  - There are 3 types of dto:
    - Request dto: LoginDto that represents data sent to api (body or query), or local database, 3rd lib. // LoginDto instead of LoginRequestDto for short name
    - Response dto: LoginResponseDto that represents data received from api, 3rd libs
      - LoginResponseDto usually has .toModel() that convert to model.
        LoginResponseDto.toModel() return LoginModel {}

- Service:
  - Handle api calls, local database storage, ...
  - Return dtos to controllers via Either<AppError, TModel>
  - Need have abstraction: SettingService, SettingServiceImpl
  - If SettingService is api service => SettingService extends ApiService that help SettingServiceImpl access to post, get, delete api methods
- Route: like features/login/login_route.dart
  - login_route declare login route & login dependencies
  ```dart
  final loginRoute = GetPage(
    name: Routes.login,
    page: () => LoginScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<LoginService>(() => LoginServiceImpl());
      Get.lazyPut(
        () => LoginController(
          loginService: Get.find<LoginService>(),
          storage: Get.find<Storage>(),
        ),
      );
    }),
  );
  ```

### Naming convention

- Model & dto name examples
  - LoginModel => LoginDto
  - LoginResponseModel => LoginResponseDto
  - CreateUserModel => CreateUserDto
  - CreateUserResponseModel => CreateUserResponseDto
  - GetUsersModel => GetUsersDto
    => For feature x, if the feature has only one action like login.
    We just use XModel/XDto for dto, model name. For features that has many action like CRUD, we need to add action as prefix: like CreateUserModel
- Controller fields naming:
  - for rx variable, need suffix 'Rx' in name:
    Ex: RxBool isLoginSuccessRx, get bool isLoginSuccess => isLoginSuccessRx.value
- Widget naming:
  - List widget & list item widget:
    Ex: UserList [ UserItem ]
  - Popular widget types => Used the popular suffix
    Ex: LoginScreen, LoginField,
    LoginForm, LoginButton, UserAvatar, PostTabs
  - A widget that is not in 2 types above => use 'Widget' suffix in name
    Ex: ForwardScrollToParentWidget(parentScrollController), ...

### Service

- Return Either<AppError, TModel> to controllers

  ```dart
    abstract class LoginService extends ApiService {
      Future<Either<AppError, LoginResponse>> login(LoginDto request);
    }
  ```

- Api response structure is in ResponseWrapper, so a service impl need to unwrap the wrapper this by using BaseService.handleResponse
  ```dart
    Future<Either<AppError, T>> handleResponse<T>({
      required Future<Response<ResponseWrapper<T>>> responseFuture,
      bool requireNetwrok = true,
    }) async {
      // unwrap & handle common api error
    }
  ```

### Controller

- A controller must extends BaseController to reuse common method like handleServiceResult
- handleServiceResult handle common error like 404, 403 error,

```dart
class LoginController extends BaseController {
  LoginController({required LoginService loginService, required Storage storage}) : _service = loginService, _storage = storage;

  final isLoginSucces = RxBool(false);
  final LoginService _service;
  final Storage _storage;

  Future<void> login(String phone, String password) async {
    await handleServiceResult<LoginResponseModel>(
      serviceResult: _service.login(
        LoginModel(phone: phone, password: password),
      ),
      onSuccess: (LoginResponseModel result) {
        _storage.token = result.token;
        Get.offNamed(Routes.home);
      },
      <!-- onError: by default service showing error message, we can provide onError to handle special errors of the feature  -->
    );
  }
}
```

### shared/widgets vs features/login/widgets (or feature/xxx/widgets)

- shared/widgets contains global widgets that can be used in every features/xxx
- features/xxx/widgets are local widgets that only can be used within the xxx feature
- Same for shared/services

### global_controller, global

- global_controller hold global state that live global & can used in any features
- global.dart => a helper that provide value getter for quick access to state value

### Translation

- Every content string that display on widget need to be localized by
  declaring in en.dart & vi.dart then 'string_key'.tr to get localized string

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
