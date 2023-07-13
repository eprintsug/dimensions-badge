/*
 * The prototype.js Element.observe method for some reason fails to capture
 * the dimensions_embed:hide event, so addEventListener isused instead
 * See: https://github.com/eprintsug/dimensions-badge/issues/1
 * The same approach is taken here.
 *
 * Find the link from the badge, and add a link with text pointing to the Dimensions site.
 *
*/
document.observe('dom:loaded', function () {
  $$('span.__dimensions_badge_embed__').each(function(el){
    el.addEventListener( 'dimensions_embed:show', function(e){
      var dim_href = this.down('a').getAttribute('href');
      if( typeof dim_href !== undefined )
      {
        this.up().insert('<a href="' + dim_href + '" target="_blank" style="margin-top:10px; display:block;">View citation information on the Dimensions website</a>');
      }
    });
  });
});
