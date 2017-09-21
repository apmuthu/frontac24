<?php

$path_to_root = "..";
//$page_security = 'SA_CUSTOMER';
$page_security = 'SA_SETUPCOMPANY';

include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/sales/includes/sales_ui.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/sales/includes/sales_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_types_db.inc");
include_once($path_to_root . "/reporting/includes/reporting.inc");
include_once($path_to_root . "/includes/ui/ui_controls.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");

$js = "";

page(_($help_context = "Merge Customers"), false, false, "", $js);

$deletecustomer = $_POST['deletecustomer']+0;
$keepcustomer   = $_POST['keepcustomer']+0;

if ($keepcustomer && $deletecustomer) {                
        
    if ($keepcustomer == $deletecustomer) 
        die("<center>You chose the same customer in both selections. Cannot merge a customer with himself/herself. <br /><br /><a href=\"merge.php\">Reload</a><br /><br /><br />");

    $sql = "UPDATE ".TB_PREF."debtor_trans SET debtor_no = $keepcustomer, branch_code = (SELECT branch_code FROM ".TB_PREF."cust_branch WHERE debtor_no = $keepcustomer LIMIT 1) WHERE debtor_no = $deletecustomer";
    db_query($sql, "An error occured");

    $sql = "UPDATE ".TB_PREF."sales_orders SET debtor_no = $keepcustomer, delivery_address = '', contact_phone = '', deliver_to = '', branch_code = (SELECT branch_code FROM ".TB_PREF."cust_branch WHERE debtor_no = $keepcustomer LIMIT 1) WHERE debtor_no = $deletecustomer";
    db_query($sql, "An error occured");

    $sql = "UPDATE ".TB_PREF."cust_allocations SET person_id = $keepcustomer WHERE person_id = $deletecustomer";
    db_query($sql, "An error occured");

    $sql = "UPDATE ".TB_PREF."recurrent_invoices SET debtor_no = $keepcustomer WHERE debtor_no = $deletecustomer";
    db_query($sql, "An error occured");

    $sql = "UPDATE ".TB_PREF."sales_orders SET debtor_no = $keepcustomer WHERE debtor_no = $deletecustomer";
    db_query($sql, "An error occured");

    $sql = "UPDATE ".TB_PREF."sales_orders SET branch_code = (SELECT branch_code FROM ".TB_PREF."cust_branch cb WHERE cb.debtor_no = $keepcustomer LIMIT 1) WHERE debtor_no = $deletecustomer";
    db_query($sql, "An error occured");

    $sql = "DELETE FROM ".TB_PREF."debtors_master WHERE debtor_no = $deletecustomer"; 
    db_query($sql, "An error occured");

    $sql = "DELETE FROM ".TB_PREF."cust_branch WHERE debtor_no = $deletecustomer"; 
    db_query($sql, "An error occured");

    $sql = "DELETE FROM ".TB_PREF."crm_contacts WHERE type = 'customer' AND entity_id = $deletecustomer"; 
    db_query($sql, "An error occured");

    $sql = "DELETE FROM ".TB_PREF."crm_contacts WHERE type = 'cust_branch' AND entity_id = (SELECT branch_code FROM ".TB_PREF."cust_branch WHERE debtor_no = $deletecustomer)"; 
    db_query($sql, "An error occured");

    $sql = "DELETE FROM ".TB_PREF."crm_persons WHERE type = 'customer' AND id = (SELECT person_id from ".TB_PREF."crm_contacts WHERE type = 'customer' AND entity_id = $deletecustomer LIMIT 1)"; 
    db_query($sql, "An error occured");
        
    header("Location: ..");
}

br(2);
start_table();
label_cell("<b class=\"headingtext\">NOTE: THIS ACTION IS IRREVOCABLE</b>");
end_table(2);

start_form();
start_table();
customer_list_cells(_("Merge & Delete this Customer: "), 'deletecustomer');
label_cell("<font size= \"6 \"> &nbsp; &nbsp; &rArr; &nbsp; &nbsp; &nbsp; </font>");
customer_list_cells(_("Merge & Keep this customer: "), 'keepcustomer');

end_table(3);
display_warning(_("Are you sure you want to void this transaction ? This action cannot be undone."), 0, 1);
br();
submit_center_first('ConfirmMerge', _("Merge Customers"), '', true);
submit_center_last('CancelMerge', _("Cancel"), '', 'cancel');
// echo "<input type=\"submit\" value=\" Merge Customers \"> &nbsp; &nbsp; <input type=\"submit\" formaction=\"..\" value=\" Cancel \" > </center>";

end_form();
br(3);

end_page();
