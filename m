From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/14] arm64 SSBD (aka Spectre-v4) mitigation
Date: Tue, 22 May 2018 16:06:34 +0100
Message-ID: <20180522150648.28297-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

This patch series implements the Linux kernel side of the "Spectre-v4"
(CVE-2018-3639) mitigation known as "Speculative Store Bypass Disable"
(SSBD).

More information can be found at:

  https://bugs.chromium.org/p/project-zero/issues/detail?id=1528
  https://developer.arm.com/support/arm-security-updates/speculative-processor-vulnerability

For all released Arm Cortex-A CPUs that are affected by this issue, then
the preferred mitigation is simply to set a chicken bit in the firmware
during CPU initialisation and therefore no change to Linux is required.
Other CPUs may require the chicken bit to be toggled dynamically (for
example, when switching between user-mode and kernel-mode) and this is
achieved by calling into EL3 via an SMC which has been published as part
of the latest SMCCC specification:

  https://developer.arm.com/cache-speculation-vulnerability-firmware-specification

as well as an ATF update for the released ARM cores affected by SSDB:

  https://github.com/ARM-software/arm-trusted-firmware/pull/1392

These patches provide the following:

  1. Safe probing of firmware to establish which CPUs in the system
     require calling into EL3 as part of the mitigation.

  2. For CPUs that require it, call into EL3 on exception entry/exit
     from EL0 to apply the SSBD mitigation when running at EL1.

  3. A command-line option to force the SSBD mitigation to be always on,
     always off, or dymamically toggled (default) for CPUs that require
     the EL3 call.

  4. An initial implementation of a prctl() backend for arm64 that allows
     userspace tasks to opt-in to the mitigation explicitly. This is
     intended to match the interface provided by x86, and so we rely on
     their core changes here. There still is an annoying issue with
     multithreaded seccomp tasks that get flagged with the mitigation
     whilst they are running in userspace.

  5. An initial implementation of the call via KVM, which exposes the
     mitigation to the guest via an HVC interface. This isn't yet
     complete and doesn't include save/restore functionality for the
     workaround state.

All comments welcome,

	M.

Marc Zyngier (14):
  arm/arm64: smccc: Add SMCCC-specific return codes
  arm64: Call ARCH_WORKAROUND_2 on transitions between EL0 and EL1
  arm64: Add per-cpu infrastructure to call ARCH_WORKAROUND_2
  arm64: Add ARCH_WORKAROUND_2 probing
  arm64: Add 'ssbd' command-line option
  arm64: ssbd: Add global mitigation state accessor
  arm64: ssbd: Skip apply_ssbd if not using dynamic mitigation
  arm64: ssbd: Disable mitigation on CPU resume if required by user
  arm64: ssbd: Introduce thread flag to control userspace mitigation
  arm64: ssbd: Add prctl interface for per-thread mitigation
  arm64: KVM: Add HYP per-cpu accessors
  arm64: KVM: Add ARCH_WORKAROUND_2 support for guests
  arm64: KVM: Handle guest's ARCH_WORKAROUND_2 requests
  arm64: KVM: Add ARCH_WORKAROUND_2 discovery through
    ARCH_FEATURES_FUNC_ID

 Documentation/admin-guide/kernel-parameters.txt |  17 +++
 arch/arm/include/asm/kvm_host.h                 |  12 ++
 arch/arm/include/asm/kvm_mmu.h                  |   5 +
 arch/arm64/Kconfig                              |   9 ++
 arch/arm64/include/asm/cpucaps.h                |   3 +-
 arch/arm64/include/asm/cpufeature.h             |  22 +++
 arch/arm64/include/asm/kvm_asm.h                |  30 +++-
 arch/arm64/include/asm/kvm_host.h               |  26 ++++
 arch/arm64/include/asm/kvm_mmu.h                |  24 ++++
 arch/arm64/include/asm/thread_info.h            |   1 +
 arch/arm64/kernel/Makefile                      |   1 +
 arch/arm64/kernel/asm-offsets.c                 |   1 +
 arch/arm64/kernel/cpu_errata.c                  | 173 ++++++++++++++++++++++++
 arch/arm64/kernel/entry.S                       |  30 ++++
 arch/arm64/kernel/ssbd.c                        | 107 +++++++++++++++
 arch/arm64/kernel/suspend.c                     |   8 ++
 arch/arm64/kvm/hyp/hyp-entry.S                  |  38 +++++-
 arch/arm64/kvm/hyp/switch.c                     |  42 ++++++
 arch/arm64/kvm/reset.c                          |   4 +
 include/linux/arm-smccc.h                       |  10 ++
 virt/kvm/arm/arm.c                              |   4 +
 virt/kvm/arm/psci.c                             |  18 ++-
 22 files changed, 579 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/kernel/ssbd.c

-- 
2.14.2
