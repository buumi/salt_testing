# S44 Update -- updates Spring:1944 from rapid for use by the autohosts
#
# Written in 2014 by Yuriy Chertkov
#
# To the extent possible under law, the author(s) have dedicated all copyright and related and
# neighboring rights to this software to the public domain worldwide. This software is
# distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
package S44Update;

use strict;

use File::Temp qw/ tempfile tempdir /;
use SpadsPluginApi;
use File::Basename;

no warnings 'redefine';

my $pluginVersion='0.1';
my $requiredSpadsVersion='0.11.4';

my %globalPluginParams = ( commandsFile => ['notNull'],
                           helpFile => ['notNull'] );

sub getVersion { return $pluginVersion; }
sub getRequiredSpadsVersion { return $requiredSpadsVersion; }
sub getParams { return [\%globalPluginParams,{}]; }

sub new {
  my $class=shift;
  my $self = {};
  bless($self,$class);
  addSpadsCommandHandler({S44Update => \&hSpadsS44Update});
  slog("Plugin loaded (version $pluginVersion)",3);
  return $self;
}

sub onUnload {
  removeSpadsCommandHandler(['S44Update']);
  slog("Plugin unloaded",3);
}

sub hSpadsS44Update {
  my ($source,$user,$p_params,$checkOnly)=@_;
  answer("updating Spring 1944...");
  # create a temp file with some name
  my ($fh, $filename) = tempfile();
  binmode $fh, ":utf8";
  close $fh;
  forkProcess( sub { dlStart($user, $filename); }, sub { dlEnd($user, $filename, @_); } );
}

sub dlStart {
  my ($user, $filename)=@_;
  my $springServerPath = getSpadsConf()->{springServer};
  my $springServerDir = dirname($springServerPath);
  system("$springServerDir/pr-downloader --filesystem-writepath /data/users/s44/spads/game_data --rapid-download s44:test>>$filename 2>&1");
  exit 0;
}

sub dlEnd {
  my ($user, $filename, $rc)=@_;
  return unless(getLobbyState() > 3 && exists getLobbyInterface()->{users}->{$user});
  if($rc != 0) {
    my $message="Failed to update!";
    slog("$message (by $user)",2);
    sayPrivate($user,"$message.");
  }else{
    slog("Updated S44 from rapid (by $user)",3);
	if (open (my $fh, "<", $filename))
	{
		binmode $fh, ":utf8";
		while (my $line = <$fh>)
		{
			sayPrivate($user, "$line");
		}
		close $fh;
	} else {
		sayPrivate($user, "Failed to open response file: $filename");
	}
    sayPrivate($user,"Update finished.");
  }
  unlink $filename;
}

1;
