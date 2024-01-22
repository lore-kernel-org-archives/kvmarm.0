Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3023DB94
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947242; cv=none; b=TWH5WIlecZVNwAbae/uuRgU4/4oKizanJpjjyIwocbiebXTGFa9gBIBzr88O9o4i+7E6m/2Of+Yk6R5AEXGdMenSp5hHATLYqVU2Bi1cWJNKpxKxfCQ5uLB0p31QulCsYw2Gh7S+tRDcun/cPgtUSNUcfKDa/MVADcGxOtaEBCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947242; c=relaxed/simple;
	bh=R0Cn8Ja7C5C5j2Ky+9nzfqG0EdHSFUyMispgz2pKFsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JpHDLn8S2X1gllcjdvwnyVg3K9nYIvFmJkfTsG3NMSEP3j7H7cmmmk9nP05vAqfGr7M4j0gcbR/qyM1a9XXbpItWXvJKTswfLhRJ64jKN5xt/krSod6Gx21VTurBm5Fa0TneTUV7vIEnKnxqhKBcq6HsnmXZi0HW2nKiJXfYG10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8crAGYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8crAGYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A961C4166B;
	Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=R0Cn8Ja7C5C5j2Ky+9nzfqG0EdHSFUyMispgz2pKFsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8crAGYRtY77l/eHo7yiaVhwQqIjMhZKtzME/Tn6MN9bmeVBd58l+f5FGaL0Bw/Pg
	 9br1fVFiTjOPOFlVoEJuWryyRyQSgQlUZE1x2NgcyTTbn9ls5pPvdY4ejpgGVUuYHr
	 VraO4Cr28gLpn5jl4EiecnHR8sDL3JKgToVDAECbUwpoM4BmwGftBeSHm2BihBELRD
	 +tDtYAP6cSSgyzGEpeCzApk61AwtayjN5fgXvF+aTo0UxzBtPgQd1I2RkkhNozc/OO
	 we7GJ94K3JYVOooLgZZ1w84C+ar9tcOpsIIyFtCSX68Qi2lBUDOl5zDW9wk4LCODau
	 dzBCqazVFo+Iw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo3-00Dh6E-Ea;
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
Subject: [PATCH v4 05/10] arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
Date: Mon, 22 Jan 2024 18:13:39 +0000
Message-Id: <20240122181344.258974-6-maz@kernel.org>
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

Add ID_AA64MMFR4_EL1 to the list of idregs the kernel knows about,
and describe the E2H0 field.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpu.h   | 1 +
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/kernel/cpuinfo.c    | 1 +
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index b1e43f56ee46..6c13fd47e170 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -56,6 +56,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64mmfr1;
 	u64		reg_id_aa64mmfr2;
 	u64		reg_id_aa64mmfr3;
+	u64		reg_id_aa64mmfr4;
 	u64		reg_id_aa64pfr0;
 	u64		reg_id_aa64pfr1;
 	u64		reg_id_aa64zfr0;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bae5d0655262..ad3753fbdcb1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -437,6 +437,11 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
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
@@ -754,6 +759,7 @@ static const struct __ftr_reg_entry {
 			       &id_aa64mmfr1_override),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
+	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
 
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
@@ -1078,6 +1084,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR3_EL1, info->reg_id_aa64mmfr3);
+	init_cpu_ftr_reg(SYS_ID_AA64MMFR4_EL1, info->reg_id_aa64mmfr4);
 	init_cpu_ftr_reg(SYS_ID_AA64PFR0_EL1, info->reg_id_aa64pfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64PFR1_EL1, info->reg_id_aa64pfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ZFR0_EL1, info->reg_id_aa64zfr0);
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 47043c0d95ec..7ca3fbd200f0 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -447,6 +447,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
 	info->reg_id_aa64mmfr3 = read_cpuid(ID_AA64MMFR3_EL1);
+	info->reg_id_aa64mmfr4 = read_cpuid(ID_AA64MMFR4_EL1);
 	info->reg_id_aa64pfr0 = read_cpuid(ID_AA64PFR0_EL1);
 	info->reg_id_aa64pfr1 = read_cpuid(ID_AA64PFR1_EL1);
 	info->reg_id_aa64zfr0 = read_cpuid(ID_AA64ZFR0_EL1);
-- 
2.39.2

