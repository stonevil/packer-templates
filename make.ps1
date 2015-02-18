# Parse command line arguments
Param(
    [Parameter(Position=1)]
    [alias("t")]
    $TARGET,
    [Parameter(Position=2)]
    [ValidateSet("true","false")]
    [alias("u")]
    $UPDATE = "false",
    [Parameter(Position=3)]
    [ValidateSet("nocm","chef","chefdk","salt","puppet")]
    [alias("c")]
    $CM = "nocm",
    [Parameter(Position=4)]
    [alias("v")]
    $CM_VERSION = "latest",
    [Parameter(Position=5)]
    [alias("b")]
    $BOX_VERSION,
    [Parameter(Position=6)]
    [ValidateSet("true","false")]
    [alias("g")]
    $GENERALIZE = "false")


$WORK_PATH = (Get-Item -Path ".\" -Verbose).FullName

Write-Host "Packer task configuration"
Write-Host "Target configuration = $TARGET"
Write-Host "Update OS status = $UPDATE"
Write-Host "Configuration Management = $CM"
Write-Host "Configuration Management version = $CM_VERSION"
Write-Host "Targe box version = $BOX_VERSION"
Write-Host "Generalize = $GENERALIZE"


# Check variables and generate command line for packer
$PACKER_VARS += "-var cm=$CM -var update=$UPDATE"

# Execute task
$proc = New-Object System.Diagnostics.ProcessStartInfo
$proc.FileName = "packer.exe"
$proc.RedirectStandardError = $true
$proc.RedirectStandardOutput = $true
$proc.UseShellExecute = $false
$proc.Arguments = "build -only=hyperv-iso $PACKER_VARS $TARGET.json"
$proc.Verb = "runAs"
$proc.WorkingDirectory = "$WORK_PATH"
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $proc
$p.Start() | Out-Null
$p.WaitForExit()
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()
Write-Host "stdout: $stdout"
Write-Host "stderr: $stderr"
Write-Host "exit code: " + $p.ExitCode


# Envoke packer with params
# $packerbin = "packer.exe"
# $packerarguments = "build -only=hyper-iso $PACKER_VARS $TARGET.json"
# start-process packer -ArgumentList build -only=hyperv-iso $PACKER_VARS $TARGET.json -verb runAs
