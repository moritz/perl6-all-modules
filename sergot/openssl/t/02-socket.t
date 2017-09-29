use OpenSSL;
use Test;

plan 4;

unless %*ENV<NETWORK_TESTING> {
    diag "NETWORK_TESTING was not set";
    skip-rest("NETWORK_TESTING was not set");
    exit;
}

check(fetch('google.com', '/'));

sub check($result) {
    if $result ~~ /200 \s+ OK/ {
        pass 'Got good response';
    }
    elsif $result ~~ /302 \s+ Found/ && $result ~~ /^^'Location:' \s* $<location>=[\N+]/ {
        diag 'Got a redirect, following...';
        subtest {
            check(fetch('google.com', $<location>));
        }, 'Got good response after redirection';
    }
    else {
        fail 'Got good response';
    }
}

sub fetch($host, $url) {
    my $ssl = OpenSSL.new(:client);
    my $s = IO::Socket::INET.new(:$host, :port(443));
    is $ssl.set-socket($s), 0, 'set-socket success';
    $ssl.set-connect-state;
    is $ssl.connect, 1, 'connect success';
    is $ssl.write("GET $url HTTP/1.1\r\nHost:www.$host\r\nConnection:close\r\n\r\n"), 46 + $url.chars + $host.chars, 'write success';

    #slurp it all up
    my $result = '';
    loop {
        my $tmp = $ssl.read(1024);
        if $tmp.chars {
            $result ~= $tmp;
        } else {
            last;
        }
    }

    $ssl.close;
    $s.close;
    $result
}
