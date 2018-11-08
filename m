From: lantianyu1986@gmail.com
Subject: [Resend PATCH V5 5/10] KVM/MMU: Add tlb flush with range helper function
Date: Thu,  8 Nov 2018 22:46:34 +0800
Message-ID: <20181108144639.11206-5-Tianyu.Lan@microsoft.com>
References: <20181108144639.11206-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181108144639.11206-1-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patch is to add wrapper functions for tlb_remote_flush_with_range
callback and flush tlb directly in kvm_mmu_zap_collapsible_spte().
kvm_mmu_zap_collapsible_spte() returns flush request to the
slot_handle_leaf() and the latter does flush on demand. When
range flush is available, make kvm_mmu_zap_collapsible_spte()
to flush tlb with range directly to avoid returning range back
to slot_handle_leaf().

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
Change since V4:
       Remove flush list interface and flush tlb directly in
       kvm_mmu_zap_collapsible_spte().
Change since V3:
       Remove code of updating "tlbs_dirty"
Change since V2:
       Fix comment in the kvm_flush_remote_tlbs_with_range()
---
 arch/x86/kvm/mmu.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cf5f572f2305..c1d383532066 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -264,6 +264,35 @@ static void mmu_spte_set(u64 *sptep, u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
+
+static inline bool kvm_available_flush_tlb_with_range(void)
+{
+	return kvm_x86_ops->tlb_remote_flush_with_range;
+}
+
+static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
+		struct kvm_tlb_range *range)
+{
+	int ret = -ENOTSUPP;
+
+	if (range && kvm_x86_ops->tlb_remote_flush_with_range)
+		ret = kvm_x86_ops->tlb_remote_flush_with_range(kvm, range);
+
+	if (ret)
+		kvm_flush_remote_tlbs(kvm);
+}
+
+static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
+		u64 start_gfn, u64 pages)
+{
+	struct kvm_tlb_range range;
+
+	range.start_gfn = start_gfn;
+	range.pages = pages;
+
+	kvm_flush_remote_tlbs_with_range(kvm, &range);
+}
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value)
 {
 	BUG_ON((mmio_mask & mmio_value) != mmio_value);
@@ -5680,7 +5709,13 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 			!kvm_is_reserved_pfn(pfn) &&
 			PageTransCompoundMap(pfn_to_page(pfn))) {
 			pte_list_remove(rmap_head, sptep);
-			need_tlb_flush = 1;
+
+			if (kvm_available_flush_tlb_with_range())
+				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+					KVM_PAGES_PER_HPAGE(sp->role.level));
+			else
+				need_tlb_flush = 1;
+
 			goto restart;
 		}
 	}
-- 
2.14.4
