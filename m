Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C454EA367
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451644; cv=none; b=hjKDdnsS7+otcBUBYG1HCUITO0yaTxBe0oP1949UQ3yJUlcfX45bYKW5ApWGzZ6rdxYgBw1FoIv3K6RUW1hb8QTo7vswlu6+xxa49QmCRNygSelHjb8rCvPp1KfW3cOUngON3qoCGOGI7EYRkUCCRgUz/dyJQs5HtJr8GS9fiYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451644; c=relaxed/simple;
	bh=4IEJ144fzXWXHjcCYOt3AJGUGmmN9rpuQkgTY8FhFP8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV43DCdjOvaZgOcmZHUttSPptxRcDCSw7U1r2+3dj8k2jS/wOdY/qdrfH6B4srUSo9GK9zSy243mx9yYqSKP1dy5hTmbZEValC9NEvFSKJpMjZV1qJLp8mXHDo/9WTtczKJVaUCvCJbB4G21FJNv4UgZXivIDBAXA4YhRHB+WSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lYAfwlUs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lYAfwlUs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3BA01650;
	Thu,  3 Sep 2026 09:07:17 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97DC73F673;
	Thu,  3 Sep 2026 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451641; bh=4IEJ144fzXWXHjcCYOt3AJGUGmmN9rpuQkgTY8FhFP8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lYAfwlUsXprb0hDzwluAc+yjCGXy4LHh+d1ET3lNV2jPtHiKrBFChSfDACkQLQMW5
	 g1+G/I8z3um5G9MLPC3cYOl84trDgwk0lmm3tRVAFReRclds/4iVDMMyMaHcCkrFhE
	 q09ZniT9zgaKCYTxr/k1Dp1RaOscGGj52NP/PUgA=
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
Subject: [RFC PATCH v7 22/28] arm64: errata: Disable SPE in KVM
Date: Thu,  3 Sep 2026 17:06:17 +0100
Message-ID: <20260903160623.315525-23-alexandru.elisei@arm.com>
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

When stage 1 is enabled and buffer virtual address VA is mapped as
read-only, and hardware dirty bit management is disabled at stage 1 and
stage 2, if stage 2 is enabled, SPE might write to address VA instead of
generating a fault.

This doesn't affect the SPE driver when running on baremetal, since the
memory is mapped at stage 1 with write permissions.

KVM does not use hardware dirty bit management and this erratum allows a
guest to write to read-only memory as long as that address is mapped at
stage 2.

Since KVM allows userspace to use SPE on heterogenous systems, where there
might be different SPE instances, tie the workaround to a particular SPE
instance and do not allow userspace to use that instance when it is
affected.

Several parts are affected:

* ARM Neoverse-N1 (MP050), SDEN v35, erratum 3023823
  https://support.arm.com/documentation/SDEN-885747/35-0
* ARM Neoverse-N2 (MP128), SDEN v21, erratum 3031178
  https://support.arm.com/documentation/SDEN-1982442/21-0
* ARM Neoverse-V1 (MP076), SDEN v23, erratum 3028884
  https://support.arm.com/documentation/SDEN-1401781/23-0
* ARM Neoverse-V2 (MP158), SDEN v13, erratum 3031173
  https://support.arm.com/documentation/SDEN-2332927/13-0
* ARM Cortex-A78 (MP102), SDEN v25, erratum 3031174
  https://support.arm.com/documentation/SDEN-1401784/25-0
* ARM Cortex-A78C:
    * MP138: SDEN v20, erratum 3031176
      https://support.arm.com/documentation/SDEN-1707916/20-0
    * MP154: SDEN v14, erratum 3031177
      https://support.arm.com/documentation/SDEN-2004089/14-0
* ARM Cortex-A78AE (MP105), SDEN v22, erratum 3031175
  https://support.arm.com/documentation/SDEN-1707912/22-0
* ARM Cortex-X1 (MP077), SDEN v25, erratum 3031174
  https://support.arm.com/documentation/SDEN-1401782/25-0
* ARM Cortex-X1C (MP136), SDEN v20, erratum 3031176
  https://support.arm.com/documentation/SDEN-1707914/20-0
* ARM Cortex-X3 (MP141), SDEN v18, erratum 3022726
  https://support.arm.com/documentation/SDEN-2055130/18-0
* ARM Cortex-X4 (MP161), SDEN v13, erratum 3022725
  https://support.arm.com/documentation/109148/13-0

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/arch/arm64/silicon-errata.rst | 23 ++++++++++++++++
 arch/arm64/Kconfig                          | 30 +++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              | 25 +++++++++++++++++
 arch/arm64/kvm/Kconfig                      |  1 +
 arch/arm64/kvm/spe.c                        |  3 +++
 arch/arm64/tools/cpucaps                    |  1 +
 drivers/perf/arm_spe_pmu.c                  |  3 +++
 include/linux/perf/arm_spe_pmu.h            |  1 +
 8 files changed, 87 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index ac3248b9f2f3..a29f8fbc16a8 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -149,13 +149,20 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78      | #4193791        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A78      | #3031174        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78AE    | #4193793        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A78AE    | #3031175        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78C     | #3324346,       | ARM64_ERRATUM_3194386       |
 |                |                 | #3324347        |                             |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A78C     | #4193794        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A78C     | #3031176,       | ARM64_ERRATUM_3023823       |
