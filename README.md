# CLAUDE.md — NomNom — Multi-Restaurant Food Ordering Platform
## Project Overview

A multi-tenant food ordering platform where multiple restaurants can register and manage their menus, and customers can browse restaurants, place orders, and receive AI-powered meal recommendations based on their BMI and calorie goals.

Built as a **microservices backend** (for MSS301 — Microservices with Spring Boot) consumed by:
- A **Web frontend** (React.js) — restaurant management & customer ordering
- A **Flutter mobile app** — customer-facing ordering + AI recommendation

---

## Tech Stack

### Backend
- **Java 21** + **Spring Boot 3.x**
- **Spring Cloud** (Gateway, Eureka, OpenFeign, Config Server)
- **Spring Security** + **JWT** (authentication & authorization)
- **Apache Kafka** — async inter-service communication (order events, notifications)
- **Docker** + **Docker Compose** — containerization

### Databases (Database-per-Service pattern)
- **PostgreSQL** — User, Restaurant, Order, Payment services
- **Redis** — Caching (menu, sessions), rate limiting
- **MongoDB** — AI Recommendation service (flexible document for meal profiles)

### Frontend
- **React.js** + **Vite** + **Tailwind CSS** — Web app
- **Flutter** — Mobile app (Android/iOS)

### AI & Recommendation
- **Rule-based engine** — BMI/TDEE calculation (local, fast)
- **Claude API / OpenAI API** — Natural language meal suggestions & explanation

### Infrastructure
- **Spring Cloud Netflix Eureka** — Service Discovery
- **Spring Cloud Gateway** — API Gateway (JWT validation, routing, rate limiting)
- **Spring Cloud Config** — Centralized configuration
- **Swagger / OpenAPI 3** — API documentation per service

---

## Microservices Architecture

```
                        ┌─────────────────────┐
  Web / Flutter App ───▶│    API Gateway       │ :8080
                        │ (Auth, Routing,      │
                        │  Rate Limiting)      │
                        └────────┬────────────┘
                                 │
          ┌──────────────────────┼───────────────────────┐
          │                      │                       │
   ┌──────▼──────┐      ┌────────▼──────┐      ┌────────▼──────┐
   │ User Service│      │  Restaurant   │      │ Order Service │
   │    :8081    │      │  Service :8082│      │    :8083      │
   └──────┬──────┘      └────────┬──────┘      └────────┬──────┘
          │ PostgreSQL            │ PostgreSQL            │ PostgreSQL
          │              ┌────────▼──────┐               │
          │              │  Menu Service │               │
          │              │    :8084      │               │
          │              └───────────────┘               │
          │                   MongoDB/PG                  │
          │                                               │
   ┌──────▼──────┐      ┌───────────────┐      ┌────────▼──────┐
   │  Payment    │      │  AI Recommend │      │ Notification  │
   │  Service    │      │  Service :8086│      │  Service :8087│
   │    :8085    │      └───────────────┘      └───────────────┘
   └─────────────┘         MongoDB                  Kafka consumer
     PostgreSQL
          │
          └──────────────── Kafka ──────────────────────┘
                         (Event Bus)

   ┌─────────────────────┐     ┌─────────────────────┐
   │   Eureka Server     │     │   Config Server     │
   │      :8761          │     │      :8888          │
   └─────────────────────┘     └─────────────────────┘
```

---

## Services Breakdown

### 1. User Service `:8081`
Handles all user accounts across all roles.

**Roles:** `CUSTOMER` | `RESTAURANT_OWNER` | `ADMIN`

**Endpoints:**
- `POST /auth/register` — Register new user
- `POST /auth/login` — Login, returns JWT
- `GET /users/me` — Get current user profile
- `PUT /users/me` — Update profile (including height, weight for BMI)
- `GET /users/me/health` — Get BMI, TDEE, calorie goal

**DB:** PostgreSQL — `users`, `roles`

---

### 2. Restaurant Service `:8082`
Multi-tenant: each restaurant belongs to one `RESTAURANT_OWNER`.

