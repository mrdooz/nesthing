#pragma once

namespace nes
{
  template <typename V, typename S = V>
  struct RollingAverage
  {
    RollingAverage(size_t numSamples)
    : _samples(numSamples)
    , _samplesUsed(0)
    , _nextSample(0)
    , _sum(0)
    {
    }

    void AddSample(V v)
    {
      if (_samplesUsed < _samples.size())
      {
        _samples[_samplesUsed++] = v;
        _sum += v;
      }
      else
      {
        _sum -= _samples[_nextSample];
        _sum += v;
        _samples[_nextSample] = v;
        _nextSample = (_nextSample + 1) % _samples.size();
      }
    }

    V GetAverage() const
    {
      return _samplesUsed == 0 ? 0 : _sum / _samplesUsed;
    }

    V GetPeak() const
    {
      V m = std::numeric_limits<V>::min();
      for (size_t i = 0; i < _samplesUsed; ++i)
      {
        m = max(m, _samples[i]);
      }
      return m;
    }

    vector<V> _samples;
    size_t _samplesUsed;
    size_t _nextSample;
    S _sum;
  };
}

