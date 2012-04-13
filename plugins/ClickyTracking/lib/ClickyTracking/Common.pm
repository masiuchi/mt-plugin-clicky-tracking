package ClickyTracking::Common;
use strict;
use warnings;

our $NAME   = ( split /::/, __PACKAGE__ )[0];
our $PLUGIN = MT->instance()->component( $NAME );

sub get_data {
    my $site_id  = $PLUGIN->get_config_value( 'site_id',  'system' );
    my $site_key = $PLUGIN->get_config_value( 'site_key', 'system' );
    if ( !$site_id || !$site_key ) {
        return;
    }

    my $ip_addr = $ENV{REMOTE_ADDR};
    if ( !$ip_addr ) {
        return;
    }

    my $url = 'http://api.getclicky.com/api/stats/4'
        . '?site_id='    . $site_id
        . '&sitekey='    . $site_key
        . '&type='       . 'visitors-list'
        . '&date='       . 'last-2-days'
        . '&ip_address=' . $ip_addr
        . '&output='     . 'json'
        . '&limit='      . '1';

    require LWP::Simple;
    my $json = LWP::Simple::get( $url );

    my ( $uid, $sess_id );
    if ( $json =~ m!"uid":"(\d+)"! ) {
        $uid = $1;
    }

    if ( $json =~ m!"session_id":"(\d+)"! ) {
        $sess_id = $1;
    }
    return ( $uid, $sess_id );
}

sub make_track_user_link {
    my ( $site_id, $uid ) = @_;

    my $link = 'http://getclicky.com/help/api#/stats/visitors'
        . '?site_id=' . $site_id
        . '&uid='     . $uid;

    return $link;
}

sub make_track_sess_link {
    my ( $site_id, $uid, $sess_id ) = @_;

    my $link = 'http://getclicky.com/help/api#/stats/visitors-actions'
        . '?site_id='    . $site_id
        . '&uid='        . $uid
        . '&session_id=' . $sess_id;

    return $link;
}

1;
__END__
