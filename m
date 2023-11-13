Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AFC22EFC
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jn6AuRwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8409C433CB;
	Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897424;
	bh=/e5j7Zt5OXbydPm2a5Ik1iZwuYfegv0/VCYg4dYEwx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn6AuRwNtA/yJbmPk2pzlzwijT9CrtcBp5izLXNG7znwNdB+vURHerhPTS+RPnWTU
	 tasKXxwWwHCbKz9WKWy0VtZULT6JdJFgTMWFX6ryiHVVzV7TmQe0juBKOKp237EwCS
	 pDvMqc1+jvl4vnkGgL/48xBUYYOdodbjnbdMNrkV6r291od65bnbvI5MRPP86+SB+k
	 HCc7f738n5EYzHbQ/9caXR9UcNA9SOFYS3hbFXhODO36HVIvJemmeaJX8BO3FbGuFR
	 Q91UR6Lf9oRKpvGLx3HXfiSCxND+LPRUlL2seRVaYuyWLRwYA/PrpOHjJBb2CzASNs
	 e9aHsk3gHCNDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayM-00CkQ4-KG;
	Mon, 13 Nov 2023 17:43:42 +0000
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
Subject: [PATCH 04/12] arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
Date: Mon, 13 Nov 2023 17:42:36 +0000
Message-Id: <20231113174244.3026520-5-maz@kernel.org>
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

Add ID_AA64MMFR4_EL1 to the list of idregs the kernel knows about,
and describe the E2H0 field.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpu.h   | 1 +
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/kernel/cpuinfo.c    | 1 +
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index f3034099fd95..d5ba6ec9f711 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -57,6 +57,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64mmfr1;
 	u64		reg_id_aa64mmfr2;
 	u64		reg_id_aa64mmfr3;
+	u64		reg_id_aa64mmfr4;
 	u64		reg_id_aa64pfr0;
 	u64		reg_id_aa64pfr1;
 	u64		reg_id_aa64zfr0;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 767a6f288755..41db7f993eef 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -438,6 +438,11 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_ctr[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1), /* RES1 */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_DIC_SHIFT, 1, 1),
@@ -755,6 +760,7 @@ static const struct __ftr_reg_entry {
 			       &id_aa64mmfr1_override),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
+	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
 
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
@@ -1079,6 +1085,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR3_EL1, info->reg_id_aa64mmfr3);
+	init_cpu_ftr_reg(SYS_ID_AA64MMFR4_EL1, info->reg_id_aa64mmfr4);
 	init_cpu_ftr_reg(SYS_ID_AA64PFR0_EL1, info->reg_id_aa64pfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64PFR1_EL1, info->reg_id_aa64pfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ZFR0_EL1, info->reg_id_aa64zfr0);
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index a257da7b56fe..a4205effca46 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -452,6 +452,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
 	info->reg_id_aa64mmfr3 = read_cpuid(ID_AA64MMFR3_EL1);
+	info->reg_id_aa64mmfr4 = read_cpuid(ID_AA64MMFR4_EL1);
 	info->reg_id_aa64pfr0 = read_cpuid(ID_AA64PFR0_EL1);
 	info->reg_id_aa64pfr1 = read_cpuid(ID_AA64PFR1_EL1);
 	info->reg_id_aa64zfr0 = read_cpuid(ID_AA64ZFR0_EL1);
-- 
2.39.2

