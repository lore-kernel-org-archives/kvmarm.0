Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3F94EBAF3
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451648; cv=none; b=OZxxOMq5fXyM6H6I831kZpCcVS4z6DW9uIp/d/uXFwtKVHuT3N+6xXbG52TuCerKxK1ufoJOO4w6UXAgolgEOfkaSaqOqSKFkbykvrO1AomusvXyKeDs0EEib77iVzxJ/7WIbSPKyfp60rJnvUdt2CbkgIQuyQkdJI7/XGbddcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451648; c=relaxed/simple;
	bh=Ylegp9Ly/fHt+npy6sCxg7xBOnZSmibnjwlqSWKyQZg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTTrHkzt81mkbhVdbiG2DjeIV6jvFjgEpidpDbXkRcnONjktkzA2yP2Skiczhp/KVIOXvF++lPw380ejNOICDAC92uyz63PkUg1LojA4ja/Kre8xTtahBrDYGCTBSXoe+ep7Tw34+9aExqnLykHiZNSGCX43q4dkb1+4XJE4q6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GpU0+H/Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GpU0+H/Y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDFF71F60;
	Thu,  3 Sep 2026 09:07:21 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B73DD3F673;
	Thu,  3 Sep 2026 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451645; bh=Ylegp9Ly/fHt+npy6sCxg7xBOnZSmibnjwlqSWKyQZg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GpU0+H/YF13gVFQfuV3BShNrGU1a7RIybDsEfit9S5Afs9RdvNMoFl6ltLTx9gFC7
	 shzdH5jHEygSX0NYhCcVfAWwyK+P18DnzZa4ghKlBnvFP0HbSgQgmV25p0SYJ0JDVZ
	 DYnhMp8kFZAzCOqgwTp8rSteTWWvDsdkZdNLoe64=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 24/28] arm64: errata: Don't enable guest buffer if misprogrammed
Date: Thu,  3 Sep 2026 17:06:19 +0100
Message-ID: <20260903160623.315525-25-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When PMBPTR_EL1 is programmed to be equal to or greater than
PMBLIMITR_EL1.Limit, SPE is enabled and PMBSR_EL1.S is zero, the CPU might
deadlock.

This doesn't affect correctly written software, like the SPE driver, but a
buggy KVM guest might trigger the erratum. The workaround for KVM is not to
enable the hardware buffer, and, as a consequence, profiling. According
to ARM DDI0487M.c, rule R_PGGHS, this is one of the acceptable
behaviours when the buffer is misprogrammed.

Several parts are affected:

* ARM Neoverse-N1 (MP050), SDEN v35, erratum 1978083
  https://support.arm.com/documentation/SDEN-885747/35-0
* ARM Neoverse-V1 (MP076), SDEN v23, erratum 1978082
  https://support.arm.com/documentation/SDEN-1401781/23-0
* ARM Cortex-X1 (MP077), SDEN v25, erratum 2004055
  https://support.arm.com/documentation/SDEN-1401782/25-0
* ARM Cortex-X1C (MP136), SDEN v20, erratum 2004056
  https://support.arm.com/documentation/SDEN-1707914/20-0
* ARM Cortex-A78 (MP102), SDEN v25, erratum 2004055
  https://support.arm.com/documentation/SDEN-1401784/25-0
* ARM Cortex-A78AE (MP105), SDEN v22, erratum 2004059
  https://support.arm.com/documentation/SDEN-1707912/22-0
* ARM Cortex-A78C (MP138), SDEN v20, erratum 2004056
  https://support.arm.com/documentation/SDEN-1707916/20-0

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/arch/arm64/silicon-errata.rst | 14 +++++++++++
 arch/arm64/Kconfig                          | 25 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_spe.h            |  1 +
 arch/arm64/kernel/cpu_errata.c              | 26 +++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/spe-sr.c             |  6 +++--
 arch/arm64/kvm/spe.c                        | 22 +++++++++++++++++
 arch/arm64/tools/cpucaps                    |  1 +
 drivers/perf/arm_spe_pmu.c                  |  3 +++
 include/linux/perf/arm_spe_pmu.h            |  1 +
 9 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index a29f8fbc16a8..a5477cae7d70 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -151,10 +151,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78      | #3031174        | ARM64_ERRATUM_3023823       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A78      | #2004055        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78AE    | #4193793        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78AE    | #3031175        | ARM64_ERRATUM_3023823       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A78AE    | #2004059        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78C     | #3324346,       | ARM64_ERRATUM_3194386       |
 |                |                 | #3324347        |                             |
 +----------------+-----------------+-----------------+-----------------------------+
