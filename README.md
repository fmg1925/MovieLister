# Catálogo de Películas - Ruby on Rails

Este es un proyecto web desarrollado en **Ruby on Rails** que permite explorar un catálogo de películas utilizando la API de [The Movie Database (TMDb)](https://www.themoviedb.org/). La aplicación ofrece funcionalidades como búsqueda, gestión de usuarios y un diseño en **modo oscuro**.

## Características

- **Búsqueda de películas** mediante la API de TMDb.
- **Gestión de usuarios** (base de datos local): crear y eliminar cuentas.
- **Estilos en modo oscuro.**
- Interfaz clara y sencilla para la exploración del catálogo.
  
## Tecnologías utilizadas

- **Ruby on Rails**
- **The Movie DB API**
- **PostgreSQL**
- **HTML/CSS**
  
## Instalación y uso

1. **Clona el repositorio:**

   ```bash
   git clone https://github.com/fmg1925/MovieLister.git
   cd MovieLister
   ```

2. **Instalar las dependencias:**
    ```bash
    bundle install
    ```

3. **Configura el archivo `config/database.yml`:**

    Copia el archivo de ejemplo:
    ```bash
    cp config/database.example.yml config/database.yml
    ```

    **Edita las siguientes líneas con tus credenciales si es necesario:**
    ```yml
    username: postgres
    password: password
    host: localhost
    ```

4. **Configurar la base de datos:**
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed # Para generar usuarios de prueba
    ```

5. **Agregar API Key y Token de TMDb:**
    ```env
    API_KEY=TU_KEY_AQUÍ
    TOKEN=TU_TOKEN_AQUÍ
    ```

6. **Iniciar el servidor:**
    ```bash
    rails server
    ```

7. **Visita `http://localhost:3000` en tu navegador.**