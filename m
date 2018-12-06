From: lantianyu1986@gmail.com
Subject: [Resend PATCH V5 6/10] KVM: Replace old tlb flush function with new
 one to flush a specified range.
Date: Thu,  6 Dec 2018 21:21:09 +0800
Message-ID: <20181206132113.2691-7-Tianyu.Lan@microsoft.com>
References: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 699254A33B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 08:22:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vnijfC-agEuV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 08:22:14 -0500 (EST)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 766374A348
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 08:22:14 -0500 (EST)
Received: by mail-pf1-f196.google.com with SMTP id w73so166108pfk.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Dec 2018 05:22:14 -0800 (PST)
In-Reply-To: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
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
index 74df957f2f81..1cd3c316a7e6 100644
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
@@ -5672,7 +5679,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * on PT_WRITABLE_MASK anymore.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+			memslot->npages);
 }
 
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
@@ -5742,7 +5750,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	 * dirty_bitmap.
 	 */
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_leaf_clear_dirty);
 
@@ -5760,7 +5769,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	lockdep_assert_held(&kvm->slots_lock);
 
 	if (flush)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
+				memslot->npages);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
 
@@ -5777,7 +5787,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
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
