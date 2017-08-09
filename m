From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 00/27] ARM Scalable Vector Extension (SVE)
Date: Wed,  9 Aug 2017 13:05:06 +0100
Message-ID: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This series implements Linux kernel support for the ARM Scalable Vector
Extension (SVE). [1]  It supersedes the previous RFC: see [6] for link
and a summary of changes.

This series depends on some series that are headed for v4.14:
see [3], [4], [5].

To reduce spam, some people may not been copied on the entire series.
For those who did not receive the whole series, it can be found in the
linux-arm-kernel archive. [2]

*Note* The final two patches (26-27) of the series are still RFC --
before committing to this ABI it would be good to get feedback on
whether the approach makes sense and whether it suitable for other
architectures.  These two patches are not required by the rest of the
series and can be revised or merged later.


Support for use of SVE by KVM guests is not currently included.
Instead, such use will be trapped and reflected to the guest as
undefined instruction execution.  SVE is hidden from the view of the
CPU feature registers visible to guests, so that guests will not
expect it to work.


This series has been build- and boot-tested on Juno r0 and the ARM FVP
Base model with SVE plugin.  Because there is no hardware with SVE
support yet, testing of the SVE functionality has only been performed on
the model.

Regression testing using LTP is under way and has also been completed on
previous versions of this series.


Series summary:

 * Patches 1-5 contain some individual bits of preparatory spadework,
   which are indirectly related to SVE.

Dave Martin (5):
  regset: Add support for dynamically sized regsets
  arm64: KVM: Hide unsupported AArch64 CPU features from guests
  arm64: efi: Add missing Kconfig dependency on KERNEL_MODE_NEON
  arm64: Port deprecated instruction emulation to new sysctl interface
  arm64: fpsimd: Simplify uses of {set,clear}_ti_thread_flag()

   Non-trivial changes among these are:

   * Patch 1: updates the regset core code to handle regsets whose size
     is not fixed at compile time.  This avoids bloating coredumps even
     though the maximum theoretical SVE regset size is large.

   * Patch 2: extends KVM to modify the ARM architectural ID registers
     seen by guests, by trapping and emulating certain registers.  For
     SVE this is a temporary measure, but it may be useful for other
     architecture extensions.  This patch may also be built on in the
     future, since the only registers currently emulated are those
     required for hiding SVE.

 * Patches 6-10 add SVE-specific system register and structure layout
   definitions, and the low-level boot code and accessors needed for
   making use of SVE.

Dave Martin (5):
  arm64/sve: System register and exception syndrome definitions
  arm64/sve: Low-level SVE architectural state manipulation functions
  arm64/sve: Kconfig update and conditional compilation support
  arm64/sve: Signal frame and context structure definition
  arm64/sve: Low-level CPU setup

 * Patches 11-13 implement the core context management facilities to
   provide each user task with its own SVE register context, signal
   handling facilities, and sane programmer's model interoperation
   between SVE and FPSIMD.

Dave Martin (3):
  arm64/sve: Core task context handling
  arm64/sve: Support vector length resetting for new processes
  arm64/sve: Signal handling support

 * Patches 14-15 provide backend logic for detecting and making use of
   the different SVE vector lengths supported by the hardware.

Dave Martin (2):
  arm64/sve: Backend logic for setting the vector length
  arm64/sve: Probe SVE capabilities and usable vector lengths

 * Patches 16-17 update the kernel-mode NEON / EFI FPSIMD frameworks to
   interoperate correctly with SVE.

Dave Martin (2):
  arm64/sve: Preserve SVE registers around kernel-mode NEON use
  arm64/sve: Preserve SVE registers around EFI runtime service calls

 * Patches 18-20 implement the userspace frontend for managing SVE,
   comprising ptrace, some new arch-specific prctl() calls, and a new
   sysctl for init-time setup.

Dave Martin (3):
  arm64/sve: ptrace and ELF coredump support
  arm64/sve: Add prctl controls for userspace vector length management
  arm64/sve: Add sysctl to set the default vector length for new
    processes

 * Patches 21-23 provide stub KVM extensions for using KVM only on the
   host, while denying guest access.  (A future series will extend this
   with full support for SVE in guests.)

Dave Martin (3):
  arm64/sve: KVM: Prevent guests from using SVE
  arm64/sve: KVM: Treat guest SVE use as undefined instruction
    execution
  arm64/sve: KVM: Hide SVE from CPU features exposed to guests

And finally:

 * Patch 24 disengages the safety catch, enabling the kernel SVE runtime
   support and allowing userspace to use SVE.

