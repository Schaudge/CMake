/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file LICENSE.rst or https://cmake.org/licensing for details.  */
#include "cmCPackIFWCommon.h"

#include <cstddef> // IWYU pragma: keep
#include <sstream>
#include <utility>

#include "cmCPackGenerator.h"
#include "cmCPackIFWGenerator.h"
#include "cmCPackLog.h" // IWYU pragma: keep
#include "cmList.h"
#include "cmSystemTools.h"
#include "cmTimestamp.h"
#include "cmVersionConfig.h"
#include "cmXMLWriter.h"

cmCPackIFWCommon::cmCPackIFWCommon()
  : Generator(nullptr)
{
}

cmValue cmCPackIFWCommon::GetOption(std::string const& op) const
{
  return this->Generator ? this->Generator->cmCPackGenerator::GetOption(op)
                         : nullptr;
}

bool cmCPackIFWCommon::IsOn(std::string const& op) const
{
  return this->Generator && this->Generator->cmCPackGenerator::IsOn(op);
}

bool cmCPackIFWCommon::IsSetToOff(std::string const& op) const
{
  return this->Generator && this->Generator->cmCPackGenerator::IsSetToOff(op);
}

bool cmCPackIFWCommon::IsSetToEmpty(std::string const& op) const
{
  return this->Generator &&
    this->Generator->cmCPackGenerator::IsSetToEmpty(op);
}

bool cmCPackIFWCommon::IsVersionLess(char const* version) const
{
  if (!this->Generator) {
    return false;
  }

  return cmSystemTools::VersionCompare(
    cmSystemTools::OP_LESS, this->Generator->FrameworkVersion, version);
}

bool cmCPackIFWCommon::IsVersionGreater(char const* version) const
{
  if (!this->Generator) {
    return false;
  }

  return cmSystemTools::VersionCompare(
    cmSystemTools::OP_GREATER, this->Generator->FrameworkVersion, version);
}

bool cmCPackIFWCommon::IsVersionEqual(char const* version) const
{
  if (!this->Generator) {
    return false;
  }

  return cmSystemTools::VersionCompare(
    cmSystemTools::OP_EQUAL, this->Generator->FrameworkVersion, version);
}

void cmCPackIFWCommon::ExpandListArgument(
  std::string const& arg, std::map<std::string, std::string>& argsOut)
{
  cmList args{ arg };
  if (args.empty()) {
    return;
  }

  cmList::size_type i = 0;
  auto c = args.size();
  if (c % 2) {
    argsOut[""] = args[i];
    ++i;
  }

  --c;
  for (; i < c; i += 2) {
    argsOut[args[i]] = args[i + 1];
  }
}

void cmCPackIFWCommon::ExpandListArgument(
  std::string const& arg, std::multimap<std::string, std::string>& argsOut)
{
  cmList args{ arg };
  if (args.empty()) {
    return;
  }

  cmList::size_type i = 0;
  auto c = args.size();
  if (c % 2) {
    argsOut.insert(std::pair<std::string, std::string>("", args[i]));
    ++i;
  }

  --c;
  for (; i < c; i += 2) {
    argsOut.insert(std::pair<std::string, std::string>(args[i], args[i + 1]));
  }
}

void cmCPackIFWCommon::WriteGeneratedByToStrim(cmXMLWriter& xout) const
{
  if (!this->Generator) {
    return;
  }

  std::ostringstream comment;
  comment << "Generated by CPack " << CMake_VERSION << " IFW generator "
          << "for QtIFW ";
  if (this->IsVersionEqual("1.9.9")) {
    comment << "less 2.0";
  } else {
    comment << this->Generator->FrameworkVersion;
  }
  comment << " tools at " << cmTimestamp().CurrentTime("", true);
  xout.Comment(comment.str().c_str());
}
