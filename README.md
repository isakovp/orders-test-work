# Orders API

Простой REST API для управления пользователями, заказами и счетами.

## API Endpoints

### Пользователи

| Метод | Путь | Описание | Параметры |
|-------|------|----------|-----------|
| `GET` | `/api/users` | Список всех пользователей | — |
| `GET` | `/api/users/:id` | Получить пользователя по ID | — |
| `POST` | `/api/users` | Создать пользователя | `user[name]`, `user[email]` |

### Заказы

| Метод | Путь | Описание | Параметры |
|-------|------|----------|-----------|
| `GET` | `/api/users/:user_id/orders` | Заказы конкретного пользователя | — |
| `POST` | `/api/users/:user_id/orders` | Создать заказ для пользователя | `order[name]`, `order[amount]` |
| `GET` | `/api/orders/:id` | Получить заказ по ID | — |
| `POST` | `/api/orders/:id/complete` | Завершить заказ | — |
| `POST` | `/api/orders/:id/cancel` | Отменить заказ | — |

## Примеры запросов

```bash
# Создать пользователя
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"user": {"name": "Иван", "email": "ivan@example.com"}}'

# Создать заказ
curl -X POST http://localhost:3000/api/users/1/orders \
  -H "Content-Type: application/json" \
  -d '{"order": {"name": "Тестовый заказ", "amount": 100.0}}'

# Завершить заказ
curl -X POST http://localhost:3000/api/orders/1/complete
```

## Модели

- **User** — пользователь (имеет один счёт и множество заказов)
- **Account** — счёт пользователя (баланс, транзакции)
- **Order** — заказ (статусы: `created`, `completed`, `cancelled`)
- **Transaction** — транзакция (виды: `credit`, `debit`)
