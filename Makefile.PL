
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "All Git::CheckFor plugins at once",
  "AUTHOR" => "Chris Weyl <cweyl\@alumni.drew.edu>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Dist-Zilla-PluginBundle-Git-CheckFor",
  "EXE_FILES" => [],
  "LICENSE" => "lgpl",
  "NAME" => "Dist::Zilla::PluginBundle::Git::CheckFor",
  "PREREQ_PM" => {
    "Dist::Zilla::Plugin::Git::NextVersion" => "1.120370",
    "Dist::Zilla::Role::BeforeRelease" => 0,
    "Dist::Zilla::Role::Git::Repo" => 0,
    "Dist::Zilla::Role::PluginBundle::Easy" => 0,
    "Git::Wrapper" => 0,
    "IPC::System::Simple" => 0,
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "Moose" => 0,
    "Moose::Autobox" => 0,
    "Moose::Role" => 0,
    "MooseX::AttributeShortcuts" => 0,
    "Try::Tiny" => 0,
    "autodie" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Capture::Tiny" => 0,
    "Env::Path" => 0,
    "File::Spec" => 0,
    "File::chdir" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Path::Class" => 0,
    "Test::CheckDeps" => "0.007",
    "Test::DZil" => 0,
    "Test::Fatal" => 0,
    "Test::Moose::More" => "0.008",
    "Test::More" => "0.94",
    "Test::Most" => 0,
    "Test::TempDir" => 0
  },
  "VERSION" => "0.007",
  "test" => {
    "TESTS" => "t/*.t t/plugin/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



