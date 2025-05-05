#!/usr/bin/env pwsh
$ps_modules = @(
    "psreadline",
    "psscriptanalyzer"
)

if (-not (Get-PSRepository)) {
    Register-PSRepository -Default
    Write-Output "Registered default repo PSGallery"
}

foreach ($ps_module in $ps_modules) {
    if (-not (Get-Module -All -ListAvailable -Name $ps_module)) {
        Install-Module -Force -Name $ps_module
    }
}
