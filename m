Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8648C28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 859D74A100;
	Wed, 26 Jan 2022 12:30:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m8u9yiwhbtqn; Wed, 26 Jan 2022 12:30:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD214A531;
	Wed, 26 Jan 2022 12:30:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9E5749F09
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H9w9DdYsCE1u for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:26 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0AFF4A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:26 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5B0D661B29;
 Wed, 26 Jan 2022 17:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A1AC340E8;
 Wed, 26 Jan 2022 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218225;
 bh=lOZNDQBKEdhHEAm0EEJe90CRSD2PZxxRVPzRAgeBg+g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=FTEQY/gvBQR4fr6BJJVpEB8tMzPWpBQtKb4mJieQld7XUpKevRmjfWdpyL4JlI/tx
 ApsUi0ztFBxF4ro5UBBwUIAnRss/13D+y6fyoUs0gKFl0gpqn1NuiJ1bdioYd/od/e
 WrJ7IRlaXIVUV76sn7FBqD3A2+KDz1tXTxB6skirn7h78tPaRipCGDb0VMg6TIwlmD
 zYtDRcbp1LhFFGRYSWAn8V/P5Yt/Cz3jUXiePcPbNoufZo33LZ6M6SgE/f7FsmfYPf
 4r3BfJYVyTd4pc/y1lM5iBqkuZPmSxqNpSodsuuKTwC24BKSPZBwu0fsXGJhqZl5tJ
 hPSxT5Eb5u0bg==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 02/12] arm64: mm: add helpers to remap page tables
 read-only/read-write
Date: Wed, 26 Jan 2022 18:30:01 +0100
Message-Id: <20220126173011.3476262-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1657; h=from:subject;
 bh=lOZNDQBKEdhHEAm0EEJe90CRSD2PZxxRVPzRAgeBg+g=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUPNZPuIBlYQ+hSRXUzLJbcL5a+cXOtRIAZKvC1
 ifBWh+mJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFDwAKCRDDTyI5ktmPJCe+DA
 CSWOra5ZYs6My7IvQBErUHdCz3EWGT1gOpzkaysGHJySx71LtDunmLFb1SCjxW6VaX0uU8A3PmfRFW
 dBk1cOwfRvJU/O95yC7aGxLxmiTPDP1LFlut+hHxiIjbhMiBQ/6QhfSq01iso8XQiZZQEL4dEnB8TL
 Gdr+CI7vbg6070ZKDhLHTBQzDMhPCd3NxtBSvWHQkEc5jhZ3B2YvC+mgAWOzUKPUHZqdbff+vQzbsm
 WrN3WhPbCsmYU3fTSrgUPPq1trL2ntlYDCquLp+1jfhzq/FmKNlQ8DI3wASm5QHiwmeG/6PfGJe06y
 6oKj9uyngpSE4tgFuxt4pWKSPq3MBNGrPQml5D0z4M214r61m73e2nUHHqFnFS6F5PImQpq6aTqHIh
 76MI51/EPW0s7bNsm2DlDwxbf7Xbc46fGBVz/awvgT+0aIxITh88AB1Bm6beTaFCjgErEuV3HEyWxW
 bVZveYVQ3Qw0o3N7ksmnj/ZGDU6hOzSellUrszqpJnL0s=
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

Add a couple of helpers to remap a single page read-only or read-write
via its linear address. This will be used for mappings of page table
pages in the linear region.

Note that set_memory_ro/set_memory_rw operate on addresses in the
vmalloc space only, so they cannot be used here.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  3 +++
 arch/arm64/mm/pageattr.c         | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c4ba047a82d2..8d3806c68687 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -34,6 +34,9 @@
 #include <linux/mm_types.h>
 #include <linux/sched.h>
 
+int set_pgtable_ro(void *addr);
+int set_pgtable_rw(void *addr);
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index a3bacd79507a..61f4aca08b95 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -153,6 +153,20 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_VALID));
 }
 
+int set_pgtable_ro(void *addr)
+{
+	return __change_memory_common((u64)addr, PAGE_SIZE,
+				      __pgprot(PTE_RDONLY),
+				      __pgprot(PTE_WRITE));
+}
+
+int set_pgtable_rw(void *addr)
+{
+	return __change_memory_common((u64)addr, PAGE_SIZE,
+				      __pgprot(PTE_WRITE),
+				      __pgprot(PTE_RDONLY));
+}
+
 int set_direct_map_invalid_noflush(struct page *page)
 {
 	struct page_change_data data = {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
