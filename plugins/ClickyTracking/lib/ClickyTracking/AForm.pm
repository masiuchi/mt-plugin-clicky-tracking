package ClickyTracking::AForm;
use strict;
use warnings;

use MT::ClickyTracking;
use ClickyTracking::Common;

our $NAME   = ( split /::/, __PACKAGE__ )[0];
our $PLUGIN = MT->instance()->component( $NAME );

our $SESSION = $PLUGIN->translate( 'session' );
our $USER    = $PLUGIN->translate( 'user' );

sub list_props {
    my $list_props = {
        tracking => {
            label   => $PLUGIN->translate( 'Tracking' ),
            display => 'force',
            order   => 2000,
            html    => \&_html,
        },
    };
    return $list_props;
}

sub _html {
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;

    my $site_id = $PLUGIN->get_config_value( 'site_id', 'system' );
    my $ct      = MT::ClickyTracking->load( $obj->id );

    my $html;
    if ( $site_id && $ct ) {
        my $track_user = ClickyTracking::Common::make_track_user_link(
            $site_id, $ct->uid
        );
        my $track_sess = ClickyTracking::Common::make_track_sess_link(
            $site_id, $ct->uid, $ct->session_id
        );

        $html = '<a href="' . $track_sess . '" target="_blank">' . $SESSION . '</a>'
              . '&nbsp;&nbsp;'
              . '<a href="' . $track_user . '" target="_blank">' . $USER . '</a>';
    } else {
        $html = '';
    }
    return $html;
}

1;
__END__
