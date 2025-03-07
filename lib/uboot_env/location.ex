# SPDX-FileCopyrightText: 2020 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule UBootEnv.Location do
  @moduledoc """
  Environment block location
  """
  defstruct [:path, :offset, :size]

  @type t() :: %__MODULE__{
          path: Path.t(),
          offset: non_neg_integer(),
          size: pos_integer()
        }
end
