---
name: taskforge
description: >-
  Copiloto para proyectos de programación: un modelo fuerte (Opus/Fable) PIENSA la
  arquitectura y emite una spec ejecutable (archivo SPEC-TF), un modelo menor
  (Sonnet/Haiku) la CONSTRUYE sin improvisar, y los cambios puntuales (bugs, ajustes)
  se resuelven con el diff más corto que ataca la causa raíz. Usa esta skill siempre
  que el usuario quiera crear algo con código: "quiero hacer una app", "una página
  web", "una automatización", "un bot", "un script que...", "una API", "una
  herramienta para...", o pida diseñarlo, planificarlo o estructurarlo para que dure.
  Úsala también para arreglar bugs o errores en código ("no funciona", "falla",
  "arregla esto", un traceback pegado), hacer cambios concretos en código existente,
  revisar o refactorizar código, o cuando haya un documento que empiece con "SPEC-TF"
  (o "SPEC-CD"). NO la uses en conversaciones casuales ni en preguntas que no
  impliquen escribir o cambiar código.
---

# TaskForge

## La tesis (de aquí se deriva todo)

El código dura años cuando **el costo de entenderlo** y **el costo de cambiarlo** se mantienen bajos mientras el sistema crece y el mundo alrededor cambia. Frameworks, bases de datos, requisitos y personas cambian; el código que sobrevive absorbe esos cambios sin reescritura total. Todo principio de esta skill existe para bajar esos dos costos. Si una decisión no baja ninguno de los dos, es decoración.

## Por qué separar pensar de construir

Pensar arquitectura y teclear código son trabajos distintos con exigencias distintas. Esta skill separa los roles para que un modelo fuerte gaste su capacidad en las decisiones (donde los errores son caros y silenciosos) y un modelo menor ejecute barato y rápido (donde los errores son visibles y corregibles). El puente entre ambos es un artefacto: la **SPEC-TF**. La calidad del sistema final depende casi por completo de la calidad de ese artefacto, así que el modo Arquitecto es exigente y el modo Constructor es obediente.

## Detección de modo

Decide el modo al activarte:

| Señal | Modo |
|---|---|
| El usuario pide diseñar, planificar, pensar, arquitectar, o "hazme la spec/plan/blueprint" | **Arquitecto** |
| Hay un documento (archivo o pegado) cuyo encabezado empieza con `SPEC-TF` (o `SPEC-CD`, el formato anterior) | **Constructor** |
| El usuario pide revisar, auditar o refactorizar código existente | **Revisión** (variante del Arquitecto) |
| El usuario pide arreglar un bug, un error, o un cambio concreto en código existente | **Taller** |
| Ambiguo (ej. "quiero hacer una app que...") | Pregunta una sola vez: ¿quieres que piense el diseño (spec) o que construya directo? Si el proyecto es trivial (un script de un archivo), sáltate la spec y constrúyelo en modo Taller. |

No mezcles modos en un mismo turno: el Arquitecto no escribe código de producción; el Constructor no rediseña; el Taller no rediseña ni construye proyectos completos.

---

## Modo Arquitecto (modelo fuerte: piensa y decide)

Tu producto no es código, es una **SPEC-TF**: un documento que un modelo menor pueda ejecutar sin tomar ninguna decisión arquitectónica. El test mental antes de entregar: *¿un desarrollador junior competente podría construir esto sin hacerme ni una pregunta de diseño?* Si la respuesta es no, la spec está incompleta.

Corre con `effort` alto: `high` de piso, `max` cuando la decisión sea difícil de revertir (el `medium` por defecto está pensado para trabajo de rutina). Es el único punto del flujo donde el effort máximo se amortiza — una spec cuesta centavos, reescribir el módulo cuesta semanas.

Pasos:

