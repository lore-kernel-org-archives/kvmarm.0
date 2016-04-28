From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm/arm64: KVM: Enforce Break-Before-Make on Stage-2 page
 tables
Date: Thu, 28 Apr 2016 16:16:31 +0100
Message-ID: <1461856591-5751-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9FC410B5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 11:14:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0WTSnmqyHUiF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 11:14:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A39774053F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 11:14:17 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM architecture mandates that when changing a page table entry
from a valid entry to another valid entry, an invalid entry is first
written, TLB invalidated, and only then the new entry being written.

The current code doesn't respect this, directly writing the new
entry and only then invalidating TLBs. Let's fix it up.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 58dbd5c..edf1cd1 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -893,11 +893,14 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	VM_BUG_ON(pmd_present(*pmd) && pmd_pfn(*pmd) != pmd_pfn(*new_pmd));
 
 	old_pmd = *pmd;
-	kvm_set_pmd(pmd, *new_pmd);
-	if (pmd_present(old_pmd))
+	if (pmd_present(old_pmd)) {
+		pmd_clear(pmd);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
-	else
+	} else {
 		get_page(virt_to_page(pmd));
+	}
+
+	kvm_set_pmd(pmd, *new_pmd);
 	return 0;
 }
 
@@ -946,12 +949,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 
 	/* Create 2nd stage page table mapping - Level 3 */
 	old_pte = *pte;
-	kvm_set_pte(pte, *new_pte);
-	if (pte_present(old_pte))
+	if (pte_present(old_pte)) {
+		kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
-	else
+	} else {
 		get_page(virt_to_page(pte));
+	}
 
+	kvm_set_pte(pte, *new_pte);
 	return 0;
 }
 
-- 
2.1.4
