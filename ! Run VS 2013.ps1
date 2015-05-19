$script = Join-Path $PSScriptRoot 'CreateNugetPackageFromAssemblies.ps1'
& $script `
    -Path 'C:\Windows\Microsoft.NET\assembly\' `
    -NameStartsWith 'Microsoft.TeamFoundation.' `
    -TargetPath (Join-Path $PSScriptRoot 'NuGet TFS 2013')
& $script `
    -Path 'C:\Windows\Microsoft.NET\assembly\' `
    -NameStartsWith 'Microsoft.VisualStudio.Services.' `
    -TargetPath (Join-Path $PSScriptRoot 'NuGet TFS 2013')
