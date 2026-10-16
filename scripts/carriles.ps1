# Abre Windows Terminal con un panel para el Arquitecto (Opus) y uno por carril de §6
# de una SPEC-TF, cada uno con su modelo y su prompt inicial.
# Uso (desde la carpeta del proyecto): carriles.ps1 SPEC-TF-x.md [-Ver]
param(
    [Parameter(Mandatory)][string]$Spec,
    [string]$Carril,   # interno: rol de un panel hijo
    [string]$Modelo,   # interno
    [switch]$Ver       # muestra el comando de wt sin abrir nada
)
$Spec = (Resolve-Path $Spec).Path

if ($Carril) {
    $prompt = if ($Carril -eq 'ARQ') {
        "Usa la skill taskforge. Eres el Arquitecto de $Spec : no construyes; resuelves los TODO-ARQUITECTO que te traigan los carriles. " +
        "Primero ejecuta ListAgents y escribe solo tu nombre de sesion en el archivo .tf-arquitecto de esta carpeta. " +
        "Cuando un Constructor te pregunte por SendMessage, decide, actualiza la spec si la decision cambia un contrato, y respondele por SendMessage a su nombre."
    } else {
        "Usa la skill taskforge en modo Constructor con $Spec. Construye SOLO el carril $Carril y escribe solo en sus Archivos propios de la seccion 6. " +
        "Ante un TODO-ARQUITECTO: lee el nombre de sesion en .tf-arquitecto, enviale la pregunta con SendMessage (incluye tu carril y tu nombre de sesion, que ves con ListAgents) " +
        "y no construyas esa parte hasta recibir su respuesta; mientras, sigue con lo que la spec si define."
    }
    claude --dangerously-skip-permissions --model $Modelo $prompt
    return
}

# Filas de la tabla de §6: | Fase | Carril | Qué | Modelo | Archivos propios | Verificación |
$en6 = $false
$filas = foreach ($l in Get-Content $Spec -Encoding utf8) {
    if ($l -match '^## ') { $en6 = $l -match '^## 6\.'; continue }
    if ($en6 -and $l -match '^\|\s*\d+\s*\|') {
        $c = $l.Split('|')
        [pscustomobject]@{ Carril = $c[2].Trim(); Modelo = $c[4].Trim() }
    }
}
$carriles = $filas | Where-Object { $_.Carril -notin '', '—', '-' } | Group-Object Carril
if (-not $carriles) { throw "La seccion 6 de $Spec no tiene carriles paralelos: construye en una sola sesion." }

$dir = (Get-Location).Path
$panel = { param($c, $m) "pwsh -NoExit -File `"$PSCommandPath`" -Spec `"$Spec`" -Carril $c -Modelo $m" }
$wt = @("-d `"$dir`" " + (& $panel 'ARQ' 'opus'))
foreach ($g in $carriles) {
    # Haiku solo si todas las fases del carril lo piden; si dudas, Sonnet (plantilla §6).
    $m = if (@($g.Group | Where-Object Modelo -notmatch 'haiku').Count -eq 0) { 'haiku' } else { 'sonnet' }
    $wt += "sp -d `"$dir`" " + (& $panel $g.Name $m)
}
$args_wt = $wt -join ' ; '
# El nombre de un Arquitecto de una corrida anterior apuntaría a una sesión muerta.
if ($Ver) { $args_wt } else { Remove-Item .tf-arquitecto -ErrorAction Ignore; Start-Process wt $args_wt }
