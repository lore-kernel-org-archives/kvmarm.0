Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3A237B030;
	Thu,  1 Oct 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872010; cv=none; b=Rccu06ZOcFO2s+YtJpisvrCNzEr5CR9Oa5496Dx2z2uoyk98CuOc0XsLGT/lTKjNOB7kC2LqCE7ZAhTvP4GCMjvYWi0NxAJzWWLkxzl/BWR5AcX2p9HXwUKiMfIDoIP9U/809zxqr+hmMR+ZsLbdUQBXeK21znGj+7AVrI+Xcqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872010; c=relaxed/simple;
	bh=hB5jHJcHH8DbO6XMsvsWp4cAYbLvk+aXuCc52F/gLQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndTtRAfxTbac467L3AEFsfHFVQIkHhQLKpOV8Y1Zf+bXQZ8O066a72EB1GxQ561+nMA6pvkc7pOmgSivnXOi0zROaK/Dx23bOCcue2FyQnsMtXCuOKQ3T2UYYb1l9rb3uKSAibMRICoV4Uuc4QlhhB07BsJPO0k4L37QSjDUwKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTVTZ2xh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTVTZ2xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8371F000FF;
	Thu,  1 Oct 2026 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872008;
	bh=1RQ6A9H9zmYcR12FE7rJxiFuAniJqyW14LcDrumbshw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FTVTZ2xhitb5tzoc9cZ1wx9CA0ppwSqT+39G0llCzD3lv5uaWQO+2X1p3NTspAaMT
	 JPhanSmuoLLxmSOU4ezAyF3uwd5DdK+jsh2LJ0T1UUP3qUvOITwPza5wK1wuNc/oub
	 0y3w1Np/JFcL91qPpzXJArkSnTARrcLIIigF4z6+c86ADLLcfmXM3gtuKgk5Rcmepo
	 rQ0FLk0a7E6wksQHzUPnRQQ/8uU9K9UPBc08F573OM/dkRCWoHgUngapbg3T5t8jFd
	 zrYONIdTQh6P9VKXaCffwcgRcmXl7jrnE/m+5n39WDPHa1pO4EB52QD7wThy9hnVYe
	 3419sS2GkntSA==
Date: Thu, 1 Oct 2026 17:26:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 08/15] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Message-ID: <ar5thpZI5GiCfVRR@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-8-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260930-arm64-gcs-v21-8-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:18PM +0100, Mark Brown wrote:
> As per I_CFFNS and the pseudocode for the SPSR_ELx and ELR_ELx registers
> a GCS exception with ExType 1 is generated for attempts to write to
> those registers when both GCSCR_ELx.EXLOCKEN and PSTATE.EXLOCK are set.

From [4] I see I_CFFNS is defined as:

"When an MSR instruction would write to the relevant ELR_ELx or SPSR_ELx
for the current Exception level ELy, the Effective value of
GCSCR_ELy.EXLOCKEN and PSTATE.EXLOCK may prevent the write."

So the lock applies to writes to the current EL's own ELR/SPSR rather than
to any ELR_ELx/SPSR_ELx the current EL can write to?

> Ensure that this is enforced for guests if access to these registers
> from the guest is handled by the hypervisor.
>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  8 +++++++
>  arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++++++++++++++++++----
>  2 files changed, 46 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 0cd91b3d6c82..e47ab38327de 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -81,6 +81,14 @@ int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
>  int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
>  int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr);
>
> +static inline void kvm_inject_exlock(struct kvm_vcpu *vcpu)
> +{
> +	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_GCS) | ESR_ELx_IL |
> +		  FIELD_PREP(ESR_ELx_ExType_MASK, ESR_ELx_ExType_EXLOCK);
> +
> +	kvm_inject_sync(vcpu, esr);
> +}
> +
>  static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
>  {
>  	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SVE) |
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 823460106de8..faecf4657ec5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2866,14 +2866,42 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>
> +static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)

So if this returns true, an EXLOCKException is raised, otherwise SPSR_EL1
is set (based on caller below).

From [0] the pseudocode for MSR SPSR_EL1, <Xt> is:

elsif PSTATE.EL == EL2 then
    if IsFeatureImplemented(FEAT_GCS) && GetCurrentEXLOCKEN() && !Halted() && PSTATE.EXLOCK == '1' && ELIsInHost(EL2) then
        EXLOCKException();
    elsif ELIsInHost(EL2) then
        SPSR_EL2() = X{64}(t);
    else
        SPSR_EL1() = X{64}(t);
    end;

Reading [2] and [3], ELIsInHost(EL2) is equivalent to vcpu_el2_e2h_is_set(),
but the code doesn't check this anywhere?

The calling function only ever writes to SPSR_EL1, which implies
!ELIsInHost() (I guess because if it is true the writes are just done
directly to registers?)

But if that's always false, then an exception can never be raised due to
the first condition being false, and then the whole thing collapses to
SPSR_EL1() = X{64}(t).

So PSTATE.EL == EL2 is ~ I gather to is_hyp_ctxt() (guest's view of its own
EL) and thus this would be equivalent to:

if (is_hyp_ctxt())
	return false;

Wouldn't it?

But for the PSTATE.EL == EL1 branch (what the hardware runs for a vEL2
guest), also from [0]:

    if IsFeatureImplemented(FEAT_GCS) && GetCurrentEXLOCKEN() && !Halted() && PSTATE.EXLOCK == '1' && !(EffectiveHCR_EL2_NVx() IN {'x11'}) then
        EXLOCKException();
    elsif IsFeatureImplemented(FEAT_S1POE2) && EffectiveHCR_EL2_NVx() IN {'x11'} && FGDTState.nH == '1' then
        AArch64_FGDTSystemAccessTrap(EL1, 0x18);
    elsif EffectiveHCR_EL2_NVx() == '011' then
        AArch64_SystemAccessTrap(EL2, 0x18);
    elsif EffectiveHCR_EL2_NVx() IN {'111'} then
        NVMem(0x160) = X{64}(t);
    else
        SPSR_EL1() = X{64}(t);
    end;

