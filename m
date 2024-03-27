Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5637E1EB39
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 12:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543742; cv=none; b=HmzgSyGLZMKHNx19Bw7D7blDNG3Q9eyYl0LfKIerTTU3N26OKJN2UIqmYwrVESY6MyOCUjNYFfvzc1GDub6bdWEyNggie+pFhEFuNvIEt2Yp9FAA3kkxwEFhdL6YQGKod+sDLaFxRUucxsB1wfx0rqJJ0/iW5FKFnbcJFkSHP2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543742; c=relaxed/simple;
	bh=gzOFJmJsseLiXdBw91aKhD2nQfl7xlgBvKD45uJaxL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gHVnuK/ZOvr0EVS9a1LRHsOC7sEarCYNEdB7ygXFzsm//bte+94wOkTJEtrSUM+DmRD+2JFvJpXAM+HpRM3iCwIG5OKZN+BEX2YYILXUcEPSzArWSMTKx6fH/H/TfTqya1y+SkUGiNy9PfaEbBkwghUeEgk+PWIkWMRPm+lDn30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzhvURJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzhvURJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F41FC43399;
	Wed, 27 Mar 2024 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711543741;
	bh=gzOFJmJsseLiXdBw91aKhD2nQfl7xlgBvKD45uJaxL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzhvURJn5vap1L6jRO7DUBAGBkuFGggxrSmz3yjm9A90s6oZOUsPM9lOnMZKa4t+k
	 7tzdI1dFq1jzmoYZEH5sau+s7YT+dns/jZYnWV8SShpl38VfdUVxF/jbMXei7cZwUz
	 D7SKC8QKMCsd98isWoyT3hnBtJ8mQSCOl1Uh56Exz8Ufls2pI1JtJ4o8PiDBRwbeZV
	 +vvRWBaTaqIdCHbsMPXDvTVQBxfsm1zmPDgCDo7rB4cJtolYl9v5puT1/DvDcmr9X6
	 /X7hm3pyFPyyu2/Tufj9QbhH+pJLUkhFEk3i949UmO/LlpZaLy6Rr0Q0glwMgfd1yx
	 VLGyVlbGjGUUw==
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
Subject: [PATCH v2 1/4] KVM: arm64: Don't defer TLB invalidation when zapping table entries
Date: Wed, 27 Mar 2024 12:48:50 +0000
Message-Id: <20240327124853.11206-2-will@kernel.org>
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
when we clear a table entry. Note, however, that the existing level
hint passed to __kvm_tlb_flush_vmid_ipa() is incorrect and will be
fixed in a subsequent patch.

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

