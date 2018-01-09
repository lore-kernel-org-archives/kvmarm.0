From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 09/16] kvm: arm/arm64: Delay stage2 page table allocation
Date: Tue,  9 Jan 2018 19:04:04 +0000
Message-ID: <20180109190414.4017-10-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C371949DBA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1LYr5I3XjKxI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A8549D6F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:30 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, Christoffer Dall <cdall@linaro.org>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We allocate the entry level page tables for stage2 when the
VM is created. This doesn't give us the flexibility of configuring
the physical address space size for a VM. In order to allow
the VM to choose the required size, we delay the allocation of
stage2 entry level tables until we really try to map something.

This could be either when the VM creates a memory range or when
it tries to map a device memory. So we add in a hook to these
two places to make sure the tables are allocated. We use
kvm->slots_lock to serialize the allocation entry point, since
we add hooks to the arch specific call back with the mutex held.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/arm.c | 18 ++++++----------
 virt/kvm/arm/mmu.c | 61 +++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 19b720ddedce..d06f00566664 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -127,13 +127,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
 
-	ret = kvm_alloc_stage2_pgd(kvm);
-	if (ret)
-		goto out_fail_alloc;
-
 	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
-	if (ret)
-		goto out_free_stage2_pgd;
+	if (ret) {
+		free_percpu(kvm->arch.last_vcpu_ran);
+		kvm->arch.last_vcpu_ran = NULL;
+		return ret;
+	}
+
 
 	kvm_vgic_early_init(kvm);
 
@@ -145,12 +145,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 
 	return ret;
-out_free_stage2_pgd:
-	kvm_free_stage2_pgd(kvm);
-out_fail_alloc:
-	free_percpu(kvm->arch.last_vcpu_ran);
-	kvm->arch.last_vcpu_ran = NULL;
-	return ret;
 }
 
 bool kvm_arch_has_vcpu_debugfs(void)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index c94c61ac38b9..257f2a8ccfc7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1011,15 +1011,39 @@ static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
 	return stage2_ptep_test_and_clear_young((pte_t *)pmd);
 }
 
-/**
- * kvm_phys_addr_ioremap - map a device range to guest IPA
- *
- * @kvm:	The KVM pointer
- * @guest_ipa:	The IPA at which to insert the mapping
- * @pa:		The physical address of the device
- * @size:	The size of the mapping
+/*
+ * Finalise the stage2 page table layout. Must be called with kvm->slots_lock
+ * held.
  */
-int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
+static int __kvm_init_stage2_table(struct kvm *kvm)
+{
+	/* Double check if somebody has already allocated it */
+	if (likely(kvm->arch.pgd))
+		return 0;
+	return kvm_alloc_stage2_pgd(kvm);
+}
+
+static int kvm_init_stage2_table(struct kvm *kvm)
+{
+	int rc;
+
+	/*
+	 * Once allocated, the stage2 entry level tables are only
+	 * freed when the KVM instance is destroyed. So, if we see
+	 * something valid here, that guarantees that we have
+	 * done the one time allocation and it is something valid
+	 * and won't go away until the last reference to the KVM
+	 * is gone.
+	 */
+	if (likely(kvm->arch.pgd))
+		return 0;
+	mutex_lock(&kvm->slots_lock);
+	rc = __kvm_init_stage2_table(kvm);
+	mutex_unlock(&kvm->slots_lock);
+	return rc;
+}
+
+static int __kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
 {
 	phys_addr_t addr, end;
@@ -1055,6 +1079,23 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
+/**
+ * kvm_phys_addr_ioremap - map a device range to guest IPA.
+ * Acquires kvm->slots_lock for making sure that the stage2 is initialized.
+ *
+ * @kvm:	The KVM pointer
+ * @guest_ipa:	The IPA at which to insert the mapping
+ * @pa:		The physical address of the device
+ * @size:	The size of the mapping
+ */
+int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
+			  phys_addr_t pa, unsigned long size, bool writable)
+{
+	if (unlikely(kvm_init_stage2_table(kvm)))
+		return -ENOMEM;
+	return __kvm_phys_addr_ioremap(kvm, guest_ipa, pa, size, writable);
+}
+
 static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
@@ -1912,7 +1953,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				goto out;
 			}
 
-			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
+			ret = __kvm_phys_addr_ioremap(kvm, gpa, pa,
 						    vm_end - vm_start,
 						    writable);
 			if (ret)
@@ -1943,7 +1984,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
-	return 0;
+	return __kvm_init_stage2_table(kvm);
 }
 
 void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslots *slots)
-- 
2.13.6
