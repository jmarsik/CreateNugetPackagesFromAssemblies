$script = Join-Path $PSScriptRoot 'CreateNugetPackagesFromAssemblies.ps1'
& $script `
    -Path 'C:\Windows\Microsoft.NET\assembly\' `
    -NameStartsWith 'Microsoft.TeamFoundation.' `
    -TargetPath (Join-Path $PSScriptRoot 'NuGet TFS')
& $script `
    -Path 'C:\Windows\Microsoft.NET\assembly\' `
    -NameStartsWith 'Microsoft.VisualStudio.Services.' `
    -TargetPath (Join-Path $PSScriptRoot 'NuGet TFS')
