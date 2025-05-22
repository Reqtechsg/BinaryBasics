$zero = @'

 # # #
#     #
#     #
#     #
#     #
#     #
 # # #

'@

$one = @'

   #
 # #
   #
   #
   #
   #
 # # #

'@

$two = @'

  # #
#     #
      #
    #
  #
#
# # # #

'@

$three = @'

 # # #
#     #
      #
   # #
      #
#     #
 # # #

'@

$four = @'

    #
   #
  #  #
 #   #
# # # #
     #
     #

'@

$five = @'

# # # #
#
#
# # #
      #
#     #
 # # #

'@

$six = @'

  #
 #
#
# # #
#     #
#     #
 # # #

'@

$seven = @'

# # # #
     #
    #
   #
  #
 #
#

'@

$eight = @'

 # # #
#     #
#     #
 # # #
#     #
#     #
 # # #

'@

$nine = @'

 # # #
#     #
#     #
 # # #
      #
      #
      #

'@

$digits = @(
    $zero,
    $one,
    $two,
    $three,
    $four,
    $five,
    $six,
    $seven,
    $eight,
    $nine
)

function Write-LedDigit([string]$number_in_string)
{
    if($number_in_string -notmatch '^\d+$')
    {
        Write-Error 'Please pass in digits only.'
        return
    }

    # Convert string to array of characters.
    $digits_array = $number_in_string.ToCharArray()

    # Create LED array from the array of characters.
    $led_array = $digits_array.ForEach({
        $digits[[int]::Parse($_)] # We need to parse the 'character' digit to 'integer' digit.
    })

    # Turn on blinking
    Write-Host $PSStyle.Blink -NoNewline

    # There are in total 9 lines to print
    for($i = 0; $i -lt 9; $i++)
    {
        $led_array.foreach({

            # Split the LED into 10 lines.
            $lines = $_ -split "`n"

            # Get the line to print for this digit.
            $line_to_print = $lines[$i]

            # Print the line - pad to the right 10 units so that the printed LEDs are 3 spaces apart.
            Write-Host $line_to_print.PadRight(10) -NoNewline
        })

        # This line is completed. Insert new line.
        Write-Host
    }

    # Turn off blinking.
    Write-Host $PSStyle.Reset -NoNewline
}
