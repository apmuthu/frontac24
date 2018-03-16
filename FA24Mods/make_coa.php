<?php
// Purpose     : Script to generate FrontAccounting 2.4.x Chart of Accounts
// Author      : Ap.Muthu <apmuthu@usa.net>
// Release Date: 2018-03-16

// form defaults
	$Country        = 'South Africa';
	$Locale         = 'en_ZA';
	$PaperSize      = 'Letter'; // or A4
	$CurrencyCode   = 'ZAR';
	$CurrencySymbol = 'R';
	$CurrencyName   = 'South African Rand';
	$CurrencyCoins  = 'Cents';
	$fyear_start    = '2017-03-01';
	$MainTaxName    = 'VAT';
	$MainTaxRate    = 14;
$chart_form = <<<EOF
<form method="POST">
<!-- https://htmlcolorcodes.com/color-names/ -->
    <table border="1" bgcolor="aqua">
        <tr>
            <th align="left"><strong>Parameter</strong></th>
            <th align="left"><strong>Value</strong></th>
            <th align="left"><strong>Examples</strong></th>
        </tr>
        <tr>
            <td>Country: </td>
            <td><input type="text" size="20" name="Country" value="$Country" maxlength="30"></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>Locale: </td>
            <td><input type="text" size="5" name="Locale" value="$Locale" maxlength="6"></td>
            <td>en_IN, ar_EG, etc</td>
        </tr>
        <tr>
            <td>Paper Size: </td>
            <td><select name="PaperSize" size="1"><option selected>Letter</option><option>A4</option></select></td>
            <td>Letter, A4</td>
        </tr>
        <tr>
            <td>Currency Code: </td>
            <td><input type="text" size="4" name="CurrencyCode" value="$CurrencyCode" maxlength="4"></td>
            <td>INR, SGD, etc</td>
        </tr>
        <tr>
            <td>Currency Symbol: </td>
            <td><input type="text" size="4" name="CurrencySymbol" value="$CurrencySymbol" maxlength="4"></td>
            <td>Rs, S$, etc</td>
        </tr>
        <tr>
            <td>Currency Name: </td>
            <td><input type="text" size="20" name="CurrencyName" value="$CurrencyName" maxlength="30"></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>Coins: </td>
            <td><input type="text" size="20" name="CurrencyCoins" value="$CurrencyCoins" maxlength="20"></td>
            <td>Paise, Cents, etc</td>
        </tr>
        <tr>
            <td>Fiscal Year Start: </td>
            <td><input type="text" size="10" name="fyear_start" value="$fyear_start" maxlength="10"></td>
            <td>YYYY-MM-DD</td>
        </tr>
        <tr>
            <td>Main Tax Name:</td>
            <td><input type="text" size="10" name="MainTaxName" value="$MainTaxName" maxlength="20"></td>
            <td>GST, VAT, Sales tax, etc</td>
        </tr>
        <tr>
            <td>Main Tax Rate: </td>
            <td><input type="text" size="6" name="MainTaxRate" value="$MainTaxRate" maxlength="6"></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td align="center" colspan="3">
			<input type="submit" name="GetChart" value="Generate FA 2.4.x Chart of Accounts"></td>
        </tr>
    </table>
</form>
EOF;
if (!isset($_POST['GetChart'])) echo $chart_form;
else {
	foreach($_POST as $key => $var) $_POST[$key] = str_replace(array(";", '"', "'", ":"),"",$var);
	extract($_POST);
	$MainTaxRate = $MainTaxRate+0;
	$LUpdate = date("Y-m-d");
	
//	$url = 'https://github.com/apmuthu/FA24extensions/raw/master/Charts/chart_en_ZA-4digit/en_ZA-new.sql';
	$url = 'https://raw.githubusercontent.com/apmuthu/frontac24/master/FA24Mods/sql/en_US-new.sql';
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	$newcoa = curl_exec($ch);
	curl_close($ch);
	$newcoa = str_replace("NULL, 'USD',", "NULL, '$CurrencyCode',", $newcoa);
	if (!in_array($CurrencyCode, array('USD', 'EUR', 'GBP', 'CAD')))
		$newcoa = str_replace(" ('US Dollars','USD'", " ('$CurrencyName', '$CurrencyCode', '$CurrencySymbol', '$Country', '$CurrencyCoins', 1,0)\n,('US Dollars','USD'", $newcoa);
	$newcoa = str_replace(" ('1', '2018-01-01', '2018-12-31', '0');", " ('1', '$fyear_start', DATE_SUB(DATE_ADD('$fyear_start', INTERVAL 1 YEAR), INTERVAL 1 DAY), '0');", $newcoa);
	$newcoa = str_replace("'char', '3', 'USD')", "'char', '3', '$CurrencyCode')", $newcoa);
	$newcoa = str_replace(" ('1', '5', '2150', '2150', 'Tax', '0');", " ('1', '$MainTaxRate', '2150', '2150', '$MainTaxName', '0');", $newcoa);
	$newcoa = str_replace("COA	Country     - USA", "COA	Country     - $Country", $newcoa);
	$newcoa = str_replace("Last Update     - ", "Last Update     - $LUpdate // ", $newcoa);
	$newcoa = str_replace(", 'Letter', '2',", ", '$PaperSize', '2',", $newcoa);
	header("Content-type: text/plain");
	header("Content-Disposition: attachment; filename=$Locale"."-new.sql");
	echo $newcoa;
}
?>
