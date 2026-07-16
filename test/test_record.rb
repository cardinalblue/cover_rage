# frozen_string_literal: true

require 'minitest/autorun'
require 'cover_rage/record'

class TestRecord < Minitest::Test
  parallelize_me!

  def test_merge_simple_case
    assert_equal(
      [
        CoverRage::Record.new(
          path: 'foo.rb',
          revision: '1',
          source: '',
          execution_count: [2, nil],
          last_executed_at: [200, nil]
        )
      ],
      CoverRage::Record.merge(
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [100, nil]
          )
        ],
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [200, nil]
          )
        ]
      )
    )
  end

  def test_merge_with_different_revision
    assert_equal(
      [
        CoverRage::Record.new(
          path: 'foo.rb',
          revision: '2',
          source: '',
          execution_count: [1, nil],
          last_executed_at: [200, nil]
        )
      ],
      CoverRage::Record.merge(
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [100, nil]
          )
        ],
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '2',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [200, nil]
          )
        ]
      )
    )
  end

  def test_merge_with_different_path
    assert_equal(
      [
        CoverRage::Record.new(
          path: 'bar.rb',
          revision: '1',
          source: '',
          execution_count: [1, nil],
          last_executed_at: [200, nil]
        )
      ],
      CoverRage::Record.merge(
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [100, nil]
          )
        ],
        [
          CoverRage::Record.new(
            path: 'bar.rb',
            revision: '1',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [200, nil]
          )
        ]
      )
    )
  end

  def test_sum
    r1 = CoverRage::Record.new(
      path: '',
      revision: '',
      source: '',
      execution_count: [1, nil],
      last_executed_at: [100, nil]
    )
    r2 = CoverRage::Record.new(
      path: '',
      revision: '',
      source: '',
      execution_count: [2, nil],
      last_executed_at: [200, nil]
    )
    result = r1 + r2
    assert_equal [3, nil], result.execution_count
    assert_equal [200, nil], result.last_executed_at
  end

  def test_sum_uses_other_when_exactly_one_execution_count_is_nil
    r1 = CoverRage::Record.new(
      path: '',
      revision: '',
      source: '',
      execution_count: [1, nil],
      last_executed_at: [100, nil]
    )
    r2 = CoverRage::Record.new(
      path: '',
      revision: '',
      source: '',
      execution_count: [nil, 2],
      last_executed_at: [nil, 200]
    )
    result = r1 + r2
    assert_equal [nil, 2], result.execution_count
    assert_equal [nil, 200], result.last_executed_at
  end

  def test_merge_when_current_record_measures_more_lines
    assert_equal(
      [
        CoverRage::Record.new(
          path: 'foo.rb',
          revision: '1',
          source: '',
          execution_count: [3, 1],
          last_executed_at: [200, 200]
        )
      ],
      CoverRage::Record.merge(
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [1, nil],
            last_executed_at: [100, nil]
          )
        ],
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [2, 1],
            last_executed_at: [200, 200]
          )
        ]
      )
    )
  end

  def test_merge_when_current_record_measures_fewer_lines
    assert_equal(
      [
        CoverRage::Record.new(
          path: 'foo.rb',
          revision: '1',
          source: '',
          execution_count: [3, nil],
          last_executed_at: [200, nil]
        )
      ],
      CoverRage::Record.merge(
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [1, 1],
            last_executed_at: [100, 100]
          )
        ],
        [
          CoverRage::Record.new(
            path: 'foo.rb',
            revision: '1',
            source: '',
            execution_count: [2, nil],
            last_executed_at: [200, nil]
          )
        ]
      )
    )
  end
end
