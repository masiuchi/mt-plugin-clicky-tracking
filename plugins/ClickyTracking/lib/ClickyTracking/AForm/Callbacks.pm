package ClickyTracking::AForm::Callbacks;
use strict;
use warnings;

our $NAME   = ( split /::/, __PACKAGE__ )[0];
our $PLUGIN = MT->instance()->component( $NAME );

sub tmpl_src_aform_confirm {
    my ( $cb, $app, $tmpl ) = @_;

    my $insert_point = quotemeta(<<'HTMLHEREDOC');
    <mt:var name="hidden_params">
HTMLHEREDOC

    require ClickyTracking::Common;
    my ( $uid, $sess_id ) = ClickyTracking::Common::get_data();
    if ( !$uid && !$sess_id ) {
        return;
    }

    my $insert = <<"HTMLHEREDOC";
    <input type="hidden" name="uid" value="$uid" />
    <input type="hidden" name="session_id" value="$sess_id" />
HTMLHEREDOC

    $$tmpl =~ s!($insert_point)!$insert$1!;
}

sub aform_after_store {
    my ( $cb, $id, $fields, $app, $aform_data ) = @_;

    require MT::ClickyTracking;
    my $uid = MT::ClickyTracking->new();

    $uid->id( $aform_data->id );
    $uid->uid( $app->param( 'uid' ) );
    $uid->session_id( $app->param( 'session_id' ) );

    $uid->save();
}

1;
__END__
