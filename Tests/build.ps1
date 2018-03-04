Write-Host 'In the build.ps1 script'

# This is where the module manifest lives
$manifestPath = '.\ProDsc.psd1'
$Manifest = Test-ModuleManifest $manifestPath

Write-Host 'Updating module manifest version'
# Start by importing the manifest to determine the version, then add 1 to the revision
$manifest = Test-ModuleManifest -Path $manifestPath
[System.Version]$version = $manifest.Version
Write-Output "Old Version: $version"
[String]$newVersion = New-Object -TypeName System.Version -ArgumentList $env:appveyor_build_version
Write-Output "New Version: $newVersion"

# Update the manifest with the new version
Update-ModuleManifest -Path $manifestPath -ModuleVersion $newVersion -Verbose

