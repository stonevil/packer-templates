# Parse command line arguments
Param(
    [Parameter(Position=1)]
    [alias("t")]
    $TARGET =,
    [Parameter(Position=2)]
    [ValidateSet("nocm","chef","chefdk","salt","puppet")]
    [alias("c")]
    $CM = "nocm",
    [Parameter(Position=3)]
    [alias("v")]
    $CM_VERSION = "latest",
    [Parameter(Position=4)]
    [ValidateSet("true","false")]
    [alias("u")]
    $UPDATE = "false",
    [Parameter(Position=5)]
    [alias("b")]
    $BOX_VERSION,
    [Parameter(Position=6)]
    [ValidateSet("true","false")]
    [alias("g")]
    $GENERALIZE = "false")

Write-Host "Target = $TARGET"
Write-Host "Configuration_Management = $CM"
Write-Host "Configuration_Management_Version = $CM_VERSION"
Write-Host "Update_OS = $UPDATE"
Write-Host "Box_Version = $BOX_VERSION"
Write-Host "Generalize = $GENERALIZE"


# Check variables and generate command line for packer
$PACKER_VARS += "-var cm=$CM -var update=$UPDATE"

#if ($CM_VERSION -neq "")
#{
# $PACKER_VARS += "-var cm_version=$CM_VERSION"
#}


$PACKER_VARS

# find rigth way
# start-process powershell -verb runAs
# packer build -only=hyperv-iso $PACKER_VARS $TARGET.json
