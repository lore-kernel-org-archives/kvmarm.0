From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 00/23] KVM/arm64: Randomise EL2 mappings (variant 3a
 mitigation)
Date: Thu,  1 Mar 2018 15:55:15 +0000
Message-ID: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>
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
itself (we get a new way to map the GIC at EL2).

Another (and more recent) goal of this series is to work around what
has been described as "variant 3a", which covers speculative reads of
privileged system registers. Randomizing the location of the
hypervisor would be pointless if one could simply obtain VBAR_EL2. In
order to work around this, we place the vectors at a fairly static
location (next to the idmap), independently of the hypervisor's own
mappings. This ensures that we can leak VBAR_EL2 without disclosing
much about HYP itself (and is similar to what the rest of the kernel
does with KPTI). This is only enabled at runtime for Cortex-A57 and
Cortex-A72.

This has been tested on the FVP model, Seattle (both 39 and 48bit VA),
Mustang and Thunder-X. I've also done a sanity check on 32bit (which
is only impacted by the HYP IO VA stuff).

Thanks,

	M.

* From v4:
  - Added some more patches to work around speculative reads of
    VBAR_EL2
  - Bunch of cleanups and clarifications thanks to Christoffer's review
  - Dropped the initial asm-offsets rework on which this series
    didn't really rely anymore

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

Marc Zyngier (23):
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
  arm64: KVM: Move vector offsetting from hyp-init.S to
    kvm_get_hyp_vector
  arm64: KVM: Move stashing of x0/x1 into the vector code itself
  arm64: KVM: Add epilogue branching to the vector code
  arm64: KVM: Allow far branches from vector slots to the main vectors
  arm/arm64: KVM: Introduce EL2-specific executable mappings
  arm64: Make BP hardening slot counter available
  arm64: KVM: Allow mapping of vectors outside of the RAM region
  arm64: Enable ARM64_HARDEN_EL2_VECTORS on Cortex-A57 and A72

 Documentation/arm64/memory.txt       |   9 +-
 arch/arm/include/asm/kvm_mmu.h       |  16 ++-
 arch/arm64/Kconfig                   |  16 +++
 arch/arm64/include/asm/alternative.h |  41 +++++++-
 arch/arm64/include/asm/cpucaps.h     |   2 +-
 arch/arm64/include/asm/insn.h        |  16 +++
 arch/arm64/include/asm/kvm_mmu.h     | 162 ++++++++++++++++++++---------
 arch/arm64/include/asm/mmu.h         |   8 +-
 arch/arm64/kernel/Makefile           |   4 +-
 arch/arm64/kernel/alternative.c      |  43 ++++++--
 arch/arm64/kernel/bpi.S              |  69 +++++++++----
 arch/arm64/kernel/cpu_errata.c       |  21 +++-
 arch/arm64/kernel/cpufeature.c       |  19 ----
 arch/arm64/kernel/insn.c             | 190 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/hyp-init.S            |   1 -
 arch/arm64/kvm/hyp/hyp-entry.S       |  58 ++++++-----
 arch/arm64/kvm/va_layout.c           | 184 +++++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h               |  12 +--
 virt/kvm/arm/hyp/vgic-v2-sr.c        |  12 +--
 virt/kvm/arm/mmu.c                   | 144 +++++++++++++++++++++-----
 virt/kvm/arm/vgic/vgic-init.c        |   6 --
 virt/kvm/arm/vgic/vgic-v2.c          |  40 +++-----
 23 files changed, 859 insertions(+), 216 deletions(-)
 create mode 100644 arch/arm64/kvm/va_layout.c

-- 
2.14.2
