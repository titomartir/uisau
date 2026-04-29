param(
    [string]$DbHost = "localhost",
    [string]$DbPort = "5432",
    [string]$Username = "postgres",
    [string]$Password = "postgres",
    [string]$Database = "encuesta_satisfaccion",
    [string]$OutputFolder = "$PSScriptRoot"
)

$pgDump = "C:\Program Files\PostgreSQL\18\bin\pg_dump.exe"

if (-not (Test-Path $pgDump)) {
    Write-Host "No se encontro pg_dump en: $pgDump" -ForegroundColor Red
    Write-Host "Instala PostgreSQL o corrige la ruta dentro de este script." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$backupFile = Join-Path $OutputFolder "$Database-pgadmin-$timestamp.backup"

Write-Host "Creando respaldo para pgAdmin..." -ForegroundColor Cyan
Write-Host "Base de datos: $Database" -ForegroundColor Yellow
Write-Host "Archivo: $backupFile" -ForegroundColor Yellow

$env:PGPASSWORD = $Password

try {
    & $pgDump `
        --host=$DbHost `
        --port=$DbPort `
        --username=$Username `
        --format=custom `
        --blobs `
        --verbose `
        --no-owner `
        --no-privileges `
        --file="$backupFile" `
        $Database

    if ($LASTEXITCODE -ne 0) {
        throw "pg_dump finalizo con codigo $LASTEXITCODE"
    }

    $backupInfo = Get-Item $backupFile
    Write-Host "Respaldo creado correctamente." -ForegroundColor Green
    Write-Host "Tamano: $([Math]::Round($backupInfo.Length / 1KB, 2)) KB" -ForegroundColor Green
}
finally {
    Remove-Item env:PGPASSWORD -ErrorAction SilentlyContinue
}