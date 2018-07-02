From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 0/6] KVM/arm64: Cache maintenance relaxations
Date: Mon,  2 Jul 2018 16:02:44 +0100
Message-ID: <20180702150250.16550-1-marc.zyngier@arm.com>
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
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This small series makes use of features recently introduced in the
ARMv8 architecture to relax the cache maintenance operations on CPUs
that implement these features.

FWB is the most important one. It allows stage-2 to enforce the
cacheability of memory, no matter what the guest says. It also
mandates that the whole machine is cache coherent (no non-coherent
I/O), meaning we can drop a whole class of cache maintenance
operations.

FWB also has the same effect as CTR_EL0.IDC being set, and when
combined with CTR_EL0.DIC allows the removal of all cache maintenance
and tracking of pages being executed.

We also take the opportunity to drop a few useless CMOs that were
applied to the HYP page tables, but that were never necessary. This
ended up requiring quite a few changes in out page table accessors so
that they get consistent barriers. These barriers are a bit on the
heavy side, and could be further optimized, although that's probably
for a different patch series

Unless someone screams now, I plan to apply this to kvmarm/next
shortly.

* From v1:
  - Reordered the series in a slightly more consistent order
  - Added patches refactoring the PT accessors before dropping
    the CMOs
  - Removed final dsb(ishst) from the last patch, as all PT accessors
    now have their own barriers
  - Collected Acks from Catalin

* From v2:
  - Dropped the clean to PoU when FWB, as it always implies IDC
  - Added comments about the pertinence of Set/Way CMOs in guests
  - Collected Acks and RBs

* From v3:
  - Fixed P[MU]D_TYPE_TABLE position in entry constructors
  - Clarified comment about FWB vs cleaning to PoU/PoC
  - Resplit patches 4 and 5
  - Dropped obsolete prototyped for a vanished function
  - Collected RBs

Marc Zyngier (6):
  arm64: KVM: Add support for Stage-2 control of memory types and
    cacheability
  arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is present
  arm64: KVM: Avoid marking pages as XN in Stage-2 if CTR_EL0.DIC is set
  KVM: arm/arm64: Consolidate page-table accessors
  KVM: arm/arm64: Stop using the kernel's {pmd,pud,pgd}_populate helpers
  KVM: arm/arm64: Remove unnecessary CMOs when creating HYP page tables

 arch/arm/include/asm/kvm_mmu.h        | 14 ++-------
 arch/arm64/include/asm/cpucaps.h      |  3 +-
 arch/arm64/include/asm/kvm_arm.h      |  1 +
 arch/arm64/include/asm/kvm_emulate.h  |  2 ++
 arch/arm64/include/asm/kvm_mmu.h      | 35 ++++++++++++++++-----
 arch/arm64/include/asm/memory.h       |  7 +++++
 arch/arm64/include/asm/pgtable-prot.h | 24 ++++++++++++--
 arch/arm64/include/asm/sysreg.h       |  1 +
 arch/arm64/kernel/cpufeature.c        | 20 ++++++++++++
 arch/arm64/kvm/sys_regs.c             | 11 ++++++-
 virt/kvm/arm/mmu.c                    | 45 ++++++++++++++++++++++-----
 11 files changed, 132 insertions(+), 31 deletions(-)

-- 
2.17.1
