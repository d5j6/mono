use Cwd;
use Cwd 'abs_path';
use Getopt::Long;
use File::Basename;
use File::Path;
use POSIX;

my $monoroot = File::Spec->rel2abs(dirname(__FILE__) . "/../..");
my $monoroot = abs_path($monoroot);
my $buildScriptsRoot = "$monoroot/external/buildscripts";

my $build = 1;
my $clean = 1;
my $mcsOnly = 0;
my $skipMonoMake = 0;
my $stevedoreBuildDeps=1;
my $cpus = `sysctl -n hw.ncpu`;
my $targetArch = (POSIX::uname)[4];

# Handy troubleshooting/niche options

# The prefix hack probably isn't needed anymore.  Let's disable it by default and see how things go
my $shortPrefix = 1;

GetOptions(
   "build=i"=>\$build,
   "clean=i"=>\$clean,
   "mcsOnly=i"=>\$mcsOnly,
   'skipmonomake=i'=>\$skipMonoMake,
   'shortprefix=i'=>\$shortPrefix,
   'stevedorebuilddeps=i'=>\$stevedoreBuildDeps,
) or die ("illegal cmdline options");

system(
	"perl",
	"$buildScriptsRoot/build.pl",
	"--build=$build",
	"--clean=$clean",
	"--mcsonly=$mcsOnly",
	"--targetarch=$targetArch",
	"--skipmonomake=$skipMonoMake",
	"--artifact=1",
	"--artifactscommon=1",
	"--forcedefaultbuilddeps=1",
	"--stevedorebuilddeps=$stevedoreBuildDeps",
	"--jobs=$cpus",
	"--shortprefix=$shortPrefix") eq 0 or die ("Failed building mono\n");
