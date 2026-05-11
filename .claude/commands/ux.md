# Command: /ux

Uruchamia agenta w roli UX / UI.

**Workflow:**
1. Wywołuje skill `read-docs` (szczególnie skupiając się na wytycznych UI).
2. Odbiera `handoff` od Architekta (jeśli istnieje).
3. Określa struktury interfejsu (stany, ścieżki).
4. Przekazuje `handoff` do Implementera `/impl`.
