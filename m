Received: from out-253.mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953EA6D24
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 19:16:49 +0000 (UTC)
Date: Fri, 9 Dec 2022 17:58:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670608715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IR+jrVVuE0jVnD3pXeex+chn1g7QgKrTqJIzEs1h2fU=;
	b=XgcgOcm1DkOKZUjSCrn+qe9RWw0h2gVpf94YOFQK3dKy2YVyyw5mpkzzmrBhWvop6GONrw
	DU3fcIitfN0dyWC+lATNByCy5EUv/Eud1jWUJOS6SI3hhsXCdsXazyAc7HNBjPmcqpWa4T
	PYcbxNZR+B79FzdVQPOB5jYyuAqIYQU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Message-ID: <Y5N3R+w3GF94hxHa@google.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
 <20221209164446.1972014-2-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209164446.1972014-2-james.clark@arm.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221209175831.JXiCRhohXYoq33Lt--p2DWUpU97NM8zGONs0vbwhRlk@z>

On Fri, Dec 09, 2022 at 04:44:46PM +0000, James Clark wrote:
> ARMV8_PMU_PMCR_N_MASK is an unshifted value which results in the wrong
> reset value for PMCR_EL0, so shift it to fix it.

That's just mean. *_MASK tends to be a shifted mask, although it would
appear that asm/perf_event.h does not follow this convention. Fixing
that would be nice (as I'm sure somebody else will get burned by this),
but for the sake of an immediate fix:

> This fixes the following error when running qemu:
> 
>   $ qemu-system-aarch64 -cpu host -machine type=virt,accel=kvm -kernel ...
> 
>   target/arm/helper.c:1813: pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.
> 
> Fixes: 292e8f149476 ("KVM: arm64: PMU: Simplify PMCR_EL0 reset handling")
> Signed-off-by: James Clark <james.clark@arm.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d5ee52d6bf73..c6cbfe6b854b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -646,7 +646,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  		return;
>  
>  	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N_MASK;
> +	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
>  	if (!kvm_supports_32bit_el0())
>  		pmcr |= ARMV8_PMU_PMCR_LC;
>  
> -- 
> 2.25.1
> 
