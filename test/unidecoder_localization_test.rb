# encoding: UTF-8

require "test/unit"

$: << File.join(File.expand_path(File.dirname(__FILE__)), '../lib')
require File.join(File.expand_path(File.dirname(__FILE__)), "../init.rb")

class UnidecoderLocalizationTest < Test::Unit::TestCase
  def setup
    # Just unsetting what might have been set last in previous test. Nothing magical.
    LuckySneaks::Unidecoder::default_locale = "en"
  end

  # NOTE: Localization tests go though String#to_ascii
  # because you really shouldn't be having to go through the base method

  def test_localize_from_hash
    hash = {
      "en" => {"é" => "ee"}
    }
    LuckySneaks::Unidecoder::localize_from hash
    assert_equal "ee", "é".to_ascii
  end

  def test_localize_from_hash_with_multiple_locales
    hash = {
      "en" => {"é" => "ee"},
      "xx" => {"é" => "xx"}
    }
    LuckySneaks::Unidecoder::localize_from hash
    assert_equal "ee", "é".to_ascii
    LuckySneaks::Unidecoder::locale = "xx"
    assert_equal "xx", "é".to_ascii
  end

  def test_localize_from_hash_with_symbols
    hash = {
      :en => {"é" => "ee"}
    }
    LuckySneaks::Unidecoder::localize_from hash
    assert_equal "ee", "é".to_ascii
  end

  def test_localize_from_file
    path_to_file = File.join(File.expand_path(File.dirname(__FILE__)), "unidecoder_localization.yml")
    LuckySneaks::Unidecoder::localize_from path_to_file
    assert_equal "ee", "é".to_ascii
    LuckySneaks::Unidecoder::locale = "xx"
    assert_equal "xx", "é".to_ascii
  end

  def test_bad_localize_from_hash
    hash = {"é" => "ee"}
    assert_raise(ArgumentError){LuckySneaks::Unidecoder::localize_from hash}
  end

  def test_bad_localize_from_file
    path_to_file = File.join(File.expand_path(File.dirname(__FILE__)), "bad_unidecoder_localization.yml")
    assert_raise(ArgumentError){LuckySneaks::Unidecoder::localize_from path_to_file}
  end

  def test_non_existent_localize_from_file
    path_to_file = File.join(File.expand_path(File.dirname(__FILE__)), "nonexistent_unidecoder_localization.yml")
    assert_raise(Errno::ENOENT){LuckySneaks::Unidecoder::localize_from path_to_file}
  end

  def test_default_locale
    assert_equal "en", LuckySneaks::Unidecoder::default_locale
  end

  def test_default_locale_equals
    LuckySneaks::Unidecoder::default_locale = "xx"
    assert_equal "xx", LuckySneaks::Unidecoder::default_locale
    assert_equal "xx", LuckySneaks::Unidecoder::locale
  end

  def test_localization_locale_change_block_method
    hash = {
      "en" => {"é" => "ee"},
      "xx" => {"é" => "xx"}
    }
    LuckySneaks::Unidecoder::localize_from hash
    LuckySneaks::Unidecoder::with_locale(:en) do
      assert_equal "ee", "é".to_ascii
    end
    LuckySneaks::Unidecoder::with_locale("en") do
      assert_equal "ee", "é".to_ascii
    end
    LuckySneaks::Unidecoder::with_locale("xx") do
      assert_equal "xx", "é".to_ascii
    end
    LuckySneaks::Unidecoder::with_default_locale do
      assert_equal "ee", "é".to_ascii
    end
    LuckySneaks::Unidecoder::with_locale(:default) do
      assert_equal "ee", "é".to_ascii
    end
  end
end