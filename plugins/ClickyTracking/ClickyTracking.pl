package MT::Plugin::ClickyTracking;
use strict;
use warnings;
use base 'MT::Plugin';

our $NAME    = ( split /::/, __PACKAGE__ )[-1];
our $VERSION = '0.01';
our $SCHEMA  = '0.4';

my $plugin   = __PACKAGE__->new({
    name        => $NAME,
    id          => lc $NAME,
    key         => lc $NAME,
    l10n_class  => $NAME . '::L10N',
    version     => $VERSION,
    schema_version => $SCHEMA,
    author_name => 'masiuchi',
    author_link => 'http://d.hatena.ne.jp/masiuchi/',
    plugin_link => 'https://github.com/masiuchi/mt-plugin-clicky-tracking',
    description => '<__trans phrase="Using Clicky for user tracking.">',
    settings    => MT::PluginSettings->new([
        [ 'site_id',  { Default => undef, Scope => 'system' } ],
        [ 'site_key', { Default => undef, Scope => 'system' } ],
    ]),
    system_config_template => 'system_config.tmpl',
});
MT->add_plugin( $plugin );

sub init_registry {
    my ( $p ) = @_;
    my $pkg   = '$' . $NAME . '::' . $NAME;
    $p->registry({
        object_types => {
            clicky_tracking => 'MT::ClickyTracking',
        },
        applications => {
            cms => {
                methods => {
                    ct_get_data => $pkg . '::CMS::get_data',
                    ct_stats    => $pkg . '::CMS::stats',
                },
                menus   => {
                    'tools:clicky_stats' => {
                        label => 'Clicky Stats',
                        mode  => 'ct_stats',
                        order => 1000,
                        view  => [ 'system' ],
                    },
                },
            },
        },
        tags => {
            function => {
                CTTrackingCode => $pkg . '::Tags::tracking_code',
                CTMailFormLink => $pkg . '::MailForm::Tags::link',
            },
        },
        callbacks => {
            'AFormEngineCGI::template_source.aform_confirm'
                => $pkg . '::AForm::Callbacks::tmpl_src_aform_confirm',
            'aform_after_store'
                => $pkg . '::AForm::Callbacks::aform_after_store',
        },
        list_properties => {
            aform_data => $pkg . '::AForm::list_props',
        },
    });
}

1;
__END__
