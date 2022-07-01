# CreateNugetPackagesFromAssemblies

Slightly improved original implementation, credits:

* http://bzbetty.blogspot.cz/2013/09/automatically-create-nuget-packages-for.html
* https://gist.github.com/bzbetty/6549585#file-createpackage-ps1

## Create packages

`NuGet.exe` must be on your `PATH`. You can install it by running `choco install NuGet.CommandLine`.

To create NuGet packages from assemblies in a folder with filenames starting with a given prefix run this:

```powershell
& .\CreateNugetPackagesFromAssemblies.ps1 `
    -Path 'C:\PathToFolderWithAssemblies\' `
    -NameStartsWith 'FileNamePrefix' `
    -TargetPath 'C:\PathToFolderWithNuGetPackages\'
```

It will go through the assemblies and create NuGet packages:

* NuGet dependencies will be inferred from assembly references
* package version and other metadata will be extracted from assembly metadata
* does not handle target framework(s) in any way

__Attention:__ For some assemblies it could matter if you run the script under x86 or x64 variant of PowerShell!

## Push to NuGet feed

When you are done with the packages, you can push them to a NuGet feed (provided that you have it added as a source in NuGet configuration):

```powershell
nuget.exe push -Source "YourFeed" -ApiKey AzureDevOps package.nupkg
```

You can use wildcards in the package specification.
