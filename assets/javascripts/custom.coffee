jQuery ->
  jQuery('.page-note-show .action a.delete').click (evt)->
    res = window.confirm "确定删除吗?"
    if res == true
      note_id = jQuery(this).data("noteid")
      jQuery.ajax
        url: "/notes/#{note_id}/destroy"
        method: 'DELETE',
        statusCode:
          200: ()->
            window.location.href = "/"




