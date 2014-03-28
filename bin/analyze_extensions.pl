#!/usr/bin/perl

# Copyright (c) 2014 Christian Speckner <cnspeckn@googlemail.com>

# Analyze XML output from php_compatinfo (https://github.com/llaville/php-compat-info).
#
# For each extension, the files referencing it are collected and printed,
# optionally including the referenced functions, classes, constants and
# namespaces.

use strict;
use XML::Parser;

my $currentFile;
my $extensions;
my $inputFile;
my ($blacklist, $whitelist);
my $verbosity = 10;

sub addExtension {
    my $extName = shift;

    return 0 unless $extName;

    if (!exists($extensions->{$extName})) {
        $extensions->{$extName} = {
            name => $extName,
            files => {}
        };
    }

    return $extensions->{$extName};
}

sub addFile {
    my ($extName, $fileName) = @_;

    return 0 unless $fileName;
    my $extension = addExtension($extName) or return 0;

    if (!exists($extension->{files}->{$fileName})) {
        $extension->{files}->{$fileName} = {
            name => $fileName,
            functions => {},
            classes => {},
            constants => {},
            namespaces => {}
        };
    }

    return $extension->{files}->{$fileName};
}

sub addLeaf {
    my ($type, $extName, $fileName, $name, $count) = @_;

    return 0 unless $name;
    my $file = addFile($extName, $fileName) or return 0;

    return $file->{$type}->{$name} = {
        name => $name,
        count => $count
    };
}

sub handleStart {
    shift;
    my $tagname = shift;
    my %attrs;
    while (@_) {
        my $attr = shift;
        my $value = shift;
        $attrs{$attr} = $value;
    }

    my %leaves = (
        function => "functions",
        class => "classes",
        namespace => "namespaces",
        constant => "constants"
    );

    if ($tagname eq "file" && exists($attrs{name})) {
        $currentFile = $attrs{name};
    }

    return unless $currentFile;

    if ($tagname eq "extension") {
        addExtension($attrs{name});
    }

    foreach my $leaf (%leaves) {
        if ($tagname eq $leaf) {
            addLeaf($leaves{$leaf}, $attrs{extension}, $currentFile, $attrs{name}, $attrs{count});
        }
    }
}

sub skipExtension {
    my $extName = shift;

    return $blacklist->{$extName} if ($blacklist);
    return !$whitelist->{$extName} if ($whitelist);
    return 0;
}

sub printExtension {
    my ($extension, $intent) = @_;
    $intent = ($intent or "");

    return if (skipExtension($extension->{name}));

    print ($intent, "Extension '$extension->{name}'", "\n");
    if ($verbosity > 1) {
        foreach my $file (values($extension->{files})) {
            printFile($file, $intent . "   ");
        }

        print "\n" ;
    }
}

sub printFile {
    my ($file, $intent) = @_;
    $intent = ($intent or "");

    my %leaves = (
        functions => "Functions",
        classes => "Classes",
        constants => "Constants",
        namespaces => "Namespaces"
    );

    print ($intent, "File '$file->{name}'", "\n");
    if ($verbosity > 2) {
        foreach my $leaf (keys(%leaves)) {

            if (keys($file->{$leaf})) {

                print ($intent, "   $leaves{$leaf}:\n");
                foreach my $leafDef (values($file->{$leaf})){
                    printLeaf($leafDef, $intent . "      ");
                }
            }
        }
    }
}

sub printLeaf {
    my ($leaf, $intent) = @_;
    $intent = ($intent or "");

    print ($intent, sprintf("%4i", $leaf->{count}), ": '$leaf->{name}'", "\n");
}

sub usage {
    my $msg = shift;

    print "$msg\n\n" if ($msg);

    print <<EOI;
usage: analyze_extensions.pl [options] report_file.xml

valid options:

    -v level                                : verbosity
    --whitelist extension[,extension...]    : whitelist extensions
    --blacklist extension[,extension...]    : blacklist extensions

EOI

    exit;
}

sub popArg {
    usage("argument required") unless (@ARGV);

    return shift(@ARGV);
}

sub decodeList {
    my $string = shift;
    my $hash = {};

    foreach my $item (split /,/, $string) {
        $hash->{$item} = 1;
    }

    return $hash;
}

sub parseArgs {
    $inputFile = pop(@ARGV) or usage();

    while (@ARGV) {
        my $arg = popArg();

        if      ($arg eq "-v") {
            $verbosity = 0 + popArg();

        } elsif ($arg eq "--whitelist") {
            $whitelist = decodeList(popArg());

        } elsif ($arg eq "--blacklist") {
            $blacklist = decodeList(popArg());

        } else {
            usage("invalid argument '$arg'");
        }
    }

    usage("you can't use both black- and whitelist") if ($whitelist && $blacklist);
}

parseArgs();

my $parser = new XML::Parser();

$parser->setHandlers(Start => \&handleStart);
$parser->parsefile($inputFile);

foreach my $extension (values(%$extensions)) {
    printExtension($extension);
}
