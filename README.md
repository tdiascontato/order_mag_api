# Projeto Rails Magalu! ️️

Este projeto é uma API Rails configurada com Docker e Docker Compose para gerenciamento de ordens através de API Rest incluindo funcionalidades de upload, consulta por ID e filtro por data. Siga as instruções abaixo para configurar o ambiente corretamente! 🚀

## Pré-requisitos 🐋

- **Docker** e **Docker Compose** instalados

## Início Rápido 🚀

### 1. Construir e Iniciar os Contêineres 🔨

Para construir e iniciar o ambiente Docker, execute:

```bash
docker-compose build
docker-compose up -d
```

Isso iniciará a API em um contêiner Docker e a deixará rodando em segundo plano.

### 2. Executar Testes 🧪

Para rodar os testes da aplicação, utilize o seguinte comando:

```bash
rails test
```

Para iniciar o servidor manualmente após rodar os testes, você pode utilizar:

```bash
rails s
```

A API estará disponível em `http://localhost:3000`.

## Endpoints da API 🌐

Os endpoints desta API estão disponíveis sob o namespace `/api/v1/orders` e oferecem funcionalidades para upload, consulta por ID e filtro de ordens por data.

### **POST `/api/v1/orders`** 📑

**Descrição:** Carrega e processa todas as orders.

**Parâmetro:**

- `data_txt` - arquivo de texto contendo os dados das ordens.

**Resposta de Sucesso (200):**

```json
[
  {
    "user_id": 1,
    "name": "Tiago Dias",
    "orders": [
      {
        "order_id": 1010,
        "date": "2024-03-05",
        "total": "150.00",
        "products": [
          { "product_id": 1, "value": "100.00" },
          { "product_id": 2, "value": "50.00" }
        ]
      }
    ]
  }
]
```

**Erros:**

- **400 Bad Request:** Quando o arquivo `data_txt` não é fornecido.

### **POST `/api/v1/orders/id`** 🔑

**Descrição:** Retorna os detalhes de uma ordem específica com base em seu ID.

**Parâmetros:**

- `data_txt` - arquivo de texto contendo os dados das ordens.
- `order_id` - ID da ordem que você deseja consultar.

**Resposta de Sucesso (200):**

```json
{
  "order_id": 1010,
  "date": "2024-03-05",
  "products": [
    { "product_id": 1, "value": "100.00" },
    { "product_id": 2, "value": "50.00" }
  ]
}
```

**Erros:**

- **400 Bad Request:** Quando `data_txt` ou `order_id` não são fornecidos.
- **404 Not Found:** Quando a ordem com o `order_id` especificado não é encontrada.

### **POST `/api/v1/orders/filters`** 🔍

**Descrição:** Retorna todas as ordens dentro de um intervalo de datas.

**Parâmetros:**

- `data_txt` - arquivo de texto contendo os dados das ordens.
- `start_date` - data inicial do intervalo, no formato `YYYYMMDD`.
- `end_date` - data final do intervalo, no formato `YYYYMMDD`.

**Resposta de Sucesso (200):**

```json
[
  {
    "user_id": 1,
    "name": "Tiago Dias",
    "orders": [
      {
        "order_id": 1010,
        "date": "2024-03-04",
        "total": "75.00",
        "products": [
          { "product_id": 3, "value": "75.00" }
        ]
      }
    ]
  }
]
```

**Erros:**

- **400 Bad Request:** Quando `data_txt`, `start_date` ou `end_date` não são fornecidos.

## Estrutura de Arquivos e Funções Principais ⚙️

### docker-compose.yml 🐳
Configura os serviços e dependências da aplicação e o mapeamento de portas para acesso à API.

### Dockerfile 🐳
Configura a imagem do ambiente Rails:

- Instala as dependências necessárias.
- Utiliza múltiplos estágios de build para reduzir o tamanho da imagem final.
- Define o usuário como não root para melhor segurança.

### OrdersController 🔧

O controlador `OrdersController` processa as funcionalidades principais:
- **Upload de ordens** com parsing do arquivo e agrupamento por usuário e ordem.
- **Consulta por ID de ordem**.
- **Filtragem de ordens** por intervalo de datas.

### Concerns 🛠️

Utilização de concerns para evitar repetição de código e auxiliar em um código ruby mais direto e limpo.
- **parse_file_dates** para limpeza do arquivo com filtro data.
- **parse_file_id** para limpeza do arquivo com filtro id.
