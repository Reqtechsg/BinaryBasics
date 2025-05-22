function Format-BinaryTable
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [int]
        $Bits
    )

    $max  = [Math]::Pow(2, $Bits) - 1

    $binary_length = $Bits

    $hex_length = [Math]::Ceiling(
        [Math]::Log($max, 16)
    )

    0..$([Math]::Pow(2, $bits) - 1) | ForEach-Object {
        [PSCustomObject]@{
            Decimal = $_
            Binary  = $($_).ToString("b$($binary_length )").PadLeft($binary_length, '0')
            Hex     = $($_).ToString("x$($hex_length)").PadLeft($hex_length, '0')
        }
    } | Format-Table Decimal, @{N = 'Binary' ; E = {$_.Binary} ; Alignment = 'Right'},  @{N = 'Hex' ; E = {$_.Hex} ; Alignment = 'Right'}
}
