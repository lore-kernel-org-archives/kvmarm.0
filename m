Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1C032548C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 18:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809228; cv=none; b=AANs3BGFCFUxT5L9Y3yOPox0Kzz4N0KOBeXRrtHwOhcrIHBZcKzSLFRfwKh9Ni7eSuC23zEQt5Sxxa9bYIrqdUeww5bjhiMvNrs5wpgyUm/WXzWSeyWSJiJiPCUuV/6i1+SMLAOW5p/2yGmazIFwCj03pVW2UaumnzmClDx/Lg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809228; c=relaxed/simple;
	bh=N6M0b2+CGYBC2hMrLP3PopLzkqWApDE4nykzu26OAvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgoEkT+rrbS72Ij8f0I4Bx/AFSD8lHH34v+OL1cocOesmHPJ6eAEQFYoYd+Nl+uaNnjtfwL8s2cdveuoMgt4l9GERrUdrSqxS2jgW1m3qHgqTblaz3YoIXyEtNIctEVrEJp2VOKQEWyAMtaetALR1mdnWH0t8WUHBDvsv8pqWUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELs8wT4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELs8wT4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3596BC19424;
	Wed,  7 Jan 2026 18:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767809228;
	bh=N6M0b2+CGYBC2hMrLP3PopLzkqWApDE4nykzu26OAvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELs8wT4wQBcPQdJTobjq9EPne4YVMQgLXIwarn5x/E1wkXTOpE+CgKsWaHDMCdKC5
	 v/CagzTghhqwKrnW5zk7c2KfA1hiQRagbFg7HHJbDrWHAovTJiCEooyAqTTA3w68bi
	 P5VubvAC9xK/Lwv/rtP6o5xPb+9jegT3lhmyAdLUWNTiO54mWkg26CaTXZ4R/ifpWu
	 Zmcll1Kmoy+T/Ey9m65RfRnqXExFx7C1ZZADQ+4tLxCyU3kRmhdqrKoqM34aKCYYFa
	 R7JqfZtTZ83UigKvr+WmPd5vOQkfq8+OrqQCEoYQnsy4R2OFJikDdgGOoFnioheubg
	 tSA5wwN+Al2mg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdXw1-00000000A9B-3qvE;
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
Subject: [PATCH 2/3] arm64: Unconditionally enable PAN support
Date: Wed,  7 Jan 2026 18:07:00 +0000
Message-ID: <20260107180701.2858276-3-maz@kernel.org>
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

FEAT_PAN has been around since ARMv8.1 (over 11 years ago), has no compiler
dependency (we have our own accessors), and is a great security benefit.

Drop CONFIG_ARM64_PAN, and make the support unconditionnal.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/Kconfig               | 17 -----------------
 arch/arm64/include/asm/cpucaps.h |  2 --
 arch/arm64/include/asm/uaccess.h |  6 ++----
 arch/arm64/kernel/cpufeature.c   |  4 ----
 arch/arm64/kvm/hyp/entry.S       |  2 +-
 5 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b6f57cc1e4df8..fcfb62ec4bae8 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1680,7 +1680,6 @@ config MITIGATE_SPECTRE_BRANCH_HISTORY
 config ARM64_SW_TTBR0_PAN
 	bool "Emulate Privileged Access Never using TTBR0_EL1 switching"
 	depends on !KCSAN
-	select ARM64_PAN
 	help
 	  Enabling this option prevents the kernel from accessing
 	  user-space memory directly by pointing TTBR0_EL1 to a reserved
@@ -1859,20 +1858,6 @@ config ARM64_HW_AFDBM
 	  to work on pre-ARMv8.1 hardware and the performance impact is
 	  minimal. If unsure, say Y.
 
-config ARM64_PAN
-	bool "Enable support for Privileged Access Never (PAN)"
-	default y
-	help
-	  Privileged Access Never (PAN; part of the ARMv8.1 Extensions)
-	  prevents the kernel or hypervisor from accessing user-space (EL0)
-	  memory directly.
-
-	  Choosing this option will cause any unprotected (not using
-	  copy_to_user et al) memory access to fail with a permission fault.
-
-	  The feature is detected at runtime, and will remain as a 'nop'
-	  instruction if the cpu does not implement the feature.
-
 endmenu # "ARMv8.1 architectural features"
 
 menu "ARMv8.2 architectural features"
@@ -2109,7 +2094,6 @@ config ARM64_MTE
 	depends on ARM64_AS_HAS_MTE && ARM64_TAGGED_ADDR_ABI
 	depends on AS_HAS_ARMV8_5
 	# Required for tag checking in the uaccess routines
-	select ARM64_PAN
 	select ARCH_HAS_SUBPAGE_FAULTS
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_USES_PG_ARCH_2
@@ -2141,7 +2125,6 @@ menu "ARMv8.7 architectural features"
 config ARM64_EPAN
 	bool "Enable support for Enhanced Privileged Access Never (EPAN)"
 	default y
-	depends on ARM64_PAN
 	help
 	  Enhanced Privileged Access Never (EPAN) allows Privileged
 	  Access Never to be used with Execute-only mappings.
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2c8029472ad45..177c691914f87 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -19,8 +19,6 @@ cpucap_is_possible(const unsigned int cap)
 			   "cap must be < ARM64_NCAPS");
 
 	switch (cap) {
-	case ARM64_HAS_PAN:
-		return IS_ENABLED(CONFIG_ARM64_PAN);
 	case ARM64_HAS_EPAN:
 		return IS_ENABLED(CONFIG_ARM64_EPAN);
 	case ARM64_SVE:
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 6490930deef84..9810106a3f664 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -124,14 +124,12 @@ static inline bool uaccess_ttbr0_enable(void)
 
 static inline void __uaccess_disable_hw_pan(void)
 {
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,
-			CONFIG_ARM64_PAN));
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN));
 }
 
 static inline void __uaccess_enable_hw_pan(void)
 {
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
-			CONFIG_ARM64_PAN));
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN));
 }
 
 static inline void uaccess_disable_privileged(void)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 547ccf28f2893..716440d147a2d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2164,7 +2164,6 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
 	return cpu_supports_bbml2_noabort();
 }
 
-#ifdef CONFIG_ARM64_PAN
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
@@ -2176,7 +2175,6 @@ static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 	sysreg_clear_set(sctlr_el1, SCTLR_EL1_SPAN, 0);
 	set_pstate_pan(1);
 }
-#endif /* CONFIG_ARM64_PAN */
 
 #ifdef CONFIG_ARM64_RAS_EXTN
 static void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
@@ -2541,7 +2539,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, ECV, CNTPOFF)
 	},
-#ifdef CONFIG_ARM64_PAN
 	{
 		.desc = "Privileged Access Never",
 		.capability = ARM64_HAS_PAN,
@@ -2550,7 +2547,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_pan,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, PAN, IMP)
 	},
-#endif /* CONFIG_ARM64_PAN */
 #ifdef CONFIG_ARM64_EPAN
 	{
 		.desc = "Enhanced Privileged Access Never",
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 9f4e8d68ab505..11a10d8f5beb2 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -126,7 +126,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 
 	add	x1, x1, #VCPU_CONTEXT
 
-	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
+	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN)
 
 	// Store the guest regs x2 and x3
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
-- 
2.47.3

