Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B991EB39
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 12:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543745; cv=none; b=Fn9rT7d2aRWfkYnpuv0b9WTEk0zm8aTCbytivn7eNcAV/kZfmMChbDGnN0Hg6W8KAABLr9Aa6KZPTR3NOKWKzE5B/ndULL9CBEIQdGk6LQD6/ZI5zPzrNjvS4nUfjrnEbb8e9lrmIqJ6Dxa5JWflsrQX3WYB+NWq1Kd/KR7XRUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543745; c=relaxed/simple;
	bh=bXN/HevD7CPAdyg/mpq/H+7HLHjel9WBtmGPHdrhUQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=agR+9W8BxO45B44Tnl+HKN3q6dHCT4YQWG3jiF+Oua/TiMsP1Wz88TMSN7zQe0luKAtMzfUxUvQh5vG6WSSG+PdCqCpNYVZlA/8agwBDA1+2a1pivDysl8VOX2WwXl0aKNty+Qh1xmK/4pM0ExiUa2GiPhmUAF5xQykqqb0QIa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLO7/kcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLO7/kcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680F5C433F1;
	Wed, 27 Mar 2024 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711543744;
	bh=bXN/HevD7CPAdyg/mpq/H+7HLHjel9WBtmGPHdrhUQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLO7/kcqYjCcdII7Jo9ynbKhRdeNj36WLWFGPCWwUpP+sibe4I6YThh/jHQltBHT0
	 GnTaMZJq6eeRUS8Bd9Kp1JjRCtNqLNUTxUaz1DHDd+tp3inpurlhbSTrTuK8CHdVGB
	 sP9URBFsDQdpArFFjH3Pgq0dS99hz6FLnBsSbiwTbqUB89YCdprP0olff/jwyzA0Tr
	 AB8xnL1QUBcMRRnRbAcFcvGf6sXzfWPkdMd/Q4zB2Wouy+TF9zxcM1N411wpGqDzsi
	 IpW6U4B6t0rys61rI6iqfzS5JaSP5WYkU6FWZzGK5/gPCQwIZAPMdphFw0Bjh2NOEc
	 tW6w/1ev5Q0sQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: [PATCH v2 2/4] KVM: arm64: Don't pass a TLBI level hint when zapping table entries
Date: Wed, 27 Mar 2024 12:48:51 +0000
Message-Id: <20240327124853.11206-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240327124853.11206-1-will@kernel.org>
References: <20240327124853.11206-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TLBI level hints are for leaf entries only, so take care not to pass
them incorrectly after clearing a table entry.

Cc: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index de0b667ba296..a40dafc43bb6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -528,7 +528,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
+		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), TLBI_TTL_UNKNOWN);
 	} else {
 		if (ctx->end - ctx->addr < granule)
 			return -EINVAL;
@@ -896,10 +896,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt) ||
-		    kvm_pte_table(ctx->old, ctx->level)) {
-			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
-					ctx->addr, ctx->level);
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     TLBI_TTL_UNKNOWN);
+		} else if (!stage2_unmap_defer_tlb_flush(pgt)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     ctx->level);
 		}
 	}
 
-- 
2.44.0.396.g6e790dbe36-goog

