# Dot source led file
. .\Write-LedDigits.ps1
. .\Write-AnimatedMessage.ps1

# Ask for a number between 5 to 9
# 2 ^ 5  has   32 numbers |  6 display boards | Each board has  16 numbers
# 2 ^ 6  has   64 numbers |  6 display boards | Each board has  32 numbers
# 2 ^ 7  has  128 numbers |  7 display boards | Each board has  64 numbers
# 2 ^ 8  has  256 numbers |  8 display boards | Each board has 128 numbers
# 2 ^ 9  has  512 numbers |  9 display boards | Each board has 256 numbers
do{
    Write-Host

    Write-AnimatedMessage "Enter a number from 5 to 9: " 15 -NoNewLine

    $exponent = Read-Host

}while($exponent -notmatch '^(5|6|7|8|9)$')

# Generate a list of numbers based on the exponent value.
$numbers = 0..$([Math]::Pow(2, $exponent) -as [int])

# The number of binary bits required is the exponent itself.
$bits = $exponent -as [int]

# A hashtable of list of numbers, to be looked up by the weight
$buckets = @{}

# A hashtable of list of display boards , to be looked up by the weight
$boards  = @{}

# Generate an array of weights
$weights = 0..$($bits - 1) | ForEach-Object {
    [Math]::Pow(2, $_) -as [int]
}

# Initialize lists in the buckets hashtable
foreach($weight in $weights)
{
    $buckets[$weight] = [System.Collections.Generic.List[int]]::new()
}

# Populate lists in the buckets hashtable
foreach($number in $numbers)
{
    foreach($weight in $buckets.Keys)
    {
        if($number -band $weight)
        {
            $buckets[$weight].Add($number)
        }
    }
}

# Number of columns to print on each display board.
$columns = $bits

# Pad size is the number of digits of the largest number.
$pad_size = $($numbers[-1]).ToString().Length

# Generate the display boards and save them in the boards hashtable.
foreach($weight in $weights)
{
    $numbers = $buckets[$weight]

    $start = 0
    $lines = while($start -le $numbers.Count)
    {
        $end = [Math]::Min($start + $columns - 1, $numbers.Count - 1)

        $numbers[$start..$end].ForEach({
            $_.ToString().PadLeft($pad_size)
        }) -join '   '

        $start += $columns
    }

    $boards[$weight] = $lines
}

# Ask for number between
Write-Host
Write-AnimatedMessage "Think of a number between 0 and $($numbers[-1])." 9
Write-AnimatedMessage "Press any key to continue." 9
Read-Host

# Initialize number_on_mind to 0.
$number_on_mind = 0

# Initialize question counter to 0.
$question = 0

$boards.Keys | Sort-Object { Get-Random } | ForEach-Object {

    # Save the current key to a weight variable for easy reference later.
    $weight = $_

    # Get the board to display for this question.
    $display = $boards[$weight]

    # Increment quesiton counter.
    $question++

    # Print question number.
    Write-Host
    Write-AnimatedMessage "Question $($question):" 9

    # Display the board.
    $display | ForEach-Object {
        Write-AnimatedMessage $_ 1
    }

    # Insert a blank line.
    Write-Host

    # Print question.
    Write-Host
    Write-AnimatedMessage 'Is the number on your mind in this list ? [Y/N]' 9 -NoNewLine
    $answer = Read-Host

    if($answer -ieq 'y')
    {
        $number_on_mind += $weight
    }
}

# Print the answer
Write-Host
Write-AnimatedMessage 'The number on your mind is: ' 9
Write-LedDigit $number_on_mind
