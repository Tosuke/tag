module tag;

/**
Add tag to types
*/
public struct Tag(string tag_, T) {
  /// kind(tag) of This
  enum tag = tag_;
  static if(is(T == void)) {

  } else {
    /// internal value
    public T value;
    alias value this;
  }
}

///
@system unittest {
  import std.variant : Algebraic, visit;
  alias Option(T) = Algebraic!(
    Tag!("Some", T),
    Tag!("None", void)
  );
  Option!int option;
  
  option = tag!"Some"(1);
  assert(option.visit!(
    (Tag!("Some", int) a) => Option!int(tag!"Some"(a + 1)),
    (Tag!("None", void) a) => Option!int(a)
  ) == tag!"Some"(2));

  option = tag!"None"();
  assert(option.visit!(
    (Tag!("Some", int) a) => Option!int(tag!"Some"(a + 1)),
    (Tag!("None", void) a) => Option!int(a)
  ) == tag!"None"());
}

@safe unittest {
  alias T = Tag!("Tag", int);
  static assert(T.tag == "Tag");
}

/// Get the underlying type whitch a **Tag** wraps. If **T** is not a **Tag** it will alias itself to **T**.
template TaggedType(T) {
  static if(is(T == Tag!(tag_, U), string tag_, U)) {
    alias TaggedType = U;
  } else {
    alias TaggedType = T;
  }
}

///
@safe unittest {
  static assert(is(
    TaggedType!(Tag!("Tag", int)) == int
  ));
  static assert(is(
    TaggedType!int == int
  ));
}

/// make tagged value
public template tag(string tag_) {
  public Tag!(tag_, T) tag(T)(T value) {
    Tag!(tag_, T) temp;
    temp.value = value;
    return temp;
  }

  @safe unittest {
    assert(tag!"Some"(1) == 1);
    assert(tag!"Some"(1) != tag!"Some"(114514));
  }

  public pure @safe @nogc Tag!(tag_, void) tag() {
    Tag!(tag_, void) temp;
    return temp;
  }
}