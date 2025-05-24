<?php
// --- RDS MySQL Connection Details ---

$host = "${rds_endpoint}";
$dbname = "${db_name}";
$username = "${db_user}";
$password = "${db_password}";

// --- Connect to RDS MySQL ---
$conn = new mysqli($host, $username, $password, $dbname);

// --- Check Connection ---
if ($conn->connect_error) {
    $db_status = "<span style='color: red;'>❌ Connection failed: " . $conn->connect_error . "</span>";
} else {
    $result = $conn->query("SELECT VERSION() AS version");
    $row = $result->fetch_assoc();
    $db_status = "<span style='color: green;'>✅ Connected to MySQL RDS! Version: " . $row['version'] . "</span>";
    $conn->close();
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Terracloud</title>
</head>
<body style="background-color: #FFFFFF; text-align: center; font-family: Arial, sans-serif;">
    <h1>Terracloud</h1>
    <img src="Terracloud.png" alt="Terracloud Logo" style="max-width: 400px; margin: 20px auto;">
    <h3><?php echo $db_status; ?></h3>
</body>
</html>




