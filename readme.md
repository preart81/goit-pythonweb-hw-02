# Тема 2. Основи технології Docker

Вам необхідно клонувати FastAPI-застосунок, налаштувати його та запустити в Docker-контейнері. Після цього перевірите правильність роботи застосунку і переконатись в успішному підключенні до бази даних.

## Технічний опис завдання

1. Використовуючи команду `git clone`, клонуйте репозиторій за адресою [https://github.com/GoIT-Python-Web/FullStack-Web-Development-hw2](https://github.com/GoIT-Python-Web/FullStack-Web-Development-hw2). Перейдіть у клонований каталог.
2. Створіть `Dockerfile` із вказівками для створення образу Docker застосунку.
3. Напишіть `docker-compose.yaml` з конфігурацією для застосунку та PostgreSQL.
4. Використайте Docker Compose для побудови середовища, команду `docker-compose up` для запуску середовища.

## Рішення

1.  Клонування репозиторію:  
    `git clone https://github.com/GoIT-Python-Web/FullStack-Web-Development-hw2`
2.  `Dockerfile` із вказівками для створення образу Docker застосунку:  
     [Dockerfile](Dockerfile)  
     Встановлення бібліотек і запуск:

    ```bash
    # Встановлюємо залежності з файлу requirements.txt
    RUN pip install -r requirements.txt

    # Запустимо наш застосунок всередині контейнера
    ENTRYPOINT ["python", "main.py"]
    ```

3.  `docker-compose.yaml` з конфігурацією для застосунку та PostgreSQL:
    [docker-compose.yml](docker-compose.yml)
4.  Побудова і запуск контейнера

    - щоб виправити помилку із встановленням psycopg2 на Linux, додамо умови `platform_system` в `requirements.txt`:

    ```diff
    -psycopg2==2.9.9 ; python_version >= "3.10" and python_version < "4.0"
    +psycopg2==2.9.9 ; python_version >= "3.10" and python_version < "4.0" and platform_system == "Windows"
    +psycopg2-binary==2.9.9 ; python_version >= "3.10" and python_version < "4.0" and platform_system == "Linux"
    ```

    - `docker compose up --build -d`

    ```sh
    docker compose up --build -d

    [+] Running 3/3
     ✔ Network goit-pythonweb-hw-02_default       Created
     ✔ Container goit-pythonweb-hw-02-web-1       Started
     ✔ Container goit-pythonweb-hw-02-postgres-1  Started
    ```

    - Перевіримо чи працює контейнер

    ```
    $ docker ps
    CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS         PORTS                    NAMES
    748f08f83336   postgres:16                "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:5432->5432/tcp   goit-pythonweb-hw-02-postgres-1
    e3dca946468e   goit-pythonweb-hw-02-web   "python main.py"         4 minutes ago   Up 4 minutes   0.0.0.0:8000->8000/tcp   goit-pythonweb-hw-02-web-1
    ```

    - для того щоб наш застосунок міг підключитись до контейнера Postgres, потрібно вказати правильний хост в [db.py](conf/db.py) (повинен відповідати назві сервісу `services: postgres`, з [docker-compose.yml](docker-compose.yml)):
      `git diff conf/db.py`

    ```diff
    -SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://postgres:567234@localhost:5432/hw02"
    +SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://postgres:567234@postgres:5432/hw02"
    ```

          - Перевіримо роботу застосунку і доступність БД, відкривши налаштований порт в браузері:

    ![alt text](md.media/p5_.png)
