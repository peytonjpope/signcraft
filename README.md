# SignCraft 🤟
**Version 1.2.1**
[signcraft.peytonpope.com](https://signcraft.peytonjpope.com)

> *A resource for ASL learners to maintain vocabulary and practice grammar, with the intention of promoting Deaf community engagement*

## What

### User Experience

SignCraft provides a structured approach to ASL vocabulary building and grammar practice:

1. **Create Word Types** - Set up categories like "noun", "verb", "adjective" to organize vocabulary
2. **Build Templates** - Design sentence structures following ASL grammar patterns:
   - `PRONOUN + VERB + NOUN` → "ME EAT FOOD"
   - `ADJECTIVE + NOUN + VERB` → "BIG DOG RUN"
3. **Add Vocabulary** - Build your personal word bank, categorized by word type
4. **Practice & Generate** - Use templates to create random sentences for practice

### Technical Architecture
- **Backend Framework:** Phoenix (Elixir/Erlang)
- **Database:** PostgreSQL with Ecto
- **Frontend:** Phoenix with Tailwind CSS
- **Deployment:** Fly.io with Docker

## Why

### Purpose
- **Grow and maintain your ASL vocabulary** with a customizable word bank designed for consistent review and long-term retention.

- **Practice ASL-specific grammar patterns** through contextual sentence building that reflects natural language use.

- **Promote engagement with the Deaf community** and culture by learning vocabulary and expressions rooted in real-world, culturally relevant contexts.

## Where

- **Live Application:** [signcraft.peytonpope.com](https://signcraft.peytonjpope.com)
- **Source Code:** [github.com/peytonjpope/signcraft](https://github.com/peytonjpope/signcraft)
- **Deployed on:** Fly.io

## How


**Prerequisites:**
- Elixir 1.17+, Erlang/OTP 27+, PostgreSQL 14+, Node.js 18+

**Setup:**
```bash
# Clone and setup
mix setup

# Start development server
mix phx.server
# Visit localhost:4000

# Database management
mix ecto.create
mix ecto.migrate

# Testing
mix test
```

**Production Deployment:**
```bash
# Deploy to Fly.io
fly deploy

```

## Who

Created by **Peyton Pope** 

- Portfolio: [peytonjpope.com](https://peytonjpope.com)
- LinkedIn: [linkedin.com/in/peytonpope](https://linkedin.com/in/peytonpope)
- GitHub: [github.com/peytonjpope](https://github.com/peytonjpope)

---