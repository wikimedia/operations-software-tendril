<?php

$clusters = array(
    gethostbyname('s1-master') => 's1',
    gethostbyname('s2-master') => 's2',
    gethostbyname('s3-master') => 's3',
    gethostbyname('s4-master') => 's4',
    gethostbyname('s5-master') => 's5',
    gethostbyname('s6-master') => 's6',
    gethostbyname('s7-master') => 's7',
    gethostbyname('m1-master') => 'm1',
    gethostbyname('m2-master') => 'm2',
    gethostbyname('x1-master') => 'x1',
);

class Host extends Record
{
    public function __construct($id=0)
    {
        $this->_cache = Record::MEMCACHE;
        $this->_expiry = 300;

        if (is_string($id))
        {
            $name = $id;

            $id = sql::query('tendril.servers')
                ->where_eq('host', $name)->fetch_one();

            if (!$id && preg_match('/^[a-z]{2}[0-9]+$/', $name))
            {
                $id = sql::query('tendril.servers')
                    ->where_like('host', "$name%")->fetch_one();
            }
        }
        parent::__construct('tendril.servers', $id);
    }

    public static function by_name_port($name, $port=3306)
    {
        $row = sql::query('tendril.servers')
            ->where_eq('host', $name)
            ->where_eq('port', $port)
            ->fetch_one();
        return new self($row);
    }

    public static function by_m_server_id($id)
    {
        $row = sql::query('tendril.servers')
            ->where_eq('m_server_id', $id)
            ->fetch_one();
        return new self($row);
    }

    public function ipv4()
    {
        return $this->ipv4 ?: gethostbyname($this->host);
    }

    public function name()
    {
        return $this->host;
    }

    public function port()
    {
        return $this->port;
    }

    public function name_short()
    {
        $parts = explode('.', $this->host);
        return $parts ? $parts[0]: '-';
    }

    public function describe()
    {
        return ($this->port == 3306) ? $this->name_short(): sprintf('%s:%d', $this->name_short(), $this->port);
    }

    public function cluster()
    {
        global $clusters;

        $node = $this;

        while ($node->m_master_id)
        {
            $node = Host::by_m_server_id($node->m_master_id);
        }

        return expect($clusters, $node->ipv4(), 'string', '-');
    }

}