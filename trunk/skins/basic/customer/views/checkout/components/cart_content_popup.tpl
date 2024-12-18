{if $zero_inventory eq 1}
<div>
    {$lang.text_cart_zero_inventory|replace:'[product]':$zero_inventory_product}
</div>
{/if}
{assign var="result_ids" value="cart_items,checkout_totals,checkout_steps,cart_status,checkout_cart"}
<div class="list_lightboxcartitemheader" {if $location !='checkout'}style="margin-left:6px;"{/if}>
<div class="list_lightboxcartitemheader_image">Item</div>
<div class="list_lightboxcartitemheader_name">Name</div>

<div class="list_lightboxcartitemheader_pricing">Price</div>

<div class="list_lightboxcartitemheader_quantity">Quantity</div>

<div class="list_lightboxcartitemheader_subtotal">SubTotal</div>
{if $update_flag == 1}
<div class="list_lightboxcartitemheader_subtotal" style="margin-left: 35px;">Address</div>
{/if}

</div>
<div class="{if $location !='checkout'}list_lightboxcartitems{else}list_lightboxcartitems_withoutscroll{/if}" {if $location !='checkout'}style="margin-left:6px; width:98%; border-right:1px solid #eee;"{/if}>
    {if $cart.products|count > 0}
    {assign var="cart_total" value="0"}
    {if $update_flag == 1}
    {assign var="actual_cart" value=$update_cart}
    {else}
    {assign var="actual_cart" value=$cart.products}
    {/if}

    <!-- Code added by Rahul Gupta to place Cart Abandonment javascript starts here -->
    {if $config.viral_send_status == 1}

    {if $smarty.session.auth.user_id >0}
    {assign var="vir_status" value="TRUE"}
    {else}
    {assign var="vir_status" value="FALSE"}
    {/if}
    {assign var="viral_arr" value=""}

    {assign var="count_viral" value=0}

    {foreach from=$actual_cart item="viral_prod" key="viral_key"}   

    {assign var="count_viral" value=$count_viral+1}

    {assign var =prod_url value=$config.http_location|cat:"/"}
    {assign var ="viral_data" value=$viral_prod.product_id|fn_get_selected_product_ids}

    {foreach from=$viral_data item="vir_data"}

    {assign var="prod_url" value=$prod_url|cat:$vir_data.name|cat:".html"}

    {assign var="image_url" value=$config.ext_images_host|cat:"/"|cat:$vir_data.image_path}

    {/foreach}

    {assign var="viral_list" value="'itemId':"|cat:$viral_prod.product_id|cat:",'title':"|cat:"'"|cat:$viral_prod.name|replace:"&#039;":""|cat:"'"|cat:",'image':"|cat:"'"|cat:$image_url|cat:"'"|cat:",'link':"|cat:"'"|cat:$prod_url|cat:"'"|cat:",'price':"|cat:$viral_prod.price|cat:",'category':"|cat:"'"|cat:$vir_data.category|cat:"'"|cat:",'brand':"|cat:"'"|cat:$vir_data.variant|cat:"'"}

    {assign var="viral_arr" value=$viral_arr|cat:$viral_list|cat:"#"}

    {/foreach}

    {/if}

    {literal}
    <script type="text/javascript">

        {/literal}{if $config.viral_send_status == 1}{literal}
        var key = {/literal}"{$viral_arr}"{literal}.split('#');
        key.pop();
        var login_status = {/literal}"{$vir_status}"{literal};
        var myArray = new Array();
        var tot_purch  =  {/literal}"{$count_viral}"{literal};
        var total_cart_val1 = $('#cart_price').val();
        {/literal}{/if}{literal}
        function update_cart_item_quantity(id)
        {
    //var str = document.getElementById('update_cart_item_quantity' + id).href;
    var str = document.getElementById('update_cart_item_quantity' + id).rev;
    var cnt = document.getElementById(id + '_amount').value;
    var ind = str.indexOf('&qty=');
    var str_pre = str.substr(0,ind);
    str = str_pre + '&qty=' + cnt;
    //document.getElementById('update_cart_item_quantity' + id).href = str;
    document.getElementById('update_cart_item_quantity' + id).rev = str;
}    

