Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395358234
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947242; cv=none; b=YrPRJn+R8omatoOImH+ZHM9PFdndJgNTvwtQ5aLJ3x0Cg27MGpjpki1qKqntQDI/KCfOHL8oJp5lzoHoISOpnjAFpvcchBBBWf5pNuPZZqMzV8hQmS7Asf90rjDRDxX0B1AekA86nmm2oeqUPQk8wFWKrLLx0e1ycBFMgu7j4bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947242; c=relaxed/simple;
	bh=hd9KsuVWHQ3mf1EmYOOu8k1O2jo8O8ksqnfICiMkpEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VnlsWemj4k5wBYdrlF3J3pw/qZH4A0K5xgVdnS+N8c3IqstT75ZPxQmLLSW4+RGJmI8+FbmNcuMtzcl2JyVr04re1uaT5PcyWlFc1acWQ+z3M4EwOGKzyL/mHjx8kA8I/6erIkpJfovQsj4xAc6ldR3qJdo4TWprTqUQ+sV0v4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAPegHue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAPegHue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50EAC4167E;
	Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=hd9KsuVWHQ3mf1EmYOOu8k1O2jo8O8ksqnfICiMkpEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAPegHue9IdG2sv7URbYyv4PgVSReqO5KrFcYrLUulAuaR/l+tBQXRYfnxjpXVKsz
	 rPjK/1rIvBwcwk/PDz8qoxF7CQgQEBhoBPaOkjs9YB9uo7IqjR/fl9ydhXo8d5mLS0
	 F0uMLrOSXUQu49xTxKKI2S1purYvcidMAsHPAN9nvHYtJ/h3UQTjDxrsQgNKmnkBJQ
	 gqkuXzq2s/jL0b+FH95XPKlBuvf4RPQOGf9I1Z5pzjBpJhUA+m3aJcoXgRoN88cWaN
	 lXGU8QIG6DvYUTuGqZoRdtj6L+gtzgNzlQ09azX1sKm7uVjBZmj8SheOHvfBLiDPb3
	 7PXDQkNy+48Xw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo3-00Dh6E-RA;
	Mon, 22 Jan 2024 18:13:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 07/10] arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative
Date: Mon, 22 Jan 2024 18:13:41 +0000
Message-Id: <20240122181344.258974-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, ardb@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
already have this path to cope with fruity CPUs.

Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/head.S | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index cab7f91949d8..5bdafbcff009 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -584,25 +584,32 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
 
 	/*
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
-	 * making it impossible to start in nVHE mode. Is that
-	 * compliant with the architecture? Absolutely not!
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
+	 * RES1 in that case.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
+	 * don't advertise it (they predate this relaxation).
 	 */
+	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
+	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
+	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
+
 	mrs	x0, hcr_el2
 	and	x0, x0, #HCR_E2H
-	cbz	x0, 1f
-
+	cbz	x0, 2f
+1:
 	/* Set a sane SCTLR_EL1, the VHE way */
 	pre_disable_mmu_workaround
 	msr_s	SYS_SCTLR_EL12, x1
 	mov	x2, #BOOT_CPU_FLAG_E2H
-	b	2f
+	b	3f
 
-1:
+2:
 	pre_disable_mmu_workaround
 	msr	sctlr_el1, x1
 	mov	x2, xzr
-2:
+3:
 	__init_el2_nvhe_prepare_eret
 
 	mov	w0, #BOOT_CPU_MODE_EL2
-- 
2.39.2

