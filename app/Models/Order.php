<?php

namespace App\Models;

use App\Services\DatabaseService;

class Order
{
    protected ?int $id;
    protected ?int $user_id;
    protected ?string $order_number;
    protected ?float $total;
    protected ?string $status;
    protected ?string $created_at;
    protected ?array $items;
    protected ?string $customer_name;

    public function __construct(?int $id, ?int $user_id, ?string $order_number, ?float $total, ?string $status, ?string $created_at, ?array $items = [], ?string $customer_name = null)
    {
        $this->id = $id;
        $this->user_id = $user_id;
        $this->order_number = $order_number;
        $this->total = $total;
        $this->status = $status;
        $this->created_at = $created_at;
        $this->items = $items;
        $this->customer_name = $customer_name;
    }

    public function getId(): ?int { return $this->id; }
    public function getUserId(): ?int { return $this->user_id; }
    public function getOrderNumber(): ?string { return $this->order_number; }
    public function getTotal(): ?float { return $this->total; }
    public function getStatus(): ?string { return $this->status; }
    public function getCreatedAt(): ?string { return $this->created_at; }
    public function getItems(): ?array { return $this->items; }
    public function getCustomerName(): ?string { return $this->customer_name; }

    public static function all(): array
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("
                SELECT o.*, u.name as customer_name
                FROM orders o
                LEFT JOIN users u ON o.user_id = u.id
                ORDER BY o.created_at DESC
            ");
            
            $orders = [];
            foreach ($results as $row) {
                $order = new self(
                    $row['id'],
                    $row['user_id'],
                    $row['order_number'],
                    $row['total'],
                    $row['status'],
                    $row['created_at'],
                    [],
                    $row['customer_name'] ?? null
                );
                $orders[] = $order;
            }
            return $orders;
        } catch (\Exception $e) {
            return [];
        }
    }

    public static function find(?int $id): ?self
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("
                SELECT o.*, u.name as customer_name
                FROM orders o
                LEFT JOIN users u ON o.user_id = u.id
                WHERE o.id = ?
            ", [$id]);
            
            if (!empty($results)) {
                $row = $results[0];
                $order = new self(
                    $row['id'],
                    $row['user_id'],
                    $row['order_number'],
                    $row['total'],
                    $row['status'],
                    $row['created_at'],
                    [],
                    $row['customer_name'] ?? null
                );
                return $order;
            }
            return null;
        } catch (\Exception $e) {
            return null;
        }
    }

    public function save(): bool
    {
        try {
            $db = DatabaseService::getInstance();
            if ($this->id) {
                $db->execute(
                    "UPDATE orders SET user_id=?, total=?, status=? WHERE id=?",
                    [$this->user_id, $this->total, $this->status, $this->id]
                );
            } else {
                $this->order_number = 'ORD-' . str_pad((string)$this->user_id, 3, '0', STR_PAD_LEFT) . time();
                $db->execute(
                    "INSERT INTO orders (user_id, order_number, total, status) VALUES (?, ?, ?, ?)",
                    [$this->user_id, $this->order_number, $this->total, $this->status]
                );
                $this->id = $db->lastInsertId();
            }
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function delete(): bool
    {
        try {
            if (!$this->id) return false;
            $db = DatabaseService::getInstance();
            $db->execute("DELETE FROM order_items WHERE order_id=?", [$this->id]);
            $db->execute("DELETE FROM orders WHERE id=?", [$this->id]);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }
}