@@ -163,6 +167,8 @@ stable kernels.
 | ARM            | Cortex-A78C     | #3031176,       | ARM64_ERRATUM_3023823       |
 |                |                 | #3031177        |                             |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A78C     | #2004056        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
@@ -189,12 +195,16 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #3031174        | ARM64_ERRATUM_3023823       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X1       | #2004055        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1C      | #3324346        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1C      | #4193792        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1C      | #3031176        | ARM64_ERRATUM_3023823       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X1C      | #2004056        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X2       | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X2       | #2224489        | ARM64_ERRATUM_2224489       |
@@ -233,6 +243,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #3023823        | ARM64_ERRATUM_3023823       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-N1     | #1978083        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #2139208        | ARM64_ERRATUM_2139208       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #2067961        | ARM64_ERRATUM_2067961       |
@@ -255,6 +267,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #3028884        | ARM64_ERRATUM_3023823       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-V1     | #1978082        | ARM64_ERRATUM_2004055       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V2     | #3324336        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V2     | #4193787        | ARM64_ERRATUM_4118414       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ca6759d16d27..d9b27ee90ab5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1494,6 +1494,31 @@ config ARM64_ERRATUM_3023823
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2004055
+	bool "Incorrect programming of PMBPTR_EL1 might result in a deadlock"
+	depends on KVM_ARM_SPE
+	default y
+	help
+	  This option adds a workaround for the following errata:
+
+	  * ARM Neoverse-N1 erratum 1978083
+	  * ARM Neoverse-V1 erratum 1978082
+	  * ARM Cortex-X1 erratum 2004055
+	  * ARM Cortex-X1C erratum 2004056
+	  * ARM Cortex-A78 erratum 2004055
+	  * ARM Cortex-A78AE erratum 2004059
+	  * ARM Cortex-A78C errata 2004056
+
+	  When PMBPTR_EL1 is programmed to be equal to or greater than
+	  PMBLIMITR_EL1.Limit, SPE is enabled and PMBSR_EL1.S is zero, the CPU
+	  might deadlock.
+
+	  The work around is for KVM to behave as if profiling is disabled when
+	  the buffer is enabled, PMSBSR_EL1.S is zero and
+	  PMBPTR_EL1.PTR >= PMBLIMITR_EL1.Limit.
+
+	  If unsure, say Y.
+
 endmenu # "ARM errata workarounds via the alternatives framework"
 
 choice
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 385b1157e578..88f8b1bb6864 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -23,6 +23,7 @@ struct kvm_vcpu_spe {
 	int irq_num;		/* Buffer management interrupt number */
 	bool initialized;	/* SPE initialized for the VCPU */
 	bool irq_level;		/* Virtual buffer management interrupt level */
+	bool buffer_misprogrammed;
 };
 
 bool kvm_supports_spe(void);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ab0558fbd5b2..0b9620893763 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -648,6 +648,25 @@ static const struct midr_range erratum_3023823_list[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_2004055
+static const struct midr_range erratum_2004055_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+	/* Neoverse-V1 r0p0 to r1p1 */
+	MIDR_RANGE(MIDR_NEOVERSE_V1, 0, 0, 1, 1),
+	/* Cortex-X1 r0p0 to r1p1 */
+	MIDR_RANGE(MIDR_CORTEX_X1, 0, 0, 1, 1),
+	/* Cortex-X1 r0p0 */
+	MIDR_REV(MIDR_CORTEX_X1C, 0, 0),
+	/* Cortex-A78 r0p0 to r1p1 */
+	MIDR_RANGE(MIDR_CORTEX_A78, 0, 0, 1, 1),
+	/* Cortex-A78 r0p0 to r1p1 */
+	MIDR_RANGE(MIDR_CORTEX_A78AE, 0, 0, 0, 1),
+	/* Cortex-A78C r0p0 */
+	MIDR_REV(MIDR_CORTEX_A78C, 0, 0),
+	{},
+};
+#endif
+
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
 static const struct midr_range erratum_ac03_cpu_38_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
