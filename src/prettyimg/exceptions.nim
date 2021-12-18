# author: Ethosa

{.push size: sizeof(int8).}
type
  ColorValueError* = object of ValueError
  ReadFromStringError* = object of ValueError
  ImageOutOfBoundsError* = object of ValueError
  ColorStringParseError* = object of ValueError
  ImageReadError* = object of ValueError
{.pop.}
