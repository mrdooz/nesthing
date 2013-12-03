#pragma once
#include "nesthing.hpp"

namespace nes
{
  template<class T>
  Status LoadFile(const char* filename, vector<T>* buf)
  {
    FILE* f = fopen(filename, "rb");
    if (!f)
    {
      return Status::FILE_NOT_FOUND;
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    buf->resize(size);
    size_t r = fread(buf->data(), 1, size, f);
    return r == size ? Status::OK : Status::FILE_READ_ERROR;
  }

  // Note, the result will be 0 terminated
  Status LoadTextFile(const char* filename, vector<char>* buf);
  bool FileExists(const char* filename);
  string CurrentDirectory();
  bool DirectoryExists(const char* name);
}
