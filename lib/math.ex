defmodule Utils.Math do

  def clamp(value, min, _max) when value < min, do: min
  def clamp(value, _min, max) when value > max, do: max
  def clamp(value, _min, _max), do: value

  def modulo(a, b) do
    m = rem(a, b)
    if m < 0,
      do: m + b,
      else: m
  end

end
