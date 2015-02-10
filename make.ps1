$Env:UPDATE

# Override variables. Just for testing
if ($Env:UPDATE = "true")
if ($Env:UPDATE = "nocm")

if ($Env:UPDATE -eq "true")
{
 $PACKER_VARS += "-var update=update"
}

if ($Env:CM -eq "nocm")
{
 $PACKER_VARS += "-var update=nocm"
}

$Env.PACKER_VARS
