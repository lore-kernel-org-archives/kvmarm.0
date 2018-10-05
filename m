From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH 00/17] ARMv8.3 pointer authentication support
Date: Fri,  5 Oct 2018 09:47:37 +0100
Message-ID: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series adds support for the ARMv8.3 pointer authentication
extension. The series contains Mark's original patches to enable pointer
authentication for userspace [1], followed by early RFC patches using
pointer authentication in the kernel.

For now it would make sense to focus on reviewing the userspace pointer
authentication patches, with the in-kernel pointer authentication
patches as support to show that the ABI exposed to userspace (e.g.
APIAKey) does not prevent pointer authentication use in the kernel.

This series is based on v4.19-rc5. The aarch64 bootwrapper [2] does the
necessary EL3 setup.


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


Userspace pointer authentication
================================

The first part of this series (sent as [PATCH v5]) adds support for
pointer authentication in userspace. This enables userspace return
address protection with GCC 7 and higher.

Changes since v4 [1]:
 - rebase onto v4.19-rc5
 - patch #7: move key init from init_new_context to arch_bprm_mm_init,
   remove unused mm_ctx_ptrauth_dup, add back mm_hooks patch from v3
 - patch #7: add AA64ISAR1.API HWCAP_CAP
 - patch #11: update cpu-feature-registers.txt
 - minor cleanups

I've kept all Reviewed-by/Acked-by/Tested-by tags from v4.

There are a couple of things worth noting:

1) Key support

This series enables the use of instructions using APIAKey, which is
initialised and maintained per-process (shared by all threads). GCC
currently only makes use of APIAKey.

This series does not add support for APIBKey, APDAKey, APDBKey, nor
APGAKey. HINT-space instructions using these keys will currently execute
as NOPs. Support for these keys can be added as users appear.

Note that while we expose the cpuid register (ID_AA64ISAR1_EL1) to
userspace, it only contains one feature for address authentication
(API/APA), so it cannot be used by userspace to tell which keys the
kernel supports. For this the kernel exposes HWCAP bits, one per key
(currently only APIAKey), which must be checked instead.

2) Checkpoint/restore

I have not yet looked at if checkpoint/restore works with applications
using pointer authentication. Presumably we will need to save and
restore the keys a task is using. To restore the keys from userspace, we
may need some way to set the keys for the task, such as through a prctl.

3) Key initialisation in Android

Currently, keys are preserved across fork and reinitialised on exec. If
keys were reinitialised on fork, it would break applications where both
parent and child return from the function that called fork.

This may however be a problem in environments where only fork is used to
start applications, and exec is not used. If I understand correctly, the
Android Zygote process model works like this. This would mean that in
Android, all processes would share the same key. We may therefore need a
mechanism for userspace to request keys to be reinitialised, e.g. a
clone flag, prctl, or trapped access to key registers.

4) KVM guest support

For the time being, this series hides pointer authentication
functionality from KVM guests. Amit Kachhap is currently looking into
supporting pointer authentication in guests.

5) uprobes

Setting uprobes on pointer authentication instructions is not yet
supported, and may cause the application to behave in unexpected ways.


In-kernel pointer authentication
================================

The second part of this series (sent as [RFC]) adds support for building
the kernel with pointer authentication instructions.

This means adding two instructions to every function: one to sign the
return address at the beginning of the function, and one to authenticate
the return address just before returning to it. If authentication fails,
the return will cause an exception to be taken, followed by a
panic/oops. This should help protect the kernel against attacks using
return-oriented programming.

Each task has its own pointer authentication key for use in the kernel,
initialized during fork. On systems without much entropy during early
boot, the earlier keys are unfortunately not unpredictable. Ideally the
kernel should get early randomness from firmware. Currently, this should
be possible on UEFI systems that support EFI_RNG_PROTOCOL (via
LINUX_EFI_RANDOM_SEED_TABLE_GUID). ARMv8.5-A will also add Random Number
instructions that should help with this [3].

The kernel currently uses only APIAKey, and switches it on entry and
exit to userspace. If/when GCC gains support for generating APIBKey
instructions, it may be worth switching to APIBKey if there is a
performance benefit (if userspace only uses APIAKey).