+|                |                 | #3031177        |                             |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
@@ -180,10 +187,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #4193791        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X1       | #3031174        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1C      | #3324346        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1C      | #4193792        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X1C      | #3031176        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X2       | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X2       | #2224489        | ARM64_ERRATUM_2224489       |
@@ -196,10 +207,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X3       | #4193786        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X3       | #3022726        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X4       | #3194386        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X4       | #4118414        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-X4       | #3022725        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X925     | #3324334        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X925     | #4193781        | ARM64_ERRATUM_4118414       |
@@ -216,6 +231,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #4193800        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-N1     | #3023823        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #2139208        | ARM64_ERRATUM_2139208       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #2067961        | ARM64_ERRATUM_2067961       |
@@ -226,6 +243,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #4193789        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-N2     | #3031178        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N3     | #3456111        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #1619801        | N/A                         |
@@ -234,10 +253,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #4193790        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-V1     | #3028884        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V2     | #3324336        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V2     | #4193787        | ARM64_ERRATUM_4118414       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-V2     | #3031173        | ARM64_ERRATUM_3023823       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V3     | #4193784        | ARM64_ERRATUM_4118414       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..ca6759d16d27 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1464,6 +1464,36 @@ config SOCIONEXT_SYNQUACER_PREITS
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_3023823
+	bool "SPE might write to pages which lack write permission at Stage-1 or Stage-2"
+	depends on KVM_ARM_SPE
+	default y
+	help
+	  This option adds a workaround for the following errata:
+
+	  * ARM Neoverse-N1 erratum 3023823
+	  * ARM Neoverse-N2 erratum 3031178
+	  * ARM Neoverse-V1 erratum 3028884
+	  * ARM Neoverse-V2 erratum 3031173
+	  * ARM Cortex-A78 erratum 3031174
+	  * ARM Cortex-A78C errata 3031176 and 3031177
+	  * ARM Cortex-A78AE erratum 3031175
+	  * ARM Cortex-X1 erratum 3031174
+	  * ARM Cortex-X1C erratum 3031176
+	  * ARM Cortex-X3 erratum 3022726
+	  * ARM Cortex-X4 erratum 3022725
+
+	  When stage 1 is enabled, and stage 2 is either enabled or disabled,
+	  and buffer virtual address VA is mapped as read-only, and hardware
+	  dirty bit management is disabled at stage 1, and stage 2 if stage 2
+	  is enabled, SPE might write to address VA instead of generating a
+	  fault.
+
+	  The work around is to disable SPE for a virtual machine. The host
+	  driver is unaffected.
+
+	  If unsure, say Y.
+
 endmenu # "ARM errata workarounds via the alternatives framework"
 
 choice
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 5db8f0619e4b..ab0558fbd5b2 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -630,6 +630,24 @@ static void cpu_enable_sme_dvmsync(const struct arm64_cpu_capabilities *__unused
 }
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_3023823
+static const struct midr_range erratum_3023823_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_X1C),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_X3),
+	/* Cortex-X4 r0p0 to r0p1 */
+	MIDR_REV_RANGE(MIDR_CORTEX_X4, 0, 0, 1),
+	{},
+};
+#endif
+
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
 static const struct midr_range erratum_ac03_cpu_38_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
@@ -987,6 +1005,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_FIXED(MIDR_CPU_VAR_REV(1, 2), BIT(0)),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_3023823
+	{
+		.desc = "SPE might write to read-only pages",
+		.capability = ARM64_WORKAROUND_3023823,
+		ERRATA_MIDR_RANGE_LIST(erratum_3023823_list),
+	},
+#endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	{
 		.desc = "ARM errata 2966298, 3117295",
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index fece4c02b97c..2bc8e34c538d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -104,6 +104,7 @@ config PKVM_STACKTRACE
 
 endif # NVHE_EL2_DEBUG
 
+
 config KVM_ARM_SPE
 	bool
 	depends on KVM && ARM_SPE_PMU
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 89ebeef1c223..ce68789d184b 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -290,6 +290,9 @@ static int kvm_spe_set_spe_id(struct kvm_vcpu *vcpu, int spe_id)
 		return 0;
 	}
 
+	if (spe_pmu->has_workaround_3023823)
+		return -EINVAL;
+
 	if (!try_module_get(spe_pmu->pmu.module))
 		return -ENXIO;
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 2775ba3359cf..5f997851b6d7 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -132,3 +132,4 @@ WORKAROUND_REPEAT_TLBI_SYNC
 WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
 WORKAROUND_SPECULATIVE_UNPRIV_LOAD
+WORKAROUND_3023823
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index f24b122a087c..928ea94f2ed6 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1198,6 +1198,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
 	write_sysreg_s(U64_MAX, SYS_PMSEVFR_EL1);
 	spe_pmu->pmsevfr_res0 = ~read_sysreg_s(SYS_PMSEVFR_EL1);
 
+	if (this_cpu_has_cap(ARM64_WORKAROUND_3023823))
+		spe_pmu->has_workaround_3023823 = true;
+
 	dev_info(dev,
 		 "probed SPEv1.%d for CPUs %*pbl [max_record_sz %u, align %u, features 0x%llx]\n",
 		 spe_pmu->pmsver - 1, cpumask_pr_args(&spe_pmu->supported_cpus),
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index bdb703558a87..edf58c51fb94 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -45,6 +45,7 @@ struct arm_spe_pmu {
 	u16					max_record_sz;
 	u16					align;
 	struct perf_output_handle __percpu	*handle;
+	bool					has_workaround_3023823;
 };
 
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
-- 
2.43.0

