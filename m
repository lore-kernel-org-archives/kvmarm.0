From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/10] KVM: arm/arm64: Limit icache invalidation to prefetch
 aborts
Date: Mon,  9 Oct 2017 16:20:27 +0100
Message-ID: <20171009152032.27804-6-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 421DA49D29
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 11:20:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ar7D3ZNLN32L for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Oct 2017 11:20:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF6049D26
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 11:20:27 -0400 (EDT)
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We've so far eagerly invalidated the icache, no matter how
the page was faulted in (data or prefetch abort).

But we can easily track execution by setting the XN bits
in the S2 page tables, get the prefetch abort at HYP and
perform the icache invalidation at that time only.

As for most VMs, the instruction working set is pretty
small compared to the data set, this is likely to save
some traffic (specially as the invalidation is broadcast).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h        | 12 ++++++++++++
 arch/arm/include/asm/pgtable.h        |  4 ++--
 arch/arm64/include/asm/kvm_mmu.h      | 12 ++++++++++++
 arch/arm64/include/asm/pgtable-prot.h |  4 ++--
 virt/kvm/arm/mmu.c                    | 19 +++++++++++++++----
 5 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 6773dcf21bff..bf76150aad5f 100644
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
index 1c462381c225..9b6e77b9ab7e 100644
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
index 48d31ca2ce9c..60c420a5ac0d 100644
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
index 9e5628388af8..1d47da22f75c 100644
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
 		coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
-		coherent_icache_guest_page(vcpu, pfn, PMD_SIZE);
+
+		if (exec_fault) {
+			new_pmd = kvm_s2pmd_mkexec(new_pmd);
+			coherent_icache_guest_page(vcpu, pfn, PMD_SIZE);
+		}
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
@@ -1410,7 +1417,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 		coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
-		coherent_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+
+		if (exec_fault) {
+			new_pte = kvm_s2pte_mkexec(new_pte);
+			coherent_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+		}
 
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
-- 
2.14.1
