{* $Id: button.tpl 11823 2011-02-11 15:55:09Z zeke $ *}

{if $but_role == "action"}
	{assign var="suffix" value="-action"}
	{assign var="file_prefix" value="action_"}
{elseif $but_role == "act"}
	{assign var="suffix" value="-act"}
	{assign var="file_prefix" value="action_"}
{elseif $but_role == "disabled_big"}
	{assign var="suffix" value="-disabled-big"}
{elseif $but_role == "big"}
	{assign var="suffix" value="-big"}
{elseif $but_role == "delete"}
	{assign var="suffix" value="-delete"}
{elseif $but_role == "tool"}
	{assign var="suffix" value="-tool"}
{else}
	{assign var="suffix" value=""}
{/if}

{if $but_name && $but_role != "text" && $but_role != "act" && $but_role != "delete"} {* SUBMIT BUTTON *}
	{if $but_class == ''}
	<span {if $but_id}id="wrap_{$but_id}"{/if} {if $but_css}style="{$but_css}"{/if} class="button-submit{$suffix}">

	<input {if $but_id}id="{$but_id}"{/if} {if $but_meta}class="{$but_meta}"{/if} {if $but_class}class="{$but_class}"{/if} type="submit" name="{$but_name}" {if $but_onclick}onclick="{$but_onclick}"{/if} value="{$but_text}" />

	</span>
	{else}
	<input {if $but_id}id="{$but_id}"{/if} {if $but_meta}class="{$but_meta}"{/if} {if $but_class}class="{$but_class}"{/if} type="submit" name="{$but_name}" {if $but_onclick}onclick="{$but_onclick}"{/if} value="{$but_text}" style="curser:hand; cursor:pointer;" />

	{/if}

{elseif $but_role == "text" || $but_role == "act" || $but_role == "edit" || ($but_role == "text" && $but_name)} {* TEXT STYLE *} {*Removed text-button*}

	<a class="{if $but_meta}{$but_meta} {/if}{if $but_name}cm-submit-link {/if}{$suffix}"{if $but_id} id="{$but_id}"{/if}{if $but_name} name="{$but_name|replace:"[":":-"|replace:"]":"-:"}"{/if}{if $but_href} href="{$but_href|fn_url}"{/if}{if $but_onclick} onclick="{$but_onclick} return false;"{/if}{if $but_target} target="{$but_target}"{/if}{if $but_rel} rel="{$but_rel}"{/if}{if $but_rev} rev="{$but_rev}"{/if}>{$but_text}</a>

{elseif $but_role == "delete"}

	<a {if $but_id}id="{$but_id}"{/if}{if $but_name} name="{$but_name|replace:"[":":-"|replace:"]":"-:"}"{/if} {if $but_href}href="{$but_href|fn_url}"{/if}{if $but_onclick} onclick="{$but_onclick} return false;"{/if}{if $but_meta} class="{$but_meta}"{/if}{if $but_target} target="{$but_target}"{/if}{if $but_rev} rev="{$but_rev}"{/if}><img src="{$images_dir}/icons/icon_delete_small.gif" width="10" height="9" border="0" alt="{$lang.delete}" title="{$lang.delete}" /></a>

{elseif $but_role == "icon"} {* LINK WITH ICON *}
	<a {if $but_id}id="{$but_id}"{/if}{if $but_href} href="{$but_href|fn_url}"{/if} {if $but_onclick}onclick="{$but_onclick};{if !$allow_href} return false;{/if}"{/if} {if $but_target}target="{$but_target}"{/if} {if $but_rev} rev="{$but_rev}"{/if} class="{if $but_meta} {$but_meta}{/if}">{$but_text}</a>

{else} {* BUTTON STYLE *}

	<span class="button{$suffix}" {if $but_id}id="{$but_id}"{/if}><a {if $but_href}href="{$but_href|fn_url}"{/if}{if $but_onclick} onclick="{$but_onclick} return false;"{/if} {if $but_target}target="{$but_target}"{/if} class="{if $but_meta}{$but_meta} {/if}" {if $but_rev}rev="{$but_rev}"{/if}>{$but_text}</a></span>

{/if}
