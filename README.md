# PromptHub

PromptHub es una biblioteca colaborativa para guardar, versionar y compartir prompts junto con el contexto, el modelo y los resultados que demuestran por qué funcionan.

## Stack

- Ruby 3.4+
- Rails 8.1
- MySQL 8
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Minitest

## Funcionalidades del MVP

- Registro e inicio de sesión.
- Prompts públicos y privados.
- Búsqueda por texto, categoría y etiquetas.
- Historial inmutable de versiones.
- Forks privados para adaptar prompts públicos.
- Favoritos personales para guardar prompts públicos.
- Comentarios inline con edición del autor y moderación del dueño.
- Búsqueda Full-Text y filtros por categoría, modelo, etiqueta y popularidad.
- Comparación visual de versiones y restauración segura del historial.
- Dashboard personal, perfiles públicos, estadísticas y actividad reciente.
- Resultados de ejemplo asociados a cada prompt.
- Interfaz responsive y copia al portapapeles.
- Políticas explícitas de autorización para prompts y forks.
- Paginación reutilizable para listados.

## Puesta en marcha

1. Copia las variables de entorno:

   ```bash
   cp .env.example .env
   ```

2. Inicia MySQL (opcionalmente con Docker):

   ```bash
   docker compose up -d mysql
   ```

   En una instalación existente, crea la base de tests una sola vez:

   ```bash
   docker compose exec -T mysql mysql -uroot -proot_password -e "CREATE DATABASE IF NOT EXISTS prompt_hub_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; GRANT ALL PRIVILEGES ON prompt_hub_test.* TO 'prompt_hub'@'%'; FLUSH PRIVILEGES;"
   ```

3. Instala dependencias y prepara la base:

   ```bash
   bundle install
   set -a; source .env; set +a
   bin/rails db:prepare
   ```

4. Inicia Rails y el compilador de Tailwind:

   ```bash
   bin/dev
   ```

La aplicación estará disponible en `http://localhost:3000`.

## Verificación

```bash
bin/rails test
bin/rails zeitwerk:check
```

La fase de base incluye también tests de políticas, paginación, privacidad y validaciones de dominio.

## Producción con Docker

La imagen de producción incluye Rails, Puma, Tailwind compilado y el cliente de MySQL. Para levantar el entorno:

```bash
cp .env.production.example .env.production
# Edita .env.production y configura contraseñas y SECRET_KEY_BASE
docker compose --env-file .env.production -f compose.production.yml up -d --build
```

La aplicación queda disponible en `http://localhost:3000` y expone el healthcheck en `/up`. El entrypoint ejecuta `db:prepare` antes de iniciar Puma.

Para generar un backup comprimido de MySQL:

```bash
bin/backup
```

Los backups se guardan en `backups/`, que está excluido de Git. En producción real, configura una tarea programada que copie esos archivos a almacenamiento externo.

El workflow de GitHub Actions ejecuta tests, Zeitwerk y la compilación de Tailwind en cada push a `main` y pull request.

## Modelo de datos

`User` posee `Prompt`; cada prompt puede pertenecer a una `Category`, tener múltiples `Tag`, `PromptResult` y snapshots `PromptVersion`, además de referenciar el prompt original cuando es un fork.
