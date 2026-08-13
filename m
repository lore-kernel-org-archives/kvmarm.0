Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3668476072
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627044; cv=none; b=kQDHPQsX+0hq/vM0E+JcmfkzUEI0h77TGTCWFyQOMtLQzYGNtid0/71+baS97SHwtB9+9HhWPuZh6b/UOR3CbxGihTa4knE6eDKFzG9eka77lE8l4xl0Gey8rrYu1Xb9Pbb4kTXDQJUjZ+1eT12LjoK1O9qIFlZmY/bmo5ih63U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627044; c=relaxed/simple;
	bh=4Ws2q1HNnCm3fZw+FMf45YUYwkc9+NewFqORB+DWv1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sFVsORH8TjafCo5xhUyn0zNz+Ltaw+ctHCFw2RW+UwDGz44MQZE+IIdoTeGQCicRA4dn0I6/Eti7XldXyc8crmjKs7h4f3NojrCYOmA93cQea6NRabnb67c6JYHuN0EtqZ8uG5++nBht9xSdSNzACeh1iuyeCgYO6CiaK1kUwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsN9Oena; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsN9Oena"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F601F00A3D;
	Thu, 13 Aug 2026 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786627043;
	bh=8mQnIEe7HU7U+Yjdi1mxEOy4hS9STWinUy4KDR49dMM=;
	h=From:To:Cc:Subject:Date;
	b=TsN9OenatxZpleQYx5LTNI4U21Whv1wJ98RbXeSTZF2fi1lv+Z4bQmogXxYNhqcIr
	 Y29E5ahteklZ2QOj35gl1AmdpsZEVlGKB/g0901j9U0IvaxIv6ya72gurz9qyGMylS
	 eH6ldYnggdT8+BqvvSQ5Thv4EByPh6jp9SyZG49LpnnYm9BJNQr4Eycq2gVqkXNiXr
	 rSp4w1xEPpbeFuE4WoIJtP/ajYPOkAqqRs960XyfOWcZYDKeVnM4oGVSdBxo6M2eSJ
	 HN46yQN9iaOh02eDl+uRnyv1w64cu4yAwavM7H3dILb+5mXcaBkKQ6pWDwjULRP+1U
	 bl/i4FIAyqcag==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Avoid mismatched accesses to 'struct kvm_nvhe_init_params'
Date: Thu, 13 Aug 2026 14:17:16 +0100
Message-ID: <20260813131717.5885-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running with hVHE enabled, ___kvm_hyp_init() calls
__kvm_init_el2_state() on the CPU initialisation path during onlining
and resume from suspend.

In order to avoid clobbering the link register across this call, it is
stashed away in the 'tmp' member of 'struct kvm_nvhe_init_params',
however this save/restore operation is performed with the stage-1 MMU
disabled at EL2 and therefore gives rise to coherency problems because
the field is not aligned or padded to the CWG. For example, a cacheable
write to a physically-adjacent structure sharing the same cacheline
could lead to an eviction and subsequent write-back, overwriting the
saved LR while the incoming CPU is executing __kvm_init_el2_state().

Save the lr in far_el2 and remove the 'tmp' member from
'struct kvm_nvhe_init_params' altogether.

Cc: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Fixes: afa9b48f327c ("KVM: arm64: Shave a few bytes from the EL2 idmap code")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 -
 arch/arm64/kernel/asm-offsets.c    |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 11 +++++++----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..dae9b1d34c8a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -214,7 +214,6 @@ struct kvm_nvhe_init_params {
 	unsigned long hcr_el2;
 	unsigned long vttbr;
 	unsigned long vtcr;
-	unsigned long tmp;
 };
 
 /*
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b6367ff3a49c..9c853ed3ceab 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -124,7 +124,6 @@ int main(void)
   DEFINE(NVHE_INIT_HCR_EL2,	offsetof(struct kvm_nvhe_init_params, hcr_el2));
   DEFINE(NVHE_INIT_VTTBR,	offsetof(struct kvm_nvhe_init_params, vttbr));
   DEFINE(NVHE_INIT_VTCR,	offsetof(struct kvm_nvhe_init_params, vtcr));
-  DEFINE(NVHE_INIT_TMP,		offsetof(struct kvm_nvhe_init_params, tmp));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 89cb553be1e5..0b3e0b28dfc7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -106,16 +106,19 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	and	x2, x1, x2
 	cbz	x2, 1f
 
-	// hVHE: Replay the EL2 setup to account for the E2H bit
-	// TPIDR_EL2 is used to preserve x0 across the macro maze...
+	/*
+	 * hVHE: Replay the EL2 setup to account for the E2H bit
+	 * TPIDR_EL2 and FAR_EL2 are used to preserve x0 and LR across
+	 * the macro maze...
+	 */
 	isb
 	msr	tpidr_el2, x0
-	str	lr, [x0, #NVHE_INIT_TMP]
+	msr	far_el2, lr
 
 	bl	__kvm_init_el2_state
 
+	mrs	lr, far_el2
 	mrs	x0, tpidr_el2
-	ldr	lr, [x0, #NVHE_INIT_TMP]
 
 1:
 	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
-- 
2.55.0.691.gc56d675ccc-goog

