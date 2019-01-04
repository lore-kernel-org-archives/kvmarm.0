From: lantianyu1986@gmail.com
Subject: [PATCH 9/11] KVM/MMU: Flush tlb in the kvm_mmu_write_protect_pt_masked()
Date: Fri,  4 Jan 2019 16:54:03 +0800
Message-ID: <20190104085405.40356-10-Tianyu.Lan@microsoft.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patch is to flush tlb in the kvm_mmu_write_protect_pt_masked() when
tlb range flush is available and make kvm_mmu_write_protect_pt_masked()
return flush request.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/x86/kvm/mmu.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9d8ee6ea02db..30ed7a79335b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1624,20 +1624,30 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
  * Used when we do not need to care about huge page mappings: e.g. during dirty
  * logging we do not have any such mappings.
  */
-static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
+static bool kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask)
 {
 	struct kvm_rmap_head *rmap_head;
+	bool flush = false;
 
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		flush |= __rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
 	}
+
+	if (flush && kvm_available_flush_tlb_with_range()) {
+		kvm_flush_remote_tlbs_with_address(kvm,
+				slot->base_gfn + gfn_offset,
+				hweight_long(mask));
+		flush = false;
+	}
+
+	return flush;
 }
 
 /**
@@ -1683,13 +1693,14 @@ bool kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
-	if (kvm_x86_ops->enable_log_dirty_pt_masked)
+	if (kvm_x86_ops->enable_log_dirty_pt_masked) {
 		kvm_x86_ops->enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
 				mask);
-	else
-		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
-
-	return true;
+		return true;
+	} else {
+		return kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset,
+				mask);
+	}
 }
 
 /**
-- 
2.14.4
