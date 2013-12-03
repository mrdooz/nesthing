#include "file_utils.hpp"
#include <sys/stat.h>
#ifdef _WIN32
#include <io.h>
#include <direct.h>
#else
#include <sys/stat.h>
#include <unistd.h>
#endif

namespace nes
{
  //---------------------------------------------------------------------------
  string CurrentDirectory()
  {
    char buf[256];
    getcwd(buf, sizeof(buf));
    return string(buf);
  }

  //---------------------------------------------------------------------------
  bool FileExists(const char* filename)
  {
    struct stat status;
    return access(filename, 0) == 0 && stat(filename, &status) == 0 && (status.st_mode & S_IFREG);
  }

  //---------------------------------------------------------------------------
  bool DirectoryExists(const char* name)
  {
    struct stat status;
    return access(name, 0) == 0 && stat(name, &status) == 0 && (status.st_mode & S_IFDIR);
  }

  //---------------------------------------------------------------------------
  Status LoadTextFile(const char* filename, vector<char>* buf)
  {
    Status err = LoadFile(filename, buf);
    buf->push_back(0);
    return err;
  }

}
