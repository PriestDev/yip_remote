<?php

namespace App\Models;

use App\Services\DatabaseService;

class Product
{
    protected ?int $id;
    protected ?string $name;
    protected ?string $description;
    protected ?string $category;
    protected ?float $price;
    protected ?string $image;
    protected ?int $stock;

    public function __construct(?int $id, ?string $name, ?string $description, ?string $category, ?float $price, ?string $image, ?int $stock = 0)
    {
        $this->id = $id;
        $this->name = $name;
        $this->description = $description;
        $this->category = $category;
        $this->price = $price;
        $this->image = $image;
        $this->stock = $stock;
    }

    public function getId(): ?int { return $this->id; }
    public function getName(): ?string { return $this->name; }
    public function getDescription(): ?string { return $this->description; }
    public function getCategory(): ?string { return $this->category; }
    public function getPrice(): ?float { return $this->price; }
    public function getImage(): ?string { return $this->image; }
    public function getStock(): ?int { return $this->stock; }

    public static function all(): array
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("SELECT * FROM products");
            
            $products = [];
            foreach ($results as $row) {
                $products[] = new self(
                    $row['id'],
                    $row['name'],
                    $row['description'],
                    $row['category'],
                    $row['price'],
                    $row['image'],
                    $row['stock']
                );
            }
            return $products;
        } catch (\Exception $e) {
            // Fall back to empty array
            return [];
        }
    }

    public static function find(?int $id): ?self
    {
        try {
            $db = DatabaseService::getInstance();
            $results = $db->query("SELECT * FROM products WHERE id = ?", [$id]);
            
            if (!empty($results)) {
                $row = $results[0];
                return new self(
                    $row['id'],
                    $row['name'],
                    $row['description'],
                    $row['category'],
                    $row['price'],
                    $row['image'],
                    $row['stock']
                );
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
                    "UPDATE products SET name=?, description=?, category=?, price=?, image=?, stock=? WHERE id=?",
                    [$this->name, $this->description, $this->category, $this->price, $this->image, $this->stock, $this->id]
                );
            } else {
                $db->execute(
                    "INSERT INTO products (name, description, category, price, image, stock) VALUES (?, ?, ?, ?, ?, ?)",
                    [$this->name, $this->description, $this->category, $this->price, $this->image, $this->stock]
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
            $db->execute("DELETE FROM products WHERE id=?", [$this->id]);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }
}
