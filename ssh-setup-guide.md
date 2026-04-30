# Быстрая настройка SSH для подключения к серверам

## 1. Копирование ключей

```bash
# Создать папку, если нет
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Скопировать файлы ключей (с флешки / другой машины)
cp id_rsa id_rsa.pub ~/.ssh/

# Права (ОБЯЗАТЕЛЬНО!)
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

## 2. Настройка SSH-клиента (~/.ssh/config)

Создайте файл `~/.ssh/config`:

```
Host masterlogger
    HostName 192.168.6.22
    User masterlogger
    IdentityFile ~/.ssh/id_rsa
    HostKeyAlgorithms +ssh-rsa
    KexAlgorithms +diffie-hellman-group14-sha1
    PubkeyAcceptedAlgorithms +ssh-rsa

Host lt-local
    HostName 192.168.6.51
    User za
    IdentityFile ~/.ssh/id_rsa
    HostKeyAlgorithms +ssh-rsa
    KexAlgorithms +diffie-hellman-group14-sha1
    PubkeyAcceptedAlgorithms +ssh-rsa
```

Установите права:
```bash
chmod 600 ~/.ssh/config
```

## 3. Первое подключение

```bash
# Удалить старый ключ, если был
ssh-keygen -R 192.168.6.22
ssh-keygen -R 192.168.6.51

# Подключиться (подтвердите новый ключ при запросе)
ssh masterlogger
ssh lt-local
```

## 4. SSHFS (монтирование)

```bash
#!/bin/bash
fusermount -u /home/za/leutvas 2>/dev/null

sshfs lt-local:/data/profiles/profile01/installedApps/uunet/it4profit-ear.ear /home/za/leutvas

echo lt-local mounted
```

Или с полными опциями (если config не используется):
```bash
sshfs -o ssh_command="ssh -i ~/.ssh/id_rsa -oHostKeyAlgorithms=+ssh-rsa -oKexAlgorithms=+diffie-hellman-group14-sha1 -oPubkeyAcceptedAlgorithms=+ssh-rsa" za@192.168.6.51:/remote/path /local/mount
```

## 5. Проверка прав (если ошибки)

```bash
ls -la ~/.ssh/
# Должно быть:
# drwx------  .ssh/
# -rw-------  config
# -rw-------  id_rsa
# -rw-r--r--  id_rsa.pub
# -rw-r--r--  known_hosts
```

## Команды одной строкой для новой машины

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa ~/.ssh/config 2>/dev/null; ssh-keygen -R 192.168.6.22; ssh-keygen -R 192.168.6.51
```
