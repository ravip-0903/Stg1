
<div class="form-field">
	<label for="payment_merchantid">Merchant ID:</label>
	<input type="text" name="payment_data[processor_params][merchantid]" id="payment_merchantid" value="{$processor_params.merchantid}"/>
    <!--<span style="font-weight:700;color:red; padding-left:10px;">200904281000001 (For staging)</span>-->
</div>

<div class="form-field">
	<label for="payment_workingkey">32 Bit Working Key:</label>
	<input type="text" name="payment_data[processor_params][workingkey]" id="payment_workingkey" value="{$processor_params.workingkey}"/>
</div>