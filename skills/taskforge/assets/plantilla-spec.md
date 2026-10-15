# Plantilla SPEC-TF

Instrucciones para el Arquitecto: copia la estructura de abajo, elimina los comentarios `<!-- -->` y entrega el resultado como archivo `SPEC-TF-[proyecto].md`. El encabezado `SPEC-TF` de la primera línea es obligatorio: es el marcador que activa el modo Constructor en el modelo que la reciba. Ninguna sección es opcional; si una no aplica, escribe "N/A + porqué" en vez de borrarla.

---

```markdown
SPEC-TF v1 — [Nombre del proyecto]

## 0. Metadatos
- Proyecto:
- Fecha:
- Stack: <!-- lenguaje, framework, BD, entorno. El Constructor no elige stack. -->
- Modelo destino: <!-- modelo por defecto del Constructor, ej. Claude Code con Haiku 5.5.
     El reparto por fase va en §6. -->
- Origen: <!-- conversación, prompt-architect .md, ticket, etc. -->

## 1. Contexto y objetivo
<!-- 3-6 líneas: quién lo usa, qué problema resuelve, qué existe hoy.
     Escrito para alguien que NO estuvo en la conversación. -->

## 2. Alcance y NO-alcance (presupuesto de complejidad)
### Dentro del alcance
- <!-- funcionalidades concretas de ESTA spec -->
### Fuera del alcance (prohibido construir)
- <!-- todo lo que suene tentador pero no se pide: autenticación, panel admin,
     configurabilidad extra, soporte multi-X, caching, "por si acaso". Sé exhaustivo:
     esta lista es la defensa principal contra la sobreingeniería del Constructor. -->

## 3. Decisiones de arquitectura (ADR-lite)
<!-- Solo decisiones relevantes, no obviedades. El porqué viaja con la spec para que
     nadie deshaga una decisión correcta por ignorancia. -->
| # | Decisión | Porqué | Alternativa descartada y por qué |
|---|---|---|---|
| 1 | | | |

## 4. Mapa de módulos
<!-- Por cada módulo/archivo principal. "Responsabilidad" = la única razón por la que
     cambiaría, idealmente ligada a un actor. "Esconde" = la complejidad que encapsula
     (módulos profundos, interfaces angostas). -->
### [nombre-del-modulo]
- Responsabilidad (una sola razón de cambio):
- Interfaz pública: <!-- firmas exactas: funciones/métodos con tipos -->
- Dependencias permitidas: <!-- lista cerrada; depender de algo fuera de esta lista es violación -->
- Esconde:

## 5. Contratos y tipos clave
<!-- Interfaces, modelos de datos, errores. Aquí se materializa "estados ilegales
     irrepresentables": define los tipos de modo que lo inválido no compile/valide.
     Incluye el contrato de errores: qué se lanza, qué se registra, qué ve el usuario. -->

## 6. Orden de construcción
<!-- Fases secuenciales. Cada fase termina en algo VERIFICABLE (corre, pasa un test,
     produce un output). El Constructor no adelanta fases.
     Columna Modelo: fases mecánicas (cableado, migraciones, boilerplate, tests derivados
     del contrato) → Haiku. Fases con lógica real (núcleo de negocio, contratos de §5) →
     Sonnet. Si dudas, Sonnet: una fase mal construida cuesta más que la diferencia de precio. -->
| Fase | Qué se construye | Modelo | Cómo se verifica al terminar |
|---|---|---|---|
| 1 | | | |

## 7. Criterios de aceptación
<!-- Comportamientos observables y testeables, no cualidades vagas.
     "Dado X, cuando Y, entonces Z". Esto es lo que el Constructor debe demostrar al final. -->
- [ ]

## 8. Anti-instrucciones (NO hacer)
<!-- Los modelos menores obedecen mejor un "NO hagas X" concreto que un principio
     abstracto. Incluye siempre las genéricas y agrega las específicas del proyecto. -->
- NO agregar dependencias/librerías fuera de las listadas en esta spec.
- NO crear capas, patrones o abstracciones no descritas en el mapa de módulos: ni interfaz de una sola
  implementación, ni factory de un solo producto, ni configuración para un valor fijo. Si parece
  hacer falta → TODO-ARQUITECTO, no se construye.
- NO usar herencia salvo donde la spec la indique.
- NO capturar excepciones sin relanzar o registrar con contexto.
- NO implementar nada de la lista "Fuera del alcance".
- <!-- específicas del proyecto -->

## 9. Escalación
Si una decisión no está cubierta por esta spec: NO improvises arquitectura.
- Decisión grande (afecta módulos, contratos o dependencias): detente y pregunta al usuario.
- Decisión menor (nombre interno, detalle local): resuélvela de la forma más simple,
  y márcala en el código como `// TODO-ARQUITECTO: [decisión + tu propuesta]`.
- Al reportar el trabajo terminado, lista todos los TODO-ARQUITECTO.
- Los TODO-ARQUITECTO los resuelve el Arquitecto, no un Constructor más capaz.
```

---

## Antes de entregar la spec (autoevaluación del Arquitecto)

- ¿Un junior competente podría construir esto sin hacerte ni una pregunta de diseño? Si dudarías en responder que sí, falta detalle en §4 o §5.
- ¿El NO-alcance (§2) es exhaustivo? Anticipa las "ayudas" típicas del Constructor y prohíbelas por escrito.
- ¿Cada decisión de §3 tiene porqué y alternativa descartada? Una decisión sin porqué será deshecha.
- ¿Las interfaces de §4 tienen firmas exactas con tipos, no descripciones vagas?
- ¿Cada fase de §6 termina en algo verificable por sí solo, y tiene modelo asignado?
- ¿Los criterios de §7 son comprobables sin interpretación?
- ¿La spec cabe en la cabeza? Si supera ~2 páginas por módulo o ~6 fases, divídela en varias SPEC-TF.
