# author: Ethosa

{.push size: sizeof(int8).}
type
  ReadFromStringError* = object of ValueError
  ImageOutOfBoundsError* = object of ValueError
  ImageReadError* = object of ValueError
  IcoError* = object of ValueError
{.pop.}
