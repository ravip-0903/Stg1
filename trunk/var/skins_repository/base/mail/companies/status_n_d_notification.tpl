{* $Id: status_n_d_notification.tpl 12500 2011-05-19 15:41:05Z 2tl $ *}

{include file="letter_header.tpl"}

{$lang.hello},<br /><br />

{$lang.text_company_status_new_to_disable|replace:"[company]":$company_data.company}

<br /><br />

{if $reason}
{$lang.reason}: {$reason}
<br /><br />
{/if}

{include file="letter_footer.tpl"}