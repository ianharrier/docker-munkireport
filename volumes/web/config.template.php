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

	// Leave this set to TRUE for more convenient upgrades to newer versions of MunkiReport.
	$conf['allow_migrations'] = TRUE;

	// DO NOT MODIFY - MySQL settings are automatically pulled from the .env file.
	$conf['pdo_dsn'] = "mysql:host=db;dbname=" . getenv('MYSQL_DATABASE');
	$conf['pdo_user'] = getenv('MYSQL_USER');
	$conf['pdo_pass'] = getenv('MYSQL_PASSWORD');
	$conf['pdo_opts'] = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');

	// DO NOT MODIFY - Timezone is automatically pulled from the .env file.
	$conf['timezone'] = @date_default_timezone_get();
