Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82A9C0502A
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 19:51:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 708AC4B883;
	Tue, 30 Aug 2022 15:51:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8GhaW4MYJbZM; Tue, 30 Aug 2022 15:51:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 547BE4B8B7;
	Tue, 30 Aug 2022 15:51:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 190BD4B883
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:51:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Ue50SSb0eYq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 15:51:44 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E78D74B87D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:51:43 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661889102;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BmHJR6N3rI3NqVKRQnsaZiBFli5RmIY4C8X+Uix5thU=;
 b=eBaq5OcegB50cLDgGEiduR4Tgk5pLMtHfEruHLpo036HKXFf0YTXH2bWlsFFUmU/6mHlgb
 4V4yxrZtBF7lSii3YCwzkHciBjKh7H1kMwVqh8gok5JQ6GRUH7NmjinsnU6ud9D2trTwEX
 A/qAC0OBx34lJZlbrfIE1UPaqv+pv/k=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 12/14] KVM: arm64: Make leaf->leaf PTE changes parallel-aware
Date: Tue, 30 Aug 2022 19:51:32 +0000
Message-Id: <20220830195132.964800-1-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Convert stage2_map_walker_try_leaf() to use the new break-before-make
helpers, thereby making the handler parallel-aware. As before, avoid the
break-before-make if recreating the existing mapping. Additionally,
retry execution if another vCPU thread is modifying the same PTE.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 71ae96608752..de1d352657d0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -829,18 +829,17 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	else
 		new = kvm_init_invalid_leaf_owner(data->owner_id);
 
-	if (stage2_pte_is_counted(old)) {
-		/*
-		 * Skip updating the PTE if we are trying to recreate the exact
-		 * same mapping or only change the access permissions. Instead,
-		 * the vCPU will exit one more time from guest if still needed
-		 * and then go through the path of relaxing permissions.
-		 */
-		if (!stage2_pte_needs_update(old, new))
-			return -EAGAIN;
+	/*
+	 * Skip updating the PTE if we are trying to recreate the exact
+	 * same mapping or only change the access permissions. Instead,
+	 * the vCPU will exit one more time from guest if still needed
+	 * and then go through the path of relaxing permissions.
+	 */
+	if (!stage2_pte_needs_update(old, new))
+		return -EAGAIN;
 
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
-	}
+	if (!stage2_try_break_pte(ptep, old, addr, level, data))
+		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
 	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
@@ -850,9 +849,8 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	smp_store_release(ptep, new);
-	if (stage2_pte_is_counted(new))
-		mm_ops->get_page(ptep);
+	stage2_make_pte(ptep, old, new, data);
+
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
