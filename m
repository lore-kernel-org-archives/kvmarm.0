Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09E0C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B5BD4B45F;
	Thu, 19 May 2022 09:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g3pSwKSNci2q; Thu, 19 May 2022 09:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9024B3AD;
	Thu, 19 May 2022 09:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96FE64B465
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fy7kdyvzgaoE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:56 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AAD74B4BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BDE81B824B1;
 Thu, 19 May 2022 13:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ECFC34117;
 Thu, 19 May 2022 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968074;
 bh=Bb16fB1SmGSKYWwrpfSZcfkvibh8rQKnfPLdNL//f+Y=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bOg5OFUjv2277j/meQP3O4SaTl6wfeWQ86gbdZeGsaiOHccCxWEfmELroBkaS0d/I
 +QKCf7moqK4aBN832WtFmuPKh/qvDFmY/+rgSNCfw8aZ14/zC9tmR49iWg450LFf3/
 z6GCDdavpRvE+CKcSQUaQVvEK/wz2/SCGU801vf2bylAjEJoAu0Pq46x2bHvW3KjpZ
 DA86pBK+RVb2wcG5XWS5V2qvuIcONAV6YwqWmNHaVywTjV8KWF830WnofrKs8mzHiM
 4w0lD7YfWAqGD3MnSCvx5zmPJeoD4S//atYCW42tMe97HhbzZGvPjCBcD6hg6dJ8Kw
 JOA3De/F/wF+w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 83/89] KVM: arm64: Avoid BBM when changing only s/w bits in
 Stage-2 PTE
Date: Thu, 19 May 2022 14:41:58 +0100
Message-Id: <20220519134204.5379-84-will@kernel.org>
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

Break-before-make (BBM) can be expensive, as transitioning via an
invalid mapping (i.e. the "break" step) requires the completion of TLB
invalidation and can also cause other agents to fault concurrently on
the invalid mapping.

Since BBM is not required when changing only the software bits of a PTE,
avoid the sequence in this case and just update the PTE directly.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2069e6833831..756bbb15c1f3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -744,6 +744,13 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		if (!stage2_pte_needs_update(old, new))
 			return -EAGAIN;
 
+		/*
+		 * If we're only changing software bits, then we don't need to
+		 * do anything else/
+		 */
+		if (!((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
+			goto out_set_pte;
+
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 	}
 
@@ -754,9 +761,11 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ptep);
+
+out_set_pte:
+	smp_store_release(ptep, new);
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