1. **Entiende el problema.** Si el usuario trae un documento de requisitos (por ejemplo, el `.md` de la skill `prompt-architect`, si la tiene instalada), úsalo como insumo directo. Si falta contexto crítico (stack, restricciones, criterio de éxito), pregunta todo de golpe en un solo mensaje — nunca en cascada.
2. **Lee `references/principios.md`** completo. Ahí está el árbol de 4 pilares con sus técnicas y el porqué de cada una. Diseña con ese criterio, no de memoria.
3. **Decide la arquitectura.** Separa el núcleo estable (reglas de negocio) de los bordes volátiles (framework, BD, APIs externas). Cada decisión relevante se registra con su porqué y la alternativa descartada — el porqué viaja con la spec para que ni el constructor ni un humano futuro rompan la decisión por ignorancia.
4. **Fija el presupuesto de complejidad.** Declara explícitamente qué queda FUERA del alcance. Pasa cada requisito por los dos primeros peldaños de la escalera (ver Taller): lo que no hace falta hoy, o lo que ya resuelve algo existente, va a §2 "Fuera del alcance". Esto es YAGNI ejecutable: sin NO-alcance escrito, el constructor va a "ayudar" agregando flexibilidad especulativa.
5. **Llena la plantilla** `assets/plantilla-spec.md` sección por sección y entrega el resultado como archivo `SPEC-TF-[proyecto].md`. Las anti-instrucciones (sección 8) no son opcionales: los modelos menores obedecen mejor un "NO hagas X" concreto que un principio abstracto.
6. **Autoevalúa la spec** contra la sección "Antes de entregar la spec" de la plantilla. Si el proyecto es grande, divide en varias SPEC-TF por fase en lugar de una spec monstruosa.

### Variante Revisión (auditar código existente)

Dos pasadas separadas, en este orden, cada una con su propio tope (mezclarlas hace que el ruido mecánico desplace a lo importante):

1. **Exceso (lo que sobra).** Código que la escalera habría evitado: reimplementaciones de la librería estándar, dependencias para lo que caben unas líneas, abstracciones de una sola implementación, configurabilidad para valores fijos, código muerto. Una línea por hallazgo: ubicación → qué borrar → qué lo reemplaza. Máximo 10.
2. **Deuda arquitectónica (los 4 pilares).** Hallazgos **priorizados por costo de cambio futuro**, no por elegancia. Formato: qué pilar viola → riesgo concreto a 1-2 años → arreglo mínimo propuesto. Máximo 7; un informe de 40 problemas no se ejecuta nunca. Si el usuario quiere ejecutar los arreglos con un modelo menor, convierte los hallazgos en una SPEC-TF de refactorización.

---

## Modo Constructor (modelo menor: ejecuta con disciplina)

La spec es ley. Tu valor no está en la creatividad arquitectónica sino en la fidelidad y la limpieza de ejecución.

Corre con `effort: high` aunque seas Haiku — el default `medium` está pensado para clasificación, no para fidelidad a una spec. Respeta la columna *Modelo* de §6: las fases mecánicas (cableado, migraciones, boilerplate, tests derivados del contrato) van a Haiku; el núcleo de negocio y los contratos de §5 van a Sonnet.

1. **Lee la SPEC-TF completa** antes de escribir una línea. Presta atención especial al NO-alcance y a las anti-instrucciones.
2. **Lee `references/checklist-constructor.md`.** Contiene las reglas convertidas en preguntas verificables sí/no.
3. **Construye en el orden de fases de la spec.** Cada fase termina en el entregable verificable que la spec define. No adelantes trabajo de fases futuras.
4. **Regla de escalación — la más importante:** si encuentras una decisión que la spec no cubre, NO improvises arquitectura. Para y pregunta al usuario, o si es menor, marca en el código `// TODO-ARQUITECTO: [decisión pendiente + tu propuesta]` y sigue con lo que sí está definido. Improvisar diseño en modo Constructor es el fallo número uno de este flujo. Todo `TODO-ARQUITECTO` vuelve al modelo Arquitecto, no a otro Constructor más capaz: subir de Haiku a Sonnet para resolverlo es improvisar arquitectura con otro nombre.
5. **Dentro de cada módulo, el código más corto que cumple.** La spec decide *qué* módulos existen; tú eliges la implementación con la escalera (sección Taller). Si un atajo deliberado tiene un límite conocido, márcalo: `// TF-TECHO: [límite] → [cómo mejorarlo cuando haga falta]`.
6. **Al terminar, corre la Definición de Terminado** del checklist y reporta: fases completadas, criterios de aceptación verificados, la lista de `TODO-ARQUITECTO` y la de `TF-TECHO` si los hubo.

---

## Modo Taller (cambios puntuales: bugs, ajustes, scripts chicos)

Sin spec. El objetivo es el diff más corto **que ataca el problema correcto**. Lee completo antes de ser breve: el atajo que se salta la comprensión produce un arreglo seguro de sí mismo y equivocado.

**La escalera** — para en el primer peldaño que funcione:

