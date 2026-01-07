Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6083132548C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 18:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809229; cv=none; b=NJ8VQ2pR1QtavsdcoT1+waEWIyAoXP5wpV+tNycNEG8XptxazaX73eDwoBN6wgb7TycQPMQjoZkvn5urAdJejfnqVM2s6tzyBNDhiRideRhjwiTHakJvlJYSdyFo4TqA686x6/H97n+W0lWjnqwh9xfcaRZRBoiW/GTF2rM8CoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809229; c=relaxed/simple;
	bh=xXE/PlTwR8mL0+jghSbaljIqMREGIinKz771yCV9QtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDqtlHQknE6FiexD7h04WEvy70rVY6EDtpIjYLIz1PlfTUqsiEkXoikszmV7N7BlsVQqbTiiEKMQngfBSTSpJHvPNCxaXGzAyE7U8lZ9tTfzVhltqDIqlc/Ngij21WbcZ+E/Wq5cGF97VsAj5H/PI3c4Qun1Lrk9Ju1DEs025KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1vdAJjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1vdAJjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D0DC4CEF7;
	Wed,  7 Jan 2026 18:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767809228;
	bh=xXE/PlTwR8mL0+jghSbaljIqMREGIinKz771yCV9QtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1vdAJjtamO6TJmlh2ImsjLWtgjJX7WbIZZ+PoGkhVgyyEfrJlRUYUvAj94g1AyGr
	 CTKabkogo2XFQ2z1rLmBY3FZQdsPFYFf58M3DX8yBLWl757sQd9DXDvzWHkDU0I65L
	 OCtGtKkHxOVFz2UndTaP6if6QW4oNB7SCc5cOUALrwQFxLDf3bBSSzG00nHyJBUruK
	 LPisK2J/uMaFH7LgPDqTK6yNrc1fcJqzhSYndhrsID4BEpNZNCmL6+fqXG/6Su4Erp
	 XU5j4abvo3sowRKwWVrMdswU4+M4vBzL2bwNVXa+awdzEs14kp/ju3q9M8as06UydA
	 6iz47Rhbk7a0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdXw2-00000000A9B-28Wh;
	Wed, 07 Jan 2026 18:07:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] arm64: Unconditionally enable EPAN support
Date: Wed,  7 Jan 2026 18:07:01 +0000
Message-ID: <20260107180701.2858276-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107180701.2858276-1-maz@kernel.org>
References: <20260107180701.2858276-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While FEAT_PAN3 is pretty recent, having it permanently enabled costs
exactly nothing, and does help with exec-only mappings on these fancy
ARMv9.2 machines that are rumoured to exist.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/Kconfig                  | 13 -------------
 arch/arm64/configs/hardening.config |  3 ---
 arch/arm64/include/asm/cpucaps.h    |  2 --
 arch/arm64/kernel/cpufeature.c      |  2 --
 4 files changed, 20 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fcfb62ec4bae8..c31079f4b611a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2120,19 +2120,6 @@ config ARM64_MTE
 
 endmenu # "ARMv8.5 architectural features"
 
-menu "ARMv8.7 architectural features"
-
-config ARM64_EPAN
-	bool "Enable support for Enhanced Privileged Access Never (EPAN)"
-	default y
-	help
-	  Enhanced Privileged Access Never (EPAN) allows Privileged
-	  Access Never to be used with Execute-only mappings.
-
-	  The feature is detected at runtime, and will remain disabled
-	  if the cpu does not implement the feature.
-endmenu # "ARMv8.7 architectural features"
-
 config AS_HAS_MOPS
 	def_bool $(as-instr,.arch_extension mops)
 
diff --git a/arch/arm64/configs/hardening.config b/arch/arm64/configs/hardening.config
index 24179722927e1..e59034e7af256 100644
--- a/arch/arm64/configs/hardening.config
+++ b/arch/arm64/configs/hardening.config
@@ -18,6 +18,3 @@ CONFIG_ARM64_BTI_KERNEL=y
 CONFIG_ARM64_MTE=y
 CONFIG_KASAN_HW_TAGS=y
 CONFIG_ARM64_E0PD=y
-
-# Available in ARMv8.7 and later.
-CONFIG_ARM64_EPAN=y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 177c691914f87..13c0fa54ea19f 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -19,8 +19,6 @@ cpucap_is_possible(const unsigned int cap)
 			   "cap must be < ARM64_NCAPS");
 
 	switch (cap) {
-	case ARM64_HAS_EPAN:
-		return IS_ENABLED(CONFIG_ARM64_EPAN);
 	case ARM64_SVE:
 		return IS_ENABLED(CONFIG_ARM64_SVE);
 	case ARM64_SME:
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 716440d147a2d..30eea68178c87 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2547,7 +2547,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_pan,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, PAN, IMP)
 	},
-#ifdef CONFIG_ARM64_EPAN
 	{
 		.desc = "Enhanced Privileged Access Never",
 		.capability = ARM64_HAS_EPAN,
@@ -2555,7 +2554,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, PAN, PAN3)
 	},
-#endif /* CONFIG_ARM64_EPAN */
 	{
 		.desc = "LSE atomic instructions",
 		.capability = ARM64_HAS_LSE_ATOMICS,
-- 
2.47.3

