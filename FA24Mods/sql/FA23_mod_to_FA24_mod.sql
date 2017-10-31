/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 2017-10-31
-- This script synchronises apmuthu's FAMods standard FA 2.3.26 Chart to FA24Mods FA 2.4.2+
-- USE `23mod`;

ALTER TABLE `0_areas` ENGINE=InnoDB; 
ALTER TABLE `0_attachments` ENGINE=InnoDB; 

ALTER TABLE `0_bank_accounts` 
	ADD COLUMN `bank_charge_act` varchar(15) NOT NULL DEFAULT '' after `id`, 
	CHANGE `last_reconciled_date` `last_reconciled_date` timestamp   NOT NULL DEFAULT '0000-00-00 00:00:00' after `bank_charge_act`, 
	CHANGE `ending_reconcile_balance` `ending_reconcile_balance` double   NOT NULL DEFAULT 0 after `last_reconciled_date`, 
	CHANGE `inactive` `inactive` tinyint(1)   NOT NULL DEFAULT 0 after `ending_reconcile_balance`, ENGINE=InnoDB; 

ALTER TABLE `0_bom` ENGINE=InnoDB; 

ALTER TABLE `0_budget_trans` 
	ADD COLUMN `id` int(11)   NOT NULL auto_increment first, 
	CHANGE `tran_date` `tran_date` date   NOT NULL DEFAULT '0000-00-00' after `id`, 
	CHANGE `account` `account` varchar(15) NOT NULL DEFAULT '' after `tran_date`, 
	CHANGE `memo_` `memo_` tinytext NOT NULL after `account`, 
	CHANGE `amount` `amount` double   NOT NULL DEFAULT 0 after `memo_`, 
	CHANGE `dimension_id` `dimension_id` int(11)   NULL DEFAULT 0 after `amount`, 
	CHANGE `dimension2_id` `dimension2_id` int(11)   NULL DEFAULT 0 after `dimension_id`, 
	DROP COLUMN `counter`, 
	DROP COLUMN `type`, 
	DROP COLUMN `type_no`, 
	DROP COLUMN `person_type_id`, 
	DROP COLUMN `person_id`, 
	DROP KEY `PRIMARY`, add PRIMARY KEY(`id`), 
	DROP KEY `Type_and_Number`;

ALTER TABLE `0_chart_class` ENGINE=InnoDB; 
ALTER TABLE `0_chart_master` ENGINE=InnoDB; 
ALTER TABLE `0_chart_types` ENGINE=InnoDB; 
ALTER TABLE `0_credit_status` ENGINE=InnoDB; 
ALTER TABLE `0_currencies` ENGINE=InnoDB; 

ALTER TABLE `0_cust_allocations` 
	ADD COLUMN `person_id` int(11)   NULL after `id`, 
	CHANGE `amt` `amt` double unsigned   NULL after `person_id`, 
	CHANGE `date_alloc` `date_alloc` date   NOT NULL DEFAULT '0000-00-00' after `amt`, 
	CHANGE `trans_no_from` `trans_no_from` int(11)   NULL after `date_alloc`, 
	CHANGE `trans_type_from` `trans_type_from` int(11)   NULL after `trans_no_from`, 
	CHANGE `trans_no_to` `trans_no_to` int(11)   NULL after `trans_type_from`, 
	CHANGE `trans_type_to` `trans_type_to` int(11)   NULL after `trans_no_to`, 
	DROP KEY `From`, 
	ADD UNIQUE KEY `trans_type_from`(`trans_type_from`,`trans_no_from`,`trans_type_to`,`trans_no_to`,`person_id`);

