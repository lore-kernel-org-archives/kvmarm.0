From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 00/19] KVM/arm64: Randomise EL2 mappings
Date: Thu,  4 Jan 2018 18:43:15 +0000
Message-ID: <20180104184334.16571-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A2D49D98
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6eoAiLqoH05k for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jan 2018 13:39:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DBB349D28
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:39:20 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Whilst KVM benefits from the kernel randomisation via KASLR, there is
no additional randomisation when the kernel is running at EL1, as we
directly use a fixed offset from the linear mapping. This is not
necessarily a problem, but we could do a bit better by independently
randomizing the HYP placement.

This series proposes to randomise the offset by inserting a few random
bits between the MSB of the RAM linear mapping and the top of the HYP
VA (VA_BITS - 2). That's not a lot of random bits (on my Mustang, I
get 13 bits), but that's better than nothing.

In order to achieve this, we need to be able to patch dynamic values
in the kernel text. This results in a bunch of changes to the
alternative framework, the insn library, and a few more hacks in KVM
itself (we get a new way to map the GIC at EL2). This series used to
depend on a number of cleanups in asm-offsets, which is not the case
anymore. I'm still including them as I think they are still pretty
useful.

This has been tested on the FVP model, Seattle (both 39 and 48bit VA),
Mustang and Thunder-X. I've also done a sanity check on 32bit (which
is only impacted by the HYP IO VA stuff).

Thanks,

	M.

* From v3:
  - Reworked the alternative code to leave the actual patching to
    the callback function. This should allow for more flexibility
    should someone or something require it
  - Now detects underflows in the IOVA allocator
  - Moved the VA patching code to va_layout.c

* From v2:
  - Fixed a crapload of bugs in the immediate generation patch
    I now have a test harness for it, making sure it generates the
    same thing as GAS...
  - Fixed a bug in the asm-offsets.h exclusion patch
  - Reworked the alternative_cb code to be nicer and avoid generating
    pointless nops

* From v1:
  - Now works correctly with KASLR
  - Dropped the callback field from alt_instr, and reuse one of the
    existing fields to store an offset to the callback
  - Fix HYP teardown path (depends on fixes previously posted)
  - Dropped the VA offset macros

Marc Zyngier (19):
  arm64: asm-offsets: Avoid clashing DMA definitions
  arm64: asm-offsets: Remove unused definitions
  arm64: asm-offsets: Remove potential circular dependency
  arm64: alternatives: Enforce alignment of struct alt_instr
  arm64: alternatives: Add dynamic patching feature
  arm64: insn: Add N immediate encoding
  arm64: insn: Add encoder for bitwise operations using literals
  arm64: KVM: Dynamically patch the kernel/hyp VA mask
  arm64: cpufeatures: Drop the ARM64_HYP_OFFSET_LOW feature flag
  KVM: arm/arm64: Do not use kern_hyp_va() with kvm_vgic_global_state
  KVM: arm/arm64: Demote HYP VA range display to being a debug feature
  KVM: arm/arm64: Move ioremap calls to create_hyp_io_mappings
  KVM: arm/arm64: Keep GICv2 HYP VAs in kvm_vgic_global_state
  KVM: arm/arm64: Move HYP IO VAs to the "idmap" range
  arm64; insn: Add encoder for the EXTR instruction
  arm64: insn: Allow ADD/SUB (immediate) with LSL #12
  arm64: KVM: Dynamically compute the HYP VA mask
  arm64: KVM: Introduce EL2 VA randomisation
  arm64: Update the KVM memory map documentation

 Documentation/arm64/memory.txt             |   8 +-
 arch/arm/include/asm/kvm_hyp.h             |   6 +
 arch/arm/include/asm/kvm_mmu.h             |   4 +-
 arch/arm64/include/asm/alternative.h       |  49 ++++++--
 arch/arm64/include/asm/alternative_types.h |  17 +++
 arch/arm64/include/asm/asm-offsets.h       |   2 +
 arch/arm64/include/asm/cpucaps.h           |   2 +-
 arch/arm64/include/asm/insn.h              |  16 +++
 arch/arm64/include/asm/kvm_hyp.h           |   9 ++
 arch/arm64/include/asm/kvm_mmu.h           |  57 ++++-----
 arch/arm64/kernel/alternative.c            |  43 +++++--
 arch/arm64/kernel/asm-offsets.c            |  17 +--
 arch/arm64/kernel/cpufeature.c             |  19 ---
 arch/arm64/kernel/insn.c                   | 190 ++++++++++++++++++++++++++++-
 arch/arm64/kvm/Makefile                    |   2 +-
 arch/arm64/kvm/va_layout.c                 | 144 ++++++++++++++++++++++
 arch/arm64/mm/cache.S                      |   4 +-
 include/kvm/arm_vgic.h                     |  12 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c              |  12 +-
 virt/kvm/arm/mmu.c                         |  95 +++++++++++----
 virt/kvm/arm/vgic/vgic-init.c              |   6 -
 virt/kvm/arm/vgic/vgic-v2.c                |  40 ++----
 22 files changed, 589 insertions(+), 165 deletions(-)
 create mode 100644 arch/arm64/include/asm/alternative_types.h
 create mode 100644 arch/arm64/kvm/va_layout.c

-- 
2.14.2
