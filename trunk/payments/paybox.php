<?php
/***************************************************************************
*                                                                          *
*    Copyright (c) 2009 Simbirsk Technologies Ltd. All rights reserved.    *
*                                                                          *
* This  is  commercial  software,  only  users  who have purchased a valid *
* license  and  accept  to the terms of the  License Agreement can install *
* and use this program.                                                    *
*                                                                          *
****************************************************************************
* PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
* "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
****************************************************************************/


//
// $Id: paybox.php 7502 2009-05-19 14:54:59Z zeke $
//
if (!defined('AREA') ) { die('Access denied'); }

if (defined('PAYMENT_NOTIFICATION')) {

	$processor_error = array(
		"00000" => "Operation successful.",
		"001xx" => "Payment refused by the authorization centre.",
		"00003" => "Paybox error.",
		"00004" => "Cardholder’s number or visual cryptogram invalid.",
		"00006" => "Access refused or site/rank/identifier incorrect.",
		"00008" => "Expiry date incorrect.",
		"00009" => "Error in behavioural verification.",
		"00010" => "Currency unknown.",
		"00011" => "Amount incorrect.",
		"00015" => "Payment already made.",
		"00016" => "Subscriber already exists (registration of a new subscriber).",
		"00021" => "Not authorized bin card.",
	);

	if ($mode == 'process') {
		fn_order_placement_routines($_REQUEST['order_id']);

	} elseif ($mode == 'result') {

		$order_id = (strpos($_REQUEST['ref'], '_')) ? substr($_REQUEST['ref'], 0, strpos($_REQUEST['ref'], '_')) : $_REQUEST['ref'];

		$pp_response = array();
		if (!empty($_REQUEST['numauto'])) {
			$pp_response["order_status"] = 'P';
			$pp_response["reason_text"] = "NumAuto: " . $_REQUEST['numauto'];

		} else {
			$pp_response["order_status"] = 'F';
			$pp_response["reason_text"] = "Response code: ";
		
			if (!empty($processor_error[$_REQUEST['erreur']])) {
				$pp_response["reason_text"] .= $processor_error[$_REQUEST['erreur']];

			} elseif (strstr($_REQUEST['erreur'], '001') == true) {
				$pp_response["reason_text"] .= $processor_error["001xx"];

			} else {
				$pp_response["reason_text"] .= $_REQUEST['erreur'];
			}
		}

		$pp_response['transaction_id'] = $_REQUEST['transac'];
		if (fn_check_payment_script('paybox.php', $order_id)) {
			fn_finish_payment($order_id, $pp_response);
		}
		exit;
	}

} else {

$paybox_script = Registry::get('config.http_location') . "/payments/paybox_files/modulev2.cgi";

$pbx_devise = $processor_data['params']['currency'];
$r_url = Registry::get('config.current_location') . "/$index_script?dispatch=payment_notification.process&payment=paybox&order_id=$order_id&sl=" . CART_LANGUAGE;
$pbx_annule = $r_url;
$pbx_effectue = $r_url;
$pbx_refuse = $r_url;

$pbx_retour = "montant:M;ref:R;numauto:A;transac:T;erreur:E;maref:R;";
$pbx_total = $order_info['total'] * 100;
$pbx_cmd = ($order_info['repaid']) ? ($order_id . '_' . $order_info['repaid']) : $order_id;

echo <<<EOT
<html>
<body onLoad="javascript: document.process.submit();">
<form method="post" action="$paybox_script" name="process">
	<input type="hidden" name=PBX_MODE value="1">
	<input type="hidden" name=PBX_SITE value="{$processor_data['params']['site_num']}">
	<input type="hidden" name=PBX_RANG value="{$processor_data['params']['rank_num']}">
	<input type="hidden" name=PBX_IDENTIFIANT value="{$processor_data['params']['identifier']}">
	<input type="hidden" name=PBX_TOTAL value="{$pbx_total}">
	<input type="hidden" name=PBX_DEVISE value="{$pbx_devise}">
	<input type="hidden" name=PBX_CMD value="{$pbx_cmd}">
	<input type="hidden" name=PBX_PORTEUR value="{$order_info['email']}">
	<input type="hidden" name=PBX_RETOUR value="{$pbx_retour}">
	<input type="hidden" name=PBX_LANGUE value="{$processor_data['params']['language']}">
	<input type="hidden" name=PBX_EFFECTUE value="{$pbx_effectue}">
	<input type="hidden" name=PBX_REFUSE value="{$pbx_refuse}">
	<input type="hidden" name=PBX_ANNULE value="{$pbx_annule}">
	<input type="hidden" name=PBX_BOUTPI value="nul">
	<input type="hidden" name=PBX_RUF1 value="POST">
	<input type="hidden" name=PBX_TXT value="<b>Proceeding to Payment Page ...</b>">
<!-- end of form -->
EOT;
$msg = fn_get_lang_var('text_cc_processor_connection');
$msg = str_replace('[processor]', 'PayBox server', $msg);
echo <<<EOT
	</form>
   <p><div align=center>{$msg}</div></p>
 </body>
</html>
EOT;
exit;
}
?>
