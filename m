Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1293E1208;
	Wed, 22 Jul 2026 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710415; cv=none; b=BXF2zunqXzZOjr966tNo7h7alaUwXBXiiOXc/0QLnhsTn+5MEesdlL2kbl0csLng37eWPQ+pOkfP8bACz07pbfq11d4o31rpqVGZ/2AazuPTVp0WKndxLvN9FnEHB4tJ8mQkNoBJ52kDJKLZOFaMhBcTGRWLKnV+2zLdQei2l7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710415; c=relaxed/simple;
	bh=K2mBNhpIojBIGiCwntqL4sDcaEX0nTyKrwnSMiGgZDU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r8X8Fck9/WrbVbsRRw4CyerbUWO38Rzdq+c4ki6LXAc94X6BrF94dUShmNHOWOC/GPuQBc2IfkCrE9jysIlBHOuo5pdvLqKLJQ2Mf33zfclyyIulqIJmc2J4LVI+YntrKhYiFy8NVClBlEyHf0KAH1TzZovfqkQFCfewjIuWLDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja28jcrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja28jcrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34C61F000E9;
	Wed, 22 Jul 2026 08:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710412;
	bh=zHnIZ5x0e8dLWEJoiNcqiC0ZghN/alePQiSbHnnslv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ja28jcrU7fnOJAueHdg8r2hpv9dVnTsFRGAZcCnz9f0z7jXTOsr3/b7tfbC2I1LRo
	 YRty/HzszqFo9qXvx6CmeTyVFD5POfL0VJmqifn4rdnCbZ6FV5u3Jm+92v4M5s9L2r
	 iBHBPeJmXJJRx9A2Ms08vJmq6tcXvUTw/5AQPYlAJZ9OM7trZWWQoNj9j7w/QmpE/G
	 cfR8qvxV4LUdZUN+3qDbH6U0jW9ar5TDSV/QtN9Ztd652KvhG9HcYD8Q1xgv7VMTBP
	 5sdOzz4NJYgwXoziE5LTrJRDTSBHhuNXMclLhNQkcj7LP+zGVVn3rASyzT0VqkxAMN
	 d+jg3HoXuLfZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/28] KVM: arm64: Add FEAT_NV3 detection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260722074234.3330999-27-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-27-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:53:31 +0000
Message-Id: <20260722085331.E34C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM's FEAT_NV3 fast-path evaluates to false for all guests, causin=
g stale SYS_NVHCR_EL2 state during L2 nested entry.
- [High] Writes to SYS_NVHCR_EL2 lack required immediate Context Synchroniz=
ation Event (ISB).
--

--- Patch [26]: [PATCH v3 26/28] KVM: arm64: Add FEAT_NV3 detection ---
commit e5daceb215a787136ab61f9dafcd9ffe40f4346c
Author: Marc Zyngier <maz@kernel.org>
   =20
    KVM: arm64: Add FEAT_NV3 detection

This commit adds the FEAT_NV3 detection code to cpufeature.c by introducing
the ARM64_HAS_NV3 capability. It engages the FEAT_NV3 fast-path in KVM now
that the infrastructure is in place.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index c9c124b0ccc8e..6ae1c816e2010 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_f=
eatures[] =3D {
>  		.matches =3D has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
>  	},
> +	{
> +		.desc =3D "FEAT_NV3",
> +		.capability =3D ARM64_HAS_NV3,

[Severity: High]
Could engaging this capability break nested virtualization on NV3 hardware?

By enabling ARM64_HAS_NV3, the fast-path checks now depend on kvm_has_nv3(),
which appears to require the guest to advertise NV3:

arch/arm64/include/asm/kvm_emulate.h:kvm_has_nv3() {
    return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
            cpus_have_final_cap(ARM64_HAS_NV3) &&
            kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV3));
}

Since NV3 is explicitly hidden from guests (ID_AA64MMFR4_EL1.NV_frac is cap=
ped
at NV2P1), won't kvm_has_feat() always evaluate to false?

This would cause is_nested_nv3_ctxt() to always return false, skipping the
SYS_NVHCR_EL2 restore in L2 nested entry:

arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h:__sysreg_restore_el1_state() {
    ...
    if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
        write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
    ...
}

Will the physical CPU execute the L2 guest using an uninitialized or stale
SYS_NVHCR_EL2 value?

[Severity: High]
Are there missing context synchronization events in this new fast-path?

When ARM64_HAS_NV3 is enabled, the code writes to the control-plane system
register SYS_NVHCR_EL2 without an immediate isb():

arch/arm64/kvm/hyp/vhe/switch.c:__compute_hcr() {
    if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
        write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);
    else
        __vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2=
));

    /* No ISB here */
    guest_hcr =3D kvm_vcpu_apply_reg_masks(vcpu, HCR_EL2, 0);
    ...
}

It also happens during state restore before returning:

arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h:__sysreg_restore_el1_state() {
    ...
    if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
        write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
}
/* No ISB before return */

Since SYS_NVHCR_EL2 is a control-plane register, doesn't it require an isb()
as the very next instruction to prevent the CPU from executing subsequent
instructions with undefined pipeline state?

> +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches =3D has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV3)
> +	},
>  	{
>  		.capability =3D ARM64_HAS_32BIT_EL0_DO_NOT_USE,
>  		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D26
