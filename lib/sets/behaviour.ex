defmodule Sets.Behaviour do
  @type set :: Sets.Protocol.t

  @callback empty(options :: keyword()) :: set
end
