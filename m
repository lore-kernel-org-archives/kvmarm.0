Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF0DC388F9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:19:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B17D20780
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B17D20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98BC94B3B8;
	Tue, 27 Oct 2020 13:19:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vR6p4+z8wM-T; Tue, 27 Oct 2020 13:19:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48E8B4B3BC;
	Tue, 27 Oct 2020 13:19:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 297F94B203
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:19:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0va0wkaKEmcG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:19:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 861A24B4E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:19:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FEF1150C;
 Tue, 27 Oct 2020 10:19:04 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5953B3F719;
 Tue, 27 Oct 2020 10:19:00 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 4/5] lib: arm/arm64: Add function to
 unmap a page
Date: Tue, 27 Oct 2020 17:19:43 +0000
Message-Id: <20201027171944.13933-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: pbonzini@redhat.com
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

Being able to cause a stage 1 data abort might be useful for future tests.
Add a function that unmaps a page from the translation tables.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 2bbe1faea900..305f77c6501f 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -23,4 +23,5 @@ extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
 extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
+extern void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 540a1e842d5b..72ac0be8d146 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -232,3 +232,35 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 out_flush_tlb:
 	flush_tlb_page(vaddr);
 }
+
+void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (!mmu_enabled())
+		return;
+
+	pgd = pgd_offset(pgtable, vaddr);
+	if (!pgd_valid(*pgd))
+		return;
+
+	pmd = pmd_offset(pgd, vaddr);
+	if (!pmd_valid(*pmd))
+		return;
+
+	if (pmd_huge(*pmd)) {
+		WRITE_ONCE(*pmd, 0);
+		goto out_flush_tlb;
+	} else {
+		pte = pte_offset(pmd, vaddr);
+		if (!pte_valid(*pte))
+			return;
+		WRITE_ONCE(*pte, 0);
+		goto out_flush_tlb;
+	}
+
+out_flush_tlb:
+	flush_tlb_page(vaddr);
+}
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
