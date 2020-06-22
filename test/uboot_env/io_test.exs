defmodule UBootEnv.IOTest do
  use ExUnit.Case

  describe "nonredundant packaging" do
    test "packaging" do
      {:ok, encoded} = UBootEnv.IO.package("testing", 1024, :unused)
      flattened = IO.iodata_to_binary(encoded)

      assert byte_size(flattened) == 1024
      <<crc32::32, _data::binary>> = flattened

      assert crc32 == 0x9336B165
    end

    test "packaging too much" do
      assert {:ok, _result} = UBootEnv.IO.package(:binary.copy("a", 1020), 1024, :unused)

      assert {:error, :environment_too_small} ==
               UBootEnv.IO.package(:binary.copy("a", 1021), 1024, :unused)
    end

    test "unpacking" do
      {:ok, encoded} = UBootEnv.IO.package("testing", 1024, :unused)
      flattened = IO.iodata_to_binary(encoded)

      {:ok, bin, :unused} = UBootEnv.IO.unpackage(flattened, :nonredundant)
      <<text::7-bytes, _rest::binary>> = bin
      assert text == "testing"
    end

    test "unpacking detects CRC errors" do
      {:ok, encoded} = UBootEnv.IO.package("testing", 1024, :unused)
      <<oops, rest::binary()>> = IO.iodata_to_binary(encoded)
      corrupted = <<oops + 1, rest::binary>>
      assert {:error, :invalid_crc} == UBootEnv.IO.unpackage(corrupted, :nonredundant)
    end
  end

  describe "redundant packaging" do
    test "packaging" do
      {:ok, encoded} = UBootEnv.IO.package("testing", 1024, 5)
      flattened = IO.iodata_to_binary(encoded)

      assert byte_size(flattened) == 1024
      <<crc32::32, generation, _data::binary>> = flattened

      assert generation == 5
      assert crc32 == 0x8125850E
    end

    test "packaging too much" do
      assert {:ok, _result} = UBootEnv.IO.package(:binary.copy("a", 1019), 1024, :unused)

      assert {:error, :environment_too_small} ==
               UBootEnv.IO.package(:binary.copy("a", 1020), 1024, 8)
    end

    test "unpacking" do
      {:ok, encoded} = UBootEnv.IO.package("testing", 1024, 6)
      flattened = IO.iodata_to_binary(encoded)

      {:ok, bin, 6} = UBootEnv.IO.unpackage(flattened, :redundant)
      <<text::7-bytes, _rest::binary>> = bin
      assert text == "testing"
    end

    test "unpacking detects CRC errors" do
      {:ok, encoded} = UBootEnv.IO.package("testing", 1024, 7)
      <<oops, rest::binary()>> = IO.iodata_to_binary(encoded)
      corrupted = <<oops + 1, rest::binary>>
      assert {:error, :invalid_crc} == UBootEnv.IO.unpackage(corrupted, :redundant)
    end
  end

  describe "nonredundant IO" do
    setup do
      path = Path.join(["..", "tmp_#{:random.uniform(10000)}"]) |> Path.expand(__DIR__)
      File.write!(path, :binary.copy(<<0xFF>>, 1024))
      on_exit(fn -> File.rm!(path) end)

      [config: UBootEnv.Config.from_string!("#{path} 0 1024"), path: path]
    end

    test "save and reload", context do
      :ok = UBootEnv.IO.write(context.config, "testing")
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::7-bytes, _rest::binary>> = bin
      assert text == "testing"
    end

    test "updating", context do
      for i <- 1000..1010 do
        original_text = "#{i}"
        :ok = UBootEnv.IO.write(context.config, original_text)
        {:ok, bin} = UBootEnv.IO.read(context.config)
        <<text::4-bytes, _rest::binary>> = bin
        assert text == original_text
      end
    end
  end

  describe "redundant IO" do
    setup do
      path = Path.join(["..", "tmp_#{:random.uniform(10000)}"]) |> Path.expand(__DIR__)
      File.write!(path, :binary.copy(<<0xFF>>, 2048))
      on_exit(fn -> File.rm!(path) end)

      [config: UBootEnv.Config.from_string!("#{path} 0 1024\n#{path} 1024 1024"), path: path]
    end

    test "save and reload", context do
      :ok = UBootEnv.IO.write(context.config, "testing")
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::7-bytes, _rest::binary>> = bin
      assert text == "testing"
    end

    test "corrupt one", context do
      :ok = UBootEnv.IO.write(context.config, "a")
      :ok = UBootEnv.IO.write(context.config, "b")

      # Corrupt "a". Should get "b"
      File.write!(context.path, <<1, 2, 3, 4>>, [:binary, :read, :write])
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::1-bytes, _rest::binary>> = bin
      assert text == "b"

      # This write should go over "a"
      :ok = UBootEnv.IO.write(context.config, "c")
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::1-bytes, _rest::binary>> = bin
      assert text == "c"

      # Now corrupt "c". Should get "b" again.
      File.write!(context.path, <<1, 2, 3, 4>>, [:binary, :read, :write])
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::1-bytes, _rest::binary>> = bin
      assert text == "b"

      # "c" is now "d"; "b" is now "e"
      :ok = UBootEnv.IO.write(context.config, "d")
      :ok = UBootEnv.IO.write(context.config, "e")
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::1-bytes, _rest::binary>> = bin
      assert text == "e"

      # This corrupts the second slot, so should get "d"
      fd = File.open!(context.path, [:binary, :read, :write])
      :file.pwrite(fd, 1024, <<1, 2, 3, 4>>)
      File.close(fd)
      {:ok, bin} = UBootEnv.IO.read(context.config)
      <<text::1-bytes, _rest::binary>> = bin
      assert text == "d"
    end

    test "updating", context do
      # This needs to loop >256 times to exercise rolling over the
      # generation counter.
      for i <- 1000..2000 do
        original_text = "#{i}"
        :ok = UBootEnv.IO.write(context.config, original_text)
        {:ok, bin} = UBootEnv.IO.read(context.config)
        <<text::4-bytes, _rest::binary>> = bin
        assert text == original_text
      end
    end
  end
end
