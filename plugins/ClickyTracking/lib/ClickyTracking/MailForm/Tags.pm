package ClickyTracking::MailForm::Tags;
use strict;
use warnings;

our $NAME   = ( split /::/, __PACKAGE__ )[0];
our $PLUGIN = MT->instance()->component( $NAME ); 

sub link {
    my ( $ctx, $args, $cond ) = @_;

    my $site_id = $PLUGIN->get_config_value( 'site_id', 'system' );
    if ( !$site_id ) {
        return;
    }

    require ClickyTracking::Common;
    my ( $uid, $sess_id ) = ClickyTracking::Common::get_data();

    my ( $user_link, $sess_link );
    if ( $uid ) {
        $user_link = ClickyTracking::Common::make_track_user_link(
            $site_id, $uid
        );
    }
    if ( $uid && $sess_id ) {
        $sess_link = ClickyTracking::Common::make_track_sess_link(
            $site_id, $uid, $sess_id
        );
    }

    my $ret = '';
    if ( $sess_link ) {
        $ret .= $PLUGIN->translate( 'Session Tracking' ) . " :\n"
              . $sess_link . "\n";
    }
    if ( $user_link ) {
        $ret .= $PLUGIN->translate( 'User Tracking' ) . " :\n"
              . $user_link . "\n";
    }

    return $ret;
}

1;
__END__
