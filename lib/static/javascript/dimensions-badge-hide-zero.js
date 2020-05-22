/*
 * The prototype.js Element.observe method for some reason fails to capture
 * the dimensions_embed:hide event, so addEventListener isused instead
 * See: https://github.com/eprintsug/dimensions-badge/issues/1
*/
document.observe('dom:loaded', function () {
  $$('span.__dimensions_badge_embed__').each(function(el){
    el.addEventListener( 'dimensions_embed:hide', function(e){
      e.target.up('.ep_summary_box').hide();
    });
  });
});

