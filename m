Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09021C433E6
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 13:42:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8ECE3229C9
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 13:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ECE3229C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1460B4B198;
	Tue, 26 Jan 2021 08:42:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RLbdWUbfYMLO; Tue, 26 Jan 2021 08:42:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B52B44B2A9;
	Tue, 26 Jan 2021 08:42:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DCE4B166
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 08:42:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zMWCdovhvaRx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 08:42:20 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD7D64B147
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 08:42:19 -0500 (EST)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DK2k0Kz7bPZ;
 Tue, 26 Jan 2021 21:41:05 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:09 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH v1 4/5] KVM: arm64: Add handling of coalescing tables into
 a block mapping
Date: Tue, 26 Jan 2021 21:42:01 +0800
Message-ID: <20210126134202.381996-5-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
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

If migration of a VM with hugepages is canceled midway, KVM will adjust
the stage-2 table mappings back to block mappings. We currently use BBM
to replace the table entry with a block entry. Take adjustment of 1G block
mapping as an example, with BBM procedures, we have to invalidate the old
table entry of level 1 first, flush TLB and unmap the old table mappings,
right before installing the new block entry.

So there will be a bit long period when the table entry of level 1 is
invalid before installation of block entry, if other vCPUs access any
guest page within the 1G range during this period and find the table
entry invalid, they will all exit from guest with an translation fault.
Actually, these translation faults are not necessary, because the block
mapping will be built later. Besides, KVM will try to build 1G block
mappings for these translation faults, and will perform cache maintenance
operations, page table walk, etc.

Approaches of TTRem level 1,2 ensure that there will be not a moment when
the old table entry is invalid before installation of the new block entry,
so no unnecessary translation faults will be caused. But level-2 method
will possibly lead to a TLB conflict which is bothering, so we use nT both
at level-1 and level-2 case to avoid handling TLB conflict aborts.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c8b959e3951b..ab1c94985ed0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,6 +49,8 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_PTE_LEAF_BLOCK_S2_NT	BIT(16)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -502,6 +504,39 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	return 0;
 }
 
+static int stage2_coalesce_tables_into_block(u64 addr, u32 level,
+					     kvm_pte_t *ptep,
+					     struct stage2_map_data *data)
+{
+	u32 ttrem_level = data->ttrem_level;
+	u64 granule = kvm_granule_size(level), phys = data->phys;
+	kvm_pte_t new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+
+	switch (ttrem_level) {
+	case TTREM_LEVEL0:
+		kvm_set_invalid_pte(ptep);
+
+		/*
+		 * Invalidate the whole stage-2, as we may have numerous leaf
+		 * entries below us which would otherwise need invalidating
+		 * individually.
+		 */
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+		smp_store_release(ptep, new);
+		data->phys += granule;
+		return 0;
+	case TTREM_LEVEL1:
+	case TTREM_LEVEL2:
+		WRITE_ONCE(*ptep, new | KVM_PTE_LEAF_BLOCK_S2_NT);
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+		WRITE_ONCE(*ptep, new & ~KVM_PTE_LEAF_BLOCK_S2_NT);
+		data->phys += granule;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     kvm_pte_t *ptep,
 				     struct stage2_map_data *data)
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
