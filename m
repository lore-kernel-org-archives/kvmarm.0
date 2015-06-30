From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] arm/arm64: KVM: fix two build failured under
 STRICT_MM_TYPECHECKS
Date: Tue, 30 Jun 2015 18:04:50 +0200
Message-ID: <1435680290-13945-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1435680290-13945-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EFA856B14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 11:53:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MGrgE9Bh48Y9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2015 11:53:48 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B34E56B0E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 11:53:48 -0400 (EDT)
Received: by widjy10 with SMTP id jy10so34670734wid.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 09:05:00 -0700 (PDT)
In-Reply-To: <1435680290-13945-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, catalin.marinas@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This fixes two instances where a pgprot_t is used as the operand
of a bitwise & operation. In order to comply with STRICT_MM_TYPECHECKS,
bitwise arithmetic on a pgprot_t should go via the pgprot_val()
accessor.

Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kvm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 1d5accbd3dcf..a255c7dd534b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -213,7 +213,8 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 			/* No need to invalidate the cache for device mappings */
-			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+			if ((pte_val(old_pte) & pgprot_val(PAGE_S2_DEVICE)) !=
+			    pgprot_val(PAGE_S2_DEVICE))
 				kvm_flush_dcache_pte(old_pte);
 
 			put_page(virt_to_page(pte));
@@ -306,7 +307,8 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 	pte = pte_offset_kernel(pmd, addr);
 	do {
 		if (!pte_none(*pte) &&
-		    (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+		    (pte_val(*pte) & pgprot_val(PAGE_S2_DEVICE)) !=
+		    pgprot_val(PAGE_S2_DEVICE))
 			kvm_flush_dcache_pte(*pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
-- 
1.9.1
