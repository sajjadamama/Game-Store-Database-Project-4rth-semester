# 🎮 Game Store

**Course:** Database Systems Project
**Members:** Amama (f23-6014) · Nehza (f23-0822)
**Class:** BS CS 4E · **Deadline:** 09-May-2025

---

## Overview

Game Store is a console/web-based e-commerce application simulating an online game marketplace. It covers user authentication, game browsing, shopping cart, order processing, payment simulation, and admin inventory management — all backed by a relational database.

---

## Features

- **User Authentication** : Signup, login, logout with hashed passwords
- **Role-Based Access** : Customer and Admin roles with separate permissions
- **Game Catalogue** : Browse and filter games by genre and platform
- **Shopping Cart** : Add/remove games with dynamic total calculation
- **Order Processing** : Place orders with automatic inventory update via trigger
- **Payment Simulation** : Select payment method and confirm transaction
- **Order Tracking** : Track order status (Processing → Shipped → Delivered)
- **Admin Panel** : Add, edit, and delete games; manage orders

---

## Database Schema

Five tables normalized to 3NF:

| Table | Key Fields |
|---|---|
| Users | user_id, username, email, password, role |
| Games | game_id, title, description, price, genre, platform |
| Orders | order_id, user_id, order_date, total_amount, status |
| Payments | payment_id, order_id, payment_date, payment_status, payment_method |
| Inventory | game_id, stock_quantity |

**SQL features:** JOINs, VIEWs, INDEXes, a trigger (auto-decrement inventory on order), and stored procedures for login/signup validation.

---

## Project Structure

```
GameStore/
├── Database/
│   ├── schema.sql          # Tables, relationships, indexes
│   ├── triggers.sql        # Inventory update trigger
│   └── views.sql           # Order summary views
├── UI/
│   ├── index.html          # Home page with game listing + filters
│   ├── product.html        # Game detail page
│   ├── cart.html           # Shopping cart
│   ├── order-summary.html  # Order review before payment
│   └── login.html          # Login and registration forms
├── Auth/
│   ├── auth.cs             # Login, signup, session management
│   └── rbac.cs             # Role-based access control
├── Core/
│   ├── cart.cs             # Cart logic
│   ├── orders.cs           # Order placement
│   └── payments.cs         # Payment processing
└── Admin/
    ├── admin.cs            # Inventory management
    └── tracking.cs         # Order status tracking
```

---

## How to Run

**1. Database**
```sql
-- Run in MySQL or SSMS in this order:
source schema.sql
source triggers.sql
source views.sql
```

**2. Backend**
- Open the project in Visual Studio
- Update the DB connection string in `appsettings`
- Press **Ctrl+F5** to build and run

**3. Use the App**
- Register a new account or log in as admin
- Browse games, add to cart, place an order

---

## Tech Stack

- **Database:** MySQL / SQL Server
- **Backend:** C# / ASP.NET
- **Frontend:** HTML, CSS, JavaScript
- **Tools:** MS Visio (ERD), SSMS / MySQL Workbench

---

## Deliverables

| # | Deliverable | Contents |
|---|---|---|
| 1 | Database Design & Setup | schema.sql, triggers, views, Word doc |
| 2 | Basic UI | HTML/CSS/JS forms, screenshots, Word doc |
| 3 | Auth & RBAC | Auth backend, screenshots, Word doc |
| 4 | Cart & Orders | Cart/order/payment code, Word doc |
| 5 | Final Application | Full project, testing, Word doc |
