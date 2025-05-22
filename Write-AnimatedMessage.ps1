function Write-AnimatedMessage
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string]
        $Message,

        [Parameter(Position = 1, Mandatory)]
        [int]
        $Delay,

        [Parameter()]
        [switch]
        $NoNewLine
    )

    $Message.ToCharArray() | ForEach-Object {

        Write-Host "$($_)" -NoNewline
        Start-Sleep -Milliseconds $Delay
    }

    if(-not $NoNewLine)
    {
        Write-Host
    }
}
