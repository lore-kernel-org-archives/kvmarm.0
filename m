Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEA0C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 10:14:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF9F7235F9
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 10:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF9F7235F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6E24B0B7;
	Fri, 22 Jan 2021 05:14:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PeMVGLD2cN+m; Fri, 22 Jan 2021 05:14:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6AE24B199;
	Fri, 22 Jan 2021 05:14:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C14FB4B196
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 05:14:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2e4gK7NLezyQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 05:14:14 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 220434B18B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 05:14:13 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DMZp50VG5z15x19;
 Fri, 22 Jan 2021 18:13:01 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 18:14:03 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 1/2] KVM: arm64: Adjust partial code of hyp stage-1 map
 and guest stage-2 map
Date: Fri, 22 Jan 2021 18:13:57 +0800
Message-ID: <20210122101358.379956-2-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210122101358.379956-1-wangyanan55@huawei.com>
References: <20210122101358.379956-1-wangyanan55@huawei.com>
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

Procedures of hyp stage-1 map and guest stage-2 map are quite different,
but they are tied closely by function kvm_set_valid_leaf_pte().
So adjust the relative code for ease of code maintenance in the future.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 54 ++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..2878aaf53b3c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -170,10 +170,9 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
 	smp_store_release(ptep, pte);
 }
 
-static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
-				   u32 level)
+static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(pa);
+	kvm_pte_t pte = kvm_phys_to_pte(pa);
 	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
 							   KVM_PTE_TYPE_BLOCK;
 
@@ -181,12 +180,7 @@ static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
 	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
 	pte |= KVM_PTE_VALID;
 
-	/* Tolerate KVM recreating the exact same mapping. */
-	if (kvm_pte_valid(old))
-		return old == pte;
-
-	smp_store_release(ptep, pte);
-	return true;
+	return pte;
 }
 
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
@@ -341,12 +335,17 @@ static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
+	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	WARN_ON(!kvm_set_valid_leaf_pte(ptep, phys, data->attr, level));
+	/* Tolerate KVM recreating the exact same mapping */
+	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	if (old != new && !WARN_ON(kvm_pte_valid(old)))
+		smp_store_release(ptep, new);
+
 	data->phys += granule;
 	return true;
 }
@@ -465,27 +464,29 @@ static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				       kvm_pte_t *ptep,
 				       struct stage2_map_data *data)
 {
+	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	/*
-	 * If the PTE was already valid, drop the refcount on the table
-	 * early, as it will be bumped-up again in stage2_map_walk_leaf().
-	 * This ensures that the refcount stays constant across a valid to
-	 * valid PTE update.
-	 */
-	if (kvm_pte_valid(*ptep))
-		put_page(virt_to_page(ptep));
+	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	if (kvm_pte_valid(old)) {
+		/* Tolerate KVM recreating the exact same mapping */
+		if (old == new)
+			goto out;
 
-	if (kvm_set_valid_leaf_pte(ptep, phys, data->attr, level))
-		goto out;
+		/*
+		 * There's an existing different valid leaf entry, so perform
+		 * break-before-make.
+		 */
+		kvm_set_invalid_pte(ptep);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+		put_page(virt_to_page(ptep));
+	}
 
-	/* There's an existing valid leaf entry, so perform break-before-make */
-	kvm_set_invalid_pte(ptep);
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
-	kvm_set_valid_leaf_pte(ptep, phys, data->attr, level);
+	smp_store_release(ptep, new);
+	get_page(virt_to_page(ptep));
 out:
 	data->phys += granule;
 	return true;
@@ -527,7 +528,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (stage2_map_walker_try_leaf(addr, end, level, ptep, data))
-		goto out_get_page;
+		return 0;
 
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
@@ -551,9 +552,8 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	kvm_set_table_pte(ptep, childp);
-
-out_get_page:
 	get_page(page);
+
 	return 0;
 }
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
