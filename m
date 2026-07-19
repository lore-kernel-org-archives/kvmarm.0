Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C66E37F8BD;
	Sun, 19 Jul 2026 23:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502612; cv=none; b=aUwBcbbjNVZtsO/b90OSHXRBbPgvlPIaEDSJPvbF+hUOWXSDd9S+l+rRdUsMN0ECJJUeOHF3juWjZYTofLkeN9SfqhqHifQwAOuc5QK4j++aHQhiJA/PyS9ct/+gzNXC04aK/PX/d1+w/OvSmAMcxAl2Eil3nP24+VXLC28usNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502612; c=relaxed/simple;
	bh=/aZpqNOmfe5bYCE+xrs9pBCTsRM6wC0+Qw9617Xjl1A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OIL4zlAA2OxB+Fa3hjQnZP4ZO4wXIU1JQInScZeIV9HSH9qF+YAZAhcmACyt09sbvGztJgjQaEaA5mMojtGVu3Tkk/+WkI02SngkQeHtKVHpfCZL7SdexG5IHIW2JDeExubWqURQUmmAiIeK7RAeOfMRNXCwHgJc/WpSdfqKb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omFuwHYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omFuwHYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07DE1F00A3D;
	Sun, 19 Jul 2026 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502610;
	bh=nxaaIcinJ0gCQmFX7l1OGW5liSHlFeSV9iaYkQM1VXg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=omFuwHYHtHVA2wQ4tPYZxSZPMfxQLJhVG6A5U9eVS0/UD+w/lfOPNX8or3PFui6RS
	 GV8UhntUxdts53VBafCRbfCJjTgjaQFNaBa/uh0M0jQv2lUQT6zhk3b+MA7uGjAQ84
	 JVeBoPJiFXl4WDn9r1DIHHoabSVa6grzXzzHzJHGZUpYiZ9AalH0eXlDG1cld5Q0Am
	 VscwfZ8HNBJHFDukKoi5lckHiXPlsWDeqQZcUF7gWwOwg+ts7zXAkvDdNuPBXJibwg
	 7xqXhO2zHEcH6JPlQOluEZsfk1AWGPrdRvVsEIxvVV79zf85PjuzvI3j9JOQshLmWE
	 +MyKVD14cvZ4Q==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:30 +0100
Subject: [PATCH v13 03/32] arm64/fpsimd: Configure all ZCR/SMCR bits when
 loading task state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-3-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7491; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/aZpqNOmfe5bYCE+xrs9pBCTsRM6wC0+Qw9617Xjl1A=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVkpaLGrwReqnj3W8sg5ftnMspkp6xhMmoVe5
 UW2AxO0tmaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZKQAKCRAk1otyXVSH
 0K4eB/97mlMktazoOsAKi0NsebZMBi1vLbLL5QOJ1FNM4RrNn4A7PnH2xjfZ2HV6t+MLm4b80XJ
 AJ1F4s7Vqf2kBmXyidCU5I6cEpn7K2COgxO927eCxmXlmdMgbe/v9Tp7JCL7sXjy3bnrkjDTgth
 U9KNEDPw691mg/cMuDkNvdv0FA34e4UqVLM2g2NAa1aS0voNpngWG9rkcYwP4N5PidQH3sbLaOi
 olQi9fPhueWj1q/Q4T3Hnmf9/PgpXsxbQiNYuWPC9Yr/cUgQWePzKi5iSABFamcmxeN3KqzdQYB
 3JgsLak8UlFor5DHKcAuajikmZ84faJjAsWSsrVjLe80aiWu
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Currently, when loading a task's SVE and/or SME state, we configure
ZCR_ELx.LEN and/or SMCR_ELx.LEN with read-modify-write sequences,
preserving all other bits of the registers (e.g. SMCR_ELx.{FA64,ZT0}).
This relies on all the other bits already holding the expected value
for the task.

