# ZenSpace (Alcove Clone) - Global Context

## Źródła prawdy (Priorytety)
1. `docs/PRD.md` - Wymagania biznesowe i funkcjonalne
2. `docs/SDD.md` - Architektura i projekt systemu
3. `docs/TECH_STACK.md` - Technologie i biblioteki
4. `docs/ROADMAP.md` - Priorytety i harmonogram
5. UI makiety
6. Aktualny kod w repozytorium

## Ogólny Workflow
`/arch` (Architect) → `/ux` (UX/UI) → `/impl` (Implementer) → `/qa` (QA/Verifier) → `/docs` (Documentation Update)

## Zasady Bezpieczeństwa (Twarda Izolacja)
- **NIE WYSYŁAJ** kodu poza lokalne modele (np. LM Studio).
- **NIE UŻYWAJ** służbowego Claude/Anthropic API dla tego projektu.
- Wszystkie operacje muszą odbywać się w izolowanym środowisku `claude-local` (`claude-zenspace`).
