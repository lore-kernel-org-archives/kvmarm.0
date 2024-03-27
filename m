Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ADE1E521
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 12:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543750; cv=none; b=cXWuMyQTB54Rq83vOx30jwNFFH5it98w/2+Njw3kb2fbg8iCLNarQhdzgCC+b0tjJNAcvvAujjlLl2lSc2uSTBl3ChUj/ZAtvg3NqRxu66eiCennRIlLyBm9CM17filP/xIO/cSMtBO64vzSANcnElWaLLThwaiNsuKEzq1rZjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543750; c=relaxed/simple;
	bh=objC47luTJxKbsIzJPJvLhwVeuYX+ge06C/74jvV0DM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TCSJKsRglhgK7MeFOEn+sG3hLEITdHNGGxsbS6TDQrE3ecWe4ZS9b5vn5t/SwrrKpUpADwEH/np4CbgEpzE945P9vlPfkVA/HnRtwA+cFE6utbQ8A7aM91b3MHI8Tts5Kt6QDp0dUaSzmfqtAUUJwuos38CNRFIY9rGuDJa+WPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhGBex4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhGBex4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E6DC433C7;
	Wed, 27 Mar 2024 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711543750;
	bh=objC47luTJxKbsIzJPJvLhwVeuYX+ge06C/74jvV0DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhGBex4AXUVbMACcE7T10JlD9cggBVLBRuupnanYXtoijba0MW5kUykotADa9ADk+
	 +/xqNVuiybdW7rh9txbbaIU0Ma3TWOQ68BnU00hmNGh0nQlcVA6I8AYChZxkhzyeWK
	 dhUGah+FJS1PK/92Z7KfJxLkOEmwT3rbfpJdidVqJXj+xNviZAvjkWKJTkRn4mAbyu
	 31qaQowZ5WXU3zyfwlZ8yIsqCG3x4IXtzrgjKcfoLEpk99+ZCIiK421t2R1gNJJlbF
	 MV7PBuNQjLe+pLI12s/jDI2UK2+4i0zorJPux7YCl5OkL4yR6YHHlG9hHXEBgep9AX
	 CKGVrc9nwrkVA==
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
Subject: [PATCH v2 4/4] KVM: arm64: Ensure target address is granule-aligned for range TLBI
Date: Wed, 27 Mar 2024 12:48:53 +0000
Message-Id: <20240327124853.11206-5-will@kernel.org>
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

When zapping a table entry in stage2_try_break_pte(), we issue range
TLB invalidation for the region that was mapped by the table. However,
we neglect to align the base address down to the granule size and so
if we ended up reaching the table entry via a misaligned address then
we will accidentally skip invalidation for some prefix of the affected
address range.

Align 'ctx->addr' down to the granule size when performing TLB
invalidation for an unmapped table in stage2_try_break_pte().

Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Quentin Perret <qperret@google.com>
Fixes: defc8cc7abf0 ("KVM: arm64: Invalidate the table entries upon a range")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a40dafc43bb6..5a59ef88b646 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -843,12 +843,15 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		 * Perform the appropriate TLB invalidation based on the
 		 * evicted pte value (if any).
 		 */
-		if (kvm_pte_table(ctx->old, ctx->level))
-			kvm_tlb_flush_vmid_range(mmu, ctx->addr,
-						kvm_granule_size(ctx->level));
-		else if (kvm_pte_valid(ctx->old))
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			u64 size = kvm_granule_size(ctx->level);
+			u64 addr = ALIGN_DOWN(ctx->addr, size);
+
+			kvm_tlb_flush_vmid_range(mmu, addr, size);
+		} else if (kvm_pte_valid(ctx->old)) {
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 				     ctx->addr, ctx->level);
+		}
 	}
 
 	if (stage2_pte_is_counted(ctx->old))
-- 
2.44.0.396.g6e790dbe36-goog

