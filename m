Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8FCC28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E610F4A0FE;
	Wed, 26 Jan 2022 12:30:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UjmYf2tCxDKP; Wed, 26 Jan 2022 12:30:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB58B4A5A0;
	Wed, 26 Jan 2022 12:30:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41C354A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CTcVgIaQXMSZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:32 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F06D4A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C094161B29;
 Wed, 26 Jan 2022 17:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE1EC340ED;
 Wed, 26 Jan 2022 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218231;
 bh=NkDHn/GFNzvHawPVS9Op4WAl8MYqnxITPT90mOH4U9k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qP1am5qxgM0KkzyrIl6Q0mpR9YjjeqfvI5J0rwwQx0TyqI9pm+FolKFUmQQC4Lb2j
 6D3/AgEm7K9ZYjsNC54LVuPMc3AlZld8YT0Jk2T5r21VW9jONWm+xbnKvSBOm77nlg
 wH4RqgWTqzYiIETCdUHnMdnH6L9TLZLNaGaFicbQQQiIt/uCINcYITkMApXsIBkuLB
 aYp3FNu2h5QX3XJlx+AcdcLAWgetZ7voTk8+2k6VFSNMLT7vMML9ysXdCUDRFMPYJx
 IHkxukLBMOuUNYfpJvCo24OdcibMD1Dik30im1JLNlIb+GaYOYZVOtZn3Lh9yfc1PA
 0Vcq6K5mZpxBA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 04/12] arm64: mm: remap PGD pages r/o in the linear region
 after allocation
Date: Wed, 26 Jan 2022 18:30:03 +0100
Message-Id: <20220126173011.3476262-5-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2460; h=from:subject;
 bh=NkDHn/GFNzvHawPVS9Op4WAl8MYqnxITPT90mOH4U9k=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUTOXbAUibor0RdzEKRaxJDrNYFfRidvP8AjwRP
 cwb0lxuJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFEwAKCRDDTyI5ktmPJF8DC/
 9RAU2RHO/xy49vf4HfxCaKH83qITUHRcA6r89bUF/uVIsCSLeyZu+YTSVYzVbR0oXkOvhePQUSGjBY
 fvk161grsqB5b5VoZDT/OvYggUxZ59BPeuBNzXYJ5C/XcD12JX9iNQvtND/f9oZTsPX3c4ztmwMppH
 ak+KB8FI3rug+zIflF7vXnshCCkPPC+pVlaszPqQYupXLi/gt1JmKoSP7+BUfUTJKnPk/HBh1T0jRW
 MdqFeYWyU/bQz8befC9PuUO02UDcFECd7eAk2FFib0WKtMO6XbOY8HWbM32M66nAOtsOkYwBtSTWGx
 SSgTnGgokH7pQMkzM2loNpUvAwzHw5JsRLnXQxigbV8f1+aSHLZpBs21XN2mNSwwB8ZZ/zcFEhvJyA
 9HraR1/POsV2WVoUC6CREUfB7YYT5GZZZn2tpWVcHinY6iopviXhB3G1gpK1eWeWEEUta13iIQY52U
 U3xV+Wn3b6sZOOBTd4c0mMonkJYtbsMQV1MSFq7CnsEP0=
X-Developer-Key: i=ardb@kernel.org; a=openpgp;
 fpr=F43D03328115A198C90016883D200E9CA6329909
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-hardening@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

As the first step in restricting write access to all page tables via the
linear mapping, remap the page at the root PGD level of a user space
page table hierarchy read-only after allocation, so that it can only be
manipulated using the dedicated fixmap based API.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c |  7 ++++--
 arch/arm64/mm/pgd.c | 25 ++++++++++++++------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index acfae9b41cc8..a52c3162beae 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -394,8 +394,11 @@ static phys_addr_t __pgd_pgtable_alloc(int shift)
 	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL);
 	BUG_ON(!ptr);
 
-	/* Ensure the zeroed page is visible to the page table walker */
-	dsb(ishst);
+	if (page_tables_are_ro())
+		set_pgtable_ro(ptr);
+	else
+		/* Ensure the zeroed page is visible to the page table walker */
+		dsb(ishst);
 	return __pa(ptr);
 }
 
diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
index 4a64089e5771..637d6eceeada 100644
--- a/arch/arm64/mm/pgd.c
+++ b/arch/arm64/mm/pgd.c
@@ -9,8 +9,10 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/set_memory.h>
 #include <linux/slab.h>
 
+#include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
@@ -20,24 +22,33 @@ static struct kmem_cache *pgd_cache __ro_after_init;
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	gfp_t gfp = GFP_PGTABLE_USER;
+	pgd_t *pgd;
 
-	if (PGD_SIZE == PAGE_SIZE)
-		return (pgd_t *)__get_free_page(gfp);
-	else
+	if (PGD_SIZE < PAGE_SIZE && !page_tables_are_ro())
 		return kmem_cache_alloc(pgd_cache, gfp);
+
+	pgd = (pgd_t *)__get_free_page(gfp);
+	if (!pgd)
+		return NULL;
+	if (page_tables_are_ro())
+		set_pgtable_ro(pgd);
+	return pgd;
 }
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	if (PGD_SIZE == PAGE_SIZE)
-		free_page((unsigned long)pgd);
-	else
+	if (PGD_SIZE < PAGE_SIZE && !page_tables_are_ro()) {
 		kmem_cache_free(pgd_cache, pgd);
+	} else {
+		if (page_tables_are_ro())
+			set_pgtable_rw(pgd);
+		free_page((unsigned long)pgd);
+	}
 }
 
 void __init pgtable_cache_init(void)
 {
-	if (PGD_SIZE == PAGE_SIZE)
+	if (PGD_SIZE == PAGE_SIZE || page_tables_are_ro())
 		return;
 
 #ifdef CONFIG_ARM64_PA_BITS_52
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
