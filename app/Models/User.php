<?php

namespace App\Models;

use App\Services\DatabaseService;

class User
{
    protected $id;
    protected $name;
    protected $email;
    protected $password;
    protected $role;
    protected $created_at;

    public function __construct($id, $name, $email, $password, $role = 'user', $created_at = null)
    {
        $this->id = $id;
        $this->name = $name;
        $this->email = $email;
        $this->password = $password;
        $this->role = $role;
        $this->created_at = $created_at;
    }

    public function getId() { return $this->id; }
    public function getName() { return $this->name; }
    public function getEmail() { return $this->email; }
    public function getPassword() { return $this->password; }
    public function getRole() { return $this->role; }
    public function getCreatedAt() { return $this->created_at; }

    public static function findByEmail($email)
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("SELECT * FROM users WHERE email = ?", [$email]);
            
            if (!empty($results)) {
                $row = $results[0];
                return new self(
                    $row['id'],
                    $row['name'],
                    $row['email'],
                    $row['password'],
                    $row['role'],
                    $row['created_at']
                );
            }
            return null;
        } catch (\Exception $e) {
            return null;
        }
    }

    public static function find($id)
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("SELECT * FROM users WHERE id = ?", [$id]);
            
            if (!empty($results)) {
                $row = $results[0];
                return new self(
                    $row['id'],
                    $row['name'],
                    $row['email'],
                    $row['password'],
                    $row['role'],
                    $row['created_at']
                );
            }
            return null;
        } catch (\Exception $e) {
            return null;
        }
    }

    public static function all()
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("SELECT * FROM users ORDER BY created_at DESC");
            
            $users = [];
            foreach ($results as $row) {
                $users[] = new self(
                    $row['id'],
                    $row['name'],
                    $row['email'],
                    $row['password'],
                    $row['role'],
                    $row['created_at']
                );
            }
            return $users;
        } catch (\Exception $e) {
            return [];
        }
    }

    public function save()
    {
        try {
            $db = DatabaseService::getInstance();
            if ($this->id) {
                $db->execute(
                    "UPDATE users SET name=?, email=?, password=?, role=? WHERE id=?",
                    [$this->name, $this->email, $this->password, $this->role, $this->id]
                );
            } else {
                $db->execute(
                    "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
                    [$this->name, $this->email, $this->password, $this->role]
                );
                $this->id = $db->lastInsertId();
            }
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function verifyPassword($password)
    {
        return password_verify($password, $this->password);
    }

    public function delete()
    {
        try {
            if (!$this->id) return false;
            $db = DatabaseService::getInstance();
            $db->execute("DELETE FROM users WHERE id=?", [$this->id]);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }
}
