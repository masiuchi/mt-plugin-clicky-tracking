package ClickyTracking::Tags;
use strict;
use warnings;

our $NAME   = ( split /::/, __PACKAGE__ )[0];
our $PLUGIN = MT->instance()->component( $NAME );

sub tracking_code {
    my ( $ctx, $args, $cond ) = @_;

    my $site_id = $PLUGIN->get_config_value( 'site_id',  'system' );
    if ( !$site_id ) {
        return;
    }

    my $tracking_code = <<"HTMLHEREDOC";
<a title="Web Statistics" href="http://getclicky.com/$site_id"><img alt="Web Statistics" src="//static.getclicky.com/media/links/badge.gif" border="0" /></a>
<script src="//static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init($site_id); }catch(e){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/66557913ns.gif" /></p></noscript>
HTMLHEREDOC
    return $tracking_code;
}

1;
__END__
