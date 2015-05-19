# CreateNugetPackagesFromAssemblies
Slightly improved original implementation, credits http://bzbetty.blogspot.cz/2013/09/automatically-create-nuget-packages-for.html and https://gist.github.com/bzbetty/6549585#file-createpackage-ps1.

## How to use it

Just run the script __! Run TFS.ps1__ in PowerShell and then enjoy created NuGet packages.

You can customize the script (create new) and use different filter (to create packages for different set of assemblies) or path (to create packages for assemblies not in GAC).

__Attention:__ For some assemblies it could matter if you run the script under x86 or x64 variant of PowerShell!
