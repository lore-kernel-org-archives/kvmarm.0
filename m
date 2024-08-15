Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAD719AD87;
	Thu, 15 Aug 2024 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726007; cv=none; b=oDNYaIXaKQsJ7SOk2v1Z4gnplEYht647mC0E+hspHVk9Xhce73jy/VWJppwHQuD2MX3eVrLcL0MnroY6lfn2jYYD65MVv1G1VhRCIN19cNb1L/vJ5g/aVcmfkxK7mYl0EzOGDpF4GUJFAkKaVklWll6+vAfM6r1TSq6bk6Os0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726007; c=relaxed/simple;
	bh=H0G+7V2K0ZCba0FYUEeo8jlLw/eTXjCszmz3eMNcWBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oc6vLXi3DhAEnYRD08Wlpo+3s6ps79A+6a65dlg3pjzdS5b1E4b5n3rxSv8jEDaP6M4NGY0dL3A1/PvGDjI8lgf814EZ7HJyRwoENqTW9ehvDOnoybB32cnck8/xbLCXO58D8c1Y9ku1WdIui1LmQm8MYdPbjHhOmnE+vZutHMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOrhJJnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOrhJJnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC89C4AF0D;
	Thu, 15 Aug 2024 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726007;
	bh=H0G+7V2K0ZCba0FYUEeo8jlLw/eTXjCszmz3eMNcWBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOrhJJnpY0hwdp1FyrdwYshqdIjunKamQkJfktFb16m94Uw39qE2iwkKi470vSHNF
	 o4VvUkgkO4CB1VC97q+HZw9Y/MMsUKwjsxJ6XavSj36/Z7nMGZ4xWkqONGk6URd2CO
	 jP+gyxMbm2OW5bfXWNOi88zWqr3Z66CDLv7VAq/yhXb/7FVBv0o0cTKl6CukB03/Tx
	 W/vBG4hxsdNz1QgdY1+FlFcToSAoT/yqz7VN2zwMCHtMc5mROIBeUwH3TQd65XowgE
	 GvjlpqMwcrnJEWCDuMUm8iedlXSrhd02PkCaVXXJzN+2qiTQITvY/6qBQ1sWrV3XEm
	 nO9Aubbf06aPw==
From: Will Deacon <will@kernel.org>
To: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: [PATCH 6.6.y 2/2] KVM: arm64: Don't pass a TLBI level hint when zapping table entries
Date: Thu, 15 Aug 2024 13:46:26 +0100
Message-Id: <20240815124626.21674-3-will@kernel.org>
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

commit 36e008323926036650299cfbb2dca704c7aba849 upstream.

The TLBI level hints are for leaf entries only, so take care not to pass
them incorrectly after clearing a table entry.

Cc: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-3-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.y only
[will@: Use '0' instead of TLBI_TTL_UNKNOWN to indicate "no level"]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 6692327fabe7..ca0bf0b92ca0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -523,7 +523,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
+		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), 0);
 	} else {
 		if (ctx->end - ctx->addr < granule)
 			return -EINVAL;
@@ -861,10 +861,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt) ||
-		    kvm_pte_table(ctx->old, ctx->level)) {
-			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
-					ctx->addr, ctx->level);
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     0);
+		} else if (!stage2_unmap_defer_tlb_flush(pgt)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     ctx->level);
 		}
 	}
 
-- 
2.46.0.184.g6999bdac58-goog

