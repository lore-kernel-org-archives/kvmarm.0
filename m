From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 00/15] arm/arm64: KVM: Merge boot and runtime page tables
Date: Tue,  7 Jun 2016 11:58:20 +0100
Message-ID: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Until now, we've been setting up KVM using two sets of page tables:
one for the "boot" where we perform the basic MMU setup, and one for
the runtime.

Switching between the two was though to be safe, but we've recently
realized that it is not: it is not enough to ensure that the VA->PA
mapping is consistent when switching TTBR0_EL2, but we also have to
ensure that the intermediate translations are the same as well. If the
TLB can return two different values for intermediate translations,
we're screwed (TLB conflicts).

At that point, the only safe thing to do is to never change TTBR0_EL2,
which means that we need to make the idmap page part of the runtime
page tables.

The series starts with a bit of brain dumping explaining what we're
trying to do. This might not be useful as a merge candidate, but it
was useful for me to put this somewhere. It goes on revamping the
whole notion of HYP VA range, making it runtime patchable. It then
always merge idmap and runtime page table into one set, leading to
quite a lot of simplification in the init/teardown code. In the
process, 32bit KVM gains the ability to teardown the HYP page-tables
and vectors, which makes kexec a bit closer.

This has been tested on Seattle, Juno, the FVP model (both v8.0 and
v8.1), Cubietruck and Midway, and is based on 4.7-rc2.

Thanks,

	M.

Marc Zyngier (15):
  arm64: KVM: Merged page tables documentation
  arm64: KVM: Kill HYP_PAGE_OFFSET
  arm64: Add ARM64_HYP_OFFSET_LOW capability
  arm64: KVM: Define HYP offset masks
  arm64: KVM: Refactor kern_hyp_va/hyp_kern_va to deal with multiple
    offsets
  arm/arm64: KVM: Export __hyp_text_start/end symbols
  arm64: KVM: Runtime detection of lower HYP offset
  arm/arm64: KVM: Always have merged page tables
  arm64: KVM: Simplify HYP init/teardown
  arm/arm64: KVM: Drop boot_pgd
  arm/arm64: KVM: Kill free_boot_hyp_pgd
  arm: KVM: Simplify HYP init
  arm: KVM: Allow hyp teardown
  arm/arm64: KVM: Prune unused #defines
  arm/arm64: KVM: Check that IDMAP doesn't intersect with VA range

 arch/arm/include/asm/kvm_asm.h      |   2 +
 arch/arm/include/asm/kvm_host.h     |  25 +++-----
 arch/arm/include/asm/kvm_mmu.h      |  11 ----
 arch/arm/include/asm/virt.h         |   4 ++
 arch/arm/kvm/arm.c                  |  20 ++----
 arch/arm/kvm/init.S                 |  56 ++++++----------
 arch/arm/kvm/mmu.c                  | 125 ++++++++++++++++--------------------
 arch/arm64/include/asm/cpufeature.h |   3 +-
 arch/arm64/include/asm/kvm_host.h   |  17 ++---
 arch/arm64/include/asm/kvm_hyp.h    |  28 ++++----
 arch/arm64/include/asm/kvm_mmu.h    | 100 ++++++++++++++++++++++++-----
 arch/arm64/include/asm/virt.h       |   4 ++
 arch/arm64/kernel/cpufeature.c      |  19 ++++++
 arch/arm64/kvm/hyp-init.S           |  61 +++---------------
 arch/arm64/kvm/hyp/entry.S          |  19 ------
 arch/arm64/kvm/hyp/hyp-entry.S      |  15 +++++
 arch/arm64/kvm/reset.c              |  28 --------
 17 files changed, 240 insertions(+), 297 deletions(-)

-- 
2.1.4

