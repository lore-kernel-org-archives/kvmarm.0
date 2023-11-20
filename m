Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F901A5BC
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6ZWZmvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE4FC433C9;
	Mon, 20 Nov 2023 12:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700483867;
	bh=drqdatwZNNrfZOfvVDcMLo2myB2+/5lGPticb1sXcDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6ZWZmvr+CYaXXzHHi4WlFCbdE+q5lKQTt1zGJCErNst6AaHMvL4ZBQQosiA8OSDR
	 ilgyIvC8GPFcBLHE8m0dOFLHYyjg4b1an4B7b35werZykpALW69tu8dddyHxUA39x1
	 NqCRMjCRwDgKPT0+Fj6x39i0TjREeRqkCCmhRXD8PPAlZa0P85ABzATlXxD2jK2Th1
	 LJTMCxLRRbML24xkYPvblxybqIUczltHdp9Nwq6pE9YD2gCgZow+3cvcwIalkC3zP1
	 q+5hjl6eqKDr9QiIp9uIJsOh29GjhKtzEyTkkdDsvzmTSeuU99QtlhQkLBTllQC5SR
	 qenVY3xh/eewQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r53X7-00EjJv-Cd;
	Mon, 20 Nov 2023 12:37:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 08/13] arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative
Date: Mon, 20 Nov 2023 12:37:16 +0000
Message-Id: <20231120123721.851738-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120123721.851738-1-maz@kernel.org>
References: <20231120123721.851738-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
already have this path to cope with fruity CPUs.

Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c |  5 ++---
 arch/arm64/kernel/head.S       | 23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a733c9a83f83..64a026cc5cec 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -140,7 +140,6 @@ void dump_cpu_features(void)
 	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
 }
 
-#define __ARM64_EXPAND_RFV(reg, field, val)	reg##_##field##_##val
 #define __ARM64_MAX_POSITIVE(reg, field)				\
 		((reg##_##field##_SIGNED ?				\
 		  BIT(reg##_##field##_WIDTH - 1) :			\
@@ -165,7 +164,7 @@ void dump_cpu_features(void)
  */
 #define ARM64_CPUID_FIELDS(reg, field, min_value)			\
 	__ARM64_CPUID_FIELDS(reg, field,				\
-			     __ARM64_EXPAND_RFV(reg, field, min_value),	\
+			     SYS_FIELD_VALUE(reg, field, min_value),	\
 			     __ARM64_MAX_POSITIVE(reg, field))
 
 /*
@@ -176,7 +175,7 @@ void dump_cpu_features(void)
 #define ARM64_CPUID_FIELDS_NEG(reg, field, max_value)			\
 	__ARM64_CPUID_FIELDS(reg, field,				\
 			     __ARM64_MIN_NEGATIVE(reg, field),		\
-			     __ARM64_EXPAND_RFV(reg, field, max_value))
+			     SYS_FIELD_VALUE(reg, field, max_value))
 
 #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	{						\
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 7b236994f0e1..57e39bc3b2b5 100644
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