ALTER TABLE `0_cust_branch` 
	CHANGE `default_location` `default_location` varchar(5) NOT NULL DEFAULT '' after `salesman`, 
	CHANGE `tax_group_id` `tax_group_id` int(11)   NULL after `default_location`, 
	CHANGE `sales_account` `sales_account` varchar(15) NOT NULL DEFAULT '' after `tax_group_id`, 
	CHANGE `sales_discount_account` `sales_discount_account` varchar(15) NOT NULL DEFAULT '' after `sales_account`, 
	CHANGE `receivables_account` `receivables_account` varchar(15) NOT NULL DEFAULT '' after `sales_discount_account`, 
	CHANGE `payment_discount_account` `payment_discount_account` varchar(15) NOT NULL DEFAULT '' after `receivables_account`, 
	CHANGE `default_ship_via` `default_ship_via` int(11)   NOT NULL DEFAULT 1 after `payment_discount_account`, 
	CHANGE `br_post_address` `br_post_address` tinytext NOT NULL after `default_ship_via`, 
	CHANGE `group_no` `group_no` int(11)   NOT NULL DEFAULT 0 after `br_post_address`, 
	CHANGE `notes` `notes` tinytext NOT NULL after `group_no`, 
	ADD COLUMN `bank_account` varchar(60) NULL after `notes`, 
	CHANGE `inactive` `inactive` tinyint(1)   NOT NULL DEFAULT 0 after `bank_account`, 
	DROP COLUMN `contact_name`, 
	DROP COLUMN `disable_trans`, ENGINE=InnoDB; 

ALTER TABLE `0_debtor_trans` 
	CHANGE `debtor_no` `debtor_no` int(11) unsigned   NOT NULL after `version`, 
	ADD COLUMN `prep_amount` double   NOT NULL DEFAULT 0 after `alloc`, 
	CHANGE `rate` `rate` double   NOT NULL DEFAULT 1 after `prep_amount`, 
	CHANGE `ship_via` `ship_via` int(11)   NULL after `rate`, 
	CHANGE `dimension_id` `dimension_id` int(11)   NOT NULL DEFAULT 0 after `ship_via`, 
	CHANGE `dimension2_id` `dimension2_id` int(11)   NOT NULL DEFAULT 0 after `dimension_id`, 
	CHANGE `payment_terms` `payment_terms` int(11)   NULL after `dimension2_id`, 
	ADD COLUMN `tax_included` tinyint(1) unsigned   NOT NULL DEFAULT 0 after `payment_terms`, 
	DROP KEY `PRIMARY`, add PRIMARY KEY(`type`,`trans_no`,`debtor_no`);

ALTER TABLE `0_debtors_master` ENGINE=InnoDB; 
ALTER TABLE `0_exchange_rates` ENGINE=InnoDB; 

ALTER TABLE `0_gl_trans` 
	CHANGE `type_no` `type_no` int(11)   NOT NULL DEFAULT 0 after `type`;

ALTER TABLE `0_grn_batch` 
	ADD COLUMN `rate` double   NULL DEFAULT 1 after `loc_code`;

ALTER TABLE `0_groups` ENGINE=InnoDB; 
ALTER TABLE `0_item_codes` ENGINE=InnoDB; 
ALTER TABLE `0_item_units` ENGINE=InnoDB; 

CREATE TABLE `0_journal`(
	`type` smallint(6) NOT NULL  DEFAULT 0 , 
	`trans_no` int(11) NOT NULL  DEFAULT 0 , 
	`tran_date` date NULL  DEFAULT '0000-00-00' , 
	`reference` varchar(60) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`source_ref` varchar(60) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`event_date` date NULL  DEFAULT '0000-00-00' , 
	`doc_date` date NOT NULL  DEFAULT '0000-00-00' , 
	`currency` char(3) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`amount` double NOT NULL  DEFAULT 0 , 
	`rate` double NOT NULL  DEFAULT 1 , 
	PRIMARY KEY (`type`,`trans_no`) , 
	KEY `tran_date`(`tran_date`) 
) ENGINE=InnoDB;

ALTER TABLE `0_loc_stock` 
	CHANGE `reorder_level` `reorder_level` double   NOT NULL DEFAULT 0 after `stock_id`;

