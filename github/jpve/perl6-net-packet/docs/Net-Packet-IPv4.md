<!-- DO NOT EDIT: File generated by docs/Generate.sh -->

NAME
====

Net::Packet::IPv4

SYNOPSIS
========

    use Net::Packet::IPv4 :short;

    my $frame = Buf.new([...]);
    my $ip = IPv4.new($frame);

    say sprintf '%s -> %s: %s',
        $ip.src.Str, $ip.dst.Str, $ip.proto;

EXPORTS
=======

    Net::Packet::IPv4

:short trait adds exports:

    constant IPv4       ::= Net::Packet::IPv4;
    constant IPv4_addr  ::= Net::Packet::IPv4_addr;
    constant IP_proto   ::= Net::Packet::IP_proto;

DESCRIPTION
===========

Net::Packet::IPv4 takes a byte buffer and returns a corresponding packet object. The byte buffer can be of the builtin Buf type or the C_Buf type of Net::Pcap.

class Net::Packet::IPv4
-----------------------

    is Net::Packet::Base

### Attributes

     $.src              is rw is Net::Packet::IPv4_addr
    $.dst              is rw is Net::Packet::IPv4_addr
      Source/destination ip address field.

    $.proto            is rw is Net::Packet::IP_proto
      Protocol field. 

    $.id               is rw is Int
    $.fragment_offset  is rw is Int
    $.flags            is rw is Int
      Identification/Fragment offset/Flags field. All these things
      control fragmentation of IP packets.

    $.ihl              is rw is Int
      Internet Header Length field. Used to specify length of the header.
      IPv4 has extra field for options (option fields are NOT YET
      IMPLEMENTED)
      
    $.dscp             is rw is Int
    $.ecn              is rw is Int
      DSCP/ECN field.  

    $.total_length     is rw is Int
      Total length of packet (fragment) size including header and payload in
      bytes.

    $.ttl              is rw is Int
      Time To Live field. Helps prevent datagrams from going in circles. It
      limits the datagrams lifetime.

    $.hdr_chksum       is rw is Int
      Header checksum field.

### Methods

    .decode($frame, Net::Packet::Base $parent?) returns Net::Packet::IPv4
      Returns the IPv4 packet corresponding to $frame.

    .pl() returns Proxy is rw
      Returns a Proxy for the payload of this packet.
      Usage:
        $eth.pl = ...
        my $ip = $eth.pl.
