#Generate a series of Vester tests from a template file and CSV with list of test info

param ( 
	$sourceCsv,
    $templateScript	
)

$data = import-csv $sourceCsv
$template = gc $templateScript

#Get list of CSV columns matching TEMPLATE*
$headers = $data | gm | ? membertype -eq "NoteProperty" | ? name -like "TEMPLATE*"

#Process each row of the csv file
foreach($test in $data) {
    $newscript = $template
    #Update template placeholders with values from CSV file
    foreach($column in $headers) {
        $newscript = $newscript.replace( $column.name, $test.$($column.name) )
    }
    #Use the first, fixed named CSV header Filename to determine the output file
    set-content $test.Filename $newscript
}