function fn_update_cart_box()
{

    if({/literal}{$config.viral_send_status}{literal} == 1)
    {
        myArray = key;
        purchas = JSON.stringify(myArray);   
        purchas = purchas.replace("&#039;","") 
        purchas = ((purchas.replace(/\"/,"{")).replace(/","/g,'},{')).replace('"','}').replace(/'/g,'"')
        purchas  = eval("(" + purchas + ")");
        
        if({/literal}{$config.footer_pixels_dynamic_lang_var.vrmnt_script_across}{literal} == 1)
        {
            vrlmnt.setCustomData({"login_status":login_status,"total_cart_value":total_cart_val1,"total_purchases":tot_purch,"purchases":purchas});
        }

    }

}
function update_cart_items(key){
    var update_url = $('#update_cart_item_quantity'+key).attr('rev');
    jQuery.ajaxRequest(update_url, {method: 'GET', cache: false, result_ids:'cart_status', callback:fn_update_cart_box});
}


function delete_cart_items(key)
{
    var update_url = $('#delete_cart_item_quantity'+key).attr('rev');
    jQuery.ajaxRequest(update_url, {method: 'POST', cache: false, result_ids:'cart_status', callback:fn_update_cart_box});
}


</script>

{/literal}

<!-- Code added by Rahul Gupta to place Cart Abandonment javascript ends here-->

{foreach from=$actual_cart item="product" key="key"}    
    <img src='http://api.targetingmantra.com/RecordEvent?mid=130915&eid=4&pid={$product.product_id}&cid={$smarty.session.auth.user_id}' width='1' height='1'>
<!--Cart Item -->
<div class="list_lightboxcartitem">
<div class="{if $location !='checkout'}list_lightboxcartitem_image{else}list_lightboxcartitem_image_fourty{/if}">
{assign var="pro_images" value=$product.product_id|fn_get_image_pairs:'product':'M'}
{if $location!="checkout"}
    {include file="common_templates/image.tpl" image_width="50" image_height="50" obj_id=$obj_id_prefix images=$pro_images object_type="product" show_thumbnail="Y"}
{else}
    {include file="common_templates/image.tpl" image_width="50" image_height="50" obj_id=$obj_id_prefix images=$pro_images object_type="product" show_thumbnail="Y"}
{/if}
</div>
<div class="list_lightboxcartitem_name">
{$product.product_id|fn_get_product_name|unescape}
                {foreach from=$product.product_options item="item"}
	                {assign var ="product_option_count" value=$item|count}
                {/foreach}

                {if $product_option_count == 1}
                    {assign var ="product_option" value=$product.product_options|fn_get_selected_product_options_info}
                    {if $product_option}
                        {include file="common_templates/options_info.tpl" product_options=$product_option}
                    {/if}
                
                {else}
		            {assign var ="product_option_array" value=$product.product_options|fn_get_array_chunk}
		            {foreach from=$product_option_array item="pro_opt"}
				        {assign var ="product_option" value=$pro_opt|fn_get_selected_product_options_info}
				        {if $product_option}
				            {include file="common_templates/options_info.tpl" product_options=$product_option}
				        {/if}
		            {/foreach}
                {/if}

                {if !isset($pincode_var)}
                {assign var ="pincode_var" value=''}
                {/if}
                {if ($smarty.cookies.pincode != '') &&  $invalid_pin != '-1' && !($smarty.request.edit_step=='step_four' || $smarty.request.dispatch == 'checkout.checkout')}
                {assign var="is_serviceable" value=$product.product_id|get_servicability_type:$smarty.cookies.pincode}
                {if $is_serviceable == '4'}
                    <div class="foot_note_nl" style="color:#666">
                        {$lang.not_cod_only_prepaid}
                    </div>
                {elseif $is_serviceable == '0'}
                    <div class="foot_note_nl" style="color:#ff0000">
                        {$lang.nss_product}
                    </div>
                {/if}
                {/if}

</div>

<div class="list_lightboxcartitem_pricing">
{assign var="display_price" value=$product.discount+$product.price}
<div class="list_lightboxcartitem_pricing_priceoffer">{$display_price|ceil|number_format}</div>
</div>

<div class="list_lightboxcartitem_quantity">
{if $location!="checkout"}
<input type="tel" name="{$key}_amount" id="{$key}_amount" value="{$product.amount}" size="5" onchange="update_cart_item_quantity({$key})" />               
<div class="clearboth"></div>
{assign var="update_url" value="index.php?dispatch=checkout.update_quantity&result_ids=cart_status&product_id="|cat:$product.product_id|cat:"&cart_id="|cat:$key}
{if isset($product_option)}
    {foreach from=$product_option item="p_option"}
        {assign var="update_url" value=$update_url|cat:"&product_options["|cat:$p_option.option_id|cat:"]="|cat:$p_option.value}
    {/foreach}    
{/if}
{assign var="update_url" value=$update_url|cat:"&qty="|cat:$product.amount}

{if !eregi("Chrome",$smarty.server.HTTP_USER_AGENT)}
    <!--<a rev="cart_status" id="update_cart_item_quantity{$key}" class="cm-ajax list_lightboxcartitem_quantity_link" href="{$update_url}" name="update_cart_item_quantity"-->
        <a rev="{$update_url}" id="update_cart_item_quantity{$key}" class="list_lightboxcartitem_quantity_link" href="javascript: void(0);" onclick="update_cart_items({$key});" name="update_cart_item_quantity">
    {else}
        <!--a rev="cart_status" id="update_cart_item_quantity{$key}" class="cm-ajax list_lightboxcartitem_quantity_link" href="{$update_url}" name="update_cart_item_quantity" onclick="return false;"-->
    <a rev="{$update_url}" id="update_cart_item_quantity{$key}" class="list_lightboxcartitem_quantity_link" href="javascript: void(0);" onclick="update_cart_items({$key});" name="update_cart_item_quantity">
{/if}

 {$lang.update_item_qty}</a>
{else}
<label>{$product.amount}</label>
{/if}
</div>

<div class="list_lightboxcartitem_subtotal">
    {assign var="product_subtotal_display" value=$product.amount*$display_price}
{assign var="product_subtotal" value=$product.amount*$product.price}{$product_subtotal_display|ceil|number_format}
{assign var="cart_total" value=$cart_total+$product_subtotal}
</div>
{if $update_flag == 1}  
<div class="list_lightboxcartitem_address" style="margin-left: 25px; float:left;">
    {assign var="x" value=$product.profile_id}
    <div class="overflow-hidden">
{if $mul_address.$x.title || $mul_address.$x.firstname || $mul_address.$x.lastname}<p style="color:#7C8E8E;" class="no-padding"><strong>{if $mul_address.$x.title}{$mul_address.$x.title} {/if}{$mul_address.$x.firstname}{if $mul_address.$x.lastname} {$mul_address.$x.lastname}{/if}</strong></p>{/if}
        {if $mul_address.$x.address}<p style="color:#7C8E8E;" class="no-padding">{$mul_address.$x.address}</p>{/if}
        {if $mul_address.$x.address_2}<p style="color:#7C8E8E;" class="no-padding">{$mul_address.$x.address_2}</p>{/if}
        {if $mul_address.$x.city}{assign var="user_location" value=$mul_address.$x.city}{/if}
        {if $mul_address.$x.state}
                {if $user_location}{assign var="user_location" value="$user_location, "}{/if}
                {assign var="user_location" value="$user_location"|cat:$mul_address.$x.state}
        {/if}
        {if $mul_address.$x.zipcode}
                {assign var="user_location" value="$user_location "|cat:$mul_address.$x.zipcode}
        {/if}
        {if $user_location}<p style="color:#7C8E8E;" class="no-padding">{$user_location}</p>{/if}
        {if $mul_address.$x.country}<p style="color:#7C8E8E;" class="no-padding" style="display:inline;">{$mul_address.$x.country}</p>{/if}
    </div>
</div>
{if $cart.gifting.gift_it == 'Y'}
    <div style="float:right;margin: 5px;">
        <img src="http://cdn.shopclues.com/images/skin/gift_icon.png" width="19" style="float:left" alt="" title="Gift Wrap" />
    </div>
{/if}
{/if}
{if $location!="checkout"}

{assign var="unique_req_id" value=$smarty.cookies.sess_id|base64_encode}

{assign var="delete_url" value="index.php?dispatch=checkout.delete.from_status&cart_id=`$key`&req_id=`$unique_req_id`"}
    {if !eregi("Chrome",$smarty.server.HTTP_USER_AGENT)}
        <!--a rev="cart_status" class="cm-ajax list_lightboxcartitem_close" style="margin-left:25px; float:left;" href="index.php?dispatch=checkout.delete.from_status&cart_id={$key}" name="update_cart_item_quantity">X</a-->
        <a rev="{$delete_url}" id="delete_cart_item_quantity{$key}" class="list_lightboxcartitem_close" href="javascript: void(0);" onclick="delete_cart_items({$key});" name="delete_cart_item_quantity">
         X</a>

         {else}
         <!--a rev="cart_status" class="cm-ajax list_lightboxcartitem_close" style="margin-left:25px; float:left;" href="index.php?dispatch=checkout.delete.from_status&cart_id={$key}" name="update_cart_item_quantity" onclick="return false;">X</a-->
         <a rev="{$delete_url}" id="delete_cart_item_quantity{$key}" class="list_lightboxcartitem_close" href="javascript: void(0);" onclick="delete_cart_items({$key});" name="delete_cart_item_quantity">
             X</a>
    {/if}

{/if}
</div>
<!--End Cart Item -->
{literal}
<script type="text/javascript">
var piwik_switch="{/literal}{$config.piwik_switch}{literal}";
  if(piwik_switch){
var _paq = _paq || [];
_paq.push(["setCookieDomain", "*.shopclues.com"]);
var product_id="{/literal}{$product.product_id}{literal}";
var product_name="{/literal}{$product.name}{literal}";
var product_price="{/literal}{$product.price}{literal}";
var quantity ="{/literal}{$product.amount}{literal}";
_paq.push(['addEcommerceItem',product_id,product_name,"",product_price,quantity]);
 var cart_total="{/literal}{$cart_total}{literal}";
_paq.push(['trackEcommerceCartUpdate',cart_total]);
_paq.push(['trackPageView']);
}
</script>
{/literal}
{/foreach}
{/if}
{if $cart.gift_certificates|count >0}
 {foreach from=$cart.gift_certificates item="gc" key="key"}
   <div class="list_lightboxcartitem">
     <div class="{if $location !='checkout'}list_lightboxcartitem_image{else}list_lightboxcartitem_image_fourty{/if}">
      <img src="skins/basic/customer/images/icons/gift_certificates_cart_icon.gif" height="40px" />
     </div>
     <div class="list_lightboxcartitem_name">
       Gift Certificates
     </div>
     <div class="list_lightboxcartitem_pricing">
       <div class="list_lightboxcartitem_pricing_priceoffer">{$gc.amount}</div>
     </div> 
     <div class="list_lightboxcartitem_quantity">
      <label>1</label>
     </div>
     <div class="list_lightboxcartitem_subtotal">
       {$gc.amount}
     </div>
     {if $location!="checkout"}

     {assign var="delete_cart_gift_certificate" value="index.php?dispatch=gift_certificates.delete&gift_cert_id=`$key`&redirect_mode=delete.from_status&cart_id=`$key`&req_id=`$unique_req_id`"}

     <a rev="{$delete_cart_gift_certificate}" id="delete_cart_item_quantity{$key}" class="list_lightboxcartitem_close" href="javascript: void(0);" onclick="delete_cart_items({$key});" name="delete_cart_item_quantity">X</a>

        <!--a rev="cart_status" href="javascript: void(0);" class="cm-ajax list_lightboxcartitem_close"  href="index.php?dispatch=gift_certificates.delete&gift_cert_id={$key}" name="update_cart_item_quantity">X</a!-->
     {/if} 
     {assign var="cart_total" value=$cart_total+$gc.amount}
   </div>  
 {/foreach}
{/if} 
{if $cart.products|count == 0  && $cart.gift_certificates|count ==0}

<div style="float:left; display:inline; width:80%; background:#fafafa; border:1px solid #eee; text-align:center; padding:10px 0px; margin-left:66px; margin-top:20px; font:15px trebuchet ms;">
Your Cart is Empty
</div>



{/if}
</div>

<div class="clearboth"></div>
{if $location!="checkout"}
<div style="float:left; display:inline; float: left; font: 12px trebuchet ms;  margin-left:10px; color:#636566; width:320px; margin-top:5px;">
{$lang.cart_instruction_by_admin}
</div>
{*include file="views/checkout/components/checkout_totals_custom.tpl" location="cart_content"*}
<div class="box_paymentcalculations" style="clear:both; width:98%; margin-left:5px; margin-right:5px; float:left;">
    <div class="box_paymentcalculations_row">
        <div class="box_paymentcalculations_fieldname bold" style="width:450px;">
        {$lang.cart_total} :
        </div>
        <div class="box_paymentcalculations_field bold">
        {include file="common_templates/price.tpl" value=$cart_total}
        <input type="hidden" value={$cart_total} id="cart_price" />
        </div>
    </div>
</div>

<div class="box_functions">
<a href="javascript:return void();" class="cm-notification-close box_functions_button_left box_functions_button_color_gray margin_left_five" title="Continue Shopping">
{$lang.continue_shopping}</a>

<div style="float: left; margin-left:3px; display:none" id="pincode_avail">
    
        <input type="tel" style="border-radius: 5px 5px 5px 5px; width:135px; line-height: 18px; float:left; border-top-right-radius: 0; border-bottom-right-radius: 0; border: 1px solid rgb(204, 204, 204); padding: 4px;" name="pincode" id="pincode" onchange="pincode_validate()" placeholder="Enter Pincode" maxlength="6"> 
    
        <a rev="cart_status" onclick="return false;" class="cm-ajax box_functions_button" id="check_but" href="index.php?dispatch=checkout.validate_pin&pincode=" style="border-top-left-radius: 0; border-bottom-left-radius: 0; cursor:pointer;">{$lang.check}</a>
         
        {if !isset($invalid_pin)}
         {assign var ="invalid_pin" value=''}
        {/if}
        
        {if $invalid_pin == '-1'}
            <div style="color: rgb(255, 0, 0); float: left; clear: both; font-size: 12px; margin: 5px 0px 10px 8px;">
            {$lang.invalid_pincode}
            </div>
        {/if}
</div>   

<div id="change_pin" class="pincode_prd_page_blk" style="display:none; float: left; margin-left: 10px;">
        <span>{$lang.shipping_to}:<span id="pin_display"></span></span><a class="ahover_nl pincode_change" onclick="change_pincode(); return false;"> {$lang.change_pin}</a>
</div>


{literal}
<script type="text/javascript">
   // $('#pincode_avail').hide();
       
    var cookie_pincode = ReadCookie('pincode');
   $('#pin_display').text(cookie_pincode);
    if(cookie_pincode == ''){
        $('#pincode_avail').show();      
    }
    else{
        $('#change_pin').show();
       }
     var invalid_pin = {/literal}'{$invalid_pin}';{literal}
     if(invalid_pin == '-1')
     {
         $('#pincode_avail').show(); 
         $('#change_pin').hide();
     }
       
 </script>
 {/literal}
 
 
          
<!--<a href="index.php?dispatch=checkout.checkout&edit_step=step_two" class="box_functions_button margin_right_fifteen" title="Checkout">Checkout</a>-->
<a href="{$config.https_location}/index.php?dispatch=checkout.checkout&edit_step=step_two" class="box_functions_button margin_right_five" title="Checkout">{$lang.place_this_order}</a>
</div>
{/if}

{*{if $settings.DHTML.ajax_add_to_cart != "Y" && $settings.General.redirect_to_cart == 'Y'}
    {include file="buttons/continue_shopping.tpl" but_href=$continue_url|default:$index_script but_role="action"}
{else}
    {include file="buttons/continue_shopping.tpl" but_meta="cm-notification-close"}
{/if}
{include file="buttons/checkout.tpl" but_href="checkout.checkout"}*}

{literal}
<script>
function pincode_validate()
{
        var str = document.getElementById('check_but').href;
    var cnt = document.getElementById('pincode').value;
    var ind = str.indexOf('&pincode=');
    var str_pre = str.substr(0,ind);
    str = str_pre + '&pincode=' + cnt;
    document.getElementById('check_but').href = str;
}
function change_pincode()
{
    
    $('#pincode_avail').show();
    $('#change_pin').hide();
}

/*function ReadCookie(cookieName) {
        var theCookie=" "+document.cookie;
        var ind=theCookie.indexOf(" "+cookieName+"=");
        if (ind==-1) ind=theCookie.indexOf(";"+cookieName+"=");
        if (ind==-1 || cookieName=="") return "";
        var ind1=theCookie.indexOf(";",ind+1);
        if (ind1==-1) ind1=theCookie.length; 
        return unescape(theCookie.substring(ind+cookieName.length+2,ind1));


       }*/

       if("{/literal}{$mode}{literal}" == 'add'  && {/literal}{$config.viral_send_status}{literal} ==1)
       {
            fn_update_cart_box();
       }

      // $('.cm-notification-close').click(fn_update_cart_box);

</script>
{/literal} 
