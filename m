From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 05/17] kvm-arm: Replace kvm_pmd_huge with pmd_thp_or_huge
Date: Mon,  4 Apr 2016 17:26:05 +0100
Message-ID: <1459787177-12767-6-git-send-email-suzuki.poulose@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56310409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OGQrx0O3OHxp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 12:25:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8853E410D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:37 -0400 (EDT)
In-Reply-To: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Both arm and arm64 now provides a helper, pmd_thp_or_huge()
to check if the given pmd represents a huge page. Use that
instead of our own custom check.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 774d00b..7837f0a 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -45,7 +45,6 @@ static phys_addr_t hyp_idmap_vector;
 
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
-#define kvm_pmd_huge(_x)	(pmd_huge(_x) || pmd_trans_huge(_x))
 #define kvm_pud_huge(_x)	pud_huge(_x)
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
@@ -115,7 +114,7 @@ static bool kvm_is_device_pfn(unsigned long pfn)
  */
 static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
 {
-	if (!kvm_pmd_huge(*pmd))
+	if (!pmd_thp_or_huge(*pmd))
 		return;
 
 	pmd_clear(pmd);
@@ -177,7 +176,7 @@ static void clear_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
 static void clear_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
 {
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
-	VM_BUG_ON(kvm_pmd_huge(*pmd));
+	VM_BUG_ON(pmd_thp_or_huge(*pmd));
 	pmd_clear(pmd);
 	kvm_tlb_flush_vmid_ipa(kvm, addr);
 	pte_free_kernel(NULL, pte_table);
@@ -240,7 +239,7 @@ static void unmap_pmds(struct kvm *kvm, pud_t *pud,
 	do {
 		next = kvm_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
-			if (kvm_pmd_huge(*pmd)) {
+			if (pmd_thp_or_huge(*pmd)) {
 				pmd_t old_pmd = *pmd;
 
 				pmd_clear(pmd);
@@ -326,7 +325,7 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 	do {
 		next = kvm_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
-			if (kvm_pmd_huge(*pmd))
+			if (pmd_thp_or_huge(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
 			else
 				stage2_flush_ptes(kvm, pmd, addr, next);
@@ -1050,7 +1049,7 @@ static void stage2_wp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
 	do {
 		next = kvm_pmd_addr_end(addr, end);
 		if (!pmd_none(*pmd)) {
-			if (kvm_pmd_huge(*pmd)) {
+			if (pmd_thp_or_huge(*pmd)) {
 				if (!kvm_s2pmd_readonly(pmd))
 					kvm_set_s2pmd_readonly(pmd);
 			} else {
@@ -1331,7 +1330,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		goto out;
 
-	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
+	if (pmd_thp_or_huge(*pmd)) {	/* THP, HugeTLB */
 		*pmd = pmd_mkyoung(*pmd);
 		pfn = pmd_pfn(*pmd);
 		pfn_valid = true;
@@ -1555,7 +1554,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
-	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
+	if (pmd_thp_or_huge(*pmd)) {	/* THP, HugeTLB */
 		if (pmd_young(*pmd)) {
 			*pmd = pmd_mkold(*pmd);
 			return 1;
@@ -1585,7 +1584,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
-	if (kvm_pmd_huge(*pmd))		/* THP, HugeTLB */
+	if (pmd_thp_or_huge(*pmd))		/* THP, HugeTLB */
 		return pmd_young(*pmd);
 
 	pte = pte_offset_kernel(pmd, gpa);
-- 
1.7.9.5
