package MT::ClickyTracking;
use strict;
use warnings;
use base 'MT::Object';

__PACKAGE__->install_properties({
    column_defs => {
        id         => 'integer not null',
        uid        => 'string(10) not null',
        session_id => 'string(9) not null',
    },
    indexes     => {
        id         => 1,
        uid        => 1,
        session_id => 1,
    },
    datasource  => 'clicky_tracking',
    primary_key => 'id',
});

1;
__END__