@@ -1012,6 +1031,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(erratum_3023823_list),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2004055
+	{
+		.desc = "Incorrect programming of PMBPTR_EL1 leads to deadlock",
+		.capability = ARM64_WORKAROUND_2004055,
+		ERRATA_MIDR_RANGE_LIST(erratum_2004055_list),
+	},
+#endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	{
 		.desc = "ARM errata 2966298, 3117295",
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
index df35025db19a..ec991f4cc348 100644
--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -112,7 +112,8 @@ void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_con
 
 	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
 	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
-	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
+	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr) &&
+	    !vcpu->arch.vcpu_spe.buffer_misprogrammed) {
 		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
 		isb();
 		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
@@ -150,7 +151,8 @@ void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_contex
 	 * Update PMBPTR_EL1 and PMBSR_EL1 only if profiling was enabled
 	 * when the guest state was resumed.
 	 */
-	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
+	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr) &&
+	    !vcpu->arch.vcpu_spe.buffer_misprogrammed) {
 		psb_csync();
 		dsb(nsh);
 		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 3e82edc8be85..ef138562f939 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -170,6 +170,25 @@ u64 kvm_spe_reset_sysreg(struct kvm_vcpu *vcpu, int reg)
 	return 0;
 }
 
+static void kvm_spe_apply_workaround_2004055(struct kvm_vcpu *vcpu)
+{
+	u64 pmblimitr_el1 = __vcpu_sys_reg(vcpu, PMBLIMITR_EL1);
+	u64 pmbsr_el1 = __vcpu_sys_reg(vcpu, PMBSR_EL1);
+	u64 ptr, limit;
+
+	if (FIELD_GET(PMBSR_EL1_S, pmbsr_el1) ||
+	    !FIELD_GET(PMBLIMITR_EL1_E, pmblimitr_el1))
+		return;
+
+	ptr = FIELD_GET(PMBPTR_EL1_PTR, __vcpu_sys_reg(vcpu, PMBPTR_EL1));
+	limit = FIELD_GET(PMBLIMITR_EL1_LIMIT, pmblimitr_el1) << 12;
+
+	if (ptr >= limit)
+		vcpu->arch.vcpu_spe.buffer_misprogrammed = true;
+	else
+		vcpu->arch.vcpu_spe.buffer_misprogrammed = false;
+}
+
 bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
 	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
@@ -186,6 +205,9 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 		WARN_ON_ONCE("unexpected trap");
 	}
 
+	if (unlikely(kvm_spe->spe_pmu->has_workaround_2004055))
+		kvm_spe_apply_workaround_2004055(vcpu);
+
 	if (reg == PMBSR_EL1) {
 		val = __vcpu_sys_reg(vcpu, PMBSR_EL1);
 		kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, val));
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 5f997851b6d7..e001a6ea5564 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -133,3 +133,4 @@ WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
 WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 WORKAROUND_3023823
+WORKAROUND_2004055
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 928ea94f2ed6..bca8cd3bca16 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1201,6 +1201,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
 	if (this_cpu_has_cap(ARM64_WORKAROUND_3023823))
 		spe_pmu->has_workaround_3023823 = true;
 
+	if (this_cpu_has_cap(ARM64_WORKAROUND_2004055))
+		spe_pmu->has_workaround_2004055 = true;
+
 	dev_info(dev,
 		 "probed SPEv1.%d for CPUs %*pbl [max_record_sz %u, align %u, features 0x%llx]\n",
 		 spe_pmu->pmsver - 1, cpumask_pr_args(&spe_pmu->supported_cpus),
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index edf58c51fb94..d5c510ebf785 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -46,6 +46,7 @@ struct arm_spe_pmu {
 	u16					align;
 	struct perf_output_handle __percpu	*handle;
 	bool					has_workaround_3023823;
+	bool					has_workaround_2004055;
 };
 
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
-- 
2.43.0

