From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/28] KVM: arm/arm64: Introduce helpers to manipulate page
 table entries
Date: Wed, 19 Dec 2018 18:03:29 +0000
Message-ID: <20181219180349.242681-9-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7D64A390
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R7G44ZIjHh4Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6C84A393
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:32 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Punit Agrawal <punit.agrawal@arm.com>

Introduce helpers to abstract architectural handling of the conversion
of pfn to page table entries and marking a PMD page table entry as a
block entry.

The helpers are introduced in preparation for supporting PUD hugepages
at stage 2 - which are supported on arm64 but do not exist on arm.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  5 +++++
 arch/arm64/include/asm/kvm_mmu.h |  5 +++++
 virt/kvm/arm/mmu.c               | 14 ++++++++------
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 1098ffc3d54b..e6eff8bf5d7f 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -82,6 +82,11 @@ void kvm_clear_hyp_idmap(void);
 #define kvm_mk_pud(pmdp)	__pud(__pa(pmdp) | PMD_TYPE_TABLE)
 #define kvm_mk_pgd(pudp)	({ BUILD_BUG(); 0; })
 
+#define kvm_pfn_pte(pfn, prot)	pfn_pte(pfn, prot)
+#define kvm_pfn_pmd(pfn, prot)	pfn_pmd(pfn, prot)
+
+#define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 658657367f2f..13d482710292 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -184,6 +184,11 @@ void kvm_clear_hyp_idmap(void);
 #define kvm_mk_pgd(pudp)					\
 	__pgd(__phys_to_pgd_val(__pa(pudp)) | PUD_TYPE_TABLE)
 
+#define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
+#define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
+
+#define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= PTE_S2_RDWR;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 6912529946fb..fb5325f7a1ac 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -607,7 +607,7 @@ static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
 	addr = start;
 	do {
 		pte = pte_offset_kernel(pmd, addr);
-		kvm_set_pte(pte, pfn_pte(pfn, prot));
+		kvm_set_pte(pte, kvm_pfn_pte(pfn, prot));
 		get_page(virt_to_page(pte));
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
@@ -1202,7 +1202,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	pfn = __phys_to_pfn(pa);
 
 	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
-		pte_t pte = pfn_pte(pfn, PAGE_S2_DEVICE);
+		pte_t pte = kvm_pfn_pte(pfn, PAGE_S2_DEVICE);
 
 		if (writable)
 			pte = kvm_s2pte_mkwrite(pte);
@@ -1611,8 +1611,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
 
 	if (vma_pagesize == PMD_SIZE) {
-		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
-		new_pmd = pmd_mkhuge(new_pmd);
+		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
+
+		new_pmd = kvm_pmd_mkhuge(new_pmd);
+
 		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 
@@ -1621,7 +1623,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
-		pte_t new_pte = pfn_pte(pfn, mem_type);
+		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
 
 		if (writable) {
 			new_pte = kvm_s2pte_mkwrite(new_pte);
@@ -1878,7 +1880,7 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
 	clean_dcache_guest_page(pfn, PAGE_SIZE);
-	stage2_pte = pfn_pte(pfn, PAGE_S2);
+	stage2_pte = kvm_pfn_pte(pfn, PAGE_S2);
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
 }
 
-- 
2.19.2
