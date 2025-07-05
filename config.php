<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

// Load env vars from .env.local
$envFile = '/.env.local';
if (file_exists($envFile)) {
    $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        list($name, $value) = explode('=', $line, 2);
        putenv("$name=$value");
    }
}

// === Database Settings ===
$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('DB_HOST');
$CFG->dbname    = getenv('DB_NAME');
$CFG->dbuser    = getenv('DB_USER');
$CFG->dbpass    = getenv('DB_PASS');
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array(
    'dbpersist'  => 0,
    'dbport'     => '',
    'dbsocket'   => '',
    'dbcollation'=> 'utf8mb4_unicode_ci',
);

// === Webroot (auto detect) ===
$CFG->wwwroot = getenv('BASE_URL');
// $host = $_SERVER['HTTP_HOST'];
// $CFG->wwwroot = "https://" . $host;

// === Moodle data directory ===
$CFG->dataroot  = '/moodledata';
$CFG->admin     = 'admin';
$CFG->directorypermissions = 0777;

// === Enable Webservice ===
$CFG->enablewebservices = true;
$CFG->enablewsrest = true;
$CFG->enablewssoap = true;
$CFG->enablewsxmlrpc = true;

// === Sessions in DB (Cloud Run stateless safe) ===
$CFG->session_handler_class = '\core\session\database';

// === objectfs plugin config (GCS) ===
$CFG->alternative_file_system_class = '\\tool_objectfs\\local\\store\\gcs\\gcs_file_system';
$CFG->tool_objectfs_enabletasks = true;
$CFG->tool_objectfs_enablepresignedurls = true;
$CFG->tool_objectfs_signingexpiration = 86400;
$CFG->tool_objectfs_useproxy = false;
$CFG->tool_objectfs_deleteretentionperiod = 0;
$CFG->tool_objectfs_gcs_bucket = getenv('GCS_BUCKET');

// Optional: key file if not using Workload Identity
if (file_exists('/key.json')) {
    $CFG->tool_objectfs_gcs_key_file = '/key.json';
}

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
