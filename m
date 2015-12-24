From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM updates for 4.5
Date: Thu, 24 Dec 2015 11:12:08 +0000
Message-ID: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Amit Singh Tomar <amittomer25@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Jisheng Zhang <jszhang@marvell.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

THis is the first pull request for the 4.5 merge window. Not much in
terms of features, but a rewrite of our 64bit world switch, making it
a lot nicer, maintainable, and much more likely to cope with things
like VHE. Also support 16bit VMIDs for systems that need to run that
many VMs concurrently.

I was really hoping that the PMU code would make it this time around,
but it got slightly delayed, and the holiday season didn't help. If
we're lucky enough (read: if all known issues have been addressed), I
may send you another pull request early in the new year.

In the mean time, please pull!

Happy Christmas,

      M.

The following changes since commit 9f9499ae8e6415cefc4fe0a96ad0e27864353c89:

  Linux 4.4-rc5 (2015-12-13 17:42:58 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-1

for you to fetch changes up to c7da6fa43cb1c5e649da0f478a491feb9208cae7:

  arm/arm64: KVM: Detect vGIC presence at runtime (2015-12-18 12:01:58 +0000)

----------------------------------------------------------------
KVM/ARM changes for Linux v4.5

- Complete rewrite of the arm64 world switch in C, hopefully
  paving the way for more sharing with the 32bit code, better
  maintainability and easier integration of new features.
  Also smaller and slightly faster in some cases...
- Support for 16bit VM identifiers
- Various cleanups

----------------------------------------------------------------
Amit Tomar (1):
      KVM: arm/arm64: Count guest exit due to various reasons

Fengguang Wu (1):
      MAINTAINERS: add git URL for KVM/ARM

Jisheng Zhang (1):
      KVM: arm/arm64: vgic: make vgic_io_ops static

Marc Zyngier (23):
      arm64: KVM: Add a HYP-specific header file
      arm64: KVM: Implement vgic-v2 save/restore
      KVM: arm/arm64: vgic-v3: Make the LR indexing macro public
      arm64: KVM: Implement vgic-v3 save/restore
      arm64: KVM: Implement timer save/restore
      arm64: KVM: Implement system register save/restore
      arm64: KVM: Implement 32bit system register save/restore
      arm64: KVM: Implement debug save/restore
      arm64: KVM: Implement guest entry
      arm64: KVM: Add patchable function selector
      arm64: KVM: Implement the core world switch
      arm64: KVM: Implement fpsimd save/restore
      arm64: KVM: Implement TLB handling
      arm64: KVM: HYP mode entry points
      arm64: KVM: Add panic handling
      arm64: KVM: Add compatibility aliases
      arm64: KVM: Map the kernel RO section into HYP
      arm64: KVM: Move away from the assembly version of the world switch
      arm64: KVM: Turn system register numbers to an enum
      arm64: KVM: Cleanup asm-offset.c
      arm64: KVM: Remove weak attributes
      ARM: KVM: Cleanup exception injection
      arm64: KVM: debug: Remove spurious inline attributes

Mark Rutland (1):
      arm64: Add macros to read/write system registers

Pavel Fedin (1):
      arm/arm64: KVM: Detect vGIC presence at runtime

Vladimir Murzin (3):
      arm/arm64: KVM: Remove unreferenced S2_PGD_ORDER
      arm: KVM: Make kvm_arm.h friendly to assembly code
      arm64: KVM: Add support for 16-bit VMID

 MAINTAINERS                          |    1 +
 arch/arm/include/asm/kvm_arm.h       |   34 +-
 arch/arm/include/asm/kvm_host.h      |    6 +
 arch/arm/include/asm/kvm_mmu.h       |    5 +
 arch/arm/kvm/arm.c                   |   40 +-
 arch/arm/kvm/emulate.c               |   74 +--
 arch/arm/kvm/guest.c                 |    6 +
 arch/arm/kvm/handle_exit.c           |    3 +
 arch/arm/kvm/mmio.c                  |    3 +
 arch/arm/kvm/mmu.c                   |    6 +-
 arch/arm64/include/asm/kvm_arm.h     |    3 +-
 arch/arm64/include/asm/kvm_asm.h     |   76 ---
 arch/arm64/include/asm/kvm_emulate.h |    1 -
 arch/arm64/include/asm/kvm_host.h    |   87 ++-
 arch/arm64/include/asm/kvm_mmio.h    |    1 -
 arch/arm64/include/asm/kvm_mmu.h     |    9 +-
 arch/arm64/include/asm/sysreg.h      |   21 +
 arch/arm64/kernel/asm-offsets.c      |   40 +-
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/guest.c               |   10 +-
 arch/arm64/kvm/handle_exit.c         |    4 +
 arch/arm64/kvm/hyp-init.S            |    9 +
 arch/arm64/kvm/hyp.S                 | 1081 +---------------------------------
 arch/arm64/kvm/hyp/Makefile          |   14 +
 arch/arm64/kvm/hyp/debug-sr.c        |  140 +++++
 arch/arm64/kvm/hyp/entry.S           |  160 +++++
 arch/arm64/kvm/hyp/fpsimd.S          |   33 ++
 arch/arm64/kvm/hyp/hyp-entry.S       |  212 +++++++
 arch/arm64/kvm/hyp/hyp.h             |   90 +++
 arch/arm64/kvm/hyp/switch.c          |  175 ++++++
 arch/arm64/kvm/hyp/sysreg-sr.c       |  138 +++++
 arch/arm64/kvm/hyp/timer-sr.c        |   71 +++
 arch/arm64/kvm/hyp/tlb.c             |   80 +++
 arch/arm64/kvm/hyp/vgic-v2-sr.c      |   84 +++
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  228 +++++++
 arch/arm64/kvm/sys_regs.c            |   59 +-
 arch/arm64/kvm/vgic-v2-switch.S      |  134 -----
 arch/arm64/kvm/vgic-v3-switch.S      |  269 ---------
 include/clocksource/arm_arch_timer.h |    6 +
 include/kvm/arm_vgic.h               |    6 +
 virt/kvm/arm/vgic-v3.c               |   11 +-
 virt/kvm/arm/vgic.c                  |    2 +-
 42 files changed, 1731 insertions(+), 1704 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/Makefile
 create mode 100644 arch/arm64/kvm/hyp/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/entry.S
 create mode 100644 arch/arm64/kvm/hyp/fpsimd.S
 create mode 100644 arch/arm64/kvm/hyp/hyp-entry.S
 create mode 100644 arch/arm64/kvm/hyp/hyp.h
 create mode 100644 arch/arm64/kvm/hyp/switch.c
 create mode 100644 arch/arm64/kvm/hyp/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/timer-sr.c
 create mode 100644 arch/arm64/kvm/hyp/tlb.c
 create mode 100644 arch/arm64/kvm/hyp/vgic-v2-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
 delete mode 100644 arch/arm64/kvm/vgic-v2-switch.S
 delete mode 100644 arch/arm64/kvm/vgic-v3-switch.S
