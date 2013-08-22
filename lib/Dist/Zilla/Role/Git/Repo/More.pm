package Dist::Zilla::Role::Git::Repo::More;

# ABSTRACT: A little more than Dist::Zilla::Role::Git::Repo

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

use Git::Wrapper;

with
    'Dist::Zilla::Role::Git::Repo',
    ;

has _repo => (is => 'lazy', isa => 'Git::Wrapper');
sub _build__repo { Git::Wrapper->new(shift->repo_root) }


# -- attributes

#has version_regexp => (is => 'rwp', isa=>'Str', lazy => 1, predicate => 1, builder => sub { '^v(.+)$' });
#has first_version  => (is => 'rwp', isa=>'Str', lazy => 1, predicate => 1, default => sub { '0.001' });

has _previous_versions => (

    traits  => ['Array'],
    is      => 'lazy',
    isa     => 'ArrayRef[Str]',
    handles => {

        has_previous_versions => 'count',
        previous_versions     => 'elements',
        earliest_version      => [ get =>  0 ],
        last_version          => [ get => -1 ],
    },
);

sub _build__previous_versions {
  my ($self) = @_;

  local $/ = "\n"; # Force record separator to be single newline

  my $git  = Git::Wrapper->new( $self->repo_root );
  my $regexp = $self->version_regexp;

  my @tags = $git->tag;
  @tags = map { /$regexp/ ? $1 : () } @tags;

  # find tagged versions; sort least to greatest
  my @versions =
    sort { version->parse($a) <=> version->parse($b) }
    grep { eval { version->parse($_) }  }
    @tags;

  return [ @versions ];
}

# -- role implementation

#sub provide_version {
  #my ($self) = @_;

  ## override (or maybe needed to initialize)
  #return $ENV{V} if exists $ENV{V};

  #return $self->first_version
    #unless $self->has_previous_versions;

  #my $last_ver = $self->last_version;
  #my $new_ver  = Version::Next::next_version($last_ver);
  #$self->log("Bumping version from $last_ver to $new_ver");

  #return "$new_ver";
#}

!!42;

__END__

=head1 SYNOPSIS

    # ta-da!
    with 'Dist::Zilla::Role::Git::Repo::More';

=head1 DESCRIPTION

This is a role that extends L<Dist::Zilla::Role::Git::Repo> to provide an
additional private attribute.  There's probably nothing here you'd be terribly
interested in.

=head1 SEE ALSO

Dist::Zilla::Role::Git::Repo

=cut
