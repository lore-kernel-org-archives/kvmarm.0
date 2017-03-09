From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 06/10] arm64/mmu: align alloc_init_pte prototype with
 pmd/pud versions
Date: Thu,  9 Mar 2017 09:25:08 +0100
Message-ID: <1489047912-642-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B826140C4E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5xjziNeB-zA8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 03:24:08 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB2E840C35
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:07 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id v186so133214737wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 00:25:32 -0800 (PST)
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Align the function prototype of alloc_init_pte() with its pmd and pud
counterparts by replacing the pfn parameter with the equivalent physical
address.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 75e21c33caff..c3963c592ec3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -107,7 +107,7 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 }
 
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, unsigned long pfn,
+				  unsigned long end, phys_addr_t phys,
 				  pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void))
 {
@@ -128,8 +128,8 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	do {
 		pte_t old_pte = *pte;
 
-		set_pte(pte, pfn_pte(pfn, prot));
-		pfn++;
+		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
+		phys += PAGE_SIZE;
 
 		/*
 		 * After the PTE entry has been populated once, we
@@ -182,7 +182,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      pmd_val(*pmd)));
 		} else {
-			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
+			alloc_init_pte(pmd, addr, next, phys,
 				       prot, pgtable_alloc);
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
-- 
2.7.4
