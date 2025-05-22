function Format-PowersOf2Table
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Int32[]]
        $Exponent
    )

    BEGIN
    {
        $powers = [System.Collections.Generic.List[PSObject]]::new()
    }

    PROCESS
    {
        $powers.AddRange(
            $Exponent.ForEach({
                $base  = $_
                $power = [Math]::Pow(2, $_)

                [PSCustomObject]@{
                    Base        = 2
                    Exponent    = $base
                    Power       = $power
                }
            })
        )
    }

    END
    {
        $powers | Format-Table Base, Exponent, @{N = 'Power' ;  E = {'{0:N0}' -f $_.Power} ; Alignment = 'Right'}
    }
}
