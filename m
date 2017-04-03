From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC 0/9] ARMv8.3 pointer authentication userspace support
Date: Mon,  3 Apr 2017 16:19:16 +0100
Message-ID: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This series adds support for the ARMv8.3 pointer authentication extension.

I've included a quick intro to the extension below, with the usual series
description below that. The final patch of the series adds additional
documentation regarding the extension.

I've based the series on the arm64 for-next/core branch [1]. I'm aware that
this series may conflict with other patches currently in flight (e.g.
allocation of ELF notes), and I intend to rebase this series as things settle.

I've pushed the series to the arm64/pointer-auth branch [2] of my linux tree.
I've also pushed out a necessary bootwrapper patch to the pointer-auth branch
[3] of my bootwrapper repo.


Extension Overview 
==================

The ARMv8.3 pointer authentication extension adds functionality to detect
modification of pointer values, mitigating certain classes of attack such as
stack smashing, and making return oriented programming attacks harder

The extension introduces the concept of a pointer authentication code (PAC),
which is stored in some upper bits of pointers. Each PAC is derived from the
original pointer, another 64-bit value (e.g. the stack pointer), and a secret
128-bit key.

New instructions are added which can be used to:

* Insert a PAC into a pointer
* Strip a PAC from a pointer
* Authenticate strip a PAC from a pointer

If authentication succeeds, the code is removed, yielding the original pointer.
If authentication fails, bits are set in the pointer such that it is guaranteed
to cause a fault if used.

These instructions can make use of four keys:

* APIAKey (A.K.A. Instruction A key)
* APIBKey (A.K.A. Instruction B key)
* APDAKey (A.K.A. Data A key)
* APDBKey (A.K.A. Data B Key)

A subset of these instruction encodings have been allocated from the HINT
space, and will operate as NOPs on any ARMv8 parts which do not feature the
extension (or if purposefully disabled by the kernel). Software using only this
subset of the instructions should function correctly on all ARMv8-A parts.

Additionally, instructions are added to authenticate small blocks of memory in
similar fashion, using APGAKey (A.K.A. Generic key).


This Series
===========

This series enables the use of instructions using APIAKey, which is initialised
and maintained per-process (shared by all threads). This series does not add
support for APIBKey, APDAKey, APDBKey, nor APGAKey. The series only supports
the use of an architected algorithm.

I've given this some basic testing with a homebrew test suite. More ideally,
we'd add some tests to the kernel source tree.

I've added some basic KVM support, but this doesn't cater for systems with
mismatched support. Looking forward, we'll need ID register emulation in KVM so
that we can hide features from guests to cater for cases like this.

There are also a few questions to consider, e.g:

* Should we expose a per-process data key now, to go with the insn key?
* Should keys be per-thread rather than per-process?
* Should we expose generic authentication (i.e. APGAKey)?
* Should the kernel remove PACs when unwinding user stacks?

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
[2] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/pointer-auth
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mark/boot-wrapper-aarch64.git pointer-auth

Mark Rutland (9):
  asm-generic: mm_hooks: allow hooks to be overridden individually
  arm64: add pointer authentication register bits
  arm64/cpufeature: add ARMv8.3 id_aa64isar1 bits
  arm64/cpufeature: detect pointer authentication
  arm64: Don't trap host pointer auth use to EL2
  arm64: add basic pointer authentication support
  arm64: expose PAC bit positions via ptrace
  arm64/kvm: context-switch PAC registers
  arm64: docs: document pointer authentication

 Documentation/arm64/booting.txt                |  8 +++
 Documentation/arm64/pointer-authentication.txt | 78 +++++++++++++++++++++
 arch/arm64/Kconfig                             | 23 ++++++
 arch/arm64/include/asm/cpucaps.h               |  4 +-
 arch/arm64/include/asm/esr.h                   |  3 +-
 arch/arm64/include/asm/kvm_arm.h               |  2 +
 arch/arm64/include/asm/kvm_emulate.h           | 15 ++++
 arch/arm64/include/asm/kvm_host.h              | 12 ++++
 arch/arm64/include/asm/mmu.h                   |  5 ++
 arch/arm64/include/asm/mmu_context.h           | 25 ++++++-
 arch/arm64/include/asm/pointer_auth.h          | 96 ++++++++++++++++++++++++++
 arch/arm64/include/asm/sysreg.h                | 30 ++++++++
 arch/arm64/include/uapi/asm/hwcap.h            |  1 +
 arch/arm64/include/uapi/asm/ptrace.h           |  5 ++
 arch/arm64/kernel/cpufeature.c                 | 39 ++++++++++-
 arch/arm64/kernel/cpuinfo.c                    |  1 +
 arch/arm64/kernel/head.S                       | 19 ++++-
 arch/arm64/kernel/ptrace.c                     | 39 +++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c                 | 43 ++++++++++++
 include/asm-generic/mm_hooks.h                 | 12 ++++
 include/uapi/linux/elf.h                       |  1 +
 21 files changed, 454 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/arm64/pointer-authentication.txt
 create mode 100644 arch/arm64/include/asm/pointer_auth.h

-- 
1.9.1
