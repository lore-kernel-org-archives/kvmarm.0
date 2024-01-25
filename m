Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659DC3589C
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 11:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706182212; cv=none; b=OAF5xbx20AJ0mvn2rys74gnNNG06UNXysqvfkgsO/Ov9GsmPZCR/mjtBfZY8sOAhBaS9jZzNV4DImwQm85dsEVjD8Syy29iZa6KMp1owd3fKLWEIbfv5i8mkW+yEaWm6AO8CXa6Qcjcu9adbXMaX1jQtDXl4fBEa3o4wrNAlNr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706182212; c=relaxed/simple;
	bh=hudeKIsDVtkxrroz9a47kw4v+vx9N48mdAxmNXvHWVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWQ/1kJqDe65SzE6Dft235NPgAaJ61GFqdak3l6eOU1vvqu4tCLsCznkViI5Kk+zQRGHOHC/Mwvyo40B6CTeS5DQT5/3ZD9AKoJER/ATs786g128kMhbKP2BJTFdMa9jwPH3CFV3yPBDG6Z+SdvIXUhVS9U/w34PmmuC7ks7WYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FFB01FB;
	Thu, 25 Jan 2024 03:30:54 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 448133F73F;
	Thu, 25 Jan 2024 03:30:08 -0800 (PST)
Date: Thu, 25 Jan 2024 11:30:06 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 20/25] KVM: arm64: Streamline save/restore of
 HFG[RW]TR_EL2
Message-ID: <20240125113006.GC1535978@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-21-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-21-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:47PM +0000, Marc Zyngier wrote:
> The way we save/restore HFG[RW]TR_EL2 can now be simplified, and
> the Ampere erratum hack is the only thing that still stands out.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 42 ++++++-------------------
>  1 file changed, 9 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 245f9c1ca666..2d5891518006 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -157,8 +157,6 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> -	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0;
> -	u64 r_val, w_val;
>  
>  	CHECK_FGT_MASKS(HFGRTR_EL2);
>  	CHECK_FGT_MASKS(HFGWTR_EL2);
> @@ -171,34 +169,10 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>  		return;
>  
> -	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
> -	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
> -
> -	/*
> -	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
> -	 */
> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
> -
> -	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> -		compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
> -		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
> -	}
> -
> -	compute_undef_clr_set(vcpu, kvm, HFGRTR_EL2, r_clr, r_set);
> -	compute_undef_clr_set(vcpu, kvm, HFGWTR_EL2, w_clr, w_set);
> -
> -	r_val = __HFGRTR_EL2_nMASK;
> -	r_val |= r_set;
> -	r_val &= ~r_clr;
> -
> -	w_val = __HFGWTR_EL2_nMASK;
> -	w_val |= w_set;
> -	w_val &= ~w_clr;
> -
> -	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
> -	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
> -
> +	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR_EL2);
> +	update_fgt_traps_cs(hctxt, vcpu, kvm, HFGWTR_EL2, 0,
> +			    cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38) ?
> +			    HFGxTR_EL2_TCR_EL1_MASK : 0);
>  	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
>  	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
>  	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
> @@ -223,9 +197,11 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>  		return;
>  
> -	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
> -	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
> -
> +	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR_EL2);
> +	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> +		write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
> +	else
> +		__deactivate_fgt(hctxt, vcpu, kvm, HFGWTR_EL2);
>  	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
>  	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
>  	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
