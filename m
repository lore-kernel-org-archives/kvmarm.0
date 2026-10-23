Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792790555;
	b=V1zTWRKAWalveZVpNzUWN1LglXD9hjdyCQ7wP9313GmnMfCsvFwVX1mJkBmikM+N36L0
	 TveXwYbRqHBuzF30cSPnHjGosKpW+NTVFzO8s2ChkZt0O2GesqP8WxJM3xyzf2OVXg01m
	 JgLaYayBs4z0fw6BG6pWeGmaIRUHD4QHsvsBw83LWw4y2tU0RlW9F5OqAVEy9VkH5C1N0
	 GYxrKF0uAoSKaSB5xc29x673JCk3wt1w5Z4+WGGuqBkC/F0NrxEvlXg1nAtgO3jEhaYNH
	 no4XdCmNlVLpDDF3PxscbDLe4w7WPSaWQXU10MgUbTOKAHcn7+OZuEmumjFLsDMa6NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790555;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yQZdJkrRxo/D+W4Or6vcvXj975b4QVeKPmmL2NpU+n0=;
	b=2B13BT8QQa4P515TwEnSk0dAReZYiRptESevYJVVnieuzu2d9XOAQlg/Qmc3emlD1kE3
	 IBb/2H7tmgvQTQd8kHCAzIacoEIQmE7KYPCudDvofyF7G2InW15iLCtAIGrQ6fhf1sPmM
	 hLyD/fWQ0BJgIYkPYO9DGnwbN3IMfAjR8rxndl0IwffBpX4Ef8iSBniZ8fw/tJQJEG9DZ
	 hWoe7NI6eY+Qpe1BtG+YnKTv5ngohvPkjsu4YIIK3oSQcx10tBaeam+qA0eLUArISBz87
	 /3z47HOckTeTc8d+JnAIrXYagFItr5Wy39EKVQDcw6UHGDQ7vA1m+cbG/tlS83I8KbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cr7aTb7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0E8606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 21:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cr7aTb7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ED11F01825;
	Fri, 23 Oct 2026 21:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792790554;
	bh=yQZdJkrRxo/D+W4Or6vcvXj975b4QVeKPmmL2NpU+n0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cr7aTb7TV5Evs+eTWjvjuQQbzvEwl9pYoSMVeWRwYEbHMjyDbB548cDtGXMtgTBu5
	 8tvODnmcYOqvs74mbxTllU1IHGLNgnIzcmiyidrJBRGPR/Mt2K9BMEjaKhdpgxele9
	 c/QSM7K5akd5EmzJGPDH1hqVK4C82Crq+SYO31tRMT88e6MyFKj14HMNv553ldH1ue
	 nDuJh0RvTkQ3mMud2hrjecuP4BTUOWOLiH9ErhEoqdUCJgVOTTdDlkDBFULw7nSVdk
	 z+qtC4yUKoGtJkyK2Cml58MDi37WrNYeJfKqvvFeCynD6e4xtvmHpY+D0YVC11hb6w
	 IDsHtJXGqUYtg==
Message-ID: <sashiko-outbox-183250@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/28] KVM: arm64: Set Access flag on table
 descriptors at stage-1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261023205610.1044532-23-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
 <20261023205610.1044532-23-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 21:22:33 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: missing kvm_has_tcr2() check in effective_tcr2()
--

commit bcde4120f508adf06668822f4f97b91e98f978ff
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Set Access flag on table descriptors at stage-1

This commit implements FEAT_HAFT stage-1 access flag updates on table
descriptors during software page table walks.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 2ce34af3b9f20..8f1be3af64e88 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -414,6 +414,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struc=
t s1_walk_info *wi,
>  	wi->hd &=3D (wi->regime =3D=3D TR_EL2 ?
>  		  FIELD_GET(TCR_EL2_HD, tcr) :
>  		  FIELD_GET(TCR_HD, tcr));
> +	wi->haft  =3D kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT) &=
& wi->ha &&
> +		    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regime));

[Severity: Medium]
Can this read a stale physical SYS_TCR2_EL12 register value if userspace
disables FEAT_TCR2 (ID_AA64MMFR3_EL1.TCRX =3D 0) while leaving
ID_AA64MMFR1_EL1.HAFDBS set to HAFT?

ID_AA64MMFR1_EL1 and ID_AA64MMFR3_EL1 are independently writable from
userspace via KVM_SET_ONE_REG and are not cross-sanitized in
kvm_vm_finalize_sys_regs(). When kvm_has_tcr2(vcpu->kvm) is false,
ctxt_has_tcrx() returns false in arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h:

static inline bool ctxt_has_tcrx(struct kvm_cpu_context *ctxt)
{
	struct kvm_vcpu *vcpu;

	if (!cpus_have_final_cap(ARM64_HAS_TCR2))
		return false;

	vcpu =3D ctxt_to_vcpu(ctxt);
	return kvm_has_tcr2(kern_hyp_va(vcpu->kvm));
}

As a result, __sysreg_restore_el1_state() and __sysreg_restore_vel2_state()
do not context-switch the physical SYS_TCR2_EL12 register when loading the
vCPU.

However, effective_tcr2() in arch/arm64/kvm/at.c does not check
kvm_has_tcr2(vcpu->kvm):

static u64 effective_tcr2(struct kvm_vcpu *vcpu, enum trans_regime regime)
{
	if (regime =3D=3D TR_EL10) {
		if (vcpu_has_nv(vcpu) &&
		    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En))
			return 0;

		return vcpu_read_sys_reg(vcpu, TCR2_EL1);
	}

	return vcpu_read_sys_reg(vcpu, TCR2_EL2);
}

When setup_s1_walk() runs while SYSREGS_ON_CPU is set (for example, in
TR_EL2/TR_EL20 via handle_at_s1e2() -> __kvm_at_s1e2() -> handle_at_slow() =
->
setup_s1_walk() or kvm_s2_handle_perm_fault() -> __kvm_translate_va() ->
setup_s1_walk(), or for a non-NV guest in TR_EL10 via kvm_inject_sea() ->
inject_abt64() -> __kvm_find_s1_desc_level() -> setup_s1_walk()),
vcpu_read_sys_reg() resolves to read_sr_from_cpu() in
arch/arm64/kvm/sys_regs.c:

	case TCR2_EL1:		val =3D read_sysreg_s(SYS_TCR2_EL12);	break;

This reads whatever SYS_TCR2_EL12 value was left on the physical CPU by a
previous vCPU, which could set wi->haft and cause walk_s1() ->
handle_desc_update() to set PTE_AF on guest stage-1 table descriptors.

Should effective_tcr2() check kvm_has_tcr2(vcpu->kvm) first (similar to
__kvm_at_s1e01_fast() and __effective_sctlr2_bit()), or should setup_s1_wal=
k()
gate wi->haft on kvm_has_tcr2(vcpu->kvm)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023205610.1044=
532-1-oupton@kernel.org?part=3D22