This series is currently intended as an RFC. Some things I haven't yet
looked at include:
  - debug and trace (ftrace, kprobes, __builtin_return_address(n),
    kdump, ...)
  - interaction with stack protector
  - suspend/resume
  - compiler without ptrauth support
  - separate kconfig option?

Feedback and comments are welcome.

Thanks,
Kristina

[1] https://lore.kernel.org/lkml/20180503132031.25705-1-mark.rutland@arm.com/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/mark/boot-wrapper-aarch64.git
[3] https://community.arm.com/processors/b/blog/posts/arm-a-profile-architecture-2018-developments-armv85a


Kristina Martsenko (3):
  arm64: enable ptrauth earlier
  arm64: initialize and switch ptrauth kernel keys
  arm64: compile the kernel with ptrauth -msign-return-address

Mark Rutland (14):
  arm64: add pointer authentication register bits
  arm64/kvm: consistently handle host HCR_EL2 flags
  arm64/kvm: hide ptrauth from guests
  arm64: Don't trap host pointer auth use to EL2
  arm64/cpufeature: detect pointer authentication
  asm-generic: mm_hooks: allow hooks to be overridden individually
  arm64: add basic pointer authentication support
  arm64: expose user PAC bit positions via ptrace
  arm64: perf: strip PAC when unwinding userspace
  arm64: enable pointer authentication
  arm64: docs: document pointer authentication
  arm64: move ptrauth keys to thread_info
  arm64: install user ptrauth keys at kernel exit time
  arm64: unwind: strip PAC from kernel addresses

 Documentation/arm64/booting.txt                |   8 ++
 Documentation/arm64/cpu-feature-registers.txt  |   4 +
 Documentation/arm64/elf_hwcaps.txt             |   5 ++
 Documentation/arm64/pointer-authentication.txt |  84 ++++++++++++++++++++
 arch/arm64/Kconfig                             |  23 ++++++
 arch/arm64/Makefile                            |   4 +
 arch/arm64/include/asm/cpucaps.h               |   5 +-
 arch/arm64/include/asm/cpufeature.h            |   9 +++
 arch/arm64/include/asm/esr.h                   |   3 +-
 arch/arm64/include/asm/kvm_arm.h               |   3 +
 arch/arm64/include/asm/mmu_context.h           |   3 +-
 arch/arm64/include/asm/pointer_auth.h          | 103 +++++++++++++++++++++++++
 arch/arm64/include/asm/ptrauth-asm.h           |  39 ++++++++++
 arch/arm64/include/asm/sysreg.h                |  30 +++++++
 arch/arm64/include/asm/thread_info.h           |   5 ++
 arch/arm64/include/uapi/asm/hwcap.h            |   1 +
 arch/arm64/include/uapi/asm/ptrace.h           |   7 ++
 arch/arm64/kernel/asm-offsets.c                |   8 ++
 arch/arm64/kernel/cpufeature.c                 |  51 ++++++++++++
 arch/arm64/kernel/cpuinfo.c                    |   1 +
 arch/arm64/kernel/entry.S                      |  13 +++-
 arch/arm64/kernel/head.S                       |   5 +-
 arch/arm64/kernel/perf_callchain.c             |   6 +-
 arch/arm64/kernel/process.c                    |   6 ++
 arch/arm64/kernel/ptrace.c                     |  38 +++++++++
 arch/arm64/kernel/smp.c                        |  10 ++-
 arch/arm64/kernel/stacktrace.c                 |   3 +
 arch/arm64/kvm/handle_exit.c                   |  18 +++++
 arch/arm64/kvm/hyp/switch.c                    |   2 +-
 arch/arm64/kvm/sys_regs.c                      |   8 ++
 include/asm-generic/mm_hooks.h                 |  11 +++
 include/uapi/linux/elf.h                       |   1 +
 32 files changed, 506 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/arm64/pointer-authentication.txt
 create mode 100644 arch/arm64/include/asm/pointer_auth.h
 create mode 100644 arch/arm64/include/asm/ptrauth-asm.h

-- 
2.11.0