ALTER TABLE `0_locations` 
	ADD COLUMN `fixed_asset` tinyint(1)   NOT NULL DEFAULT 0 after `contact`, 
	CHANGE `inactive` `inactive` tinyint(1)   NOT NULL DEFAULT 0 after `fixed_asset`, ENGINE=InnoDB; 

ALTER TABLE `0_payment_terms` ENGINE=InnoDB; 
ALTER TABLE `0_prices` ENGINE=InnoDB; 
ALTER TABLE `0_print_profiles` ENGINE=InnoDB; 
ALTER TABLE `0_printers` ENGINE=InnoDB; 
ALTER TABLE `0_purch_data` ENGINE=InnoDB; 

ALTER TABLE `0_purch_order_details` 
	ADD KEY `itemcode`(`item_code`);

ALTER TABLE `0_purch_orders` 
	ADD COLUMN `prep_amount` double   NOT NULL DEFAULT 0 after `total`, 
	ADD COLUMN `alloc` double   NOT NULL DEFAULT 0 after `prep_amount`, 
	CHANGE `tax_included` `tax_included` tinyint(1)   NOT NULL DEFAULT 0 after `alloc`;

ALTER TABLE `0_quick_entries` 
	ADD COLUMN `usage` varchar(120) NULL after `description`, 
	CHANGE `base_amount` `base_amount` double   NOT NULL DEFAULT 0 after `usage`, 
	CHANGE `base_desc` `base_desc` varchar(60) NULL after `base_amount`, 
	CHANGE `bal_type` `bal_type` tinyint(1)   NOT NULL DEFAULT 0 after `base_desc`, ENGINE=InnoDB; 

ALTER TABLE `0_quick_entry_lines` 
	ADD COLUMN `memo` tinytext NOT NULL after `amount`, 
	CHANGE `action` `action` varchar(2) NOT NULL after `memo`, 
	CHANGE `dest_id` `dest_id` varchar(15) NOT NULL DEFAULT '' after `action`, 
	CHANGE `dimension_id` `dimension_id` smallint(6) unsigned   NULL after `dest_id`, 
	CHANGE `dimension2_id` `dimension2_id` smallint(6) unsigned   NULL after `dimension_id`, ENGINE=InnoDB; 

CREATE TABLE `0_reflines`(
	`id` int(11) NOT NULL  auto_increment , 
	`trans_type` int(11) NOT NULL  , 
	`prefix` varchar(5) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`pattern` varchar(35) COLLATE latin1_general_ci NOT NULL  DEFAULT '1' , 
	`description` varchar(60) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`default` tinyint(1) NOT NULL  DEFAULT 0 , 
	`inactive` tinyint(1) NOT NULL  DEFAULT 0 , 
	PRIMARY KEY (`id`) , 
	UNIQUE KEY `prefix`(`trans_type`,`prefix`) 
) ENGINE=InnoDB;

ALTER TABLE `0_sales_order_details` 
	ADD COLUMN `invoiced` double   NOT NULL DEFAULT 0 after `quantity`, 
	CHANGE `discount_percent` `discount_percent` double   NOT NULL DEFAULT 0 after `invoiced`, 
	ADD KEY `stkcode`(`stk_code`);

ALTER TABLE `0_sales_orders` 
	ADD COLUMN `prep_amount` double   NOT NULL DEFAULT 0 after `total`, 
	ADD COLUMN `alloc` double   NOT NULL DEFAULT 0 after `prep_amount`;

ALTER TABLE `0_sales_pos` ENGINE=InnoDB; 
ALTER TABLE `0_sales_types` ENGINE=InnoDB; 
ALTER TABLE `0_salesman` ENGINE=InnoDB; 
ALTER TABLE `0_security_roles` ENGINE=InnoDB; 
ALTER TABLE `0_shippers` ENGINE=InnoDB; 
ALTER TABLE `0_sql_trail` ENGINE=InnoDB; 

