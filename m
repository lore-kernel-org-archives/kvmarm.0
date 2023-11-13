Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B596522EE4
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmRBNJGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155D5C433D9;
	Mon, 13 Nov 2023 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897425;
	bh=mDtW4Z8A35acA1VEGJf/ya9n7T6SEZP2HzCfuJMDHcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmRBNJGaEz3mol0snFfXEoLkMTBJswLqCDKrxZtBJUiEv2rACqT8qmOEN8mN1i1ED
	 DYVTpxNgudYABtA1xDC4lP8HiPRqlOykBnvANzBqPhn/7UtJtPRsqSJpaIHT0CQXs7
	 BV8FCmBH4TVkGc/dDbNRC2JtnVVJAEZvT40Y+4h/vBb9Uptcj0bmd7jV06cYx8yauE
	 sMiraiHjkpkyjWO3Bh0JvjnD9la3AAILFGTrb3y1Xe4OaIgzPmguNoTkmHYuYSIjQt
	 YMOHragIFmf7ZkJ25PN+nAvut5WLGXqnBV69U8bEU9quJO4ZrRZfOceVOip7G+9U8o
	 ITHrFmZBmeB1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayN-00CkQ4-68;
	Mon, 13 Nov 2023 17:43:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 07/12] arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is non-zero
Date: Mon, 13 Nov 2023 17:42:39 +0000
Message-Id: <20231113174244.3026520-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231113174244.3026520-1-maz@kernel.org>
References: <20231113174244.3026520-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

For CPUs that have ID_AA64MMFR4_EL1.E2H0 as non-zero, it is important
to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
already have this path to cope with fruity CPUs.

Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/head.S | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 7b236994f0e1..5853540f7809 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -584,25 +584,34 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
 
 	/*
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
-	 * making it impossible to start in nVHE mode. Is that
-	 * compliant with the architecture? Absolutely not!
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0=0b111x. HCR_EL2.E2H can be
+	 * RES1 in that case.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
+	 * don't advertise it (they predate this relaxation).
 	 */
+	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
+	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
+	and	x0, x0, #0b1110
+	cmp	x0, #0b1110
+	b.eq	1f
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

