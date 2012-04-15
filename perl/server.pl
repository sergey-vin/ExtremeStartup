#!/usr/bin/perl

use IO::Socket; 
use strict;
use Data::Dumper;

sub isPrime($)
{
  my ($n) = @_;
  my @ar;
  for (my $i = 2; $i < $n; $i++)
  {
    my $start = $i * 2;
    while ($start <= $n)
    {
      $ar[$start] = 1;
      $start += $i;
    }
  }
  return $ar[$n] < 1;
}

sub isSQ($)
{
  my ($n) = @_;
  my @ar;
  my $isS = 0; # square
  my $isQ = 0; # cube
  for (my $i = 2; $i <= sqrt($n); $i++)
  {
     if ($i*$i == $n)
     {
        $isS = 1;
        last;
     }
  }
  if ($isS)
  {
    for (my $i = 2; $i < sqrt($n); $i++)
    {
       if ($i*$i*$i == $n)
       {
          $isQ = 1;
          last;
       }
    }

  }
  return $isQ;
}

my $old_name = '';

sub solve {
	my ($input) = @_;

  my $input_decode = $input;
  $input_decode =~ s/%20/ /g;
  print Dumper "requst: $input_decode";
  if ($input =~ /what%20is%20your%20name/)
  {
    $input = 'Sergey 2';
  }
  elsif ($input_decode =~/what is (\d+) plus (\d+) divided by (\d+)/)
  {
    $input = $1 + $2 / $3;
  }
  elsif ($input_decode =~/what is (\d+) plus (\d+) multiplied by (\d+)/)
  {
    $input = $1 + $2 * $3;
  }
  elsif ($input_decode =~/what is (\d+) minus (\d+) divided by (\d+)/)
  {
    $input = $1 - $2 / $3;
  }
  elsif ($input_decode =~/what is (\d+) minus (\d+) multiplied by (\d+)/)
  {
    $input = $1 - $2 * $3;
  }

  elsif ($input_decode =~/what is (\d+) divided by (\d+) minus (\d+)/)
  {
    $input = $1 / $2 - $3;
  }
  elsif ($input_decode =~/what is (\d+) divided by (\d+) plus (\d+)/)
  {
    $input = $1 / $2 + $3;
  }
  elsif ($input_decode =~/what is (\d+) multiplied by (\d+) minus (\d+)/)
  {
    $input = $1 * $2 - $3;
  }
  elsif ($input_decode =~/what is (\d+) multiplied by (\d+) plus (\d+)/)
  {
    $input = $1 * $2 + $3;
  }
  elsif ($input =~ /what%20is%20(\d+)%20plus%20(\d+)/)
  {
    $input = $1 + $2;
  }
  elsif ($input_decode =~ /is the largest/)
  {
    my $max = -1000000000;
    $input_decode =~ s/^.*is the largest: //;
    $input_decode =~ s/(\d+)/$max = $1 if ($max < $1) /gsex;
    $input = $max;
  }
  elsif ($input_decode =~ /what is (\d+) plus (\d+)/)
  {
    $input = $1 + $2;
  }
  elsif ($input_decode =~/which city is the Eiffel tower/)
  {
    $input = 'Paris';
  }
  elsif ($input_decode =~ /my name is (.*?). what is my name/)
  {
    $old_name = $input = $1;
  }
  elsif ($input_decode =~/I was here before. what is my name/)
  {
    $input = $old_name;
  }
  elsif ($input_decode =~ /what is the twitter id of the organizer of this dojo/)
  {
    $input = '@oslocodingdojo';
  }
  elsif ($input_decode =~ /what is (\d+) multiplied by (\d+)/)
  {
    $input = $1 * $2;
  }
  elsif ($input_decode =~ /what colour is a banana/)
  {
    $input = 'yellow';
  }
  elsif ($input_decode =~/what is (\d+) plus (\d+)/)
  {
    $input = $1 + $2;
  }
  elsif ($input_decode =~/what is (\d+) minus (\d+)/)
  {
    $input = $1 - $2;
  }
  elsif ($input_decode =~/what is (\d+) divided by (\d+)/)
  {
    $input = $1 / $2 if $2 != 0;
    $input = '' if $2 == 0;
  }
  elsif ($input_decode =~/who is the Prime Minister of Great Britain/)
  {
    $input = 'David Cameron';
  }
  elsif ($input_decode =~/what currency did Spain use before the Euro/)
  {
    $input = 'peseta';
  }
  elsif ($input_decode =~ /which of the following numbers are primes/)
  {
    my @primes; 
    $input_decode =~ s/^.*which of the following numbers are primes: //;
    $input_decode =~ s/ HTTP.*$//;
    $input_decode =~ s/(\d+)/push @primes, $1 if (isPrime($1)) /gsex;
    $input = join ', ', @primes;
  }
  elsif ($input_decode =~/which of the following numbers is both a square and a cube/)
  {
    my @num;
    $input_decode =~ s/^.*which of the following numbers is both a square and a cube //;
    $input_decode =~ s/ HTTP.*$//;
    $input_decode =~ s/(\d+)/push @num, $1 if (isSQ($1)) /gsex;
    $input = join ', ', @num;
  }

  elsif ($input_decode =~/I want to shop. What products do you have for sale /)
  {
    $input = 'bananas, eggs';
  }
  elsif ($input_decode =~/how many dollars does one (eggs|bananas) cost/)
  {
    $input = '0';
  }
  elsif ($input_decode =~/what is my order total/)
  {
    $input = 0;
  }


  # templates
  elsif ($input_decode =~/who is the Prime Minister of Great Britain/)
  {
    $input = 'Tony Blair';
  }
  elsif ($input_decode =~/who is the Prime Minister of Great Britain/)
  {
    $input = 'Tony Blair';
  }


	return $input;
}

# print Dumper solve('which of the following numbers is the largest: 42, 380, 57, 336');
# print Dumper solve('which of the following numbers are primes: 938, 648, 181, 47');
# print Dumper solve('which of the following numbers are primes: 361, 199 HTTP/1.1');
# print Dumper solve('which of the following numbers is both a square and a cube: 925, 25, 809, 441, 64 HTTP/1.1');
# exit;

my $sock = new IO::Socket::INET (
	LocalHost => '0.0.0.0',
	LocalPort => '9000',
	Proto => 'tcp',
	Listen => 1,
	Reuse => 1,
);

die "Could not create socket: $!\n" unless $sock;

while (my $new_sock = $sock->accept()) {
	my $name = gethostbyaddr($new_sock->peeraddr, AF_INET);
	my $port = $new_sock->peerport;
	print "Connection from $name port $port\n";
	my $input;
	my $answer;
	$_ = <$new_sock>;
	s/\x0d$//;
	s/\x0a$//;
	$input = $_;
	$answer = &solve($input);
	my $result = "HTTP/1.0 200 OK\n";
	$result .= "Date: Sat, 22 Dec 2012 00:00:01 GMT\n";
	$result .= "Content-Type: text/html\n";
	$result .= "Content-Length: " . length($answer) . "\n";
	$result .= "\n";
	$result .= $answer;
	print $new_sock $result;
	close $new_sock;
	print "Request: [$input]\n";
	print "Answer: [$answer]\n";
  print "-----------\n\n";
}
close($sock);
