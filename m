Received: from out-28.mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4144539B
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 07:01:56 +0000 (UTC)
Date: Thu, 1 Jun 2023 07:01:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685602914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=plr4C16SSJbKZ59AieGvFJiPtYheTw7pGAQ68J2Djz8=;
	b=C7FXcOcqsYSeBr4NAXtbvcxKb0OL0ZNSvL9RHTKGcT4hdyOL9Y32dz6uHpohEy6iOhUg4N
	C72iagtr2eRQ54LHUg0d9WCFov4IiviKD1ws6ZtPU27I3oQo0gQY67+fbdo5IwHqZFVQcj
	RouUPWaFLIDHHGuuKBJm6IF/8r0WJZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 02/17] arm64: Add KVM_HVHE capability and has_hvhe()
 predicate
Message-ID: <ZHhCXm4k9zEOwPtV@linux.dev>
References: <20221020090727.3669908-1-maz@kernel.org>
 <20221020090727.3669908-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020090727.3669908-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 20, 2022 at 10:07:12AM +0100, Marc Zyngier wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a3959e9f7d55..efac89c4c548 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1932,6 +1932,15 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
>  		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
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

> +
>  #ifdef CONFIG_ARM64_PAN
>  static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
>  {
> @@ -2642,6 +2651,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		.cpu_enable = cpu_trap_el0_impdef,
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
> index f1c0347ec31a..cee2be85b89b 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -43,6 +43,7 @@ HAS_TLB_RANGE
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
