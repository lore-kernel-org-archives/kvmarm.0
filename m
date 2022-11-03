Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4904BC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 09:12:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D17D74B76D;
	Thu,  3 Nov 2022 05:12:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8JWMHX0QmQfK; Thu,  3 Nov 2022 05:12:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CD64B74E;
	Thu,  3 Nov 2022 05:12:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3AE4B651
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 05:12:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jo4hHWngVebp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 05:12:11 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B82964B6C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 05:12:11 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667466731;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QTWHUvGXXLBaVP9WYsfv0JsA+QFYWloxD6w3Irr67xY=;
 b=qk0UaXWKcvR61VmaSQPKKbwqvg2avzRET2daAVXqBtQ7APbZPM3eyb89eiokiUkL0twTIM
 U6D1Vd9xDqvjAQb5lRZ+xsXg8d+2ZnlMysaXB63H2Io+EWQRFIb7uT2PEPd5uOxEMjY2SU
 MTfiX0ir1w9yjebGG3zQwP2EwUl7EXg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 04/14] KVM: arm64: Don't pass kvm_pgtable through
 kvm_pgtable_walk_data
Date: Thu,  3 Nov 2022 09:11:30 +0000
Message-Id: <20221103091140.1040433-5-oliver.upton@linux.dev>
In-Reply-To: <20221103091140.1040433-1-oliver.upton@linux.dev>
References: <20221103091140.1040433-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

In order to tear down page tables from outside the context of
kvm_pgtable (such as an RCU callback), stop passing a pointer through
kvm_pgtable_walk_data.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index db25e81a9890..93989b750a26 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -50,7 +50,6 @@
 #define KVM_MAX_OWNER_ID		1
 
 struct kvm_pgtable_walk_data {
-	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
 
 	u64				addr;
@@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
 	return (data->addr >> shift) & mask;
 }
 
-static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
+static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
 {
 	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
 	u64 mask = BIT(pgt->ia_bits) - 1;
@@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
 	return (addr & mask) >> shift;
 }
 
-static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
-{
-	return __kvm_pgd_page_idx(data->pgt, data->addr);
-}
-
 static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 {
 	struct kvm_pgtable pgt = {
@@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 		.start_level	= start_level,
 	};
 
-	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
+	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
 static bool kvm_pte_table(kvm_pte_t pte, u32 level)
@@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 	return ret;
 }
 
-static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
+static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
 {
 	u32 idx;
 	int ret = 0;
-	struct kvm_pgtable *pgt = data->pgt;
 	u64 limit = BIT(pgt->ia_bits);
 
 	if (data->addr > limit || data->end > limit)
@@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
 	if (!pgt->pgd)
 		return -EINVAL;
 
-	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
+	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
 		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
 
 		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
@@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker)
 {
 	struct kvm_pgtable_walk_data walk_data = {
-		.pgt	= pgt,
 		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
 
-	return _kvm_pgtable_walk(&walk_data);
+	return _kvm_pgtable_walk(pgt, &walk_data);
 }
 
 struct leaf_walk_data {
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
