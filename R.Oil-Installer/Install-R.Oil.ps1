$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "R.Oil-site"
$installPath = Join-Path $env:LOCALAPPDATA "Programs\ROil"
$sitePage = Join-Path $installPath "index.html"

if (-not (Test-Path -LiteralPath (Join-Path $source "index.html"))) {
    throw "Site files were not found next to the installer: $source"
}
if (-not (Test-Path -LiteralPath (Join-Path $source "clients.html"))) {
    throw "The client reminder page is missing from the installation package."
}

New-Item -ItemType Directory -Path $installPath -Force | Out-Null
Copy-Item -Path (Join-Path $source "*") -Destination $installPath -Recurse -Force

$desktopShortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "R.Oil.lnk"
$startMenu = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
$startShortcut = Join-Path $startMenu "R.Oil.lnk"
$shell = New-Object -ComObject WScript.Shell

foreach ($shortcutPath in @($desktopShortcut, $startShortcut)) {
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $sitePage
    $shortcut.WorkingDirectory = $installPath
    $shortcut.Description = "Сайт и клиентская база R.Oil"
    $shortcut.Save()
}

Write-Host "R.Oil was installed to: $installPath"
Write-Host "Shortcuts were created on the desktop and in the Start menu."
Start-Process -FilePath $sitePage