**Endpoints:**
- `POST /restaurants` — Register new restaurant (owner only)
- `GET /restaurants` — List all active restaurants (public)
- `GET /restaurants/{id}` — Get restaurant details
- `PUT /restaurants/{id}` — Update restaurant info (owner only)
- `GET /restaurants/{id}/menus` — Get menus of a restaurant

**DB:** PostgreSQL — `restaurants`, `operating_hours`

---

### 3. Menu Service `:8084`
Manages menu items per restaurant. Includes calorie info for AI feature.

**Endpoints:**
- `POST /restaurants/{id}/items` — Add menu item (owner only)
- `GET /restaurants/{id}/items` — List menu items (public)
- `PUT /items/{id}` — Update item (owner only)
- `DELETE /items/{id}` — Delete item (owner only)

**Key fields per item:** `name`, `description`, `price`, `calories`, `protein_g`, `carb_g`, `fat_g`, `category`, `image_url`, `is_available`

**DB:** PostgreSQL (or MongoDB for flexible schema)

---

### 4. Order Service `:8083`
Manages the full order lifecycle. Uses **Saga Pattern** for distributed transaction.

**Order States:** `PENDING` → `CONFIRMED` → `PREPARING` → `READY` → `COMPLETED` | `CANCELLED`

**Endpoints:**
- `POST /orders` — Place new order
- `GET /orders/{id}` — Get order details
- `GET /orders/me` — Customer's order history
- `PUT /orders/{id}/status` — Update status (restaurant owner)
- `DELETE /orders/{id}` — Cancel order (customer, only if PENDING)

**Saga Flow:**
1. Order Service creates order (`PENDING`)
2. Calls Payment Service → payment reserved
3. Publishes `order.confirmed` event to Kafka
4. Restaurant Service consumes event → notifies owner
5. On failure → compensating transaction (refund)

**DB:** PostgreSQL — `orders`, `order_items`

---

### 5. Payment Service `:8085`
Handles payment processing (mock gateway, extendable to VNPay/Stripe).

**Endpoints:**
- `POST /payments` — Process payment for an order
- `GET /payments/{orderId}` — Get payment status
- `POST /payments/{id}/refund` — Refund (on cancellation)

**DB:** PostgreSQL — `payments`, `transactions`

---

### 6. AI Recommendation Service `:8086`
Two-layer recommendation system.

**Layer 1 — Rule-based (fast, local):**
- Input: user height, weight, age, gender, activity level, goal
- Calculate: BMI → category, TDEE → daily calorie target
- Filter: menu items whose calories fit within meal quota (e.g. lunch = 35% of TDEE)
- Output: list of suitable menu items with calorie match score

**Layer 2 — AI API (rich, explainable):**
- Sends user health profile + filtered items to Claude/OpenAI API
- Returns: natural language explanation, personalized top picks, warnings (e.g. high sodium)
- Cached in Redis for 1 hour per user per restaurant

**Endpoints:**
- `POST /recommendations` — Get recommendations
  ```json
  {
    "restaurant_id": "uuid",
    "meal_type": "LUNCH",
    "use_ai": true
  }
  ```
- `GET /recommendations/history` — User's past recommendations

**DB:** MongoDB — `recommendation_logs`, `user_health_profiles`

---

### 7. Notification Service `:8087`
Event-driven, consumes Kafka topics.

**Kafka Topics consumed:**
- `order.placed` → notify restaurant owner (new order)
- `order.confirmed` → notify customer (order confirmed)
- `order.ready` → notify customer (food ready)
- `order.cancelled` → notify both parties

**Channels:** In-app notification (stored in DB), Email (JavaMailSender / mock)

**DB:** PostgreSQL — `notifications`

---

## Multi-Tenant Design

- Every `Restaurant` has an `owner_id` (FK to User)
- Every `MenuItem` has a `restaurant_id`
- Every `Order` has a `restaurant_id` + `customer_id`
- API Gateway passes `X-User-Id` and `X-User-Role` headers after JWT validation
- Services use `@PreAuthorize` to enforce ownership (owner can only modify their own restaurant)

