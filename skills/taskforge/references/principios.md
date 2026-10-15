# Principios del código duradero

Referencia completa para el modo Arquitecto. La estructura es un árbol: cuatro pilares, y cada técnica cuelga de un pilar. Enseña a derivar, no a memorizar: ante una decisión de diseño no cubierta aquí, vuelve a la tesis y a los pilares.

**La tesis:** el código dura años cuando el costo de entenderlo y el costo de cambiarlo se mantienen bajos mientras el sistema crece y el mundo cambia. Frameworks, bases de datos, requisitos y personas cambian; sobrevive el código que absorbe esos cambios sin reescritura.

---

## Pilar 1 — Contra la complejidad

La complejidad es el enemigo raíz. Distingue la **esencial** (la del problema real, no se puede eliminar) de la **accidental** (la que nosotros agregamos con herramientas, capas y astucia). La accidental mata más código que la esencial.

- **La solución aburrida y obvia casi siempre gana.** La astucia es deuda: cada truco ingenioso es un peaje que todo lector futuro paga.
- **Optimiza para lectura, no para escritura.** El código se lee muchas más veces de las que se escribe; el lector es el cliente. Nombres que dicen la verdad, funciones con un trabajo evidente, flujo que se sigue de arriba a abajo.
- **Módulos profundos, interfaces angostas** (Ousterhout). Un buen módulo esconde mucha complejidad detrás de una superficie pequeña. Esto corrige el reflejo de "funciones diminutas por todos lados", que fragmenta la lógica y la esparce: muchas funciones triviales con interfaces anchas son complejidad, no limpieza.
- **Consistencia sobre optimización local.** Un código predecible le gana a uno lleno de soluciones individualmente brillantes pero todas distintas. Se navega por patrón: resuelto una vez, resuelto igual en todos lados.
- **Principio de la menor sorpresa.** El código, las APIs y los nombres se comportan como el lector espera. Una función `getUser` que además escribe en la BD es una traición. Es el principio más barato de cumplir y más caro de violar.

## Pilar 2 — Acoplamiento y cohesión

El metal debajo de casi todo lo demás; SOLID y media literatura de diseño son casos particulares de esto. Dos métricas mentales:

- **Cohesión (alta):** lo que cambia junto, vive junto. Un módulo cohesivo tiene una sola razón para cambiar.
- **Acoplamiento (bajo):** los módulos saben lo mínimo unos de otros. Pregunta clave ante cualquier línea: *¿cuántas cosas tienen que seguir siendo verdad en OTROS módulos para que esta línea funcione?*

Técnicas concretas:

- **Ley de Demeter ("no hables con extraños").** No encadenes `a.getB().getC().hazAlgo()`: cada eslabón es una dependencia oculta que se rompe cuando el del medio cambia. Habla solo con tus colaboradores directos.
- **Tell, Don't Ask.** No le saques datos a un objeto para decidir por él; dile qué hacer y que él decida con sus propios datos. Extraer-decidir-devolver esparce la lógica de un concepto por todo el sistema.
- **Command-Query Separation (CQS).** Un método cambia estado O responde una pregunta, nunca ambos. Hace el código predecible y los tests triviales. (Semilla conceptual de CQRS, útil más adelante en el mundo de datos.)
- **Composición sobre herencia.** La herencia es el acoplamiento más fuerte que existe y es para siempre; la composición se recombina. Herencia solo ante una relación es-un genuina y estable, y aun así con sospecha.
- **Interfaces angostas por cliente** (ISP). Varias interfaces pequeñas específicas para quien las consume, en vez de una interfaz gorda que obliga a implementar métodos que no se usan.

## Pilar 3 — Aislar el cambio

El pilar central de la longevidad: es lo que permite cambiar de ORM, de base de datos o de framework sin tocar el corazón del sistema.

- **Separa lo que cambia rápido de lo que cambia lento.** Las reglas de negocio cambian lento; el framework, la BD, la UI y las APIs externas cambian rápido. El núcleo de dominio no depende de los bordes volátiles: los bordes dependen del núcleo, a través de abstracciones que el núcleo define (puertos y adaptadores / inversión de dependencias). La dirección de las dependencias siempre apunta hacia lo estable.
- **Envuelve las dependencias de terceros** (anti-corruption layer). Ninguna librería de vendor se usa directamente desde el dominio; se accede a través de una envoltura propia. Cuando el vendor cambie su API, se toca un archivo, no cuarenta.
- **Explícito sobre implícito.** Nada de estado global oculto, singletons mágicos ni efectos secundarios sorpresa. Las dependencias entran por parámetro o constructor, visibles en la firma. Lo implícito se siente productivo el día 1 y es una pesadilla el año 2, porque el costo de entender explota.
- **Los contratos públicos son promesas.** Una API publicada (endpoint, interfaz de librería, esquema de eventos) no se rompe silenciosamente: se versiona (semver como disciplina mínima) y se depreca con aviso. Romper contratos ajenos es la forma más rápida de lograr que *otro* código deje de durar.

## Pilar 4 — Evolvabilidad

