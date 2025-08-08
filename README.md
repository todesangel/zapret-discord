# zapret-discord  

```markdown
# Zapret-Discord-YouTube: Обход блокировок

Инструмент для обхода блокировок Discord и YouTube с поддержкой Cloudflare IP-переключения и автоматических обновлений.

## 📥 Установка
1. Скачайте последнюю версию из [Releases](https://github.com/your-repo/releases)
2. Распакуйте архив (требуется WinRAR/7-Zip)
3. Запустите `service.bat` от имени администратора

## 🛠 Основные функции
- **Обход блокировки Discord** через DPI-обфускацию (`discord.bat`)
- **Переключение Cloudflare IP** (`cloudflare_switch.bat`)
- **Автоматические обновления** (`autoupdate.bat` и встроенные в `service.bat`)
- **Системные сервисы** (установка/удаление через `service.bat`)

## 🚀 Быстрый старт
### Для Discord:
```bash
discord.bat
```

### Переключение Cloudflare IP:
```bash
cloudflare_switch.bat
```
(Переключает между реальными IP Cloudflare и заглушкой `0.0.0.0`)

## ⚙️ Менеджер сервисов (`service.bat`)
```
1. Install Service
2. Remove Services
3. Check Service Status
4. Run Diagnostics
5. Check Updates
```

## 🔄 Автообновление
Система проверяет новые версии на GitHub:
- Ручная проверка: `autoupdate.bat`
- Автоматическая проверка при запуске `discord.bat`

## 📁 Структура файлов
```
/bin/          - Исполняемые файлы (winws.exe)
/lists/        - IP-списки (ipset-cloudflare.txt, list-discord.txt)
cloudflare_switch.bat - Переключатель Cloudflare
discord.bat    - Основной скрипт обхода
service.bat    - Менеджер сервисов
autoupdate.bat - Скрипт обновлений
```

## ⚠️ Важно
- Требуются права администратора
- Анти-DPI методы могут замедлить соединение
- Cloudflare IP могут меняться - актуальный список в `ipset-cloudflare.txt`
