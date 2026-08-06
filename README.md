# Zsolt AI PRO 3

AI alapú sportfogadás elemző Flutter alkalmazás.

**Verzió:** 0.3.0

## Funkciók (jelenlegi)

- Splash → fő navigáció (5 fül)
- **Kezdőlap**: AI tipp, AI score, következő meccsek, top tippek, value bet (repository adatokból)
- **Meccsek**: lista, keresés, kedvenc, nap/szűrő UI, meccs részletek
- **Profil**: StatPal + Gemini API kulcs mentése (secure storage)
- Quick Actions: fülváltás a kezdőlapról
- Mock meccsadatok + StatPal API fallback (ha van kulcs)

## Futtatás

```bash
cd zsolt_ai_pro_3-main
flutter pub get
flutter run
```

Opcionális API kulcs build időben:

```bash
flutter run --dart-define=STATPAL_API_KEY=your_key --dart-define=GEMINI_API_KEY=your_key
```

Vagy a **Profil** képernyőn mentheted a kulcsokat (secure storage).

## Struktúra

```
lib/
  core/          # config, network, cache, theme, storage
  models/        # AppMatch
  repositories/  # MatchRepository (API + mock)
  screens/       # Home, Matches, Profile, Splash, Detail
  services/      # ApiKeyService
  widgets/       # közös + match detail kártyák
```

## Következő lépések (később)

- Gemini AI tippek generálása
- Szelvény modul
- Élő odds / prematch endpointok bővítése
- Dark mode

## Licenc

Lásd `LICENSE`.
