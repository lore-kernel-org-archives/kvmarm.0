Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB3EC48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 814FB215EA
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814FB215EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 373984A50C;
	Fri, 21 Jun 2019 05:40:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gnf+K65RavWB; Fri, 21 Jun 2019 05:40:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7BC04A554;
	Fri, 21 Jun 2019 05:40:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06FCF4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2X-F1N6kqcsL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:40:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B24F4A554
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E40014FF;
 Fri, 21 Jun 2019 02:40:12 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE03B3F246;
 Fri, 21 Jun 2019 02:40:10 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 38/59] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
Date: Fri, 21 Jun 2019 10:38:22 +0100
Message-Id: <20190621093843.220980-39-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
stage 2 page table for the guest hypervisor.

Note: A bunch of the code in mmu.c relating to MMU notifiers is
currently dealt with in an extremely abrupt way, for example by clearing
out an entire shadow stage-2 table. This will be handled in a more
efficient way using the reverse mapping feature in a later version of
the patch series.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h    |  3 +++
 arch/arm64/include/asm/kvm_nested.h |  3 +++
 arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                  |  4 ++-
 virt/kvm/arm/mmu.c                  | 42 +++++++++++++++++++++++------
 5 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 32bcaa1845dc..f4c5ac5eb95f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -163,6 +163,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **haddr);
 int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end);
 void free_hyp_pgds(void);
 
 void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
@@ -171,6 +173,7 @@ int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 052d46d96201..3b415bc76ced 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -48,6 +48,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_nested_s2_clear(struct kvm *kvm);
+extern void kvm_nested_s2_flush(struct kvm *kvm);
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 023027fa2db5..8880033fb6e0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -456,6 +456,45 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
 
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_wp(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(kvm));
+	}
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_clear(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
+	}
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_flush(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(kvm));
+	}
+}
+
 /*
  * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
  * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4e3cbfa1ecbe..bcca27d5c481 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1005,8 +1005,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Ensure a rebooted VM will fault in RAM pages and detect if the
 	 * guest MMU is turned off and flush the caches as needed.
 	 */
-	if (vcpu->arch.has_run_once)
+	if (vcpu->arch.has_run_once) {
 		stage2_unmap_vm(vcpu->kvm);
+		kvm_nested_s2_clear(vcpu->kvm);
+	}
 
 	vcpu_reset_hcr(vcpu);
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 3c7845832db8..94d400e7af57 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -416,12 +416,10 @@ static void stage2_flush_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 	} while (pud++, addr = next, addr != end);
 }
 
-static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
-				 struct kvm_memory_slot *memslot)
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end)
 {
 	struct kvm *kvm = mmu->kvm;
-	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
-	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 	phys_addr_t next;
 	pgd_t *pgd;
 
@@ -433,6 +431,15 @@ static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
+				 struct kvm_memory_slot *memslot)
+{
+	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
+
+	kvm_stage2_flush_range(mmu, addr, end);
+}
+
 /**
  * stage2_flush_vm - Invalidate cache for pages mapped in stage 2
  * @kvm: The struct kvm pointer
@@ -453,6 +460,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 
+	kvm_nested_s2_flush(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -1509,12 +1518,12 @@ static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 }
 
 /**
- * stage2_wp_range() - write protect stage2 memory region range
+ * kvm_stage2_wp_range() - write protect stage2 memory region range
  * @kvm:	The KVM pointer
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
@@ -1561,7 +1570,8 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_nested_s2_wp(kvm);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1585,7 +1595,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1600,6 +1610,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	kvm_nested_s2_wp(kvm);
 }
 
 static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
@@ -2111,6 +2122,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -2138,6 +2150,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 	 * through this calling path.
 	 */
 	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -2180,6 +2193,13 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 		return stage2_pmdp_test_and_clear_young(pmd);
 	else
 		return stage2_ptep_test_and_clear_young(pte);
+
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
+
+	return stage2_ptep_test_and_clear_young(pte);
 }
 
 static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
@@ -2198,6 +2218,11 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 		return pmd_young(*pmd);
 	else
 		return pte_young(*pte);
+
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
@@ -2455,6 +2480,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
