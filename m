From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/8] Workaround for Cortex-A76 erratum 1165522
Date: Fri, 23 Nov 2018 18:40:59 +0000
Message-ID: <20181123184107.39334-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3C04A236
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3qORdAxCdgqS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 13:41:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 459EF4A1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:17 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Early Cortex-A76 suffer from an erratum that can result in invalid
TLBs when the CPU speculatively executes an AT instruction in the
middle of a guest world switch, while the guest virtual memory
configuration is in an inconsistent state.

We handle this issue by mandating the use of VHE and making sure that
the guest context is fully installed before switching HCR_EL2.TGE to
zero. This ensures that a speculated AT instruction is either executed
on the host context (TGE set) or the guest context (TGE clear), and
that there is no intermediate state.

There is some additional complexity in the TLB invalidation code,
where we most make sure that a speculated AT instruction cannot mess
the stage-1 TLBs.

* From v1:
  - VHE TLB invalidation now atomic
  - Avoid speculated AT during TLB invalidation
  - Addressed most comments from Christoffer
  - Resplit to ease reviewing

Marc Zyngier (8):
  arm64: KVM: Make VHE Stage-2 TLB invalidation operations
    non-interruptible
  KVM: arm64: Rework detection of SVE, !VHE systems
  arm64: KVM: Install stage-2 translation before enabling traps
  arm64: Add TCR_EPD{0,1} definitions
  arm64: KVM: Force VHE for systems affected by erratum 1165522
  arm64: KVM: Add synchronization on translation regime change for
    erratum 1165522
  arm64: KVM: Handle ARM erratum 1165522 in TLB invalidation
  arm64: Add configuration/documentation for Cortex-A76 erratum 1165522

 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm/include/asm/kvm_host.h        |  2 +-
 arch/arm64/Kconfig                     | 12 +++++
 arch/arm64/include/asm/cpucaps.h       |  3 +-
 arch/arm64/include/asm/kvm_host.h      | 10 ++--
 arch/arm64/include/asm/kvm_hyp.h       |  7 +++
 arch/arm64/include/asm/pgtable-hwdef.h |  4 ++
 arch/arm64/kernel/cpu_errata.c         |  8 +++
 arch/arm64/kvm/hyp/switch.c            | 23 +++++++-
 arch/arm64/kvm/hyp/tlb.c               | 73 ++++++++++++++++++++++----
 virt/kvm/arm/arm.c                     |  8 +--
 11 files changed, 130 insertions(+), 21 deletions(-)

-- 
2.19.1