La licencia para cambiar el código sin miedo, y para que sobreviva años en producción con gente que no estuvo en su creación.

- **Tests como permiso para tocar.** El código sin pruebas se osifica: nadie se atreve a modificarlo, así que se pudre o se reescribe. Pero prueba **comportamiento, no implementación** — tests acoplados a detalles internos son un ancla que castiga cada refactor y enseñan a no refactorizar.
- **Haz los estados ilegales irrepresentables.** Usa el sistema de tipos: evita la obsesión por primitivos (un `EmailAddress`, no un `string`), modela estados con tipos que no permiten combinaciones inválidas, valida en el borde y confía adentro. El compilador es un mantenedor que nunca duerme.
- **DRY es sobre conocimiento, no sobre texto.** Dos trozos de código parecidos que cambian por razones distintas deben quedar separados; unificarlos crea un acople falso. **Regla del tres:** tolera la duplicación hasta la tercera aparición del mismo conocimiento; la abstracción prematura ha matado más bases de código que la duplicación.
- **YAGNI / presupuesto de complejidad.** Resuelve el problema de hoy, limpio. La generalidad especulativa (flexibilidad para futuros que nunca llegan) es el espejo del subdiseño. Deja costuras claras donde el cambio es *probable*, no andamios para lo imaginario. En una SPEC-TF esto se materializa como la sección de NO-alcance.
- **Documenta el porqué, no el qué.** El código ya dice qué hace. Los comentarios y los ADR (registros de decisión) capturan la restricción, el trade-off, la alternativa descartada. El "qué" se pudre; el "porqué" es irremplazable y es lo que impide que el mantenedor del futuro deshaga una decisión correcta por ignorancia.
- **Inmutabilidad por defecto + núcleo funcional, cáscara imperativa.** Datos inmutables y funciones puras en el centro (fáciles de razonar y de testear sin mocks); los efectos secundarios — BD, red, archivos, reloj — empujados al borde del sistema. Es también la arquitectura natural de los pipelines de datos reproducibles.
- **Idempotencia y diseño para el reintento.** En cualquier sistema distribuido (APIs, colas, jobs, pipelines) las cosas se ejecutan dos veces. El código duradero asume el reintento en vez de romperse con él: operaciones repetibles sin daño, claves de idempotencia donde toque.
- **Observabilidad y fallo ruidoso.** Alguien que no estuvo ahí va a depurar esto a las 2 a.m.: logging estructurado con contexto, errores con significado, fallar rápido y visible en los bordes. Un error tragado en silencio es una bomba con temporizador.
- **Regla del Boy Scout.** Deja el código un poco mejor de como lo encontraste. La longevidad no es un rediseño heroico; es mantenimiento contra la entropía en cada commit. (En modo Constructor: solo dentro del alcance de la spec.)

---

## Apéndice A — SOLID, traducido

SOLID no es un nivel aparte: es vocabulario para casos particulares de los pilares. Si el usuario o el código lo invocan, tradúcelo así:

| Letra | Lectura correcta | Veredicto |
|---|---|---|
| **S** — Single Responsibility | No "una función hace una cosa": *un módulo tiene una sola razón para cambiar*, y la razón la define **quién** pide el cambio (un actor). Dos actores que pueden forzar cambios en la misma clase = dos responsabilidades. | Es Pilar 2 (cohesión) bien dicho. Úsalo con la formulación del actor. |
| **O** — Open/Closed | La versión original (jerarquías para extender sin modificar) envejeció mal: produce puntos de extensión especulativos que chocan con YAGNI. Versión útil: *deja costuras donde el cambio es probable, no en todas partes*. | Úsalo solo reformulado; desconfía de quien lo cite en su forma clásica. |
| **L** — Liskov Substitution | Un subtipo debe poder sustituir al base sin romper expectativas. Correcto y profundo, pero su lección práctica moderna es *composición sobre herencia*: sin jerarquías profundas, Liskov casi no aparece. | Consecuencia del Pilar 2, no regla de portada. |
| **I** — Interface Segregation | Interfaces angostas y específicas por cliente. Subestimado; envejeció bien. | Ya está en Pilar 2. |
| **D** — Dependency Inversion | El dominio no depende de los bordes; depende de abstracciones que él mismo define. | Es el corazón del Pilar 3. Núcleo, no extra. |

## Apéndice B — Descartados a propósito

Para que la skill no se infle (la sobreingeniería también aplica a las skills):

- **Ley de Postel** ("sé liberal en lo que aceptas"): envejeció mal; hoy se la asocia con fragilidad y agujeros de seguridad. Preferir: estricto en ambos lados del contrato.
- **KISS, "make it work / right / fast" y slogans similares:** correctos pero ya cubiertos con más precisión por los pilares. Mencionar de pasada si el usuario los trae; no son secciones.
- **Connascence:** vocabulario más fino que acoplamiento/cohesión, pero demasiado académico para uso diario. Nota al pie como máximo.
- **Seguridad y versionado de APIs en profundidad:** importantísimos, pero son casi una skill propia. Aquí solo vive el principio "los contratos públicos son promesas" (Pilar 3).