EffectiveHCR_EL2_NVx() (see [5]) obtains the nested virt configuration
based on HCR flags.

In __compute_hcr():

static u64 __compute_hcr(struct kvm_vcpu *vcpu)
{
	...

	if (is_hyp_ctxt(vcpu)) {
		...
		hcr |= HCR_NV | HCR_NV2 | HCR_AT | HCR_TTLB;
		if (!vcpu_el2_e2h_is_set(vcpu))
			hcr |= HCR_NV1;
		...
	}
	...
}

So for a vEL2 guest this is either '101' (guest E2H=1), or '111' (guest E2H=0).

So that leaves us with:

    if IsFeatureImplemented(FEAT_GCS) && GetCurrentEXLOCKEN() && !Halted() && PSTATE.EXLOCK == '1' && !(EffectiveHCR_EL2_NVx() IN {'x11'}) then
        EXLOCKException();
    elsif EffectiveHCR_EL2_NVx() IN {'111'} then
        NVMem(0x160) = X{64}(t);
    else
        SPSR_EL1() = X{64}(t);

And from include/asm/vncr_mapping.h:

#define VNCR_SPSR_EL1           0x160

So that's the VNCR write that the hardware does.

So for '101' the hardware does the EXLOCK check and the write
itself, for '111' the check is skipped and the write goes to the VNCR page.

In both cases, nothing traps to KVM (only '011', NV1 without NV2 would -
but KVM never configures that as it requires NV2).

So... TL;DR is, shouldn't this function look like:

static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)
{
	if (!kvm_has_gcs(vcpu->kvm))
		return false;

	if (!(vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT))
		return false;

	if (is_hyp_ctxt(vcpu))
		return false;

	return vcpu_read_sys_reg(vcpu, GCSCR_EL1) & GCSCR_ELx_EXLOCKEN;
}

?

> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(vcpu->kvm))
> +		return false;
> +
> +	if (!(vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT))
> +		return false;
> +
> +	/*
> +	 * Note that the EXLOCKEN for the running EL is checked
> +	 * regardless of the register written to.
> +	 */

This seems to contradict [4] - the register written to is what decides
whether the lock applies?

> +	if (is_hyp_ctxt(vcpu))
> +		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL1);

GetCurrentEXLOCKEN() is defined in [1] as:

    ...
    case PSTATE.EL of
	...
        when EL1 =>
            return GCSCR_EL1().EXLOCKEN == ‘1’;
        when EL2 =>
            return GCSCR_EL2().EXLOCKEN == ‘1’;
	...
    end;

And is_hyp_ctxt() -> PSTATE.EL == 2, else -> PSTATE.EL == 1 so this matches up with:

> +
> +	return gcscr & GCSCR_ELx_EXLOCKEN;

Where this is the .EXLOCKEN == '1' bit.

> +}
> +
>  static bool access_elr(struct kvm_vcpu *vcpu,
>  		       struct sys_reg_params *p,
>  		       const struct sys_reg_desc *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (sysregs_exlocked(vcpu)) {
> +			kvm_inject_exlock(vcpu);
> +			return false;
> +		}
> +

(I assume ELR mirrors SPSR but I haven't checked).

>  		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
> -	else
> +	} else {
>  		p->regval = vcpu_read_sys_reg(vcpu, ELR_EL1);
> +	}
>
>  	return true;
>  }
> @@ -2882,10 +2910,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (sysregs_exlocked(vcpu)) {
> +			kvm_inject_exlock(vcpu);
> +			return false;
> +		}
> +
>  		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
> -	else
> +	} else {
>  		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
> +	}
>
>  	return true;
>  }
>
> --
> 2.47.3
>
>

[0]:https://support.arm.com/documentation/111107/2026-09/AArch64-Registers/SPSR-EL1--Saved-Program-Status-Register--EL1-?lang=en
[1]:https://support.arm.com/documentation/ddi0487/md/-Part-J-Architectural-Pseudocode/-Chapter-J1-A-profile-Architecture-Pseudocode/-J1-2-Pseudocode-for-AArch64-operation/-J1-2-267-GetCurrentEXLOCKEN
[2]:https://support.arm.com/documentation/ddi0487/md/-Part-J-Architectural-Pseudocode/-Chapter-J1-A-profile-Architecture-Pseudocode/-J1-4-Shared-pseudocode/-J1-4-552-ELIsInHost?lang=en
[3]:https://support.arm.com/documentation/ddi0487/md/-Part-J-Architectural-Pseudocode/-Chapter-J1-A-profile-Architecture-Pseudocode/-J1-4-Shared-pseudocode/-J1-4-558-EffectiveHCR-EL2-E2H?lang=en
[4]:https://support.arm.com/documentation/ddi0487/md/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D11-The-Guarded-Control-Stack/-D11-4-Exception-returns/-D11-4-1-Pushing-and-popping-exception-return-state?lang=en
[5]:https://support.arm.com/documentation/ddi0487/md/-Part-J-Architectural-Pseudocode/-Chapter-J1-A-profile-Architecture-Pseudocode/-J1-4-Shared-pseudocode/-J1-4-559-EffectiveHCR-EL2-NVx?lang=en

--
Cheers, Lorenzo
