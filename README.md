# Процесс безопасной передачи файлов проекта на удалённый сервер

## 1. Создание SSH-ключа

Для подключения к серверу создаём SSH-ключ:

```bash
ssh-keygen -t ed25519 -C "devops-monitoring"
```

Ключи сохраняются в папке ~/.ssh

## 2. Копирование ключа на сервер

Отправляем открытый ключ на сервер:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@SERVER_IP
```

Вместо username и SERVER_IP указываем имя пользователя и IP-адрес сервера

## 3. Передача проекта

Создаем архив проекта:

```bash
tar --exclude='.git' --exclude='*.log' -czf project.tar.gz infra-monitoring-project
```

Копируем архив на сервер:

```bash
scp project.tar.gz username@SERVER_IP:~
```

## 4. Запуск проекта на сервере

Подключаемся к серверу:

```bash
ssh username@SERVER_IP
```

Распаковываем архив:

```bash
tar -xzf project.tar.gz
cd infra-monitoring-project
```

Запускаем Docker Compose:

```bash
docker compose up -d
```

Проверяем работу:

```bash
docker compose ps
curl http://localhost:80
```

Если всё работает, появится сообщение:

```text
Monitoring Service Active
```
