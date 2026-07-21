Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B135E3E49D4
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653691; cv=none; b=mApon57BQn3/vOVsJSE/NCBnj30SvnDrtQ2cTSND0/2UjfMicoxfwx6kKS+qBgiMG0OvVMSuJ6Rpehu/FgS4kIF7VCtxudjBA4RECR3hgB+CVTjx92tPCoi82e6Ww/ifu0Pt6qk/QfLPI5YMFpk+sFgK+BmVa5Lli8DYBnK22ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653691; c=relaxed/simple;
	bh=PlcPQDFC8s5rVbdbhfsSOHPPT73vbmThKQ3FFGLvR38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeV4xC8u0lxNkXJx9gEUFytXmf8FBpAvQSgr71XwxcCU1CMxUL5adFRClDuAzHUTvuj5LQjRb/lcZOIkC6uHt6KCmJlbOWCGP0gSUme9v4Ze8QdJDObP1GMU4UvVgzWsEc5mJgVklqhW0tf/AU0qr6LSkKmekJFBU17+MBcS/bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlW9HAn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlW9HAn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636951F00A3D;
	Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653686;
	bh=3r6dZmt3FBP0iVpP3O5kIP4fsBWTgN6R+bZQvrqxQGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlW9HAn8tL8M0f1X06zu7CBxVgFnd9A2Sw0ff968uoq8aes9CfNLKG4SlIvsefgtW
	 mrDP7UGBHVsPoAr9Ujix+MqHL0i3Po67HUfxqcyY/3MisbfsQlN3pQliEcH2g0W+6N
	 eFd1OAlgMS6Sh1HDEK7f7oxGd9Jtl6dSLIF4llX9HwcsvN3r23zZ86Im9cKaGi9oO5
	 MHTy5TwWju6mhyrh1wMcTKZsDQ/vOlfAWws63IwwdT6gM5oRX8bI4Ji7B8W1jfw6wQ
	 +cBJQgQMBnOQBJv9ci5o4PCDfS+xI9jUSVAo2qDQoygBw/qG4/4s9iA5+RnMlLR5Bh
	 efV8T1+dZoaeQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmDwq-00000007J9p-2VTq;
	Tue, 21 Jul 2026 17:08:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/6] KVM: arm64: Move GICv3 broken SEIS implementation detection to a CPU errrata
Date: Tue, 21 Jul 2026 18:07:50 +0100
Message-ID: <20260721170754.3150521-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721170754.3150521-1-maz@kernel.org>
References: <20260721170754.3150521-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Using is_midr_in_range_list() in a noinstr function isn't a good idea.
And yet kvm_compute_ich_hcr_trap_bits() is doing that by calling
vgic_v3_broken_seis().

Move all the broken SEIS detection logic to the errata detection
framework, and use a new ARM64_WORKAROUND_GICv3_BROKEN_SEIS cap
to indicate that we're running on broken CPUs.

This reuses the MIDR list used for IMPDEF PMU detection, which
has a 100% overlap with the SEIS stuff...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 17 +++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v3.c  | 26 +++-----------------------
 arch/arm64/tools/cpucaps       |  1 +
 3 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1995e1198648e..78e4e105f6ab5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -272,7 +272,7 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(&range) && has_dic;
 }
 
-static const struct midr_range impdef_pmuv3_cpus[] = {
+static const struct midr_range apple_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
@@ -301,7 +301,14 @@ static bool has_impdef_pmuv3(const struct arm64_cpu_capabilities *entry, int sco
 	if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		return false;
 
-	return is_midr_in_range_list(impdef_pmuv3_cpus);
+	return is_midr_in_range_list(apple_cpus);
+}
+
+static bool has_broken_gic_v3_seis(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	return (is_kernel_in_hyp_mode() &&
+		is_midr_in_range_list(apple_cpus) &&
+		(read_sysreg_s(SYS_ICH_VTR_EL2) & ICH_VTR_EL2_SEIS));
 }
 
 static void cpu_enable_impdef_pmuv3_traps(const struct arm64_cpu_capabilities *__unused)
@@ -1009,6 +1016,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_impdef_pmuv3,
 		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
 	},
+	{
+		.desc = "Known broken GICv3 SEIS implementation",
+		.capability = ARM64_WORKAROUND_GICv3_BROKEN_SEIS,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_broken_gic_v3_seis,
+	},
 	{
 	}
 };
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9e841e7afd4a7..0991a649a5d1e 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -809,27 +809,9 @@ static int __init early_gicv4_enable(char *buf)
 }
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
-static const struct midr_range broken_seis[] = {
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
-	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
-	{},
-};
-
-static bool vgic_v3_broken_seis(void)
+static __always_inline bool vgic_v3_broken_seis(void)
 {
-	return (is_kernel_in_hyp_mode() &&
-		is_midr_in_range_list(broken_seis) &&
-		(read_sysreg_s(SYS_ICH_VTR_EL2) & ICH_VTR_EL2_SEIS));
+	return cpus_have_cap(ARM64_WORKAROUND_GICv3_BROKEN_SEIS);
 }
 
 void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
@@ -959,10 +941,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (has_v2)
 		static_branch_enable(&vgic_v3_has_v2_compat);
 
-	if (vgic_v3_broken_seis()) {
-		kvm_info("GICv3 with broken locally generated SEI\n");
+	if (vgic_v3_broken_seis())
 		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_EL2_SEIS;
-	}
 
 	vgic_v3_enable_cpuif_traps();
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd49..50373264ecde8 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -121,6 +121,7 @@ WORKAROUND_CAVIUM_TX2_219_TVM
 WORKAROUND_CLEAN_CACHE
 WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_DISABLE_CNP
+WORKAROUND_GICv3_BROKEN_SEIS
 WORKAROUND_PMUV3_IMPDEF_TRAPS
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_QCOM_ORYON_CNTVOFF
-- 
2.47.3

