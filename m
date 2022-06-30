Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFD8C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74FA44B431;
	Thu, 30 Jun 2022 09:58:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gi+2x2UY5iZL; Thu, 30 Jun 2022 09:58:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 962DB4B274;
	Thu, 30 Jun 2022 09:58:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B4A40712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yx4uFJ6djo3g for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:17 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D9084B4AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:17 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EDF1F620E4;
 Thu, 30 Jun 2022 13:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1899CC341CB;
 Thu, 30 Jun 2022 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597496;
 bh=czGrMKVmcAgfqMuBOqGAxm/Bl1F3qGCKOPa4Z2x4jgM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BEhtAorXncZaZBdv8J+ZmsKppz0vF4m6YFziJGxh6rfOC+rHG2q0EjK7RF30UFvBj
 B3yzmL/mGT9+qpGunIsAJneAFDY3rMhPZQJXPfu4fGvmT0bgtylmuWGmeQOEjt6zmc
 Vx+QyIRwVbCHGCWHuBsnhUDIsA2LtdQX8Lm31m0jKOg7riKYQf8MsnbeEd/oQRfrTh
 QMnlmfimZB3N0Nx3POZyfvCqqD1FOBj6vEdUUCMB4PkjQtTeKSp9WRNzTGXV/GEy7x
 d/0TRxrpONVxPToUcJtzINi0CzeJA5EpL3fpseck+WvsnadRyUishnhnw2zf1o28un
 zP0GXkhB6bwLg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 05/24] KVM: arm64: Make hyp stage-1 refcnt correct on the
 whole range
Date: Thu, 30 Jun 2022 14:57:28 +0100
Message-Id: <20220630135747.26983-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

We currently fixup the hypervisor stage-1 refcount only for specific
portions of the hyp stage-1 VA space. In order to allow unmapping pages
outside of these ranges, let's fixup the refcount for the entire hyp VA
space.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 62 +++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 579eb4f73476..8f2726d7e201 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -185,12 +185,11 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
-static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
-					 kvm_pte_t *ptep,
-					 enum kvm_pgtable_walk_flags flag,
-					 void * const arg)
+static int fix_host_ownership_walker(u64 addr, u64 end, u32 level,
+				     kvm_pte_t *ptep,
+				     enum kvm_pgtable_walk_flags flag,
+				     void * const arg)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
 	kvm_pte_t pte = *ptep;
@@ -199,15 +198,6 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	/*
-	 * Fix-up the refcount for the page-table pages as the early allocator
-	 * was unable to access the hyp_vmemmap and so the buddy allocator has
-	 * initialised the refcount to '1'.
-	 */
-	mm_ops->get_page(ptep);
-	if (flag != KVM_PGTABLE_WALK_LEAF)
-		return 0;
-
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -236,12 +226,30 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	return host_stage2_idmap_locked(phys, PAGE_SIZE, prot);
 }
 
-static int finalize_host_mappings(void)
+static int fix_hyp_pgtable_refcnt_walker(u64 addr, u64 end, u32 level,
+					 kvm_pte_t *ptep,
+					 enum kvm_pgtable_walk_flags flag,
+					 void * const arg)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	kvm_pte_t pte = *ptep;
+
+	/*
+	 * Fix-up the refcount for the page-table pages as the early allocator
+	 * was unable to access the hyp_vmemmap and so the buddy allocator has
+	 * initialised the refcount to '1'.
+	 */
+	if (kvm_pte_valid(pte))
+		mm_ops->get_page(ptep);
+
+	return 0;
+}
+
+static int fix_host_ownership(void)
 {
 	struct kvm_pgtable_walker walker = {
-		.cb	= finalize_host_mappings_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
-		.arg	= pkvm_pgtable.mm_ops,
+		.cb	= fix_host_ownership_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 	int i, ret;
 
@@ -257,6 +265,18 @@ static int finalize_host_mappings(void)
 	return 0;
 }
 
+static int fix_hyp_pgtable_refcnt(void)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= fix_hyp_pgtable_refcnt_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pkvm_pgtable.mm_ops,
+	};
+
+	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits),
+				&walker);
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
@@ -286,7 +306,11 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-	ret = finalize_host_mappings();
+	ret = fix_host_ownership();
+	if (ret)
+		goto out;
+
+	ret = fix_hyp_pgtable_refcnt();
 	if (ret)
 		goto out;
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
