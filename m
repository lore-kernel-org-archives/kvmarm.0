Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5869B1A238F
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733752636; cv=none; b=tyUkcw4tzGnOGO98+NhSevjTpHI5agmakGyzk2L/bozz1Qipf0jvO4VgH/rlThPpGoxbxRg2FVsL8RlvpJYDfOpfzh4OG4yjWrWVQG2lZLODwNTqWdBMogfhKryMYA6svDZ7QUCYUvOUhCgHAjn/AomoRT48JCkGzmaq0fmThC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733752636; c=relaxed/simple;
	bh=2ML88HTGtDovWLV++vT3SjrrYFYW9LNrePxGawQsgZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDlWsU6CSps7CAlmcEkFoHVrUctJbUvFszP4sZCLX2Im5e9Q+m8XF5r7ArQqSjgCKF4SiPPwGsSF6fxJp4QxYyZ8G2JLQgTfblon4WPBWUayCkaztbJ7udSAUix25hZXZIwVutRlF1tMh2q5c5YM9kdhagVr1x9leN/lBt2SyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFC4A339;
	Mon,  9 Dec 2024 05:57:40 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8169E3F720;
	Mon,  9 Dec 2024 05:57:11 -0800 (PST)
Date: Mon, 9 Dec 2024 13:57:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 2/4] arm64/sysreg: Get rid of the TCR2_EL1x SysregFields
Message-ID: <Z1b3NEoIALJYCdL9@J2N7QTR9R3.cambridge.arm.com>
References: <20241207190740.2607673-1-maz@kernel.org>
 <20241207190740.2607673-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207190740.2607673-3-maz@kernel.org>

On Sat, Dec 07, 2024 at 07:07:38PM +0000, Marc Zyngier wrote:
> TCR2_ELx is a pretty bizarre construct, as it is shared between
> TCR2_EL1 and TCR2_EL12. But the latter is obviously only an
> accessor to the former.

Minor nit, but I believe that the first 'TCR2_ELx' here should be
'TCR2_EL1x'.

> In order to make things more consistent, upgrade TCR2_EL1x to
> a full-blown sysreg definition for TCR2_EL1, and describe TCR2_EL12
> as a mapping to TCR2_EL1.
> 
> This results in a couple of minor changes to the actual code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I agree the *_EL1x thins is horrid.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/cpufeature.c | 2 +-
>  arch/arm64/kvm/at.c            | 6 +++---
>  arch/arm64/mm/proc.S           | 5 +++--
>  arch/arm64/tools/sysreg        | 8 ++------
>  4 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 6ce71f444ed84..7712df48758e9 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2376,7 +2376,7 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
>  #ifdef CONFIG_ARM64_POE
>  static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
>  {
> -	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1x_E0POE);
> +	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
>  	sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_E0POE);
>  }
>  #endif
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8c5d7990e5b31..0905b8778a9bb 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -111,7 +111,7 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
>  	case TR_EL10:
>  		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
> -			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
> +			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE);
>  	default:
>  		BUG();
>  	}
> @@ -140,8 +140,8 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
>  		}
>  
>  		val = __vcpu_sys_reg(vcpu, TCR2_EL1);
> -		wi->poe = val & TCR2_EL1x_POE;
> -		wi->e0poe = val & TCR2_EL1x_E0POE;
> +		wi->poe = val & TCR2_EL1_POE;
> +		wi->e0poe = val & TCR2_EL1_E0POE;
>  	}
>  }
>  
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index b8edc5765441e..fb30c8804f87b 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -501,7 +501,7 @@ alternative_else_nop_endif
>  #ifdef CONFIG_ARM64_HAFT
>  	cmp	x9, ID_AA64MMFR1_EL1_HAFDBS_HAFT
>  	b.lt	1f
> -	orr	tcr2, tcr2, TCR2_EL1x_HAFT
> +	orr	tcr2, tcr2, TCR2_EL1_HAFT
>  #endif /* CONFIG_ARM64_HAFT */
>  1:
>  #endif	/* CONFIG_ARM64_HW_AFDBM */
> @@ -532,7 +532,8 @@ alternative_else_nop_endif
>  #undef PTE_MAYBE_NG
>  #undef PTE_MAYBE_SHARED
>  
> -	orr	tcr2, tcr2, TCR2_EL1x_PIE
> +	orr	tcr2, tcr2, TCR2_EL1_PIE
> +	msr	REG_TCR2_EL1, x0
>  
>  .Lskip_indirection:
>  
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index b6846c601df6c..19d137d9c50ed 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2999,7 +2999,7 @@ Sysreg	TTBR1_EL1	3	0	2	0	1
>  Fields	TTBRx_EL1
>  EndSysreg
>  
> -SysregFields	TCR2_EL1x
> +Sysreg	TCR2_EL1	3	0	2	0	3
>  Res0	63:16
>  Field	15	DisCH1
>  Field	14	DisCH0
> @@ -3013,14 +3013,10 @@ Field	3	POE
>  Field	2	E0POE
>  Field	1	PIE
>  Field	0	PnCH
> -EndSysregFields
> -
> -Sysreg	TCR2_EL1	3	0	2	0	3
> -Fields	TCR2_EL1x
>  EndSysreg
>  
>  Sysreg	TCR2_EL12	3	5	2	0	3
> -Fields	TCR2_EL1x
> +Mapping	TCR2_EL1
>  EndSysreg
>  
>  Sysreg	TCR2_EL2	3	4	2	0	3
> -- 
> 2.39.2
> 
