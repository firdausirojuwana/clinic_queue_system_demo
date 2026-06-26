<?php
include '../config/database.php';

$result = mysqli_query($conn, "SELECT * FROM patient ORDER BY patient_id DESC");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Patients</title>

    <style>
        body {
            font-family: Arial;
            background: #f4f6f9;
            margin: 0;
        }

        .container {
            width: 90%;
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        a.button {
            display: inline-block;
            padding: 10px 15px;
            background: #2c3e50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #2c3e50;
            color: white;
            padding: 10px;
        }

        td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f1f1f1;
        }

        .edit {
            color: #2980b9;
            font-weight: bold;
            text-decoration: none;
        }

        .delete {
            color: #e74c3c;
            font-weight: bold;
            text-decoration: none;
        }

        .top {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .back {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: #2c3e50;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>👥 Patients</h2>

    <div class="top">
        <a class="button" href="add_patient.php">+ Add Patient</a>
    </div>

    <table>
        <tr>
            <th>Name</th>
            <th>IC Number</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Gender</th>
            <th>Action</th>
        </tr>

        <?php while ($row = mysqli_fetch_assoc($result)) { ?>

        <tr>
            <td><?php echo $row['name']; ?></td>
            <td><?php echo $row['ic_number']; ?></td>
            <td><?php echo $row['phone']; ?></td>
            <td><?php echo $row['email']; ?></td>
            <td><?php echo $row['gender']; ?></td>

            <td>
                <a class="edit" href="edit_patient.php?id=<?php echo $row['patient_id']; ?>">Edit</a> |
                <a class="delete"
                   onclick="return confirm('Delete this patient?');"
                   href="delete_patient.php?id=<?php echo $row['patient_id']; ?>">
                   Delete
                </a>
            </td>
        </tr>

        <?php } ?>

    </table>

    <a class="back" href="../index.php">Back to Menu</a>

</div>

</body>
</html>