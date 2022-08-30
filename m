Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4822FECAAD5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 19:42:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24CF4B9A8;
	Tue, 30 Aug 2022 15:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LQmFW3u3IGRL; Tue, 30 Aug 2022 15:42:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 601FE4B8BA;
	Tue, 30 Aug 2022 15:42:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2D84B8B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eynSbbDKxmFZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 15:42:11 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0511D40A93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:11 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661888530;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OM9zxSJJuTKTuFSKGRv27d7vX1yV4xi18G4afH0SBng=;
 b=xVd55y2ntnEMM6i/pBXAEUbvLk9n9/Xp1W3X2aFoztrKb5WjPyoibjUuU7AjudHvyb58FU
 UxrnI3KP0KNlEWOrDD7iaQKuIadCBJKsIhFQNCbOUcc0BbDaPb7agTa3yUrWAsW4hR3Dzw
 XaNwFLeQglXkmROtM7gbsywFkgDY0LY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>, Ricardo Koller <ricarkol@google.com>,
 Reiji Watanabe <reijiw@google.com>, David Matlack <dmatlack@google.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/14] KVM: arm64: Split init and set for table PTE
Date: Tue, 30 Aug 2022 19:41:23 +0000
Message-Id: <20220830194132.962932-6-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

Create a helper to initialize a stage-2 table and directly call
smp_store_release() to install it.

A subsequent change to KVM will tweak the way we traverse the page
tables, requiring that the visitor callbacks steer the walker down a
newly installed table. Furthermore, when stage-2 faults are serviced
in parallel the PTE must be considered volatile, so walkers will need
to stash a pointer to the new table.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 430753fbb727..331f6e3b2c20 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -142,16 +142,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, 0);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
-			      struct kvm_pgtable_mm_ops *mm_ops)
+static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
+	kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
-
-	WARN_ON(kvm_pte_valid(old));
-	smp_store_release(ptep, pte);
+	return pte;
 }
 
 static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
@@ -413,7 +410,7 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *pte
 static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			  enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	struct hyp_map_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
@@ -427,8 +424,10 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte
 	if (!childp)
 		return -ENOMEM;
 
-	kvm_set_table_pte(ptep, childp, mm_ops);
+	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ptep);
+	smp_store_release(ptep, new);
+
 	return 0;
 }
 
@@ -804,7 +803,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				kvm_pte_t *old, struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp, pte = *old;
+	kvm_pte_t *childp, pte = *old, new;
 	int ret;
 
 	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, pte, data);
@@ -830,8 +829,9 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (stage2_pte_is_counted(pte))
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 
-	kvm_set_table_pte(ptep, childp, mm_ops);
+	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ptep);
+	smp_store_release(ptep, new);
 
 	return 0;
 }
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
