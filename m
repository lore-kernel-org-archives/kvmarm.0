Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AB23DD871;
	Tue,  6 Oct 2026 11:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285531; cv=none; b=aD9CjFPrgoomk7NyFeoZ2UsSBOHqqGPzHx/GjOSdzTQyg1RSLKk7HRSzDZTi/2VcZVcF7cWbA7Fya0Gqb2smA80gernItJjq9A3c3bSt74FACHnJyiybomrietviC85j/yEHTg96hJHzAcRVivTQlgqzUZMvfedYDkQ7v9Q5Bmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285531; c=relaxed/simple;
	bh=J0aYmzl4Bca+kxxzx5CT2dAYF56mfLYy3OaN1LrAIjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcvN9KB4s2Px3H2TrhvEZywa7U6iQqR96gjmKrTDqEA9IX3OPxPMn/urxz46cE3uxEKRFdrd5FFdxK4hkXvqST1O8S/ncF2F/hXbV0EvE1cGoNLmT1DX0yHJQmSymeD7IwkW3agzyrOSH/MxWnEcEW5NMMHXSKHLT/XBgdRyy+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RZ5hdLhD; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RZ5hdLhD"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECE121516;
	Tue,  6 Oct 2026 04:18:43 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A908D3F763;
	Tue,  6 Oct 2026 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791285527; bh=J0aYmzl4Bca+kxxzx5CT2dAYF56mfLYy3OaN1LrAIjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZ5hdLhDyybGfQibMShr19Huoc4OLB+eoXXlg7amCRsxzOgV1zt1dFH/S0dhFJkgc
	 rIFYwye7wxuuF+SdCgqKHuV8+tHKURuLoG+OFSMqph64rLv2vaGBHlM7+nTnpwaXg0
	 NO8CPkXvVECFbdhIjvjb8OSJwJynk/APt9d+RyAE=
Date: Tue, 6 Oct 2026 12:18:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <asTZEhzMDs869r_n@arm.com>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>

Hi Peng,

On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
> suffers from a cache coherency issue (ERR050104). The upper bits, above
> bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
> have been incorrectly connected. This causes some TLBI and IC
> maintenance operations exchanged between the A53 and A72 core clusters
> to be corrupted.
> 
> The workaround requires:
> 
>   - Downgrading targeted TLBI operations to broadcast-all variants.
>     Instead of patching the low-level __TLBI_1 macro (which interferes
>     with the REPEAT_TLBI workaround and causes excessive over-
>     invalidation), redirect high-level TLB flush functions
>     (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
>     __flush_tlb_kernel_pgtable) to use VMALLE1IS via static key checks.
> 
>   - Upgrading IC IVAU to IC IALLUIS for both kernel (via ALTERNATIVE in
>     invalidate_icache_by_line) and EL0 userspace (via trap-and-upgrade
>     in user_cache_maint_handler with SCTLR_EL1.UCI=0).
> 
>   - Disabling KVM since correct TLB maintenance cannot be guaranteed
>     for guests.

Do you need virtualisation on such platform? An alternative would be for
the guests to be aware of the erratum as well and use the right TLBI/IC
ops. But you'd also need to upgrade the VMID-aware ops in KVM (unless
the hardware can't work around stage 2 TLBI at all).

>   - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
>     does not support broadcast TLB.
> 
> SoC detection uses devicetree compatible string "fsl,imx8qm" or
> "fsl,imx8qp" since the boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0)
> are not unique to this SoC.

That's fine but I wonder whether your hardware implements the SoC ID
SMCCC. That would come in handy if some future revision fixes the bug.
The DT string doesn't tell you version/revision.

> @@ -580,23 +584,28 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
>  
>  	asid = ASID(mm);
>  
> -	switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
> -	case TLBF_NONE:
> -		__flush_s1_tlb_range_op(vae1is, start, pages, stride,
> -					asid, tlb_level);
> -		break;
> -	case TLBF_NOWALKCACHE:
> -		__flush_s1_tlb_range_op(vale1is, start, pages, stride,
> -					asid, tlb_level);
> -		break;
> -	case TLBF_NOBROADCAST:
> -		/* Combination unused */
> -		BUG();
> -		break;
> -	case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
> -		__flush_s1_tlb_range_op(vale1, start, pages, stride,
> -					asid, tlb_level);
> -		break;
> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_NXP_ERR050104) &&
> +	    !(flags & TLBF_NOBROADCAST)) {
> +		__tlbi(vmalle1is);

This assumes it doesn't run under any hypervisor with HCR_EL2.FB. I
guess that's fine if this erratum renders virtualisation unusable
anyway.

> +	} else {
> +		switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
> +		case TLBF_NONE:
> +			__flush_s1_tlb_range_op(vae1is, start, pages, stride,
> +						asid, tlb_level);
> +			break;
> +		case TLBF_NOWALKCACHE:
> +			__flush_s1_tlb_range_op(vale1is, start, pages, stride,
> +						asid, tlb_level);
> +			break;
> +		case TLBF_NOBROADCAST:
> +			/* Combination unused */
> +			BUG();
> +			break;
> +		case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
> +			__flush_s1_tlb_range_op(vale1, start, pages, stride,
> +						asid, tlb_level);
> +			break;
> +		}
>  	}
>  
>  	if (!(flags & TLBF_NONOTIFY))

