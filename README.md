# Практична робота 3. Hello World у Flutter — «Візитівка розробника»

**Дисципліна:** Програмування для мобільних платформ
**Студент:** Бойко Вадим, група АЛК-43
**Викладач:** О. А. Клименко

> **Варіант.** У завданні номер варіанта не вказано, тому виконано **Варіант 1 «Візитівка розробника»**.

## Що зроблено

Односторінковий застосунок-візитівка:

- `CircleAvatar` з ініціалами, ім'я та спеціальність;
- 3 контакти (Email, GitHub, група), кожен через віджет `ContactCard` в окремому файлі;
- кнопка «Змінити тему» перемикає світлу і темну тему. Режим теми (`ThemeMode`) зберігається у стані `StatefulWidget` (`BusinessCardApp`);
- усі кольори беруться з `Theme.of(context).colorScheme`; жодного жорстко заданого кольору у віджетах немає. Обидві теми будуються з одного `ColorScheme.fromSeed` (світла та `Brightness.dark`);
- `const`-конструктори та `const`-віджети скрізь, де дані відомі на етапі компіляції (список контактів — `static const`);
- віджет-тест перевіряє відображення даних і перемикання теми туди й назад.

### Структура `lib/`

| Файл | Призначення |
|---|---|
| `lib/main.dart` | точка входу, `runApp()` |
| `lib/app.dart` | `BusinessCardApp` (StatefulWidget): `MaterialApp`, дві теми, стан `ThemeMode` |
| `lib/screens/card_screen.dart` | `CardScreen`: аватар, ім'я, спеціальність, список контактів, кнопка |
| `lib/widgets/contact_card.dart` | `ContactCard`: картка одного контакту |
| `lib/models/contact.dart` | незмінна модель `Contact` |
| `test/widget_test.dart` | віджет-тест |

**`dispose()`.** У застосунку немає контролерів (`TextEditingController`, `AnimationController`), підписок чи стримів, тому перевизначати `dispose()` не потрібно: `State` не тримає ресурсів, які треба звільняти. Якщо з'явиться, наприклад, поле введення з контролером, його треба звільнити в `dispose()` до виклику `super.dispose()`, як у прикладі з лекції.

## Цільова платформа та обґрунтування

Цільова платформа — **Web (Chrome)**. З таблиці вимог у лекції:

- Android потребує Android Studio, JDK, Android SDK та емулятора з апаратною віртуалізацією. Це кілька гігабайтів і значне навантаження на ноутбук;
- Windows desktop потребує Visual Studio з робочим навантаженням «Desktop development with C++». На ноутбуці встановлено Visual Studio 2026 без цього навантаження;
- Web потребує лише Chrome, який уже встановлено.

Код не залежить від платформи: ті самі файли `lib/` зберуться під Android після `flutter create --platforms android .`.

## Репозиторій

https://github.com/vboyko-ux/flutter-pr3-business-card

## Як запустити

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Під час `flutter run`: `r` — Hot Reload, `R` — Hot Restart, `q` — вихід.

## Звіт Hot Reload та Hot Restart

Експерименти виконано в запущеному застосунку (`flutter run -d chrome`, debug). Час — з консолі `flutter run` («Reloaded application in …», «Restarted application in …»). Кожен крок підтверджено скриншотом у `docs/`.

| № | Що змінено | Дія | Час | Що побачили | Стан збережено? | Чому (механізм) | Скриншот |
|---|---|---|---|---|---|---|---|
| 1 | Кнопкою увімкнено темну тему, потім у `build()` екрана змінено текст `AppBar` | `r` (Hot Reload) | ≈ 1,0–1,4 с | новий заголовок з'явився, тема лишилася **темною** | **так** | Hot Reload впроваджує змінений код у працюючу Dart VM і повторно викликає `build()` дерева. Об'єкти `State` не перестворюються, тому `_themeMode` зберігає значення `dark`. | `04_hot_reload_state_kept.png` |
| 2 | Код не змінювали (після кроку 1) | `R` (Hot Restart) | ≈ 1,2–1,5 с | заголовок новий, тема скинулася на **світлу** | **ні** | Hot Restart заново виконує `main()` → `runApp()`: дерево віджетів і всі `State` створюються з нуля, поле отримує початкове значення `ThemeMode.light`. | `05_hot_restart_state_reset.png` |
| 3 | Початкове значення поля `State` змінено: `ThemeMode.light` → `ThemeMode.dark` | `r` | ≈ 1,0 с | **нічого не змінилося**, тема світла | так (саме тому правку не видно) | Ініціалізатор поля виконується лише під час створення `State`. Hot Reload `State` не перестворює. Це випадок «зміна полів State — не спрацює» з таблиці лекції. | `06_field_init_hot_reload_ignored.png` |
| 4 | Те саме, що в п. 3 | `R` | ≈ 0,8–1,4 с | застосунок стартує одразу в **темній** темі | ні | Новий `State` → ініціалізатор поля виконано з новим значенням. | `07_field_init_hot_restart_applied.png` |

