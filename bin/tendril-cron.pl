#!/usr/bin/perl

use strict;
use DBI;
use Digest::MD5 qw(md5 md5_hex md5_base64);

my $dbi = "DBI:mysql:;mysql_read_default_file=./tendril.cnf;mysql_read_default_group=tendril";
my $db  = DBI->connect($dbi, undef, undef) or die("db?");
$db->do("SET NAMES 'utf8';");

my $servers = $db->prepare("select id, host, port from servers");

$servers->execute();

while (my $row = $servers->fetchrow_hashref())
{
	my $server_id = $row->{id};
	my $host = $row->{host};
	my $port = $row->{port};

	my ($lock) = $db->selectrow_array("select get_lock('tendril-cron-$server_id', 1)");

	if ($lock == 1)
	{
		print "$host:$port\n";

		my $wdbi = "DBI:mysql:host=$host;port=$port;mysql_read_default_file=./tendril.cnf;mysql_read_default_group=watchdog";
		my $wdb  = DBI->connect($wdbi, undef, undef);

		if ($wdb)
		{
			my $status = $wdb->prepare("show master status");
			if ($status->execute() and my $row = $status->fetchrow_hashref())
			{
				foreach my $key (keys %$row)
				{
					my $replace = $db->prepare("replace into master_status (server_id, variable_name, variable_value) values (?,lower(?),?)");
					$replace->execute($server_id, $key, $row->{$key});
					$replace->finish();
				}
			}
			$status->finish();

			my $status = $wdb->prepare("show slave status");
			if ($status->execute() and my $row = $status->fetchrow_hashref())
			{
				foreach my $key (keys %$row)
				{
					my $replace = $db->prepare("replace into slave_status (server_id, variable_name, variable_value) values (?,lower(?),?)");
					$replace->execute($server_id, $key, $row->{$key});
					$replace->finish();
				}
			}
			$status->finish();

			$wdb->disconnect();
		}
	}

	my $update = $db->prepare("update servers set event_cron = now() where id = ?");
	$update->execute($server_id);
	$update->finish();
}

