Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A32AC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 12:14:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9FA6C23A59
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 12:14:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FA6C23A59
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3627A4B208;
	Thu, 14 Jan 2021 07:14:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZZUc6baNXgWO; Thu, 14 Jan 2021 07:14:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB644B1DC;
	Thu, 14 Jan 2021 07:14:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D764B178
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 07:14:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NVr+l4Ud8MxH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 07:14:09 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F6434B1A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 07:14:08 -0500 (EST)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DGjrD5ckxz7VLg;
 Thu, 14 Jan 2021 20:13:00 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 14 Jan 2021 20:13:54 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] KVM: arm64: Filter out the case of only changing
 permissions from stage-2 map path
Date: Thu, 14 Jan 2021 20:13:49 +0800
Message-ID: <20210114121350.123684-3-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210114121350.123684-1-wangyanan55@huawei.com>
References: <20210114121350.123684-1-wangyanan55@huawei.com>
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

(1) During running time of a a VM with numbers of vCPUs, if some vCPUs
access the same GPA almost at the same time and the stage-2 mapping of
the GPA has not been built yet, as a result they will all cause
translation faults. The first vCPU builds the mapping, and the followed
ones end up updating the valid leaf PTE. Note that these vCPUs might
want different access permissions (RO, RW, RX, RWX, etc.).

(2) It's inevitable that we sometimes will update an existing valid leaf
PTE in the map path, and we perform break-before-make in this case.
Then more unnecessary translation faults could be caused if the
*break stage* of BBM is just catched by other vCPUS.

With (1) and (2), something unsatisfactory could happen: vCPU A causes
a translation fault and builds the mapping with RW permissions, vCPU B
then update the valid leaf PTE with break-before-make and permissions
are updated back to RO. Besides, *break stage* of BBM may trigger more
translation faults. Finally, some useless small loops could occur.

We can make some optimization to solve above problems: When we need to
update a valid leaf PTE in the map path, let's filter out the case where
this update only change access permissions, and don't update the valid
leaf PTE here in this case. Instead, let the vCPU enter back the guest
and it will exit next time to go through the relax_perms path without
break-before-make if it still wants more permissions.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 32 ++++++++++++++++++----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 52ab38db04c7..8886d43cfb11 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -157,6 +157,11 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * If device attributes are not explicitly requested in @prot, then the
  * mapping will be normal, cacheable.
  *
+ * Note that the update of a valid leaf PTE in this function will be aborted,
+ * if it's trying to recreate the exact same mapping or only change the access
+ * permissions. Instead, the vCPU will exit one more time from guest if still
+ * needed and then go through the path of relaxing permissions.
+ *
  * Note that this function will both coalesce existing table entries and split
  * existing block mappings, relying on page-faults to fault back areas outside
  * of the new mapping lazily.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a11ac874bc2a..4d177ce1d536 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -45,6 +45,10 @@
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
 
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -460,22 +464,27 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	return 0;
 }
 
-static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
-				       kvm_pte_t *ptep,
-				       struct stage2_map_data *data)
+static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
+				      kvm_pte_t *ptep,
+				      struct stage2_map_data *data)
 {
 	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 	struct page *page = virt_to_page(ptep);
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
-		return false;
+		return -E2BIG;
 
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
 	if (kvm_pte_valid(old)) {
-		/* Tolerate KVM recreating the exact same mapping */
-		if (old == new)
-			goto out;
+		/*
+		 * Skip updating the PTE if we are trying to recreate the exact
+		 * same mapping or only change the access permissions. Instead,
+		 * the vCPU will exit one more time from guest if still needed
+		 * and then go through the path of relaxing permissions.
+		 */
+		if (!((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS)))
+			return -EAGAIN;
 
 		/*
 		 * There's an existing different valid leaf entry, so perform
@@ -488,9 +497,8 @@ static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 
 	smp_store_release(ptep, new);
 	get_page(page);
-out:
 	data->phys += granule;
-	return true;
+	return 0;
 }
 
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
@@ -518,6 +526,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				struct stage2_map_data *data)
 {
+	int ret;
 	kvm_pte_t *childp, pte = *ptep;
 	struct page *page = virt_to_page(ptep);
 
@@ -528,8 +537,9 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 	}
 
-	if (stage2_map_walker_try_leaf(addr, end, level, ptep, data))
-		return 0;
+	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
+	if (ret != -E2BIG)
+		return ret;
 
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