---

## Kafka Topics

| Topic | Producer | Consumer | Payload |
|---|---|---|---|
| `order.placed` | Order Service | Notification Service | orderId, restaurantId, customerId |
| `order.confirmed` | Order Service | Notification Service | orderId |
| `order.status.updated` | Order Service | Notification Service | orderId, newStatus |
| `order.cancelled` | Order Service | Payment Service, Notification Service | orderId |
| `payment.completed` | Payment Service | Order Service | orderId, status |
| `payment.failed` | Payment Service | Order Service | orderId, reason |

---

## API Gateway Routes

| Path prefix | Target Service | Auth required |
|---|---|---|
| `/api/auth/**` | User Service | ❌ |
| `/api/users/**` | User Service | ✅ |
| `/api/restaurants/**` | Restaurant Service | Partial |
| `/api/items/**` | Menu Service | Partial |
| `/api/orders/**` | Order Service | ✅ |
| `/api/payments/**` | Payment Service | ✅ |
| `/api/recommendations/**` | AI Service | ✅ |
| `/api/notifications/**` | Notification Service | ✅ |

---

## Project Structure (Monorepo)

```
food-ordering-platform/
├── infrastructure/
│   ├── eureka-server/
│   ├── api-gateway/
│   └── config-server/
├── services/
│   ├── user-service/
│   ├── restaurant-service/
│   ├── menu-service/
│   ├── order-service/
│   ├── payment-service/
│   ├── recommendation-service/
│   └── notification-service/
├── frontend/
│   └── web-app/               # React.js
├── mobile/
│   └── flutter-app/           # Flutter
├── docker-compose.yml
└── CLAUDE.md
```

---

## Development Timeline (10 Weeks — MSS301)

| Week | Focus | Key Output |
|---|---|---|
| 1 | Design & Planning | Architecture diagram, ERD, task assignment |
| 2 | Infrastructure Setup | Eureka, Gateway, Config Server running |
| 3 | User Service + Auth | JWT login/register, role-based access |
| 4 | Restaurant + Menu Service | CRUD APIs, multi-tenant enforcement |
| 5 | Order Service | Order lifecycle, basic Saga flow |
| 6 | Payment + Kafka | Payment mock, event-driven notifications |
| 7 | AI Recommendation Service | Rule-based engine + AI API integration |
| 8 | Web Frontend | React app consuming API Gateway |
| 9 | Testing + Docker | E2E tests, Docker Compose, documentation |
| 10 | Presentation | Final demo |

---

## Flutter App Scope (Separate Course)

The Flutter app connects to the same API Gateway and covers the **customer-facing** flow:

- Browse restaurants (list, search, filter by category)
- View menu items with calorie info
- AI Recommendation screen (input BMI data → get suggestions)
- Place order & track status (real-time polling or WebSocket)
- Order history
- Profile management (health data for AI feature)

---

## Environment Variables (per service)

```env
# Common
SERVER_PORT=808x
EUREKA_SERVER_URL=http://localhost:8761/eureka
JWT_SECRET=your_jwt_secret_here

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=service_db
DB_USER=postgres
DB_PASS=postgres

# Kafka
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# AI Service only
CLAUDE_API_KEY=your_claude_api_key
OPENAI_API_KEY=your_openai_api_key
REDIS_HOST=localhost
REDIS_PORT=6379
```

---

## Key Design Decisions

1. **Saga Pattern (Choreography)** for order placement — services react to Kafka events, no central orchestrator
2. **Database-per-Service** — each service owns its data, no shared DB
3. **JWT at Gateway** — token validated once at gateway, user info forwarded via headers
4. **AI caching** — recommendations cached in Redis to avoid repeated API calls
5. **Multi-tenant by ownership** — restaurant owners isolated by `owner_id` check, not by separate schema/DB
