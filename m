From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 6/8] KVM: arm/arm64: Preserve Exec permission across R/W
 permission faults
Date: Fri, 20 Oct 2017 16:49:02 +0100
Message-ID: <20171020154904.31427-7-marc.zyngier@arm.com>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA9E49D3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 11:48:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fmATUexYlyNf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 11:48:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BCEB49D48
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 11:48:20 -0400 (EDT)
In-Reply-To: <20171020154904.31427-1-marc.zyngier@arm.com>
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

So far, we loose the Exec property whenever we take permission
faults, as we always reconstruct the PTE/PMD from scratch. This
can be counter productive as we can end-up with the following
fault sequence:

	X -> RO -> ROX -> RW -> RWX

Instead, we can lookup the existing PTE/PMD and clear the XN bit in the
new entry if it was already cleared in the old one, leadig to a much
nicer fault sequence:

	X -> ROX -> RWX

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 10 ++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
 virt/kvm/arm/mmu.c               | 27 +++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 4d7a54cbb3ab..aab64fe52146 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -107,6 +107,11 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
 	return (pte_val(*pte) & L_PTE_S2_RDWR) == L_PTE_S2_RDONLY;
 }
 
+static inline bool kvm_s2pte_exec(pte_t *pte)
+{
+	return !(pte_val(*pte) & L_PTE_XN);
+}
+
 static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
 {
 	pmd_val(*pmd) = (pmd_val(*pmd) & ~L_PMD_S2_RDWR) | L_PMD_S2_RDONLY;
@@ -117,6 +122,11 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
 }
 
+static inline bool kvm_s2pmd_exec(pmd_t *pmd)
+{
+	return !(pmd_val(*pmd) & PMD_SECT_XN);
+}
+
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 1e1b20cb348f..126abefffe7f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -203,6 +203,11 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
 	return (pte_val(*pte) & PTE_S2_RDWR) == PTE_S2_RDONLY;
 }
 
+static inline bool kvm_s2pte_exec(pte_t *pte)
+{
+	return !(pte_val(*pte) & PTE_S2_XN);
+}
+
 static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
 {
 	kvm_set_s2pte_readonly((pte_t *)pmd);
@@ -213,6 +218,11 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return kvm_s2pte_readonly((pte_t *)pmd);
 }
 
+static inline bool kvm_s2pmd_exec(pmd_t *pmd)
+{
+	return !(pmd_val(*pmd) & PMD_S2_XN);
+}
+
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f956efbd933d..b83b5a8442bb 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -926,6 +926,25 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
+static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
+{
+	pmd_t *pmdp;
+	pte_t *ptep;
+
+	pmdp = stage2_get_pmd(kvm, NULL, addr);
+	if (!pmdp || pmd_none(*pmdp) || !pmd_present(*pmdp))
+		return false;
+
+	if (pmd_thp_or_huge(*pmdp))
+		return kvm_s2pmd_exec(pmdp);
+
+	ptep = pte_offset_kernel(pmdp, addr);
+	if (!ptep || pte_none(*ptep) || !pte_present(*ptep))
+		return false;
+
+	return kvm_s2pte_exec(ptep);
+}
+
 static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
@@ -1407,6 +1426,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (exec_fault) {
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
 			invalidate_icache_guest_page(vcpu, pfn, PMD_SIZE);
+		} else if (fault_status == FSC_PERM) {
+			/* Preserve execute if XN was already cleared */
+			if (stage2_is_exec(kvm, fault_ipa))
+				new_pmd = kvm_s2pmd_mkexec(new_pmd);
 		}
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
@@ -1425,6 +1448,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (exec_fault) {
 			new_pte = kvm_s2pte_mkexec(new_pte);
 			invalidate_icache_guest_page(vcpu, pfn, PAGE_SIZE);
+		} else if (fault_status == FSC_PERM) {
+			/* Preserve execute if XN was already cleared */
+			if (stage2_is_exec(kvm, fault_ipa))
+				new_pte = kvm_s2pte_mkexec(new_pte);
 		}
 
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
-- 
2.14.1
