# Skill: handoff

**Cel:**
Przekazanie stanu pracy z jednego agenta/kroku do kolejnego (np. Architect -> Implementer).

**Logika:**
Jako input przyjmuje:
- Ostatnio wygenerowane `docs_summary`.
- Ostatnie commity/diffy (lub propozycje zmian).
- Opis nowego zadania.
- Poprzednie `handoff_summary`.

Generuje jako output `handoff_summary` zawierający:
- **Cel** (biznesowy + techniczny).
- **Kontekst** (kluczowe założenia).
- **Zakres zadania** (in-scope / out-of-scope).
- **Wejścia/Wyjścia** (pliki, interfejsy).
- **Checklisty** dla kolejnego agenta.
