<?php

namespace App\Models;

class Product
{
    protected $id;
    protected $name;
    protected $description;
    protected $price;
    protected $image;

    public function __construct($id, $name, $description, $price, $image)
    {
        $this->id = $id;
        $this->name = $name;
        $this->description = $description;
        $this->price = $price;
        $this->image = $image;
    }

    public function getId() { return $this->id; }
    public function getName() { return $this->name; }
    public function getDescription() { return $this->description; }
    public function getPrice() { return $this->price; }
    public function getImage() { return $this->image; }

    public static function all()
    {
        return [
            new self(1, 'Product 1', 'High quality product', 29.99, 'product1.jpg'),
            new self(2, 'Product 2', 'Premium product', 39.99, 'product2.jpg'),
            new self(3, 'Product 3', 'Deluxe product', 49.99, 'product3.jpg'),
        ];
    }

    public static function find($id)
    {
        $products = self::all();
        foreach ($products as $product) {
            if ($product->getId() === (int) $id) {
                return $product;
            }
        }
        return null;
    }
}
