From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 08/31] KVM: arm/arm64: Make mmu functions non-static
Date: Mon,  2 Oct 2017 22:10:50 -0500
Message-ID: <1507000273-3735-6-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: jintack@cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Jintack Lim <jintack.lim@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Make mmu functions non-static so that we can reuse those functions
to support mmu for the nested VMs.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_mmu.h |  9 ++++
 virt/kvm/arm/mmu.c               | 94 +++++++++++++++++++++++-----------------
 2 files changed, 64 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 21c0299..bceaec1 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -145,9 +145,18 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_alloc_stage2_pgd(struct kvm *kvm);
+int __kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm *kvm);
+void __kvm_free_stage2_pgd(struct kvm *kvm, struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+void kvm_unmap_stage2_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			    phys_addr_t start, u64 size);
+void kvm_stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			 phys_addr_t addr, phys_addr_t end);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t start, phys_addr_t end);
+
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 184cdc9..ca10799 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -307,7 +307,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 }
 
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * kvm_unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @kvm:   The VM pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -317,12 +317,12 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			    phys_addr_t start, u64 size)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
 	phys_addr_t next;
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
 	assert_spin_locked(&kvm->mmu_lock);
 	pgd = mmu->pgd + stage2_pgd_index(addr);
@@ -391,11 +391,10 @@ static void stage2_flush_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
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
 
@@ -406,6 +405,15 @@ static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
+		struct kvm_memory_slot *memslot)
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
@@ -762,21 +770,9 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
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
@@ -793,6 +789,22 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
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
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -828,7 +840,8 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(kvm, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(kvm, &kvm->arch.mmu, gpa,
+					       vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -860,22 +873,13 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-/**
- * kvm_free_stage2_pgd - free all stage-2 tables
- * @kvm:	The KVM struct pointer for the VM.
- *
- * Walks the level-1 page table pointed to by kvm->arch.mmu.pgd and frees all
- * underlying level-2 and level-3 tables before freeing the actual level-1 table
- * and setting the struct pointer to NULL.
- */
-void kvm_free_stage2_pgd(struct kvm *kvm)
+void __kvm_free_stage2_pgd(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 {
 	void *pgd = NULL;
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
 	spin_lock(&kvm->mmu_lock);
 	if (mmu->pgd) {
-		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+		kvm_unmap_stage2_range(kvm, mmu, 0, KVM_PHYS_SIZE);
 		pgd = READ_ONCE(mmu->pgd);
 		mmu->pgd = NULL;
 	}
@@ -885,6 +889,18 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	if (pgd)
 		free_pages_exact(pgd, S2_PGD_SIZE);
 }
+/**
+ * kvm_free_stage2_pgd - free all stage-2 tables
+ * @kvm:	The KVM struct pointer for the VM.
+ *
+ * Walks the level-1 page table pointed to by kvm->arch.mmu.pgd and frees all
+ * underlying level-2 and level-3 tables before freeing the actual level-1 table
+ * and setting the struct pointer to NULL.
+ */
+void kvm_free_stage2_pgd(struct kvm *kvm)
+{
+	__kvm_free_stage2_pgd(kvm, &kvm->arch.mmu);
+}
 
 static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu,
 			     struct kvm_mmu_memory_cache *cache,
@@ -1204,7 +1220,7 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+void kvm_stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
 			    phys_addr_t addr, phys_addr_t end)
 {
 	pgd_t *pgd;
@@ -1251,7 +1267,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1275,7 +1291,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1626,7 +1642,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(kvm, gpa, size);
+	kvm_unmap_stage2_range(kvm, &kvm->arch.mmu, gpa, size);
 	return 0;
 }
 
@@ -1938,8 +1954,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size);
+		kvm_unmap_stage2_range(kvm, &kvm->arch.mmu,
+				       mem->guest_phys_addr, mem->memory_size);
 	else
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 	spin_unlock(&kvm->mmu_lock);
@@ -1975,7 +1991,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, gpa, size);
+	kvm_unmap_stage2_range(kvm, &kvm->arch.mmu, gpa, size);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
1.9.1
