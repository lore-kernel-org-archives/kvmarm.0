Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F6E3655FE
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 05:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778824142; cv=none; b=S+i0TsOT8Ahumi/ZjNnUXEC0qsPxbwoc45aHcUxW+sZ/XMrgJQZOB3g86tbXh406RukgV+I3nxPlwgjSDatCQtnsiXolOyeX5izdDNeH7SnXYP79JKpedvsjI4vCNBN1L3QGjtxGlFyJ44YbNnJB7QRmD8qwoRuLJaWfZyhU/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778824142; c=relaxed/simple;
	bh=Ua9XP2t8wZs196UuDUJ+sQyVgcH0lmHelOVyZKJC5O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gm3ORENNUFvzb8FViR3GUvL9bbIGm1DHD0DZPwSy0VDxFejvAUEiAOPQJVX0xAKwumdiAvNj1YDw6kw3g+2wA3UO12Rav0IYtvT87nvW6MfAVo3aok6plUUnemhyFKh9d8b0dCPGEl3NjeP0RnSVhBBOejw6xbYA3MaMpyeVkns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hkryT5Xe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hkryT5Xe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F10DF2659;
	Thu, 14 May 2026 22:48:53 -0700 (PDT)
Received: from [10.164.18.66] (unknown [10.164.18.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1A953F85F;
	Thu, 14 May 2026 22:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778824139; bh=Ua9XP2t8wZs196UuDUJ+sQyVgcH0lmHelOVyZKJC5O4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hkryT5XejjE9ee6hMhAaNIq9D1EAk9hbUCvf4K0brgW0h9afmkZvc5b7/DX0aI5PT
	 upitpVHAzTymB4zZDRMiV4H5/kRJGmmawI8/vtmbrkxGJ6xLbfVGNFa8w1UBYY+4/l
	 OUwfh4pWWAbq6KZCj7v5sFIJBCRaqbX7XoaSUsxY=
Message-ID: <f69e9bd0-5991-48e3-87a7-6ce5c39678ef@arm.com>
Date: Fri, 15 May 2026 11:18:53 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Remove @arch from __load_stage2()
To: Zenghui Yu <zenghui.yu@linux.dev>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com
References: <20260318144305.56831-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260318144305.56831-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 18/03/26 8:13 PM, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> Since commit fe49fd940e22 ("KVM: arm64: Move VTCR_EL2 into struct s2_mmu"),
> @arch is no longer required to obtain the per-kvm_s2_mmu vtcr and can be
> removed from __load_stage2().
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/kvm_mmu.h              | 3 +--
>  arch/arm64/kvm/at.c                           | 2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 2 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c              | 2 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c                 | 4 ++--
>  arch/arm64/kvm/hyp/vhe/switch.c               | 2 +-
>  arch/arm64/kvm/hyp/vhe/tlb.c                  | 4 ++--
>  8 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index d968aca0461a..c1e535e3d931 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -318,8 +318,7 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
>   * Must be called from hyp code running at EL2 with an updated VTTBR
>   * and interrupts disabled.
>   */
> -static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
> -					  struct kvm_arch *arch)
> +static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu)
>  {
>  	write_sysreg(mmu->vtcr, vtcr_el2);
>  	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index a024d9a770dc..3b61da0a24d8 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1379,7 +1379,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  		}
>  	}
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
> -	__load_stage2(mmu, mmu->arch);
> +	__load_stage2(mmu);
>  
>  skip_mmu_switch:
>  	/* Temporarily switch back to guest context */
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 5f9d56754e39..803961cdd39e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -63,7 +63,7 @@ int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
>  static __always_inline void __load_host_stage2(void)
>  {
>  	if (static_branch_likely(&kvm_protected_mode_initialized))
> -		__load_stage2(&host_mmu.arch.mmu, &host_mmu.arch);
> +		__load_stage2(&host_mmu.arch.mmu);
>  	else
>  		write_sysreg(0, vttbr_el2);
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d815265bd374..87a169838481 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -336,7 +336,7 @@ int __pkvm_prot_finalize(void)
>  	kvm_flush_dcache_to_poc(params, sizeof(*params));
>  
>  	write_sysreg_hcr(params->hcr_el2);
> -	__load_stage2(&host_mmu.arch.mmu, &host_mmu.arch);
> +	__load_stage2(&host_mmu.arch.mmu);
>  
>  	/*
>  	 * Make sure to have an ISB before the TLB maintenance below but only
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 779089e42681..3938997e7963 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -299,7 +299,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	__sysreg_restore_state_nvhe(guest_ctxt);
>  
>  	mmu = kern_hyp_va(vcpu->arch.hw_mmu);
> -	__load_stage2(mmu, kern_hyp_va(mmu->arch));
> +	__load_stage2(mmu);
>  	__activate_traps(vcpu);
>  
>  	__hyp_vgic_restore_state(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index 3dc1ce0d27fe..01226a5168d2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -110,7 +110,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
>  	if (vcpu)
>  		__load_host_stage2();
>  	else
> -		__load_stage2(mmu, kern_hyp_va(mmu->arch));
> +		__load_stage2(mmu);
>  
>  	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
>  }
> @@ -128,7 +128,7 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
>  		return;
>  
>  	if (vcpu)
> -		__load_stage2(mmu, kern_hyp_va(mmu->arch));
> +		__load_stage2(mmu);
>  	else
>  		__load_host_stage2();
>  
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 9db3f11a4754..bc8090d915bf 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -219,7 +219,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  
>  	__vcpu_load_switch_sysregs(vcpu);
>  	__vcpu_load_activate_traps(vcpu);
> -	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
> +	__load_stage2(vcpu->arch.hw_mmu);
>  }
>  
>  void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index 35855dadfb1b..539e44d09f17 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -60,7 +60,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
>  	 * place before clearing TGE. __load_stage2() already
>  	 * has an ISB in order to deal with this.
>  	 */
> -	__load_stage2(mmu, mmu->arch);
> +	__load_stage2(mmu);
>  	val = read_sysreg(hcr_el2);
>  	val &= ~HCR_TGE;
>  	write_sysreg_hcr(val);
> @@ -78,7 +78,7 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
>  
>  	/* ... and the stage-2 MMU context that we switched away from */
>  	if (cxt->mmu)
> -		__load_stage2(cxt->mmu, cxt->mmu->arch);
> +		__load_stage2(cxt->mmu);
>  
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
>  		/* Restore the registers to what they were */

