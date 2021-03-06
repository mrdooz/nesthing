#pragma once

#include <stdint.h>
#include <vector>
#include <string>
#include <array>
#include <algorithm>
#include <unordered_set>
#include <unordered_map>
#include <map>

namespace nes
{
  typedef uint8_t u8;
  typedef uint16_t u16;
  typedef uint32_t u32;
  typedef uint64_t u64;

  typedef int8_t s8;
  typedef int16_t s16;
  typedef int32_t s32;
  typedef int64_t s64;

  using std::vector;
  using std::string;
  using std::array;
  using std::pair;
  using std::unordered_set;
  using std::unordered_map;
  using std::make_pair;
  using std::max;
  using std::min;
  using std::map;

  enum class Status
  {
    OK,
    ROM_NOT_FOUND,
    DISASM_NOT_FOUND,
    INVALID_MAPPER_VERSION,
    FONT_NOT_FOUND,

    ERROR_LOADING_ROM,

    FILE_NOT_FOUND,
    FILE_READ_ERROR,
  };
}
