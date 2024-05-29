# Bank

## Configuração do Ambiente

### Requisitos

- Docker
- Docker Compose
- Elixir
- Phoenix

### Passos para iniciar o servidor Phoenix

1. **Clone o repositório**

   ```sh
   git clone <URL_DO_SEU_REPOSITORIO>
   cd bank
   ```

2. **Configurar o Docker e o PostgreSQL**

   - Certifique-se de que o Docker e o Docker Compose estão instalados.
   - Crie um arquivo `docker-compose.yml` na raiz do projeto com o seguinte conteúdo:

     ```yaml
     version: '3.8'

     services:
       db:
         image: postgres:latest
         environment:
           POSTGRES_USER: postgres
           POSTGRES_PASSWORD: postgres
           POSTGRES_DB: bank_dev
         ports:
           - "5432:5432"
         volumes:
           - postgres_data:/var/lib/postgresql/data

     volumes:
       postgres_data:
     ```

   - Inicie os serviços do Docker:

     ```sh
     docker-compose up -d
     ```

3. **Configurar o Phoenix**

   - Instale as dependências e configure o projeto:

     ```sh
     mix setup
     ```

   - Atualize o arquivo `config/dev.exs` para conectar-se ao banco de dados PostgreSQL no Docker:

     ```elixir
     config :bank, Bank.Repo,
       username: "postgres",
       password: "postgres",
       database: "bank_dev",
       hostname: "localhost",
       show_sensitive_data_on_connection_error: true,
       pool_size: 10
     ```

4. **Executar migrações**

   - Execute as migrações do banco de dados:

     ```sh
     mix ecto.migrate
     ```

5. **Iniciar o servidor Phoenix**

   - Inicie o servidor Phoenix com:

     ```sh
     mix phx.server
     ```

   - Ou, para iniciar dentro do IEx (shell interativa do Elixir):

     ```sh
     iex -S mix phx.server
     ```

Agora você pode visitar usar o insomia e as collections que estão na raiz do projeto para executar o endpoint

