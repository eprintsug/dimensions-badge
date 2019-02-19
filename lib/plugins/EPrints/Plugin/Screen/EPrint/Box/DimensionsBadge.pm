=head1 NAME

EPrints::Plugin::Screen::EPrint::Box::DimensionsBadge

=head1 DESCRIPTION

By default this module will render a box on the EPrint summary page that will be
populdated with a Dimensions badge if the item has an appropraite identifier, and
there is some Dimensions data for the item.

There is also an EPScript method that can be called on an EPrint e.g. in a citation file.
This allows a test to be conducted to see if the EPrint has enough data to make a Dimensions
badge applicable, and also to render the badge. This can be used if the default EPrints Boxes
are not used for rendering the summary page:

  
  <epc:if test="$item.dimensions_badge(1)">
    <div id="summary_dimensions" class="summary-widget">
      <h2>Dimensions</h2>
      <epc:print expr="$item.dimensions_badge()" />
    </div>
  </epc:if>

Calling the method without a value will render the badge:
  <epc:print expr="$item.dimensions_badge()" />

Passing a parameter to the method will return a boolean to show whether the badge could be rendered:
  <epc:if test="$item.dimensions_badge(1)">


The display of the badge can be altered by updating the configuration in the
B<z_dimensions_badge.pl> configuration file.

For a full description of the Dimensions badge, please see L<https://badge.dimensions.ai/>.

=head1 BUGS

Please view L<https://github.com/eprintsug/dimensions-badge/issues/> for details of
any known bugs, or to submit reports of any bugs you have discovered. 

=head1 AVAILABILITY

This module should be available via the EPrints Bazaar L<https://bazaar.eprints.org/>.

The code lives at L<https://github.com/eprintsug/dimensions-badge/>.

=head1 AUTHOR

John Salter L<https://orcid.org/0000-0002-8611-8266> - L<https://github.com/jesusbagpuss/>

=cut


package EPrints::Plugin::Screen::EPrint::Box::DimensionsBadge;

our @ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

use strict;

sub new
{
	my( $class, %params ) = @_;

	my $self = $class->SUPER::new( %params );

	$self->{name} = "Dimensions Badge";
	if( $self->{session}->can_call( "dimensions_badge", "get_type_and_id" ) && defined $self->{processor}->{eprint} )
	{
		my ( $type, $id ) = $self->{session}->call( [ "dimensions_badge", "get_type_and_id" ], $self->{processor}->{eprint} );
		$self->{dimensions_id_type} = $type;
		$self->{dimensions_id} = $id;
	}

	return $self;
}

sub can_be_viewed
{
	my( $self ) = @_;

	return 0 if( !defined $self->{dimensions_id_type} || !defined $self->{dimensions_id} );
	return 1;
}

sub render
{
	my( $self ) = @_;

	my $session = $self->{session};
	my $frag = $session->xml->create_document_fragment;

	return $frag if ( !defined $self->{dimensions_id_type} || !defined $self->{dimensions_id} );

	my $span = $session->make_element( "span",
		class => "__dimensions_badge_embed__",
		"data-$self->{dimensions_id_type}" => $self->{dimensions_id},
		(defined $self->param( 'data_attributes' ) ? %{$self->param( 'data_attributes' )} : undef ),
	);
	$frag->appendChild( $span );

	if( !$self->param( "exclude_js" ) ){
		my $script = $session->make_element( "script",
			src=>( defined $self->param( "js_url" )
				? $self->param( "js_url" )
				: "https://badge.dimensions.ai/badge.js"
			),
			async=>"async",
			charset=> "utf-8"
		);
		$frag->appendChild( $script );
	}

	return $frag;
}


package EPrints::Script::Compiled;

sub run_dimensions_badge
{
	my( $self, $state, $eprint, $test ) = @_;

	if( !defined $eprint->[0] || ref($eprint->[0]) ne "EPrints::DataObj::EPrint" )
	{
		$self->runtime_error( "Can only call dimensions_badge() on eprint objects not ".
			ref($eprint->[0]) );
	}

	my $processor = EPrints::ScreenProcessor->new(
		session => $state->{session},
		eprint => $eprint->[0],
		eprintid => $eprint->[0]->get_id
	);
	
	my $box = $state->{session}->plugin( "Screen::EPrint::Box::DimensionsBadge", processor=>$processor );
	if( !defined $box )
	{
		$self->runtime_error( "Problem creating Screen::EPrint::Box::DimensionsBadge" );
	}

	if( $test )
	{
		return [ 0, "BOOLEAN" ] if( !defined $box || !$box->can_be_viewed );
		return [ 1, "BOOLEAN" ];
	}

	return [ $box->render, "XHTML" ];
}

1;

