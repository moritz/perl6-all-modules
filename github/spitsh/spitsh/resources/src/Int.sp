#| Int is the primitive type for integers in the shell.
augment Int {
    #| Ints are true in Bool context if they are not equal to 0
    method Bool { $self != 0 }

    #| Returns true if the argument is an Int and equal to the invocant.
    method ACCEPTS(Int $b)? { $b == $self }

    method JSON { $self-->JSON }

    method valid? { $self.matches(/^[0-9]+$/) }
}

augment List[Int] {
    method sum+ { $self.${ awk '{ i += $0 } END { printf i }' } }
}
