Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C26947B403
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519927; cv=none; b=UVjj2U4w0aC2L0ZhDzGr2vx1OuRkt/5ysHUvDCKXND1ZFqp+IbarPs7WNcAbRUqD0YM79ud8GK+H5Ll3hrMm/rw9TcggFM6cuLWRaD3Z86qlRvaP6q2ihBJrXT7VImr+tLBrW4hgGEHqXZkbtq8YcUOROfxY9qs8i/+7b/xcP14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519927; c=relaxed/simple;
	bh=pS4fc+DWPWj0gMe6msC77y6Fpi4tYZKDlh0OobjR0d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsqtUcBGdJtiJ1skrvUzdaXyFx1Ptf/mpY9OBNk2NADiptk3PVJ2H4RSyLv3+A6J0V8mcCciKwkbsDltYzMyxpK1fvq3MtPOAQTWhNbdxPmIz1PBIVnbQJ6wVBhWpcuADQtEUt440za3jy6JYCOhzb8FbWVf5qvbv3TojujTDB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TOGRuL4m; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TOGRuL4m"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88B4A1A00;
	Wed,  8 Jul 2026 07:12:00 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 984173F7B4;
	Wed,  8 Jul 2026 07:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783519924; bh=pS4fc+DWPWj0gMe6msC77y6Fpi4tYZKDlh0OobjR0d4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TOGRuL4moMpwF+YU4AL5KUA2+6hainzJazOPH9RkMdp+oWnl1nZg9tRtFfmpleidM
	 x07ANFJS81TcNAOB3DgjkugblJrnNtkL8VpClA0PW9jucsRXW6EChV4tZWYzpjqlQY
	 dWlCkFPkPMWDOqWjNB95emNEjSCynj79uIvvReGw=
Date: Wed, 8 Jul 2026 15:11:58 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 23/28] KVM: arm64: Add NVHCR_EL2 context switching
Message-ID: <20260708141158.GA12293@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-24-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-24-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:43PM +0100, Marc Zyngier wrote:
> Since NVHCR_EL2 represents the HCR_EL2 state of the EL1 guest, it
> must be dealt with in some particular way:
> 
> - for a guest in hyp context (an L1 by definition), NVHCR_EL2 directly
>   reflects HCR_EL2 as read and written by the guest itself. It must
>   therefore be eagerly synced back with the emulation code which only
>   knows about HCR_EL2. This is unconditional if NV3 is available on
>   the host.
> 
> - For an L2 guest, NVHCR_EL2 is controlled by the L1 guest, and we
>   just context switch it like any other EL1 register. Yes, EL1, as
>   that's where this thing runs from the PoV of L1. This is conditioned
>   on the guest using NV3.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 11 +++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c            | 10 ++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..c382848d31947 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -172,6 +172,10 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  
>  	if (ctxt_has_sctlr2(ctxt))
>  		ctxt_sys_reg(ctxt, SCTLR2_EL1) = read_sysreg_el1(SYS_SCTLR2);
> +
> +	/* Retrieve L2's HCR_EL2, and save it for future use */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		ctxt_sys_reg(ctxt, NVHCR_EL2) = read_sysreg_s(SYS_NVHCR_EL2);
>  }
>  
>  static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
> @@ -285,6 +289,13 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
>  
>  	if (ctxt_has_sctlr2(ctxt))
>  		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
> +
> +	/*
> +	 * Publish the L2 view of HCR_EL2 to the HW if L1 is using NV3.
> +	 * Otherwise, the data is already in place in the L1's own VNCR.
> +	 */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
>  }
>  
>  /* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 05bcf8bf7f978..c5c06ae41b229 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -71,7 +71,10 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  			hcr |= HCR_NV1;
>  
>  		/* Publish the guest's view of HCR_EL2 to the HW */
> -		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
> +		if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);
> +		else
> +			__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
>  
>  		/*
>  		 * Nothing in HCR_EL2 should impact running in hypervisor
> @@ -565,7 +568,10 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>  		*vcpu_cpsr(vcpu) |= mode;
>  
>  		/* Publish the latest HCR_EL2 to the emulation */
> -		hcr = __vcpu_sys_reg(vcpu, NVHCR_EL2);
> +		hcr = (cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		       vcpu_el2_e2h_is_set(vcpu)) ?
> +			read_sysreg_s(SYS_NVHCR_EL2) :
> +			__vcpu_sys_reg(vcpu, NVHCR_EL2);
>  
>  		__vcpu_assign_sys_reg(vcpu, HCR_EL2, hcr);
>  	}
> -- 
> 2.47.3
> 
