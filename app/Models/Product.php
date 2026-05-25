<?php

namespace App\Models;

use App\Services\DatabaseService;

class Product
{
    protected $id;
    protected $name;
    protected $description;
    protected $category;
    protected $price;
    protected $image;
    protected $stock;

    public function __construct($id, $name, $description, $category, $price, $image, $stock = 0)
    {
        $this->id = $id;
        $this->name = $name;
        $this->description = $description;
        $this->category = $category;
        $this->price = $price;
        $this->image = $image;
        $this->stock = $stock;
    }

    public function getId() { return $this->id; }
    public function getName() { return $this->name; }
    public function getDescription() { return $this->description; }
    public function getCategory() { return $this->category; }
    public function getPrice() { return $this->price; }
    public function getImage() { return $this->image; }
    public function getStock() { return $this->stock; }

    public static function all()
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

    public static function find($id)
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

    public function save()
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

    public function delete()
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
