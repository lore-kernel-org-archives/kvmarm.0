Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DE119DF97;
	Thu, 15 Aug 2024 12:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726002; cv=none; b=uEbmgRumy2ZW6jruGr1qyWp4t4mlQEAOg+sYZJTy4VmLFotC5wvUprl1sK94kvvbfTx2FFCdxukDXK3SBf3kN94D52yBBihFZ+wb8GWCCRG9HA62qcxQ6x8XoiaTAKxCaulFa4OFwJHAQQ6fjrPo6rbi7B8CrvSrv6jSWonnT4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726002; c=relaxed/simple;
	bh=LtZ4l0UK8V84h8ROrSGlNDloENp1mMb5d0lKjelf0/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H3p1xj+kjxT6qM92LsU59uyMYhbR8cihGPgqPABwThDUspIx43llZO9VqBuQ83TSPu9F5hbByj8ArKEoSbY1SrgufTe9ezgkcl5xLVV9zh3OAD4NbiVseolu7DveyeyLib3SBg2iLLe7iojAeWCVmZv4ZBP3CBPAeTAst0GCY68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSJSIh2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSJSIh2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FD4C32786;
	Thu, 15 Aug 2024 12:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726002;
	bh=LtZ4l0UK8V84h8ROrSGlNDloENp1mMb5d0lKjelf0/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSJSIh2attj05RjyiuIfn6AbmoXGVIPcXIyOTDyQ4TAsr2wVyFuCY+/n4OuZNYIxi
	 fOQd1TIooU15H8kTZgJDJ5v/4AHqFuSHu64eu/GUdX9VViHmx8YDzFu/Zq6gIWzHgo
	 1/Uz7PVmXgKk84HJ6tXryFO3N6vvy5qv7vRFTqhNDkDgd1F28tZHi2whFwW0cOHbFR
	 SBZHEdmWMH+fWIw2rCwajwGM9ezsE5feuL+WAKxxYdnV81a3zX+wMMxbAb61Pg0fym
	 KbxHkXaNPwzoE5RUg/85s6Dq6xEaZFMZ8r0z307YwnWziF5ArGxSVh+PEbWtlbmyLk
	 /MTBMAPF2ViOQ==
From: Will Deacon <will@kernel.org>
To: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: [PATCH 6.6.y 1/2] KVM: arm64: Don't defer TLB invalidation when zapping table entries
Date: Thu, 15 Aug 2024 13:46:25 +0100
Message-Id: <20240815124626.21674-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240815124626.21674-1-will@kernel.org>
References: <20240815124626.21674-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit f62d4c3eb687d87b616b4279acec7862553bda77 upstream.

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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-2-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.y only
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 15aa9bad1c28..6692327fabe7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -861,9 +861,11 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
2.46.0.184.g6999bdac58-goog

