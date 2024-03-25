Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D58410A3C
	for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711392729; cv=none; b=MXNNJSmaHly5goW5mFTIORInJzoAkHurYbBDYQwYpjV1X2VGm3n0Puvg9pNiS9ppoAgZo4JN+I0/aPsPqfYsHOd7xSf8y/w58fmf63txPboCGF9mlpZ4jjoa5OYnJ5eyQJmq1i22P7rVq19eOsy8kPSrtX1eYRdIQEfYh+YMcGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711392729; c=relaxed/simple;
	bh=pp/mGSQctVF+cnNA7rY+yLh0nt0v3ISjCZuBkz0b7/c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BOb959fBx+ICUgEUqMxU8CVM0qNlmRiwSAree4vW8LPPFE+2m1r+LgrSlrno3K98VOHeufxXsyFqN6vZkauTbc7eGQOlqAeL5yDewAGwXvg0OUB6UeezUfGE2QegJofwtbni1wgfumBe3/hAXkZPNoB87CCJevEJFgm05OVYtow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kfp1r3RN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kfp1r3RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C6BC43390;
	Mon, 25 Mar 2024 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711392729;
	bh=pp/mGSQctVF+cnNA7rY+yLh0nt0v3ISjCZuBkz0b7/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kfp1r3RNey85n3/rXGeFdsweLpXnsDwBT8P+kuoPDamv87azNwUfyPm8oT54Gu6ud
	 NRr3V11e2WCQERYxb9vJ4fie+wIN95H+Gid589cRG3qclGvejQ82l0Q86YczpakUJV
	 jCUfCsjL2gXTlbY0Qv2k5xfiwzvlBrJY72VQQuqrxeQ15Hbr/EiPfxGoY5D+ToLSej
	 A6DptsQSaDy51gxGhwbmjJeayilvAG8/UYTM3bE+4PJDn2A4BOucf6k0w4Z5JT+3Zg
	 QLPaSDjiAeQWDygI3e/yPrkw7PhER2nhKccFmYuYxu+lAFBQo1Gbzppa5XNU5UlfJJ
	 limZC/M0lwlOA==
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
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: Don't defer TLB invalidation when zapping table entries
Date: Mon, 25 Mar 2024 18:51:56 +0000
Message-Id: <20240325185158.8565-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240325185158.8565-1-will@kernel.org>
References: <20240325185158.8565-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 7657ea920c54 ("KVM: arm64: Use TLBI range-based instructions for
unmap") introduced deferred TLB invalidation for the stage-2 page-table
so that range-based invalidation can be used for the accumulated
addresses. This works fine if the structure of the page-tables remains
unchanged, but if entire tables are zapped and subsequently freed then
we transiently leave the hardware page-table walker with a reference
to freed memory thanks to the translation walk caches. For example,
stage2_unmap_walker() will free page-table pages:

	if (childp)
		mm_ops->put_page(childp);

and issue the TLB invalidation later in kvm_pgtable_stage2_unmap():

	if (stage2_unmap_defer_tlb_flush(pgt))
		/* Perform the deferred TLB invalidations */
		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);

For now, take the conservative approach and invalidate the TLB eagerly
when we clear a table entry.

Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3fae5830f8d2..de0b667ba296 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -896,9 +896,11 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt))
+		if (!stage2_unmap_defer_tlb_flush(pgt) ||
+		    kvm_pte_table(ctx->old, ctx->level)) {
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 					ctx->addr, ctx->level);
+		}
 	}
 
 	mm_ops->put_page(ctx->ptep);
-- 
2.44.0.396.g6e790dbe36-goog

