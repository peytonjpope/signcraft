# SignCraft 🤟
[🌐 signcraft.peytonpope.com](https://signcraft.peytonjpope.com)

> *A resource for ASL learners to maintain vocabulary and practice grammar, with the intention of promoting Deaf community engagement*

### v1.6.1
- Filter words by category
- Target a specific template or word
- Prevented duplicate words types and structures
- NUMBER types. Select a min and max range to be generated


## What

### User Experience

SignCraft provides an easy-to-use approach to ASL vocab building and grammar practice:
1. **Get Started** - With carefully selected pre-installed common words, types, and templates
2. **Create Word Types** - That categorize your words. This can include parts of speech (ex. 'subject') or number ranges (ex. '1-100')
3. **Build Templates** - Design sentence structures following ASL grammar patterns. Example:
   - `topic + subject + verb` → "FOOD ME EAT"
4. **Add Vocabulary** - Build your personal word bank over time, categorized by word type
5. **Practice & Generate** - Create random sentences to practice words you know

### Technical Architecture
- **Backend Framework:** Phoenix (Elixir/Erlang)
- **Database:** PostgreSQL with Ecto
- **Frontend:** Phoenix with Tailwind CSS
- **Deployment:** Fly.io with Docker

## Why

- **Grow and maintain your ASL vocabulary** with word bank for review and long-term retention.

- **Practice ASL-specific grammar patterns** through contextual sentence building that reflects natural language use.

- **Promote engagement with the Deaf community** and culture by learning vocabulary and expressions rooted in real-world, culturally relevant contexts.

## Where

- **Live Application:** [signcraft.peytonpope.com](https://signcraft.peytonjpope.com)
- **Source Code:** [github.com/peytonjpope/signcraft](https://github.com/peytonjpope/signcraft)
- **Deployed on:** Fly.io

## How


**Prerequisites:**
- Elixir 1.17+, Erlang/OTP 27+, PostgreSQL 14+

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
- LinkedIn: [linkedin.com/in/peyton-pope-75202b24a](https://www.linkedin.com/in/peyton-pope-75202b24a/)
- GitHub: [github.com/peytonjpope](https://github.com/peytonjpope)

---