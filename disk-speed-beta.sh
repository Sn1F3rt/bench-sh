#!/usr/bin/bash

echo "Testing hard drive write speed."
maxwrite="0"
for i in {1..3}; do
  printf 'Pass %s... ' $i
  dd if=/dev/zero of=diskbench.tmp bs=1M count=1024 conv=fdatasync > benchmark.tmp 2>&1
  speed=`tail -1 benchmark.tmp|awk '{print $8}'`
  unit=`tail -1 benchmark.tmp|awk '{print $9}'`
#  echo "$speed $unit"
  if (( $(echo "$speed > $maxwrite"|bc -l) )); then
    maxwrite=$speed
  fi
done
echo "$maxwrite $unit"

echo "Testing hard drive read speed with caching."
maxcache="0"
for i in {1..3}; do
  printf 'Pass %s... ' $i
  dd if=diskbench.tmp of=/dev/null bs=1M count=1024 > benchmark.tmp 2>&1
  speed=`tail -1 benchmark.tmp|awk '{print $8}'`
  unit=`tail -1 benchmark.tmp|awk '{print $9}'`
#  echo "$speed $unit"
  if (( $(echo "$speed > $maxcache"|bc -l) )); then
    maxcache=$speed
  fi
done
echo "$maxcache $unit"

echo "Testing hard drive read speed without caching."
maxread="0"
for i in {1..3}; do
  printf 'Pass %s... ' $i
  echo 3 > /proc/sys/vm/drop_caches
  dd if=diskbench.tmp of=/dev/null bs=1M count=1024 > benchmark.tmp 2>&1
  speed=`tail -1 benchmark.tmp|awk '{print $8}'`
  unit=`tail -1 benchmark.tmp|awk '{print $9}'`
#  echo "$speed $unit"
  if (( $(echo "$speed > $maxread"|bc -l) )); then
    maxread=$speed
  fi
done
echo "$maxread $unit"

echo "Testing cpu speed."
maxcpu="0"
for i in {1..3}; do
  printf 'Pass %s... ' $i
  output=$( { dd if=/dev/zero bs=1M count=1024|md5sum > benchmark.tmp; } 2>&1 )
  speed=`echo "$output"|tail -1|awk '{print $8}'`
  unit=`echo "$output"|tail -1|awk '{print $9}'`
#  echo "$speed $unit"
  if (( $(echo "$speed > $maxcpu"|bc -l) )); then
    maxcpu=$speed
  fi
done
echo "$maxcpu $unit"

rm -f diskbench.tmp
rm -f benchmark.tmp
