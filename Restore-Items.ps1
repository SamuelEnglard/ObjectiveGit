function Restore-Items
{
	<#
		.Synopsis
		Restore working tree files

		.Description
		Updates files in the working tree to match the version in the specified tree.

		.Parameter Repository
		Path to the git repository. Can be relative or absolute. If not specified defaults to the current directory

		.Parameter Files
		Working files to restore.

		.Parameter Force
		When checking out paths from the index, do not fail upon unmerged entries; instead, unmerged entries are ignored.

		.Link
		https://git-scm.com/docs/git-checkout
	#>
	param(
		[Parameter(Mandatory=$False,Position=1,ValueFromPipeline=$True)]
		[string]$Repository = ".\",
		[Parameter(Mandatory=$True)]
		[string[]]$Files,
		[Alias("f")]
		[switch]$Force = $False
	)
	process
	{
		$Repository = Resolve-Path -Path $Repository
		Write-Verbose -Message "Checking out files $Files in $Repository"
		$ExtendedCLI = "";
		if ($Force)
		{
			$ExtendedCLI += " -f"
		}
		$ErrorCount = $Error.Count
		$Output = (Invoke-Expression -Command "git -C $Repository checkout$ExtendedCLI $Files") 2>&1
		if ($Error.Count -gt $ErrorCount)
		{
			$Error | select -Skip $ErrorCount | ForEach-Object { Write-Error -ErrorRecord $_ }
			return
		}
		Write-Verbose -Message "Successfully checked out files $Files in $Repository"
	}
}