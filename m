From: lantianyu1986@gmail.com
Subject: [Resend PATCH V5 6/10] KVM: Replace old tlb flush function with new one to flush a specified range.
Date: Thu,  8 Nov 2018 22:46:35 +0800
Message-ID: <20181108144639.11206-6-Tianyu.Lan@microsoft.com>
References: <20181108144639.11206-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181108144639.11206-1-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patch is to replace kvm_flush_remote_tlbs() with kvm_flush_
remote_tlbs_with_address() in some functions without logic change.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/x86/kvm/mmu.c         | 31 +++++++++++++++++++++----------
 arch/x86/kvm/paging_tmpl.h |  3 ++-
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c1d383532066..af3e9e466014 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1485,8 +1485,12 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
-	if (__drop_large_spte(vcpu->kvm, sptep))
-		kvm_flush_remote_tlbs(vcpu->kvm);
+	if (__drop_large_spte(vcpu->kvm, sptep)) {
+		struct kvm_mmu_page *sp = page_header(__pa(sptep));
+
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+			KVM_PAGES_PER_HPAGE(sp->role.level));
+	}
 }
 
 /*
@@ -1954,7 +1958,8 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
 
 	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, 0);
-	kvm_flush_remote_tlbs(vcpu->kvm);
+	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
@@ -2470,7 +2475,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		account_shadowed(vcpu->kvm, sp);
 		if (level == PT_PAGE_TABLE_LEVEL &&
 		      rmap_write_protect(vcpu, gfn))
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
@@ -2590,7 +2595,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			return;
 
 		drop_parent_pte(child, sptep);
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
 	}
 }
 
@@ -3014,8 +3019,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
 			ret = RET_PF_EMULATE;
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	}
+
 	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH || flush)
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
+				KVM_PAGES_PER_HPAGE(level));
 
 	if (unlikely(is_mmio_spte(*sptep)))
 		ret = RET_PF_EMULATE;
@@ -5681,7 +5688,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * on PT_WRITABLE_MASK anymore.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+			memslot->npages);
 }
 
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
@@ -5751,7 +5759,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	 * dirty_bitmap.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_leaf_clear_dirty);
 
@@ -5769,7 +5778,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	lockdep_assert_held(&kvm->slots_lock);
 
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
 
@@ -5786,7 +5796,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	/* see kvm_mmu_slot_leaf_clear_dirty */
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7cf2185b7eb5..6bdca39829bc 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -894,7 +894,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
 			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
-				kvm_flush_remote_tlbs(vcpu->kvm);
+				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
+					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 
 			if (!rmap_can_add(vcpu))
 				break;
-- 
2.14.4
