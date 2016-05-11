From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 05/29] kvm-arm: Replace kvm_pmd_huge with pmd_thp_or_huge
Date: Wed, 11 May 2016 15:29:58 +0200
Message-ID: <1462973422-10021-6-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Both arm and arm64 now provides a helper, pmd_thp_or_huge()
to check if the given pmd represents a huge page. Use that
instead of our own custom check.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 17 ++++++++---------
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
2.1.2.330.g565301e.dirty

