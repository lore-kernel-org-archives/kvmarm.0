Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5CAC4332B
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2111923121
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 12:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2111923121
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E69C4B297;
	Tue, 26 Jan 2021 07:45:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IrnTwZPoxccO; Tue, 26 Jan 2021 07:45:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF424B28D;
	Tue, 26 Jan 2021 07:45:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FF84B21B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UtE35VniXyci for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 07:45:15 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41AD74B219
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 07:45:15 -0500 (EST)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR1m3szjDds;
 Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:03 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH 3/7] kvm: arm64: Add level_apply parameter for
 stage2_attr_walker
Date: Tue, 26 Jan 2021 20:44:40 +0800
Message-ID: <20210126124444.27136-4-zhukeqian1@huawei.com>
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

In order to change PTEs of some specific levels, the level_apply
parameter can be used as a level mask.

This has no fuctional change for current code.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4915ba35f93b..0f8a319f16fe 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -734,6 +734,7 @@ struct stage2_attr_data {
 	kvm_pte_t	attr_clr;
 	kvm_pte_t	pte;
 	u32		level;
+	u32		level_apply;
 };
 
 static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
@@ -743,6 +744,9 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	kvm_pte_t pte = *ptep;
 	struct stage2_attr_data *data = arg;
 
+	if (!(data->level_apply & BIT(level)))
+		return 0;
+
 	if (!kvm_pte_valid(pte))
 		return 0;
 
@@ -753,14 +757,15 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
-				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
-				    u32 *level)
+				    kvm_pte_t attr_clr, u32 level_apply,
+				    kvm_pte_t *orig_pte, u32 *level)
 {
 	int ret;
 	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
 	struct stage2_attr_data data = {
 		.attr_set	= attr_set & attr_mask,
 		.attr_clr	= attr_clr & attr_mask,
+		.level_apply	= level_apply,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_attr_walker,
@@ -783,7 +788,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
-					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, -1,
 					NULL, NULL);
 }
 
@@ -791,7 +796,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				 &pte, NULL);
+				 -1, &pte, NULL);
 	dsb(ishst);
 	return pte;
 }
@@ -800,7 +805,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
 	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
-				 &pte, NULL);
+				 -1, &pte, NULL);
 	/*
 	 * "But where's the TLBI?!", you scream.
 	 * "Over in the core code", I sigh.
@@ -813,7 +818,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
 bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
 {
 	kvm_pte_t pte = 0;
-	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
+	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, -1, &pte, NULL);
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
 }
 
@@ -833,7 +838,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, -1, NULL, &level);
 	if (!ret)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
 	return ret;
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
