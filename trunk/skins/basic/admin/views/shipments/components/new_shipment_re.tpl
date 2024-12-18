{* $Id: new_shipment.tpl 12452 2011-05-13 11:33:14Z alexions $ *}

<script type="text/javascript">
//<![CDATA[
	var packages = [];
//]]>
</script>

<form action="{""|fn_url}" method="post" name="shipments_form" id="shipments_form">
<input type="hidden" name="shipment_data[order_id]" value="{$order_info.order_id}" />
<input type="hidden" name="reshipment" value="1" />
{foreach from=$order_info.shipping key="shipping_id" item="shipping"}
	{if $shipping.packages_info.packages}
		{assign var="has_packages" value=true}
	{/if}
{/foreach}

{if $has_packages}
	<div class="tabs cm-j-tabs">
		<ul>
			<li id="tab_general" class="cm-js cm-active"><a>{$lang.general}</a></li>
			<li id="tab_packages_info" class="cm-js"><a>{$lang.packages}</a></li>
		</ul>
	</div>
{/if}

<div class="cm-tabs-content" id="tabs_content">
	<div id="content_tab_general">

		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="table">
		<tr>
			<th>{$lang.product}</th>
			<th width="5%">{$lang.quantity}</th>
		</tr>

		{assign var="shipment_products" value=false}

		{foreach from=$order_info.items item="product" key="key"}
			{if $product.amount > -1}
			{assign var="shipment_products" value=true}
			
			<tr {cycle values="class=\"table-row\", " name="class_cycle"}>
				<td>
					{assign var=may_display_product_update_link value="products.update"|fn_check_view_permissions}
					{if $may_display_product_update_link && !$product.deleted_product}<a href="{"products.update?product_id=`$product.product_id`"|fn_url}">{/if}{$product.product|unescape|default:$lang.deleted_product}{if $may_display_product_update_link}</a>{/if}
					{if $product.product_code}<p>{$lang.sku}:&nbsp;{$product.product_code}</p>{/if}
					{if $product.product_options}<div class="options-info">{include file="common_templates/options_info.tpl" product_options=$product.product_options}</div>{/if}
				</td>
				<td class="center" nowrap="nowrap">
						{math equation="amount + 1" amount=$product.amount assign="loop_amount"}
						{if $loop_amount <= 100}
							<select id="shipment_data_{$key}" class="cm-shipments-product" name="shipment_data[products][{$key}]">
								<option value="0">0</option>
							{section name=amount start=1 loop=$loop_amount}
								<option value="{$smarty.section.amount.index}" {if $smarty.section.amount.last}selected="selected"{/if}>{$smarty.section.amount.index}</option>
							{/section}
							</select>
						{else}
							<input id="shipment_data_{$key}" type="text" class="input-text" size="3" name="shipment_data[products][{$key}]" value="{$product.shipment_amount}" />&nbsp;of&nbsp;{$product.shipment_amount}
						{/if}
				</td>
			</tr>
			{/if}
		{/foreach}

		{if !$shipment_products}
			<tr>
				<td colspan="2">{$lang.no_products_for_shipment}</td>
			</tr>
		{/if}

		</table>

		{include file="common_templates/subheader.tpl" title=$lang.options}

		<fieldset>
			<div class="form-field">
				<label for="shipping_name">{$lang.shipping_method}:</label>
				<select	name="shipment_data[shipping_id]" id="shipping_name">
					{foreach from=$shippings item="shipping"}
						<option	value="{$shipping.shipping_id}">{$shipping.shipping}</option>
					{/foreach}
				</select>
			</div>
			
			<div class="form-field">
				<label for="tracking_number">{$lang.tracking_number}:</label>
				<input type="text" name="shipment_data[tracking_number]" id="tracking_number" size="10" value="" class="input-text-medium" />
			</div>
			
			<div class="form-field">
				<label for="carrier_key">{$lang.carrier}:</label>
				<select id="carrier_key" name="shipment_data[carrier]">
					<option value="">--</option>
					<!--<option value="USP">{$lang.usps}</option>
					<option value="UPS">{$lang.ups}</option>					
					<option value="AUP">{$lang.australia_post}</option>
					<option value="DHL">{$lang.dhl}</option>
					<option value="CHP">{$lang.chp}</option>-->
                    <!--Modified By Chandan-->
					<option value="FDX">{$lang.fedex}</option>
                    <option value="First_Flight">{$lang.mycarrier_First_Flight}</option>
                    <option value="Gati">{$lang.mycarrier_Gati}</option>
                    <option value="Maruti_Courier">{$lang.mycarrier_Maruti_Courier}</option>
                    <option value="blue_dart">{$lang.mycarrier_blue_dart}</option>
                    <option value="DTDC">{$lang.mycarrier_dtdc}</option>
                    <option value="India_Post_Registered">{$lang.mycarrier_india_post_registered}</option>
                    <option value="PRofessional">{$lang.mycarrier_professional}</option>
                    <option value="Quantum">{$lang.mycarrier_quantum}</option>
					<option value="Aramax">{$lang.mycarrier_aramax}</option>
                    <!--Modified By Chandan-->
				</select>
			</div>
            
            <!-- Start Change By Paresh -->
            <div class="form-field">
				<label for="carrier_key">{$lang.package_type}:</label>
				<select id="carrier_key" name="shipment_data[package_type]">
					<option value="">--</option>
                    {assign var="package_types" value=""|get_package_types}
                    {foreach from=$package_types item="package_type"}
                    <option value="{$package_type.id}">{$package_type.package_type_name}</option>
                  	{/foreach}
				</select>
			</div>
			
            <div class="form-field">
				<label for="weight">{$lang.weight}:</label>
				<input type="text" name="shipment_data[weight]" id="weight" size="10" value="" class="input-text-medium" />
			</div>
            
            <div class="form-field">
				<label for="tracking_number">{$lang.dimention}:</label>
				<input type="text" name="shipment_data[height]" id="height" size="10" value="" class="input-text-medium" />
			</div> 
            <!-- End Change By Paresh -->
			<div class="form-field">
				<label for="shipment_comments">{$lang.comments}:</label>
				<textarea id="shipment_comments" name="shipment_data[comments]" cols="55" rows="8" class="input-textarea-long">{$lang.shipment_data_comment}</textarea>
			</div>
			
			<div class="form-field">
				<label for="order_status">{$lang.order_status}:</label>
				<select id="order_status" name="shipment_data[order_status]">
					<option value="">{$lang.do_not_change}</option>
					{foreach from=$smarty.const.STATUSES_ORDER|fn_get_statuses:true key="key" item="status"}
						<option value="{$key}" {if $key== 'A'} selected="selected"{/if}>{$status}</option>
					{/foreach}
				</select>
				<p class="description">
					{$lang.text_order_status_notification}
				</p>
			</div>
		</fieldset>

		<div class="cm-toggle-button">
			<div class="select-field notify-customer">
				<input type="checkbox" name="notify_user" id="shipment_notify_user" value="Y" class="checkbox" checked="checked" />
				<label for="shipment_notify_user">{$lang.send_shipment_notification_to_customer}</label>
			</div>
		</div>
	</div>
	
	{if $has_packages}
		<div id="content_tab_packages_info">
			<span class="packages-info">{$lang.text_shipping_packages_info}</span>
			{assign var="package_num" value="1"}

			{foreach from=$order_info.shipping key="shipping_id" item="shipping"}
				{foreach from=$shipping.packages_info.packages key="package_id" item="package"}
					{assign var="allowed" value=true}
					
					{capture name="package_container"}
					<div class="package-container">
						{* Uncomment the line below and the label tag to activate the distribution of packages functionality *}
						{*<input type="checkbox" class="cm-shipments-package" id="package_{$shipping_id}{$package_id}" value="Y" />*}
						
						<script type="text/javascript">
						//<![CDATA[
							packages['package_{$shipping_id}{$package_id}'] = [];
						//]]>
						</script>
						<h3>
						{*<label for="package_{$shipping_id}{$package_id}">*}{$lang.package} {$package_num} {if $package.shipping_params}({$package.shipping_params.box_length} x {$package.shipping_params.box_width} x {$package.shipping_params.box_height}){/if}{*</label>*}
						</h3>
						<ul>
						{foreach from=$package.products key="cart_id" item="amount"}
							<script type="text/javascript">
							//<![CDATA[
								packages['package_{$shipping_id}{$package_id}']['{$cart_id}'] = '{$amount}';
							//]]>
							</script>
							{if $order_info.items.$cart_id}
								<li><span>{$amount}</span> x {$order_info.items.$cart_id.product} {if $order_info.items.$cart_id.product_options}({include file="common_templates/options_info.tpl" product_options=$order_info.items.$cart_id.product_options}){/if}</li>
							{else}
								{assign var="allowed" value=false}
							{/if}
						{/foreach}
						</ul>
						<span class="strong">{$lang.weight}:</span> {$package.weight}<br />
						<span class="strong">{$lang.shipping_method}:</span> {$shipping.shipping}
					</div>
										{/capture}
					
					{if $allowed}
						{$smarty.capture.package_container}
					{/if}
					
					{math equation="num + 1" num=$package_num assign="package_num"}
				{/foreach}
			{/foreach}
		</div>
	{/if}
</div>

<div class="buttons-container">
	{include file="buttons/save_cancel.tpl" create=true but_name="dispatch[shipments.add]" cancel_action="close"}
</div>


</form>

{literal}
<script type="text/javascript">
//<![CDATA[
	$('.cm-shipments-package').bind('change', fn_calculate_packages);
	
	/*Modified by chandan*/
	$("#shipments_form").bind("keypress", function(e) {
		 if (e.keyCode == 13) {
			 return false;
		}
    });
	/*Modified by chandan*/
	
	function fn_calculate_packages()
	{
		var products = [];
		
		$('.cm-shipments-package:checked').each(function(id, elm) {
			jelm = $(elm);
			id = jelm.attr('id');
			
			for (var i in packages[id]) {
				if (typeof(products[i]) == 'undefined') {
					products[i] = parseInt(packages[id][i]);
				} else {
					products[i] += parseInt(packages[id][i]);
				}
			}
		});
		
		// Set the values of the ship products to 0. We will change the values to the correct variants after
		$('.cm-shipments-product').each(function() {
			$(this).val(0);
		});
		
		if (products.length > 0) {
			for (var i in products) {
				$('#shipment_data_' + i).val(products[i]);
			}
		}
	}
//]]>
</script>
{/literal}
