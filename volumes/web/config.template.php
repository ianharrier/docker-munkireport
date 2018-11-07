<?php

	/*
	|===============================================
	| User settings
	|===============================================
	|
	| Add custom settings here.
	|
	*/



	/*
	|===============================================
	| docker-munkireport settings
	|===============================================
	|
	| It is recommended that you keep the following settings, which are optimized
	| for the MunkiReport Docker image.
	|
	*/

	// Leave this set to '' for nicer looking URLs.
	$conf['index_page'] = '';

	// DO NOT MODIFY - MySQL settings are automatically pulled from the .env file.
	$conf['connection'] = [
	    'driver'    => 'mysql',
	    'host'      => 'db',
	    'port'      => 3306,
	    'database'  => getenv('MYSQL_DATABASE'),
	    'username'  => getenv('MYSQL_USER'),
	    'password'  => getenv('MYSQL_PASSWORD'),
	    'options'   => [PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci']
	];

	// DO NOT MODIFY - Timezone is automatically pulled from the .env file.
	$conf['timezone'] = @date_default_timezone_get();
