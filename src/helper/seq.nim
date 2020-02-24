import sequtils

template deleteAll*[T](s: var seq[T]) =
    if (s.len > 0):
        s.delete(0, s.len - 1)

template delete*[T](s: var seq[T], e: T) =
    for i in 0..len(s):
        if (e == s[i]):
            s.delete(i)
            break
