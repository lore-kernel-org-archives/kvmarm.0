From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 00/28] ARM: KVM: Rewrite the world switch in C (mostly)
Date: Thu,  4 Feb 2016 11:00:17 +0000
Message-ID: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that the arm64 rewrite is in mainline, I've taken a stab at fixing
the 32bit code the same way. This is fairly straightforward (once
you've been through it once...), with a few patches that adapt the
code to be similar to the 64bit version.

Note that the timer and GIC code should be made common between the two
architectures, as this is litterally the exact same code (I've posted
some proof of concept for that a while ago, see
http://www.spinics.net/lists/kvm/msg126775.html).

This has been tested on a Dual A7, and the code is pushed on a branch:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm/wsinc

	M.

* From v1:
  - Rebased on -rc2
  - Moved VTCR setup out of the init sequence (and into C code)
  - Now depends on the first patch of the VHE series

Marc Zyngier (28):
  ARM: KVM: Move the  HYP code to its own section
  ARM: KVM: Remove __kvm_hyp_code_start/__kvm_hyp_code_end
  ARM: KVM: Move VFP registers to a CPU context structure
  ARM: KVM: Move CP15 array into the CPU context structure
  ARM: KVM: Move GP registers into the CPU context structure
  ARM: KVM: Add a HYP-specific header file
  ARM: KVM: Add system register accessor macros
  ARM: KVM: Add TLB invalidation code
  ARM: KVM: Add CP15 save/restore code
  ARM: KVM: Add timer save/restore
  ARM: KVM: Add vgic v2 save/restore
  ARM: KVM: Add VFP save/restore
  ARM: KVM: Add banked registers save/restore
  ARM: KVM: Add guest entry code
  ARM: KVM: Add VFP lazy save/restore handler
  ARM: KVM: Add the new world switch implementation
  ARM: KVM: Add populating of fault data structure
  ARM: KVM: Add HYP mode entry code
  ARM: KVM: Add panic handling code
  ARM: KVM: Change kvm_call_hyp return type to unsigned long
  ARM: KVM: Remove the old world switch
  ARM: KVM: Switch to C-based stage2 init
  ARM: KVM: Remove __weak attributes
  ARM: KVM: Turn CP15 defines to an enum
  ARM: KVM: Cleanup asm-offsets.c
  ARM: KVM: Remove unused hyp_pc field
  ARM: KVM: Remove handling of ARM_EXCEPTION_DATA/PREF_ABORT
  ARM: KVM: Remove __kvm_hyp_exit/__kvm_hyp_exit_end

 arch/arm/include/asm/kvm_asm.h     |  41 +--
 arch/arm/include/asm/kvm_emulate.h |  15 +-
 arch/arm/include/asm/kvm_host.h    |  61 +++-
 arch/arm/include/asm/kvm_mmu.h     |   2 +-
 arch/arm/include/asm/virt.h        |   4 +
 arch/arm/kernel/asm-offsets.c      |  40 +--
 arch/arm/kernel/vmlinux.lds.S      |   6 +
 arch/arm/kvm/Makefile              |   1 +
 arch/arm/kvm/arm.c                 |   2 +-
 arch/arm/kvm/coproc.c              |  52 +--
 arch/arm/kvm/coproc.h              |  16 +-
 arch/arm/kvm/emulate.c             |  34 +-
 arch/arm/kvm/guest.c               |   5 +-
 arch/arm/kvm/handle_exit.c         |   7 -
 arch/arm/kvm/hyp/Makefile          |  14 +
 arch/arm/kvm/hyp/banked-sr.c       |  77 +++++
 arch/arm/kvm/hyp/cp15-sr.c         |  84 +++++
 arch/arm/kvm/hyp/entry.S           | 101 ++++++
 arch/arm/kvm/hyp/hyp-entry.S       | 169 ++++++++++
 arch/arm/kvm/hyp/hyp.h             | 130 ++++++++
 arch/arm/kvm/hyp/s2-setup.c        |  34 ++
 arch/arm/kvm/hyp/switch.c          | 228 +++++++++++++
 arch/arm/kvm/hyp/timer-sr.c        |  71 ++++
 arch/arm/kvm/hyp/tlb.c             |  71 ++++
 arch/arm/kvm/hyp/vfp.S             |  68 ++++
 arch/arm/kvm/hyp/vgic-v2-sr.c      |  84 +++++
 arch/arm/kvm/init.S                |   8 -
 arch/arm/kvm/interrupts.S          | 480 +--------------------------
 arch/arm/kvm/interrupts_head.S     | 648 -------------------------------------
 arch/arm/kvm/reset.c               |   2 +-
 arch/arm64/include/asm/kvm_asm.h   |   3 -
 31 files changed, 1265 insertions(+), 1293 deletions(-)
 create mode 100644 arch/arm/kvm/hyp/Makefile
 create mode 100644 arch/arm/kvm/hyp/banked-sr.c
 create mode 100644 arch/arm/kvm/hyp/cp15-sr.c
 create mode 100644 arch/arm/kvm/hyp/entry.S
 create mode 100644 arch/arm/kvm/hyp/hyp-entry.S
 create mode 100644 arch/arm/kvm/hyp/hyp.h
 create mode 100644 arch/arm/kvm/hyp/s2-setup.c
 create mode 100644 arch/arm/kvm/hyp/switch.c
 create mode 100644 arch/arm/kvm/hyp/timer-sr.c
 create mode 100644 arch/arm/kvm/hyp/tlb.c
 create mode 100644 arch/arm/kvm/hyp/vfp.S
 create mode 100644 arch/arm/kvm/hyp/vgic-v2-sr.c
 delete mode 100644 arch/arm/kvm/interrupts_head.S

-- 
2.1.4

