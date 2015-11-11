From: Laura Abbott <labbott@fedoraproject.org>
Subject: [PATCH 2/2] arm: kvm: Fix STRICT_MM_TYPECHECK errors
Date: Tue, 10 Nov 2015 18:03:21 -0800
Message-ID: <1447207401-12023-2-git-send-email-labbott@fedoraproject.org>
References: <1447207401-12023-1-git-send-email-labbott@fedoraproject.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447207401-12023-1-git-send-email-labbott@fedoraproject.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


PAGE_S2_DEVICE is a pgprot val and needs to be accessed using the proper
accessors. Switch to these accessors to avoid errors with
STRICT_MM_TYPECHECK.

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
Found in the course of other work
---
 arch/arm/kvm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 6984342..43f8162 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -213,7 +213,8 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 			/* No need to invalidate the cache for device mappings */
-			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+			if ((pte_val(old_pte) & pgprot_val(PAGE_S2_DEVICE)) !=
+			     pgprot_val(PAGE_S2_DEVICE))
 				kvm_flush_dcache_pte(old_pte);
 
 			put_page(virt_to_page(pte));
@@ -306,7 +307,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 	pte = pte_offset_kernel(pmd, addr);
 	do {
 		if (!pte_none(*pte) &&
-		    (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+		    (pte_val(*pte) & pgprot_val(PAGE_S2_DEVICE)) !=
+		     pgprot_val(PAGE_S2_DEVICE))
 			kvm_flush_dcache_pte(*pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
-- 
2.5.0
