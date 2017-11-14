/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 2017-11-14
-- This script synchronises a standard FA 2.4.2+ Chart to apmuthu's FA24Mods Chart for FA 2.4.2+
-- USE `24org`;

ALTER TABLE `0_bom` 
	CHANGE `parent` `parent` varchar(20) NOT NULL DEFAULT '' after `id`, 
	CHANGE `component` `component` varchar(20) NOT NULL DEFAULT '' after `parent`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `workcentre_added`, 
	DROP KEY `parent`, 
	DROP KEY `PRIMARY`,
	ADD PRIMARY KEY (`parent`,`loc_code`,`component`,`workcentre_added`);

ALTER TABLE `0_credit_status` 
	CHANGE `reason_description` `reason_description` varchar(100) NOT NULL DEFAULT '' after `id`;

ALTER TABLE `0_crm_contacts` 
	ADD KEY `entity_id`(`entity_id`), 
	ADD KEY `person_id`(`person_id`);

ALTER TABLE `0_cust_allocations` 
	DROP KEY `From`, 
	DROP KEY `trans_type_from`,
	ADD UNIQUE KEY `trans_type_from` (`trans_type_from`,`trans_no_from`,`trans_type_to`,`trans_no_to`,`person_id`);

ALTER TABLE `0_debtor_trans_details` 
	ADD KEY `stock_trans`(`stock_id`);

ALTER TABLE `0_loc_stock` 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' first, 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `loc_code`;

ALTER TABLE `0_payment_terms` 
	CHANGE `terms` `terms` varchar(80) NOT NULL DEFAULT '' after `terms_indicator`;

ALTER TABLE `0_purch_data` 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `supplier_id`, 
	CHANGE `suppliers_uom` `suppliers_uom` varchar(50) NOT NULL DEFAULT '' after `price`, 
	CHANGE `supplier_description` `supplier_description` varchar(50) NOT NULL DEFAULT '' after `conversion_factor`;

ALTER TABLE `0_reflines` 
	CHANGE `prefix` `prefix` varchar(5) NOT NULL DEFAULT '' after `trans_type`;

ALTER TABLE `0_sales_types` 
	CHANGE `sales_type` `sales_type` varchar(50) NOT NULL DEFAULT '' after `id`;

ALTER TABLE `0_salesman` 
	CHANGE `salesman_name` `salesman_name` varchar(60) NOT NULL DEFAULT '' after `salesman_code`, 
	CHANGE `salesman_phone` `salesman_phone` varchar(30) NOT NULL DEFAULT '' after `salesman_name`, 
	CHANGE `salesman_fax` `salesman_fax` varchar(30) NOT NULL DEFAULT '' after `salesman_phone`;

ALTER TABLE `0_stock_moves` 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `trans_no`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `type`, 
	CHANGE `reference` `reference` varchar(40) NOT NULL DEFAULT '' after `price`;

ALTER TABLE `0_supp_allocations` 
	DROP KEY `From`,
	DROP KEY `trans_type_from`,
	ADD UNIQUE KEY `trans_type_from` (`trans_type_from`,`trans_no_from`,`trans_type_to`,`trans_no_to`,`person_id`);

ALTER TABLE `0_tag_associations` 
	DROP KEY `record_id`,
	ADD PRIMARY KEY `record_id` (`record_id`,`tag_id`);

ALTER TABLE `0_tax_types` 
	ADD UNIQUE KEY `name` (`name`,`rate`);

ALTER TABLE `0_users` 
	CHANGE `transaction_days` `transaction_days` smallint(6)   NOT NULL DEFAULT 30 COMMENT 'Transaction days' after `startup_tab`, 
	CHANGE `save_report_selections` `save_report_selections` smallint(6)   NOT NULL DEFAULT 0 COMMENT 'Save Report Selection Days' after `transaction_days`, 
	CHANGE `use_date_picker` `use_date_picker` tinyint(1)   NOT NULL DEFAULT 1 COMMENT 'Use Date Picker for all Date Values' after `save_report_selections`, 
	CHANGE `def_print_destination` `def_print_destination` tinyint(1)   NOT NULL DEFAULT 0 COMMENT 'Default Report Destination' after `use_date_picker`, 
	CHANGE `def_print_orientation` `def_print_orientation` tinyint(1)   NOT NULL DEFAULT 0 COMMENT 'Default Report Orientation' after `def_print_destination`;

ALTER TABLE `0_wo_requirements` 
	CHANGE `stock_id` `stock_id` varchar(20) NOT NULL DEFAULT '' after `workorder_id`, 
	CHANGE `loc_code` `loc_code` varchar(5) NOT NULL DEFAULT '' after `unit_cost`;

ALTER TABLE `0_workcentres` 
	CHANGE `name` `name` varchar(40) NOT NULL DEFAULT '' after `id`, 
	CHANGE `description` `description` varchar(50) NOT NULL DEFAULT '' after `name`;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
