From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 18/28] KVM: arm/arm64: Limit icache invalidation to prefetch aborts
Date: Wed, 31 Jan 2018 10:34:57 +0100
Message-ID: <20180131093507.22219-19-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We've so far eagerly invalidated the icache, no matter how
the page was faulted in (data or prefetch abort).

But we can easily track execution by setting the XN bits
in the S2 page tables, get the prefetch abort at HYP and
perform the icache invalidation at that time only.

As for most VMs, the instruction working set is pretty
small compared to the data set, this is likely to save
some traffic (specially as the invalidation is broadcast).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h        | 12 ++++++++++++
 arch/arm/include/asm/pgtable.h        |  4 ++--
 arch/arm64/include/asm/kvm_mmu.h      | 12 ++++++++++++
 arch/arm64/include/asm/pgtable-prot.h |  4 ++--
 virt/kvm/arm/mmu.c                    | 19 +++++++++++++++----
 5 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index bc8d21e76637..4d7a54cbb3ab 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -85,6 +85,18 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
 	return pmd;
 }
 
+static inline pte_t kvm_s2pte_mkexec(pte_t pte)
+{
+	pte_val(pte) &= ~L_PTE_XN;
+	return pte;
+}
+
+static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~PMD_SECT_XN;
+	return pmd;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *pte)
 {
 	pte_val(*pte) = (pte_val(*pte) & ~L_PTE_S2_RDWR) | L_PTE_S2_RDONLY;
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 150ece66ddf3..a757401129f9 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -102,8 +102,8 @@ extern pgprot_t		pgprot_s2_device;
 #define PAGE_HYP_EXEC		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_RDONLY)
 #define PAGE_HYP_RO		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_RDONLY | L_PTE_XN)
 #define PAGE_HYP_DEVICE		_MOD_PROT(pgprot_hyp_device, L_PTE_HYP)
-#define PAGE_S2			_MOD_PROT(pgprot_s2, L_PTE_S2_RDONLY)
-#define PAGE_S2_DEVICE		_MOD_PROT(pgprot_s2_device, L_PTE_S2_RDONLY)
+#define PAGE_S2			_MOD_PROT(pgprot_s2, L_PTE_S2_RDONLY | L_PTE_XN)
+#define PAGE_S2_DEVICE		_MOD_PROT(pgprot_s2_device, L_PTE_S2_RDONLY | L_PTE_XN)
 
 #define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT | L_PTE_RDONLY | L_PTE_XN | L_PTE_NONE)
 #define __PAGE_SHARED		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_XN)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 56b3e03c85e7..1e1b20cb348f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -173,6 +173,18 @@ static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
 	return pmd;
 }
 
+static inline pte_t kvm_s2pte_mkexec(pte_t pte)
+{
+	pte_val(pte) &= ~PTE_S2_XN;
+	return pte;
+}
+
+static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~PMD_S2_XN;
+	return pmd;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *pte)
 {
 	pteval_t old_pteval, pteval;
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 0a5635fb0ef9..4e12dabd342b 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -60,8 +60,8 @@
 #define PAGE_HYP_RO		__pgprot(_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
 #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
 
-#define PAGE_S2			__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
-#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_UXN)
+#define PAGE_S2			__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY | PTE_S2_XN)
+#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
 
 #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_PXN | PTE_UXN)
 #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 2174244f6317..0417c8e2a81c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1292,7 +1292,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, writable, hugetlb = false, force_pte = false;
+	bool write_fault, exec_fault, writable, hugetlb = false, force_pte = false;
 	unsigned long mmu_seq;
 	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
@@ -1304,7 +1304,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long flags = 0;
 
 	write_fault = kvm_is_write_fault(vcpu);
-	if (fault_status == FSC_PERM && !write_fault) {
+	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
+	VM_BUG_ON(write_fault && exec_fault);
+
+	if (fault_status == FSC_PERM && !write_fault && !exec_fault) {
 		kvm_err("Unexpected L2 read permission error\n");
 		return -EFAULT;
 	}
@@ -1398,7 +1401,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 		}
 		clean_dcache_guest_page(vcpu, pfn, PMD_SIZE);
-		invalidate_icache_guest_page(vcpu, pfn, PMD_SIZE);
+
+		if (exec_fault) {
+			new_pmd = kvm_s2pmd_mkexec(new_pmd);
+			invalidate_icache_guest_page(vcpu, pfn, PMD_SIZE);
+		}
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
@@ -1410,7 +1417,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 		clean_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
-		invalidate_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+
+		if (exec_fault) {
+			new_pte = kvm_s2pte_mkexec(new_pte);
+			invalidate_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+		}
 
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
-- 
2.14.2
