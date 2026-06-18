/**
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <pico/stdlib.h>
#include <stdio.h>

int main() {
  stdio_init_all();
  while (true) {
    printf("Hello, world!\n");
    sleep_ms(1000);
  }
}

class IShape {
public:
  virtual ~IShape() = default;     // important for polymorphic deletion
  virtual double area() const = 0; // pure virtual = interface method
  virtual void draw() const = 0;
};

class Circle : public IShape {
public:
  explicit Circle(double r) : radius(r) {}

private:
  double radius;
};
