From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 38/55] KVM: arm/arm64: Make mmu functions non-static
Date: Mon,  9 Jan 2017 01:24:34 -0500
Message-ID: <1483943091-1364-39-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3714404BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xTkHUNWy7-YR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:39 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2D0340296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:39 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWAM017317
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:21 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 354D282
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:21 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 1AEFE83
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:21 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QKV0041485
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:20 -0500
Received: by mail-qk0-f198.google.com with SMTP id x64so109019013qkb.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:20 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Make mmu functions non-static so that we can reuse those functions
to support mmu for the nested VMs.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/mmu.c               | 90 +++++++++++++++++++++++-----------------
 arch/arm64/include/asm/kvm_mmu.h |  9 ++++
 2 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 56358fa..98b42e8 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -301,7 +301,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 }
 
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * kvm_unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @kvm:   The VM pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -311,8 +311,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu,
-			       phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
@@ -374,11 +373,10 @@ static void stage2_flush_puds(pgd_t *pgd,
 	} while (pud++, addr = next, addr != end);
 }
 
-static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
-				 struct kvm_memory_slot *memslot)
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t start, phys_addr_t end)
 {
-	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
-	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
+	phys_addr_t addr = start;
 	phys_addr_t next;
 	pgd_t *pgd;
 
@@ -389,6 +387,15 @@ static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
+				 struct kvm_memory_slot *memslot)
+{
+	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = start + PAGE_SIZE * memslot->npages;
+
+	kvm_stage2_flush_range(mmu, start, end);
+}
+
 /**
  * stage2_flush_vm - Invalidate cache for pages mapped in stage 2
  * @kvm: The struct kvm pointer
@@ -745,21 +752,9 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
 }
 
-/**
- * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
- * @kvm:	The KVM struct pointer for the VM.
- *
- * Allocates only the stage-2 HW PGD level table(s) (can support either full
- * 40-bit input addresses or limited to 32-bit input addresses). Clears the
- * allocated pages.
- *
- * Note we don't need locking here as this is only called when the VM is
- * created, which can only be done once.
- */
-int kvm_alloc_stage2_pgd(struct kvm *kvm)
+int __kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	pgd_t *pgd;
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
 	if (mmu->pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
@@ -776,6 +771,22 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	return 0;
 }
 
+/**
+ * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
+ * @kvm:	The KVM struct pointer for the VM.
+ *
+ * Allocates only the stage-2 HW PGD level table(s) (can support either full
+ * 40-bit input addresses or limited to 32-bit input addresses). Clears the
+ * allocated pages.
+ *
+ * Note we don't need locking here as this is only called when the VM is
+ * created, which can only be done once.
+ */
+int kvm_alloc_stage2_pgd(struct kvm *kvm)
+{
+	return __kvm_alloc_stage2_pgd(&kvm->arch.mmu);
+}
+
 static void stage2_unmap_memslot(struct kvm_s2_mmu *mmu,
 				 struct kvm_memory_slot *memslot)
 {
@@ -811,7 +822,7 @@ static void stage2_unmap_memslot(struct kvm_s2_mmu *mmu,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(mmu, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -841,6 +852,17 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+void __kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
+{
+	if (mmu->pgd == NULL)
+		return;
+
+	kvm_unmap_stage2_range(mmu, 0, KVM_PHYS_SIZE);
+	/* Free the HW pgd, one page at a time */
+	free_pages_exact(mmu->pgd, S2_PGD_SIZE);
+	mmu->pgd = NULL;
+}
+
 /**
  * kvm_free_stage2_pgd - free all stage-2 tables
  * @kvm:	The KVM struct pointer for the VM.
@@ -854,15 +876,7 @@ void stage2_unmap_vm(struct kvm *kvm)
  */
 void kvm_free_stage2_pgd(struct kvm *kvm)
 {
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
-
-	if (mmu->pgd == NULL)
-		return;
-
-	unmap_stage2_range(mmu, 0, KVM_PHYS_SIZE);
-	/* Free the HW pgd, one page at a time */
-	free_pages_exact(mmu->pgd, S2_PGD_SIZE);
-	mmu->pgd = NULL;
+	__kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
 static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu,
@@ -1175,13 +1189,13 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 }
 
 /**
- * stage2_wp_range() - write protect stage2 memory region range
+ * kvm_stage2_wp_range() - write protect stage2 memory region range
  * @kvm:	The KVM pointer
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
-			    phys_addr_t addr, phys_addr_t end)
+void kvm_stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			 phys_addr_t addr, phys_addr_t end)
 {
 	pgd_t *pgd;
 	phys_addr_t next;
@@ -1225,7 +1239,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1249,7 +1263,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1589,7 +1603,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 {
-	unmap_stage2_range(&kvm->arch.mmu, gpa, PAGE_SIZE);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, PAGE_SIZE);
 	return 0;
 }
 
@@ -1900,7 +1914,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr,
+		kvm_unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr,
 				   mem->memory_size);
 	else
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
@@ -1944,7 +1958,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3455c4..a504162 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -145,9 +145,18 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_alloc_stage2_pgd(struct kvm *kvm);
+int __kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm *kvm);
+void __kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
+			    u64 size);
+void kvm_stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			 phys_addr_t addr, phys_addr_t end);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t start, phys_addr_t end);
+
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
-- 
1.9.1
