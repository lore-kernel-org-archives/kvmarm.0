From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v6 00/13] ARMv8.3 pointer authentication userspace support
Date: Fri,  7 Dec 2018 18:39:18 +0000
Message-ID: <20181207183931.4285-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Richard Henderson <richard.henderson@linaro.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series adds support for the ARMv8.3 pointer authentication extension,
enabling userspace return address protection with GCC 7 and above.

(The previous version also had in-kernel pointer authentication patches
as RFC; these will be updated and sent at a later time.)

Changes since v5 [1]:
 - Exposed all 5 keys (not just APIAKey) [Will]
 - New prctl for reinitializing keys [Will]
 - New ptrace options for getting and setting keys [Will]
 - Keys now per-thread instead of per-mm [Catalin]
 - Fixed cpufeature detection for late CPUs [Suzuki]
 - Added comments for ESR_ELx_EC_* definitions [Will]
 - Rebased onto v4.20-rc5

This series is based on v4.20-rc5. The aarch64 bootwrapper [2] does the
necessary EL3 setup.

The patches are also available at:
  git://linux-arm.org/linux-km.git ptrauth-user


Extension Overview
==================

The ARMv8.3 pointer authentication extension adds functionality to detect
modification of pointer values, mitigating certain classes of attack such as
stack smashing, and making return oriented programming attacks harder.

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
space, and will operate as NOPs on any ARMv8-A parts which do not feature the
extension (or if purposefully disabled by the kernel). Software using only this
subset of the instructions should function correctly on all ARMv8-A parts.

Additionally, instructions are added to authenticate small blocks of memory in
similar fashion, using APGAKey (A.K.A. Generic key).


This series
===========

This series enables userspace to use any pointer authentication instructions,
using any of the 5 keys. The keys are initialised and maintained per-process
(shared by all threads).

For the time being, this series hides pointer authentication functionality from
KVM guests. Amit Kachhap is currently looking into supporting pointer
authentication in guests.

Setting uprobes on pointer authentication instructions is not yet supported, and
may cause the application to behave in unexpected ways.

Feedback and comments are welcome.

Thanks,
Kristina

[1] https://lore.kernel.org/lkml/20181005084754.20950-1-kristina.martsenko@arm.com/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/mark/boot-wrapper-aarch64.git


Kristina Martsenko (3):
  arm64: add comments about EC exception levels
  arm64: add prctl control for resetting ptrauth keys
  arm64: add ptrace regsets for ptrauth key management

Mark Rutland (10):
  arm64: add pointer authentication register bits
  arm64/kvm: consistently handle host HCR_EL2 flags
  arm64/kvm: hide ptrauth from guests
  arm64: Don't trap host pointer auth use to EL2
  arm64/cpufeature: detect pointer authentication
  arm64: add basic pointer authentication support
  arm64: expose user PAC bit positions via ptrace
  arm64: perf: strip PAC when unwinding userspace
  arm64: enable pointer authentication
  arm64: docs: document pointer authentication

 Documentation/arm64/booting.txt                |   8 ++
 Documentation/arm64/cpu-feature-registers.txt  |   8 ++
 Documentation/arm64/elf_hwcaps.txt             |  12 +++
 Documentation/arm64/pointer-authentication.txt |  93 +++++++++++++++++++++
 arch/arm64/Kconfig                             |  23 ++++++
 arch/arm64/include/asm/cpucaps.h               |   8 +-
 arch/arm64/include/asm/cpufeature.h            |  12 +++
 arch/arm64/include/asm/esr.h                   |  17 ++--
 arch/arm64/include/asm/kvm_arm.h               |   3 +
 arch/arm64/include/asm/pointer_auth.h          |  93 +++++++++++++++++++++
 arch/arm64/include/asm/processor.h             |   4 +
 arch/arm64/include/asm/sysreg.h                |  30 +++++++
 arch/arm64/include/asm/thread_info.h           |   4 +
 arch/arm64/include/uapi/asm/hwcap.h            |   2 +
 arch/arm64/include/uapi/asm/ptrace.h           |  25 ++++++
 arch/arm64/kernel/Makefile                     |   1 +
 arch/arm64/kernel/cpufeature.c                 | 103 +++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                    |   2 +
 arch/arm64/kernel/head.S                       |   5 +-
 arch/arm64/kernel/perf_callchain.c             |   6 +-
 arch/arm64/kernel/pointer_auth.c               |  47 +++++++++++
 arch/arm64/kernel/process.c                    |   4 +
 arch/arm64/kernel/ptrace.c                     | 110 +++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c                   |  18 ++++
 arch/arm64/kvm/hyp/switch.c                    |   2 +-
 arch/arm64/kvm/sys_regs.c                      |   8 ++
 include/uapi/linux/elf.h                       |   3 +
 include/uapi/linux/prctl.h                     |   8 ++
 kernel/sys.c                                   |   8 ++
 29 files changed, 653 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/arm64/pointer-authentication.txt
 create mode 100644 arch/arm64/include/asm/pointer_auth.h
 create mode 100644 arch/arm64/kernel/pointer_auth.c

-- 
2.11.0
