# Architecture

The Flutter application uses feature-first organisation and a small set of direct boundaries:

```text
Presentation (Flutter + Riverpod + go_router)
                    ↓
Domain (pure calculations and models)
                    ↓
Local data operations
                    ↓
Generated Drift database / SQLite
```

Widgets contain interaction and display logic; the energy engine and serving/nutrition scaling are pure domain code. `AppDatabase` extends Drift's supported generated database, owns its explicit migration strategy, transactions, seeds, and local queries. A generic repository hierarchy was deliberately avoided because Phase 1 has one data source.

Local-first means diary writes complete in SQLite before success is presented. Reads never require connectivity. Historical entries store nutrient snapshots, so later food corrections cannot rewrite history.

The intended, unimplemented future boundary is:

```text
SQLite
   ↓
Future sync queue
   ↓
Future API
```

Neither the queue nor API exists in Phase 1.