It would be simpler and more robust to configure all the bits without
a read-modify-write sequence:

 - Doing so will remove the need to configure these registers during
   feature detection and when returning from idle, simplifying the code
   and removing some redundant writes to the registers.

 - Doing so will permit KVM to clobber other bits of the registers when
   no task state is bound. Along with other changes (e.g. when saving
   state), this will make it possible for KVM to expose a different
   configuration to guests (e.g. disabling ZT0 for vCPUs, even if ZT0
   is exposed to userspace).

While SMCR_ELx.LEN and ZCR_ELx.LEN are self synchronizing SMCR_ELx.FA64
and SMCR_ELx.EZT0 are not so we add an isb() if those have changed.
This could be further optimised by considering if the SME configuration
of the loaded state means we will rely on the newly configured values
but for clarity this is not done here, it can be improved in future.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  2 -
 arch/arm64/kernel/cpufeature.c  |  2 -
 arch/arm64/kernel/fpsimd.c      | 84 +++++++++++++++++++----------------------
 3 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index e13a85320ab6..59f3c4a9e390 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -360,8 +360,6 @@ struct arm64_cpu_capabilities;
 extern void cpu_enable_fpsimd(const struct arm64_cpu_capabilities *__unused);
 extern void cpu_enable_sve(const struct arm64_cpu_capabilities *__unused);
 extern void cpu_enable_sme(const struct arm64_cpu_capabilities *__unused);
-extern void cpu_enable_sme2(const struct arm64_cpu_capabilities *__unused);
-extern void cpu_enable_fa64(const struct arm64_cpu_capabilities *__unused);
 extern void cpu_enable_fpmr(const struct arm64_cpu_capabilities *__unused);
 
 extern void fpsimd_suspend_exit(void);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120..0609dce1989e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2992,7 +2992,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.capability = ARM64_SME_FA64,
 		.matches = has_cpuid_feature,
-		.cpu_enable = cpu_enable_fa64,
 		ARM64_CPUID_FIELDS(ID_AA64SMFR0_EL1, FA64, IMP)
 	},
 	{
@@ -3000,7 +2999,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.capability = ARM64_SME2,
 		.matches = has_cpuid_feature,
-		.cpu_enable = cpu_enable_sme2,
 		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, SME, SME2)
 	},
 #endif /* CONFIG_ARM64_SME */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 78c9d8dab545..b868db2982ee 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -277,6 +277,27 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
 	task->thread.vl_onexec[type] = vl;
 }
 
+static unsigned long task_zcr(const struct task_struct *task)
+{
+	unsigned long vq = sve_vq_from_vl(task_get_sve_vl(task));
+	unsigned long zcr = vq - 1;
+
+	return zcr;
+}
+
+static unsigned long task_smcr(const struct task_struct *task)
+{
+	unsigned long vq = sve_vq_from_vl(task_get_sme_vl(task));
+	unsigned long smcr = vq - 1;
+
+	if (system_supports_fa64())
+		smcr |= SMCR_ELx_FA64;
+	if (system_supports_sme2())
+		smcr |= SMCR_ELx_EZT0;
+
+	return smcr;
+}
+
 /*
  * TIF_SME controls whether a task can use SME without trapping while
  * in userspace, when TIF_SME is set then we must have storage
@@ -377,10 +398,8 @@ static void task_fpsimd_load(void)
 			if (!thread_sm_enabled(&current->thread))
 				WARN_ON_ONCE(!test_and_set_thread_flag(TIF_SVE));
 
-			if (test_thread_flag(TIF_SVE)) {
-				unsigned long vq = sve_vq_from_vl(task_get_sve_vl(current));
-				sysreg_clear_set_s(SYS_ZCR_EL1, ZCR_ELx_LEN, vq - 1);
-			}
+			if (system_supports_sve())
+				sysreg_cond_update_s(SYS_ZCR_EL1, task_zcr(current));
 
 			restore_sve_regs = true;
 			restore_ffr = true;
@@ -402,12 +421,17 @@ static void task_fpsimd_load(void)
 
 	/* Restore SME, override SVE register configuration if needed */
 	if (system_supports_sme()) {
-		unsigned long sme_vl = task_get_sme_vl(current);
-
-		/* Ensure VL is set up for restoring data */
 		if (test_thread_flag(TIF_SME)) {
-			unsigned long vq = sve_vq_from_vl(sme_vl);
-			sysreg_clear_set_s(SYS_SMCR_EL1, SMCR_ELx_LEN, vq - 1);
+			u64 old_smcr = read_sysreg_s(SYS_SMCR_EL1);
+			u64 new_smcr = task_smcr(current);
+
+			sysreg_cond_update_s(SYS_SMCR_EL1, new_smcr);
+
+			/* FA64 and EZT0 are not self synchronising */
+			old_smcr &= SMCR_ELx_FA64 | SMCR_ELx_EZT0;
+			new_smcr &= SMCR_ELx_FA64 | SMCR_ELx_EZT0;
+			if (old_smcr != new_smcr)
+				isb();
 		}
 
 		write_sysreg_s(current->thread.svcr, SYS_SVCR);
@@ -1217,26 +1241,6 @@ void cpu_enable_sme(const struct arm64_cpu_capabilities *__always_unused p)
 	isb();
 }
 
