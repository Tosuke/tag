# tag

## Introdubtion
Add "tagged value" to [D](http://dlang.org/) for an effective use of [`std.variant.Algebraic`](http://dlang.org/phobos/std_variant.html#.Algebraic).

## Example
```d
import tag;
import std.variant : Algebraic, visit;

/// optional type definition
alias Option(T) = Algebraic!(
  Tag!("Some", T),
  Tag!"None"
);

void main() {
  Option!int option;
  
  option = tag!"Some"(1);
  f(option).writeln; // 2
  
  option = tag!"None";
  f(option).writeln; // -1
}

int f(Option!int opt) {
  /// pattern mathing
  return opt.visit!(
    (Tag!("Some", int) a) => a + 1,
    (Tag!"None" a) => -1;
  );
}
```

## [Document](https://tosuke.github.io/tag/tag.html)