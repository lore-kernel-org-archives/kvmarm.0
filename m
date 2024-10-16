Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4C520604E
	for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 09:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729071445; cv=none; b=f4jWXufAkWc8wjJ1eOqbDoqjvcuOMjhyv7SC0WjKPTSSHiRrgUn2/bj9V0FjhngemnM18NjSEe9FvspYZHSujQSk+SoGS1enB2efRzaW+LuAXcVkkFo4vOjS5p8Eqch6YHLssoqK9qju7qI9J0x5IRmc0LShVNqXoXk/ZrqcPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729071445; c=relaxed/simple;
	bh=DMdduzklBMbOnU2TBHdpQjl81F9o4dksoyXjfw+yiQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeVREjMhh7oqYD015JdMgYsCz13TaKJNcIS5McA9R1+TXVG06leetXgCIpodI/paJ2nR3X8mnVjKJSSSWdbfiRo+Ew6IIjv5f+53TNWsMGJOkl+89kV/d9CaXEQd7DDc6O4lv7eFuK9m2xKlZJtiD9Hmms5NAk0Nn7NTKKjGRGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98778FEC;
	Wed, 16 Oct 2024 02:37:52 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4338B3F528;
	Wed, 16 Oct 2024 02:37:21 -0700 (PDT)
Date: Wed, 16 Oct 2024 10:37:18 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 06/36] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Message-ID: <Zw-JTojEW5ZXa8R-@raptor>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-7-maz@kernel.org>

Hi Marc,

I'm planning to have a look at (some) of the patches, do you have a timeline for
merging the series? Just so I know what to prioritise.

On Wed, Oct 09, 2024 at 07:59:49PM +0100, Marc Zyngier wrote:
> Accessing CNTHCTL_EL2 is fraught with danger if running with
> HCR_EL2.E2H=1: half of the bits are held in CNTKCTL_EL1, and
> thus can be changed behind our back, while the rest lives
> in the CNTHCTL_EL2 shadow copy that is memory-based.
> 
> Yes, this is a lot of fun!
> 
> Make sure that we merge the two on read access, while we can
> write to CNTKCTL_EL1 in a more straightforward manner.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c    | 28 ++++++++++++++++++++++++++++
>  include/kvm/arm_arch_timer.h |  3 +++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3cd54656a8e2f..932d2fb7a52a0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -157,6 +157,21 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>  		if (!is_hyp_ctxt(vcpu))
>  			goto memory_read;
>  
> +		/*
> +		 * CNTHCTL_EL2 requires some special treatment to
> +		 * account for the bits that can be set via CNTKCTL_EL1.
> +		 */
> +		switch (reg) {
> +		case CNTHCTL_EL2:
> +			if (vcpu_el2_e2h_is_set(vcpu)) {
> +				val = read_sysreg_el1(SYS_CNTKCTL);
> +				val &= CNTKCTL_VALID_BITS;
> +				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> +				return val;
> +			}
> +			break;
> +		}
> +
>  		/*
>  		 * If this register does not have an EL1 counterpart,
>  		 * then read the stored EL2 version.
> @@ -207,6 +222,19 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>  		 */
>  		__vcpu_sys_reg(vcpu, reg) = val;
>  
> +		switch (reg) {
> +		case CNTHCTL_EL2:
> +			/*
> +			 * If E2H=0, CNHTCTL_EL2 is a pure shadow register.
> +			 * Otherwise, some of the bits are backed by
> +			 * CNTKCTL_EL1, while the rest is kept in memory.
> +			 * Yes, this is fun stuff.
> +			 */
> +			if (vcpu_el2_e2h_is_set(vcpu))
> +				write_sysreg_el1(val, SYS_CNTKCTL);

Sorry, but I just can't seem to get my head around why the RES0 bits aren't
cleared. Is KVM relying on the guest to implement Should-Be-Zero-or-Preserved,
as per the RES0 definition?

> +			return;
> +		}
> +
>  		/* No EL1 counterpart? We're done here.? */
>  		if (reg == el1r)
>  			return;
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index c819c5d16613b..fd650a8789b91 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -147,6 +147,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt);
>  void kvm_timer_cpu_up(void);
>  void kvm_timer_cpu_down(void);
>  
> +/* CNTKCTL_EL1 valid bits as of DDI0487J.a */
> +#define CNTKCTL_VALID_BITS	(BIT(17) | GENMASK_ULL(9, 0))

This does match CNTHCTL_EL2_VHE().

Thanks,
Alex

> +
>  static inline bool has_cntpoff(void)
>  {
>  	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
> -- 
> 2.39.2
> 
