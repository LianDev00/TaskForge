# TaskForge

**Opus piensa, Haiku construye.** Un modelo fuerte diseña la arquitectura una sola vez y la deja en una spec ejecutable (`SPEC-TF`). Después, un modelo barato la construye sin tomar decisiones de diseño. Pagas el modelo caro solo donde los errores salen caros.

*English below.*

## Instalación

```
/plugin marketplace add LianDev00/taskforge
/plugin install taskforge@taskforge
```

## Uso

| Comando | Qué hace |
|---|---|
| `/taskforge:spec <idea>` | **Arquitecto.** Diseña y entrega `SPEC-TF-<proyecto>.md`. Úsalo con Opus. |
| `/taskforge:construir <spec>` | **Constructor.** Construye fase por fase a partir de la spec. Úsalo con Sonnet o Haiku. |
| `/taskforge:arreglar <síntoma>` | **Taller.** Arregla el bug en la causa raíz, con el diff más corto, y deja un test que lo demuestra. |
| `/taskforge:revisar <ruta>` | **Revisión.** Dos pasadas: lo que sobra (hasta 10) y la deuda arquitectónica (hasta 7). |
| `/taskforge:deuda` | Lista los `TODO-ARQUITECTO` y los atajos marcados `TF-TECHO`. |

No hace falta usar los comandos: la skill se activa sola cuando dices "quiero hacer una app / web / automatización…", cuando pides arreglar un bug o cuando pegas una `SPEC-TF`. En conversaciones casuales no se activa.

## Cómo funciona

1. **Arquitecto:** separa el núcleo estable de los bordes volátiles, registra cada decisión con su porqué y deja por escrito qué queda **fuera del alcance**.
2. **SPEC-TF:** es el puente entre los dos modelos. Incluye fases, contratos, criterios de aceptación y anti-instrucciones concretas ("NO hagas X").
3. **Constructor:** obedece la spec. Si encuentra una decisión que la spec no cubre, no improvisa: deja un `TODO-ARQUITECTO` en el código y esa decisión vuelve al modelo fuerte.

4. **Taller:** para bugs y cambios chicos no hay spec. Se recorre una escalera (¿hace falta? → ¿ya existe en el repo? → librería estándar → función nativa → dependencia instalada → una línea → mínimo código) y el bug se arregla donde pasan todas las llamadas, no solo en la que falló. Si el arreglo exige rediseñar, lo dice en vez de parchear.

Todo se apoya en 4 pilares: contra la complejidad, acoplamiento y cohesión, aislar el cambio, y evolvabilidad.

---

## English

**Opus thinks, Haiku builds.** A strong model designs the architecture once and writes it down as an executable spec (`SPEC-TF`). A cheap model then builds it without making design decisions. The skill itself is written in Spanish; it answers in the language you use.

Install with the two commands above, then use `/taskforge:spec`, `/taskforge:construir` (build), `/taskforge:arreglar` (fix a bug), `/taskforge:revisar` (review) or `/taskforge:deuda` (debt ledger).

## Créditos

El modo Taller está inspirado en [ponytail](https://github.com/DietrichGebert/ponytail) de Dietrich Gebert (MIT).

## Licencia

MIT
