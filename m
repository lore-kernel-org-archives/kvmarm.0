Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E034E75A;
	Tue, 14 Jul 2026 10:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023403; cv=none; b=KgIPKuMcGvZXbZFPZJQ//zPcT6u4fCrUJyIOxAnHHZyN9DMinmD6mQZxKBd5uAQxa4ndYNo3vEcG+WjXcwrOi4CO7lYBtAY/a3ZM1M6fcivVy/KqND+rgCB4q+03KBu6GLre7siBT2gDLp/vlvxGPBEAmMyYsmJ4rVTdub8R5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023403; c=relaxed/simple;
	bh=Nvwan52GrCJOZFS6aOhT1DcTQV+8Ud1p54wP1wi6MEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cn8YSsq2X6BtQpeS7/69uz2jgwcfnHuMkL925IQO+k5loCov0q9lYYCEdwQeIurADYsBkrdoMwicGBq1/9HLgJrsIvDO842eShgeodnkXTCs38xkr+SCDZCsBnL33+qtfcQBbMv5w3Y78IbJxtp5/scvdVk5X9pVsQQTxD7Bi9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hE7ZH2qz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE7ZH2qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ECB1F000E9;
	Tue, 14 Jul 2026 10:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784023401;
	bh=J4YvdXY9iSx4StAaBaVKkGrMNpVbigchAnlPGxvoCu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hE7ZH2qzLvzXAKtDgzwRZ/4fzfkVn/He2mwr3DOBySiFLDTyCS8onOl/gujzYJOL9
	 MiuGfXSFRWZsXcCJVlev95HSZK5J2DT+qTf29IimiNoCHCDMEhnQMiVCLhyf1zb1uA
	 3bzAYGBxhENhnvlWUKF5bDkM05fvjgJiCRBBt/fXqqEWJQglvStKe+iQeKVmcypVHY
	 pedq0htHqzDKTDq0M1cIpWt0CrXBjfZHn6TBd69aX5DGiTxQTTWi5jYhVfLix6FUjU
	 rVc64RrvTpKvndr1JoE+rgkBf4ksXFVAcfrNcSXqKegIIhL8CaCQq5DmgZb5Y7s7T8
	 bO3FZy6PT1Ozw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 23/28] KVM: arm64: Add NVHCR_EL2 context switching
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260714091641.1970822-24-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-24-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 10:03:21 +0000
Message-Id: <20260714100321.99ECB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A guest can leak the SYS_NVHCR_EL2 hardware register state of a pr=
evious vCPU by configuring E2H=3D0 and NVTGE=3D1.
--

--- Patch [23]: [PATCH v2 23/28] KVM: arm64: Add NVHCR_EL2 context switchin=
g ---
commit d9946edce781237514b1a1fe42315834ea75838a
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add NVHCR_EL2 context switching

This commit introduces context switching for the NVHCR_EL2 register to
support nested virtualization. For an L1 guest in hyp context, the register
is eagerly synced with HCR_EL2 emulation. For an L2 guest, it is context
switched as an EL1 register if NV3 is in use.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..c382848d31947 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -172,6 +172,10 @@ static inline void __sysreg_save_el1_state(struct kv=
m_cpu_context *ctxt)
> =20
>  	if (ctxt_has_sctlr2(ctxt))
>  		ctxt_sys_reg(ctxt, SCTLR2_EL1) =3D read_sysreg_el1(SYS_SCTLR2);
> +
> +	/* Retrieve L2's HCR_EL2, and save it for future use */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		ctxt_sys_reg(ctxt, NVHCR_EL2) =3D read_sysreg_s(SYS_NVHCR_EL2);

[Severity: High]
Does this create an asymmetry with how __compute_hcr() initializes the
register?

In __compute_hcr(), the write to SYS_NVHCR_EL2 is gated by an E2H check:

	if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
		write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);

However, this save path relies on is_nested_nv3_ctxt(), which checks NV and
NVTGE but does not verify E2H:

static inline bool is_nested_nv3_ctxt(struct kvm_vcpu *vcpu)
{
	return (has_vhe() && kvm_has_nv3(vcpu->kvm) && is_nested_ctxt(vcpu) &&
		(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
		(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE));
}

If an L1 guest sets HCR_EL2.E2H =3D 0, HCR_EL2.NV =3D 1, and HCRX_EL2.NVTGE=
 =3D 1,
could __compute_hcr() skip writing SYS_NVHCR_EL2 on L1 entry, leaving the
hardware register uninitialized (holding a previous vCPU's state)?

When transitioning to an L2 guest and later preempting, would this save path
evaluate is_nested_nv3_ctxt() as true? Could this cause it to read the
uninitialized SYS_NVHCR_EL2 register and leak the previous vCPU's hardware
state into the guest's context?

>  }

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index ee92f6ad91c2b..e823046d28796 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -71,7 +71,10 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  			hcr |=3D HCR_NV1;
> =20
>  		/* Publish the guest's view of HCR_EL2 to the HW */
> -		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
> +		if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);
> +		else
> +			__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
> =20
>  		/*
>  		 * Nothing in HCR_EL2 should impact running in hypervisor

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D23
