Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8B0C47E4B
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:32:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51810613F0
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51810613F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 041BD4B0B1;
	Thu, 15 Jul 2021 12:32:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xc0l-tJk62NR; Thu, 15 Jul 2021 12:32:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C024B0CB;
	Thu, 15 Jul 2021 12:32:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05B924B09E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:32:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UdHcB2At-zyU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 12:32:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11F1A4B089
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:32:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5323B613D3;
 Thu, 15 Jul 2021 16:32:17 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m44HX-00DYjr-OF; Thu, 15 Jul 2021 17:32:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
 kvm_pgtable_stage2_annotate
Date: Thu, 15 Jul 2021 17:31:46 +0100
Message-Id: <20210715163159.1480168-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

kvm_pgtable_stage2_set_owner() could be generalised into a way
to store up to 63 bits in the page tables, as long as we don't
set bit 0.

Let's just do that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 12 +++++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 14 ++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c          | 20 ++++++--------------
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f004c0115d89..9579e8c2793b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -274,14 +274,16 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   void *mc);
 
 /**
- * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
- *				    track ownership.
+ * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
+ *				   to track ownership (and more).
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Base intermediate physical address to annotate.
  * @size:	Size of the annotated range.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
- * @owner_id:	Unique identifier for the owner of the page.
+ * @annotation:	A 63 bit value that will be stored in the page tables.
+ *		@annotation[0] must be 0, and @annotation[63:1] is stored
+ *		in the page tables. @annotation as a whole must not be 0.
  *
  * By default, all page-tables are owned by identifier 0. This function can be
  * used to mark portions of the IPA space as owned by other entities. When a
@@ -290,8 +292,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id);
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, kvm_pte_t annotation);
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..ffe482c3b818 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -245,6 +245,15 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
+#define KVM_MAX_OWNER_ID		1
+
+static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
+{
+	BUG_ON(owner_id > KVM_MAX_OWNER_ID);
+	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
+}
+
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
 {
 	int ret;
@@ -257,8 +266,9 @@ int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
 		return -EINVAL;
 
 	hyp_spin_lock(&host_kvm.lock);
-	ret = kvm_pgtable_stage2_set_owner(&host_kvm.pgt, start, end - start,
-					   &host_s2_pool, pkvm_hyp_id);
+	ret = kvm_pgtable_stage2_annotate(&host_kvm.pgt, start, end - start,
+					  &host_s2_pool,
+					  kvm_init_invalid_leaf_owner(pkvm_hyp_id));
 	hyp_spin_unlock(&host_kvm.lock);
 
 	return ret != -EAGAIN ? ret : 0;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a5874ebd0354..a065f6d960af 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -50,9 +50,6 @@
 
 #define KVM_PTE_LEAF_ATTR_S2_IGNORED	GENMASK(58, 55)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
-#define KVM_MAX_OWNER_ID		1
-
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -206,11 +203,6 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 	return pte;
 }
 
-static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
-{
-	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
-}
-
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -466,7 +458,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 struct stage2_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
-	u8				owner_id;
+	u64				annotation;
 
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
@@ -603,7 +595,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (kvm_phys_is_valid(phys))
 		new = kvm_init_valid_leaf_pte(phys, data->attr, level);
 	else
-		new = kvm_init_invalid_leaf_owner(data->owner_id);
+		new = data->annotation;
 
 	if (stage2_pte_is_counted(old)) {
 		/*
@@ -796,8 +788,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id)
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, kvm_pte_t annotation)
 {
 	int ret;
 	struct stage2_map_data map_data = {
@@ -805,7 +797,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
-		.owner_id	= owner_id,
+		.annotation	= annotation,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -815,7 +807,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	if (owner_id > KVM_MAX_OWNER_ID)
+	if (!annotation || (annotation & PTE_VALID))
 		return -EINVAL;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
