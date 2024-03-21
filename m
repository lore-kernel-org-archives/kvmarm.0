Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C03C17
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 11:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711022072; cv=none; b=OslpFO9sT5JW9G1/0k3qizEohEs+HE5BqyQo6IwAPpHHODhUdOL42DEFdLvKNyiMPkjmPZVydcX5Rddy9rKSRoCuzRsqJrpB7Zyiy06XbkTp8c8k6zBPV8WOKocBuyaCAPr3e03MkO39g3by8rzf+6dd+GDYY+N20cNKRPfnDxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711022072; c=relaxed/simple;
	bh=5lZnvjA+/xFbb9DKJlPTHynLRn9dpcg73+obB1uDuAE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M+7KJtXka1YjzZ79qyswI7UWuT6tDlIkn1mHycBXnS0SHjLGL82YDM0bsfpxwKlc+mihpU2s1HD9O0+IwdH+XZfIkI+7WcLCNKDxLdntV2z6u2OC6Gl6YcWJmy+HgMGNItyQKbOpM7szYzs31TGGKF4FEFb30v65yJBNAOb2nBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVYrrz89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVYrrz89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20FAC433C7;
	Thu, 21 Mar 2024 11:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711022071;
	bh=5lZnvjA+/xFbb9DKJlPTHynLRn9dpcg73+obB1uDuAE=;
	h=From:To:Cc:Subject:Date:From;
	b=cVYrrz89jQMqsemjYmLUwRvW819ZPie5/n+SuyZDFxtM5idVbpadMAk4V272myZwW
	 vxeKaGozDB/NUBuxvOFKzRnTh6xJS63NY6+cjwCfh+cYLVEihT/WaVlfKdDF7+14gT
	 oKaYP6aHUvJJsPTfPGljOORWmFt+PdjSnb5y7BlQJip6OKWNreniVZqvio9qsJydYB
	 Qemfug8TfHUuHOMF7JS91MUUuRn4rFmisRwWGfCvob3QKxmP4tGwKQOgpLWlXlWiir
	 897Iq6aBGFDhcDVUpo21F6p+bZbHSKv1d0I5SEK5AmPXU+ZW0cT7XOdAJa8+sW6oHL
	 t0MG5sWpun6Mg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnH09-00EAzk-Fj;
	Thu, 21 Mar 2024 11:54:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] arm64: Fix early handling of FEAT_E2H0 not being implemented
Date: Thu, 21 Mar 2024 11:54:14 +0000
Message-Id: <20240321115414.3169115-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Commit 3944382fa6f2 introduced checks for the FEAT_E2H0 not being
implemented. However, the check is absolutely wrong and makes a
point it testing a bit that is guaranteed to be zero.

On top of that, the detection happens way too late, after the
init_el2_state has done its job.

This went undetected because the HW this was tested on has E2H being
RAO/WI, and not RES1. However, the bug shows up when run as a nested
guest, where HCR_EL2.E2H is not necessarily set to 1. As a result,
booting the kernel in hVHE mode fails with timer accesses being
cought in a trap loop (which was fun to debug).

Fix the check for ID_AA64MMFR4_EL1.E2H0, and set the HCR_EL2.E2H bit
early so that it can be checked by the rest of the init sequence.

With this, hVHE works again in a NV environment that doesn't have
FEAT_E2H0.

Fixes: 3944382fa6f2 ("arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/head.S | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index ce08b744aaab..06234c3a15f3 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -291,6 +291,21 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	blr	x2
 0:
 	mov_q	x0, HCR_HOST_NVHE_FLAGS
+
+	/*
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
+	 * RES1 in that case. Publish the E2H bit early so that
+	 * it can be picked up by the init_el2_state macro.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
+	 * don't advertise it (they predate this relaxation).
+	 */
+	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
+	tbz	x1, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
+
+	orr	x0, x0, #HCR_E2H
+1:
 	msr	hcr_el2, x0
 	isb
 
@@ -303,22 +318,10 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 
 	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
 
-	/*
-	 * Compliant CPUs advertise their VHE-onlyness with
-	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
-	 * RES1 in that case.
-	 *
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
-	 * don't advertise it (they predate this relaxation).
-	 */
-	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
-	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
-	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
-
 	mrs	x0, hcr_el2
 	and	x0, x0, #HCR_E2H
 	cbz	x0, 2f
-1:
+
 	/* Set a sane SCTLR_EL1, the VHE way */
 	pre_disable_mmu_workaround
 	msr_s	SYS_SCTLR_EL12, x1
-- 
2.39.2

