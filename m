Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F956C28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A4834B099;
	Wed, 26 Jan 2022 12:30:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KQskhUZgjAo1; Wed, 26 Jan 2022 12:30:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3384C4B08E;
	Wed, 26 Jan 2022 12:30:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5F54AC78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7NUHXvJW4tsr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:44 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 077364B093
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:44 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3C220B81F83;
 Wed, 26 Jan 2022 17:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52CBC340E8;
 Wed, 26 Jan 2022 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218242;
 bh=+9r0eENwjcrZsaucV5LRPlnIuFJW40RDRpKxbSWSeHc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YDAxXbhb+/WC0bnK3qTYyh/LKHBiNtzGkIqBDPoTOJ0ufKXcvKi85P9jlQst0A/8F
 GnVyDTEDpYd4oLcMorvP4R30Q9d2p9xRgMX0u/v3/W19mTQdL8A28cA9Uu+jWf2Hi9
 d8M/ZGODlcA3tduJTxNxbJi+BDT19B0VzeCdg0TG/7wYjvFTUkTsNU/bukMl0UScb1
 i3KNr/YA76IfeyzV7sy2vRDvxiLaVycICOn2MlBiY3pLrqlMZi+/cRJex0Z8idrEWu
 NZFKN8qoBveecwEzG8DZZBtopF9I2dG1U4x+P8iRi72WWBNprH/URrrbAF2cb3lByz
 fJ5nRUjv1TcWg==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 08/12] arm64: mm: remap kernel PTE level page tables r/o
 in the linear region
Date: Wed, 26 Jan 2022 18:30:07 +0100
Message-Id: <20220126173011.3476262-9-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2238; h=from:subject;
 bh=+9r0eENwjcrZsaucV5LRPlnIuFJW40RDRpKxbSWSeHc=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUbo/Cm7PIshn0dC5CWatC79oZscN7k5hjn8Rcu
 PMtRDlqJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFGwAKCRDDTyI5ktmPJLviC/
 40E17Ru+4lAVhwvY6HNacedYwjyRWoJxpb4D5K29WQfXWq1YOL6ROBHq5DtB1gjmqJeqZQJQWrfajk
 4/SW9RDioe8YaLmAWUZZgdOJ6bxrEvsWakArwRaS3Haur+/Qc6i30Chgz0z6scvYoOdIhTfoQFAwWR
 qvipSKoQIlUsmC7UpAO9mIxxBzn2XJiN6Jd0hdEdXYudnNCqfJ9cPkM5KS92PT9KFAi1W8nlcc+8Ao
 jIN3GwRntYbppkKelvTql7ZcLV1qD2h0h2c0HkP82ZFxzaf9DyRXnwY1/mbNzx/b5uiBqJ4WCgQLxW
 gP09b6f4Q41N0Wk3JFBEH8NejSOM0NtIA43WfnW9QNmaM5npB/P934NzvWT83XVWtghq+UZ/dMHaGb
 aH8n6QQt2u1wKJ3rgGBx7yVsFXFvywvj7bA3LOzUyw/PdL8DIjKIn58nMw6mvbe58gut2mMno8HZrU
 owY+QCKUIrTorWodg/NvzuTD6Oye4caAvKPezXnjkZAQY=
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

Now that all kernel page table manipulations are routed through the
fixmap API if r/o page tables are enabled, we can remove write access
from the linear mapping of those pages.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/pgalloc.h |  6 +++++
 arch/arm64/mm/mmu.c              | 24 +++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 18a5bb0c9ee4..073482634e74 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -20,6 +20,9 @@
 #define __HAVE_ARCH_PMD_FREE
 #define __HAVE_ARCH_PTE_ALLOC_ONE
 #define __HAVE_ARCH_PTE_FREE
+#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
+#define __HAVE_ARCH_PTE_FREE_KERNEL
+
 #include <asm-generic/pgalloc.h>
 
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
@@ -27,6 +30,9 @@
 pgtable_t pte_alloc_one(struct mm_struct *mm);
 void pte_free(struct mm_struct *mm, struct page *pte_page);
 
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
+void pte_free_kernel(struct mm_struct *mm, pte_t *pte);
+
 #if CONFIG_PGTABLE_LEVELS > 2
 
 pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 949846654797..971501535757 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1402,7 +1402,7 @@ int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 	table = pte_offset_kernel(pmdp, addr);
 	pmd_clear(pmdp);
 	__flush_tlb_kernel_pgtable(addr);
-	pte_free_kernel(NULL, table);
+	pte_free_kernel(&init_mm, table);
 	return 1;
 }
 
@@ -1709,3 +1709,25 @@ void pte_free(struct mm_struct *mm, struct page *pte_page)
 	pgtable_pte_page_dtor(pte_page);
 	__free_page(pte_page);
 }
+
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
+{
+	pte_t *pte = __pte_alloc_one_kernel(mm);
+
+	VM_BUG_ON(mm != &init_mm);
+
+	if (!pte)
+		return NULL;
+	if (page_tables_are_ro())
+		set_pgtable_ro(pte);
+	return pte;
+}
+
+void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	VM_BUG_ON(mm != &init_mm);
+
+	if (page_tables_are_ro())
+		set_pgtable_rw(pte);
+	free_page((u64)pte);
+}
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
