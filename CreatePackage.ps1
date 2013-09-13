#requires -version 2.0
param (
    [parameter(Mandatory=$true)]
    [string]
    $Path
)

$tool= "e:\tools\NuGet.exe"
$files = Get-ChildItem -Path $Path -Filter Microsoft.TeamFoundation.*.dll -recurse

if($files.length -lt 1)
{
	Exit 0
}

foreach ($assembly in $files)
{		
	#If the NuSpec file has the same name as an assembly, perform some basic search/replace on tokens	
	$nuspecFile = $assembly -creplace '.dll', '.nuspec' 

    $versionInfo = (dir $assembly.FullName).VersionInfo

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

    $references = [System.Reflection.Assembly]::LoadFrom($assembly.FullName).GetReferencedAssemblies() 
    foreach ($reference in $references )
    {
        if($reference.Name.StartsWith("Microsoft.TeamFoundation")) {
            $nuspec += "<dependency id=""$($reference.Name)"" version=""($($reference.Version.ToString()),)"" />"
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
    $cmd = "$tool pack ""$($nuspecFile)"" "
    Invoke-Expression $cmd
    Remove-Item $nuspecFile

}
