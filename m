Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE6E539B
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 07:06:31 +0000 (UTC)
Date: Thu, 1 Jun 2023 07:06:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685603189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x2Nt6+3aPrrBCPPJNnDhYk/w2wITeauWyWODk28dJ+4=;
	b=JqkA2tKMz0xNguxWb5vEZgweCFwZU87nP7JIE5RuH9cT9R6aTKqz+skWNvnCL9xq3Mql+V
	plgPNBtgJ76M8A/IIULJQqxmHKU/CFsrcbI8ZrTJiY185fDJ+343vMaLw6gL5Efhwk8AbR
	gIy/i5+Yrpvs3EY7Ck/11OHPGsCP6A4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 04/17] arm64: Add KVM_HVHE capability and has_hvhe()
 predicate
Message-ID: <ZHhDcIYlAGF4KOK+@linux.dev>
References: <20230526143348.4072074-1-maz@kernel.org>
 <20230526143348.4072074-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143348.4072074-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

I'm an idiot and was responding to v1. Here's the same damn comment, but
on v2!

On Fri, May 26, 2023 at 03:33:35PM +0100, Marc Zyngier wrote:
> Expose a capability keying the hVHE feature as well as a new
> predicate testing it. Nothing is so far using it, and nothing
> is enabling it yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/include/asm/virt.h       |  8 ++++++++
>  arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++++
>  arch/arm64/tools/cpucaps            |  1 +
>  4 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index bc1009890180..3d4b547ae312 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -16,6 +16,7 @@
>  #define cpu_feature(x)		KERNEL_HWCAP_ ## x
>  
>  #define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
> +#define ARM64_SW_FEATURE_OVERRIDE_HVHE		4
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 91029709d133..5f84a87a6a2d 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -145,6 +145,14 @@ static __always_inline bool is_protected_kvm_enabled(void)
>  		return cpus_have_final_cap(ARM64_KVM_PROTECTED_MODE);
>  }
>  
> +static __always_inline bool has_hvhe(void)
> +{
> +	if (is_vhe_hyp_code())
> +		return false;
> +
> +	return cpus_have_final_cap(ARM64_KVM_HVHE);
> +}
> +
>  static inline bool is_hyp_nvhe(void)
>  {
>  	return is_hyp_mode_available() && !is_kernel_in_hyp_mode();
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 2d2b7bb5fa0c..04ef60571b37 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1998,6 +1998,15 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
>  	return true;
>  }
>  
> +static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	u64 val;
> +
> +	val = arm64_sw_feature_override.val & arm64_sw_feature_override.mask;
> +	return cpuid_feature_extract_unsigned_field(val, ARM64_SW_FEATURE_OVERRIDE_HVHE);
> +}

Does this need to test ID_AA64MMFR1_EL1.VH as well? Otherwise I don't
see what would stop us from attempting hVHE on a system with asymmetric
support for VHE, as the software override was only evaluated on the boot
CPU.

>  #ifdef CONFIG_ARM64_PAN
>  static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
>  {
> @@ -2643,6 +2652,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.cpu_enable = cpu_enable_dit,
>  		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
>  	},
> +	{
> +		.desc = "VHE for hypervisor only",
> +		.capability = ARM64_KVM_HVHE,
> +		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
> +		.matches = hvhe_possible,
> +	},
>  	{},
>  };
>  
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 40ba95472594..3c23a55d7c2f 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -47,6 +47,7 @@ HAS_TLB_RANGE
>  HAS_VIRT_HOST_EXTN
>  HAS_WFXT
>  HW_DBM
> +KVM_HVHE
>  KVM_PROTECTED_MODE
>  MISMATCHED_CACHE_TYPE
>  MTE
> -- 
> 2.34.1
> 

-- 
Thanks,
Oliver
