Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F2E15C9
	for <kvmarm@lists.linux.dev>; Wed, 14 Aug 2024 12:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723638878; cv=none; b=F/tS+OVEw+bskdRPT6dTmnVZNdjoxl++lMmzcZiGq3DFzagVJn7U81HRU5qBMhaB1+ioAE13RbBTOILC1BuLx5WRVnXfg3wGO71/7H0IF8sqr9j9jJ3XcZFdH/ywa5QPaU8GwEb4bVYM2sAV0DhSRJZOOEmcWKVUC7wlFZkKAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723638878; c=relaxed/simple;
	bh=SI9hLU+Or0+BIYHu7IxOEE+FRI74wNTkfKN9m2X+qIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cNiogucvACQN5OdKWvjZZsgNXkwcSini9/GQlmtNc42jflkd3Oa9L+/0gzdV5/i5lXy3e1NUY7JnmpZiKE7iLXz1vvpfFP4VNuTmlQRjWylATBOLNNeMy71xma7qDCJd+aNDVUp6SplFVOafslDetHyJTUcUTCWVYS8G7sau4bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m41DBnEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m41DBnEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B104C4AF0F;
	Wed, 14 Aug 2024 12:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723638877;
	bh=SI9hLU+Or0+BIYHu7IxOEE+FRI74wNTkfKN9m2X+qIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m41DBnEkuZzQXiBPWqDVtAfQYIR+76WzHtf4ojE+XtbKqyK4rp9VAqFcTKg57oyhx
	 owEiP/4BZ6d01vCWfLKfs9+DW0s8498PWh6HMG7rhdGxIg1pFbv2wdCtpVquNcgkey
	 rxNce//66CabRrWCj8DclvoBYN2kLXK5pRuV3t1XQdrtgpLgMbW/an8rp3tonmVR2k
	 eDDl/yzt+rX1oQu2KYfpagfPCcxLNNv2HxG+jhFFPasB6S0VXS1Di44KaZlYOPspqo
	 Q0i1BxpV68mHPXz9I85Fte9OPg8T17n4CLjC7O/dQ2tj9eHQ1uP6W3L1Jo01qAOh/F
	 weudeHNopNTCg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 2/2] KVM: arm64: Ensure TLBI uses correct VMID after changing context
Date: Wed, 14 Aug 2024 13:34:29 +0100
Message-Id: <20240814123429.20457-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240814123429.20457-1-will@kernel.org>
References: <20240814123429.20457-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the target context passed to enter_vmid_context() matches the
current running context, the function returns early without manipulating
the registers of the stage-2 MMU. This can result in a stale VMID due to
the lack of an ISB instruction in exit_vmid_context() after writing the
VTTBR when ARM64_WORKAROUND_SPECULATIVE_AT is not enabled.

For example, with pKVM enabled:

	// Initially running in host context
	enter_vmid_context(guest);
		-> __load_stage2(guest); isb	// Writes VTCR & VTTBR
	exit_vmid_context(guest);
		-> __load_stage2(host);		// Restores VTCR & VTTBR

	enter_vmid_context(host);
		-> Returns early as we're already in host context
	tlbi vmalls12e1is	// !!! Can use the stale VMID as we
				// haven't performed context
				// synchronisation since restoring
				// VTTBR.VMID

Add an unconditional ISB instruction to exit_vmid_context() after
restoring the VTTBR. This already existed for the
ARM64_WORKAROUND_SPECULATIVE_AT path, so we can simply hoist that onto
the common path.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Fuad Tabba <tabba@google.com>
Fixes: 58f3b0fc3b87 ("KVM: arm64: Support TLB invalidation in guest context")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index ca3c09df8d7c..48da9ca9763f 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -132,10 +132,10 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
 	else
 		__load_host_stage2();
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/* Ensure write of the old VMID */
-		isb();
+	/* Ensure write of the old VMID */
+	isb();
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		if (!(cxt->sctlr & SCTLR_ELx_M)) {
 			write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
 			isb();
-- 
2.46.0.76.ge559c4bf1a-goog