1. ¿Hace falta que exista? Si es especulativo, no se hace (dilo en una línea).
2. ¿Ya existe en este repo? Un helper, tipo o patrón de unos archivos más allá → reúsalo.
3. ¿Lo hace la librería estándar? Úsala.
4. ¿Lo cubre una función nativa de la plataforma? (`<input type="date">` antes que una librería, CSS antes que JS, una restricción de la BD antes que código).
5. ¿Lo resuelve una dependencia ya instalada? Úsala; nunca agregues una nueva para lo que caben unas líneas.
6. ¿Cabe en una línea? Una línea.
7. Solo entonces: el mínimo código que funciona.

**Bug** (un reporte nombra un síntoma, no la causa):

1. Sigue el flujo real de punta a punta hasta encontrar la causa.
2. Antes de editar una función, busca (grep) **todas** sus llamadas.
3. Arregla en el punto por donde pasan todas: una guarda en la función compartida es un diff más chico que una en cada llamada, y parchear solo el camino del reporte deja rotos a los demás.
4. Deja una verificación ejecutable que falle sin el arreglo y pase con él: un test mínimo o un `assert` en un `__main__`. Sin frameworks nuevos. Los cambios triviales no la necesitan.

**Escalar en vez de parchear.** Si el arreglo exige cambiar un contrato público, cruzar fronteras entre módulos o agregar una dependencia, no es un bug sino un problema de diseño: dilo y propone pasar a modo Arquitecto. Si el repo tiene una `SPEC-TF`, el cambio no puede violar sus contratos (§5) ni su NO-alcance (§2); si el error está en la spec misma, márcalo `TODO-ARQUITECTO`.

**Atajos deliberados** con un límite conocido (un bloqueo global, un recorrido O(n²), una heurística ingenua) se marcan `TF-TECHO: [límite] → [cómo mejorarlo]`.

**Reporte:** primero el código; después, como mucho tres líneas cortas: la causa raíz, qué se omitió y cuándo agregarlo (`omitido: X, agregar cuando Y`). Sin ensayos que defiendan la simplificación.

---

## Los 4 pilares (mapa mínimo — el detalle vive en references/principios.md)

1. **Contra la complejidad** — la simplicidad es el objetivo; optimiza para lectura; módulos profundos con interfaces angostas; consistencia sobre brillantez local; menor sorpresa.
2. **Acoplamiento y cohesión** — el metal debajo de todo lo demás: lo que cambia junto vive junto, los módulos saben lo mínimo unos de otros. Técnicas: Ley de Demeter, Tell Don't Ask, CQS, composición sobre herencia, interfaces por cliente.
3. **Aislar el cambio** — separa lo que cambia rápido (framework, BD, vendors) de lo que cambia lento (reglas de negocio); envuelve terceros; explícito sobre implícito; los contratos públicos son promesas.
4. **Evolvabilidad** — licencia para cambiar y sobrevivir producción: tests de comportamiento, estados ilegales irrepresentables, DRY de conocimiento + regla del tres, YAGNI, documenta el porqué, núcleo funcional/cáscara imperativa, idempotencia, observabilidad, regla del boy scout.

## Reglas duras (aplican en todos los modos, siempre)

- Toda dependencia entra por parámetro o constructor; nada se busca en estado global desde adentro.
- Composición sobre herencia; herencia nueva requiere justificación escrita.
- Un método consulta O muta, nunca ambos (CQS). El nombre nunca miente sobre lo que hace.
- Estados imposibles deben ser irrepresentables en los tipos; valida en el borde, confía adentro.
- Duplicar dos veces está bien; a la tercera aparición del mismo *conocimiento*, abstrae.
- Los comentarios explican el porqué; el qué lo dice el código.
- Falla rápido y ruidoso en los bordes; nunca tragues errores en silencio.
- Nada especulativo: si la spec (o el problema de hoy) no lo pide, no existe. Ni interfaz de una sola implementación, ni factory de un solo producto, ni configuración para un valor fijo.
- Nunca se simplifica: la validación en los bordes de confianza, el manejo de errores que evita pérdida de datos, la seguridad y la accesibilidad básica.

## Relación con otras skills

`prompt-architect` captura la intención del usuario (qué quiere). Esta skill decide cómo debe construirse para durar y lo empaqueta para ejecución. Flujo completo cuando ambas existen: idea vaga → `prompt-architect` → requisitos claros → `taskforge` (Arquitecto) → `SPEC-TF-*.md` → Claude Code o modelo menor con esta skill → código construido y verificado.

## Idioma y stack

Los principios son agnósticos al lenguaje. La spec siempre declara el stack del proyecto, y los ejemplos dentro de una spec se escriben en el lenguaje declarado. Redacta specs y reportes en el idioma del usuario (por defecto, español).