Dave Martin (1):
  arm64/sve: Detect SVE and activate runtime support

 * Patch 25 adds some basic documentation.

Dave Martin (1):
  arm64/sve: Add documentation

 * Patches 26-27 (which may be considered RFC) propose a mechanism to
   report the maximum runtime signal frame size to userspace.

Dave Martin (2):
  arm64: signal: Report signal frame size to userspace via auxv
  arm64/sve: signal: Include SVE when computing AT_MINSIGSTKSZ


Refernces:

[1] ARM Scalable Vector Extension
https://community.arm.com/groups/processors/blog/2016/08/22/technology-update-the-scalable-vector-extension-sve-for-the-armv8-a-architecture

[2] linux-arm-kernel August 2017 Archives by thread
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/thread.html

[3] [PATCH v2 REPOST 0/2] arm64: Abstract syscallno manipulation
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/522736.html
Accepted by Catalin for v4.14.

[4] [PATCH 0/5] Simplify kernel-mode NEON
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/523415.html
(Depends on [5].)
Accepted by Catalin for v4.14, pending upstream merge of [5].

[5] [PATCH resend 00/18] crypto: ARM/arm64 roundup for v4.14
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/520664.html
Accepted by Herbert Xu for v4.14.

[6] [RFC PATCH v2 00/41] Scalable Vector Extension (SVE) core support
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/495966.html

 * Account for the size of the frame link record in AT_MINSIGSTKSZ.

 * Give SVE insn generation macros more human-readable names.  Make SVE
   insn generation macro arg names more uniform and sligntly less
   cryptic.  Tidy up asm "for" loop macro.

 * Describe ID_AA64PFR0 SVE field in ftr_id_aa64pfr0[]: after upstream
   refactoring, this must be present to derive an ELF hwcap from the
   field.

 * Minor simplifications to head.S: promote code simplicity over
   avoiding MSRs, since this is a cold path.

 * Get rid of obsolete (and dodgy) sve_state() struct template macro.
   Explicit offset/size calculations are used instead.  The removal of
   variably-modified types also permits some trivial functions to be
   inlined in the source.

 * Adapt to simplified kernel-mode NEON / EFI FPSIMD framework.

 * ptrace: Flush regs back to thread_struct before dumping NT_ARM_SVE.
   This is currently redundant, since NT_PRFPREG happens to be dumped
   out first, and the flush done for that regset happens to flush the
   SVE regs too.  But this might change someday.  This isn't a hot path,
   so an extra flush isn't the end of the world.

 * PR_SVE_{SET,GET}_VL: Flags and vector length arguments for SET_VL
   merged (ABI change).  This makes saving and restoring the vector
   length and flags a good deal less painful.

 * PR_SVE_SET_VL: (And all other VL-setting interfaces): clamp VL to
   8192.  Some features of the SVE ISA won't work as expected if future
   arch revisions ever permit VLs above 8192, so we'll need userspace to
   request this explicitly.  This allows SET_VL(SVE_VL_MAX) to continue
   to work as expected today.

 * thread_struct.sve_flags member removed.  These flag(s) are made into
   thread flags instead.

 * VL_THREAD flag for VL setting (via ptrace/prctl) removed.  This is
   only protecting userspace from itself, so it's superfluous.  Instead,
   VL setting will always affect the current thread only.
   General-purpose code shouldn't be setting the VL in the first place.

 * TIF_SVE_VL_INHERIT flag (previously VL_INHERIT) now accessible via
   ptrace flags too.

 * Migrate default vl procfs interface to use sysctl.  Reinventing the
   wheel here is error-prone and unnecessary.

 * Improve system_supports_sve() to remove dead code when
   CONFIG_ARM64_SVE=n,

 * Fixed a use-before-allocation bug for dynamically allocated SVE task
   state.

 * Probe available vector lengths: SVE doesn't require every vector
   length up to the maximum to be supported by the hardware -- only
   power-of-two lengths are required.  The common vector lengths across
   all early CPUs are determined, and these are the vector lengths that
   userspace is permitted to set.  Late secondaries that lack support
   for any of these vector lengths are rejected.  (There will be at
   least one common VL, since support for VL=16 is mandatory.)

 * SIGILL userspace cleanly when SVE use is attempted, if the kernel or
   hardware configuration doesn't fully support it.

 * Hide SVE from the ID registers seen by the guest, and ensure
   attempted SVE use by guests is trapped and reflected to the guest as
   an undef.

 * Patch series resplit and redescribed.

 * Documentation updated to reflect ABI changes.


