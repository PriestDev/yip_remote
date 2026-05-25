<?php

namespace App\Models;

use App\Services\DatabaseService;

class Order
{
    protected $id;
    protected $user_id;
    protected $order_number;
    protected $total;
    protected $status;
    protected $created_at;
    protected $items;

    public function __construct($id, $user_id, $order_number, $total, $status, $created_at, $items = [])
    {
        $this->id = $id;
        $this->user_id = $user_id;
        $this->order_number = $order_number;
        $this->total = $total;
        $this->status = $status;
        $this->created_at = $created_at;
        $this->items = $items;
    }

    public function getId() { return $this->id; }
    public function getUserId() { return $this->user_id; }
    public function getOrderNumber() { return $this->order_number; }
    public function getTotal() { return $this->total; }
    public function getStatus() { return $this->status; }
    public function getCreatedAt() { return $this->created_at; }
    public function getItems() { return $this->items; }

    public static function all()
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
                    []
                );
                $order->customer_name = $row['customer_name'];
                $orders[] = $order;
            }
            return $orders;
        } catch (\Exception $e) {
            return [];
        }
    }

    public static function find($id)
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
                    []
                );
                $order->customer_name = $row['customer_name'];
                return $order;
            }
            return null;
        } catch (\Exception $e) {
            return null;
        }
    }

    public function save()
    {
        try {
            $db = DatabaseService::getInstance();
            if ($this->id) {
                $db->execute(
                    "UPDATE orders SET user_id=?, total=?, status=? WHERE id=?",
                    [$this->user_id, $this->total, $this->status, $this->id]
                );
            } else {
                $this->order_number = 'ORD-' . str_pad($this->user_id, 3, '0', STR_PAD_LEFT) . time();
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

    public function delete()
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

    public function getCustomerName()
    {
        return $this->customer_name ?? 'Unknown';
    }
}
