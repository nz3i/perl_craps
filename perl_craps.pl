#!/usr/bin/perl
use strict;
use warnings;
use Term::ReadKey;

my $purse = 20;
my $wager;
my $come_out = 1;
my $game_loop = 1;
my $point;

print "You have \$$purse.00.\n";
while ($game_loop) {
    if ($come_out) {
        $wager = get_wager($purse);
        process_come_out_roll();
    } else {
        process_point_roll();
    }
}

sub process_come_out_roll {
    print "Press any key to roll dice\n";
    ReadMode('cbreak');
    my $key = ReadKey(0);
    ReadMode('normal');
    my $sum = roll_dice();

    if ($sum == 2 || $sum == 3 || $sum == 12) {
        print "Crap out, you lose\n";
        $purse -= $wager;
        print_total($purse);
        $game_loop = continue_game($purse);
    } elsif ($sum == 7 || $sum == 11) {
        print "Natural, you win\n";
        $purse += $wager;
        print_total($purse);
        $game_loop = continue_game($purse);
    } else {
        $point = $sum;
        print "Point to roll is $point\n";
        $come_out = 0;
    }
}

sub process_point_roll {
    print "\nPress any key to roll again....";
    ReadMode('cbreak');
    my $key = ReadKey(0);
    ReadMode('normal');
    my $sum = roll_dice();
    print "Sum is $sum\n";

    if ($sum == 7) {
        print "You lose\n";
        $purse -= $wager;
        print_total($purse);
        $game_loop = continue_game($purse);
    } elsif ($sum == $point) {
        print "You win\n";
        $purse += $wager;
        print_total($purse);
        $come_out = 1;
        $game_loop = continue_game($purse);
    } else {
        print "Roll again\n";
    }
}

sub roll_dice {
    my $random1 = int(rand(6) + 1);
    my $random2 = int(rand(6) + 1);
    my $sum = $random1 + $random2;
    print "$random1 + $random2 = $sum\n";
    return $sum;
}

sub get_wager {
    my ($purse) = @_;
    my $wager;
    do {
        print "Enter your wager: ";
        $wager = <STDIN>;
        chomp $wager;
        if ($wager !~ /^\d+$/ || $wager > $purse || $wager <= 0) {
            print "Enter a positive number up to your total purse ($purse).\n";
        }
    } while ($wager !~ /^\d+$/ || $wager > $purse || $wager <= 0);
    return $wager;
}

sub continue_game {
    my ($purse) = @_;
    if ($purse > 0) {
        print "Continue game? (Y or N): ";
        my $choice = <STDIN>;
        chomp $choice;
        return lc($choice) eq 'y' ? 1 : 0;
    } else {
        print "You are out of money! Game over!\n";
        return 0;
    }
}

sub print_total {
    my ($purse) = @_;
    print "Your total is \$$purse.00\n";
}

