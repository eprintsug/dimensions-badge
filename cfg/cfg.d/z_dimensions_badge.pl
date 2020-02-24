########################################################################################
# Dimensions Summary Page Widget
#
# See: https://badge.dimensions.ai
#
########################################################################################

# Enable the widget
$c->{plugins}{"Screen::EPrint::Box::DimensionsBadge"}{params}{disable} = 0;

# Function to return id type and id.
# 	Supported id_types are listed on https://badge.dimensions.ai/.
# 	In 2019-02, doi, pmid and DimensionsIDs (id) are supported.
#
# 	If an EPrint has multiple usable identifiers, the first returned 
# 	value will be used.
#
#	Also, if for some reason you wanted to *not* show a Dimensions badge for an item, returning 
#	no value from this will not show a badge. 
$c->{'dimensions_badge'}->{get_type_and_id} = sub {
        my( $eprint ) = @_;

        if( $eprint->exists_and_set( "doi" ) ){
                return( "doi", $eprint->value( "doi" ) );
        }
        if( $eprint->exists_and_set( "pmid" ) ){
                return( "pmid", $eprint->value( "pmid" ) );
        }

		# id_numbers that have 10. in them (rudimentary doi check)
        if( $eprint->exists_and_set( "id_number" ) && ( $eprint->value( "id_number" ) =~ /\b10./ ) ){
		        
                return( "doi", $eprint->value( "id_number" ) );	
	}

	#other fields could be checked and returned here.
};

# Position
#	By default the Box plugins will appear at position 1000 of the 'summary_right' area.
#	To change the position of the Dimensions badge within this area, alter the value below:
#$c->{plugins}->{"Screen::EPrint::Box::DimensionsBadge"}->{appears}->{summary_right} = 500;
#
#	To stop the badge appearing in the summary_right area, un-set the value:
#$c->{plugins}->{"Screen::EPrint::Box::DimensionsBadge"}->{appears}->{summary_right} = undef;
#	To make it appear in other places, define where, and the position:
#$c->{plugins}->{"Screen::EPrint::Box::DimensionsBadge"}->{appears}->{summary_bottom} = 25;


# Badge appearance
#	You can customise how the badge is dispalyed by setting attributes here.
#	For the full list of options, see https://badge.dimensions.ai/#customising.
#	The values here will be set on the <span> element used to create the badge.
#
#$c->{plugins}{"Screen::EPrint::Box::DimensionsBadge"}{params}{data_attributes} = {
#	'data-legend' => 'always',
#	'data-style'  => 'large_circle',
#	'data-hide-zero-citations' => 'true',
#};

# Hide zero citations - hiding the Box
# 	If you are using the 'data-hide-zero-citations' attributre above, you may wish 
# 	to un-comment the following line, which will ass a link to the javascript file
# 	to the badge, resulting in the EPrints Box being hidden when there are no 
# 	citations.
#	You may also copy the example file to the 'auto' javascript directory, or 
#	include your own custom javscript file if e.g. you are using the Bootstrap 
#	framework in your repository.
#
#$c->{plugins}{"Screen::EPrint::Box::DimensionsBadge"}{params}{zero_citation_js_url} = "/javascript/dimensions-badge-hide-zero.js";



# Javascript URL
# 	By default the link to the badge javascript is included in the Box, or rendered
# 	with the EPScript methods.
#	You may wish to add the link to the badge javascript to your template, or
#	include it in your page another way. If you do this, you can prevent the default
#	inclusion of the javascript by uncommenting the following line:
#$c->{plugins}{"Screen::EPrint::Box::DimensionsBadge"}{params}{exclude_js} = 1;
#
#	If for some reason you need to set a different URL for the main badge javascript, 
#	you can configure this option:
#$c->{plugins}{"Screen::EPrint::Box::DimensionsBadge"}{params}{js_url} = "https://badge.dimensions.ai/badge.js";
#


