From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 00/14] kvmtool: Refactor kernel image loading to allow pipes
Date: Thu, 30 Jul 2015 11:52:17 +0100
Message-ID: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently kvmtool uses rewinds (lseeks to position 0) on kernel image
files. This prevents non-regular files (for instance pipes in the -k
parameter) from being used as a kernel image file.

This series reworks the kernel loading to avoid any seeks and allows
to pipe in kernel images on the command line. This basically gives us
decompression and direct kernel downloading for free in a neat UNIX
way:
$ lkvm run -k <(zcat zImage.gz) ...
$ lkvm run -k <(dd if=uImage bs=64 skip=1) ...
$ lkvm run -k <(wget -O - http://foo.com/guest.zImage) ...
$ lkvm run -k <(curl -s tftp://server/guest.zImage) ...

The first patch refactors the kernel image loading, which currently
tries to be architecture agnostic in a very intricate way. As the
actual implementations are very much architecture specific, make this
clear in the code by introducing separate functions for each arch.

Allowing pipes is quite easy for arm/arm64 and powerpc, since they
only do a (now pointless) rewind in the beginning, which we simply
drop in patch 2.
x86 requires some more love, patch 3 and 4 take care of that for
bzImage and "flat binaries", respectively.
Since the MIPS ELF loader contains an actual (non-rewinding) seek,
patch 5 adds a pipe-aware wrapper around lseek to still do some
(forward) seeking despite the file descriptor being non-seekable.
Patch 6, 7 and 8 then use this to eventually rework the kernel image
loading for MIPS to be pipe-safe, too.
Patch 9 moves the ARM kernel loading from arm/fdt.c into arm/kvm.c,
to be in line with the other architectures.
Now that we may read from pipes or sockets, simply using the read(2)
syscall breaks occasionally.
Patch 10 introduces a safe wrapper for reading whole files (inspired
by the ARM implementation), whereas patches 11-14 move the kernel
loading in each architecture over to using the safe read wrappers.

These patches apply on top of the latest kvmtool master branch.
So far I could test arm, arm64 and x86, with MIPS and PowerPC
being at least compile-tested.

Cheers,
Andre.

Andre Przywara (14):
  Refactor kernel image loading
  arm/powerpc: remove unneeded seeks in kernel loading
  x86: allow pipes for bzImage kernel images
  x86: support loading flat binary kernel images from a pipe
  kvmtool: introduce pseek
  MIPS: use pseek() in ELF kernel image loading
  MIPS: move ELF headers loading outside of load_elf_binary()
  MIPS: remove seeks from load_flat_binary()
  arm: move kernel loading into arm/kvm.c
  provide generic read_file() implementation
  arm/arm64: use read_file() in kernel and initrd loading
  powerpc: use read_file() in kernel and initrd loading
  MIPS: use read wrappers in kernel loading
  x86: use read wrappers in kernel loading

 arm/fdt.c                |  99 +---------------------------------------
 arm/kvm.c                |  87 ++++++++++++++++++++++++++++++++++++
 include/kvm/kvm.h        |   5 +--
 include/kvm/read-write.h |   4 ++
 kvm.c                    |  42 ++---------------
 mips/kvm.c               | 114 ++++++++++++++++++++++++++---------------------
 powerpc/kvm.c            |  42 ++++++++---------
 util/read-write.c        |  61 +++++++++++++++++++++++++
 x86/kvm.c                | 102 ++++++++++++++++++++++--------------------
 9 files changed, 297 insertions(+), 259 deletions(-)

-- 
2.3.5

