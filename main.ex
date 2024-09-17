## ---------------------------
## -- Types and Basics
## ---------------------------

# Comment

# To use the Elixir shell use the `iex` command.
# Compile your modules with the `elixirc` command.

3  # integer
0x1F  # integer
3.0  # float

:hello  # atom

my_tuple = {1,2,3}  # tuple
my_list = [1, 2, 3]  # linked list
["string", 123, :atom]  # mixed types list
my_binary = <<1,2,3>>  # binary, aka Python's bytes

elem(my_tuple, 0)  # returns 1

[head | tail] = my_list  # returns 1 and 3

{a, b, c} = my_tuple  # tuple destructuring
[a, b, c] = my_list  # list destructuring
[head | _] = my_list  # ignore other values
<<a, b, c>> = my_binary  # bytes destructuring

"hello" # string (encoded in UTF-8!)
~c"hello" # char list

"""
I'm a multi-line
string.
"""

?a  # Python's ord('a')

# concat lists
[1,2,3] ++ [4,5]
'hello ' ++ 'world'

# concat strings and binaries
<<1,2,3>> <> <<4,5>> #=> <<1,2,3,4,5>>
"hello " <> "world"  #=> "hello world"

1..10  # range
lower..upper = 1..10  # pattern matching for ranges

genders = %{"david" => "male", "gillian" => "female"}  # map
genders["david"]
genders = %{david: "male", gillian: "female"}  # map with atom keys
genders.gillian

## ---------------------------
## -- Operators
## ---------------------------

1 + 1
10 - 5
5 * 2
10 / 2  # always a float
div(10, 2)  # integer division
rem(10, 3)  # division remainder

# boolean only operators
true and true
false or true

# boolean operators supporting other types
1 || true
false && 1
nil && 20
!true

1 == 1
1 != 1
1 < 2
1 == 1.0  # not checking type for floats
1 === 1.0  # checking type for floats
1 < :hello

## ---------------------------
## -- Control Flow
## ---------------------------

if false do
  "This will never be seen"
else
  "This will"
end

unless true do
  "This will never be seen"
else
  "This will"
end

case {:one, :two} do
  {:four, :five} ->
    "This won't match"
  {:one, x} ->
    "This will match and bind `x` to `:two` in this clause"
  _ ->
    "This will match any value"
end

cond do
  1 + 1 == 3 ->
    "I will never be seen"
  2 * 5 == 12 ->
    "Me neither"
  1 + 2 == 3 ->
    "But I will"
end

cond do
  1 + 1 == 3 ->
    "I will never be seen"
  2 * 5 == 12 ->
    "Me neither"
  true ->
    "But I will (this is essentially an else)"
end

try do
  throw(:hello)
catch
  message -> "Got #{message}."
after
  IO.puts("I'm the after clause.")
end

## ---------------------------
## -- Modules and Functions
## ---------------------------

square = fn(x) -> x * x end  # lambda
square.(5)

f = fn
  x, y when x > 0 -> x + y  # guard clause with pattern matching
  x, y -> x * y
end
f.(1, 3)  # first branch
f.(-1, 3)  # second branch

# built-ins
is_number(10)
is_list("hello")
elem({1,2,3}, 0)

defmodule Math do  # module
  @my_data 100  # attribute

  def sum(a, b) do  # public
    do_sum(a, b)
  end

  def square(x) do
    x * x
  end

  defp do_sum(a, b) do  # private
    a + b
  end

  def area({:circle, r}) when is_number(r) do  # guard (as before)
    3.14 * r * r
  end

  def area({:rectangle, w, h}) do  # "second branch" of the guard
    w * h
  end
end
Math.sum(1, 2)
Math.square(3)

# The pipe operator |> allows you to pass the output of an expression
# as the first parameter into a function.
Range.new(1,10)
|> Enum.map(fn x -> x * x end)
|> Enum.filter(fn x -> rem(x, 2) == 0 end)

## ---------------------------
## -- Structs and Exceptions
## ---------------------------

defmodule Person do
  defstruct name: nil, age: 0, height: 0
end
joe_info = %Person{ name: "Joe", age: 30, height: 180 }
joe_info.name #=> "Joe"
older_joe_info = %{ joe_info | age: 31 }  # clone joe info but override age

## ---------------------------
## -- Concurrency
## ---------------------------

func = fn -> 2 * 2 end
pid = spawn(func)

def receiver do
  receive do  # "receive" keyword to receive data from other threads
    {:rectangle, w, h} ->
      IO.puts("Area = #{w * h}")
      area_loop()
    {:circle, r} ->
      IO.puts("Area = #{3.14 * r * r}")
      area_loop()
  end
end
pid = spawn(fn -> receiver() end)
send pid, {:rectangle, 2, 3}  # "send" keyword to send message to other threads
self()  # current pid

## ---------------------------
## -- Agents
## ---------------------------

# An agent is a process that keeps track of some changing value

# Create an agent with `Agent.start_link`, passing in a function
# The initial state of the agent will be whatever that function returns
{:ok, my_agent} = Agent.start_link(fn -> ["red", "green"] end)

# `Agent.get` takes an agent name and a `fn` that gets passed the current state
# Whatever that `fn` returns is what you'll get back
Agent.get(my_agent, fn colors -> colors end) #=> ["red", "green"]

# Update the agent's state the same way
Agent.update(my_agent, fn colors -> ["blue" | colors] end)
