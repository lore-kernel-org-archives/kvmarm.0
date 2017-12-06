From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/18] KVM/arm64: Randomise EL2 mappings
Date: Wed,  6 Dec 2017 14:38:21 +0000
Message-ID: <20171206143839.29223-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Whilst KVM benefits from the kernel randomisation when running VHE,
there is no randomisation whatsoever when the kernel is running at
EL1, as we directly use a fixed offset from the linear mapping.

This series proposes to randomise the offset by inserting a few random
bits between the MSB of the linear mapping and the top of the HYP VA
(VA_BITS - 2). That's not a lot of random bits (on my Mustang, I get
13 bits), but that's better than nothing.

In order to achieve this, we need to be able to patch dynamic values
in the kernel text. This results in a bunch of changes to the
alternative framework, the insn library, cleanups in asm-offsets, and
a few more hacks in KVM itself (we get a new way to map the GIC at
EL2).

This has been tested on the FVP model, Seattle (both 39 and 48bit VA),
Mustang and Thunder-X. I've also done a sanity check on 32bit (which
is only impacted by the HYP IO VA stuff).

Thanks,

	M.

Marc Zyngier (18):
  arm64: asm-offsets: Avoid clashing DMA definitions
  arm64: asm-offsets: Remove unused definitions
  arm64: asm-offsets: Remove potential circular dependency
  arm64: alternatives: Enforce alignment of struct alt_instr
  arm64: alternatives: Add dynamic patching feature
  arm64: insn: Add N immediate encoding
  arm64: insn: Add encoder for bitwise operations using litterals
  arm64: KVM: Dynamically patch the kernel/hyp VA mask
  arm64: cpufeatures: Drop the ARM64_HYP_OFFSET_LOW feature flag
  arm64; insn: Add encoder for the EXTR instruction
  arm64: insn: Allow ADD/SUB (immediate) with LSL #12
  arm64: KVM: Introduce EL2 VA randomisation
  arm64: Update the KVM memory map documentation
  KVM: arm/arm64: Do not use kern_hyp_va() with kvm_vgic_global_state
  KVM: arm/arm64: Demote HYP VA range display to being a debug feature
  KVM: arm/arm64: Move ioremap calls to create_hyp_io_mappings
  KVM: arm/arm64: Keep GICv2 HYP VAs in kvm_vgic_global_state
  KVM: arm/arm64: Move HYP IO VAs to the "idmap" range

 Documentation/arm64/memory.txt             |   8 +-
 arch/arm/include/asm/kvm_hyp.h             |   6 +
 arch/arm/include/asm/kvm_mmu.h             |   4 +-
 arch/arm64/include/asm/alternative.h       |  47 ++++---
 arch/arm64/include/asm/alternative_types.h |  17 +++
 arch/arm64/include/asm/asm-offsets.h       |   2 +
 arch/arm64/include/asm/cpucaps.h           |   2 +-
 arch/arm64/include/asm/insn.h              |  16 +++
 arch/arm64/include/asm/kvm_hyp.h           |   9 ++
 arch/arm64/include/asm/kvm_mmu.h           |  54 ++++----
 arch/arm64/kernel/alternative.c            |  13 +-
 arch/arm64/kernel/asm-offsets.c            |  17 +--
 arch/arm64/kernel/cpufeature.c             |  19 ---
 arch/arm64/kernel/insn.c                   | 191 ++++++++++++++++++++++++++++-
 arch/arm64/kvm/Makefile                    |   2 +-
 arch/arm64/kvm/haslr.c                     | 129 +++++++++++++++++++
 arch/arm64/mm/cache.S                      |   4 +-
 include/kvm/arm_vgic.h                     |  12 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c              |  12 +-
 virt/kvm/arm/mmu.c                         |  63 +++++++---
 virt/kvm/arm/vgic/vgic-init.c              |   6 -
 virt/kvm/arm/vgic/vgic-v2.c                |  40 ++----
 22 files changed, 519 insertions(+), 154 deletions(-)
 create mode 100644 arch/arm64/include/asm/alternative_types.h
 create mode 100644 arch/arm64/kvm/haslr.c

-- 
2.14.2
