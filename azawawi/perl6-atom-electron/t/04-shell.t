use v6;

use Test;

use lib 'lib';

# Methods to test
my @methods = 'show-item-in-folder', 'open-item', 'open-external',
  'move-item-to-trash', 'beep';

plan @methods.elems + 3;

use Atom::Electron::Shell;
ok 1, "'use Atom::Electron::Shell' worked!";

for @methods -> $method {
  ok Atom::Electron::Shell.can($method), "Shell.$method is found";
}

{
  # Skip tests if the electron executable is not found
  use File::Which;
  unless which('electron') {
    skip-rest("electron is not installed. skipping tests...");
    exit;
  }
}

my $app = Atom::Electron::App.instance;
LEAVE {
  diag 'Destroy electron app';
  $app.destroy;
}

my $file-to-delete = "delete-me.txt";
$file-to-delete.IO.spurt("Hello world");
ok $file-to-delete.IO ~~ :e, "File exists";
Atom::Electron::Shell.move-item-to-trash($file-to-delete);
ok $file-to-delete.IO !~~ :e, "File moved to trash";
