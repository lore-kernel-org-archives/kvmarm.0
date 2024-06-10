Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF10A1DA23
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 11:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718017819; cv=none; b=rTFFrwi/BUuLAXRtgTowLz1DgWg01gIzge3rHEAa+aQPFo2pzE2jtskzK7spybCjqCfQyfQaEgeAvj2U0VyjVQD4SKQ+nmHyqv06fUC8KAxJ0uPC2RFoGi7oEKQqD6zBvb6w7IYekye0c1a399c6ycxPtRFrQ04NhRmfQ22mCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718017819; c=relaxed/simple;
	bh=t8YAAYThVnVgT7x/11d4Zu4WwbrMMvSN6ZQtxSBGXPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eK5wyfX2B+/FUa5r51zk07KpnyDUlqgJQqLF0OTKICx1e6RAMN8qIQY98u9vlQKL+faTlwWRC4jrX2gJffdMi6T5KiL7MsCxcBCo+YRywzTeuOndUpkbcT9c+yjcFwIkSWJ9l7jONv3KccqEjoeoKQagI+dPZLQ/wIriAwfqpZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C59B312FC;
	Mon, 10 Jun 2024 04:10:41 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E56843F73B;
	Mon, 10 Jun 2024 04:10:13 -0700 (PDT)
Date: Mon, 10 Jun 2024 12:10:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 6/9] KVM: arm64: pmu: Use generated define for
 PMSELR_EL0.SEL access
Message-ID: <ZmbfE_0n65lMxRb1@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-6-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-6-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:31PM -0600, Rob Herring (Arm) wrote:
> ARMV8_PMU_COUNTER_MASK is really a mask for the PMSELR_EL0.SEL register
> field. Make that clear by adding a standard sysreg definition for the
> register, and using it instead.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h |  1 -
>  arch/arm64/kvm/sys_regs.c       | 10 +++++-----
>  arch/arm64/tools/sysreg         |  5 +++++
>  include/linux/perf/arm_pmuv3.h  |  1 -
>  4 files changed, 10 insertions(+), 7 deletions(-)

This looks good to me; I checked the reg values match those in the
latest ARM ARM (ARM DDI 0487K.a pages 9016 to 9018), and they also match
the eixsting values in the kernel. The changes to use the new mask name
and to use SYS_FIELD_GET() all look good to me.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index af3b206fa423..b0d6c33f9ecc 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -403,7 +403,6 @@
>  #define SYS_PMCNTENCLR_EL0		sys_reg(3, 3, 9, 12, 2)
>  #define SYS_PMOVSCLR_EL0		sys_reg(3, 3, 9, 12, 3)
>  #define SYS_PMSWINC_EL0			sys_reg(3, 3, 9, 12, 4)
> -#define SYS_PMSELR_EL0			sys_reg(3, 3, 9, 12, 5)
>  #define SYS_PMCEID0_EL0			sys_reg(3, 3, 9, 12, 6)
>  #define SYS_PMCEID1_EL0			sys_reg(3, 3, 9, 12, 7)
>  #define SYS_PMCCNTR_EL0			sys_reg(3, 3, 9, 13, 0)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 22b45a15d068..f8b5db48ea8a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -880,7 +880,7 @@ static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	reset_unknown(vcpu, r);
> -	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
> +	__vcpu_sys_reg(vcpu, r->reg) &= PMSELR_EL0_SEL_MASK;
>  
>  	return __vcpu_sys_reg(vcpu, r->reg);
>  }
> @@ -972,7 +972,7 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	else
>  		/* return PMSELR.SEL field */
>  		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
> -			    & ARMV8_PMU_COUNTER_MASK;
> +			    & PMSELR_EL0_SEL_MASK;
>  
>  	return true;
>  }
> @@ -1040,8 +1040,8 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
>  			if (pmu_access_event_counter_el0_disabled(vcpu))
>  				return false;
>  
> -			idx = __vcpu_sys_reg(vcpu, PMSELR_EL0)
> -			      & ARMV8_PMU_COUNTER_MASK;
> +			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
> +					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
>  		} else if (r->Op2 == 0) {
>  			/* PMCCNTR_EL0 */
>  			if (pmu_access_cycle_counter_el0_disabled(vcpu))
> @@ -1091,7 +1091,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  
>  	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
>  		/* PMXEVTYPER_EL0 */
> -		idx = __vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
> +		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
>  		reg = PMEVTYPER0_EL0 + idx;
>  	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
>  		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a4c1dd4741a4..231817a379b5 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2153,6 +2153,11 @@ Field	4	P
>  Field	3:0	ALIGN
>  EndSysreg
>  
> +Sysreg	PMSELR_EL0	3	3	9	12	5
> +Res0	63:5
> +Field	4:0	SEL
> +EndSysreg
> +
>  SysregFields	CONTEXTIDR_ELx
>  Res0	63:32
>  Field	31:0	PROCID
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index 46377e134d67..caa09241ad4f 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -7,7 +7,6 @@
>  #define __PERF_ARM_PMUV3_H
>  
>  #define ARMV8_PMU_MAX_COUNTERS	32
> -#define ARMV8_PMU_COUNTER_MASK	(ARMV8_PMU_MAX_COUNTERS - 1)
>  
>  /*
>   * Common architectural and microarchitectural event numbers.
> 
> -- 
> 2.43.0
> 