Full series and diffstat:

Dave Martin (27):
  regset: Add support for dynamically sized regsets
  arm64: KVM: Hide unsupported AArch64 CPU features from guests
  arm64: efi: Add missing Kconfig dependency on KERNEL_MODE_NEON
  arm64: Port deprecated instruction emulation to new sysctl interface
  arm64: fpsimd: Simplify uses of {set,clear}_ti_thread_flag()
  arm64/sve: System register and exception syndrome definitions
  arm64/sve: Low-level SVE architectural state manipulation functions
  arm64/sve: Kconfig update and conditional compilation support
  arm64/sve: Signal frame and context structure definition
  arm64/sve: Low-level CPU setup
  arm64/sve: Core task context handling
  arm64/sve: Support vector length resetting for new processes
  arm64/sve: Signal handling support
  arm64/sve: Backend logic for setting the vector length
  arm64/sve: Probe SVE capabilities and usable vector lengths
  arm64/sve: Preserve SVE registers around kernel-mode NEON use
  arm64/sve: Preserve SVE registers around EFI runtime service calls
  arm64/sve: ptrace and ELF coredump support
  arm64/sve: Add prctl controls for userspace vector length management
  arm64/sve: Add sysctl to set the default vector length for new
    processes
  arm64/sve: KVM: Prevent guests from using SVE
  arm64/sve: KVM: Treat guest SVE use as undefined instruction execution
  arm64/sve: KVM: Hide SVE from CPU features exposed to guests
  arm64/sve: Detect SVE and activate runtime support
  arm64/sve: Add documentation
  arm64: signal: Report signal frame size to userspace via auxv
  arm64/sve: signal: Include SVE when computing AT_MINSIGSTKSZ

 Documentation/arm64/sve.txt              | 454 ++++++++++++++++++++
 arch/arm64/Kconfig                       |  12 +
 arch/arm64/include/asm/cpu.h             |   4 +
 arch/arm64/include/asm/cpucaps.h         |   3 +-
 arch/arm64/include/asm/cpufeature.h      |  34 ++
 arch/arm64/include/asm/elf.h             |   5 +
 arch/arm64/include/asm/esr.h             |   3 +-
 arch/arm64/include/asm/fpsimd.h          |  68 ++-
 arch/arm64/include/asm/fpsimdmacros.h    | 137 ++++++
 arch/arm64/include/asm/kvm_arm.h         |   4 +-
 arch/arm64/include/asm/processor.h       |  10 +
 arch/arm64/include/asm/sysreg.h          |  16 +
 arch/arm64/include/asm/thread_info.h     |   2 +
 arch/arm64/include/asm/traps.h           |   2 +
 arch/arm64/include/uapi/asm/auxvec.h     |   3 +-
 arch/arm64/include/uapi/asm/hwcap.h      |   1 +
 arch/arm64/include/uapi/asm/ptrace.h     | 130 ++++++
 arch/arm64/include/uapi/asm/sigcontext.h | 113 ++++-
 arch/arm64/kernel/armv8_deprecated.c     |  15 +-
 arch/arm64/kernel/cpufeature.c           |  64 +++
 arch/arm64/kernel/cpuinfo.c              |   7 +
 arch/arm64/kernel/entry-fpsimd.S         |  17 +
 arch/arm64/kernel/entry.S                |  14 +-
 arch/arm64/kernel/fpsimd.c               | 699 ++++++++++++++++++++++++++++++-
 arch/arm64/kernel/head.S                 |  13 +-
 arch/arm64/kernel/process.c              |   6 +-
 arch/arm64/kernel/ptrace.c               | 288 ++++++++++++-
 arch/arm64/kernel/signal.c               | 214 +++++++++-
 arch/arm64/kernel/signal32.c             |   2 +-
 arch/arm64/kernel/traps.c                |   5 +-
 arch/arm64/kvm/handle_exit.c             |   8 +
 arch/arm64/kvm/hyp/switch.c              |  12 +-
 arch/arm64/kvm/sys_regs.c                | 236 +++++++++--
 arch/arm64/mm/proc.S                     |  14 +-
 fs/binfmt_elf.c                          |   6 +-
 include/linux/regset.h                   |  67 ++-
 include/uapi/linux/elf.h                 |   1 +
 include/uapi/linux/prctl.h               |   9 +
 kernel/sys.c                             |  12 +
 39 files changed, 2583 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/arm64/sve.txt

-- 
2.1.4
