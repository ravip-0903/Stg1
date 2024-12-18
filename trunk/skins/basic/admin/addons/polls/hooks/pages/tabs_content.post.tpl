{* $Id: tabs_content.post.tpl 11823 2011-02-11 15:55:09Z zeke $ *}

{if $page_type == $smarty.const.PAGE_TYPE_POLL}
	<div id="content_poll">

		<div class="form-field">
			<label for="poll_show_results">{$lang.poll_show_results}:</label>
			<input type="hidden" name="page_data[poll_data][show_results]" value="N" />
			<input type="checkbox" class="checkbox" name="page_data[poll_data][show_results]" id="poll_show_results" value="Y"{if $page_data.poll.show_results == "Y"} checked="checked"{/if} />
		</div>

		<div class="form-field">
			<label for="poll_header">{$lang.poll_header}:</label>
			<textarea name="page_data[poll_data][header]" id="poll_header" cols="50" rows="5" class="cm-wysiwyg input-textarea-long input-fill">{$page_data.poll.header}</textarea>
			
		</div>

		<div class="form-field">
			<label for="poll_footer">{$lang.poll_footer}:</label>
			<textarea name="page_data[poll_data][footer]" id="poll_footer" cols="50" rows="5" class="cm-wysiwyg input-textarea-long input-fill">{$page_data.poll.footer}</textarea>
			
		</div>

		<div class="form-field">
			<label for="poll_results">{$lang.poll_results}:</label>
			<textarea name="page_data[poll_data][results]" id="poll_results" cols="50" rows="5" class="cm-wysiwyg input-textarea-long input-fill">{$page_data.poll.results}</textarea>
			
		</div>

	</div>
{/if}