# Checklist del Constructor

Los principios del Arquitecto, convertidos en preguntas sí/no que se pueden verificar mirando el código. Úsalo en dos momentos: como guía mientras escribes, y como auditoría al cerrar cada fase. La respuesta correcta a cada pregunta está indicada; cualquier desviación se corrige antes de avanzar o se justifica en el reporte final.

## Antes de escribir la primera línea

- ¿Leíste la SPEC-TF completa, incluidas anti-instrucciones (§8) y NO-alcance (§2)? → debe ser sí
- ¿Sabes exactamente qué entregable verificable cierra la fase actual (§6)? → debe ser sí
- ¿Estás por usar una librería que no está en la spec? → debe ser no (escala si crees necesitarla)

## Antes de escribir cada pieza

- ¿Recorriste la escalera (SKILL.md, modo Taller) y paraste en el primer peldaño que funciona? → sí
- ¿Buscaste en el repo un helper, tipo o patrón que ya haga esto? → sí
- ¿El atajo que tomaste tiene un límite conocido? → si sí, márcalo `TF-TECHO: [límite] → [cómo mejorarlo]`

## Durante la construcción (auditar al cerrar cada fase)

**Dependencias y acoplamiento**
- ¿Cada dependencia externa entra por parámetro o constructor, visible en la firma? → sí
- ¿Algo se obtiene desde estado global, singleton o variable de módulo desde adentro de la lógica? → no
- ¿Hay cadenas de navegación tipo `a.getB().getC().hazAlgo()`? → no (rompe la cadena: pide al colaborador directo)
- ¿Algún módulo depende de algo fuera de su lista de "dependencias permitidas" (§4)? → no

**Interfaces y comportamiento**
- ¿Existe algún método que consulta Y muta a la vez? → no (sepáralo en dos)
- ¿Algún nombre miente u omite lo que la función realmente hace (efectos ocultos)? → no
- ¿Creaste herencia nueva? → no, salvo que la spec la indique (si crees que hace falta: TODO-ARQUITECTO)

**Datos y estados**
- ¿Hay combinaciones de datos inválidas que los tipos permiten representar? → minimízalas (tipos antes que validaciones repetidas)
- ¿Se valida en el borde (entrada al sistema) y se confía adentro? → sí
- ¿Hay primitivos desnudos donde la spec definió un tipo (§5)? → no

**Errores y efectos**
- ¿Alguna excepción se captura y se traga en silencio? → no (relanza o registra con contexto)
- ¿Los efectos secundarios (BD, red, archivos, reloj) están en el borde y no mezclados dentro de la lógica pura? → sí
- ¿Los mensajes de error dirían algo útil a alguien depurando a las 2 a.m.? → sí

**Alcance y duplicación**
- ¿Construiste algo "por si acaso" que la spec no pide? → no (bórralo, aunque duela)
- ¿Copiaste el mismo conocimiento por tercera vez? → si sí, abstrae ahora; si es la segunda, déjalo duplicado
- ¿Tocaste código fuera del alcance de la spec? → no (Boy Scout solo dentro del alcance)

**Comentarios**
- ¿Los comentarios explican el porqué (restricción, trade-off) y no narran el qué? → sí

## Definición de Terminado (al final de todo)

1. Todas las fases de §6 completadas, cada una con su verificación cumplida.
2. Todos los criterios de aceptación de §7 demostrados (ejecutados, no supuestos).
3. Checklist de arriba auditado en la versión final; desviaciones corregidas o justificadas.
4. Cero elementos del NO-alcance implementados.
5. Reporte final al usuario con: resumen por fase, resultado de cada criterio de aceptación, lista completa de `TODO-ARQUITECTO` y de `TF-TECHO` (si hubo), y cualquier desviación justificada.

Si algún punto no se cumple, el trabajo no está terminado: está pendiente o está escalado. Decir cuál de los dos es parte del reporte.
