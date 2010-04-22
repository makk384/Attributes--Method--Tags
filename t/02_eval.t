#!/usr/bin/perl

package Foo;

use Attribute::Method::Tags;
use Attribute::Method::Tags::Registry;
use Test::More tests => 3;

# can't tag methods in a string eval block
{
    eval "sub fi : Tags( foo ) {}";
    like(
        $@,
        qr/^Cannot tag anonymous subs at file \(eval/,
        "expected error when defining subs in string eval"
    );
}

# adding same method twice raises error
{
    sub fee : Tags( bar ) {}

    eval {
        Attribute::Method::Tags::Registry->add('Foo', 'fee', [qw(foo bar)]);
    };
    like(
        $@,
        qr/tags for Foo->fee already exists, method redefinition perhaps/,
        "expected error when adding tags for an already-registered method"
    );
}

# adding non alphanumeric tags
{
    sub fo : Tags( bar ) {}

    eval {
        Attribute::Method::Tags::Registry->add('Foo', 'fo', [ qw( !!! )]);
    };
    like(
        $@,
        qr/^tags must be alphanumeric/,
        "tags must be alphanumeric"
    );
}
