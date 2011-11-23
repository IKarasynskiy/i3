#!perl
# vim:ts=4:sw=4:expandtab
#
# Regression: when resizing two containers on a workspace, opening a floating
# client, then closing it again, i3 will re-distribute the space on the
# workspace as if a tiling container was closed, leading to the containers
# taking much more space than they possibly could.
#
use i3test;
use List::Util qw(sum);

my $tmp = fresh_workspace;

my $first = open_window;
my $second = open_window;

my ($nodes, $focus) = get_ws_content($tmp);
my $old_sum = sum map { $_->{rect}->{width} } @{$nodes};

cmd 'resize grow left 10 px or 25 ppt';
cmd 'split v';

sync_with_i3;

my $third = open_window;

cmd 'mode toggle';
sync_with_i3;

cmd 'kill';
sync_with_i3;

($nodes, $focus) = get_ws_content($tmp);
my $new_sum = sum map { $_->{rect}->{width} } @{$nodes};

is($old_sum, $new_sum, 'combined container width is still equal');

done_testing;
