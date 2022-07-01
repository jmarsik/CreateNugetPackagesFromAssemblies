#requires -version 2.0
param(
    [string]
    $Path = '.\',

    [string]
    $NameStartsWith = '',

    [string]
    $TargetPath = '.\'
)

# should be in PATH, one can install it for example by using Chocolatey command "choco install NuGet.CommandLine"
$tool = 'NuGet.exe'
$files = Get-ChildItem -Path $Path -Filter ($NameStartsWith + "*.dll") -recurse

if($files.length -lt 1)
{
    Exit 0
}

New-Item -Path $TargetPath -ItemType Directory -Force

foreach ($assembly in $files)
{
    # if the NuSpec file has the same name as an assembly, perform some basic search/replace on tokens
    $nuspecFile = $assembly -creplace '.dll', '.nuspec'
    $nuspecFile = Join-Path $TargetPath $nuspecFile

    $versionInfo = (Get-ChildItem $assembly.FullName).VersionInfo

$nuspec = @"
<?xml version="1.0" encoding="utf-8"?>
<package>
    <metadata>
        <id>$($assembly -creplace '.dll', '')</id>
        <version>$($versionInfo.ProductVersion)</version>
        <authors>$(($versionInfo.CompanyName, 'Microsoft', 1 -ne '')[0])</authors>
        <owners>$($versionInfo.CompanyName)</owners>
        <description>$(($versionInfo.Comments, $versionInfo.FileDescription, 1 -ne '')[0])</description>
        <language>en-US</language>
        <requireLicenseAcceptance>false</requireLicenseAcceptance>
        <dependencies>
"@

    Write-Host $assembly.FullName
    $references = [System.Reflection.Assembly]::LoadFrom($assembly.FullName).GetReferencedAssemblies()
    foreach ($reference in $references)
    {
        if ($reference.Name.StartsWith($NameStartsWith)) {
            Write-Host $reference.FullName
            Write-Host $reference.Name
            # it would be probably better to determine exact ProductVersion of the referenced assembly file and use that in [version,) specification
            # because this ProductVersion is then used as a version of the NuGet package and those dependencies are also meant as NuGet packages)
            $nuspec += [System.Environment]::NewLine + "            <dependency id=""$($reference.Name)"" version=""[$($reference.Version.ToString()),)"" />"
        }
    }

$nuspec += @"

        </dependencies>
    </metadata>
    <files>
        <file src="$($assembly.FullName)" target="lib" />
    </files>
</package>
"@

    $nuspec | Set-Content $nuspecFile
    $cmd = "$tool pack ""$($nuspecFile)"" -OutputDirectory ""$($TargetPath)"""
    Invoke-Expression $cmd
    Remove-Item $nuspecFile
}
