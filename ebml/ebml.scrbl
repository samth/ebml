#lang scribble/doc

@(require scribble/manual)

@title{@bold{EBML}: A binary encoding format}

@author[(author+email "John Clements" "clements@racket-lang.org")]

@(require (for-label "reader.rkt"
                     "writer.rkt"))


@section{EBML}

This is a Racket library to read and write EBML, the "extended 
binary markup language." It was designed by the implementors 
of the @link["http://matroska.org"]{``matroska'' project}.

EBML is a packed format for representing structured data.

@verbatim{
element = header data

header = encoded-id encoded-len

data = element ...
     | non-element
}

The @racket{encoded-id} and @racket{encoded-len} fields use a 
variable-length encoding. The first byte of this encoding 
indicates---through the number of leading zeros---how many 
bytes long the field is. the leading zeros and the first one
are then trimmed from the given number of bytes, and the result
is interpreted as a big-endian unsigned number.

So, for instance, the byte string

@racketblock[
(bytes #b10001011)             
]

... encodes the length 11, while the byte string 

@racketblock[
(bytes #b01000001 #b00000010)
]

... encodes the length 258. Note that there is more than one
way to encode a given length; you could also encode the length 
11 with the byte string 

@racketblock[
(bytes #b00100000 #b00000000 #b00001011)
]

Header IDs are limited to four bytes, and data lengths are limited
to 8.

EBML has at least one big problem, which is that the packed representation is ambiguous. Specifically, there's no way to reliably distinguish data that is a sequence of elements from data that is a binary blob.

To choose a concrete example, if you were using EBML to encode
s-expressions, you might choose a particular header id 
(say, 1) to encode a pair, and another one (say, 2) to encode
atoms. The pairs would include two sub-elements, and the atoms
would contain, say string or integer. 

@defmodule[reader]{
                   
@defproc[(ebml-read (in (or/c input-port? path-string? bytes?))) ebml-element?]{
Reads ebml elements from the given input-port, byte string, or file. It continues reading ebml elements until the source is exhausted. It signals an error if the end of the source doesn't correspond with
the end of an element.

Since the EBML parser has no way of knowing which elements are
compound elements, using the parser usually includes manual
recursion into the parser. So, for instance, if we used the encoding
scheme given above where 1 encodes a pair and 2 encodes an atom,
a decoder might look like this:
                                                                                
 Plays an rsound. Plays concurrently with an already-playing sound, if there is one.}

}