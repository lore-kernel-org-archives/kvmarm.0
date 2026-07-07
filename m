Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82023ED135
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783432526; cv=none; b=LVoWmDB2v9PwepdcHslJEeYHC1ohpGM46CnZiNlAlQZ8+Wz8hXIL249TrC+91vDtOLZpvHgOBembdKhJHdOzLjuRcJ3vsSf0Gpxg00sPPD4XNZVRIF5y6a9v0Joe1csez8t2+FUmfa/B6BqMTRCO2iDHj0GbIf76Cm9mxyTwRK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783432526; c=relaxed/simple;
	bh=ICx3pfpfzRC6B2jMY/97ptCXRIXl9HJdina4SUTaGAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anwIyExbp1yHUwFwfMROLDJPnYNCpTUoPr2VtH4qVkpSZKlO8GSx5RRJ7HJ0tOwfSvSOgMrEOQoVqbEGd4sJo2OcyeSwwgvXtqRTig6Q5brM7BljnHg5LbScyrrKRU+YHTtO5OV/W9VCQFmJVo8D9cqaO+ZW4lSd30IzWXE+rPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=r8of3wY/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="r8of3wY/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC5311A2D;
	Tue,  7 Jul 2026 06:55:19 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CCEDD3F85F;
	Tue,  7 Jul 2026 06:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783432524; bh=ICx3pfpfzRC6B2jMY/97ptCXRIXl9HJdina4SUTaGAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r8of3wY/XjYZJZHOKfxPdd3GPh2MArwl/HPgItGmZ8ELFmveS/0aL84ZcirScE/6l
	 zwmexmBW7XqSC+Sez/ExU6fNBrPDYNBHE1ssBv2Cfu2IogXLmnwYcbRJfOUZvv6EV4
	 Bwi8/2tor3fuOswaAjOycwBcWS5Xg3XHxBI/7z38=
Date: Tue, 7 Jul 2026 14:55:20 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 09/28] KVM: arm64: Relax CPTR_EL2 handling when
 FEAT_NV2p1 is present
Message-ID: <20260707135520.GB922094@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-10-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:29PM +0100, Marc Zyngier wrote:
> With FEAT_NV2P1, it is no longer necessary to trap CPTR_EL2 accesses
> via CPACR_EL1, as CPACR_EL1.TCPAC is guaranteed to be stateful.
> 
> Prevent such trapping and context switch CPACTR_EL1 in NV contexts
> when NV2P1 is present.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
>  arch/arm64/kvm/hyp/vhe/switch.c         | 3 +++
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      | 8 +++++---
>  arch/arm64/kvm/sys_regs.c               | 5 ++++-
>  4 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8e5f492f39086..7b27296c94607 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -108,9 +108,10 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
>  	 * The architecture is a bit crap (what a surprise): an EL2 guest
>  	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
>  	 * as they are RES0 in the guest's view. To work around it, trap the
> -	 * sucker using the very same bit it can't set...
> +	 * sucker using the very same bit it can't set. FEAT_NV2p1 fixes it.
>  	 */
> -	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
> +	if (!cpus_have_final_cap(ARM64_HAS_NV2P1) &&
> +	    vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
>  		val |= CPTR_EL2_TCPAC;
>  
>  	/*
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 3b76e0468317b..361d3f8344dd8 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -441,6 +441,9 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	u64 esr = kvm_vcpu_get_esr(vcpu);
>  	int rt;
>  
> +	if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +		return false;
> +
>  	if (!is_hyp_ctxt(vcpu) || esr_sys64_to_sysreg(esr) != SYS_CPACR_EL1)
>  		return false;
>  
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index be685b63e8cf2..6f0f046e4ca4e 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -42,10 +42,12 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
>  		u64 val;
>  
>  		/*
> -		 * We don't save CPTR_EL2, as accesses to CPACR_EL1
> -		 * are always trapped, ensuring that the in-memory
> -		 * copy is always up-to-date. A small blessing...
> +		 * Without FEAT_NV2p1, we don't save CPTR_EL2, as accesses
> +		 * to CPACR_EL1 are always trapped, ensuring that the
> +		 * in-memory copy is always up-to-date. A small blessing...
>  		 */
> +		if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			__vcpu_assign_sys_reg(vcpu, CPTR_EL2, read_sysreg_el1(SYS_CPACR));
>  		__vcpu_assign_sys_reg(vcpu, SCTLR_EL2,	 read_sysreg_el1(SYS_SCTLR));
>  		__vcpu_assign_sys_reg(vcpu, TTBR0_EL2,	 read_sysreg_el1(SYS_TTBR0));
>  		__vcpu_assign_sys_reg(vcpu, TTBR1_EL2,	 read_sysreg_el1(SYS_TTBR1));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6b47d936efb32..1dfc1f88bec82 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -326,7 +326,10 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
>  			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
>  			return val;
>  		case CPTR_EL2:
> -			return __vcpu_sys_reg(vcpu, reg);
> +			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +				return read_sysreg_el1(SYS_CPACR);
> +			else
> +				return __vcpu_sys_reg(vcpu, reg);
>  		default:
>  			WARN_ON_ONCE(1);
>  		}
> -- 
> 2.47.3
> 
