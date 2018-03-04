# This is where the module manifest lives
$manifestPath = '.\ProDsc.psd1'
$Manifest = Test-ModuleManifest $manifestPath


# Start by importing the manifest to determine the version, then add 1 to the revision
$manifest = Test-ModuleManifest -Path $manifestPath
[System.Version]$version = $manifest.Version
Write-Output "Old Version: $version"
[String]$newVersion = New-Object -TypeName System.Version -ArgumentList $env:appveyor_build_version
Write-Output "New Version: $newVersion"

# Update the manifest with the new version
Update-ModuleManifest -Path $manifestPath -ModuleVersion $newVersion -Verbose

# Publish the new version back to Master on GitHub
Try 
{
    $env:Path += ";$env:ProgramFiles\Git\cmd"
    Import-Module posh-git -ErrorAction Stop
    git checkout master
    git add --all
    git status
    git commit -s -m "Update version to $newVersion"
    git push origin master
    Write-Host "ProDsc Module version $newVersion published to GitHub." -ForegroundColor Cyan
}
Catch 
{
    # Sad panda; it broke
    Write-Warning "Publishing update $newVersion to GitHub failed."
    throw $_
}