[...]

> @@ -200,6 +202,29 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
>  	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
>  }
>  
> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
> +static bool
> +is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	WARN_ON(preemptible());

Not needed for a DT lookup.

> +
> +	return of_machine_is_compatible("fsl,imx8qm") ||
> +		of_machine_is_compatible("fsl,imx8qp");
> +}
> +
> +static void
> +cpu_enable_imx8qm_err050104(const struct arm64_cpu_capabilities *__unused)
> +{
> +	cpu_enable_cache_maint_trap(__unused);
> +
> +	/*
> +	 * TLB maintenance cannot be guaranteed correct for guests, so
> +	 * disable KVM as if kvm-arm.mode=none was passed on the command line.
> +	 */
> +	kvm_force_disabled();
> +}
> +#endif
> +
>  #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
>  	.matches = is_affected_midr_range,			\
>  	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
> @@ -1030,6 +1055,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>  		.matches = has_broken_gic_v3_seis,
>  	},
> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
> +	{
> +		.desc = "NXP erratum ERR050104",
> +		.capability = ARM64_WORKAROUND_NXP_ERR050104,
> +		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
> +		.matches = is_imx8qm_soc,
> +		.cpu_enable = cpu_enable_imx8qm_err050104,
> +	},
> +#endif

There's a precedent with 4311569 to wire up a SoC erratum into the CPU
errata framework. That one is a system wide feature, so only probed once
for the CPUs coming up at boot (though still probed for each late CPUs).
For iMX, you need this turned on early, hence the boot probing. But
calling it a strict boot CPU feature is a bit of a stretch. It also gets
probed on every CPU, unnecessarily.

I think we could do with something like below (maybe as a preparatory
patch). We could also add it to 4311569 even if it changes its scope
from system to boot CPU (the early param is available).

Only compile-tested and haven't tried wiring up your workaround:

-------------------8<-----------------------
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4f04ad82ea34..669f808e379e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -266,6 +266,13 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 #define SCOPE_BOOT_CPU				ARM64_CPUCAP_SCOPE_BOOT_CPU
 #define SCOPE_ALL				ARM64_CPUCAP_SCOPE_MASK
 
+/*
+ * matches() is called only once, when the capability is detected, and the
+ * result applies to all CPUs. Secondary and late CPUs are not checked for
+ * conflicts but cpu_enable() is still called on each of them. It has no
+ * effect on SCOPE_LOCAL_CPU capabilities.
+ */
+#define ARM64_CPUCAP_PROBE_ONCE			((u16)BIT(3))
 /*
  * Is it permitted for a late CPU to have this capability when system
  * hasn't already enabled it ?
@@ -293,6 +300,13 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
  */
 #define ARM64_CPUCAP_LOCAL_CPU_ERRATUM		\
 	(ARM64_CPUCAP_SCOPE_LOCAL_CPU | ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
+/*
+ * SoC (not CPU) errata workarounds. The erratum is probed once on the boot
+ * CPU, before the secondary CPUs are brought up, and no secondary or late CPU
+ * can conflict with it.
+ */
+#define ARM64_CPUCAP_SOC_ERRATUM			\
+	(ARM64_CPUCAP_SCOPE_BOOT_CPU | ARM64_CPUCAP_PROBE_ONCE)
 /*
  * CPU feature detected at boot time based on system-wide value of a
  * feature. It is safe for a late CPU to have this feature even though
@@ -414,6 +428,12 @@ static inline bool cpucap_match_all_early_cpus(const struct arm64_cpu_capabiliti
 	return cap->type & ARM64_CPUCAP_MATCH_ALL_EARLY_CPUS;
 }
 
+static inline bool cpucap_probe_once(const struct arm64_cpu_capabilities *cap)
+{
+	return (cap->type & ARM64_CPUCAP_PROBE_ONCE) &&
+	       !(cap->type & ARM64_CPUCAP_SCOPE_LOCAL_CPU);
+}
+
 /*
  * Generic helper for handling capabilities with multiple (match,enable) pairs
  * of call backs, sharing the same capability bit.
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e0c09402540c..a418e240ccce 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -986,7 +986,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_ERRATUM_4311569
 	{
 		.capability = ARM64_WORKAROUND_4311569,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_SOC_ERRATUM,
 		.matches = need_arm_si_l1_workaround_4311569,
 	},
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 84053f0a8e01..0e4c3de78c1d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3695,8 +3695,11 @@ static void verify_local_cpu_caps(u16 scope_mask)
 		if (!caps || !(caps->type & scope_mask))
 			continue;
 
-		cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
 		system_has_cap = cpus_have_cap(caps->capability);
+		if (cpucap_probe_once(caps))
+			cpu_has_cap = system_has_cap;
+		else
+			cpu_has_cap = caps->matches(caps, SCOPE_LOCAL_CPU);
 
 		if (system_has_cap) {
 			/*
