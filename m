From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 18/29] arm/arm64: KVM: Enforce Break-Before-Make on Stage-2
 page tables
Date: Wed, 11 May 2016 15:30:11 +0200
Message-ID: <1462973422-10021-19-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F2049BA5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sDORC6nCO-4q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:15 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AF4649B6D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:10 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id g17so82947882wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:08 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The ARM architecture mandates that when changing a page table entry
from a valid entry to another valid entry, an invalid entry is first
written, TLB invalidated, and only then the new entry being written.

The current code doesn't respect this, directly writing the new
entry and only then invalidating TLBs. Let's fix it up.

Cc: <stable@vger.kernel.org>
Reported-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/mmu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 42eefab..74b5d19 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -910,11 +910,14 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
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
 
@@ -963,12 +966,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 
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
2.1.2.330.g565301e.dirty
