Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060E8C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B047B4B3FD;
	Thu, 19 May 2022 09:44:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XMI+GsDkryjM; Thu, 19 May 2022 09:44:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30CCF4B3D6;
	Thu, 19 May 2022 09:44:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C8464B3D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id REVfpq3zlOYY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:21 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E2FD4B3D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:21 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E1E2B61783;
 Thu, 19 May 2022 13:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FBC34117;
 Thu, 19 May 2022 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967860;
 bh=9Zu+1PM964G8VB/qecrYRRnyKHnt3EWZgmbLdhsUNTc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=CV0ZGuRQXsTvx7y4SinA0e6Ox7OFe71U5wvIU+soixC4yNptm76juK7kEUF1h9SxX
 oYpeant1QNqop7yI6rv39FS2nZqWWzDrARyBU65hR9ArrGfPkeSIh8NpwE97ooMo+a
 z0IIs2FNE7b2inyibH/xINq5w+o/hiaC6wnOd/Kp/lgVcGC4kGvxLkZfHnH4VyTNwb
 eXLX4TlMeo9wsJtqFHIjr4uZ4AXEiEqU5Xaf2t4BAKkKw4bXDEZFw8t23CAmRmbMIY
 FLRtGPgTpZhgPyd9e7j2mfy8bbyTtEkUZybVZlZt8c2lRCTp4qPkRmx5SwTueyrIV2
 l8vZJZC129frg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 29/89] KVM: arm64: Check for PTE validity when checking for
 executable/cacheable
Date: Thu, 19 May 2022 14:41:04 +0100
Message-Id: <20220519134204.5379-30-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

Don't blindly assume that the PTE is valid when checking whether
it describes an executable or cacheable mapping.

This makes sure that we don't issue CMOs for invalid mappings.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1d300313009d..a6676fd14cf9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -700,12 +700,12 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
 	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
+	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
 }
 
 static bool stage2_pte_executable(kvm_pte_t pte)
 {
-	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
 static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
@@ -750,8 +750,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	/* Perform CMOs before installation of the guest stage-2 PTE */
 	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
-
+					       granule);
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
@@ -1148,7 +1147,7 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
+	if (!stage2_pte_cacheable(pgt, pte))
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