-void cpu_enable_sme2(const struct arm64_cpu_capabilities *__always_unused p)
-{
-	/* This must be enabled after SME */
-	BUILD_BUG_ON(ARM64_SME2 <= ARM64_SME);
-
-	/* Allow use of ZT0 */
-	write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_EZT0_MASK,
-		       SYS_SMCR_EL1);
-}
-
-void cpu_enable_fa64(const struct arm64_cpu_capabilities *__always_unused p)
-{
-	/* This must be enabled after SME */
-	BUILD_BUG_ON(ARM64_SME_FA64 <= ARM64_SME);
-
-	/* Allow use of FA64 */
-	write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_FA64_MASK,
-		       SYS_SMCR_EL1);
-}
-
 void __init sme_setup(void)
 {
 	struct vl_info *info = &vl_info[ARM64_VEC_SME];
@@ -1283,20 +1287,10 @@ void __init sme_setup(void)
 
 void fpsimd_suspend_exit(void)
 {
-	u64 smcr = 0;
-
-	if (system_supports_sve())
-		write_sysreg_s(0, SYS_ZCR_EL1);
-
-	if (system_supports_sme()) {
-		if (system_supports_fa64())
-			smcr |= SMCR_ELx_FA64;
-		if (system_supports_sme2())
-			smcr |= SMCR_ELx_EZT0;
+	if (!system_supports_sme())
+		return;
 
-		write_sysreg_s(smcr, SYS_SMCR_EL1);
-		write_sysreg_s(0, SYS_SMPRI_EL1);
-	}
+	write_sysreg_s(0, SYS_SMPRI_EL1);
 }
 
 /*
@@ -1338,8 +1332,7 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
 	 * any effective streaming mode SVE state.
 	 */
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
-		unsigned long vq = sve_vq_from_vl(task_get_sve_vl(current));
-		sysreg_clear_set_s(SYS_ZCR_EL1, ZCR_ELx_LEN, vq - 1);
+		sysreg_cond_update_s(SYS_ZCR_EL1, task_zcr(current));
 		sve_flush_live();
 		fpsimd_bind_task_to_cpu();
 	} else {
@@ -1474,8 +1467,7 @@ void do_sme_acc(unsigned long esr, struct pt_regs *regs)
 		WARN_ON(1);
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
-		unsigned long vq = sve_vq_from_vl(task_get_sme_vl(current));
-		sysreg_clear_set_s(SYS_SMCR_EL1, SMCR_ELx_LEN, vq - 1);
+		sysreg_cond_update_s(SYS_SMCR_EL1, task_smcr(current));
 
 		fpsimd_bind_task_to_cpu();
 	} else {

-- 
2.47.3

