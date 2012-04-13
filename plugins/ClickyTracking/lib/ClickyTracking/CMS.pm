package ClickyTracking::CMS;
use strict;
use warnings;

our $NAME   = ( split /::/, __PACKAGE__ )[0];
our $PLUGIN = MT->instance()->component( $NAME );

sub get_data {
    my ( $app ) = @_;

    my $site_id  = $PLUGIN->get_config_value( 'site_id',  'system' );
    my $site_key = $PLUGIN->get_config_value( 'site_key', 'system' );
    if ( !$site_id || !$site_key ) {
        return _json_error();
    }

    my $ip_addr = $ENV{REMOTE_ADDR};
    if ( !$ip_addr ) {
        return _json_error();
    }

    my $url = 'http://api.getclicky.com/api/stats/4'
        . '?site_id=' . $site_id
        . '&sitekey=' . $site_key
        . '&type='    . 'visitors-list'
        . '&date='    . 'last-2-days'
        . '&output='  . 'json'
        . '&limit='   . '1';

    require LWP::Simple;
    my $xml = LWP::Simple::get( $url );

    my ( $uid, $session_id ) ;
    if ( $xml =~ m!"uid":"(\d+)"! ) {
        $uid = $1;
    }
    if ( $xml =~ m!"session_id":"(\d+)"! ) {
        $session_id = $1;
    }
    if ( !$uid && !$session_id ) {
        return _json_error();
    }

    $app->send_http_header( 'text/javascript+json' );
    $app->{no_print_body} = 1;
    require MT::Util;
    return $app->print_encode(
        MT::Util::to_json({
            error => undef,
            result => {
                uid         => $uid,
                session_id => $session_id,
            }
        })
    );
}

sub _json_error {
    my ( $app ) = @_;
    $app->send_http_header( 'text/javascript+json' );
    $app->{no_print_body} = 1;
    require MT::Util;
    return $app->print_encode(
        MT::Util::to_json({ error => 1 })
    );
}

sub stats {
    my ( $app ) = @_;

    my $param = {
        site_id  => $PLUGIN->get_config_value( 'site_id',  'system' ),
        site_key => $PLUGIN->get_config_value( 'site_key', 'system' ),
    };

    return $PLUGIN->load_tmpl( 'cms/stats.tmpl', $param );
}

1;
__END__
