# Docker-команда FROM вказує базовий образ контейнера
# slim - мінімальний образ
FROM python:3.11-slim

# Встановимо змінну середовища
# ENV APP_HOME /app

# Встановимо робочу директорію всередині контейнера
# WORKDIR $APP_HOME
WORKDIR .

# Скопіюємо інші файли в робочу директорію контейнера
COPY . .

# Оновлюємо pip
RUN pip install --upgrade pip

# Встановлюємо залежності з файлу requirements.txt
RUN pip install -r requirements.txt

# Позначимо порт, де працює застосунок всередині контейнера
EXPOSE 8000

# Запустимо наш застосунок всередині контейнера
ENTRYPOINT ["python", "main.py"]
