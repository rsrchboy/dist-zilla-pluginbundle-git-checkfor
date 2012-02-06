package Dist::Zilla::Plugin::Git::CheckFor::Fixups;

# ABSTRACT: Check your repo for fixup! and squash! before release

use Moose;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

# we depend on functionality first present in 1.120370
use Dist::Zilla::Plugin::Git::NextVersion 1.120370 ();
use List::Util 'first';
use Git::Wrapper;

# debugging...
#use Smart::Comments;

with
    'Dist::Zilla::Role::BeforeRelease',
    'Dist::Zilla::Role::Git::Repo::More',
    ;

has _next_version_plugin => (

    is      => 'lazy',
    isa     => 'Dist::Zilla::Plugin::Git::NextVersion',
    handles => [ 'last_version' ],
);

sub _build__next_version_plugin {
    my $self = shift @_;

    return
        first { $_->isa('Dist::Zilla::Plugin::Git::NextVersion') }
        @{ $self->zilla->plugins_with(-VersionProvider) }
        ;
}

sub before_release {
    my $self = shift @_;

    my $repo     = $self->_repo;
    my $last_ver = $self->last_version;

    ### $last_ver
    my $log_opts = { pretty => 'oneline', 'abbrev-commit' => 1 };
    my @logs
        = defined $last_ver
        ? $self->_repo->log($log_opts, "$last_ver..HEAD")
        : $self->_repo->log($log_opts)
        ;

    my $_checker = sub {
        my $lookfor = shift;

        return
            map  { $_ =~ s/\n.*$//; $_          }
            map  { $_->id . ': ' . $_->message  }
            grep { $_->message =~ /^$lookfor! / }
            @logs;
    };

    ### @logs
    my @fixups   = $_checker->('fixup');
    my @squashes = $_checker->('squash');

    if (@fixups || @squashes) {

        $self->log_fatal(
            "Aborting release; found squash or fixup commits:\n\n"
            . join("\n", @fixups)
            . join("\n", @squashes)
            );
    }

    $self->log('No fixup or squash commits found; OK to release');
    return;
}


__PACKAGE__->meta->make_immutable;

!!42;

__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Dist::Zilla>

=cut