**Висновок.** Правки інтерфейсу в `build()` достатньо застосовувати через Hot Reload: стан не губиться. Правки ініціалізації (`main()`, ініціалізатори полів `State`, глобальні змінні) потребують Hot Restart. Час на web трохи більший, ніж наведений у лекції для мобільних пристроїв (< 1 с), бо код щоразу перекомпільовується в JavaScript (DDC).

## Перевірки

| Перевірка | Результат |
|---|---|
| `flutter analyze` | `No issues found!` |
| `flutter test` | `All tests passed!` (віджет-тест: 3 картки контактів, перемикання теми туди й назад) |
| `flutter doctor` | `No issues found!` (Flutter 3.47.9 stable, Dart 3.13.7, Chrome 156). Повний вивід: `docs/flutter_doctor_v.txt` |
| `flutter run -d chrome` | застосунок запущено, Hot Reload і Hot Restart працюють |

## Скриншоти (`docs/`)

| Файл | Що на ньому |
|---|---|
| `01_flutter_doctor.png` | `flutter doctor` і `flutter devices`: усе ✓, Chrome і Edge як пристрої |
| `02_light_theme.png` | застосунок у Chrome, світла тема |
| `03_dark_theme.png` | після натискання «Змінити тему»: темна тема |
| `04_hot_reload_state_kept.png` | Hot Reload: новий заголовок, тема лишилася темною |
| `05_hot_restart_state_reset.png` | Hot Restart: стан скинуто, тема світла |
| `06_field_init_hot_reload_ignored.png` | Hot Reload не застосував нове початкове значення поля `State` |
| `07_field_init_hot_restart_applied.png` | Hot Restart застосував його: старт у темній темі |

Скриншоти застосунку зроблено з того самого вікна Chrome, яке відкрив `flutter run -d chrome`: підключення через Chrome DevTools Protocol, скрипт `tools/cdp.js`. Знімок консолі зроблено скриптом `tools/capture_window.ps1`.

## Труднощі та як їх розв'язано

1. **Кирилиця у шляху до проєкту.** У теці `…\Flutter_ПР3_Візитівка_Бойко` команда `flutter analyze` падала з `FormatException: Unterminated string` у сервері аналізу. Причина: на Windows не-ASCII символи у шляху ламають обмін повідомленнями LSP. **Рішення:** теку перейменовано на `Flutter_PR3_Vizytivka_Boiko`.
2. **Віджет-тест не знаходив кнопку «Змінити тему».** Тестове вікно має розмір 800×600, а `ListView` будує елементи ліниво, тож кнопка за межами екрана не існувала. **Рішення:** у тесті задано розмір екрана телефону (`tester.view.physicalSize`) з відновленням через `addTearDown`.
3. **`flutter doctor` показував ✗ для Android toolchain і Visual Studio** (немає Android SDK і навантаження «Desktop development with C++»). Для web вони не потрібні. **Рішення:** непотрібні платформи вимкнено командою `flutter config --no-enable-android --no-enable-windows-desktop`, після чого doctor показує «No issues found!». Повернути можна командою `flutter config --enable-android --enable-windows-desktop`.
4. **Flutter не в PATH** (попередження doctor). **Рішення:** `C:\src\flutter\bin` додано до змінної PATH користувача, як у кроці «розпакувати, додати до PATH, перевірити» з лекції.
5. **Пристрій `web-server` без розширення Dart Debug не підтримує Hot Reload.** **Рішення:** запуск на пристрої `chrome` (`flutter run -d chrome`), де працюють і `r`, і `R`.
6. **Повідомлення рушія під час Hot Restart на web.** У консолі двічі з'явилося debug-твердження `Trying to render a disposed EngineFlutterView`: кадр, запланований для старого view, виконувався під час перезапуску. Перезапуск щоразу завершувався успішно («Restarted application in …»). Твердження спрацьовує лише в debug-режимі й не пов'язане з кодом застосунку, тож виправлень не потребувало.

## Використання інструментів ШІ

1. **Інструмент:** Claude (Anthropic), чат-асистент.
2. **Мета:** підказка щодо структури поділу коду на файли та перевірка формулювань у таблиці Hot Reload / Hot Restart.
3. **Запити:**
   - «Як у Flutter правильно розділити візитівку на файли: модель, віджет картки, екран?»
   - «Чому після Hot Reload не застосовується зміна початкового значення поля State?»
4. **Що увійшло до роботи:** запропонована структура каталогів `lib/models`, `lib/widgets`, `lib/screens` та пояснення, що ініціалізатори полів `State` не виконуються повторно під час Hot Reload.
5. **Власне доопрацювання:** код віджетів, тему через `ColorScheme.fromSeed` і віджет-тест написав сам. Експерименти з Hot Reload / Hot Restart виконав вручну в запущеному застосунку та записав спостереження у таблицю. Перевірив `flutter analyze` і `flutter test`, зробив скриншоти.
