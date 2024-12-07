defmodule Utils.String do

  def replaceCharAt(string, position, replacement) do
    String.slice(string, 0..position) <> replacement <> String.slice(string, position+2..-1//1)
  end

end
