From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 04/12] kvm-arm: Rename kvm_pmd_huge to huge_pmd
Date: Mon, 14 Mar 2016 16:53:03 +0000
Message-ID: <1457974391-28456-5-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A550D49B54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rjBcqFLuZi7t for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF3E49B3D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:09 -0400 (EDT)
In-Reply-To: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_pmd_huge doesn't have any dependency on the page table
where the pmd lives (i.e, hyp vs. stage2). So, rename it to
huge_pmd() to make it explicit.

kvm_p.d_* wrappers will be used for helpers which differ
across hyp vs stage2.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a16631c..3b038bb 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -44,7 +44,7 @@ static phys_addr_t hyp_idmap_vector;
 
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
-#define kvm_pmd_huge(_x)	(pmd_huge(_x) || pmd_trans_huge(_x))
+#define huge_pmd(_x)		(pmd_huge(_x) || pmd_trans_huge(_x))
 #define kvm_pud_huge(_x)	pud_huge(_x)
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
@@ -114,7 +114,7 @@ static bool kvm_is_device_pfn(unsigned long pfn)
  */
 static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
 {
-	if (!kvm_pmd_huge(*pmd))
+	if (!huge_pmd(*pmd))
 		return;
 
 	pmd_clear(pmd);
@@ -176,7 +176,7 @@ static void clear_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
 static void clear_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
 {
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
-	VM_BUG_ON(kvm_pmd_huge(*pmd));
+	VM_BUG_ON(huge_pmd(*pmd));
 	pmd_clear(pmd);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
 	pte_free_kernel(NULL, pte_table);
@@ -239,7 +239,7 @@ static void unmap_pmds(struct kvm *kvm, pud_t *pud,
 	do {
 		next = kvm_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
-			if (kvm_pmd_huge(*pmd)) {
+			if (huge_pmd(*pmd)) {
 				pmd_t old_pmd = *pmd;
 
 				pmd_clear(pmd);
@@ -325,7 +325,7 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 	do {
 		next = kvm_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
-			if (kvm_pmd_huge(*pmd))
+			if (huge_pmd(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
 			else
 				stage2_flush_ptes(kvm, pmd, addr, next);
@@ -1043,7 +1043,7 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
 	do {
 		next = kvm_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
-			if (kvm_pmd_huge(*pmd)) {
+			if (huge_pmd(*pmd)) {
 				if (!kvm_s2pmd_readonly(pmd))
 					kvm_set_s2pmd_readonly(pmd);
 			} else {
@@ -1324,7 +1324,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		goto out;
 
-	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
+	if (huge_pmd(*pmd)) {	/* THP, HugeTLB */
 		*pmd = pmd_mkyoung(*pmd);
 		pfn = pmd_pfn(*pmd);
 		pfn_valid = true;
@@ -1532,7 +1532,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
-	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
+	if (huge_pmd(*pmd)) {	/* THP, HugeTLB */
 		if (pmd_young(*pmd)) {
 			*pmd = pmd_mkold(*pmd);
 			return 1;
@@ -1562,7 +1562,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
-	if (kvm_pmd_huge(*pmd))		/* THP, HugeTLB */
+	if (huge_pmd(*pmd))		/* THP, HugeTLB */
 		return pmd_young(*pmd);
 
 	pte = pte_offset_kernel(pmd, gpa);
-- 
1.7.9.5
