$Source = "\\dc\Disrtib\AD\AIS"
$Destination = "C:\ProgramData\AIS"
$SourceLink = Join-Path $Source "AIS.lnk"
$PublicDesktop = "C:\Users\Public\Desktop"
$UpdateFile = Join-Path $Destination "update.txt"
$TargetDate = "20250909"

# Флаг необходимости обновления
$needRecreate = $true

if (Test-Path $UpdateFile) {
    $fileDate = Get-Content $UpdateFile -ErrorAction SilentlyContinue
    if ($fileDate -eq $TargetDate) {
        Write-Host "Все обновлено. Действий не требуется." -ForegroundColor Green
        $needRecreate = $false
    }
}

if ($needRecreate) {
    Write-Host "Обнаружено устаревшее или отсутствующее обновление. Начинаем процесс..." -ForegroundColor Yellow

    # Удаляем папку если есть
    if (Test-Path $Destination) {
        Remove-Item $Destination -Recurse -Force -ErrorAction SilentlyContinue
    }
    # Создаем заново
    New-Item -ItemType Directory -Path $Destination | Out-Null

    # Копируем файлы
    Copy-Item -Path "$Source\*" -Destination $Destination -Recurse -Force -Container -Verbose

    # Создаем update.txt с целевой датой
    $TargetDate | Out-File -FilePath $UpdateFile -Encoding ASCII -Force

    # Копируем ярлык на рабочий стол
    if (Test-Path $SourceLink) {
        Copy-Item -Path $SourceLink -Destination $PublicDesktop -Force
    }

    Write-Host "Обновление завершено." -ForegroundColor Green
}
