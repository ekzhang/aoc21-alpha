(module
  (memory (export "memory") 1) ;; Wasm page size is 64 KB

  ;; Get the buffer value at a given index.
  (func $get_num (param $idx i32) (result i32)
    (i32.load
      (i32.mul (local.get $idx) (i32.const 4))))

  ;; Set the buffer value at a given index.
  (func $set_num (param $idx i32) (param $val i32)
    (i32.store
      (i32.mul (local.get $idx) (i32.const 4))
      (local.get $val)))

  ;; Get the k-th bit of an integer.
  (func $get_bit (param $num i32) (param $k i32) (result i32)
    (i32.shl
      (i32.and
        (i32.shr_u (local.get $num) (local.get $k))
        (i32.const 1))
      (local.get $k)))

  ;; Resets the current mask for the array to all present (`1` on-bits).
  (func $set_mask (param $num_ints i32)
    (local $idx i32)
    (local.set $idx (i32.const 0))
    (loop
      (call $set_num
        (i32.add (local.get $idx) (local.get $num_ints))
        (i32.const 1))
      (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
      (br_if 0 (i32.ne (local.get $idx) (local.get $num_ints)))))

  ;; Resets the last masked index, or `-1` if not unique.
  (func $last_mask (param $num_ints i32) (result i32)
    (local $idx i32)
    (local $found i32)
    (local.set $idx (i32.const 0))
    (local.set $found (i32.const -1))
    (loop
      (if
        (call $get_num (i32.add (local.get $idx) (local.get $num_ints)))
        (if
          (i32.ne (local.get $found) (i32.const -1))
          (return (i32.const -1))
          (local.set $found (local.get $idx))))
      (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
      (br_if 0 (i32.ne (local.get $idx) (local.get $num_ints))))
    (local.get $found))

  ;; Gets the majority bit of the masked integers.
  (func $maj_bit (param $bitk i32) (param $num_ints i32) (result i32)
    (local $idx i32)
    (local $net_ones i32)

    (local.set $idx (i32.const 0))
    (local.set $net_ones (i32.const 0))

    (block (result i32)
      (loop
        (if
          (call $get_num (i32.add (local.get $num_ints) (local.get $idx)))
          (if
            (call $get_bit (call $get_num (local.get $idx)) (local.get $bitk))
            (local.set $net_ones (i32.add (local.get $net_ones) (i32.const 1)))
            (local.set $net_ones (i32.sub (local.get $net_ones) (i32.const 1)))))
        (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
        (br_if 0 (i32.ne (local.get $idx) (local.get $num_ints))))
      (if (result i32)
        (i32.ge_s (local.get $net_ones) (i32.const 0))
        (i32.shl (i32.const 1) (local.get $bitk))
        (i32.const 0))))

  ;; Given the bit length and number of integers provided, computes the value of
  ;; "gamma" for the submarine according to the problem statement.
  (func $cmp_gamma (param $bit_length i32) (param $num_ints i32) (result i32)
    (local $bitk i32)
    (local.set $bitk (i32.sub (local.get $bit_length) (i32.const 1)))
    (call $set_mask (local.get $num_ints))
    (if (result i32)
      (i32.eqz (local.get $bit_length))
      (i32.const 0)
      (i32.or
        (call $maj_bit (local.get $bitk) (local.get $num_ints))
        (call $cmp_gamma (local.get $bitk) (local.get $num_ints)))))

  ;; Part 1: Compute the power consumption using gamma.
  (func $soln (param $bit_length i32) (param $num_ints i32) (result i32)
    (local $gamma i32)
    (local.set $gamma (call $cmp_gamma (local.get $bit_length) (local.get $num_ints)))
    (i32.mul
      (local.get $gamma)
      (i32.xor
        (i32.sub
          (i32.shl (i32.const 1) (local.get $bit_length))
          (i32.const 1))
        (local.get $gamma))))

  ;; Filter masked numbers that have a certain bit set.
  (func $filter_bit (param $bitk i32) (param $val i32) (param $num_ints i32)
    (local $idx i32)
    (local $mask_idx i32)
    (local.set $idx (i32.const 0))
    (loop
      (local.set $mask_idx (i32.add (local.get $idx) (local.get $num_ints)))
      (if
        (call $get_num (local.get $mask_idx))
        (if
          (i32.ne
            (call $get_bit (call $get_num (local.get $idx)) (local.get $bitk))
            (local.get $val))
          (call $set_num (local.get $mask_idx) (i32.const 0))))
      (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
      (br_if 0 (i32.ne (local.get $idx) (local.get $num_ints)))))

  (func $cmp_rating (param $inv i32) (param $bit_length i32) (param $num_ints i32) (result i32)
    (local $idx i32)
    (local $result i32)
    (local $bit i32)
    (local.set $idx (i32.sub (local.get $bit_length) (i32.const 1)))
    (call $set_mask (local.get $num_ints))
    (loop
      (local.set $bit (call $maj_bit (local.get $idx) (local.get $num_ints)))
      (if
        (local.get $inv)
        (local.set $bit
          (i32.xor
            (i32.shl (i32.const 1) (local.get $idx))
            (local.get $bit))))
      (call $filter_bit (local.get $idx) (local.get $bit) (local.get $num_ints))
      (local.set $result (call $last_mask (local.get $num_ints)))
      (if
        (i32.ne (local.get $result) (i32.const -1))
        (return (call $get_num (local.get $result))))
      (local.set $idx (i32.sub (local.get $idx) (i32.const 1)))
      (br_if 0 (i32.ge_s (local.get $idx) (i32.const 0))))
    (i32.const -1))

  ;; Part 2: Compute the life support rating.
  (func $soln2 (param $bit_length i32) (param $num_ints i32) (result i32)
    (i32.mul
      (call $cmp_rating (i32.const 0) (local.get $bit_length) (local.get $num_ints))
      (call $cmp_rating (i32.const 1) (local.get $bit_length) (local.get $num_ints))))

  (export "soln" (func $soln))
  (export "soln2" (func $soln2)))
