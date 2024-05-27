# Dimensions Badge

This plugin will display a Dimensions badge in your repository on an item page, if that item has a suitable identifier - a DOI, PubMed ID or Dimensions ID.

Please note the following, from the [Dimensions Badge page](https://badge.dimensions.ai/#terms): 
> If you represent an academic institution, you can also use the badges and metrics API for free. The first thing you need to do is register some simple details with us here. You're then permitted to use the badges on your websites in respect of work related to your institution, provided the websites are open to everyone and otherwise non-commercial (but we don't mind if they include adverts).

## DESCRIPTION

By default this module will render a box on the EPrint summary page that will be
populated with a Dimensions badge if the item has an appropraite identifier, and
there is some Dimensions data for the item.

There is also an EPScript method that can be called on an EPrint e.g. in a citation file.
This allows a test to be conducted to see if the EPrint has enough data to make a Dimensions
badge applicable, and also to render the badge. This can be used if the default EPrints Boxes
are not used for rendering the summary page:

```xml  
<epc:if test="$item.dimensions_badge(1)">
  <div id="summary_dimensions" class="summary-widget">
    <h2>Dimensions</h2>
    <epc:print expr="$item.dimensions_badge()" />
  </div>
</epc:if>
```

Calling the method without a value will render the badge:
```xml
<epc:print expr="$item.dimensions_badge()" />
```

Passing a parameter to the method will return a boolean to show whether the badge could be rendered:
```xml
<epc:if test="$item.dimensions_badge(1)">
```


The display of the badge can be altered by updating the configuration in the
`z_dimensions_badge.pl` configuration file.

For a full description of the Dimensions badge, please see https://badge.dimensions.ai/.

If you want to use the 'hide zero citations' option for the badge, please read the notes in 
`z_dimensions_badge.pl`. There is a javascript file included with this plugin but you may
wish to add it to the 'auto' directory, or include a different javascript file if you are using
any custom rendering. Please see https://github.com/eprintsug/dimensions-badge/issues/1 for
some additional details. 

## BUGS

Please view https://github.com/eprintsug/dimensions-badge/issues/ for details of
any known bugs, or to submit reports of any bugs you have discovered. 

## AVAILABILITY

This module should be available via the EPrints Bazaar https://bazaar.eprints.org/.

The code lives at https://github.com/eprintsug/dimensions-badge/.

## AUTHOR

John Salter https://orcid.org/0000-0002-8611-8266 - https://github.com/jesusbagpuss/

