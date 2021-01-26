Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C44C432C3
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5E1A2313E
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5E1A2313E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C23AE4B28B;
	Tue, 26 Jan 2021 07:45:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFyX2jwVdNmN; Tue, 26 Jan 2021 07:45:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 758304B284;
	Tue, 26 Jan 2021 07:45:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E543D4B219
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D5dmXGOXutXK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 07:45:19 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BE674B27A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:18 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yX1ljRzjDdp;
 Tue, 26 Jan 2021 20:44:04 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:05 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH 5/7] kvm: arm64: Add some HW_DBM related mmu interfaces
Date: Tue, 26 Jan 2021 20:44:42 +0800
Message-ID: <20210126124444.27136-6-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: yubihong@huawei.com, Cornelia Huck <cohuck@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, zhengchuan@huawei.com,
 Alex Williamson <alex.williamson@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>
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

This adds set_dbm, clear_dbm and sync_dirty interfaces in mmu layer.
They simply wrap those interfaces of pgtable layer, adding reschedule
semantics.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  7 +++++++
 arch/arm64/kvm/mmu.c             | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e52d82aeadca..51dd31ba1b94 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -183,6 +183,13 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void free_hyp_pgds(void);
 
+void kvm_stage2_clear_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long npages);
+void kvm_stage2_set_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long npages);
+void kvm_stage2_sync_dirty(struct kvm *kvm, struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long npages);
+
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..18717fd12731 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -609,6 +609,36 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
+void kvm_stage2_clear_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_clear_dbm);
+}
+
+void kvm_stage2_set_dbm(struct kvm *kvm, struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_set_dbm);
+}
+
+void kvm_stage2_sync_dirty(struct kvm *kvm, struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long npages)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t addr = base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + npages) << PAGE_SHIFT;
+
+	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_sync_dirty);
+}
+
 static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
 	__clean_dcache_guest_page(pfn, size);
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
