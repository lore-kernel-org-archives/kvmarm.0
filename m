Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0C0C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 08:37:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BAE99235F9
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 08:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAE99235F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA4F34B081;
	Fri, 22 Jan 2021 03:37:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MVeeN6uyThZs; Fri, 22 Jan 2021 03:37:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B144B0BA;
	Fri, 22 Jan 2021 03:37:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 506614B081
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 03:37:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eHdsrsfpZuH6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 03:37:17 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1D374AEF8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 03:37:15 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DMXdn4gT6zl8Rv;
 Fri, 22 Jan 2021 16:35:41 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 16:37:01 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Will Deacon
 <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device MMIO
Date: Fri, 22 Jan 2021 16:36:50 +0800
Message-ID: <20210122083650.21812-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Joerg Roedel <joro@8bytes.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
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

The MMIO region of a device maybe huge (GB level), try to use block
mapping in stage2 to speedup both map and unmap.

Especially for unmap, it performs TLBI right after each invalidation
of PTE. If all mapping is of PAGE_SIZE, it takes much time to handle
GB level range.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++++++++++
 arch/arm64/kvm/mmu.c                 | 12 ++++++++----
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52ab38db04c7..2266ac45f10c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -82,6 +82,17 @@ struct kvm_pgtable_walker {
 	const enum kvm_pgtable_walk_flags	flags;
 };
 
+/**
+ * kvm_supported_pgsize() - Get the max supported page size of a mapping.
+ * @pgt:	Initialised page-table structure.
+ * @addr:	Virtual address at which to place the mapping.
+ * @end:	End virtual address of the mapping.
+ * @phys:	Physical address of the memory to map.
+ *
+ * The smallest return value is PAGE_SIZE.
+ */
+u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys);
+
 /**
  * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..ab11609b9b13 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -81,6 +81,21 @@ static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
 	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
 }
 
+u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys)
+{
+	u32 lvl;
+	u64 pgsize = PAGE_SIZE;
+
+	for (lvl = pgt->start_level; lvl < KVM_PGTABLE_MAX_LEVELS; lvl++) {
+		if (kvm_block_mapping_supported(addr, end, phys, lvl)) {
+			pgsize = kvm_granule_size(lvl);
+			break;
+		}
+	}
+
+	return pgsize;
+}
+
 static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
 {
 	u64 shift = kvm_granule_shift(level);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..80b403fc8e64 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -499,7 +499,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
 {
-	phys_addr_t addr;
+	phys_addr_t addr, end;
+	unsigned long pgsize;
 	int ret = 0;
 	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
@@ -509,21 +510,24 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
+	end = guest_ipa + size;
 
-	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
+	for (addr = guest_ipa; addr < end; addr += pgsize) {
 		ret = kvm_mmu_topup_memory_cache(&cache,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			break;
 
+		pgsize = kvm_supported_pgsize(pgt, addr, end, pa);
+
 		spin_lock(&kvm->mmu_lock);
-		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
+		ret = kvm_pgtable_stage2_map(pgt, addr, pgsize, pa, prot,
 					     &cache);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
 
-		pa += PAGE_SIZE;
+		pa += pgsize;
 	}
 
 	kvm_mmu_free_memory_cache(&cache);
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