ALTER TABLE `0_stock_category` 
	ADD COLUMN `dflt_wip_act` varchar(15) NOT NULL DEFAULT '' after `dflt_adjustment_act`, 
	CHANGE `dflt_dim1` `dflt_dim1` int(11)   NULL after `dflt_wip_act`, 
	ADD COLUMN `dflt_no_purchase` tinyint(1)   NOT NULL DEFAULT 0 after `dflt_no_sale`, 
	DROP COLUMN `dflt_assembly_act`, ENGINE=InnoDB; 

CREATE TABLE `0_stock_fa_class`(
	`fa_class_id` varchar(20) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`parent_id` varchar(20) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`description` varchar(200) COLLATE latin1_general_ci NOT NULL  DEFAULT '' , 
	`long_description` tinytext COLLATE latin1_general_ci NOT NULL  , 
	`depreciation_rate` double NOT NULL  DEFAULT 0 , 
	`inactive` tinyint(1) NOT NULL  DEFAULT 0 , 
	PRIMARY KEY (`fa_class_id`) 
) ENGINE=InnoDB;

ALTER TABLE `0_stock_master` 
	ADD COLUMN `wip_account` varchar(15) NOT NULL DEFAULT '' after `adjustment_account`, 
	CHANGE `dimension_id` `dimension_id` int(11)   NULL after `wip_account`, 
	ADD COLUMN `purchase_cost` double   NOT NULL DEFAULT 0 after `dimension2_id`, 
	CHANGE `material_cost` `material_cost` double   NOT NULL DEFAULT 0 after `purchase_cost`, 
	CHANGE `labour_cost` `labour_cost` double   NOT NULL DEFAULT 0 after `material_cost`, 
	CHANGE `overhead_cost` `overhead_cost` double   NOT NULL DEFAULT 0 after `labour_cost`, 
	CHANGE `inactive` `inactive` tinyint(1)   NOT NULL DEFAULT 0 after `overhead_cost`, 
	CHANGE `no_sale` `no_sale` tinyint(1)   NOT NULL DEFAULT 0 after `inactive`, 
	ADD COLUMN `no_purchase` tinyint(1)   NOT NULL DEFAULT 0 after `no_sale`, 
	CHANGE `editable` `editable` tinyint(1)   NOT NULL DEFAULT 0 after `no_purchase`, 
	ADD COLUMN `depreciation_method` char(1) NOT NULL DEFAULT 'S' after `editable`, 
	ADD COLUMN `depreciation_rate` double   NOT NULL DEFAULT 0 after `depreciation_method`, 
	ADD COLUMN `depreciation_factor` double   NOT NULL DEFAULT 1 after `depreciation_rate`, 
	ADD COLUMN `depreciation_start` date   NOT NULL DEFAULT '0000-00-00' after `depreciation_factor`, 
	ADD COLUMN `depreciation_date` date   NOT NULL DEFAULT '0000-00-00' after `depreciation_start`, 
	ADD COLUMN `fa_class_id` varchar(20) NOT NULL DEFAULT '' after `depreciation_date`, 
	DROP COLUMN `assembly_account`, 
	DROP COLUMN `actual_cost`, 
	DROP COLUMN `last_cost`;

ALTER TABLE `0_stock_moves` 
	CHANGE `price` `price` double   NOT NULL DEFAULT 0 after `tran_date`, 
	CHANGE `reference` `reference` varchar(40) NOT NULL DEFAULT '' after `price`, 
	CHANGE `qty` `qty` double   NOT NULL DEFAULT 1 after `reference`, 
	CHANGE `standard_cost` `standard_cost` double   NOT NULL DEFAULT 0 after `qty`, 
	DROP COLUMN `person_id`, 
	DROP COLUMN `discount_percent`, 
	DROP COLUMN `visible`;

