#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$configName = if ($env:SYNCZ_CONFIG_NAME) { $env:SYNCZ_CONFIG_NAME } else { "syncz.yml" }
$dir = (Get-Location).ProviderPath

while ($true) {
    if (Test-Path -LiteralPath (Join-Path $dir $configName) -PathType Leaf) {
        Push-Location -LiteralPath $dir
        try {
            & syncz @args
            exit $LASTEXITCODE
        }
        finally {
            Pop-Location
        }
    }

    $parent = Split-Path -Parent $dir
    if ([string]::IsNullOrEmpty($parent) -or $parent -eq $dir) {
        break
    }

    $dir = $parent
}

Write-Error "syncz wrapper: $configName not found in current directory or any parent directory"
exit 1
