Write-Host 'In the build.ps1 script'
$manifestPath = '.\ProDsc.psd1'
$newModuleversion = $env:APPVEYOR_BUILD_VERSION
$buildFolder = $env:APPVEYOR_BUILD_FOLDER

try 
{
    $manifestContent = Get-Content $manifestPath -Raw
    [version]$version = [regex]::matches($manifestContent,"ModuleVersion\s=\s\'(?<version>(\d+\.)?(\d+\.)?(\*|\d+))") | ForEach-Object {$_.groups['version'].value}

    $replacements = @{
        "ModuleVersion = '.*'" = "ModuleVersion = '$newModuleversion'"            
    }

    $replacements.GetEnumerator() | ForEach-Object {
        $manifestContent = $manifestContent -replace $_.Key,$_.Value
    }
        
    $manifestContent | Set-Content -Path $manifestPath
}
catch
{
    Write-Error -Message $_.Exception.Message
    $host.SetShouldExit($LastExitCode)
}

