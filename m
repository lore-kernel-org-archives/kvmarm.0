Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AEEC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3783149F07;
	Wed, 26 Jan 2022 12:30:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LB3X++OBoVUn; Wed, 26 Jan 2022 12:30:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2913F4A417;
	Wed, 26 Jan 2022 12:30:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C9C4A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Om+GHkOBteXG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:24 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DC9B4A014
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:24 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A78CE6170A;
 Wed, 26 Jan 2022 17:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B6FC340EB;
 Wed, 26 Jan 2022 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218223;
 bh=RnezKA+OcKDAG9Mh1/3XxqGMxaOSHLyLtTYhFTpeQ0k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KwPpOhdfTY2EK9+tglIKSGBNkLVLyKwT0XxXsjopC/TBEtV4f2dv13gDn75hgc8GG
 V32it6CyEF20TJsq4Y6JsL14GvQDP7rw6FJmfogNylrQGaoimTRBoR3sLk3LnCY4UG
 55fmEw4RTIwuewdpibR+btC4ry6oDCbco6tvEmUca0CvYGReClX1ckh5fLk9uziteI
 Am65V1pkupa9B1N2C8r1l8QdSMhNqIIn/0Cau5NocYV2i1VUAQmw/06I/8SzLLgQLE
 1pAu1UIyc55EmoqPA6dL3jigbyBgTw982Qb70M3+5ds/KYXFR9WjIm/c9VX0L/+1rv
 QS1fMphVjknKw==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 01/12] asm-generic/pgalloc: allow arch to override PMD
 alloc/free routines
Date: Wed, 26 Jan 2022 18:30:00 +0100
Message-Id: <20220126173011.3476262-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2359; h=from:subject;
 bh=RnezKA+OcKDAG9Mh1/3XxqGMxaOSHLyLtTYhFTpeQ0k=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUNbLtlyRCaE6N4Ud6VCGzNOAAfiUcToxl3P/XX
 P6BgSkiJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFDQAKCRDDTyI5ktmPJLX4C/
 94sVPXESuLBfe40cP35qsqUFWRHo6zU1AmLldoRO1uJcQyttHvitcfpNxvEeg3H9dXJebYbvwbzvZP
 E5wA5NxeiZ550fq/Pm5oeMVCHimTNeW7okOqKoNOr+3lG6OwHG80TKjg8E2tbVFNkxRCloUHVBBYUl
 3T3bHqe6Wl7lLCoY0phVanY9hnV33g/gjeHhCKjLYrGfCx48KxhmcHe3kEM+f4oGg6idvSdBBzFtbj
 qp89/FCbJsvVqkdirMWYI5xpEIMLFBdfNfNU2VLfL9jPjCESDU/yODefwCcXg8ra1r/ExCJ3D/elkt
 fAlfG8oTTtXsUsjsB/XXICLmiAj/M0LlgGtdPD9jyvcORsQ3xFtWxgoVl4kjtgoFYWblaXmtsTwKUz
 PIFagxF9j4EkoNQhWJBGXZX9j3+8XYLY7YrJww1YZQzt8n9Lo6yIAPt+gGYdoFTGMD5aUYs3w1/3Eo
 eQUilERJpgO2RDOlIeJuD61GFr/hdLX3gwNY9hlf1igCw=
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

Extend the existing CPP macro based hooks that allow architectures to
specialize the code that allocates and frees pages to be used as page
tables.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/asm-generic/pgalloc.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 977bea16cf1b..65f31f615d99 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -34,6 +34,7 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 }
 #endif
 
+#ifndef __HAVE_ARCH_PTE_FREE_KERNEL
 /**
  * pte_free_kernel - free PTE-level kernel page table page
  * @mm: the mm_struct of the current context
@@ -43,6 +44,7 @@ static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
 	free_page((unsigned long)pte);
 }
+#endif
 
 /**
  * __pte_alloc_one - allocate a page for PTE-level user page table
@@ -91,6 +93,7 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
  * done with a reference count in struct page.
  */
 
+#ifndef __HAVE_ARCH_PTE_FREE
 /**
  * pte_free - free PTE-level user page table page
  * @mm: the mm_struct of the current context
@@ -101,11 +104,11 @@ static inline void pte_free(struct mm_struct *mm, struct page *pte_page)
 	pgtable_pte_page_dtor(pte_page);
 	__free_page(pte_page);
 }
+#endif
 
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
-#ifndef __HAVE_ARCH_PMD_ALLOC_ONE
 /**
  * pmd_alloc_one - allocate a page for PMD-level page table
  * @mm: the mm_struct of the current context
@@ -116,7 +119,7 @@ static inline void pte_free(struct mm_struct *mm, struct page *pte_page)
  *
  * Return: pointer to the allocated memory or %NULL on error
  */
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+static inline pmd_t *__pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *page;
 	gfp_t gfp = GFP_PGTABLE_USER;
@@ -132,6 +135,12 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 	}
 	return (pmd_t *)page_address(page);
 }
+
+#ifndef __HAVE_ARCH_PMD_ALLOC_ONE
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return __pmd_alloc_one(mm, addr);
+}
 #endif
 
 #ifndef __HAVE_ARCH_PMD_FREE
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
