<?php

namespace App\Models;

use App\Services\DatabaseService;

class User
{
    protected ?int $id;
    protected ?string $name;
    protected ?string $email;
    protected ?string $password;
    protected ?string $role;
    protected ?string $created_at;

    public function __construct(?int $id, ?string $name, ?string $email, ?string $password, ?string $role = 'user', ?string $created_at = null)
    {
        $this->id = $id;
        $this->name = $name;
        $this->email = $email;
        $this->password = $password;
        $this->role = $role;
        $this->created_at = $created_at;
    }

    public function getId(): ?int { return $this->id; }
    public function getName(): ?string { return $this->name; }
    public function getEmail(): ?string { return $this->email; }
    public function getPassword(): ?string { return $this->password; }
    public function getRole(): ?string { return $this->role; }
    public function getCreatedAt(): ?string { return $this->created_at; }

    public static function findByEmail(?string $email): ?self
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

    public static function find(?int $id): ?self
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

    public static function all(): array
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

    public function save(): bool
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

    public function verifyPassword(?string $password): bool
    {
        return password_verify($password ?? '', $this->password ?? '');
    }

    public function delete(): bool
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
