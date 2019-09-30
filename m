Return-Path: <SRS0=6KZ/=XZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AECC388F4
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 14:25:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46B44218DE
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 14:25:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46B44218DE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F17484A656;
	Mon, 30 Sep 2019 10:25:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RL6dtRbcPD3U; Mon, 30 Sep 2019 10:25:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 901F54A7EC;
	Mon, 30 Sep 2019 10:25:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E92E4A70A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 10:25:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GTnsdpu4Dd+C for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Sep 2019 10:25:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487844A703
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 10:25:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E610F1597;
 Mon, 30 Sep 2019 07:25:17 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DFED53F706;
 Mon, 30 Sep 2019 07:25:16 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear the
 PTE_USER bit
Date: Mon, 30 Sep 2019 15:25:07 +0100
Message-Id: <20190930142508.25102-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190930142508.25102-1-alexandru.elisei@arm.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: pbonzini@redhat.com, andre.przywara@arm.com, maz@kernel.org
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

The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
(EL0, on arm64, or PL0, on arm) can read and write from that memory
location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
when is set [3]. Add a function to clear the bit which we can use when we
want to execute code from that page or the prevent access from lower
exception levels.

Make it available to arm too, in case someone needs it at some point.

[1] ARM DDI 0406C.d, Table B3-6
[2] ARM DDI 0487E.a, table D5-28
[3] ARM DDI 0487E.a, table D5-33

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index df3ccf7bc7e0..8fe85ba31ec9 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
+extern void mmu_clear_user(unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 3d38c8397f5a..78db22e6af14 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
 	return addr;
 }
+
+void mmu_clear_user(unsigned long vaddr)
+{
+	pgd_t *pgtable;
+	pteval_t *pte;
+
+	if (!mmu_enabled())
+		return;
+
+	pgtable = current_thread_info()->pgtable;
+	pte = get_pte(pgtable, vaddr);
+
+	*pte &= ~PTE_USER;
+	flush_tlb_page(vaddr);
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
