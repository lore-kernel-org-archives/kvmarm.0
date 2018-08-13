From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v2 2/2] KVM: arm/arm64: Skip updating PTE entry if no change
Date: Mon, 13 Aug 2018 10:40:49 +0100
Message-ID: <20180813094049.3726-3-punit.agrawal@arm.com>
References: <20180813094049.3726-1-punit.agrawal@arm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180813094049.3726-1-punit.agrawal@arm.com>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, marc.zyngier@arm.com, christoffer.dall@arm.com, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When there is contention on faulting in a particular page table entry
at stage 2, the break-before-make requirement of the architecture can
lead to additional refaulting due to TLB invalidation.

Avoid this by skipping a page table update if the new value of the PTE
matches the previous value.

Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
Change-Id: I28e17daf394a4821b13c2cf8726bf72bf30434f9
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: stable@vger.kernel.org
---
 virt/kvm/arm/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 2ab977edc63c..d0a9dccc3793 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1120,6 +1120,10 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	/* Create 2nd stage page table mapping - Level 3 */
 	old_pte = *pte;
 	if (pte_present(old_pte)) {
+		/* Skip page table update if there is no change */
+		if (pte_val(old_pte) == pte_val(*new_pte))
+			goto out;
+
 		kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
@@ -1127,6 +1131,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	}
 
 	kvm_set_pte(pte, *new_pte);
+out:
 	return 0;
 }
 
-- 
2.18.0