ALTER TABLE `0_supp_allocations` 
	ADD COLUMN `person_id` int(11)   NULL after `id`, 
	CHANGE `amt` `amt` double unsigned   NULL after `person_id`, 
	CHANGE `date_alloc` `date_alloc` date   NOT NULL DEFAULT '0000-00-00' after `amt`, 
	CHANGE `trans_no_from` `trans_no_from` int(11)   NULL after `date_alloc`, 
	CHANGE `trans_type_from` `trans_type_from` int(11)   NULL after `trans_no_from`, 
	CHANGE `trans_no_to` `trans_no_to` int(11)   NULL after `trans_type_from`, 
	CHANGE `trans_type_to` `trans_type_to` int(11)   NULL after `trans_no_to`, 
	ADD UNIQUE KEY `person_id`(`person_id`,`trans_type_from`,`trans_no_from`,`trans_type_to`,`trans_no_to`);

ALTER TABLE `0_supp_invoice_items` 
	ADD COLUMN `dimension_id` int(11)   NOT NULL DEFAULT 0 after `memo_`, 
	ADD COLUMN `dimension2_id` int(11)   NOT NULL DEFAULT 0 after `dimension_id`;

ALTER TABLE `0_supp_trans` 
	CHANGE `supplier_id` `supplier_id` int(11) unsigned   NOT NULL after `type`, 
	DROP KEY `PRIMARY`, add PRIMARY KEY(`type`,`trans_no`,`supplier_id`), 
	DROP KEY `supplier_id`, add KEY `supplier_id`(`supplier_id`);

ALTER TABLE `0_suppliers` ENGINE=InnoDB; 

ALTER TABLE `0_sys_prefs` 
	CHANGE `value` `value` text NOT NULL after `length`, ENGINE=InnoDB; 

ALTER TABLE `0_tax_group_items` 
	ADD COLUMN `tax_shipping` tinyint(1)   NOT NULL DEFAULT 0 after `tax_type_id`, 
	DROP COLUMN `rate`;

ALTER TABLE `0_tax_groups` 
	CHANGE `inactive` `inactive` tinyint(1)   NOT NULL DEFAULT 0 after `name`, 
	DROP COLUMN `tax_shipping`;

ALTER TABLE `0_trans_tax_details` 
	ADD COLUMN `reg_type` tinyint(1)   NULL after `memo`;

ALTER TABLE `0_useronline` ENGINE=InnoDB; 

ALTER TABLE `0_users` 
	ADD COLUMN `transaction_days` smallint(6)   NOT NULL DEFAULT 30 COMMENT 'Transaction days' after `startup_tab`, 
	ADD COLUMN `save_report_selections` smallint(6)   NOT NULL DEFAULT 0 COMMENT 'Save Report Selection Days' after `transaction_days`, 
	ADD COLUMN `use_date_picker` tinyint(1)   NOT NULL DEFAULT 1 COMMENT 'Use Date Picker for all Date Values' after `save_report_selections`, 
	ADD COLUMN `def_print_destination` tinyint(1)   NOT NULL DEFAULT 0 COMMENT 'Default Report Destination' after `use_date_picker`, 
	ADD COLUMN `def_print_orientation` tinyint(1)   NOT NULL DEFAULT 0 COMMENT 'Default Report Orientation' after `def_print_destination`, 
	CHANGE `inactive` `inactive` tinyint(1)   NOT NULL DEFAULT 0 after `def_print_orientation`, ENGINE=InnoDB; 

CREATE TABLE `0_wo_costing`(
	`id` int(11) NOT NULL  auto_increment , 
	`workorder_id` int(11) NOT NULL  DEFAULT 0 , 
	`cost_type` tinyint(1) NOT NULL  DEFAULT 0 , 
	`trans_type` int(11) NOT NULL  DEFAULT 0 , 
	`trans_no` int(11) NOT NULL  DEFAULT 0 , 
	`factor` double NOT NULL  DEFAULT 1 , 
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB;

ALTER TABLE `0_wo_issue_items` 
	ADD COLUMN `unit_cost` double   NOT NULL DEFAULT 0 after `qty_issued`;

ALTER TABLE `0_wo_requirements` 
	ADD COLUMN `unit_cost` double   NOT NULL DEFAULT 0 after `units_req`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `unit_cost`, 
	DROP COLUMN `std_cost`;

ALTER TABLE `0_workcentres` ENGINE=InnoDB;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
